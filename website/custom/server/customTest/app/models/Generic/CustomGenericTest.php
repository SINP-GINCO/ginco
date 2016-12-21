<?php
require_once TEST_PATH . 'ControllerTestCase.php';
require_once CUSTOM_APPLICATION_PATH . '/models/Generic/CustomGeneric.php';

/**
 * Custom Generic model test class.
 *
 * @author Gautam Pastakia
 */
class CustomGenericTest extends ControllerTestCase {

	private $genericModel;

	private $metadataModel;

	private $genericService;

	private $db;

	private $hidingValue;

	private $fields = array(
		'table_observation__geometrie',
		'table_observation__nomcommune',
		'table_observation__nomcommunecalcule',
		'table_observation__codecommune',
		'table_observation__codecommunecalcule',
		'table_observation__codemaille',
		'table_observation__codemaillecalcule',
		'table_observation__codedepartement',
		'table_observation__codedepartementcalcule'
	);

	/**
	 * Set up the test case.
	 *
	 * @see sources/library/Zend/Test/PHPUnit/Zend_Test_PHPUnit_ControllerTestCase::setUp()
	 */
	public function setUp() {
		parent::setUp();

		// On instancie les objets
		$this->genericModel = new Custom_Application_Model_Generic_Generic();
		$this->metadataModel = new Application_Model_Metadata_Metadata();
		$this->genericService = new Application_Service_GenericService();

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
		$sql = file_get_contents(dirname(__FILE__) . '/../../resources/insert_script_common.sql');
		pg_query($sql) or die('Request failed: ' . pg_last_error());
	}

	/**
	 * Clean up after the test case.
	 */
	public function tearDown() {
		parent::tearDown();
		$this->genericModel = null;
		$this->metadataModel = null;
		$this->genericService = null;
		$this->db = null;
	}

