<?php
require_once TEST_PATH . 'ControllerTestCase.php';
require_once CUSTOM_APPLICATION_PATH . '/services/CustomQueryService.php';

/**
 * Custom ResultLocation test class.
 */
class CustomQueryServiceTest extends ControllerTestCase {

	private $queryService;

	private $db;

	private $hidingValue;

	/**
	 * Set up the test case.
	 *
	 * @see sources/library/Zend/Test/PHPUnit/Zend_Test_PHPUnit_ControllerTestCase::setUp()
	 */
	public function setUp() {
		parent::setUp();

		// On instancie le service
		$this->queryService = new Custom_Application_Service_QueryService('RAW_DATA');

		// On initialise les entrées en base
		$this->initDb();

		$configuration = Zend_Registry::get("configuration");
		$this->ĥidingValue = $configuration->getConfig('hiding_value');
	}

	/**
	 * Initiates the db.
	 */
	private function initDb() {
		$this->db = Zend_Registry::get('mapping_db');
		pg_connect($this->getConnectionString());
		$sql = file_get_contents(dirname(__FILE__) . '/../resources/insert_script_common.sql');
		pg_query($sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Clean up after the test case.
	 */
	public function tearDown() {
		parent::tearDown();
		$this->queryService = null;
		$this->db = null;
	}

	/**
	 * Test on getResultRowsCustom.
	 * User has all permissions.
	 * Set of results data is linked with request id 100.
	 * No value should be hidden.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomWithAllPermissions() {
		// Test Parameters
		$requestId = 100;
		$websiteSession = $this->getWebsiteSession($requestId);

		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);

		// Search the array with observation_id 1.
		$key = array_search(1, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(1, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 7.
		$key = array_search(7, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(7, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 15.
		$key = array_search(15, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(15, $results['rows'][$key][0]);
		// The geometrie (there is no geometry for this observation)
		$this->assertEmpty(0, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 19.
		$key = array_search(19, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(19, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);
	}
	
	/**
	 * Test on getResultRowsCustom.
	 * User has all permissions.
	 * Set of results data is linked with request id 100.
	 * No value should be hidden.
	 * Values must be ordered by observateuridentite
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomSort() {
		// Test Parameters
		$requestId = 101;
		$websiteSession = $this->getWebsiteSessionSort($requestId);
	
		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);
	
		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);
		
		// The observateuridentite
		$this->assertEquals(null, $results['rows'][0][1]);
		$this->assertEquals("Bloody BEETROOTS", $results['rows'][1][1]);
	}

	/**
	 * Test on getResultRowsCustom.
	 * User has only private permission.
	 * Set of results data is linked with request id 200.
	 * Some values should be hidden.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomWithOnlyPrivatePermission() {
		// Test Parameters
		$requestId = 200;
		$websiteSession = $this->getWebsiteSession($requestId);

		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);

		// Search the array with observation_id 1.
		$key = array_search(1, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(1, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 7.
		$key = array_search(7, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(7, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 15.
		$key = array_search(15, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(15, $results['rows'][$key][0]);
		// The geometrie (there is no geometry for this observation)
		$this->assertEmpty(0, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 19.
		$key = array_search(19, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(19, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);
	}

	/**
	 * Test on getResultRowsCustom.
	 * User has only sensitive permission.
	 * Set of results data is linked with request id 300.
	 * Some values should be hidden.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomWithOnlySensitivePermission() {
		// Test Parameters
		$requestId = 300;
		$websiteSession = $this->getWebsiteSession($requestId);

		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);

		// Search the array with observation_id 1.
		$key = array_search(1, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(1, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 7.
		$key = array_search(7, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(7, $results['rows'][$key][0]);
		// The geometrie
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 15.
		$key = array_search(15, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(15, $results['rows'][$key][0]);
		// The geometrie (there is no geometry for this observation)
		$this->assertEmpty(0, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 19.
		$key = array_search(19, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(19, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);
	}

	/**
	 * Test on getResultRowsCustom.
	 * User has no permissions.
	 * Set of results data is linked with request id 400.
	 * Some values should be hidden.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomWithoutPermissions() {
		// Test Parameters
		$requestId = 400;
		$websiteSession = $this->getWebsiteSession($requestId);

		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);

		// Search the array with observation_id 1.
		$key = array_search(1, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(1, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 7.
		$key = array_search(7, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(7, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 15.
		$key = array_search(15, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(15, $results['rows'][$key][0]);
		// The geometrie (there is no geometry for this observation)
		$this->assertEmpty(0, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 19.
		$key = array_search(19, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(19, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);
	}

	/**
	 * Test on getResultRowsCustom.
	 * User has visitor permissions.
	 * Set of results data is linked with request id 500.
	 * Some values should be hidden.
	 * TODO correct and migrate to Symfony2
	 */
	public function untestGetResultRowsCustomWithVisitorPermissions() {
		// Test Parameters
		$requestId = 500;
		$websiteSession = $this->getWebsiteSession($requestId);

		$json = $this->queryService->getResultRowsCustom(0, 20, null, null, $requestId, $websiteSession);
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertEquals(20, $results['total']);
		$this->assertCount(20, $results['rows']);

		// Search the array for observation_id 1.
		$key = array_search(1, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(1, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 7.
		$key = array_search(7, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(7, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 15.
		$key = array_search(15, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(15, $results['rows'][$key][0]);
		// The geometrie (there is no geometry for this observation)
		$this->assertEmpty(0, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains("VOSGES (88)", $results['rows'][$key][4][0]);

		// Search the array for observation_id 19.
		$key = array_search(19, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(19, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);

		// Search the array for observation_id 2 nothing special)
		$key = array_search(2, array_column($results['rows'], 0));

		// The observation_id
		$this->assertEquals(2, $results['rows'][$key][0]);
		// The geometrie
		$this->assertContains($this->ĥidingValue, $results['rows'][$key][1]);
		// The codecommunecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][2]);
		// The codemaillecalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][3]);
		// The codedepartementcalcule
		$this->assertNotContains($this->ĥidingValue, $results['rows'][$key][4][0]);
	}

	/**
	 * Test on getResultColumnsCustom.
	 * Test that the function works correctly after being customized.
	 * Test that asked results are in the json returned.
	 */
	public function testGetResultColumnsCustom() {
		// Test parameters
		$datasetId = "dataset_1";
		$formQuery = $this->getFormQuery();
		$maxPrecisionLevel = 1;
		$idRequest = 1;

		$json = $this->queryService->getResultColumnsCustom($datasetId, $formQuery, $maxPrecisionLevel, $idRequest, $this->getWebsiteSession($idRequest));
		$results = json_decode($json, true);

		$this->assertEquals(1, $results['success']);
		$this->assertCount(5, $results['root']);
		$key = array_search('codecommunecalcule', array_column($results['root'], 'data'));
		$this->assertNotNull($results['root'][$key]);
		$key = array_search('OGAM_ID_table_observation', array_column($results['root'], 'data'));
		$this->assertNotNull($results['root'][$key]);
		$key = array_search('location_centroid', array_column($results['root'], 'data'));
		$this->assertNotNull($results['root'][$key]);
	}

	/**
	 * Test on getMaxPrecisionLevel.
	 */
	public function testGetMaxPrecisionLevelWithoutCriterias() {
		$level = $this->queryService->getMaxPrecisionLevel(array());
		$this->assertEquals(1000, $level);
	}

	/**
	 * Test on getMaxPrecisionLevel.
	 * Criterias are geometrie and codedepartement.
	 */
	public function testGetMaxPrecisionLevelWithDifferentLevelCriterias() {
		// Test parameters
		$names = array(
			"geometrie",
			"codedepartement"
		);
		$level = $this->queryService->getMaxPrecisionLevel($this->getCriterias($names));
		$this->assertEquals(0, $level);
	}

	/**
	 * Test on getMaxPrecisionLevel.
	 * Criterias are codecommune and codecommunecalcule.
	 */
	public function testGetMaxPrecisionLevelWithSameLevelCriterias() {
		// Test parameters
		$names = array(
			"codecommune",
			"codecommunecalcule"
		);
		$level = $this->queryService->getMaxPrecisionLevel($this->getCriterias($names));
		$this->assertEquals(1, $level);
	}

	/**
	 * Test on getMaxPrecisionLevel.
	 * Criterias are codemaillecalcule.
	 */
	public function testGetMaxPrecisionLevelWithOneCriterias() {
		// Test parameters
		$names = array(
			"codemaillecalcule"
		);
		$level = $this->queryService->getMaxPrecisionLevel($this->getCriterias($names));
		$this->assertEquals(2, $level);
	}

	/**
	 * Test on shouldValueBeHidden.
	 * The column is more precise than the hiding_level.
	 * The value should be hidden.
	 */
	public function testShouldValueBeHiddenMorePreciseColumn() {
		$method = new ReflectionMethod('Custom_Application_Service_QueryService', 'shouldValueBeHidden');
		$method->setAccessible(TRUE);
		$result = $method->invoke($this->queryService, "geometrie", 2);
		$this->assertTrue($result);
	}

	/**
	 * Test on shouldValueBeHidden.
	 * The column is as precise as the hiding_level.
	 * The value should not be hidden.
	 */
	public function testShouldValueBeHiddenSameLevelOfPrecisionColumn() {
		$method = new ReflectionMethod('Custom_Application_Service_QueryService', 'shouldValueBeHidden');
		$method->setAccessible(TRUE);
		$result = $method->invoke($this->queryService, "geometrie", 0);
		$this->assertNull($result);
	}

	/**
	 * Test on shouldValueBeHidden.
	 * The column is as precise as the hiding_level.
	 * The value should not be hidden.
	 */
	public function testShouldValueBeHiddenLessPreciseolumn() {
		$method = new ReflectionMethod('Custom_Application_Service_QueryService', 'shouldValueBeHidden');
		$method->setAccessible(TRUE);
		$result = $method->invoke($this->queryService, "codemaille", 1);
		$this->assertNull($result);
	}

	/**
	 * TODO
	 * Test on getDetailsCustom.
	 */
	public function untestGetDetailsCustom() {}

	/**
	 * TODO
	 * Test on getDetailsDataCustom.
	 */
	public function untestGetDetailsDataCustom() {}

	/**
	 * TODO
	 * Test on prepareResultLocationsCustom.
	 */
	public function untestPrepareResultLocationsCustom() {}

	/**
	 * Returns a basic stub website session object.
	 *
	 * @param Integer $requestId
	 * @return Zend_Session_Namespace
	 */
	private function getWebsiteSession($requestId) {
		$websiteSession = new Zend_Session_Namespace('website');
		$websiteSession->SQLSelect = "SELECT DISTINCT table_observation.ogam_id_table_observation as table_observation__OGAM_ID_table_observation,
			table_observation.geometrie as table_observation__geometrie,
			table_observation.codecommunecalcule as table_observation__codecommunecalcule, table_observation.codemaillecalcule as table_observation__codemaillecalcule,
			'SCHEMA/RAW_DATA/FORMAT/table_observation' || '/' || 'OGAM_ID_table_observation/' ||table_observation.OGAM_ID_table_observation || '/' || 'PROVIDER_ID/' ||table_observation.PROVIDER_ID as id,
			table_observation.codedepartementcalcule as table_observation__codedepartementcalcule,
			table_observation.OGAM_ID_table_observation,table_observation.PROVIDER_ID, hiding_level ";
		$websiteSession->SQLPkey = " table_observation.OGAM_ID_table_observation, table_observation.PROVIDER_ID ";
		$websiteSession->SQLFrom = " FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id ";
		$websiteSession->SQLFromJoinResults = " FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id,
			LEFT JOIN mapping.results ON results.id_observation = table_observatioN.ogam_id_table_observation AND results.id_provider = table_observation.provider_id";
		$websiteSession->SQLWhere = " WHERE (1 = 1) AND table_observation.sensiniveau IN ('0', '1', '2', '3', '4')
			AND table_observation.OGAM_ID_table_observation = results.id_observation AND table_observation.PROVIDER_ID = results.id_provider
			AND table_format = 'table_observation' AND hiding_level <= 1000 AND id_request = " . $requestId;
		$websiteSession->SQLAndWhere = "";
		$websiteSession->count = 20;
		$websiteSession->resultColumns = $this->getResultColumns();

		return $websiteSession;
	}
	
	/**
	 * Returns a basic stub website session object for sort request.
	 *
	 * @param Integer $requestId
	 * @return Zend_Session_Namespace
	 */
	private function getWebsiteSessionSort($requestId) {
		$websiteSession = new Zend_Session_Namespace('website');
		
		$websiteSession->SQLSelect = "SELECT DISTINCT table_observation.ogam_id_table_observation as table_observation__OGAM_ID_table_observation,
			table_observation.observateuridentite as table_observation__observateuridentite, 
			'SCHEMA/RAW_DATA/FORMAT/table_observation' || '/' || 'OGAM_ID_table_observation/' ||table_observation.OGAM_ID_table_observation || '/' || 'PROVIDER_ID/' ||table_observation.PROVIDER_ID as id,
			 table_observation.OGAM_ID_table_observation,table_observation.PROVIDER_ID,
			 coalesce(table_observation.observateuridentite, '') ,
			 hiding_level ";
		$websiteSession->SQLPkey = " table_observation.OGAM_ID_table_observation, table_observation.PROVIDER_ID ";
		$websiteSession->SQLFrom = " FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id ";
		$websiteSession->SQLFromJoinResults = " FROM model_1_observation table_observation LEFT JOIN RAW_DATA.submission ON submission.submission_id = table_observation.submission_id,
			LEFT JOIN mapping.results ON results.id_observation = table_observatioN.ogam_id_table_observation AND results.id_provider = table_observation.provider_id";
		$websiteSession->SQLWhere = " WHERE (1 = 1) AND table_observation.sensiniveau IN ('0', '1', '2', '3', '4')
			AND table_observation.OGAM_ID_table_observation = results.id_observation AND table_observation.PROVIDER_ID = results.id_provider
			AND table_format = 'table_observation' AND hiding_level <= 1000 AND id_request = " . $requestId;
		$websiteSession->SQLAndWhere = "";
		$websiteSession->count = 20;
		$websiteSession->resultColumns = $this->getResultSort();
	
		return $websiteSession;
	}
	

	/**
	 * Returns a a basic stub resultColunmns array.
	 *
	 * @return Application_Object_Metadata_TableField[]
	 */
	private function getResultColumns() {
		$columnId = new Application_Object_Metadata_TableField();
		$columnId->columnName = "ogam_id_table_observation";
		$columnId->unit = "IDString";
		$columnId->type = "STRING";
		$columnId->format = "table_observation";
		$columnId->data = "ogam_id_table_observation";

		$columnGeometrie = new Application_Object_Metadata_TableField();
		$columnGeometrie->columnName = "geometrie";
		$columnGeometrie->unit = "GEOM";
		$columnGeometrie->type = "GEOM";
		$columnGeometrie->subtype = "GEOM";
		$columnGeometrie->format = "table_observation";
		$columnGeometrie->data = "geometrie";

		$columnCodeCommune = new Application_Object_Metadata_TableField();
		$columnCodeCommune->columnName = "codecommunecalcule";
		$columnCodeCommune->unit = "CodeCommuneCalculeValue";
		$columnCodeCommune->type = "ARRAY";
		$columnCodeCommune->subtype = "DYNAMIC";
		$columnCodeCommune->format = "table_observation";
		$columnCodeCommune->data = "codecommunecalcule";

		$columnCodeMaille = new Application_Object_Metadata_TableField();
		$columnCodeMaille->columnName = "codemaillecalcule";
		$columnCodeMaille->unit = "CodeMailleCalculeValue";
		$columnCodeMaille->type = "ARRAY";
		$columnCodeMaille->subtype = "DYNAMIC";
		$columnCodeMaille->format = "table_observation";
		$columnCodeMaille->data = "codemaillecalcule";

		$columnCodeDepartement = new Application_Object_Metadata_TableField();
		$columnCodeDepartement->columnName = "codedepartementcalcule";
		$columnCodeDepartement->unit = "CodeDepartementCalculeValue";
		$columnCodeDepartement->type = "ARRAY";
		$columnCodeDepartement->subtype = "DYNAMIC";
		$columnCodeDepartement->format = "table_observation";
		$columnCodeDepartement->data = "codedepartementcalcule";

		return array(
			"table_observation__OGAM_ID_table_observation" => $columnId,
			"table_observation__geometrie" => $columnGeometrie,
			"table_observation__codecommunecalcule" => $columnCodeCommune,
			"table_observation__codemaillecalcule" => $columnCodeMaille,
			"table_observation__codedepartementcalcule" => $columnCodeDepartement
		);
	}

	/**
	 * Returns a sort stub resultColunmns array.
	 *
	 * @return Application_Object_Metadata_TableField[]
	 */
	private function getResultSort() {
		$columnId = new Application_Object_Metadata_TableField();
		$columnId->columnName = "ogam_id_table_observation";
		$columnId->unit = "IDString";
		$columnId->type = "STRING";
		$columnId->format = "table_observation";
		$columnId->data = "ogam_id_table_observation";
	
		$columnObservateuridentite = new Application_Object_Metadata_TableField();
		$columnObservateuridentite->columnName = "observateuridentite";
		$columnObservateuridentite->unit = "CharacterString";
		$columnObservateuridentite->type = "STRING";
		$columnObservateuridentite->subtype = null;
		$columnObservateuridentite->format = "table_observation";
		$columnObservateuridentite->data = "observateuridentite";
	
		return array(
			"table_observation__OGAM_ID_table_observation" => $columnId,
			"table_observation__observateur_identite" => $columnObservateuridentite
		);
	}
	
	/**
	 * Returns a basic form query stub object.
	 *
	 * @return Application_Object_Generic_FormQuery
	 */
	private function getFormQuery() {
		$formQuery = new Application_Object_Generic_FormQuery();
		$formQuery->datasetId = 'dataset_1';

		$criteriaCommune = new Application_Object_Metadata_FormField();
		$criteriaCommune->data = "codecommunecalcule";
		$criteriaCommune->value = array(
			"88083"
		);
		$criteriaCommune->format = "form_localisation";

		$criterias = array(
			$criteriaCommune
		);

		$formQuery->criterias = $criterias;

		$resultId = new Application_Object_Metadata_FormField();
		$resultId->data = "OGAM_ID_table_observation";
		$resultId->format = "form_autres";

		$resultCommune = new Application_Object_Metadata_FormField();
		$resultCommune->data = "codecommunecalcule";
		$resultCommune->format = "form_localisation";

		$results = array(
			$resultId,
			$resultCommune
		);

		$formQuery->results = $results;

		return $formQuery;
	}

	/**
	 * Returns an array of criterias.
	 *
	 * @param
	 *        	Array of String $names data values of the criterias wanted
	 */
	private function getCriterias($names) {
		$criterias = array();
		foreach ($names as $name) {
			$criteria = new Application_Object_Metadata_FormField();
			$criteria->data = $name;
			array_push($criterias, $criteria);
		}
		return $criterias;
	}
}