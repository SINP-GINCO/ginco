<?php
namespace Ign\Bundle\GincoBundle\Controller;

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
use Ign\Bundle\GincoBundle\Form\DataSubmissionType;
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
	 *
	 * @Route("/create-data-submission", name="integration_creation")
	 */
	public function createDataSubmissionAction(Request $request) {
		$datasetChoices = $this->getDoctrine()
			->getRepository('OGAMBundle:Metadata\Dataset', 'metadata')
			->getDatasetsForUpload();

		$providerChoices = $this->getDoctrine()
			->getRepository('OGAMBundle:Website\Provider', 'website')
			->findAll();

		$defaultProvider = $this->getUser()->getProvider();

		$formOptions = array(
			'datasetChoices' => $datasetChoices,
			'providerChoices' => $providerChoices,
			'defaultProvider' => $defaultProvider
		);

		$form = $this->createForm(DataSubmissionType::class, null, $formOptions);

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {
			$values = $form->getNormData();
			$dataset = $values['DATASET_ID'];

			$userLogin = $this->getUser()->getLogin();
			$providerId = $values['PROVIDER_ID'];

			$this->get('logger')->debug('userLogin : ' . $userLogin);
			$this->get('logger')->debug('providerId : ' . $providerId->getLabel());

			// Send the create new data submission request to the integration server
			try {
				$submissionId = $this->get('ogam.integration_service')->newDataSubmission($providerId->getId(), $dataset->getId(), $userLogin);
			} catch (\Exception $e) {
				$this->get('logger')->error('Error while creating new data submission : ' . $e);

				return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
					'error' => $e->getMessage()
				));
			}

			$submission = $this->getEntityManger()->getReference('OGAMBundle:RawData\Submission', $submissionId);
			return $this->showUploadDataAction($request, $submission);
		}

		return $this->render('OGAMBundle:Integration:show_create_data_submission.html.twig', array(
			'datasets' => $datasetChoices,
			'form' => $form->createView()
		));
	}

	/**
	 * Build and return the pdata upload form.
	 *
	 * @param bool $showDetail
	 *        	show the list of expected fields in the form (description)
	 * @param bool $model
	 *        	link to a CSV model file
	 * @return Form
	 * @throws Exception
	 */
	protected function getDataUploadForm(Submission $submission, $showDetail = false, $model = false) {
		$fileMaxSize = intval($this->get('ogam.configuration_manager')->getConfig('fileMaxSize', '40')); // MBi
		$geomFieldInFile = false;

		$formBuilder = $this->get('form.factory')
			->createNamedBuilder('datauploadform', FormType::class)
			->setAction($this->generateUrl('integration_validate_upload', array(
			'id' => $submission->getId()
		)));

		// Get the submission object from the database

		$requestedFiles = $submission->getDataset()->getFiles();
		//
		// For each requested file, add a file upload element
		//
		foreach ($requestedFiles as $requestedFile) {
			// Checks if geom unit field is present in the file
			if (!$geomFieldInFile) {
				$fields = $this->getDoctrine()
					->getRepository('OGAMBundle:Metadata\FileField')
					->getFileFields($requestedFile->getFormat());
				foreach ($fields as $field) {
					$unit = $this->getDoctrine()
						->getRepository('OGAMBundle:Metadata\Unit')
						->getUnitFromFileField($field);
					$geomFieldInFile = $geomFieldInFile || $unit[0]['type'] == 'GEOM';
				}
			}
			$translator = $this->get('translator');
			$fileLabel = $translator->trans('IntegrationPage.File') . " '" . $translator->trans($requestedFile->getLabel() . "'");
			$fileelement = $formBuilder->create($requestedFile->getFormat(), FileType::class, array(
				'label' => $fileLabel,
				'block_name' => 'fileformat',
				'constraints' => array(
					new File(array(
						'maxSize' => "${fileMaxSize}Mi"
					))
				)
			));

			$formBuilder->add($fileelement);
		}

		//
		// Add the srid element
		//
		if ($geomFieldInFile) {
			$sridElement = $formBuilder->create('SRID', IntegerType::class, array(
				'label' => $this->get('translator')
					->trans('Spatial reference system (SRID)'),
				'required' => true,
				'constraints' => array(
					new Type(array(
						'type' => 'int'
					)),
					new Length(array(
						'min' => 4,
						'max' => 8
					))
				)
			));

			$formBuilder->add($sridElement);
		}

		$formBuilder->add('submit', SubmitType::class);

		return $formBuilder->getForm();
	}

	/**
	 * @Route("/validate-upload-data/{id}", name="integration_validate_upload")
	 */
	public function validateUploadDataAction(Request $request, Submission $submission) {
		$this->getLogger()->debug('validateUploadDataAction');

		$form = $this->getDataUploadForm($submission);
		$form->handleRequest($request);

		// Check the validity of the POST
		if (!$form->isSubmitted() || !$request->isMethod(Request::METHOD_POST)) {
			$this->get('logger')->debug('form is not a post');
			return $this->redirectToRoute('integration_home');
		}

		// Check the validity of the Form
		if (!$form->isValid()) {
			$this->get('logger')->debug('form is not valid');
			return $this->showUploadDataAction($request, $submission);
		}

		// Get the selected values
		$values = $form->getData();
		if (array_key_exists('SRID', $values)) {
			$srid = $values['SRID'];
		} else {
			// there is no geometric column
			$srid = '0';
		}

		// Get the configuration info
		$configuration = $this->get('ogam.configuration_manager');
		$uploadDir = $configuration->getConfig('uploadDir', '/var/www/html/upload');

		//
		// For each requested file
		//

		$requestedFiles = $submission->getDataset()->getFiles();

		foreach ($requestedFiles as $key => $requestedFile) {
			$file = $form[$requestedFile->getFormat()]->getData();
			// Get the uploaded filename
			$filename = $file->getClientOriginalName();

			// Print it only if it is not an array (ie: nothing has been selected by the user)
			if (!is_array($filename)) {
				$this->getLogger()->debug('uploaded filename ' . $filename);
			}

			// Check that the file is present
			if (empty($file) || !$file->isValid()) {
				$this->getLogger()->debug('File ' . $requestedFile->format . ' is missing, skipping');
				unset($requestedFiles[$key]);
			} else {
				// Move the file to the upload directory on the php server
				$this->getLogger()->debug('move file : ' . $filename);
				$targetPath = $uploadDir . DIRECTORY_SEPARATOR . $submission->getId() . DIRECTORY_SEPARATOR . $requestedFile->getFileType();
				$targetName = $targetPath . DIRECTORY_SEPARATOR . $filename;
				@mkdir($uploadDir . DIRECTORY_SEPARATOR . $submission->getId()); // create the submission dir
				@mkdir($targetPath);

				$file->move($targetPath, $filename);

				$this->getLogger()->debug('renamed to ' . $targetName);
				$requestedFile->filePath = $targetName; // TODO : clean this fake filePath property
			}
		}

		// Send the files to the integration server
		try {
			$providerId = $submission->getProvider()->getId();
			$this->get('ogam.integration_service')->uploadData($submission->getId(), $providerId, $requestedFiles, $srid, false);
		} catch (\Exception $e) {
			$this->get('logger')->error('Error during upload:' . $e, array(
				'exception' => $e
			));
			return $this->render('OGAMBundle:Integration:data_error.html.twig', array(
				'error' => $e->getMessage()
			));
		}

		// Redirect the user to the show plot location page
		// This ensure that the user will not resubmit the data by doing a refresh on the page
		return $this->redirectToRoute('integration_home');
	}
}
