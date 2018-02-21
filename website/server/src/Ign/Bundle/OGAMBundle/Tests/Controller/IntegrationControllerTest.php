<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class IntegrationControllerTest extends AbstractControllerTest {
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return [
			'integration' => [
				[
					'uri' => '/integration/'
				]
			],
			'show-data-submission-page' => [
				[
					'uri' => '/integration/show-data-submission-page'
				]
			],
			'create-data-submission' => [
				[
					'uri' => '/integration/create-data-submission'
				]
			],
			'show-upload-data' => [
				[
					'uri' => '/integration/show-upload-data/1'
				]
			],
			'validate-upload-data' => [
				[
					'uri' => '/integration/validate-upload-data/1'
				]
			],
			'cancel-data-submission' => [
				[
					'uri' => '/integration/cancel-data-submission'
				]
			],
			'check-submission' => [
				[
					'uri' => '/integration/check-submission'
				]
			],
			'validate-data' => [
				[
					'uri' => '/integration/validate-data'
				]
			],
			'get-data-status' => [
				[
					'uri' => '/integration/get-data-status'
				]
			],
			'check-data-status' => [
				[
					'uri' => '/integration/check-data-status'
				]
			],
			'export-file-model' => [
				[
					'uri' => '/integration/export-file-model'
				]
			]
		];
	}

	public function getVisitorUrls() {
		return $this->getNotLoggedUrls();
	}

	public function getAdminUrls() {
		return [
			'integration' => [
				[
					'uri' => '/integration/'
				]
			],
			'show-data-submission-page' => [
				[
					'uri' => '/integration/show-data-submission-page'
				]
			],
			'create-data-submission' => [
				[
					'uri' => '/integration/create-data-submission'
				]
			],
			'show-upload-data' => [
				[
					'uri' => '/integration/show-upload-data/1'
				]
			],
			'validate-upload-data' => [
				[
					'uri' => '/integration/validate-upload-data/1'
				],
				[
					'statusCode' => Response::HTTP_FOUND,
					'redirectionLocation' => '/integration/'
				]
			],
			'cancel-data-submission' => [
				[
					'uri' => '/integration/cancel-data-submission'
				]
			],
			'check-submission' => [
				[
					'uri' => '/integration/check-submission'
				]
			],
			'validate-data' => [
				[
					'uri' => '/integration/validate-data'
				]
			],
			'get-data-status' => [
				[
					'uri' => '/integration/get-data-status'
				]
			],
			'check-data-status' => [
				[
					'uri' => '/integration/check-data-status'
				]
			],
			'export-file-model' => [
				[
					'uri' => '/integration/export-file-model?fileFormat=LOCATION_FILE'
				]
			]
		];
	}
}