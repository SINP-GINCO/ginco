<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\RawData\DEE;
use Ign\Bundle\GincoBundle\Entity\RawData\Jdd;
use Ign\Bundle\GincoBundle\Exception\MetadataException;
use Ign\Bundle\GincoBundle\Form\GincoJddType;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/")
 */
class JddController extends GincoController {

	/**
	 * Default action: Show the jdd list page
	 * Can show own user's Jdd, or all Jdds
	 * Ginco customisation: the test for 'Jdd deletable' takes into account if the jdd has active DEEs
	 *
	 * @Route("/jdd/all/", name = "all_jdd_list", defaults={"allJdds": true, "providerJdds": false})
	 * @Route("/jdd/provider/", name = "provider_jdd_list", defaults={"allJdds": false, "providerJdds": true})
	 * @Route("/jdd/", name = "user_jdd_list", defaults={"allJdds": false, "providerJdds": false})
	 */
	public function listAction(Request $request, $allJdds = false, $providerJdds = false) {

		$this->denyAccessUnlessGranted('LIST_JDD') ;

		$em = $this->get('doctrine.orm.raw_data_entity_manager');

		if ($allJdds) {
			$jddList = $em->getRepository('IgnGincoBundle:RawData\Jdd')->getActiveJdds();
		} else if ($providerJdds) {
			$jddList = $em->getRepository('IgnGincoBundle:RawData\Jdd')->getActiveJdds($this->getUser()->getProvider(), null);
		} else {
			$jddList = $em->getRepository('IgnGincoBundle:RawData\Jdd')->getActiveJdds(null, $this->getUser());
		}

		$deeRepo = $em->getRepository('IgnGincoBundle:RawData\DEE');
		foreach ($jddList as $jdd) {
			$jdd->trueDeletable = $this->get('ginco.jdd_service')->isDeletable($jdd);
			foreach ($jdd->getSubmissions() as $submission) {
				foreach ($submission->getFiles() as $file) {
					$file->filenameWithoutExtension = pathinfo($file->getFileName(), PATHINFO_FILENAME);
					$file->filenameExtension = pathinfo($file->getFileName(), PATHINFO_EXTENSION);
				}
			}
			// Add DEE information
			$jdd->dee = $deeRepo->findLastVersionByJdd($jdd);
		}

		return $this->render('IgnGincoBundle:Jdd:jdd_list_page.html.twig', array(
			'jddList' => $jddList,
			'allJdds' => $allJdds,
			'providerJdds' => $providerJdds
		));
	}

	/**
	 * Jdd view page
	 *
	 * @Route("/jdd/{id}/show", name = "jdd_show", requirements={"id": "\d+"})
	 */
	public function showAction(Jdd $jdd) {
		
		$this->denyAccessUnlessGranted('VIEW_JDD', $jdd) ;
		
		return $this->render('IgnGincoBundle:Jdd:jdd_show_page.html.twig', array(
			'jdd' => $jdd,
			'user' => $this->getUser()
		));
	}

	/**
	 * Jdd creation page
	 * Checks, via a service, the xml file on metadata platform, and fills jdd fields with metadata fields
	 *
	 * @Route("/jdd/new", name = "jdd_new")
	 */
	public function newAction(Request $request) {
		
		$this->denyAccessUnlessGranted('CREATE_JDD') ;

		// Get the referer url, to redirect to it at the end of the action
		$refererUrl = $request->headers->get('referer');
		if ($refererUrl && in_array($refererUrl, [
				$this->generateUrl('user_jdd_list', [], true),
				$this->generateUrl('provider_jdd_list', [], true),
				$this->generateUrl('all_jdd_list', [], true)
		])) {
			$redirectUrl = $refererUrl;
		} else {
			$redirectUrl = $this->generateUrl('user_jdd_list');
		}
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);

		$em = $this->get('doctrine.orm.entity_manager');

		// Get the url of the metadata service
		$metadataServiceUrl = $this->get('ginco.configuration_manager')->getConfig('jddMetadataFileDownloadServiceURL');
		// Format the URL to only get prefix
		$endUrl = strpos($metadataServiceUrl, "cadre");
		$metadataServiceUrl = substr($metadataServiceUrl, 0, $endUrl + 6);

		$jdd = new Jdd();
                
		$form = $this->createForm(GincoJddType::class, $jdd, array(
			// the entity manager used for model choices must be the same as the one used to persist the $jdd entity
			'entity_manager' => $em,
			'user' => $this->getUser()
		));

		$form->handleRequest($request);

		// Add a custom step to test validity of the metadata_id, with the metadata service
		$formIsValid = $form->isValid();
                
