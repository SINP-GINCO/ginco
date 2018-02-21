<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class ProxyControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return [
			'indexAction' => [
				[
					'uri' => '/proxy/'
				]
			],
			'showReportAction' => [
				[
					'uri' => '/proxy/show-report'
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
					'uri' => '/proxy/'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/'
				]
			],
			'showReportAction' => [
				[
					'uri' => '/proxy/show-report',
					'parameters' => [
						'submissionId' => 2
					]
				]
			]
		];
	}
}
