<?php
namespace Ign\Bundle\GincoConfigurateurBundle\Tests\Utils;

use Ign\Bundle\GincoConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\GincoConfigurateurBundle\Utils\CopyUtils;

/**
 * Test class for copy utils class
 * of the GINCO configurateur Bundle
 */
class CopyUtilsTest extends ConfiguratorTest {

	/**
	 *
	 * @var CopyUtils
	 */
	public $copyUtils;

	/**
	 *
	 * Connection to the database
	 *
	 * @var
	 */
	public $dbconn;

	/**
	 *
	 * @var string the id of the model to test
	 */
	public $modelId = '2';

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		// The script file used here is the same as for publication service
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_publication_service.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$logger = $container->get('monolog.logger.ginco');

		$adminName = $container->getParameter('database_admin_user');
		$adminPassword = $container->getParameter('database_admin_password');

		$this->copyUtils = new CopyUtils($conn, $logger, $adminName, $adminPassword);
		$this->dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// exec things needed to be done
		$this->copyUtils->copyData($this->modelId, $this->dbconn);
		$this->copyUtils->copyFormat($this->modelId, 'metadata', false);
		$this->copyUtils->copyTableFormat($this->modelId, 'metadata', false);
		$this->copyUtils->copyTableTree($this->modelId, 'metadata', false);
		$this->copyUtils->copyField($this->modelId, 'metadata', false);
		$this->copyUtils->copyTableField($this->modelId, 'metadata', false);
		$this->copyUtils->copyModel($this->modelId, 'metadata', false);
		$this->copyUtils->copyModelTables($this->modelId, 'metadata', false);
		$this->copyUtils->createQueryDataset($this->modelId, $this->dbconn);
	}

	/**
	 * @covers Ign\Bundle\GincoConfigurateurBundle\Utils\CopyUtils::createFormFields
	 */
	public function testCreateFormFields() {
		// First, gets the query dataset id previously created
		$datasetId = $this->copyUtils->hasQueryDataset($this->modelId);
		if (!$datasetId) {
			return;
		}

		// Test that before calling createFormFields, there is no form_format linked to the query dataset
		$sql1 = "SELECT COUNT(*) FROM metadata.form_format ff
				INNER JOIN metadata.dataset_forms df ON df.format = ff.format
				WHERE df.dataset_id = ?";
		$stmt = $this->copyUtils->getConnection()->prepare($sql1);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 0);

		// Test that before calling createFormFields, there is no form_field
		// related to a form_format related to the query dataset
		$sql2 = "SELECT COUNT(*) FROM metadata.form_field ffi
				 INNER JOIN metadata.form_format ffo ON ffi.format = ffo.format
				 INNER JOIN metadata.dataset_forms df ON ffo.format = df.format
				 WHERE df.dataset_id = ?";
		$stmt = $this->copyUtils->getConnection()->prepare($sql2);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 0);

		// Test that before calling createFormFields, there is no field_mapping of type 'FORM'
		$sql3 = "SELECT COUNT(*) FROM metadata.field_mapping fm
				 INNER JOIN metadata.form_format ffo ON fm.src_format = ffo.format
				 INNER JOIN metadata.dataset_forms df ON ffo.format = df.format
				 WHERE mapping_type = 'FORM'
				 AND df.dataset_id = ?";
		$stmt = $this->copyUtils->getConnection()->prepare($sql3);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 0);

		// Execute createFormFields
		$this->copyUtils->createFormFields($this->modelId, $datasetId, $this->dbconn);

		// Test that after calling, there is 3 form_format linked to the query dataset :
		// Localisation - table_son, Autres - table_son, Autres - table_father, localisation - table_father
		// Without this bundle, it would be only 2 : one related to table_son, one to table_father
		$stmt = $this->copyUtils->getConnection()->prepare($sql1);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertEquals(4, $stmt->fetchColumn(0));

		// Test that after calling createFormFields, there is exactly 12 form_field in db (12 table fields related to table_son and table_father)
		$stmt = $this->copyUtils->getConnection()->prepare($sql2);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 12);

		// Test that after calling createFormFields, there is exactly 12 field_mapping of type FORM
		$stmt = $this->copyUtils->getConnection()->prepare($sql3);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 12);
	}
}