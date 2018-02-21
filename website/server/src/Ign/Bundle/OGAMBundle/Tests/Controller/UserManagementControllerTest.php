<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class UserManagementControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return [
			'indexAction' => [
				[
					'uri' => '/usermanagement/'
				]
			],
			'showProvidersAction' => [
				[
					'uri' => '/usermanagement/showProviders'
				]
			],
			'showProviderContentAction' => [
				[
					'uri' => '/usermanagement/showProviderContent/1'
				]
			],
			'editProviderAction' => [
				[
					'uri' => '/usermanagement/editProvider'
				]
			],
			'deleteProviderAction' => [
				[
					'uri' => '/usermanagement/deleteProvider/999'
				]
			],
			'showRolesAction' => [
				[
					'uri' => '/usermanagement/showRoles'
				]
			],
			'editRoleAction' => [
				[
					'uri' => '/usermanagement/editRole'
				]
			],
			'deleteRoleAction' => [
				[
					'uri' => '/usermanagement/deleteRole/999'
				]
			],
			'showUsersAction' => [
				[
					'uri' => '/usermanagement/showUsers'
				]
			],
			'editUserAction' => [
				[
					'uri' => '/usermanagement/editUser'
				]
			],
			'changePasswordAction' => [
				[
					'uri' => '/usermanagement/changePassword/visitor'
				]
			],
			'deleteUserAction' => [
				[
					'uri' => '/usermanagement/deleteUser/notexistinglogin'
				]
			]
		];
	}

	public function getVisitorUrls() {
		return $this->getNotLoggedUrls();
	}

	public function getAdminUrls() {
		return [
			'indexAction' => [
				[
					'uri' => '/usermanagement/'
				]
			],
			'showProvidersAction' => [
				[
					'uri' => '/usermanagement/showProviders'
				]
			],
			'showProviderContentAction' => [
				[
					'uri' => '/usermanagement/showProviderContent/1'
				]
			],
			'editProviderAction' => [
				[
					'uri' => '/usermanagement/editProvider'
				]
			],
			'deleteProviderAction' => [
				[
					'uri' => '/usermanagement/deleteProvider/999'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/usermanagement/showProviders',
					'alertMessage' => 'The provider does not exist.'
				]
			],
			'showRolesAction' => [
				[
					'uri' => '/usermanagement/showRoles'
				]
			],
			'editRoleAction' => [
				[
					'uri' => '/usermanagement/editRole'
				]
			],
			'deleteRoleAction' => [
				[
					'uri' => '/usermanagement/deleteRole/999'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/usermanagement/showRoles',
					'alertMessage' => 'The role does not exist.'
				]
			],
			'showUsersAction' => [
				[
					'uri' => '/usermanagement/showUsers'
				]
			],
			'editUserAction' => [
				[
					'uri' => '/usermanagement/editUser'
				]
			],
			'changePasswordAction' => [
				[
					'uri' => '/usermanagement/changePassword/visitor'
				]
			],
			'deleteUserAction' => [
				[
					'uri' => '/usermanagement/deleteUser/notexistinglogin'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/usermanagement/showUsers',
					'alertMessage' => 'The user does not exist.'
				]
			]
		];
	}
}
