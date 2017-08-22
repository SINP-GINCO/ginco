<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Form\GincoDataSubmissionType;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\FormType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints\File;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FileFormat;
use Symfony\Component\Validator\Constraints\Type;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Ign\Bundle\OGAMBundle\Controller\IntegrationController as BaseController;

/**
 * @Route("/integration")
 */
class IntegrationController extends BaseController {

	/**
	 * Show the create data submission page.
	 * GINCO: Add a choice for the provider in the form
	 *
	 * @Route("/create-data-submission", name="integration_creation")
	 */
	public function createDataSubmissionAction(Request $request) {
		
		// Get the referer url, and put it in session to redirect to it at the end of the process
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);
		
		$em = $this->get('doctrine.orm.entity_manager');
		
		// Find jddid if given in GET parameters
		$jddId = intval($request->query->get('jddid', 0));
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
		
		// If the model of the jdd has no published datasets, add a flash error message
		// And disable the whole form
		$formDisabled = false;
		if ($jdd != null && $jdd->getModel()
			->getImportDatasets()
			->count() == 0) {
			$this->addFlash('error', 'Integration.Submission.noDatasetsForModel');
			$formDisabled = true;
		}
		$submission = new Submission();
		$form = $this->createForm(new GincoDataSubmissionType(), $submission, array(
			'jdd' => $jdd,
			'default_provider' => $this->getUser()
				->getProvider(),
			'disabled' => $formDisabled
		));
		
		$form->handleRequest($request);
		
		if ($form->isSubmitted() && $form->isValid()) {
			// Add user relationship
			$submission->setUser($this->getUser());
			
			// Add jdd relationship
			// And update jdd "dataUpdatedAt"
			if ($form->has('jddid')) {
				$jddId = $form->get('jddid')->getData();
				$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->findOneById($jddId);
				$submission->setJdd($jdd);
				$jdd->setDataUpdatedAt(new \DateTime());
				$em->merge($jdd);
			}
			
			// writes the submission to the database
			// merge because cascade persist is not set in the entity
			// and get the merged object to access auto-generated id
			$attachedSubmission = $em->merge($submission);
			$em->flush();
			
			// Redirects to page 2 of the form: upload data
			return $this->redirect($this->generateUrl('integration_upload_data', array(
				'id' => $attachedSubmission->getId()
			)));
		}
		
		return $this->render('IgnGincoBundle:Integration:show_create_data_submission.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Validate the data.
	 * Custom: send a notification mail to the connected user
	 *
	 * @Route("/validate-data",name="integration_validate")
	 *
	 * @return Response
	 */
	public function validateDataAction(Request $request) {
		$this->getLogger()->debug('validateDataAction');
		
		// Get the submission Id
		$submissionId = $request->get("submissionId");
		
		// Send the validation request to the integration server
		try {
			$this->get('ogam.integration_service')->validateDataSubmission($submissionId);
		} catch (\Exception $e) {
			$this->getLogger()->error('Error during upload: ' . $e);
			
			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $this->get('translator')
					->trans("An unexpected error occurred.")
			));
		}
		// Get the JDD Metadata Id
		$submissionRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\RawData\Submission', 'raw_data');
		$submission = $submissionRepo->find($submissionId);
		$jddMetadataId = $submission->getJdd()->getField('metadataId');
		
		// -- Send the email
		$siteName = $this->get('ogam.configuration_manager')->getConfig('site_name');
		
		// Files of the submission
		$submissionFiles = $submission->getFiles();
		$fileNames = array();
		foreach ($submissionFiles as $submissionFile) {
			$fileName = basename($submissionFile->getFileName());
			$fileNames[] = $fileName;
		}
		
		// Get recipient, the connected user.
		$user = $this->getUser();
		
		// Title and body:
		$title = (count($fileNames) > 1) ? "Intégration des fichiers " : "Intégration du fichier ";
		$title .= implode($fileNames, ", ");
		
		// -- Attachments
		$reports = $this->get('ginco.submission_service')->getReportsFilenames($submissionId);
		$attachements = array();
		
		// Regenerate sensibility report each time (see #815)
		$this->get('ginco.submission_service')->generateReport($submissionId, "sensibilityReport");
		
		foreach ($reports as $report => $reportPath) {
			// Regenerate report if does not exist
			if (!is_file($reportPath)) {
				$this->getLogger()->error("Report file '$report' does not exist for submission $submissionId");
				return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
					'error' => $this->get('translator')
						->trans("An unexpected error occurred.")
				));
			}
			$attachements[] = $reportPath;
		}
		
		$this->get('app.mail_manager')->sendEmail('IgnGincoBundle:Emails:publication-notification-to-user.html.twig', array(
			'metadata_uuid' => $jddMetadataId,
			'user' => $user,
			'region' => $siteName,
			'filename' => implode($fileNames, ", "),
			'file_number' => count($fileNames)
		), $user->getEmail(), $attachements);
		
		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}
}
