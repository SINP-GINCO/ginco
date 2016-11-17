<?php
require_once TEST_PATH . 'ControllerTestCase.php';

/**
 * Custom ResultLocation test class.
 *
 * @author Gautam Pastakia
 */
class ResultLocationTest extends ControllerTestCase {

	private $resultLocationModel;

	private $metadataModel;

	private $db;

	private $permissions = array(
		"all" => array(
			"sensitive" => true,
			"private" => true,
			"logged" => true
		),
		"onlyPrivate" => array(
			"sensitive" => false,
			"private" => true,
			"logged" => true
		),
		"onlySensitive" => array(
			"sensitive" => true,
			"private" => false,
			"logged" => true
		),
		"none" => array(
			"sensitive" => false,
			"private" => false,
			"logged" => true
		),
		"visitor" => array(
			"sensitive" => false,
			"private" => false,
			"logged" => false
		)
	);

	/**
	 * Set up the test case.
	 *
	 * @see sources/library/Zend/Test/PHPUnit/Zend_Test_PHPUnit_ControllerTestCase::setUp()
	 */
	public function setUp() {
		parent::setUp();

		// On instancie le service
		$this->resultLocationModel = new Application_Model_Mapping_ResultLocation();
		$this->metadataModel = new Application_Model_Metadata_Metadata();

		// On initialise les entrées en base
		$this->initDb();
	}

	/**
	 * Initiates the db.
	 */
	private function initDb() {
		$this->db = Zend_Registry::get('mapping_db');
		pg_connect($this->getConnectionString());
		$sql = file_get_contents(dirname(__FILE__) . '/../../resources/insert_script_common.sql');
		pg_query($sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Clean up after the test case.
	 */
	public function tearDown() {
		parent::tearDown();
		$this->resultLocationModel = null;
		$this->metadataModel = null;
		$this->db = null;
	}

	/**
	 * Checks that results table is properly populated.
	 * Query searches for the only observation that has '88083' as the codecommunecalcule.
	 * User has all permissions (sensible and private).
	 * Result should return observation_id 1.
	 */
	public function untestFillResultsWithAllPermissions() {
		// First, clean results
		$this->resultLocationModel->cleanPreviousResults('123456789');

		// Test parameters
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$locationTable = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');
		session_id('12345');
		$stubResultLocationModel = $this->getMockResultLocationModel($this->permissions['all']);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'fillLocationResult');
		$method->setAccessible(TRUE);
		$method->invoke($stubResultLocationModel, $from, $where, '12345', $locationTable);

		// Get the request id
		$getRequestIdmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getLastRequestIdFromSession');
		$getRequestIdmethod->setAccessible(TRUE);
		$reqId = $getRequestIdmethod->invoke($stubResultLocationModel, 12345);

		// Get the results linked to the request id
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($stubResultLocationModel, $reqId);

		// Assertions
		$this->assertCount(1, $results);
		$this->assertEquals(1, $results[0]["id_observation"]);
	}

	/**
	 * Checks that results table is properly populated.
	 * Query searches for the only observation that has 88083 as the codecommunecalcule.
	 * The observation searched is private and has a diffusionniveauprecision of 3.
	 * User has only private permission.
	 * Result should return observation_id 1.
	 */
	public function untestFillResultsWithOnlyPrivatePermission() {
		// First, clean results
		$this->resultLocationModel->cleanPreviousResults('123456789');

		// Test parameters
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$locationTable = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');
		session_id('12345');
		$stubResultLocationModel = $this->getMockResultLocationModel($this->permissions['onlyPrivate']);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'fillLocationResult');
		$method->setAccessible(TRUE);
		$method->invoke($stubResultLocationModel, $from, $where, '12345', $locationTable);

		// Get the request id
		$getRequestIdmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getLastRequestIdFromSession');
		$getRequestIdmethod->setAccessible(TRUE);
		$reqId = $getRequestIdmethod->invoke($stubResultLocationModel, 12345);

		// Get the results linked to the request id
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($stubResultLocationModel, $reqId);

		// Assertions
		$this->assertCount(1, $results);
		$this->assertEquals(1, $results[0]["id_observation"]);
	}

