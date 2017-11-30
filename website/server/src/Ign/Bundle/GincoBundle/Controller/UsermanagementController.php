<?php
namespace Ign\Bundle\GincoBundle\Controller;

use Ign\Bundle\GincoBundle\Form\GincoRoleType;
use Ign\Bundle\GincoBundle\Form\UserRoleType;
use Ign\Bundle\OGAMBundle\Controller\UsermanagementController as BaseController;
use Ign\Bundle\OGAMBundle\Entity\Website\Role;
use Ign\Bundle\OGAMBundle\Entity\Website\User;
use Ign\Bundle\GincoBundle\Entity\Website\ProviderInpn;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\Route;
use Ign\Bundle\GincoBundle\Form\ProviderInpnType;
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
	 *
	 * @Route("/addProvider", name="usermanagement_addProvider")
	 */
	public function addProviderAction(Request $request,$id = null) {

		$providerInpn = new ProviderInpn();

		$logger = $this->get('logger');
		$logger->debug('addProviderAction');
		$em = $this->getDoctrine()->getManager();
		$searchOrga = $this->get('ginco.provider_service');

		// Get the provider form
		$form = $this->createForm(ProviderInpnType::class, $providerInpn);
		$form->handleRequest($request);
		
		if ($form->isSubmitted() && $form->isValid()) {

			$providerInpn = $form->getData();
			$resultChoice = explode("(",$providerInpn->getLabel());
			
			//Test if the selection if you have the id in ()
			if (sizeOf($resultChoice) <= 1) {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.error_label'));
				return $this->render('OGAMBundle:UsermanagementController:add_provider.html.twig', array(
					'form' => $form->createView()
				));
			}
			
			//Check if organism exist in database
			$idChoice = str_replace(")","",$resultChoice[1]);
			
			$findID = $this->getDoctrine()->getRepository('Ign\Bundle\GincoBundle\Entity\Website\ProviderInpn', 'website')->find($idChoice);
			if ($findID) {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.exist_provider'));
				return $this->redirectToRoute('usermanagement_showProviders');
			}
			
			$searchInfosId = json_decode($searchOrga->getInfosById($idChoice));
			
			//Verify if we have a result and if the selection haven't been modified
			if(($searchInfosId->response->numFound) > 0) {
				//Get Value from JSON
				$label = $searchInfosId->response->docs[0]->libelleLong ." - ". $searchInfosId->response->docs[0]->libelleCourt;
				if(isset($searchInfosId->response->docs[0]->descriptionOrganisme)) {
					$definition= $searchInfosId->response->docs[0]->descriptionOrganisme;
				} else {
					$definition = 0;
				}
				
				$idOrganisme = $searchInfosId->response->docs[0]->id;
				$codeOrganisme = $searchInfosId->response->docs[0]->codeOrganisme;
				$logger->debug('provider : ' . \Doctrine\Common\Util\Debug::dump($providerInpn, 3, true, false));
				$insertResult = new ProviderInpn;
				$insertResult ->setId($idOrganisme);
				$insertResult->setLabel($label);
				$insertResult->setDefinition($definition);
				$insertResult->setUUID($codeOrganisme);
				
				
				// Save the provider
				$em = $this->getDoctrine()->getManager();
				$em->persist($insertResult);
				// Save the provider map params
				if($id == null) {
					$bbox = $this->createDefaultBoundingBox();
					$bbox->setProviderId($idOrganisme);
					$em->persist($bbox);
				}
				$em->flush();

				$this->addFlash('success', $this->get('translator')
					->trans('Providers.flash.success'));
				return $this->redirectToRoute('usermanagement_showProviders');
			} else {
				$this->addFlash('error', $this->get('translator')
					->trans('Providers.flash.error_label'));
				return $this->render('OGAMBundle:UsermanagementController:add_provider.html.twig', array(
					'form' => $form->createView()
				));
			}
		}

		
		return $this->render('OGAMBundle:UsermanagementController:add_provider.html.twig', array(
			'form' => $form->createView()
		));

	}

	/**
	 * Search a provider
	 *
	 * @Route("/search-providers", name="search_providers")
	 */
	public function searchProviders(Request $request) {
	
		$logger = $this->get('logger');
		$logger->debug('addProviderAction');
		
		$inputProvider = $request->query->get('inputProvider');
		$logger->debug($inputProvider);
		$logger->debug('addProviderAction');
		$em = $this->getDoctrine()->getManager();
		$searchOrga = $this->get('ginco.provider_service');
		$searchOrganism = $searchOrga->searchOrganism($inputProvider);
		$resultOrganism = json_decode($searchOrganism);
		$i = 0;
		$result = array();
		$logger->debug($inputProvider);
		while ($i < ($resultOrganism->response->numFound)) {
			$libelleCourt = $resultOrganism->response->docs[$i]->libelleCourt;
			$libelleLong = $resultOrganism->response->docs[$i]->libelleLong;
			$result[$i]['label'] = $libelleLong."-".$libelleCourt;
			$result[$i]['description'] = 0;
			//$result[$i]['description'] = $resultJson->row[0]->docs[$i]->descriptionOrganisme;
			$result[$i]['id'] = $resultOrganism->response->docs[$i]->id;
			$result[$i]['codeOrganisme'] = $resultOrganism->response->docs[$i]->codeOrganisme;
			$i++;
			
			
		}
		return new JsonResponse($result);
	}
	
}
