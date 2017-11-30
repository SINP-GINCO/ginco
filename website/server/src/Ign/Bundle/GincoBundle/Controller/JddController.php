<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\GincoBundle\Form\GincoJddType;
use Ign\Bundle\OGAMBundle\Controller\JddController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/jdd")
 */
class JddController extends BaseController {

	/**
	 * Default action: Show the jdd list page
	 * Ginco customisation: the test for 'Jdd deletable' takes into account if the jdd has active DEEs
	 *
	 * @Route("/all/", name = "all_jdd_list")
	 */
	public function listAllAction() {
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}

		if (!$this->getUser()->isAllowed('MANAGE_DATASETS_OTHER_PROVIDER') || !$this->getUser()->isAllowed('DATA_INTEGRATION')) {
			throw $this->createAccessDeniedException();
		}

		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jddList = $em->getRepository('OGAMBundle:RawData\Jdd')->getActiveJdds();
		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		foreach ($jddList as $jdd) {
			$jdd->trueDeletable = $this->isJddDeletable($jdd);
			foreach ($jdd->getSubmissions() as $submission) {
				foreach ($submission->getFiles() as $file) {
					$file->filenameWithoutExtension = pathinfo($file->getFileName(), PATHINFO_FILENAME);
					$file->filenameExtension = pathinfo($file->getFileName(), PATHINFO_EXTENSION);
				}
			}
			// Add DEE information
			$jdd->dee = $deeRepo->findLastVersionByJdd($jdd);
		}

		return $this->render('OGAMBundle:Jdd:jdd_list_page.html.twig', array(
			'jddList' => $jddList,
			'allJdds' => true
		));
	}

	/**
	 * #1223 : Shows the user jdd list page.
	 *
	 * @Route("/", name = "user_jdd_list")
	 */
	public function listUserAction() {
		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jddList = $em->getRepository('OGAMBundle:RawData\Jdd')->getActiveJdds(null, $this->getUser());
		foreach ($jddList as $jdd) {
			$jdd->trueDeletable = $this->isJddDeletable($jdd);
		}

		return $this->render('OGAMBundle:Jdd:jdd_list_page.html.twig', array(
			'jddList' => $jddList,
			'allJdds' => false
		));
	}

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
			'entity_manager' => $em
		));

		$form->handleRequest($request);

		// Add a custom step to test validity of the metadata_id, with the metadata service
		$formIsValid = $form->isValid();
		if ($formIsValid) {
			$metadataId = $form->get('metadata_id')->getData();

			// Test if another jdd already exists with this metadataId
			$jddWithSameMetadataId = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
				'metadataId' => $metadataId
			));
			if (count($jddWithSameMetadataId) > 0) {
				$error = new FormError($this->get('translator')->trans('Metadata.Unique', array(), 'validators'));
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
				$error = new FormError($this->get('translator')->trans($e->getMessage(), array(), 'validators'));
				$form->get('metadata_id')->addError($error);
				$formIsValid = false;
			}
		}
		if ($formIsValid) {
			// Add user and provider relationship
			$jdd->setUser($this->getUser());
			$jdd->setProvider($this->getUser()
				->getProvider());

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
			return $this->redirect($this->generateUrl('integration_creation', array(
				'jddid' => $attachedJdd->getId()
			)));
		}

		return $this->render('IgnGincoBundle:Jdd:jdd_new_page.html.twig', array(
			'form' => $form->createView(),
			'metadataUrl' => $metadataServiceUrl,
			'xml' => isset($xml) ? $xml : ''
		));
	}

	/**
	 * Jdd delete action
	 * Ginco customisation:: the test for 'Jdd deletable' takes into account if the jdd has active DEEs
	 *
	 * @Route("/{id}/delete", name = "jdd_delete", requirements={"id": "\d+"})
	 */
	public function deleteAction(Jdd $jdd) {

		// Test if deletable
		if (!$this->isJddDeletable($jdd)) {
			$this->addFlash('error', [
				'id' => 'Jdd.delete.impossible',
				'parameters' => [
					'%jddId%' => $jdd->getField('title')
				]
			]);
			// Redirects to the jdd list page
			return $this->redirect($this->generateUrl('jdd_list'));
		}

		return parent::deleteAction($jdd);
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
			$this->addFlash('notice', 'Jdd.page.metadataUpdateOK');
		} catch (MetadataException $e) {
			$this->addFlash('error', 'Jdd.page.metadataUpdateError');
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		return $this->redirect($redirectUrl);
	}

	/**
	 * Test if a jdd is deletable:
	 * - must have no active submissions
	 * - must have no active DEE
	 *
	 * @param Jdd $jdd
	 * @return bool
	 */
	protected function isJddDeletable(Jdd $jdd) {
		// Basic deletability: Jdd has no active submissions
		if (!$jdd->isDeletable()) {
			return false;
		}

		// Do the jdd has an active DEE ?
		$em = $this->get('doctrine.orm.entity_manager');
		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		// Get last version of DEE attached to the jdd
		$DEE = $deeRepo->findLastVersionByJdd($jdd);
		if ($DEE && $DEE->getStatus() != DEE::STATUS_DELETED) {
			return false;
		}
		return true;
	}
}