		if ($formIsValid) {
                        
			$metadataId = $form->get('metadata_id')->getData();

			// Test if another jdd already exists with this metadataId
			$jddWithSameMetadataId = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findByField(array(
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
                        
			if ($this->getUser()->isAllowed('MANAGE_JDD_SUBMISSION_ALL')){
				$provider = $form->get('provider')->getData();
			} else {
				$provider = $this->getUser()->getProvider();
			}
                        
			$jdd->setProvider($provider);

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
	 * The test for 'Jdd deletable' takes into account if the jdd has active DEEs
	 *
	 * @Route("/jdd/{id}/delete", name = "jdd_delete", requirements={"id": "\d+"})
	 */
	public function deleteAction(Jdd $jdd, Request $request) {
		
		$this->denyAccessUnlessGranted('DELETE_JDD', $jdd) ;

		// Get the referer url, to redirect to it at the end of the action
		$refererUrl = $request->headers->get('referer');

		// Test if jdd is deletable
		if (!$this->get('ginco.jdd_service')->isDeletable($jdd)) {
			$this->addFlash('error', [
				'id' => 'Jdd.delete.impossible',
				'parameters' => [
					'%jddId%' => $jdd->getField('title')
				]
			]);

			$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('user_jdd_list');
			return $this->redirect($redirectUrl);
		}

		// Change jdd status to deleted
		$jdd->Delete();
		// Persist change to db
		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$em->merge($jdd);
		$em->flush();

		$this->get('session')
			->getFlashBag()
			->add('success', 'Jdd.delete.success');

		// Redirect according to the referer
		if ($refererUrl && in_array($refererUrl, [
				$this->generateUrl('user_jdd_list', [], true), 
				$this->generateUrl('provider_jdd_list', [], true), 
				$this->generateUrl('all_jdd_list', [], true)
		])) {
			$redirectUrl = $refererUrl;
		} else {
			$redirectUrl = $this->generateUrl('integration_home');
		}
		// Redirects to a jdd list page
		return $this->redirect($redirectUrl);
	}

	/**
	 * Update Metadata for the given jdd
	 * returns JsonResponse true or false
	 * Checks, via a service, the xml file on metadata platform, and fills jdd fields with metadata fields
	 *
	 * @Route("/jdd/{id}/update-metadata", name = "jdd_update_metadata", requirements={"id": "\d+"})
	 */
	public function updateMetadata(Request $request, Jdd $jdd) {
		
		$jddService = $this->get('ginco.jdd_service') ;
		try {
			$jddService->updateMetadataFields($jdd) ;
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
	 * Jdd view fields - test page for developers
	 *
	 * @Route("/jdd/{id}/fields", name = "jdd_fields", requirements={"id": "\d+"})
	 */
	public function showFieldsAction(Jdd $jdd) {
		
		$user = $this->getUser();
		$allowed = false;
		foreach ($user->getRoles() as $role) {
			if ('Développeur' == $role->getLabel()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}

		return $this->render('IgnGincoBundle:Jdd:jdd_show_fields.html.twig', array(
			'jdd' => $jdd
		));
	}

	/**
	 * Add a field by key value
	 *
	 * @Route("/jdd/{id}/add-field/{key}/{value}", name = "jdd_add_field", requirements={"id": "\d+"})
	 *
	 * @param Jdd $jdd
	 * @param
	 *        	$key
	 * @param
	 *        	$value
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse
	 */
	public function addField($id, $key = null, $value = null) {
		
		$user = $this->getUser();
		$allowed = false;
		foreach ($user->getRoles() as $role) {
			if ('Développeur' == $role->getLabel()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}
		
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->find($id);
		if ($jdd) {
			$jdd->setField($key, $value);
			$em->flush();
		}
		// Redirects to the jdd show page
		return $this->redirect($this->generateUrl('jdd_fields', array(
			'id' => $jdd->getId()
		)));
	}

	/**
	 * Removes a field by key
	 *
	 * @Route("/jdd/{id}/remove-field/{key}", name = "jdd_remove_field", requirements={"id": "\d+"})
	 *
	 * @param Jdd $jdd
	 * @param
	 *        	$key
	 * @param
	 *        	$value
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse
	 */
	public function removeField($id, $key) {
		
		$user = $this->getUser();
		$allowed = false;
		foreach ($user->getRoles() as $role) {
			if ('Développeur' == $role->getLabel()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}
		
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('IgnGincoBundle:RawData\Jdd')->find($id);
		if ($jdd) {
			$jdd->removeField($key);
			$em->flush();
		}
		// Redirects to the jdd show page
		return $this->redirect($this->generateUrl('jdd_fields', array(
			'id' => $jdd->getId()
		)));
	}

	/**
	 * Find and show the jdd for a given key/value field
	 *
	 * @Route("/jdd/find-field/{key}/{value}", name = "jdd_find_field")
	 */
	public function findByFieldAction($key, $value) {
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}
		$user = $this->getUser();
		$allowed = false;
		foreach ($user->getRoles() as $role) {
			if ('Développeur' == $role->getCode()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}

		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jddList = $em->getRepository('IgnGincoBundle:RawData\Jdd')->findByField(array(
			$key => $value
		), array(
			'id' => 'DESC'
		));

		return $this->render('IgnGincoBundle:Jdd:jdd_list_page.html.twig', array(
			'allJdds' => false,
			'jddList' => $jddList
		));
	}
}
