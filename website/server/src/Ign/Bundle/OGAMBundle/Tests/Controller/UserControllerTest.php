<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class UserControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	
	/**
	 * Test access without login
	 * @dataProvider getAdminUrls
	 */
	public function testControllerActionNotLoggedAccess() {
		$this->checkControllerActionAccess(func_get_args(), Response::HTTP_OK);
	}

	/**
	 * Test access with a visitor login
	 * @dataProvider getAdminUrls
	 */
	public function testControllerActionVisitorAccess() {
		$this->logIn('visitor', array(
			'ROLE_VISITOR'
		)); // The session must be keeped for the chained requests
		$this->checkControllerActionAccess(func_get_args(), Response::HTTP_OK);
	}

	public function getAdminUrls() {
		return [
			'indexAction' => [
				[
					'uri' => '/user/'
				]
			],
			'showLoginFormAction' => [
				[
					'uri' => '/user/login'
				]
			],
			'validateLoginAction' => [
				[
					'uri' => '/user/validateLogin'
				]
			],
			'changePasswordAction' => [
				[
					'uri' => '/user/changePassword'
				]
			],
			'logoutAction' => [
				[
					'uri' => '/user/logout'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => 'http://localhost/'
				]
			]
		];
	}
}
