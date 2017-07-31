<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;
use Doctrine\ORM\ORMException;

/**
 * Utility class for publication of an import model into a database.
 *
 * @author Gautam Pastakia
 *
 */
class ImportModelPublication extends DatabaseUtils {

	public function __construct(Connection $conn, $adminName, $adminPassword) {
		parent::__construct($conn, $adminName, $adminPassword);
	}

	/**
	 * Publishes an import model by copying all the data related to a specific import model.
	 *
	 * @param $importModelId the
	 *        	id of the importmodel
	 * @return true if publication succeded, false otherwise
	 */
	public function publishImportModel($importModelId) {
		if ($this->isImportModelPresentInTableDataset($importModelId) && $this->isPublishable($importModelId)) {

			$this->conn->beginTransaction();
			// copyData has a particular case of action regarding transaction : it uses PHP PostgreSQL
			// functions, and thus has its own way of handling transactions. In case of problem,
			// we thus don't need to use DBAL transaction system, has PHP already handles it.
			if (!$this->copyData($importModelId)) {
				return false;
			}
			$this->copyFormat($importModelId);
			$this->copyFileFormat($importModelId);
			$this->copyField($importModelId);
			$this->copyFileField($importModelId);
			$this->copyFieldMapping($importModelId);
			$this->copyImportModel($importModelId);
			$this->copyDatasetFields($importModelId);
			$this->copyModelDatasets($importModelId);
			$this->copyDatasetFiles($importModelId);
		} else {
			return false;
		}

		try {
			$this->conn->commit();
			$this->conn->close();
		} catch (ORMException $e) {
			$this->conn->rollback();
			$this->conn->close();
			return false;
		}

		return true;
	}

