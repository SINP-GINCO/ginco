<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils;

/**
 * Test class for copy utils class (see Story #36).
 *
 * @author Gautam Pastakia
 *
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
		static::$kernel = static::createKernel(array('environment' => 'test_ogam'));
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$logger = $container->get('monolog.logger.ginco');

		$adminName = $container->getParameter('database_admin_user');
		$adminPassword = $container->getParameter('database_admin_password');

		$this->dbconn = pg_connect("host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		$this->copyUtils = new CopyUtils($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::isModelPresentInWorkSchema
	 */
	public function testIsModelPresentInWorkSchema() {
		$exists = $this->copyUtils->isModelPresentInWorkSchema($this->modelId);
		$this->assertTrue($exists);
		$exists = $this->copyUtils->isModelPresentInWorkSchema("false_id");
		$this->assertFalse($exists);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyData
	 */
	public function testCopyData() {
		// Test that before calling, the 'my_special_data' is not present
		$sql = "SELECT data from metadata.data WHERE data = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_special_data');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyData($this->modelId, $this->dbconn);

		// Test that after calling, the 'my_special_data' is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'my_special_data');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyFormat
	 */
	public function testCopyFormat() {
		// Test that before calling, the format table_father is not present
		$sql = "SELECT type from metadata.format WHERE format = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_father');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyFormat($this->modelId, 'metadata', false);

		// Test that after calling, the format table_father is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'TABLE');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyTableFormat
	 * @depends testCopyFormat
	 */
	public function testCopyTableFormat() {
		// Test that before calling, the table_format table_father is not present
		$sql = "SELECT label from metadata.table_format WHERE format = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_father');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyTableFormat($this->modelId, 'metadata', false);

		// Test that after calling, the format table_father is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'table_father');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyTableTree
	 * @depends testCopyTableFormat
	 */
	public function testCopyTableTree() {
		// Test that before calling, the table_tree for child table_son is not present
		$sql = "SELECT parent_table from metadata.table_tree WHERE child_table = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyTableTree($this->modelId, 'metadata', false);
		// Test that after calling, the table_tree for child table_son is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'table_father');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyField
	 * @depends testCopyData
	 * @depends testCopyFormat
	 */
	public function testCopyField() {
		// Test that before calling, the field for 'my_special_data' is not present
		$sql = "SELECT format from metadata.field WHERE data = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_special_data');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyField($this->modelId, 'metadata', false);

		// Test that after calling, the field for 'my_special_data' is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'table_son');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyTableField
	 * @depends testCopyField
	 * @depends testCopyFormat
	 */
	public function testCopyTableField() {
		// Test that before calling, the table_field 'my_special_data'is not present
		$sql = "SELECT format from metadata.table_field WHERE data = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_special_data');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyTableField($this->modelId, 'metadata', false);

		// Test that after calling, the table_field for 'my_special_data' is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'table_son');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyModel
	 * @depends testCopyField
	 * @depends testCopyFormat
	 */
	public function testCopyModel() {
		// Test that before calling, the model model_to_publish is not present
		$sql = "SELECT name from metadata.model WHERE id = :modelId ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindParam(':modelId', $this->modelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyModel($this->modelId, 'metadata', false);

		// Test that after calling, the model model_to_publish is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'model_to_publish');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::copyModelTables
	 * @depends testCopyModel
	 * @depends testCopyFormat
	 */
	public function testCopyModelTables() {
		// Test that before calling, the model_table for model_to_publish and table_son is not present
		$sql = "SELECT model_id from metadata.model_tables WHERE table_id = ? ";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->copyModelTables($this->modelId, 'metadata', false);

		// Test that after calling, the model_table for model_to_publish and table_son is present
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) === '2');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::createQueryDataset
	 * @depends testCopyModel
	 */
	public function testCreateQueryDataset() {
		// Test that before calling, there is no dataset of type 'QUERY' linked to the model
		$sql = "SELECT md.model_id, md.dataset_id FROM metadata.model_datasets md
				INNER JOIN metadata.dataset d ON d.dataset_id = md.dataset_id
				WHERE d.type = 'QUERY'
				AND md.model_id = ?";
		$stmt = $this->copyUtils->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->modelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->copyUtils->createQueryDataset($this->modelId, $this->dbconn);

		// Test that after calling, there is a datastet of type 'Query' linked to the model
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) === '2');
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils::createFormFields
	 * @depends testCreateQueryDataset
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

		// Test that after calling, there is 2 form_format linked to the query dataset (related to table_son and table_father)
		$stmt = $this->copyUtils->getConnection()->prepare($sql1);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 2);

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