	/**
	 * Checks that results table is properly populated.
	 * Query searches for the only observation that has 88083 as the codecommunecalcule.
	 * The observation searched is private and has a diffusionniveauprecision of 3.
	 * User has only sensible permission.
	 * No result should be returned.
	 */
	public function untestFillResultsWithOnlySensiblePermission() {
		// First, clean results
		$this->resultLocationModel->cleanPreviousResults('123456789');

		// Test parameters
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$locationTable = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');
		session_id('12345');
		$stubResultLocationModel = $this->getMockResultLocationModel($this->permissions['onlySensitive']);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'fillLocationResult');
		$method->setAccessible(TRUE);
		$method->invoke($stubResultLocationModel, $from, $where, '12345', $locationTable);

		// Get the request id
		$getRequestIdmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getLastRequestIdFromSession');
		$getRequestIdmethod->setAccessible(TRUE);
		$reqId = $getRequestIdmethod->invoke($stubResultLocationModel, 12345);

		// Get the results linked to the request id
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($stubResultLocationModel, $reqId);

		// Assertions
		$this->assertCount(0, $results);
	}

	/**
	 * Checks that results table is properly populated.
	 * Query searches for the only observation that has 88083 as the codecommunecalcule.
	 * The observation searched is private and has a diffusionniveauprecision of 3.
	 * User has no permissions.
	 * No result should be returned.
	 */
	public function untestFillResultsWithNoPermission() {
		// First, clean results
		$this->resultLocationModel->cleanPreviousResults('123456789');

		// Test parameters
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$locationTable = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');
		session_id('12345');

		// Call the method
		$stubResultLocationModel = $this->getMockResultLocationModel($this->permissions['none']);
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'fillLocationResult');
		$method->setAccessible(TRUE);
		$method->invoke($stubResultLocationModel, $from, $where, '12345', $locationTable);

		// Get the request id
		$getRequestIdmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getLastRequestIdFromSession');
		$getRequestIdmethod->setAccessible(TRUE);
		$reqId = $getRequestIdmethod->invoke($stubResultLocationModel, 12345);

		// Get the results linked to the request id
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($stubResultLocationModel, $reqId);

		// Assertions
		$this->assertCount(0, $results);
	}

	/**
	 * Checks that results table is properly populated.
	 * Query searches for the only observation that has 88083 as the codecommunecalcule.
	 * The observation searched is private and has a diffusionniveauprecision of 3.
	 * User has no permissions and is not logged in.
	 * No result should be returned.
	 */
	public function untestFillResultsWithVisitorPermissions() {
		// First, clean results
		$this->resultLocationModel->cleanPreviousResults('123456789');

		// Test parameters
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$locationTable = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');
		session_id('12345');

		// Call the method
		$stubResultLocationModel = $this->getMockResultLocationModel($this->permissions['visitor']);
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'fillLocationResult');
		$method->setAccessible(TRUE);
		$method->invoke($stubResultLocationModel, $from, $where, '12345', $locationTable);

		// Get the request id
		$getRequestIdmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getLastRequestIdFromSession');
		$getRequestIdmethod->setAccessible(TRUE);
		$reqId = $getRequestIdmethod->invoke($stubResultLocationModel, 12345);

		// Get the results linked to the request id
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($stubResultLocationModel, $reqId);

		// Assertions
		$this->assertCount(0, $results);
	}

	/**
	 * Test on getResultsFromRequestId.
	 */
	public function untestGetResultsFromRequestId() {
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$method->setAccessible(TRUE);
		$results = $method->invoke($this->resultLocationModel, 1);
		$this->assertCount(20, $results);
	}

	/**
	 * Test on getLastRequestIdFromSession.
	 */
	public function testGetLastRequestIdFromSession() {
		$requestId = $this->resultLocationModel->getLastRequestIdFromSession(123456789);
		$this->assertEquals(1, $requestId);
	}

	/**
	 * Test on getHidingLevels.
	 *
	 * Permissions : all.
	 * Diffusionniveauprecision : 3
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithAllPermissionsWithOnlyPrivateData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('12345');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '100';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(1, 1), $table, $this->permissions['all'], $from, $where, $requestId);
		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 *
	 * Permissions : only private.
	 * Diffusionniveauprecision : 3
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsslWithOnlyPrivatePermissionWithOnlyPrivateData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '200';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(1, 1), $table, $this->permissions['onlyPrivate'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 *
	 * Permissions : sensitive only.
	 * Diffusionniveauprecision : 3
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 3.
	 */
	public function testGetHidingLevelsWithOnlySensitivePermissionWithOnlyPrivateData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '300';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(1, 1), $table, $this->permissions['onlySensitive'], $from, $where, $requestId);

		$this->assertEquals(3, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 *
	 * Permissions : private only.
	 * Diffusionniveauprecision : 3
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 3.
	 */
	public function testGetHidingLevelsWithoutPermissionWithOnlyPrivateData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '400';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(1, 1), $table, $this->permissions['none'], $from, $where, $requestId);

		$this->assertEquals(3, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : visitor.
	 * Diffusionniveauprecision : 3
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 1.
	 */
	public function untestGetHidingLevelsWithVisitorPermissionsWithOnlyPrivateData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('12345');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '500';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(1, 1), $table, $this->permissions['visitor'], $from, $where, $requestId);

		$this->assertEquals(1, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 *
	 * Permissions : all permissions.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 2
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithAllPermissionsWithOnlySensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '100';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(7, 1), $table, $this->permissions['all'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only private.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 2
	 * Should return : 2.
	 */
	public function untestGetHidingLevelsWithOnlyPrivatePermissionWithOnlySensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '200';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(7, 1), $table, $this->permissions['onlyPrivate'], $from, $where, $requestId);
		$this->assertEquals(2, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only sensitive.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 2
	 * Should return : 0.
	 */
	public function untestGetHidingLevelsWithOnlySensitivePermissionWithOnlySensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '300';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(7, 1), $table, $this->permissions['onlySensitive'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : no permission.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 2
	 * Should return : 2.
	 */
	public function untestGetHidingLevelsWithoutPermissionWithOnlySensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '400';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(7, 1), $table, $this->permissions['none'], $from, $where, $requestId);

		$this->assertEquals(2, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : visitor.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 2
	 * Should return : 2.
	 */
	public function untestGetHidingLevelsWithVisitorPermissionWithOnlySensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '500';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(7, 1), $table, $this->permissions['visitor'], $from, $where, $requestId);

		$this->assertEquals(2, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : all permissions.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithAllPermissionsWithOnlyPrivateDataWithoutDfn() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '100';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(15, 1), $table, $this->permissions['all'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only private.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithOnlyPrivatePermissionWithOnlyPrivateDataWithoutDfn() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '200';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(15, 1), $table, $this->permissions['onlyPrivate'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only sensitive.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 1.
	 */
	public function untestGetHidingLevelsWithOnlySensitivePermissionWithOnlyPrivateDataWithoutDfn() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '300';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(15, 1), $table, $this->permissions['onlySensitive'], $from, $where, $requestId);

		$this->assertEquals(1, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : no permission.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 1.
	 */
	public function untestGetHidingLevelsWithoutPermissionWithOnlyPrivateDataWithoutDfn() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '400';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(15, 1), $table, $this->permissions['none'], $from, $where, $requestId);

		$this->assertEquals(1, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : visitor.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pr'
	 * sensiniveau : 0
	 * Should return : 1.
	 */
	public function untestGetHidingLevelsWithVisitorPermissionWithOnlyPrivateDataWithoutDfn() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '500';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(15, 1), $table, $this->permissions['visitor'], $from, $where, $requestId);

		$this->assertEquals(1, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : all permissions.
	 * Diffusionniveauprecision : 2
	 * dspublique : 'Pr'
	 * sensiniveau : 3
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithAllPermissionsWithPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '100';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(19, 1), $table, $this->permissions['all'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only private.
	 * Diffusionniveauprecision : 2
	 * dspublique : 'Pr'
	 * sensiniveau : 3
	 * Should return : 3.
	 */
	public function untestGetHidingLevelsWithOnlyPrivatePermissionWithPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '200';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(19, 1), $table, $this->permissions['onlyPrivate'], $from, $where, $requestId);

		$this->assertEquals(3, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only sensitive.
	 * Diffusionniveauprecision : 2
	 * dspublique : 'Pr'
	 * sensiniveau : 3
	 * Should return : 2.
	 */
	public function untestGetHidingLevelsWithOnlySensitivePermissionWithPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '300';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(19, 1), $table, $this->permissions['onlySensitive'], $from, $where, $requestId);

		$this->assertEquals(2, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : no permission.
	 * Diffusionniveauprecision : 2
	 * dspublique : 'Pr'
	 * sensiniveau : 3
	 * Should return : 3.
	 */
	public function testGetHidingLevelsWithoutPermissionWithPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '400';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(19, 1), $table, $this->permissions['none'], $from, $where, $requestId);

		$this->assertEquals(3, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : visitor.
	 * Diffusionniveauprecision : 2
	 * dspublique : 'Pr'
	 * sensiniveau : 3
	 * Should return : 3.
	 */
	public function testGetHidingLevelsWithVisitorPermissionWithPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '500';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(19, 1), $table, $this->permissions['visitor'], $from, $where, $requestId);

		$this->assertEquals(3, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : all permissions.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pu'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithAllPermissionsWithoutPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '100';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(3, 1), $table, $this->permissions['all'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only private.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pu'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function testGetHidingLevelsWithOnlyPrivatePermissionWithoutPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '200';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(3, 1), $table, $this->permissions['onlyPrivate'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : only sensitive.
	 * Diffusionniveauprecision : NULL
	 * dspublique : 'Pu'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function untestGetHidingLevelsWithOnlySensitivePermissionWithoutPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '300';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(3, 1), $table, $this->permissions['onlySensitive'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : no permission.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 0
	 * Should return : 0.
	 */
	public function untestGetHidingLevelsWithoutPermissionWithoutPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '400';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(3, 1), $table, $this->permissions['none'], $from, $where, $requestId);

		$this->assertEquals(0, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getHidingLevels.
	 * TODO correct and migrate to Symfony2
	 * Permissions : visitor.
	 * Diffusionniveauprecision : 0
	 * dspublique : 'Pu'
	 * sensiniveau : 0
	 * Should return : 1.
	 */
	public function untestGetHidingLevelsWithVisitorPermissionWithoutPrivateAndSensitiveData() {
		// Test parameters
		$table = new Application_Object_Metadata_TableFormat();
		$table->format = 'table_observation';
		$table->tableName = 'model_1_observation';
		session_id('123456789');
		$from = "FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id";
		$where = "WHERE (1 = 1) AND table_observation.codecommunecalcule && '{\"88083\"}' ";
		$requestId = '500';

		$tableValues = $this->resultLocationModel->getHidingLevels($this->getKeys(), $this->getTableValues(3, 1), $table, $this->permissions['visitor'], $from, $where, $requestId);

		$this->assertEquals(1, $tableValues[0]['hiding_level']);
	}

	/**
	 * Test on getSensibilityHidingLevel.
	 */
	public function testGetSensibilityHidingLevel() {
		// Test parameters
		$sensiNiveaux = array(
			0,
			1,
			2,
			3,
			4
		);

		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getSensibilityHidingLevel');
		$method->setAccessible(TRUE);

		foreach ($sensiNiveaux as $sensiNiveau) {
			$hidingLevel = $method->invoke($this->resultLocationModel, $sensiNiveau, $this->permissions['all']);
			$this->assertEquals(0, $hidingLevel);
		}

		foreach ($sensiNiveaux as $sensiNiveau) {
			$hidingLevel = $method->invoke($this->resultLocationModel, $sensiNiveau, $this->permissions['onlyPrivate']);
			$this->assertEquals($sensiNiveau, $hidingLevel);
		}

		foreach ($sensiNiveaux as $sensiNiveau) {
			$hidingLevel = $method->invoke($this->resultLocationModel, $sensiNiveau, $this->permissions['onlySensitive']);
			$this->assertEquals(0, $hidingLevel);
		}

		foreach ($sensiNiveaux as $sensiNiveau) {
			$hidingLevel = $method->invoke($this->resultLocationModel, $sensiNiveau, $this->permissions['none']);
			$this->assertEquals($sensiNiveau, $hidingLevel);
		}

		foreach ($sensiNiveaux as $sensiNiveau) {
			$hidingLevel = $method->invoke($this->resultLocationModel, $sensiNiveau, $this->permissions['visitor']);
			if ($sensiNiveau >= 1) {
				$this->assertEquals($sensiNiveau, $hidingLevel);
			} else {
				$this->assertEquals(1, $hidingLevel);
			}
		}
	}

	/**
	 * Test on getPrivateHidingLevel.
	 */
	public function testGetPrivateHidingLevel() {
		// Test parameters
		$diffusionNiveauxPrecision = array(
			0,
			1,
			2,
			3,
			4,
			5,
			null
		);

		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getPrivateHidingLevel');
		$method->setAccessible(TRUE);

		// All dfn. Private. All permissions => Hiding level is 0 always.
		foreach ($diffusionNiveauxPrecision as $diffusionNiveauPrecision) {
			$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', $diffusionNiveauPrecision, $this->permissions['all']);
			$this->assertEquals(0, $hidingLevel);
		}

		// All dfn. Private. Only private permission => Hiding level is 0 always.
		foreach ($diffusionNiveauxPrecision as $diffusionNiveauPrecision) {
			$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', $diffusionNiveauPrecision, $this->permissions['onlyPrivate']);
			$this->assertEquals(0, $hidingLevel);
		}

		// All dfn. Private. Only sensitive permission => Hiding level depends on value of dfn.
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 0, $this->permissions['onlySensitive']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 1, $this->permissions['onlySensitive']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 2, $this->permissions['onlySensitive']);
		$this->assertEquals(2, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 3, $this->permissions['onlySensitive']);
		$this->assertEquals(3, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 4, $this->permissions['onlySensitive']);
		$this->assertEquals(4, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 5, $this->permissions['onlySensitive']);
		$this->assertEquals(0, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', null, $this->permissions['onlySensitive']);
		$this->assertEquals(1, $hidingLevel);

		// All dfn. Private. No permission => Hiding level depends on value of dfn.
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 0, $this->permissions['none']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 1, $this->permissions['none']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 2, $this->permissions['none']);
		$this->assertEquals(2, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 3, $this->permissions['none']);
		$this->assertEquals(3, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 4, $this->permissions['none']);
		$this->assertEquals(4, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 5, $this->permissions['none']);
		$this->assertEquals(0, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', null, $this->permissions['none']);
		$this->assertEquals(1, $hidingLevel);

		// All dfn. Private. No permission and not logged => Hiding level depends on value of dfn.
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 0, $this->permissions['visitor']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 1, $this->permissions['visitor']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 2, $this->permissions['visitor']);
		$this->assertEquals(2, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 3, $this->permissions['visitor']);
		$this->assertEquals(3, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 4, $this->permissions['visitor']);
		$this->assertEquals(4, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', 5, $this->permissions['visitor']);
		$this->assertEquals(1, $hidingLevel);
		$hidingLevel = $method->invoke($this->resultLocationModel, 'Pr', null, $this->permissions['visitor']);
		$this->assertEquals(1, $hidingLevel);

		// All dfn. Public. All permissions => Hiding level is always 0.
		foreach ($diffusionNiveauxPrecision as $diffusionNiveauPrecision) {
			$hidingLevel = $method->invoke($this->resultLocationModel, 'Pu', $diffusionNiveauPrecision, $this->permissions['all']);
			$this->assertEquals(0, $hidingLevel);
		}

		// No dfn. Public. With All permissions => Hiding level is always 0 except if user is not logged in, it is 1.
		foreach ($this->permissions as $permissions) {
			if ($permissions['logged']) {
				$hidingLevel = $method->invoke($this->resultLocationModel, 'Pu', null, $permissions);
				$this->assertEquals(0, $hidingLevel);
			} else {
				$hidingLevel = $method->invoke($this->resultLocationModel, 'Pu', null, $permissions);
				$this->assertEquals(1, $hidingLevel);
			}
		}
	}

	/**
	 * Test on setHidingLevels.
	 * Check that updating the results table is effective.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestSetHidingLevels() {
		session_id('123456789');

		// Get the results linked to the request id before lauching method
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($this->resultLocationModel, 1);

		$key = array_search(1, array_column($results, 'id_observation'));
		$this->assertEquals(3, $results[$key]['hiding_level']);
		$hidingLevels = array(
			2
		);

		// Execute the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'setHidingLevels');
		$method->setAccessible(TRUE);
		$method->invoke($this->resultLocationModel, $hidingLevels, $this->getTableValues(1, 1), 'table_observation', session_id());

		// Get the results linked to the request id after lauching method
		$results = $getResultsmethod->invoke($this->resultLocationModel, 1);

		$key = array_search(1, array_column($results, 'id_observation'));
		$this->assertEquals(2, $results[$key]['hiding_level']);
	}

	/**
	 * Test on getVisuPermissions.
	 */
	public function testGetVisuPermissions() {
		$permissions = $this->resultLocationModel->getVisuPermissions();
		$this->assertFalse($permissions['sensitive']);
		$this->assertFalse($permissions['private']);
		$this->assertFalse($permissions['logged']);
	}

	/**
	 * Test on deleteUnshowableResultsFromCriterias.
	 * Test is done first on results linked to request id '1'.
	 * There are 20 results with only two rows with hiding_level of 2 and 3.
	 * After launching the method, these last two results should not appear.
	 */
	public function untestDeleteUnshowableResultsFromCriteriasWithOneCriteria() {
		$mockResultLocationModel = $this->getMockResultLocationModel($this->permissions['all']);

		// Get the results linked to the request id before lauching method
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($this->resultLocationModel, 1);

		$this->assertCount(20, $results);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'deleteUnshowableResultsFromCriterias');
		$method->setAccessible(TRUE);
		$method->invoke($mockResultLocationModel, 1);

		// Get the results linked to the request id after lauching method
		$results = $getResultsmethod->invoke($this->resultLocationModel, 1);

		$this->assertCount(18, $results);
	}

	/**
	 * Test on deleteUnshowableResultsFromCriterias.
	 * Test is done first on results linked to request id '712'.
	 * There are 20 results with three rows with hiding_level of 1 and one row of hiding_level of 2.
	 * After launching the method, the only result row with hiding_level of 2 should not appear.
	 */
	public function untestDeleteUnshowableResultsFromCriteriasWithTwoCriterias() {
		$criteriaCommune = new Application_Object_Metadata_FormField();
		$criteriaCommune->data = "codecommunecalcule";
		$criteriaCommune->value = "88083";

		$criteriaDepartement = new Application_Object_Metadata_FormField();
		$criteriaDepartement->data = "codedepartementcalcule";
		$criteriaDepartement->value = "88";

		$criterias = array(
			$criteriaCommune,
			$criteriaDepartement
		);
		$mockResultLocationModel = $this->getMockResultLocationModel($this->permissions['all'], $criterias);

		// Get the results linked to the request id before lauching method
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($this->resultLocationModel, 712);

		$this->assertCount(20, $results);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'deleteUnshowableResultsFromCriterias');
		$method->setAccessible(TRUE);
		$method->invoke($mockResultLocationModel, 712);

		// Get the results linked to the request id after lauching method
		$results = $getResultsmethod->invoke($this->resultLocationModel, 712);

		$this->assertCount(19, $results);
	}

	/**
	 * Test on deleteUnshowableResultsFromCriterias.
	 * Test is done first on results linked to request id '712'.
	 * There are 20 results with three rows with hiding_level of 1 and one row of hiding_level of 2.
	 * After launching the method, these four rows should not appear.
	 */
	public function untestDeleteUnshowableResultsFromCriteriasWithMultipleCriterias() {
		$criteriaGeometrie = new Application_Object_Metadata_FormField();
		$criteriaGeometrie->data = "geometrie";
		$criteriaGeometrie->value = null;

		$criteriaCommune = new Application_Object_Metadata_FormField();
		$criteriaCommune->data = "codecommunecalcule";
		$criteriaCommune->value = "88083";

		$criteriaDepartement = new Application_Object_Metadata_FormField();
		$criteriaDepartement->data = "codedepartementcalcule";
		$criteriaDepartement->value = "88";

		$criterias = array(
			$criteriaGeometrie,
			$criteriaCommune,
			$criteriaDepartement
		);
		$mockResultLocationModel = $this->getMockResultLocationModel($this->permissions['all'], $criterias);

		// Get the results linked to the request id before lauching method
		$getResultsmethod = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'getResultsFromRequestId');
		$getResultsmethod->setAccessible(TRUE);
		$results = $getResultsmethod->invoke($this->resultLocationModel, 712);

		$this->assertCount(20, $results);

		// Call the method
		$method = new ReflectionMethod('Application_Model_Mapping_ResultLocation', 'deleteUnshowableResultsFromCriterias');
		$method->setAccessible(TRUE);
		$method->invoke($mockResultLocationModel, 712);

		// Get the results linked to the request id after lauching method
		$results = $getResultsmethod->invoke($this->resultLocationModel, 712);

		$this->assertCount(16, $results);
	}

	/**
	 * Test on cleanPreviousResults.
	 * Used session_id has associated request_id 1.
	 * After executing method, no request id should be returned.
	 */
	public function testCleanPreviousResultsWithTrueSessionId() {
		$reqId = $this->resultLocationModel->getLastRequestIdFromSession(123456789);

		$this->assertEquals(1, $reqId);

		$this->resultLocationModel->cleanPreviousResults(123456789);
		$reqId = $this->resultLocationModel->getLastRequestIdFromSession(123456789);

		$this->assertEmpty($reqId);
	}

	/**
	 * Test on cleanPreviousResults.
	 * Used session_id has no associated requests.
	 * After executing method, check that request id 1 should be returned for session_id 123456789.
	 */
	public function testCleanPreviousResultsWithFalseSessionId() {
		$reqId = $this->resultLocationModel->getLastRequestIdFromSession(12);

		$this->assertEmpty($reqId);

		$this->resultLocationModel->cleanPreviousResults(12);
		$reqId = $this->resultLocationModel->getLastRequestIdFromSession(12);

		$this->assertEmpty($reqId);
		$reqId = $this->resultLocationModel->getLastRequestIdFromSession(123456789);

		$this->assertEquals(1, $reqId);
	}

	/**
	 * TODO
	 * Test on getResultsBbox.
	 */
	public function untestGetResultsBbox() {}

	/**
	 * Test on getResultsCount.
	 */
	public function testGetResultsCount() {
		$count = $this->resultLocationModel->getResultsCount(12);
		$this->assertEquals(0, $count);

		$count = $this->resultLocationModel->getResultsCount(123456789);
		$this->assertEquals(20, $count);
	}

	/**
	 * TODO
	 * Test on getLocationInfo.
	 */
	public function untestGetLocationInfo() {}

	/**
	 * Returns the mock object for stubbing few methods.
	 *
	 * @param Array|Boolean $permissions
	 *        	the permissions
	 * @param
	 *        	Array of Application_Object_Metadata_FormField the list of criterias. Can be null.
	 * @return PHPUnit_Framework_MockObject_MockObject
	 */
	private function getMockResultLocationModel($permissions, $criterias = null) {
		// Mock object for stubbing few methods
		$stubResultLocationModel = $this->getMockBuilder(Application_Model_Mapping_ResultLocation::class)
			->setMethods(array(
			'getVisuPermissions',
			'getSchema',
			'getQueryCriterias'
		))
			->getMock();

		// Stub for permissions
		$stubResultLocationModel->expects($this->any())
			->method('getVisuPermissions')
			->willReturn($permissions);

		// Stub for schema
		$stubResultLocationModel->expects($this->any())
			->method('getSchema')
			->willReturn('RAW_DATA');

		// Stub for query criterias
		if ($criterias == null) {
			// Stubbed criteria
			$criteria = new Application_Object_Metadata_FormField();
			$criteria->data = "codecommunecalcule";
			$criteria->value = "80083";

			$stubResultLocationModel->expects($this->any())
				->method('getQueryCriterias')
				->willReturn(array(
				$criteria
			));
		} else {
			$stubResultLocationModel->expects($this->any())
				->method('getQueryCriterias')
				->willReturn($criterias);
		}

		return $stubResultLocationModel;
	}

	/**
	 * Returns the table values used for parameters in methods calling.
	 *
	 * @param Integer $idObservation
	 * @param Integer $idProvider
	 * @return Array of String
	 */
	private function getTableValues($idObservation, $idProvider) {
		return array(
			array(
				"id_observation" => "$idObservation",
				"id_provider" => "$idProvider"
			)
		);
	}

	/**
	 * Returns the name of the primary keys used for parameters in methods calling.
	 *
	 * @return Array of String
	 */
	private function getKeys() {
		return array(
			"id_observation" => "ogam_id_table_observation",
			"id_provider" => "provider_id"
		);
	}
}