	/**
	 * Returns true if the data model of the import model is published.
	 * @param $importModelId the
	 *        	id of the importmodel
	 * @return boolean
	 */
	public function isImportModelDataModelPublished($importModelId) {
		$publishable = false;
		$sql = "SELECT count(m.id)
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.model_datasets as md ON md.dataset_id = d.dataset_id
				INNER JOIN metadata.model as m ON m.id = md.model_id
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) === 1) {
			$publishable = true;
		}

		$this->conn->close();
		return $publishable;
	}

	/**
	 * Copies the data located in metadata_work.data table, which belongs directly to the import model
	 * specified by its id.
	 * Note : Use of pg_query function, without preparing the statement, is allowed here as the only
	 * parameter here is the model id, which is generated on the server side.
	 * It was chosen instead of prepared statement as it allows multiple queries, instead of one.
	 * Note 2 : We use bulk upsert with locking table feature. It is necessarry as table already
	 * contains rows that we want to insert.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 * @return boolean true if transaction succeeded, false otherwise
	 */
	public function copyData($importModelId) {
		$dbconn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		if (!pg_query($dbconn, "BEGIN")) {
			return false;
		}

		$sql = 'CREATE TEMPORARY TABLE data_temp(data varchar(174),
				unit varchar(36), label varchar(60), definition varchar(255),
				comment varchar(255)) ON COMMIT DROP;
				INSERT INTO data_temp(data, unit, label, definition, comment)
				SELECT DISTINCT dtj.data, dtj.unit, dtj.label, dtj.definition, dtj.comment FROM metadata_work.dataset as d
				INNER JOIN metadata_work.dataset_files as mt ON mt.dataset_id = \'' . $importModelId . '\'
				INNER JOIN metadata_work.file_format as tfo ON tfo.format = mt.format
				INNER JOIN metadata_work.file_field as tfi ON tfi.format = tfo.format
				INNER JOIN metadata_work.data as dtj ON dtj.data = tfi.data
				WHERE d.type = \'IMPORT\';
				LOCK TABLE metadata.data IN EXCLUSIVE MODE;
				UPDATE metadata.data
				SET data = data_temp.data, unit = data_temp.unit,
					label = data_temp.label, definition = data_temp.definition,
					comment = data_temp.comment
				FROM data_temp
				WHERE data_temp.data = metadata.data.data;
				INSERT INTO metadata.data
				SELECT data_temp.data, data_temp.unit,
						data_temp.label, data_temp.definition,
						data_temp.comment
				FROM data_temp
				LEFT OUTER JOIN metadata.data ON (metadata.data.data = data_temp.data)
				WHERE metadata.data.data IS NULL;';
		if (pg_query($dbconn, $sql)) {
			pg_query("COMMIT;");
		} else {
			pg_query("ROLLBACK;");
			pg_close($dbconn);
			return false;
		}
		pg_close($dbconn);
		return true;
	}

	/**
	 * Copies the data located in metadata_work.format table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyFormat($importModelId) {
		$sql = "INSERT INTO metadata.format(format, type)
				SELECT DISTINCT ffo.format, ffo.type
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata_work.format as ffo ON ffo.format = df.format
				WHERE ffo.type = 'FILE' AND d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.table_format table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	to the import model
	 */
	public function copyFileFormat($importModelId) {
		$sql = "INSERT INTO metadata.file_format(format, file_extension, file_type, position, label, definition)
				SELECT DISTINCT ffo.format, ffo.file_extension, ffo.file_type, ffo.position, ffo.label , ffo.definition
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata_work.file_format as ffo ON ffo.format = df.format
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.field table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the model
	 */
	public function copyField($importModelId) {
		$sql = "INSERT INTO metadata.field(data, format, type)
				SELECT DISTINCT f.data, f.format, f.type
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata_work.file_format as ffo ON ffo.format = df.format
				INNER JOIN metadata_work.field as f ON f.format = ffo.format
				WHERE d.dataset_id = :importModelId AND f.type = 'FILE'";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.table_field table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyFileField($importModelId) {
		$sql = "INSERT INTO metadata.file_field(data, format, is_mandatory, mask, position)
				SELECT DISTINCT ffi.data, ffi.format, ffi.is_mandatory, ffi.mask, ffi.position
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata_work.file_format as ffo ON ffo.format = df.format
				INNER JOIN metadata_work.file_field as ffi ON ffi.format = ffo.format
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.field_mapping table, which belongs directly to the import model
	 * specified by its id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyFieldMapping($importModelId) {
		$sql = "INSERT INTO metadata.field_mapping(src_data, src_format, dst_data, dst_format, mapping_type)
				SELECT DISTINCT fim.src_data, fim.src_format, fim.dst_data, fim.dst_format, fim.mapping_type
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				INNER JOIN metadata_work.format as fo ON fo.format = df.format
				INNER JOIN metadata_work.field_mapping as fim ON fim.src_format = df.format
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.dataset_fields table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyDatasetFields($importModelId) {
		$sql = "INSERT INTO metadata.dataset_fields(dataset_id, schema_code, format, data)
				SELECT DISTINCT df.dataset_id, df.schema_code, df.format, df.data
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_fields as df ON df.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the import model located in metadata_work.dataset table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyImportModel($importModelId) {
		$sql = "INSERT INTO metadata.dataset(dataset_id, label, is_default, definition, type)
				SELECT DISTINCT d.dataset_id, d.label, d.is_default, d.definition, d.type
				FROM metadata_work.dataset d
				WHERE d.dataset_id = :importModelId AND d.type = 'IMPORT'";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.model_datasets table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyModelDatasets($importModelId) {
		$sql = "INSERT INTO metadata.model_datasets(model_id, dataset_id)
				SELECT DISTINCT md.model_id, md.dataset_id
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.model_datasets as md ON md.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Copies the data located in metadata_work.dataset_files table, specified by the import model id.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 */
	public function copyDatasetFiles($importModelId) {
		$sql = "INSERT INTO metadata.dataset_files(dataset_id, format)
				SELECT DISTINCT df.dataset_id, df.format
				FROM metadata_work.dataset d
				INNER JOIN metadata_work.dataset_files as df ON df.dataset_id = d.dataset_id
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
	}

	/**
	 * Checks if an import model exists in the metatada_work schema.
	 *
	 * @param string $importModelId
	 *        	the id of the import model
	 * @return boolean
	 */
	public function isImportModelPresentInTableDataset($importModelId) {
		$sql = "SELECT DISTINCT count(*)
				FROM metadata_work.dataset AS d
				WHERE d.dataset_id = :importModelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':importModelId', $importModelId);
		$stmt->execute();
		if ($stmt->fetchColumn(0) == 0) {
			return false;
		}
		return true;
	}

	/**
	 * Returns true if an import model is published.
	 *
	 * @param $importModelId the
	 *        	id of the import model
	 *
	 * @return boolean
	 */
	public function isPublished($importModelId) {
		$published = false;

		$sql = "SELECT count(*) from metadata.dataset WHERE dataset_id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $importModelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) === 1) {
			$published = true;
		}

		$this->conn->close();

		return $published;
	}

	/**
	 * Checks if, for a given import model, the model has at least one file
	 *
	 * @param $modelId : the id of the import model
	 * @return bool
	 */
	public function importModelHasFiles($modelId) {
		$sql = "SELECT count(*) from metadata_work.dataset_files WHERE dataset_id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$hasFiles =  ($stmt->fetchColumn(0) >= 1) ;

		$this->conn->close();

		return $hasFiles;
	}

	/**
	 * Checks if, for a given import model, every file has at least one non-technical field
	 *
	 * @param $modelId : the id of the import model
	 * @return bool
	 */
	public function importModelFilesHaveFields($modelId) {
		$sql = "SELECT df.format AS fileformat, COUNT(ffi.data) AS nbfields
				FROM metadata_work.dataset_files df
				LEFT JOIN metadata_work.file_field ffi ON df.format = ffi.format
				WHERE df.dataset_id = ?
				GROUP BY df.format;";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$filesHaveFields = true;
		while ($row = $stmt->fetch()) {
			// no technical fields, unlike data tables.
			if ($row['nbfields'] == 0) {
				$filesHaveFields = false;
			}
		}

		return $filesHaveFields;
	}

	/**
	 * Checks if, for a given import model, every file has at least one field mapped
	 *
	 * @param $modelId : the id of the import model
	 * @return bool
	 */
	public function importModelFilesAreMapped($modelId) {
		$sql = "SELECT df.format AS fileformat, fm.mapping_type AS type, COUNT(fm.src_data) AS nbmappings
				FROM metadata_work.dataset_files df
				LEFT JOIN metadata_work.field_mapping fm ON df.format = fm.src_format
				WHERE df.dataset_id = ?
				GROUP BY df.format, fm.mapping_type;";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		$filesAllMapped = true;
		while ($row = $stmt->fetch()) {
			// no technical fields, unlike data tables.
			if ( ($row['type'] == 'FILE' || empty($row['type']) ) && $row['nbmappings'] == 0 ) {
				$filesAllMapped = false;
			}
		}
		return $filesAllMapped;
	}

	/**
	 * Returns true if it is possible to publish the import model.
	 * The import model :
	 * - must NOT be published
	 * - must have its associated data model published
	 * - must have at least one file
	 * - must have at least one field in all its files.
	 * - must have at least one mapped field in all its files.
	 *
	 * @param $modelId: the	id of the model
	 * @return boolean
	 */
	public function isPublishable($modelId) {

		$publishable = (
			!$this->isPublished($modelId)
			&& $this->isImportModelDataModelPublished($modelId)
			&& $this->importModelHasFiles($modelId)
			&& $this->importModelFilesHaveFields($modelId)
			&& $this->importModelFilesAreMapped($modelId)
		);

		return $publishable;
	}
}