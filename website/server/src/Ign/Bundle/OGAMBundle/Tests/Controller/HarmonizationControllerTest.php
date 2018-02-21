<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class HarmonizationControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return [
			'indexAction' => [
				[
					'uri' => '/harmonization/'
				]
			],
			'showHarmonizationPageAction' => [
				[
					'uri' => '/harmonization/show-harmonization-page'
				]
			],
			'launchHarmonizationAction' => [
				[
					'uri' => '/harmonization/launch-harmonization'
				]
			],
			'removeHarmonizationDataAction' => [
				[
					'uri' => '/harmonization/remove-harmonization-data'
				]
			],
			'getStatusAction' => [
				[
					'uri' => '/harmonization/get-status'
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
					'uri' => '/harmonization/'
				]
			],
			'showHarmonizationPageAction' => [
				[
					'uri' => '/harmonization/show-harmonization-page'
				]
			],
			'removeHarmonizationDataAction' => [
				[
					'uri' => '/harmonization/remove-harmonization-data',
					'method' => 'GET',
					'parameters' => [
						'DATASET_ID' => 'TREES',
						'PROVIDER_ID' => 1
					]
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/harmonization/show-harmonization-page'
				]
			],
			'launchHarmonizationAction' => [
				[
					'uri' => '/harmonization/launch-harmonization',
					'method' => 'GET',
					'parameters' => [
						'DATASET_ID' => 'TREES',
						'PROVIDER_ID' => 1
					]
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/harmonization/show-harmonization-page'
				]
			],
			'getStatusAction' => [
				[
					'uri' => '/harmonization/get-status',
					'method' => 'POST',
					'parameters' => [
						'DATASET_ID' => 'TREES',
						'PROVIDER_ID' => 1,
						'action' => 'status'
					]
				],
				[
					'isJson' => true
				]
			]
		];
	}
}