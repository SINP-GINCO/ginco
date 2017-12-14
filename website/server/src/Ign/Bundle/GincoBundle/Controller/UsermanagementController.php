<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Exception\UserUpdaterException;
use Ign\Bundle\GincoBundle\Form\GincoRoleType;
use Ign\Bundle\GincoBundle\Form\UserAddFromINPNType;
use Ign\Bundle\GincoBundle\Form\UserRoleType;
use Ign\Bundle\OGAMBundle\Controller\UsermanagementController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\Website\Provider;
use Ign\Bundle\GincoBundle\Form\ProviderSearchType;
use Ign\Bundle\OGAMBundle\Entity\Website\Role;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Ign\Bundle\GincoBundle\Services\ProviderService;
use Symfony\Component\Validator\Constraints\Length;

/**
 * @Route("/usermanagement")
 */
class UsermanagementController extends BaseController {

	/**
	 * Add a User:
	 * Search him in the INPN directory, given his login.
	 * On success, add him in DB and redirect to editUser to change his roles.
	 *
	 * @param Request $request
	 * @return \Symfony\Component\HttpFoundation\RedirectResponse|\Symfony\Component\HttpFoundation\Response
	 *
	 * @Route("/addUser", name="usermanagement_addUser")
	 */
	public function addUserAction(Request $request) {
		$logger = $this->get('logger');
		$logger->debug('addUserAction');

		// Get the "Add User from INPN" form
		$form = $this->createForm(UserAddFromINPNType::class);

		$form->handleRequest($request);

		$formIsValid = $form->isValid();
		if ($formIsValid) {
			$userLogin = $form->get('login')->getData();

			// If already existing in db, display error
			$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
			if ($userRepo->find($userLogin)) {
				$error = new FormError($this->get('translator')->trans('administration.user.add.alreadyExists', array(), 'validators'));
				$form->get('login')->addError($error);
				$formIsValid = false;
			}

			// Checks if user exists in INPN directory, and try to create him in database
			try {
				$newUser = $this->get('ginco.inpn_user_updater')->updateOrCreateLocalUser($userLogin);

				// If not in INPN directory (and not exception), display an error
				if (!$newUser) {
					$error = new FormError($this->get('translator')->trans('administration.user.add.notFound', array(), 'validators'));
					$form->get('login')->addError($error);
					$formIsValid = false;
				}
			}
			catch (UserUpdaterException $e) {
				$error = new FormError($this->get('translator')->trans($e->getMessage(), array(), 'validators'));
				$form->get('login')->addError($error);
				$formIsValid = false;
			}
		}

		if ($formIsValid) {
			// User has already be created, just notice the adminisitrator and
			// redirect to edit Roles pages
			$this->addFlash('success', $this->get('translator')
				->trans('User.add.success', array('%login%' => $userLogin)));

			return $this->redirectToRoute('usermanagement_editUser', array('login' => $userLogin));
		}

		return $this->render('IgnGincoBundle:UsermanagementController:add_user.html.twig', array(
			'form' => $form->createView()
		));
	}

	/**
	 * Edit a user.
	 *
	 * @Route("/editUser/{login}", name="usermanagement_editUser")
	 */
	public function editUserAction(Request $request, $login = null) {
		$user = new User();

		$logger = $this->get('logger');
		$logger->debug('editUserAction');

		if ($login != null) {
			$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
			$user = $userRepo->find($login);
		}

		// Get the user form
		$form = $this->createForm(UserRoleType::class, $user);

		$form->handleRequest($request);

		if ($form->isSubmitted() && $form->isValid()) {
			$user = $form->getData();
			// Save the user
			$em = $this->getDoctrine()->getManager();
			$em->persist($user);
			$em->flush();

			$this->addFlash('success', $this->get('translator')
				->trans('The user information has been saved.'));

			return $this->redirectToRoute('usermanagement_showUsers');
		}

		return $this->render('IgnGincoBundle:UsermanagementController:edit_user.html.twig', array(
			'user' => $user,
			'form' => $form->createView()
		));
	}


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

