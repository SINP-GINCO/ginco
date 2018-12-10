<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Utils;

use Ign\Bundle\GincoConfigurateurBundle\Tests\ConfiguratorTest;

/**
 * This test class is for custom TablesGenerationTest
 */
class TablesGenerationTest extends ConfiguratorTest {

	/**
	 *
	 * @var TablesGeneration
	 */
	public $tg;

	/**
	 *
	 * Connection to the database via PDO
	 *
	 * @var
	 *
	 */
	protected $dbconn;

	public static function executeScripts($adminConn) {}

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
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-3-Create_website_schema.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-5-Create_dee_tables.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/5-create_trigger_sensitive.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/create_trigger_init.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/3-Delete_predefined_requests.sql');
		pg_query($adminDbconn, $sql) or die('Request failed: ' . pg_last_error());

		$dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$tg = $container->get('app.tablesgeneration');
		$tg->createTables('1', $dbconn);
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$this->dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$this->tg = $container->get('app.tablesgeneration');
	}

	/**
	 * Tests if a trigger is created on the table observation (has the "identifiantpermanent" column)
	 * But not on the table localisation (has not the column)
	 */
	public function testCreateIdentifierTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_localisation'
				and trigger_name LIKE 'perm_id_generate%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 0);

		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name LIKE 'perm_id_generate%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}

	/**
	 * Tests if sensitive triggers are created on the table observation (has the needed columns)
	 */
	public function testCreateSensitiveTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name = 'sensitive_manual'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);

		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name = 'sensitive_automatic'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}

	/**
	 * Tests if init trigger is created on the table observation (has the needed columns)
	 */
	public function testInitTrigger() {
		$sql = "select count(trigger_name)
				from information_schema.triggers
				where event_object_schema = 'raw_data'
				and event_object_table = 'model_1_observation'
				and trigger_name LIKE 'init_trigger%'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$row = $stmt->fetch();
		$this->assertTrue($row['count'] == 1);
	}
}