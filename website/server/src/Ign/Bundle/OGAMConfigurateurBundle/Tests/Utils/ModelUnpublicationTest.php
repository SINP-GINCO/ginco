<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\CopyUtils;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelPublication;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication;

/**
 * Test class for model unpublication service (see Story #202).
 * Note : this class test needs metadata and metadata_work schemas
 * initialized in order to work.
 *
 * @author Gautam Pastakia
 *
 */
class ModelUnpublicationTest extends ConfiguratorTest {

	/**
	 *
	 * @var ModelUnpublication
	 */
	public $mup;

	/**
	 *
	 * @var ModelPublication
	 */
	public $mp;

	/**
	 *
	 * @var CopyUtils
	 */
	public $copyUtils;

	/**
	 *
	 * @var string the id of the model to test
	 */
	public $modelId = 'model_2';

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_unpublication_service.sql');
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

		$this->mp = new ModelPublication($conn, $logger, $adminName, $adminPassword);
		$this->mup = new ModelUnpublication($conn, $logger, $adminName, $adminPassword);
		$this->copyUtils = new CopyUtils($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteFormFields
	 */
	public function testDeleteFormFields() {
		// First, gets the query dataset id linked to the model
		$datasetId = $this->copyUtils->hasQueryDataset($this->modelId);
		if (!$datasetId) {
			return;
		}

		// Test that before calling, there is 1 form_format linked to the query dataset
		$sql1 = "SELECT COUNT(*) FROM metadata.form_format ff
				INNER JOIN metadata.dataset_forms df ON df.format = ff.format
				WHERE df.dataset_id = ?";
		$stmt = $this->mp->getConnection()->prepare($sql1);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 1);

		// Test that before calling, there are 2 form_field
		// related to a form_format related to the query dataset
		$sql2 = "SELECT COUNT(*) FROM metadata.form_field ffi
				 INNER JOIN metadata.form_format ffo ON ffi.format = ffo.format
				 INNER JOIN metadata.dataset_forms df ON ffo.format = df.format
				 WHERE df.dataset_id = ?";
		$stmt = $this->mp->getConnection()->prepare($sql2);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 2);

