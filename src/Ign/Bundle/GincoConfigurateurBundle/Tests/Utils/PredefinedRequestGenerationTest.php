<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Utils;

use Ign\Bundle\GincoConfigurateurBundle\Utils\TablesGeneration;
use Symfony\Component\Config\FileLocator;
use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration;

/**
 * Unit Tests for PredefinedRequest class
 */
class PredefinedRequestTest extends WebTestCase {

	/**
	 *
	 * Connection to the database via PDO
	 *
	 * @var
	 */
	protected $dbconn;

	/**
	 * Instanciates the unit_test db with data.
	 * Purges it before.
	 */
	public static function setUpBeforeClass() {
		// Launch kernel in order to get connection
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');

		// Create a specific admin connection to execute admin necessary privileges script
		$adminName = $container->getParameter('database_admin_user');
		$adminPassword = $container->getParameter('database_admin_password');
		$adminDbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $adminName . " password=" . $adminPassword) or die('Connection is impossible : ' . pg_last_error());

		// Execute insert scripts
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_predefined_request_service.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/create_predefined_request_tables.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();
		$conn = $container->get('database_connection');
		$this->dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$this->prg = $container->get('app.predefinedrequestgeneration');
		$this->mu = $container->get('app.modelunpublication');
	}

	/**
	 * Test the connection
	 */
	public function testGetConnection() {
		$sql = "SELECT 1::integer";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['int4']);
	}

	/**
	 * Test predefined request group creation
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration::addPredefinedRequestGroup
	 */
	public function testAddPredefinedRequestGroup() {
		$this->prg->addPredefinedRequestGroup('dataset_2_predefined', 'dataset_2_predefined', 'dataset_2_predefined', '1', $this->dbconn);

		$sql = "select count(group_name), group_name
				from website.predefined_request_group
				group by group_name";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['count']);
		$this->assertTrue($row['group_name'] == 'dataset_2_predefined');
	}

	/**
	 * Test predefined request creation
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration::addPredefinedRequest
	 */
	public function testCreatePredefinedRequest() {
		$datasetId = 'dataset_2_predefined';
		$tableSchema = 'RAW_DATA';
		$criteria = array();
		$results = array();
		$label = 'critères les plus fréquents';
		$requestName = $datasetId . '_periode';

		$this->prg->createPredefinedRequest($datasetId, $tableSchema, $requestName, $criteria, $results, $label, $this->dbconn);

		$sql = "select count(request_name), request_name
				from website.predefined_request
				group by request_name";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['count']);
		$this->assertTrue($row['request_name'] == 'dataset_2_predefined_periode');
	}

	/**
	 * Test predefined request criterion creation
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration::addPredefinedRequestCriterion
	 */
	public function testAddPredefinedRequestCriterion() {
		$datasetId = 'dataset_2_predefined';
		$requestName = $datasetId . '_periode';
		$this->prg->addPredefinedRequestCriterion($requestName, 'form_localisation', 'codeen', '', 'FALSE', $this->dbconn);

		$sql = "select count(request_name), request_name
				from website.predefined_request_criteria
				group by request_name";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['count']);
		$this->assertTrue($row['request_name'] == 'dataset_2_predefined_periode');
	}

	/**
	 * Test predefined request result creation
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration::addPredefinedRequestResult
	 */
	public function testAddPredefinedRequestResult() {
		$datasetId = 'dataset_2_predefined';
		$requestName = $datasetId . '_periode';
		$this->prg->addPredefinedRequestResult($requestName, 'form_localisation', 'codeen', $this->dbconn);

		$sql = "select count(request_name), request_name
				from website.predefined_request_result
				group by request_name";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['count']);
		$this->assertTrue($row['request_name'] == 'dataset_2_predefined_periode');
	}

	/**
	 * Test delete predefined request
	 *
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::dropPredefinedRequests
	 */
	public function testDropPredefinedRequest() {
		$datasetId = 'dataset_2_predefined';
		$this->mu->dropPredefinedRequests($datasetId);

		$sql = "select count(request_name), request_name
				from website.predefined_request
				group by request_name";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);
	}

	/**
	 * Test predefined requests are created when a model is published
	 *
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\PredefinedRequestGeneration::createPredefinedRequests
	 */
	public function testCreatePredefinedRequests() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();
		$prg = $container->get('app.modelpublication');
		$prg->publishModel('2');

		$sql = "select count(request_name)
				from website.predefined_request";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		// Predefined request on sensitivity is not created as the field occstatutbiologique is missing in the table2.
		// It's normal : if not the trigger is created and needs taxref table, and I don't want to create it.
		$this->assertEquals(5, $row['count']);

		$sql = "select count(group_name)
				from website.predefined_request_group";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(1, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_group_asso";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(5, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_criteria";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(21, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_result";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(70, $row['count']);
	}

	/**
	 * Test predefined request are deleted when a model is unpublished
	 */
	public function testDeletePredefinedRequest() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();
		$prg = $container->get('app.modelunpublication');
		$prg->unPublishModel('2');

		$sql = "select count(request_name)
				from website.predefined_request";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);

		$sql = "select count(group_name)
				from website.predefined_request_group";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_group_asso";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_criteria";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);

		$sql = "select count(request_name)
				from website.predefined_request_result";
		$stmt = $this->prg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertEquals(0, $row['count']);
	}
}
