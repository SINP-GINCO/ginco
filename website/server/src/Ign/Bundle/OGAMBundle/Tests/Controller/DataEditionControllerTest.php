<?php
namespace Ign\Bundle\OGAMBundle\Tests\Controller;

use Symfony\Component\HttpFoundation\Response;

class DataEditionControllerTest extends AbstractControllerTest {

	/**
	 * @dataProvider getEditionData
	 */
	public function testGetEditFormAction($url, $defaultStatusCode) {
		$this->logIn('admin', array(
			'ROLE_ADMIN'
		));
		$this->checkControllerActionAccess($url, $defaultStatusCode);
	}
	
	public function getEditionData() {
		return [
			'ajax-get-edit-form location'=>[
			[
				[
					'uri' => '/dataedition/ajax-get-edit-form/SCHEMA/RAW_DATA/FORMAT/LOCATION_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T'
				],
				[
					'isJson' => true,
					'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-get-edit-form-95552-P6040-2-4T.json'
				]
				
			],
			 Response::HTTP_OK
			],
		'ajax-get-edit-form plot'=>[
			[
				[
					'uri' => '/dataedition/ajax-get-edit-form/SCHEMA/RAW_DATA/FORMAT/PLOT_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5'
				],
				[
					'isJson' => true,
					'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-get-edit-form-cyle-5.json'
				]
				],
			Response::HTTP_OK
			]
		];
	}
	
	// *************************************************** //
	// Access Right Tests //
	// *************************************************** //
	public function getNotLoggedUrls() {
		return $this->getAdminUrls();
	}

	public function getVisitorUrls() {
		return $this->getAdminUrls();
	}

	public function getAdminUrls() {
		return [
			'showEditDataAction' => [
				[
					'uri' => '/dataedition/show-edit-data/SCHEMA/RAW_DATA/FORMAT/PLOT_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5'
				],
				[
					'isJson' => false,
					'contentFile' => __DIR__ . '/Mock/DataEditionController/show-edit-data.json'
				]
			],
			'showAddDataAction' => [
				[
					'uri' => '/dataedition/show-add-data/SCHEMA/RAW_DATA/FORMAT/SPECIES_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5'
				],
				[
					'isJson' => false,
					'contentFile' => __DIR__ . '/Mock/DataEditionController/show-add-data.json'
				]
			],
			'ajaxGetEditFormAction' => [
				[
					'uri' => '/dataedition/ajax-get-edit-form/SCHEMA/RAW_DATA/FORMAT/PLOT_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5',
					'parameters' => [
						'page' => 1,
						'start' => 0,
						'limit' => 25
					]
				],
				[
					'isJson' => true,
					'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-get-edit-form.json'
				]
			],

			'getparametersAction' => [
				[
					'uri' => '/dataedition/getParameters'
				],
				[
					'contentFile' => __DIR__ . '/Mock/DataEditionController/getParameters.js'
				]
			],
			'ajaximageuploadAction' => [
				[
					'uri' => '/dataedition/ajaximageupload'
				],
				[
					'isJson' => true
				]
			]
		];
	}
	
	public function testDataInsertionAction(){
		$this->logIn('admin', array(
			'ROLE_ADMIN'
		));
		$this->checkControllerActionAccess( [
			[
				'uri' => '/dataedition/ajax-get-add-form/SCHEMA/RAW_DATA/FORMAT/SPECIES_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5/ID_TAXON/',
				'parameters' => [
					'page' => 1,
					'start' => 0,
					'limit' => 25
				]
			],
			[
				'isJson' => true,
				'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-get-add-form.json'
			]
		]);
		return $this->client;
	}
	
	/**
	 * 
	 * @depends testDataInsertionAction
	 */
	public function testValidation($client){
		$this->client =$client;
		$this->checkControllerActionAccess(
		[
		[ // Chained to the ajaxGetAddForm action
			'uri' => '/dataedition/ajax-validate-edit-data',
			'method' => 'POST',
			'parameters' => [
				'SPECIES_DATA__PROVIDER_ID' => 1,
				'SPECIES_DATA__PLOT_CODE' => '95552-P6040-2-4T',
				'SPECIES_DATA__CYCLE' => 5,
				'SPECIES_DATA__ID_TAXON' => 349525,
				'SPECIES_DATA__BASAL_AREA' => null,
				'SPECIES_DATA__COMMENT' => null,
				'MODE' => 'ADD'
			]
		],
		[
			'isJson' => true,
			'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-validate-edit-data.json'
		]
		]);
		return $this->client;
	}
	
	/**
	 *  @depends testValidation
	 */
	public function testDeleteDataAction($client){
		$this->client =$client;
		$this->checkControllerActionAccess([
			[
				'uri' => '/dataedition/ajax-delete-data/SCHEMA/RAW_DATA/FORMAT/SPECIES_DATA/PROVIDER_ID/1/PLOT_CODE/95552-P6040-2-4T/CYCLE/5/ID_TAXON/349525'
			],
			[
				'isJson' => true,
				'jsonFile' => __DIR__ . '/Mock/DataEditionController/ajax-delete-data.json'
			]
		]);
	}
}