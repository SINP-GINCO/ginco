<?php
namespace Ign\Bundle\OGAMBundle\Controller;

use Ign\Bundle\OGAMBundle\Entity\RawData\Jdd;
use Ign\Bundle\OGAMBundle\Form\JddType;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/")
 */
class JddController extends GincoController {

	/**
	 * Default action: Show the jdd list page
	 * todo: pagination, filter by user/provider, filter with exposed fields (filter form)
	 *
	 * @Route("/jdd/", name = "jdd_list")
	 */
	public function listAction() {
		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jddList = $em->getRepository('OGAMBundle:RawData\Jdd')->getActiveJdds();

		return $this->render('OGAMBundle:Jdd:jdd_list_page.html.twig', array(
			'jddList' => $jddList,
			'user' => $this->getUser()
		));
	}

	/**
	 * Jdd view page
	 *
	 * @Route("/jdd/{id}/show", name = "jdd_show", requirements={"id": "\d+"})
	 */
	public function showAction(Jdd $jdd) {
		return $this->render('OGAMBundle:Jdd:jdd_show_page.html.twig', array(
			'jdd' => $jdd,
			'user' => $this->getUser()
		));
	}

	/**
	 * Jdd creation page
	 *
	 * @Route("/jdd/new", name = "jdd_new")
	 */
	public function newAction(Request $request) {

		// Get the referer url, and put it in session to redirect to it at the end of the process
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');
		$session = $request->getSession();
		if (!$session->has('redirectToUrl'))
			$session->set('redirectToUrl', $redirectUrl);

		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jdd = new Jdd();
		$form = $this->createForm(new JddType(), $jdd, array(
			// the entity manager used for model choices must be the same as the one used to persist the $jdd entity
			'entity_manager' => $em
		));

		$form->handleRequest($request);
		if ($form->isValid()) {
			// Add user and provider relationship
			$jdd->setUser($this->getUser());
			$jdd->setProvider($this->getUser()
				->getProvider());

			// writes the jdd to the database
			// persist won't work (because user and provider are not retrieved via the same entity manager ?)
			// So merge and get the merged object to access auto-generated id
			$attachedJdd = $em->merge($jdd);
			$em->flush();

			// Redirects to the new submission form: upload data
			return $this->redirect($this->generateUrl('integration_creation', array(
				'jddid' => $attachedJdd->getId()
			)));
		}
		return $this->render('OGAMBundle:Jdd:jdd_new_page.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Jdd delete action
	 *
	 * @Route("/jdd/{id}/delete", name = "jdd_delete", requirements={"id": "\d+"})
	 */
	public function deleteAction(Jdd $jdd, Request $request) {

		// Get the referer url, to redirect to it at the end of the action
		$refererUrl = $request->headers->get('referer');
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('integration_home');

		// Test if deletable
		if (!$jdd->isDeletable()) {
			$this->get('session')
				->getFlashBag()
				->add('error', 'Jdd.delete.impossible');
			// Redirects to the jdd list page
			return $this->redirect($redirectUrl);
		}

		// Change its status to deleted
		$jdd->Delete();
		// Persist change to db
		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$em->merge($jdd);
		$em->flush();

		$this->get('session')
			->getFlashBag()
			->add('success', 'Jdd.delete.success');
		// Redirects to the jdd list page
		return $this->redirect($redirectUrl);
	}

	/**
	 * Jdd view fields - test page for developers
	 *
	 * @Route("/jdd/{id}/fields", name = "jdd_fields", requirements={"id": "\d+"})
	 */
	public function showFieldsAction(Jdd $jdd) {
		if (!$this->get('security.authorization_checker')->isGranted('IS_AUTHENTICATED_FULLY')) {
			throw $this->createAccessDeniedException();
		}
		$user = $this->getUser();
		$allowed = false;
		foreach ($user->getRoles() as $role) {
			if ('developpeur' == $role->getCode()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}

		return $this->render('OGAMBundle:Jdd:jdd_show_fields.html.twig', array(
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
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->find($id);
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
		$em = $this->get('doctrine.orm.entity_manager');
		$jdd = $em->getRepository('OGAMBundle:RawData\Jdd')->find($id);
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
			if ('developpeur' == $role->getCode()) {
				$allowed = true;
			}
		}
		if (!$allowed) {
			throw $this->createAccessDeniedException();
		}

		$em = $this->get('doctrine.orm.raw_data_entity_manager');
		$jddList = $em->getRepository('OGAMBundle:RawData\Jdd')->findByField(array(
			$key => $value
		), array(
			'id' => 'DESC'
		));

		return $this->render('OGAMBundle:Jdd:jdd_list_page.html.twig', array(
			'allJdds' => false,
			'jddList' => $jddList
		));
	}
}
