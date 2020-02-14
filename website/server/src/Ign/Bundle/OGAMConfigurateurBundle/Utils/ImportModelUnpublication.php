<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\ORM\ORMException;
use Doctrine\ORM\EntityManager;

use Monolog\Logger;

use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;

/**
 * Utility class for unpublication of an import model from the database.
 *
 * @author Gautam Pastakia
 *
 */
class ImportModelUnpublication extends DatabaseUtils {

	/**
	 *
	 * @var PDO connection with user 'ogam' rights.
	 */
	private $pgConn;
	
	
	/**
	 *
	 * @var EntityManager
	 */
	private $entityManager ;

	public function __construct(EntityManager $entityManager, Logger $logger) {
		
		$this->entityManager = $entityManager ;
		$conn = $entityManager->getConnection() ;
		parent::__construct($conn, $logger);
		$this->pgConn = pg_connect("host=" . $conn->getHost() . " port=" . $conn->getPort() . " dbname=" . $conn->getDatabase() . " user=" . $conn->getUsername() . " password=" . $conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());
	}

	/**
	 * Unpublishes an import model.
	 *
	 * @param $importModelId the
	 *        	id of the importmodel
	 * @return string SUCCESS if unpublication succeded, FAIL otherwise, NOTHING_TO_DO if import model exists but is not published
	 */
	public function unpublishImportModel(Dataset $importModel) {
		
		if (Dataset::UNPUBLISHED == $importModel->getStatus()) {
			return 'NOTHING_TO_DO' ;
		}
		
		$importModel->setStatus(Dataset::UNPUBLISHED) ;
		$this->entityManager->flush() ;
		
		return 'SUCCESS' ;
	}

	
	/**
	 * Deletes all data related to an import model.
	 * @param Dataset $dataset
	 */
	public function deleteImportModel(Dataset $importModel) {

		$this->conn->beginTransaction();
		$this->deleteFieldMappingData($importModel);
		$this->deleteDatasetFieldsData($importModel);
		$this->deleteDatasetFilesData($importModel);
		$this->deleteModelDatasetsData($importModel);
		$this->deleteFileFieldData($importModel);
		$this->deleteFieldData($importModel);
		$this->deleteFileFormatData($importModel);
		$this->deleteFormatData($importModel);
		$this->deleteImportModelData($importModel);
		$this->deleteDataData($importModel);

		try {
			$this->conn->commit();
			$this->conn->close();
		} catch (ORMException $e) {
			$this->conn->rollback();
			$this->conn->close();
			return 'FAIL';
		}
		return 'SUCCESS';
	}
	
	
	/**
	 * Deletes the data located in metadata.data table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteDataData(Dataset $importModel) {
		// Select all data values
		$sql = "SELECT DISTINCT dtj.data, dtj.unit, dtj.label, dtj.definition, dtj.comment FROM metadata.dataset as d
				INNER JOIN metadata.dataset_files as mt ON mt.dataset_id = '" . $importModel->getId() . "'
				INNER JOIN metadata.file_format as tfo ON tfo.format = mt.format
				INNER JOIN metadata.file_field as tfi ON tfi.format = tfo.format
				INNER JOIN metadata.data as dtj ON dtj.data = tfi.data
				WHERE d.type = 'IMPORT'";
		$results = pg_query($this->pgConn, $sql);

		// Prepare delete statement for each data value
		$deleteSql = "DELETE FROM metadata.data WHERE data = $1";
		pg_prepare($this->pgConn, "", $deleteSql);

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field WHERE data = :data";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':data', $row['data']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($count == 0) {
				pg_execute($this->pgConn, "", array(
					$row['data']
				));
			}
		}
	}

	/**
	 * Deletes the data located in metadata.format table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteFormatData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT ffo.format
						FROM metadata.dataset d
						INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
						INNER JOIN metadata.format as ffo ON ffo.format = df.format
						WHERE ffo.type = 'FILE' AND d.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.format WHERE format = $1";
		pg_prepare($this->pgConn, "", $deleteQuery);

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field WHERE format = :format";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':format', $row['format']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($count == 0) {
				pg_execute($this->pgConn, "", array(
					$row['format']
				));
			}
		}
	}

	/**
	 * Deletes the data located in metadata.table_format table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	to the import model
	 */
	private function deleteFileFormatData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT ffo.format
						FROM metadata.dataset d
						INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
						INNER JOIN metadata.file_format as ffo ON ffo.format = df.format
						WHERE d.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.file_format WHERE format = $1";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['format']
			));
		}
	}

	/**
	 * Deletes the data located in metadata.field table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the model
	 */
	private function deleteFieldData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT f.data, f.format
						FROM metadata.dataset d
						INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
						INNER JOIN metadata.file_format as ffo ON ffo.format = df.format
						INNER JOIN metadata.field as f ON f.format = ffo.format
						WHERE d.dataset_id = $1 AND f.type = 'FILE'";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.field WHERE data = $1 AND format = $2 AND type = 'FILE'";
		pg_prepare($this->pgConn, "", $deleteQuery);

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field_mapping
					WHERE src_data = :data AND src_format = :format";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':data', $row['data']);
			$stmt->bindParam(':format', $row['format']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($count == 0) {
				pg_execute($this->pgConn, "", array(
					$row['data'],
					$row['format']
				));
			}
		}
	}

	/**
	 * Deletes the data located in metadata.table_field table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteFileFieldData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT ffi.data, ffi.format
				FROM metadata.dataset d
				INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata.file_format as ffo ON ffo.format = df.format
				INNER JOIN metadata.file_field as ffi ON ffi.format = ffo.format
				WHERE d.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.file_field WHERE data = $1 AND format = $2";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['data'],
				$row['format']
			));
		}
	}

	/**
	 * Deletes the data located in metadata.field_mapping table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteDatasetFieldsData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT dataset_id, schema_code, format, data
						FROM metadata.dataset_fields
						WHERE dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.dataset_fields
						WHERE dataset_id = $1 AND schema_code = $2 AND format = $3 AND data = $4";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['dataset_id'],
				$row['schema_code'],
				$row['format'],
				$row['data']
			));
		}
	}

	/**
	 * Deletes the data located in metadata.field_mapping table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteFieldMappingData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT fim.src_data, fim.src_format, fim.dst_data, fim.dst_format
						FROM metadata.dataset d
						INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
						INNER JOIN metadata.format as fo ON fo.format = df.format
						INNER JOIN metadata.field_mapping as fim ON fim.src_format = df.format
						WHERE d.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));
		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.field_mapping
						WHERE src_data = $1 AND src_format = $2 AND dst_data = $3 AND dst_format = $4";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['src_data'],
				$row['src_format'],
				$row['dst_data'],
				$row['dst_format']
			));
		}
	}

	/**
	 * Deletes the import model located in metadata.dataset table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteImportModelData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT d.dataset_id
						FROM metadata.dataset d
						WHERE d.dataset_id = $1 AND d.type = 'IMPORT'";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.dataset WHERE dataset_id = $1";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['dataset_id']
			));
		}
	}

	/**
	 * Deletes the data located in metadata.model_datasets table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function deleteModelDatasetsData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT md.model_id, md.dataset_id
						FROM metadata.dataset d
						INNER JOIN metadata.model_datasets as md ON md.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.model_datasets WHERE model_id = $1 AND dataset_id = $2";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['model_id'],
				$row['dataset_id']
			));
		}
	}

	/**
	 * Deletes the data located in metadata.dataset_files table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	private function deleteDatasetFilesData(Dataset $importModel) {
		// Select all values
		$selectQuery = "SELECT DISTINCT df.dataset_id, df.format
						FROM metadata.dataset d
						INNER JOIN metadata.dataset_files as df ON df.dataset_id = d.dataset_id
						WHERE d.dataset_id = $1";
		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$importModel->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.dataset_files WHERE dataset_id = $1 AND format = $2";
		pg_prepare($this->pgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->pgConn, "", array(
				$row['dataset_id'],
				$row['format']
			));
		}
	}


	/**
	 * Returns true if at least one file related to the import model is being uploaded.
	 *
	 * @param string $importModelId
	 *        	the
	 *        	id of the import model
	 * @return boolean
	 */
	public function hasRunningFileUpload($importModelId) {
		$hasRunningFile = false;
		$sql = "SELECT count(s.submission_id)
				FROM raw_data.submission s
				WHERE s.dataset_id = :importModelId
				AND status = 'RUNNING'";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) >= 1) {
			$hasRunningFile = true;
		}

		$this->conn->close();

		return $hasRunningFile;
	}

}