	/**
	 * Test on getDatum.
	 * User has all permissions.
	 * Set of results is linked with session_id : 111.
	 * For row with id 1 (private level 3, sensitive level 0): no value should be hidden.
	 * For row with id 7 (private level 0, sensitive level 2): no value should be hidden.
	 * For row with id 15 (private level null, sensitive level 0): no value should be hidden.
	 * For row with id 19 (private level 2, sensitive level 0):no value should be hidden.
	 * For row with id 2 (private level 0, sensitive level 0): no value should be hidden.
	 *
	 * Some assertions are not tested because values of the fields are empty.
	 */
	public function testGetDatumWithAllPermissions() {
		// Test parameters
		session_id(111);
		$data = $this->genericService->buildDataObject('RAW_DATA', 'table_observation', null);
		$data->infoFields['table_observation__PROVIDER_ID']->value = 1;
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "1";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "7";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "15";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			if (!empty($data->editableFields[$field]->value)) {
				$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
			}
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "19";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "2";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}
	}

	/**
	 * Test on getDatum.
	 * User has only private permission.
	 * Set of results is linked with session_id : 222.
	 * For row with id 1 (private level 3, sensitive level 0): no value should be hidden.
	 * For row with id 7 (private level 0, sensitive level 2): values up to codemaille should be hidden.
	 * For row with id 15 (private level null, sensitive level 0): values up to commune should be hidden.
	 * For row with id 19 (private level 2, sensitive level 0): no value should be hidden.
	 * For row with id 2 (private level 0, sensitive level 0): no value should be hidden.
	 *
	 * Some assertions are not tested because values of the fields are empty.
	 */
	public function testGetDatumWithOnlyPrivatePermission() {
		// Test parameters
		session_id(222);
		$data = $this->genericService->buildDataObject('RAW_DATA', 'table_observation', null);
		$data->infoFields['table_observation__PROVIDER_ID']->value = 1;
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "1";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "7";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "15";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "19";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "2";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}
	}

	/**
	 * Test on getDatum.
	 * User has only sensitive permission.
	 * Set of results is linked with session_id : 333.
	 * For row with id 1 (private level 3, sensitive level 0): values up to departement should be hidden.
	 * For row with id 7 (private level 0, sensitive level 2): no value should be hidden.
	 * For row with id 15 (private level null, sensitive level 0): values up to commune should be hidden.
	 * For row with id 19 (private level 2, sensitive level 0): values up to maille should be hidden.
	 * For row with id 2 (private level 0, sensitive level 0): no value should be hidden.
	 *
	 * Some assertions are not tested because values of the fields are empty.
	 */
	public function testGetDatumWithOnlySensitivePermission() {
		// Test parameters
		session_id(333);
		$data = $this->genericService->buildDataObject('RAW_DATA', 'table_observation', null);
		$data->infoFields['table_observation__PROVIDER_ID']->value = 1;
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "1";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "7";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "15";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "19";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "2";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}
	}

	/**
	 * Test on getDatum.
	 * User has no permission.
	 * Set of results is linked with session_id : 444.
	 * For row with id 1 (private level 3, sensitive level 0): values up to departement should be hidden.
	 * For row with id 7 (private level 0, sensitive level 2): values up to maille should be hidden.
	 * For row with id 15 (private level null, sensitive level 0): values up to commune should be hidden.
	 * For row with id 19 (private level 2, sensitive level 0): values up to maille should be hidden.
	 * For row with id 2 (private level 0, sensitive level 0): no value should be hidden.
	 *
	 * Some assertions are not tested because values of the fields are empty.
	 */
	public function testGetDatumWithoutPermissions() {
		// Test parameters
		session_id(444);
		$data = $this->genericService->buildDataObject('RAW_DATA', 'table_observation', null);
		$data->infoFields['table_observation__PROVIDER_ID']->value = 1;
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "1";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "7";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "15";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "19";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "2";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		foreach ($this->fields as $field) {
			$this->assertNotContains($this->ĥidingValue, $data->editableFields[$field]->value);
		}
	}

	/**
	 * Test on getDatum.
	 * User is not logged in.
	 * Set of results is linked with session_id : 555.
	 * For row with id 1 (private level 3, sensitive level 0): values up to departement should be hidden.
	 * For row with id 7 (private level 0, sensitive level 2): values up to maille should be hidden.
	 * For row with id 15 (private level null, sensitive level 0): values up to commune should be hidden.
	 * For row with id 19 (private level 2, sensitive level 0): values up to maille should be hidden.
	 * For row with id 2 (private level 0, sensitive level 0): values up to commune should be hidden..
	 *
	 * Some assertions are not tested because values of the fields are empty.
	 */
	public function testGetDatumWithVisitorPermissions() {
		// Test parameters
		session_id(555);
		$data = $this->genericService->buildDataObject('RAW_DATA', 'table_observation', null);
		$data->infoFields['table_observation__PROVIDER_ID']->value = 1;
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "1";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "7";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "15";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "19";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);

		// Test parameters
		$data->infoFields['table_observation__OGAM_ID_table_observation']->value = "2";

		// Call the method
		$this->genericModel->getDatum($data);

		// Assertions
		$this->assertContains($this->ĥidingValue, $data->editableFields['table_observation__geometrie']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__nomcommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommune']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codecommunecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaille']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codemaillecalcule']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartement']->value);
		$this->assertNotContains($this->ĥidingValue, $data->editableFields['table_observation__codedepartementcalcule']->value);
	}

	/**
	 * Test on getRawDataTablePrimaryKeys.
	 */
	public function testGetRawDataTablePrimaryKeys() {
		$table = $this->metadataModel->getTableFormat('RAW_DATA', 'table_observation');

		$primaryKeys = $this->genericModel->getRawDataTablePrimaryKeys($table);

		$this->assertCount(2, $primaryKeys);
		$this->assertEquals('provider_id', $primaryKeys['id_provider']);
		$this->assertEquals('ogam_id_table_observation', $primaryKeys['id_observation']);
	}
}