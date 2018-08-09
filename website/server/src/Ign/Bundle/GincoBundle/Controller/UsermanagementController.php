<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Entity\Mapping\ProviderMapParameters;
use Ign\Bundle\GincoBundle\Entity\Website\Role;
use Ign\Bundle\GincoBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Exception\UserUpdaterException;
use Ign\Bundle\GincoBundle\Form\ChangePasswordType;
use Ign\Bundle\GincoBundle\Form\GincoRoleType;
use Ign\Bundle\GincoBundle\Form\ProviderSearchType;
use Ign\Bundle\GincoBundle\Form\UserAddFromINPNType;
use Ign\Bundle\GincoBundle\Form\UserRoleType;

use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;

use Symfony\Component\Form\FormError;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;

/**
 * @Route("/usermanagement")
 */
class UsermanagementController extends GincoController {

	/**
	 * @Route("/", name = "usermanagement_home")
	 */
	public function indexAction() {
		return $this->render('IgnGincoBundle:UsermanagementController:index.html.twig', array());
	}
	
	/**
	 * Delete a provider.
	 *
	 * @Route("/deleteProvider/{id}", name="usermanagement_deleteProvider")
	 */
	public function deleteProviderAction($id) {
		$providerRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Provider', 'website');
		$provider = $providerRepo->find($id);
	
		if ($provider == null) {
			$this->addFlash('error', $this->get('translator')
				->trans('The provider does not exist.'));
			return $this->redirectToRoute('usermanagement_showProviders');
		}
	
		$em = $this->getDoctrine()->getManager();
		$em->remove($provider);
	
		// Delete provider map parameters
		$providerMapParametersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Mapping\ProviderMapParameters', 'mapping');
		$detachedProviderMapParameters = $providerMapParametersRepo->find($provider->getId());
	
		if ($detachedProviderMapParameters == null) {
			$this->addFlash('error', $this->get('translator')
				->trans('The provider map parameters do not exist.'));
			return $this->redirectToRoute('usermanagement_showProviders');
		}
	
		$providerMapParameters = $em->merge($detachedProviderMapParameters);
		$em->remove($providerMapParameters);
	
		$em->flush();
	
		$this->addFlash('success', $this->get('translator')
			->trans('The provider has been deleted.'));
	
		return $this->redirectToRoute('usermanagement_showProviders');
	}
	
	/**
	 * Delete a role.
	 *
	 * @Route("/deleteRole/{code}", name="usermanagement_deleteRole")
	 */
	public function deleteRoleAction($code) {
		$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Role', 'website');
		$role = $roleRepo->find($code);
	
		if ($role == null) {
			$this->addFlash('error', $this->get('translator')
				->trans('The role does not exist.'));
			return $this->redirectToRoute('usermanagement_showRoles');
		}
	
		$em = $this->getDoctrine()->getManager();
		$em->remove($role);
		$em->flush();
	
		$this->addFlash('success', $this->get('translator')
			->trans('The role has been deleted.'));
	
		return $this->redirectToRoute('usermanagement_showRoles');
	}
	
	/**
	 * @Route("/deleteUser/{login}", name="usermanagement_deleteUser")
	 */
	public function deleteUserAction($login) {
		$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
		$user = $userRepo->find($login);
	
		if ($user == null) {
			$this->addFlash('error', $this->get('translator')
				->trans('The user does not exist.'));
			return $this->redirectToRoute('usermanagement_showUsers');
		}
	
		$em = $this->getDoctrine()->getManager();
		$em->remove($user);
		$em->flush();
	
		$this->addFlash('success', $this->get('translator')
			->trans('The user has been deleted.'));
	
		return $this->redirectToRoute('usermanagement_showUsers');
	}
	
