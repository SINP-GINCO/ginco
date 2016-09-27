<?php
namespace Ign\Bundle\ConfigurateurBundle\Tests\Utils;

use Ign\Bundle\ConfigurateurBundle\Tests\ConfiguratorTest;
use Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnpublication;

/**
 * Test class for import model unpublication service (see Story #212).
 * Note : this class test needs metadata and metadata_work schemas
 * initialized in order to work.
 *
 * @author Gautam Pastakia
 *
 */
class ImportModelUnpublicationTest extends ConfiguratorTest {

	/**
	 *
	 * @var ImportModelUnpublication
	 */
	public $imu;

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

		$sql = file_get_contents(dirname(__FILE__) . '/../Resources/insert_script_for_import_model_unpublication_service.sql');
		pg_query($adminConn, $sql) or die('Request failed: ' . pg_last_error());

		pg_close($adminConn);
	}

	public function setUp() {
		static::$kernel = static::createKernel();
		static::$kernel->boot();

		$container = static::$kernel->getContainer();

		$conn = $container->get('database_connection');
		$logger = $container->get('logger');

		$this->imu = new ImportModelUnpublication($conn, $logger);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteFieldMappingData
	 */
	public function testDeleteFieldMappingData() {
		// Test that before calling, the field mapping for the import model are present
		$sql = "SELECT src_data, dst_data, dst_format from metadata.field_mapping WHERE src_format = ? ORDER BY src_data";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();
		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['src_data'] === 'altitudemax');
		$this->assertTrue($result[0]['dst_data'] === 'altitudemax');
		$this->assertTrue($result[0]['dst_format'] === 'my_table');
		$this->assertTrue($result[1]['src_data'] === 'altitudemin');
		$this->assertTrue($result[1]['dst_data'] === 'altitudemin');
		$this->assertTrue($result[1]['dst_format'] === 'my_table');
		$this->assertCount(2, $result);

		$this->imu->deleteFieldMappingData($this->importModelId);

		// Test that after calling, the field mapping for the import model are not present
		$stmt->execute();
		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteDatasetFieldsData
	 */
	public function testDeleteDatasetFieldsData() {
		// Test that before calling, the dataset fields for 'my_dataset' are present
		$sql = "SELECT dataset_id, schema_code, format, data from metadata.dataset_fields WHERE dataset_id = ? ORDER BY data";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_dataset');
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

		$this->imu->deleteDatasetFieldsData($this->importModelId);
		// Test that after calling, the dataset fields for 'my_dataset' are not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteFileFieldData
	 */
	public function testDeleteFileFieldData() {
		// Test that before calling, the file fields for 'my_file' are present
		$sql = "SELECT data from metadata.file_field WHERE format = ? ORDER BY data";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['data'] === 'altitudemax');
		$this->assertTrue($result[1]['data'] === 'altitudemin');
		$this->assertTrue($result[2]['data'] === 'specific_data_for_my_dataset');
		$this->assertCount(3, $result);

		$this->imu->deleteFileFieldData($this->importModelId);

		// Test that after calling, the file fields for 'my_file' are not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteFieldData
	 * @depends testDeleteFieldMappingData
	 * @depends testDeleteFileFieldData
	 */
	public function testDeleteFieldData() {
		// Test that before calling, the fields for 'my_file' are present
		$sql = "SELECT data from metadata.field WHERE format = ? AND type = ? ORDER BY data";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->bindValue(2, 'FILE');
		$stmt->execute();

		$result = $stmt->fetchAll();

		$this->assertTrue($result[0]['data'] === 'altitudemax');
		$this->assertTrue($result[1]['data'] === 'altitudemin');
		$this->assertTrue($result[2]['data'] === 'specific_data_for_my_dataset');
		$this->assertCount(3, $result);

		$this->imu->deleteFieldData($this->importModelId);

		// Test that after calling, the fields for 'my_file' are not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteDatasetFilesData
	 * @depends testDeleteFieldMappingData
	 * @depends testDeleteFileFieldData
	 */
	public function testDeleteDatasetFilesData() {
		// Test that before calling, the {'my_dataset', 'my_file') key is present
		$sql = "SELECT format from metadata.dataset_files WHERE dataset_id = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'my_file');

		$this->imu->deleteDatasetFilesData($this->importModelId);

		// Test that after calling, the {'my_dataset', 'my_file') is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteModelDatasetsData
	 */
	public function testDeleteModelDatasetsData() {
		// Test that before calling, the link model_datasets {'2', 'my_dataset'} is present
		$sql = "SELECT model_id from metadata.model_datasets WHERE dataset_id = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === '2');

		$this->imu->deleteModelDatasetsData($this->importModelId);

		// Test that after calling, the link model_datasets {'2', 'my_dataset'} is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteFileFormatData
	 * @depends testDeleteDatasetFieldsData
	 */
	public function testDeleteFileFormatData() {
		// Test that before calling, the file format 'my_file' is present
		$sql = "SELECT label from metadata.file_format WHERE format = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'My file');

		$this->imu->deleteFileFormatData($this->importModelId);

		// Test that after calling, the file format 'my_file' is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteFormatData
	 * @depends testDeleteFileFormatData
	 */
	public function testDeleteFormatData() {
		// Test that before calling, the format 'my_file' is present
		$sql = "SELECT type from metadata.format WHERE format = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'my_file');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'FILE');

		$this->imu->deleteFormatData($this->importModelId);
		// Test that after calling, the format 'my_file' is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::isImportModelPresentInTableDataset
	 */
	public function testIsImportModelPresentInTableDataset() {
		$exists = $this->imu->isImportModelPresentInTableDataset($this->importModelId);
		$this->assertTrue($exists);
		$exists = $this->imu->isImportModelPresentInTableDataset("false_id");
		$this->assertFalse($exists);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteImportModelData
	 * @depends testDeleteDatasetFilesData
	 * @depends testDeleteModelDatasetsData
	 * @depends testIsImportModelPresentInTableDataset
	 */
	public function testDeleteImportModelData() {
		// Test that before calling, the import model is present
		$sql = "SELECT definition from metadata.dataset WHERE dataset_id = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, $this->importModelId);
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'def');

		$this->imu->deleteImportModelData($this->importModelId);

		// Test that after calling, the import model is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::deleteDataData
	 * @depends testDeleteFieldData
	 */
	public function testDeleteDataData() {
		// Test that before calling, the 'specific_data_for_my_dataset' key is present
		$sql = "SELECT data from metadata.data WHERE data = ? ";
		$stmt = $this->imu->getConnection()->prepare($sql);
		$stmt->bindValue(1, 'specific_data_for_my_dataset');
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === 'specific_data_for_my_dataset');
		$this->imu->deleteDataData($this->importModelId);

		// Test that after calling, the 'specific_data_for_my_dataset' key is not present
		$stmt->execute();

		$this->assertTrue($stmt->fetchColumn(0) === false);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::hasRunningFileUpload
	 */
	public function testHasRunningFileUpload() {
		$hasRunningFile = $this->imu->hasRunningFileUpload($this->importModelId);
		$this->assertFalse($hasRunningFile);
		$hasRunningFile = $this->imu->hasRunningFileUpload('running_upload_dataset');
		$this->assertTrue($hasRunningFile);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::unpublishImportModel
	 */
	public function testUnpublishModel() {
		$success = $this->imu->unpublishImportModel('dataset_to_unpublish');
		$this->assertEquals('SUCCESS', $success);
	}

	/**
	 * @covers Ign\Bundle\ConfigurateurBundle\Utils\ImportModelUnPublication::unpublishImportModel
	 */
	public function testUnpublishModelThatDoesntExist() {
		// Try to unpublish an import model that does not exist
		$success = $this->imu->unpublishImportModel('my_false_id');
		$this->assertEquals('FAIL', $success);
	}
}