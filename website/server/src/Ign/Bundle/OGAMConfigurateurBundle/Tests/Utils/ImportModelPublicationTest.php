<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Tests\Utils;

use Ign\Bundle\OGAMConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\OGAMConfigurateurBundle\Utils\ImportModelPublication;

/**
 * Test class for import model publication service (see Story #211).
 * Note : this class test needs metadata and metadata_work schemas
 * initialized in order to work.
 *
 * @author Gautam Pastakia
 *
 */
class ImportModelPublicationTest extends ConfiguratorTest {

	/**
	 *
	 * @var ImportModelPublication
	 */
	public $imp;

	/**
	 *
	 * @var string the id of import model to test
	 */
	public $importModelId = 'my_dataset';

	public static function executeScripts($adminConn) {
		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_common.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());

		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/1-4-Create_raw_data_schema.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());

		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_import_model_publication_service.sql');
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

		$this->imp = new ImportModelPublication($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * @importModelHasFiles
	 */
	public function testImportModelHasFiles() {
		$test = $this->imp->importModelHasFiles('dataset_with_no_fields');
		$this->assertTrue($test);
		$test = $this->imp->importModelHasFiles('dataset_with_no_file');
		$this->assertFalse($test);
	}

	/**
	 * importModelFilesHaveFields
	 */
	public function testImportModelFilesHaveFields() {
		$test = $this->imp->importModelFilesHaveFields('dataset_with_no_mapping');
		$this->assertTrue($test);
		$test = $this->imp->importModelFilesHaveFields('dataset_with_no_fields');
		$this->assertFalse($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ImportModelPublication::importModelFilesAreMapped
	 */
	public function testImportModelFilesAreMapped() {
		$test = $this->imp->importModelFilesAreMapped('my_dataset');
		$this->assertTrue($test);
		$test = $this->imp->importModelFilesAreMapped('dataset_with_no_mapping');
		$this->assertFalse($test);
	}

	/**
	 * @covers Ign\Bundle\OGAMConfigurateurBundle\Utils\ImportModelPublication::isPublishable
	 */
	public function testIsPublishable() {
		$test = $this->imp->isPublishable('my_dataset');
		$this->assertTrue($test);
		$test = $this->imp->isPublishable('non_publishable_dataset');
		$this->assertFalse($test);
		$test = $this->imp->isPublishable('dataset_with_no_file');
		$this->assertFalse($test);
		$test = $this->imp->isPublishable('dataset_with_no_fields');
		$this->assertFalse($test);
		$test = $this->imp->isPublishable('dataset_with_no_mapping');
		$this->assertFalse($test);
	}

	public function testPublishModel() {
		$success = $this->imp->publishImportModel('dataset_to_publish');
		$this->assertTrue($success);
	}

	public function testPublishModelThatDoesntExist() {
		// Try to publish an import model that does not exist
		$success = $this->imp->publishImportModel('my_false_id');
		$this->assertFalse($success);
	}

	public function testIsImportModelPresentInTableDataset() {
		$exists = $this->imp->isImportModelPresentInTableDataset($this->importModelId);
		$this->assertTrue($exists);
		$exists = $this->imp->isImportModelPresentInTableDataset("false_id");
		$this->assertFalse($exists);
	}

	public function testCopyData() {
		// Test that before calling, the specific_data_for_my_dataset key is not present
		$sql = "SELECT data from metadata.data WHERE data = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'specific_data_for_my_dataset');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyData($this->importModelId);

		// Test that after calling, the specific_data_for_my_dataset is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'specific_data_for_my_dataset');
	}

	public function testCopyImportModel() {
		// Test that before calling, the import model is not present
		$sql = "SELECT definition from metadata.dataset WHERE dataset_id = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyImportModel($this->importModelId);

		// Test that after calling, the dataset is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'def');
	}

	/**
	 * @depends testCopyImportModel
	 */
	public function testCopyModelDatasets() {
		// Test that before calling, the model_datasets {'2', 'my_dataset'} is not present
		$sql = "SELECT model_id from metadata.model_datasets WHERE dataset_id = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyModelDatasets($this->importModelId);

		// Test that after calling, the model_datasets {'2', 'my_dataset'} is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === '2');
	}

	public function testCopyFormat() {
		// Test that before calling, the table_tree for child table_son is not present
		$sql = "SELECT type from metadata.format WHERE format = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyFormat($this->importModelId);
		// Test that after calling, the table_tree for child table_son is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'FILE');
	}

	/**
	 * @depends testCopyFormat
	 */
	public function testCopyFileFormat() {
		// Test that before calling, the file_format my_file is not present
		$sql = "SELECT label from metadata.file_format WHERE format = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyFileFormat($this->importModelId);

		// Test that after calling, the format my_file is present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'My file');
	}

	/**
	 * @depends testCopyData
	 * @depends testCopyFormat
	 */
	public function testCopyField() {
		// Test that before calling, the field altitude_max is not present
		$sql = "SELECT data from metadata.field WHERE format = ? AND type = ? ORDER BY data";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->bindValue(2, 'FILE');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyField($this->importModelId);

		// Test that after calling, the field for table_son fk is not present
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['data'] === 'altitudemax');
		$this->assertTrue($result[1]['data'] === 'altitudemin');
		$this->assertTrue($result[2]['data'] === 'specific_data_for_my_dataset');
		$this->assertCount(3, $result);
	}

	/**
	 * @depends testCopyField
	 * @depends testCopyFileFormat
	 */
	public function testCopyFileField() {
		// Test that before calling, the table_field for table_son fk is not present
		$sql = "SELECT data from metadata.file_field WHERE format = ? ORDER BY data";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyFileField($this->importModelId);

		// Test that after calling, the table_field for table_son fk is present
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['data'] === 'altitudemax');
		$this->assertTrue($result[1]['data'] === 'altitudemin');
		$this->assertTrue($result[2]['data'] === 'specific_data_for_my_dataset');
		$this->assertCount(3, $result);
	}

	/**
	 * @depends testCopyImportModel
	 * @depends testCopyFileFormat
	 */
	public function testCopyDatasetFiles() {
		// Test that before calling, the {'my_dataset', 'my_file') key is not present
		$sql = "SELECT format from metadata.dataset_files WHERE dataset_id = ? ";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyDatasetFiles($this->importModelId);

		// Test that after calling, the {'my_dataset', 'my_file') is present
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) === 'my_file');
	}

	/**
	 * @depends testCopyData
	 * @depends testCopyFormat
	 */
	public function testCopyFieldMapping() {
		// Test that before calling, the field mapping for the import model are not present
		$sql = "SELECT src_data, dst_data, dst_format from metadata.field_mapping WHERE src_format = ? ORDER BY src_data";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);

		$this->imp->copyFieldMapping($this->importModelId);

		// Test that after calling, the field mapping for the import model are present
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['src_data'] === 'altitudemax');
		$this->assertTrue($result[0]['dst_data'] === 'altitudemax');
		$this->assertTrue($result[0]['dst_format'] === 'my_table');
		$this->assertTrue($result[1]['src_data'] === 'altitudemin');
		$this->assertTrue($result[1]['dst_data'] === 'altitudemin');
		$this->assertTrue($result[1]['dst_format'] === 'my_table');
		$this->assertCount(2, $result);
	}

	/**
	 * @depends testCopyField
	 * @depends testCopyFormat
	 */
	public function testCopyDatasetFields() {
		// Test that before calling, the dataset fields for 'my_dataset' are not present
		$sql = "SELECT dataset_id, schema_code, format, data from metadata.dataset_fields WHERE dataset_id = ? ORDER BY data";
		$stmt = $this->imp->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_dataset');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
		// Test that after calling, the dataset fields for 'my_dataset' are present
		$this->imp->copyDatasetFields($this->importModelId);
		$stmt->execute();

		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['dataset_id'] === 'my_dataset');
		$this->assertTrue($result[0]['schema_code'] === 'RAW_DATA');
		$this->assertTrue($result[0]['format'] === 'my_table');
		$this->assertTrue($result[0]['data'] === 'altitudemax');
		$this->assertTrue($result[1]['dataset_id'] === 'my_dataset');
		$this->assertTrue($result[1]['schema_code'] === 'RAW_DATA');
		$this->assertTrue($result[1]['format'] === 'my_table');
		$this->assertTrue($result[1]['data'] === 'altitudemin');
		$this->assertCount(2, $result);
	}

	public function testIsImportModelDataModelPublished() {
		$publishable = $this->imp->isImportModelDataModelPublished($this->importModelId);
		$this->assertTrue($publishable);
		$publishable = $this->imp->isImportModelDataModelPublished('my_non_publishable_dataset');
		$this->assertFalse($publishable);
	}

	public function testIsPublished() {
		$published = $this->imp->isPublished($this->importModelId);
		$this->assertTrue($published);
		$published = $this->imp->isPublished('running_upload_dataset');
		$this->assertFalse($published);
	}
}