	/**
	 * @Route("/changePassword/{login}", name="usermanagement_changePassword")
	 */
	public function changePasswordAction(Request $request, $login) {
		$logger = $this->get('logger');
		$logger->debug('changePasswordAction');
	
		// Load the user
		$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
		$user = $userRepo->find($login);
	
		// Get the change password form
		$form = $this->createForm(ChangePasswordType::class, $user);
	
		$form->handleRequest($request);
	
		if ($form->isSubmitted() && $form->isValid()) {
			// $form->getData() holds the submitted values
			// but, the original `$user` variable has also been updated
			$user = $form->getData();
	
			// Encrypt the password if in creation mode
			if (!empty($user->getPlainPassword())) {
				$encoder = $this->get('ginco.challenge_response_encoder');
				$password = $encoder->encodePassword($user->getPlainPassword(), '');
				$user->setPassword($password);
			}
	
			// Save the user
			$em = $this->getDoctrine()->getManager();
			$em->persist($user);
			$em->flush();
	
			$this->addFlash('success', $this->get('translator')
				->trans('The user password information has been saved.'));
	
			return $this->redirectToRoute('usermanagement_showUsers');
		}
	
		return $this->render('IgnGincoBundle:UsermanagementController:change_password.html.twig', array(
			'form' => $form->createView(),
			'user' => $user
		));
	}
	
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
			$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
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
			$userRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
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
	 *
	 * @Route("/editRole/{code}", name="usermanagement_editRole")
	 */
	public function editRoleAction(Request $request, $code = null) {
		$role = new Role();
		$logger = $this->get('logger');
		$logger->debug('editRoleAction');

		if ($code != null) {
			$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Role', 'website');
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
				$schemaRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Metadata\TableSchema');
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

		return $this->render('IgnGincoBundle:UsermanagementController:edit_role.html.twig', array(
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
		$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
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

		return $this->render('IgnGincoBundle:UsermanagementController:show_users.html.twig', array(
			'users' => $users,
			'isDeletableUser' => $isDeletableUser
		));
	}

	/**
	 * Show the list of roles.
	 * The default role (Grand public) cannot be edited.
	 *
	 * @Route("/showRoles", name="usermanagement_showRoles")
	 */
	public function showRolesAction() {
		$logger = $this->get('logger');
		$logger->info('showRolesAction');

		// Get the list of roles
		$rolesRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Role', 'website');
		$roles = $rolesRepo->findAll();

		// Calculate if each role can be deleted or not
		$isDeletableRole = array();
		foreach ($roles as $role) {

			$isDeletable = true;

			// If a user is using this role then we cannot delete it
			$roleRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Role', 'website');
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

		return $this->render('IgnGincoBundle:UsermanagementController:show_roles.html.twig', array(
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
			$provider = $form->get('label')->getData();

			$provider = $providerService->updateOrCreateLocalProvider($provider->getId());

			if ($provider) {
				$this->addFlash('success', $this->get('translator')
					->trans('Providers.flash.success'));
				return $this->redirectToRoute('usermanagement_showProviders');
			} else {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.error_label'));
			}
		}

		return $this->render('IgnGincoBundle:UsermanagementController:add_provider.html.twig', array(
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
	 * Show the list of providers.
	 *
	 * @Route("/showProviders", name="usermanagement_showProviders")
	 */
	public function showProvidersAction() {
		$logger = $this->get('logger');
		$logger->info('showProvidersAction');
	
		// Get the list of providers
		$providersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Provider', 'website');
		$providers = $providersRepo->findAll();
	
		// Calculate if each provider can be deleted or not
		$isDeletableProvider = array();
		foreach ($providers as $provider) {
	
			$isDeletable = true;
	
			// If a user is using this provider then we cannot delete
			$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
			$users = $usersRepo->findByProvider($provider->getId());
			if (count($users) > 0) {
				$isDeletable = false;
			}
	
			// If a submission exists with this provider then we cannot delete
			$submissionRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\RawData\Submission', 'raw_data');
			$submissions = $submissionRepo->getActiveSubmissions($provider->getId());
			if (count($submissions) > 0) {
				$isDeletable = false;
			}
	
			$isDeletableProvider[$provider->getId()] = $isDeletable;
		}
	
		return $this->render('IgnGincoBundle:UsermanagementController:show_providers.html.twig', array(
			'providers' => $providers,
			'isDeletableProvider' => $isDeletableProvider
		));
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
		$providersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\Provider', 'website');
		$provider = $providersRepo->find($id);
		
		$logger->info('provider : ' . \Doctrine\Common\Util\Debug::dump($provider, 3, true, false));
		
		// Get the users linked to this provider
		$usersRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\User', 'website');
		$users = $usersRepo->findByProvider($provider->getId());
		
		// Get the submissions linked to this provider
		$submissionsRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\RawData\Submission', 'raw_data');
		$submissions = $submissionsRepo->getActiveSubmissions($provider->getId());
		
		$logger->info('submissions : ' . \Doctrine\Common\Util\Debug::dump($submissions, 3, true, false));
		
		//Get the JDD linked to JDDId
		$submRepo = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\RawData\Jdd', 'raw_data');
		$jddInfos = array();
		$previousJddId = 0;
		foreach ($submissions as $key=>$valuesField) {
			$jddResult = $submRepo->getActiveJddsFields($valuesField->getJdd()->getId());
			if($previousJddId != $valuesField->getJdd()->getId()) {
				$jddInfos = array_merge($jddInfos,$jddResult);
				$previousJddId = $valuesField->getJdd()->getId();
			}
		}
		// Get the raw data linked to this provider
		return $this->render('IgnGincoBundle:UsermanagementController:show_provider_content.html.twig', array(
			'provider' => $provider,
			'users' => $users,
			'submissions' => $submissions,
			'jddInfos' => $jddInfos
		));
	}
	
	/**
	 * Create a new BoundingBox object with default values from database.
	 *
	 * @return BoundingBox the BoundingBox
	 */
	public function createDefaultBoundingBox() {
	
		// Get the parameters from configuration file
		$configuration = $this->get("ginco.configuration_manager");
		$xMin = $configuration->getConfig('default_provider_bbox_x_min');
		$xMax = $configuration->getConfig('default_provider_bbox_x_max');
		$yMin = $configuration->getConfig('default_provider_bbox_y_min');
		$yMax = $configuration->getConfig('default_provider_bbox_y_max');
		$zoomLevel = $configuration->getConfig('default_provider_zoom_level');
	
		$em = $this->getDoctrine()->getManager();
		$zoomLevel = $em->find('Ign\Bundle\GincoBundle\Entity\Mapping\ZoomLevel', $zoomLevel);
	
		$bb = new ProviderMapParameters();
		return $bb->createBoundingBox($xMin, $xMax, $yMin, $yMax, $zoomLevel);
	}
}
