<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Form\GincoRoleType;
use Ign\Bundle\OGAMBundle\Controller\UsermanagementController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\Website\Role;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/usermanagement")
 */
class UsermanagementController extends BaseController {

	/**
	 * Edit a role.
	 * Ginco customisation: removes the "schema" and "datasets restriction" fields from the form:
	 * --> schema: always RAW_DATA
	 * --> datasets restrictions: none
	 *
	 * @Route("/editRole/{code}", name="usermanagement_editRole")
	 */
	public function editRoleAction(Request $request, $code = null) {
		$role = new Role();
		$logger = $this->get('logger');
		$logger->debug('editRoleAction');

		if ($code != null) {
			$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');
			$role = $roleRepo->find($code);
		}
		// Get the role form
		$form = $this->createForm(GincoRoleType::class, $role);

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {
			// $form->getData() holds the submitted values
			// but, the original `$provider` variable has also been updated
			// $role = $form->getData();
			$logger->debug('provider : ' . \Doctrine\Common\Util\Debug::dump($role, 3, true, false));

			// Always give the permission to RAW_DATA schema (and only RAW_DATA)
			if (!$role->isSchemaAllowed('RAW_DATA')) {
				$schemaRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Metadata\TableSchema');
				$schemaRawData = $schemaRepo->find('RAW_DATA');
				$role->addSchema($schemaRawData);
			}
			// Save the role
			$em = $this->getDoctrine()->getManager();
			$em->persist($role);
			$em->flush();

			$this->addFlash('success', $this->get('translator')
				->trans('The role information has been saved.'));

			return $this->redirectToRoute('usermanagement_showRoles');
		}

		return $this->render('OGAMBundle:UsermanagementController:edit_role.html.twig', array(
			'form' => $form->createView(),
			'label_role' => $role->getLabel()
		));
	}

	/**
	 * Show the list of users.
	 * Ginco : The default user (visiteur) cannot be edited.
	 *
	 * @Route("/showUsers", name="usermanagement_showUsers")
	 */
	public function showUsersAction() {
		$logger = $this->get('logger');
		$logger->info('showUsersAction');

		// Get the list of roles
		$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$users = $usersRepo->findAll();

		// Calculate if each user can be deleted (thus, modified or change-password ability given) or not
		$isDeletableUser = array();
		foreach ($users as $user) {

			$isDeletable = true;

			if ($user->getLogin() === 'visiteur') {
				$isDeletable = false;
			}

			$isDeletableUser[$user->getLogin()] = $isDeletable;
		}

		return $this->render('OGAMBundle:UsermanagementController:show_users.html.twig', array(
			'users' => $users,
			'isDeletableUser' => $isDeletableUser
		));
	}

	/**
	 * Show the list of roles.
	 * Ginco: The default role (Grand public) cannot be edited.
	 *
	 * @Route("/showRoles", name="usermanagement_showRoles")
	 */
	public function showRolesAction() {
		$logger = $this->get('logger');
		$logger->info('showRolesAction');

		// Get the list of roles
		$rolesRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');
		$roles = $rolesRepo->findAll();

		// Calculate if each role can be deleted or not
		$isDeletableRole = array();
		foreach ($roles as $role) {

			$isDeletable = true;

			// If a user is using this role then we cannot delete it
			$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');
			$nbUsers = $roleRepo->userCount($role->getCode());
			if ($nbUsers > 0) {
				$isDeletable = false;
			}

			// If the role is Grand public then we cannot delete it
			if ($role->getLabel() === 'Grand public') {
				$isDeletable = false;
			}

			// If the role is the default one then we cannot delete it
			if ($role->getIsDefault()) {
				$isDeletable = false;
			}

			$isDeletableRole[$role->getCode()] = $isDeletable;
		}

		// Calculate if each role can be modified or not
		$isModifiableRole = array();
		foreach ($roles as $role) {

			$isModifiable = true;

			/*
			 * if ($role->getLabel() === 'Grand public') {
			 * $isModifiable = false;
			 * }
			 */

			$isModifiableRole[$role->getCode()] = $isModifiable;
		}

		return $this->render('OGAMBundle:UsermanagementController:show_roles.html.twig', array(
			'roles' => $roles,
			'isDeletableRole' => $isDeletableRole,
			'isModifiableRole' => $isModifiableRole
		));
	}
}