		// Test that before calling, there are 2 field_mapping of type 'FORM'
		$sql3 = "SELECT COUNT(*) FROM metadata.field_mapping fm
				 INNER JOIN metadata.form_format ffo ON fm.src_format = ffo.format
				 INNER JOIN metadata.dataset_forms df ON ffo.format = df.format
				 WHERE mapping_type = 'FORM'
				 AND df.dataset_id = ?";
		$stmt = $this->mp->getConnection()->prepare($sql3);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) == 2);

		// Delete Form Fields
		$this->mup->deleteFormFields($this->modelId);

		// Tests that after calling, it is 0 of each entries tested above
		$stmt = $this->mp->getConnection()->prepare($sql1);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 0);

		$stmt = $this->mp->getConnection()->prepare($sql2);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 0);

		$stmt = $this->mp->getConnection()->prepare($sql3);
		$stmt->bindValue(1, $datasetId);
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) == 0);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteQueryDataset
	 */
	public function testDeleteQueryDataset() {
		// Test that before calling, a dataset of type QUERY exists, is linked to the model,
		// and that dataset_fields contains entries for the QUERY dataset
		$sql = "SELECT COUNT(*) from metadata.dataset d
				INNER JOIN metadata.dataset_fields df ON d.dataset_id = df.dataset_id
				INNER JOIN metadata.model_datasets md ON d.dataset_id = md.dataset_id
 				WHERE md.model_id = ?
 				AND d.type = 'QUERY'";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->modelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) >= 1);

		$this->mup->deleteQueryDataset($this->modelId);

		// Tests that after calling, it is deleted
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0) >= 1);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::modelHasData
	 */
	public function testDeleteModelTablesData() {
		// Test that before calling, the model_table for model_to_publish and table_son are present
		$sql = "SELECT table_id from metadata.model_tables WHERE model_id = ? ";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'model_2');
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertEquals(sizeof($result), 2);
		$values = array(
			'table_son',
			'table_father'
		);
		$this->assertTrue(in_array($result[0]['table_id'], $values));
		$this->assertTrue(in_array($result[1]['table_id'], $values));
		$this->assertFalse($stmt->fetchColumn(0));

		$this->mup->deleteModelTablesData($this->modelId);

		// Test that after calling, the model_table for model_to_publish and table_son are not present
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteTableTreeData
	 */
	public function testDeleteTableTreeData() {
		// Test that before calling, the table_tree for child table_son is present
		$sql = "SELECT child_table from metadata.table_tree WHERE parent_table = ? ";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_father');
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertEquals(sizeof($result), 1);
		$this->assertTrue($result[0]['child_table'] === 'table_son');

		$this->mup->deleteTableTreeData($this->modelId);
		// Test that after calling, the table_tree for child table_son is not present
		$stmt->execute();
		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteTableFieldData
	 */
	public function testDeleteTableFieldData() {
		// Test that before calling, the table_field 'my_special_data' is present
		$sql = "SELECT data from metadata.table_field WHERE format = ? ORDER BY data";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertEquals(sizeof($result), 4);
		$values = array(
			'altitudemax',
			'altitudemin',
			'my_special_data',
			'OGAM_ID_table_son'
		);
		$this->assertTrue(in_array($result[0]['data'], $values));
		$this->assertTrue(in_array($result[1]['data'], $values));
		$this->assertTrue(in_array($result[2]['data'], $values));
		$this->assertTrue(in_array($result[3]['data'], $values));

		$this->mup->deleteTableFieldData($this->modelId);

		// Test that after calling, the table_field for 'my_special_data' is not present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @depends testDeleteTableFieldData
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteFieldData
	 */
	public function testDeleteFieldData() {
		// Test that before calling, the field for 'my_special_data' is present
		$sql = "SELECT data from metadata.field WHERE format = ? ORDER BY data";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertEquals(sizeof($result), 4);
		$values = array(
			'altitudemax',
			'altitudemin',
			'my_special_data',
			'OGAM_ID_table_son'
		);
		$this->assertTrue(in_array($result[0]['data'], $values));
		$this->assertTrue(in_array($result[1]['data'], $values));
		$this->assertTrue(in_array($result[2]['data'], $values));
		$this->assertTrue(in_array($result[3]['data'], $values));

		$this->mup->deleteFieldData($this->modelId);

		// Test that after calling, the field for 'my_special_data' is not present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @depends testDeleteFieldData
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteDataData
	 */
	public function testDeleteDataData() {
		// Test that before calling, the 'my_special_data' is present
		$sql = "SELECT data from metadata.data WHERE data = ? ";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_special_data');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'my_special_data');

		$this->mup->deleteDataData($this->modelId);

		// Test that after calling, the 'my_special_data' is not present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));

		// Test that the other data fields are present (because they are in another table)
		$sql = "SELECT data from metadata.data WHERE data LIKE ? ORDER BY data";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, '%altitude%');
		$stmt->execute();
		$results = $stmt->fetchAll();

		$this->assertEquals(sizeof($results), 3);
		$values = array(
			'altitudemax',
			'altitudemin',
			'altitudeMoyenne'
		);
		$this->assertTrue(in_array($results[0]['data'], $values));
		$this->assertTrue(in_array($results[1]['data'], $values));
		$this->assertTrue(in_array($results[2]['data'], $values));
	}

	/**
	 * @depends testDeleteModelTablesData
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteTableFormatData
	 */
	public function testDeleteTableFormatData() {
		// Test that before calling, the table_format table_father is present
		$sql = "SELECT format from metadata.table_format WHERE format = ? OR format = ? ORDER BY format";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->bindValue(2, 'table_father');
		$stmt->execute();
		$results = $stmt->fetchAll();

		$this->assertEquals(sizeof($results), 2);
		$values = array(
			'table_father',
			'table_son'
		);
		$this->assertTrue(in_array($results[0]['format'], $values));
		$this->assertTrue(in_array($results[1]['format'], $values));

		$this->mup->deleteTableFormatData($this->modelId);

		// Test that after calling, the format table_father is not present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @depends testDeleteTableFormatData
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteFormatData
	 */
	public function testDeleteFormatData() {
		// Test that before calling, the table_format table_father is present
		$sql = "SELECT format from metadata.format WHERE format = ? OR format = ? ORDER BY format";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'table_son');
		$stmt->bindValue(2, 'table_father');
		$stmt->execute();
		$results = $stmt->fetchAll();

		$this->assertEquals(sizeof($results), 2);
		$values = array(
			'table_father',
			'table_son'
		);
		$this->assertTrue(in_array($results[0]['format'], $values));
		$this->assertTrue(in_array($results[1]['format'], $values));

		$this->mup->deleteFormatData($this->modelId);

		// Test that after calling, the format table_father is not present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * After this test is passed, we reemove the model_datasets occurences so that testDeleteModelData
	 * can be executed in real conditions (before unpublishing a data model, all other models
	 * related to it are unpublished : therefore, there should be no data in model_datasets table.
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::getImportModelsFromDataModel
	 */
	public function testGetImportModelsFromDataModel() {
		$importModels = $this->mup->getImportModelsFromDataModel('model_2');
		$this->assertEquals(sizeof($importModels), 2);
		$this->assertContains('my_dataset', $importModels);
		$this->assertContains('my_other_dataset', $importModels);
		// Check that a model that has one table with at least one row returns true
		$importModels = $this->mup->getImportModelsFromDataModel('5');
		$this->assertEquals(sizeof($importModels), 0);
		// Remove the model_datasets occurences
		$sql = "DELETE FROM metadata.model_datasets";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->execute();
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::unpublishModel
	 */
	public function testUnpublish() {
		// Try to unpublish a model that does not exist
		$success = $this->mup->unpublishModel('my_false_id');
		$this->assertFalse($success);
		// Unpublish a simple model
		$success = $this->mup->unpublishModel('4');
		$this->assertTrue($success);
		// Unpublish a complex model
		$success = $this->mup->unpublishModel('5');
		$this->assertTrue($success);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::isModelPresentInProdSchema
	 */
	public function testIsModelPresentInProdSchema() {
		$exists = $this->mup->isModelPresentInProdSchema($this->modelId);
		$this->assertTrue($exists);
		$exists = $this->mup->isModelPresentInProdSchema("false_id");
		$this->assertFalse($exists);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::modelHasData
	 */
	public function testModelHasData() {
		// Check if every single table generated is empty for an empty model
		$hasData = $this->mup->modelHasData('model_2');
		$this->assertFalse($hasData);
		// Check that a model that has one table with at least one row returns true
		$hasData = $this->mup->modelHasData('model_3');
		$this->assertTrue($hasData);
	}

	/**
	 * @depends testGetImportModelsFromDataModel
	 * @depends testIsModelPresentInProdSchema
	 * @depends testModelHasData
	 * @depends testDeleteModelTablesData
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::deleteModelData
	 */
	public function testDeleteModelData() {
		// Test that before calling, the model model_to_publish is not present
		$sql = "SELECT name from metadata.model WHERE id = :modelId ";
		$stmt = $this->mup->getConnection()->prepare($sql);
		$stmt->bindParam(':modelId', $this->modelId);
		$stmt->execute();

		$results = $stmt->fetchAll();

		$this->assertEquals(sizeof($results), 1);
		$this->assertTrue($results[0]['name'] === 'model_to_publish');

		$this->mup->deleteModelData($this->modelId);

		// Test that after calling, the model model_to_publish is present
		$stmt->execute();

		$this->assertFalse($stmt->fetchColumn(0));
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::dropTables
	 */
	public function testDropTables() {
		// Retrieve tables from model
		$sql = "SELECT DISTINCT tfo.table_name
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = ?";
		$listStmt = $this->mup->getConnection()->prepare($sql);
		$listStmt->bindValue(1, '6');
		$listStmt->execute();
		$results = $listStmt->fetchAll();

		// Query to check if table exists - they should exist
		$sql = "SELECT EXISTS (
					SELECT 1 FROM pg_catalog.pg_class c
    				JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    				WHERE  n.nspname = ? AND c.relname = ? AND c.relkind = 'r')";
		$existsStmt = $this->mup->getConnection()->prepare($sql);

		foreach ($results as $result) {
			$existsStmt->bindValue(1, 'raw_data');
			$existsStmt->bindValue(2, $result['table_name']);
			$existsStmt->execute();
			$this->assertTrue($existsStmt->fetchColumn(0));
		}

		$this->mup->dropTables('6');
		// Query to check if table exists - they should not exist
		foreach ($results as $result) {
			$existsStmt->bindValue(1, 'raw_data');
			$existsStmt->bindValue(2, $result['table_name']);
			$existsStmt->execute();
			$this->assertFalse($existsStmt->fetchColumn(0));
		}
	}

/**
 * @depends testDropTables
 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ModelUnpublication::dropSequences
 */
	/*
	 * public function testDropSequences() {
	 * // Retrieve sequences from model
	 * $sql = "SELECT DISTINCT tfo.table_name
	 * FROM metadata_work.model m
	 * INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
	 * INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
	 * WHERE m.id = ?";
	 * $listStmt = $this->mup->getConnection()->prepare($sql);
	 * $listStmt->bindValue(1, '6');
	 * $listStmt->execute();
	 * $results = $listStmt->fetchAll();
	 *
	 * // Query to check if sequence exists - they should exist
	 * $sql = "SELECT EXISTS (
	 * SELECT 1 FROM pg_catalog.pg_class c
	 * JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
	 * WHERE n.nspname = ? AND c.relname = ? AND c.relkind = 'S')";
	 * $existsStmt = $this->mup->getConnection()->prepare($sql);
	 *
	 * foreach ($results as $result) {
	 * $existsStmt->bindValue(1, 'raw_data');
	 * $existsStmt->bindValue(2, 'ogam_id'.$result['table_name'].'_seq');
	 * $existsStmt->execute();
	 * $this->assertTrue($existsStmt->fetchColumn(0));
	 * }
	 *
	 * $this->mup->dropSequences('6');
	 *
	 * // Query to check if sequence exists - they should not exist
	 * foreach ($results as $result) {
	 * $existsStmt->bindValue(1, 'raw_data');
	 * $existsStmt->bindValue(2, 'ogam_id'.$result['table_name'].'_seq');
	 * $existsStmt->execute();
	 * $this->assertFalse($existsStmt->fetchColumn(0));
	 * }
	 * }
	 */
}