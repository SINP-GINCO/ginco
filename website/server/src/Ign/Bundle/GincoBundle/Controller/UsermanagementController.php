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
			'form' => $form->createView()
		));
	}

	/**
	 * Show the list of users.
	 * Ginco : Remove the default user (visiteur).
	 *
	 * @Route("/showUsers", name="usermanagement_showUsers")
	 */
	public function showUsersAction() {
		$logger = $this->get('logger');
		$logger->info('showUsersAction');

		// Get the list of roles
		$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$users = $usersRepo->findAll();

		// Remove default user
		for ($i = 0; $i < count($users); $i ++) {
			if ($users[$i]->getLogin() === 'visiteur') {
				unset($users[$i]);
				break;
			}
		}

		return $this->render('OGAMBundle:UsermanagementController:show_users.html.twig', array(
			'users' => $users
		));
	}

	/**
	 * Show the list of roles.
	 * Ginco: Remove the default role.
	 *
	 * @Route("/showRoles", name="usermanagement_showRoles")
	 */
	public function showRolesAction() {
		$logger = $this->get('logger');
		$logger->info('showRolesAction');

		// Get the list of roles
		$rolesRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');
		$roles = $rolesRepo->findAll();

		// Remove default role
		for ($i = 0; $i < count($roles); $i ++) {
			if ($roles[$i]->getCode() === 'grand_public') {
				unset($roles[$i]);
				break;
			}
		}

		// Calculate if each role can be deleted or not
		$isDeletableRole = array();
		foreach ($roles as $role) {

			$isDeletable = true;

			// If a user is using this role then we cannot delete
			$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Role', 'website');
			$nbUsers = $roleRepo->userCount($role->getCode());
			if ($nbUsers > 0) {
				$isDeletable = false;
			}

			$isDeletableRole[$role->getCode()] = $isDeletable;
		}

		return $this->render('OGAMBundle:UsermanagementController:show_roles.html.twig', array(
			'roles' => $roles,
			'isDeletableRole' => $isDeletableRole
		));
	}
}