			// Check if default value is not null (not possible to do in form validation nor in entity)
			if ($role->getIsDefault() == null) {
				$role->setIsDefault(false);
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

	/**
	 * Add a provider
	 * Search it in the INPN directory, then add it as a local provider
	 *
	 * @Route("/addProvider", name="usermanagement_addProvider")
	 */
	public function addProviderAction(Request $request,$id = null) {

		$logger = $this->get('logger');
		$logger->debug('addProviderAction');
		$providerService = $this->get('ginco.inpn_provider_service');

		// Get the provider form
		$form = $this->createForm(ProviderSearchType::class);
		$form->handleRequest($request);

		if ($form->isValid()) {

			// Get search request
			$search = $form->get('label')->getData();

			// Test and extract the id of INPN provider - in parenthesis
			$re = '/\((\d+)\)/';
			preg_match($re, $search, $matches);

			//Test if the selection if you have the id in ()
			if (count($matches) == 0) {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.error_label'));
				return $this->render('OGAMBundle:UsermanagementController:add_provider.html.twig', array(
					'form' => $form->createView()
				));
			}

			//Check if organism exist in database
			$idProvider = intval($matches[1]);

			$findID = $this->getDoctrine()->getRepository('Ign\Bundle\OgamBundle\Entity\Website\Provider', 'website')->find($idProvider);
			if ($findID) {
				$this->addFlash('warning', $this->get('translator')
					->trans('Providers.flash.exist_provider'));
				return $this->redirectToRoute('usermanagement_showProviders');
			}

			$provider = $providerService->updateOrCreateLocalProvider($idProvider);

			if ($provider) {
				$this->addFlash('success', $this->get('translator')
					->trans('Providers.flash.success'));
				return $this->redirectToRoute('usermanagement_showProviders');
			} else {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.error_label'));
			}
		}

		return $this->render('OGAMBundle:UsermanagementController:add_provider.html.twig', array(
			'form' => $form->createView()
		));

	}

	/**
	 * Search a provider
	 * This url is a proxy to make ajax calls to the INPN webservice
	 *
	 * @Route("/search-providers", name="search_providers")
	 */
	public function searchProvidersProxyAction(Request $request) {

		$term = $request->query->get('term');
		$results = $this->get('ginco.inpn_provider_service')->searchOrganism($term);
		return new JsonResponse($results);
	}

	/**
	 * Edit a provider : disable route (we can't anymore edit providers as they come from INPN)
	 *
	 * @Route("/editProvider/{id}", name="usermanagement_editProvider")
	 */
	public function editProviderAction(Request $request, $id = null) {
		throw $this->createNotFoundException();
	}


	/**
	 * Refresh provider infos from INPN webservice
	 * @Route("/refreshProvider/{id}", name = "provider_refresh")
	 */
	public function refreshProviderAction(Request $request, $id) {

		// Update via the INPN webservice
		$provider = $this->get('ginco.inpn_provider_service')->updateOrCreateLocalProvider($id);

		// If user not found, flash message
		if (!$provider) {
			$this->addFlash('warning', $this->get('translator')
				->trans('Providers.refresh.notfound'));
		}

		// Get the referer url
		$refererUrl = $request->headers->get('referer');
		// returns to the page where the action comes from
		$redirectUrl = ($refererUrl) ? $refererUrl : $this->generateUrl('usermanagement_showProviders');
		return $this->redirect($redirectUrl);
	}
	/**
	 * Show the detail of a provider.
	 *
	 * @Route("/showProviderContent/{id}", name="usermanagement_showProviderContent")
	 *
	 * @param Integer $id
	 *        	the id of a provider
	 */
	public function showProviderContentAction($id) {
		$logger = $this->get('logger');
		$logger->info('showProviderContentAction');
		
		$logger->info('id : ' . $id);
		
		// Get the provider detail
		$providersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\Provider', 'website');
		$provider = $providersRepo->find($id);
		
		$logger->info('provider : ' . \Doctrine\Common\Util\Debug::dump($provider, 3, true, false));
		
		// Get the users linked to this provider
		$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\Website\User', 'website');
		$users = $usersRepo->findByProvider($provider->getId());
		
		// Get the submissions linked to this provider
		$submissionsRepo = $this->getDoctrine()->getRepository('Ign\Bundle\OGAMBundle\Entity\RawData\Submission', 'raw_data');
		$submissions = $submissionsRepo->getActiveSubmissions($provider->getId());
		
		$logger->info('submissions : ' . \Doctrine\Common\Util\Debug::dump($submissions, 3, true, false));
		
		// Get the raw data linked to this provider
		
		return $this->render('OGAMBundle:UsermanagementController:show_provider_content.html.twig', array(
			'provider' => $provider,
			'users' => $users,
			'submissions' => $submissions
		));
	}
}
