<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\TablesGeneration;

/**
 *
 * Note : this class test needs metadata, metadata_work, raw_data and harmonized_data schemas
 * initialiazed in order to work.
 *
 * @author Anna Mouget
 *
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
	 */
	protected $dbconn;

	public static function executeScripts($adminConn) {}

	/**
	 * Instanciates the unit_test db with data.
	 * Purges it before.
	 */
	public static function setUpBeforeClass() {
		// Launch kernel in order to get connection
		static::$kernel = static::createKernel(array('environment' => 'test_ogam'));
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
		static::$kernel = static::createKernel(array('environment' => 'test_ogam'));
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$this->dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$this->tg = $container->get('app.tablesgeneration');
	}

	public function testGetConnection() {
		$sql = "SELECT 1::integer";
		$row = $this->tg->getConnection()
			->query($sql)
			->fetch();
		$this->assertEquals(1, $row['int4']);
	}

	public function testCreateTable() {
		$results = $this->tg->selectTablesFormat('1', $this->dbconn);

		$count = 0;

		// pour chaque table
		while ($row = pg_fetch_assoc($results)) {
			$tableSchema = $row['schema_code'];
			$tableName = $row['table_name'];

			$sql = "SELECT 1::integer
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_SCHEMA = ?
					AND TABLE_NAME = ?";
			$stmt = $this->tg->getConnection()->prepare($sql);
			$stmt->bindValue(1, strtolower($tableSchema));
			$stmt->bindValue(2, strtolower($tableName));
			$stmt->execute();
			$row2 = $stmt->fetch();
			$count = $count + $row2['int4'];
		}
		$this->assertTrue($count > 0);
	}

	/**
	 * @depends testCreateTable
	 */
	public function testSelectTablesFormat() {
		$results = $this->tg->selectTablesFormat('1', $this->dbconn);

		$numberTables = count(pg_fetch_all($results));

		$this->assertTrue($numberTables == 2);
	}

	/**
	 * @depends testCreateTable
	 */
	public function testCreateGeomCol() {
		// geometry type is known by postgres as an user-defined type
		$sql = "SELECT count(column_name)
				FROM information_schema.columns
				WHERE table_name='_1_localisation'
				AND data_type='USER-DEFINED'";
		$row = $this->tg->getConnection()
			->query($sql)
			->fetch();
		$this->assertTrue($row['count'] == 1);
	}

	/**
	 * @depends testCreateTable
	 */
	public function testAddConstraints() {
		// $this->tg->addConstraints('1');
		$sql = "SELECT count(column_name)
				FROM information_schema.columns
				WHERE table_name='_1_observation' and column_name='ogam_id_1_localisation'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 1);

		$sql = "SELECT count(tc.constraint_name) AS cn
				FROM information_schema.table_constraints AS tc
				WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='_1_observation'";
		$stmt = $this->tg->getConnection()->prepare($sql);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 1);
	}

	/**
	 * @depends testCreateTable
	 */
	public function testGrantRights() {
		$sql = "select has_schema_privilege('raw_data', 'USAGE')";
		$row = $this->tg->getConnection()
			->query($sql)
			->fetch();

		$sql2 = " select has_any_column_privilege('raw_data._1_observation', 'insert')";
		$row2 = $this->tg->getConnection()
			->query($sql2)
			->fetch();

		$this->assertTrue($row['has_schema_privilege'] == "t");
		$this->assertTrue($row2['has_any_column_privilege'] == "t");
	}

	/**
	 */
	public function testGetPostgresTypeFromOgamType() {
		$result = $this->tg->getPostgresTypeFromOgamType('NUMERIC', 'Decimal', 'champTest');
		$this->assertEquals('float8', $result);

		$result = $this->tg->getPostgresTypeFromOgamType('DATE', 'DateTime', 'champTest');
		$this->assertEquals('timestamp with time zone', $result);

		$result = $this->tg->getPostgresTypeFromOgamType('TIME', 'Time', 'champTest');
		$this->assertEquals('time', $result);

		$result = $this->tg->getPostgresTypeFromOgamType('STRING', 'UnitTest', 'commentaire');
		$this->assertEquals('text', $result);
	}
}