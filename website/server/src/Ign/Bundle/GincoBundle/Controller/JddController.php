<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Doctrine\ORM\EntityManager;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\GincoBundle\Form\GincoJddType;
use Ign\Bundle\OGAMBundle\Entity\Metadata\Dataset;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Ign\Bundle\OGAMBundle\Entity\RawData\Submission;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\FormType;
use Symfony\Component\Form\Extension\Core\Type\SubmitType;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\HttpFoundation\JsonResponse;
use Ign\Bundle\OGAMBundle\Entity\Metadata\FileFormat;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Ign\Bundle\OGAMBundle\Form\DataSubmissionType;
use Symfony\Component\Validator\Constraints\Type;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Ign\Bundle\OGAMBundle\Form\JddType;

/**
 * @Route("/jdd")
 */
class JddController extends Controller {

	/**
	 * Jdd creation page
	 * Ginco customisation: add a field for metadata identifier
	 * Checks, via a service, the xml file on metadata platform, and fills jdd fields with metadata fields
	 *
	 * @Route("/new", name = "jdd_new")
	 */
	public function newAction(Request $request) {

		// Redirect url is integration_home when creating a new jdd, put it in session to redirect to it at the end of the process
		$redirectUrl = $this->generateUrl('integration_home');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);

		$em = $this->get('doctrine.orm.entity_manager');

		// Get the url of the metadata service
		$metadataServiceUrl = $this->get('ogam.configuration_manager')->getConfig('jddMetadataFileDownloadServiceURL');
		// Format the URL to only get prefix
		$endUrl = strpos($metadataServiceUrl, "cadre");
		$metadataServiceUrl = substr($metadataServiceUrl, 0, $endUrl + 6);

		$jdd = new Jdd();
		$form = $this->createForm(new GincoJddType(), $jdd, array(
			// the entity manager used for model choices must be the same as the one used to persist the $jdd entity
			'entity_manager' => $em,
		));

		$form->handleRequest($request);

		// Add a custom step to test validity of the metadata_id, with the metadata service
		$formIsValid = $form->isValid();
		if ($formIsValid) {
			$metadataId = $form->get('metadata_id')->getData();

			// Test if another jdd already exists with this metadataId
			$jddWithSameMetadataId = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array('metadataId' => $metadataId));
			if (count($jddWithSameMetadataId) > 0) {
				$error = new FormError($this->get('translator')->trans(
					'Metadata.Unique',
					array(),
					'validators'
				));
				$form->get('metadata_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {
			// Read the metadata XML file
			$mr = $this->get('ginco.metadata_reader');
			try {
				$fields = $mr->getMetadata($metadataId);
			} catch (MetadataException $e) {
				$error = new FormError($this->get('translator')->trans(
					$e->getMessage(),
					array(),
					'validators'
				));
				$form->get('metadata_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {
			// Add user and provider relationship
			$jdd->setUser($this->getUser());
			$jdd->setProvider($this->getUser()->getProvider());

			// writes the jdd to the database
			// persist won't work (because user and provider are not retrieved via the same entity manager ?)
			// So merge and get the merged object to access auto-generated id
			$attachedJdd = $em->merge($jdd);
			// and we must create the fields for the attched Jdd... beurk !!
			foreach ($fields as $key => $value) {
				$attachedJdd->setField($key, $value);
			}
			$em->flush();

			// Redirects to the new submission form: upload data
			return $this->redirect($this->generateUrl('integration_creation', array('jddid' => $attachedJdd->getId())));
		}

		return $this->render('IgnGincoBundle:Jdd:jdd_new_page.html.twig', array(
			'form' => $form->createView(),
			'metadataUrl' => $metadataServiceUrl,
			'xml' => isset($xml) ? $xml: '',
		));
	}

	/**
	 * Update Metadata for the given jdd
	 * returns JsonResponse true or false
	 * Checks, via a service, the xml file on metadata platform, and fills jdd fields with metadata fields
	 *
	 * @Route("/{id}/update-metadatas", name = "jdd_update_metadatas", requirements={"id": "\d+"})
	 */
	public function updateMetadatas(Request $request, Jdd $jdd) {
		$metadataId = $jdd->getField('metadataId');
		$em = $this->get('doctrine.orm.entity_manager');
		$mr = $this->get('ginco.metadata_reader');
		try {
			// Read the metadata XML file
			$fields = $mr->getMetadata($metadataId);
			$attachedJdd = $em->merge($jdd);
			// Ceate the fields for the attched Jdd
			foreach ($fields as $key => $value) {
				$attachedJdd->setField($key, $value);
			}
			$em->flush();
			$this->addFlash(
				'notice',
				'Jdd.page.metadataUpdateOK'
			);
		} catch (MetadataException $e) {
			$this->addFlash(
				'error',
				'Jdd.page.metadataUpdateError'
			);
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

}
