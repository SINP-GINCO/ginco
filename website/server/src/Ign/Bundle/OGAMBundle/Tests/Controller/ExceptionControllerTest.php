<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class ExceptionControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return $this->getAdminUrls();
	}

	public function getVisitorUrls() {
		return $this->getAdminUrls();
	}
	
	// See : https://symfony.com/doc/current/controller/error_pages.html#testing-error-pages
	public function getAdminUrls() {
		return [
			'index_403' => [
				[
					'uri' => '/_error/403'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			],
			'index_404' => [
				[
					'uri' => '/_error/404'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			],
			'index_500' => [
				[
					'uri' => '/_error/500'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			],
			'index_403_json' => [
				[
					'uri' => '/_error/403.json'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			],
			'index_404_json' => [
				[
					'uri' => '/_error/404.json'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			],
			'index_500_json' => [
				[
					'uri' => '/_error/500.json'
				],
				[
					'statusCode' => Response::HTTP_OK
				]
			]
		];
	}
}