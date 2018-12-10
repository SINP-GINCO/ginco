<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;
use Doctrine\DBAL\DBALException;
use Monolog\Logger;
use Symfony\Component\Debug\Exception\ContextErrorException;

/**
 * Utility class for unpublication of a model into a database.
 *
 * @author Gautam Pastakia
 *
 */
class ModelUnpublication extends DatabaseUtils {

	/**
	 *
	 * @var PDO connection with admin rights.
	 */
	private $adminPgConn;

	/**
	 * @var string The PDO connection with admin rights connections parameters
	 */
	private $connParams;

	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
		$this->connParams = "host=" . $conn->getHost() . " dbname=" . $conn->getDatabase() . " user=" . $adminName . " password=" . $adminPassword;
		try{
			$this->adminPgConn = pg_connect($this->connParams);
		} catch(ContextErrorException $e){
			$this->logger->error($e);
		}

	}

	/**
	 * Unpublishes a model by deleting all the data related to a specific model, then
	 * dropping generated tables and sequences related to these tables.
	 *
	 * @param $modelId the
	 *        	id of the model
	 * @return true if unpublication succeded, false otherwise
	 */
	public function unpublishModel($modelId) {
		try {
			if ($this->isModelPresentInProdSchema($modelId)) {
				$this->adminPgConn = pg_connect($this->connParams);
				pg_query($this->adminPgConn, "BEGIN");
				$this->deleteFormFields($modelId);
				$this->deleteQueryDataset($modelId);
				$this->deleteTranslationData($modelId);
				$this->deleteModelTablesData($modelId);
				$this->deleteTableTreeData($modelId);
				$this->deleteTableFieldData($modelId);
				$this->deleteFieldData($modelId);
				$this->deleteDataData($modelId);
				$this->deleteTableFormatData($modelId);
				$this->deleteFormatData($modelId);
				$this->deleteModelData($modelId);
				$this->dropTables($modelId);
				$this->dropTriggerFunctions($modelId);
			} else {
				return false;
			}
			pg_query($this->adminPgConn, "COMMIT");
		} catch (ContextErrorException $e) {
			$this->logger->error($e);
			pg_query($this->adminPgConn, "ROLLBACK");
			return false;
		} catch (DBALException $e) {
			$this->logger->error($e);
			pg_query($this->adminPgConn, "ROLLBACK");
			return false;
		} finally {
			$this->conn->close();
			pg_close($this->adminPgConn);
		}
		return true;
	}

	/**
	 * Deletes all the data located in metadata.data table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteDataData($modelId) {
		// Select all data values
		$selectQuery = "SELECT DISTINCT dtj.data
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON m.id = mt.model_id
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata_work.table_field as tfi ON tfi.format = tfo.format
				INNER JOIN metadata_work.data as dtj ON dtj.data = tfi.data
				AND m.id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each data value
		$deleteSql = "DELETE FROM metadata.data WHERE data = $1";
		pg_prepare($this->adminPgConn, "", $deleteSql);

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field WHERE data = :data";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':data', $row['data']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($count == 0) {
				pg_execute($this->adminPgConn, "", array(
					$row['data']
				));
			}
		}
	}

	/**
	 * Deletes all the data located in metadata.format table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteFormatData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT fo.format, fo.type
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata_work.format as fo ON fo.format = mt.table_id
				WHERE m.id = $1 AND fo.type = 'TABLE'";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.format WHERE format = $1";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['format']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.table_format table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteTableFormatData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT tfo.format
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = $1";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_format WHERE format = $1";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['format']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.table_tree table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteTableTreeData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT ttr.schema_code, ttr.child_table
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata_work.table_schema as tsc ON tsc.schema_code = tfo.schema_code
				INNER JOIN metadata_work.table_tree as ttr ON ttr.schema_code = tsc.schema_code AND ttr.child_table = tfo.format";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_tree WHERE schema_code = $1 AND child_table = $2";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['schema_code'],
				$row['child_table']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteFieldData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT f.data, f.format
					FROM metadata_work.model m
					INNER JOIN metadata_work.model_tables as mt ON mt.model_id = $1
					INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
					INNER JOIN metadata_work.field as f ON f.format = tfo.format";

		pg_prepare($this->adminPgConn, "", $selectQuery);

		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.field WHERE data = $1 AND format = $2";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['data'],
				$row['format']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.table_field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteTableFieldData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT tfi.data, tfi.format
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata_work.table_field as tfi ON tfi.format = tfo.format";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_field WHERE data = $1 AND format = $2";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['data'],
				$row['format']
			));
		}
	}

	/**
	 * Deletes all the model located in metadata.model table, specified by the model id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteModelData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT m.id
				FROM metadata_work.model m
				WHERE m.id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.model WHERE id = $1";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['id']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.model_tables table, specified by the model id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteModelTablesData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT mt.model_id, mt.table_id
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.model_tables WHERE model_id = $1 AND table_id = $2";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['model_id'],
				$row['table_id']
			));
		}
	}

	/**
	 * Deletes all the data located in metadata.translation table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	public function deleteTranslationData($modelId) {
		// Select all values
		$selectQuery = "SELECT DISTINCT t.table_format, t.row_pk
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata_work.translation as t ON t.table_format = mt.table_id
				WHERE m.id = $1";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$modelId
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.translation WHERE table_format = $1";
		pg_prepare($this->adminPgConn, "", $deleteQuery);

		while ($row = pg_fetch_assoc($results)) {
			pg_execute($this->adminPgConn, "", array(
				$row['table_format']
			));
		}
	}

	/**
	 * Delete entries in Form_Field table, and Form_Format.
	 * created at the time of publication in createFormFields.
	 *
	 * @param
	 *        	$modelId
	 */
	public function deleteFormFields($modelId) {
		// Searches all Query Datasets linked to the model ;
		$sql = "SELECT md.dataset_id FROM metadata.model_datasets md
				INNER JOIN metadata.dataset d ON d.dataset_id = md.dataset_id
				WHERE md.model_id = $1
				AND d.type = 'QUERY'";
		pg_prepare($this->adminPgConn, "", $sql);
		$result = pg_execute($this->adminPgConn, "", array(
			$modelId
		));
		$datasets = pg_fetch_all($result);

		// Delete all results (one or zero expected...)
		if ($datasets) {
			foreach ($datasets as $dataset) {
				$datasetId = $dataset['dataset_id'];

				// search all form_formats linked to teh dataset
				$sql = "SELECT ff.format
				 		FROM metadata.form_format ff
						INNER JOIN metadata.dataset_forms df ON ff.format = df.format
						WHERE df.dataset_id = $1";
				pg_prepare($this->adminPgConn, "", $sql);
				$result = pg_execute($this->adminPgConn, "", array(
					$datasetId
				));
				$forms = pg_fetch_all($result);

				if ($forms) {
					foreach ($forms as $form) {
						$format = $form['format'];
						// Delete form_fields, fields, and field_mappings related the form_format
						$deleteQuery = "DELETE FROM metadata.field_mapping WHERE src_format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));
						$deleteQuery = "DELETE FROM metadata.form_field WHERE format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));
						$deleteQuery = "DELETE FROM metadata.field WHERE format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));

						// Delete form_format, format and dataset_forms
						$deleteQuery = "DELETE FROM metadata.dataset_forms WHERE format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));
						$deleteQuery = "DELETE FROM metadata.form_format WHERE format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));
						$deleteQuery = "DELETE FROM metadata.format WHERE format = $1";
						pg_prepare($this->adminPgConn, "", $deleteQuery);
						pg_execute($this->adminPgConn, "", array(
							$format
						));
					}
				}
			}
		}
	}

	/**
	 * Delete the 'Query Dataset' related to the model, and all its related entries
	 * in table 'dataset_fields'.
	 * They are only used in OGAM for visualization, and can't be configured
	 * in the configurator.
	 *
	 * @param
	 *        	$modelId
	 */
	public function deleteQueryDataset($modelId) {
		// Searches all Query Datasets linked to the model ;
		$sql = "SELECT md.dataset_id FROM metadata.model_datasets md
				INNER JOIN metadata.dataset d ON d.dataset_id = md.dataset_id
				WHERE md.model_id = $1
				AND d.type = 'QUERY'";
		pg_prepare($this->adminPgConn, "", $sql);
		$result = pg_execute($this->adminPgConn, "", array(
			$modelId
		));
		$rows = pg_fetch_all($result);

		// Delete all results (one or zero expected...)
		if ($rows) {
			foreach ($rows as $row) {
				$datasetId = $row['dataset_id'];

				// Delete possible predefined requests on this dataset
				$this->dropPredefinedRequests($datasetId);

				// delete from dataset_fields
				$deleteFieldsQuery = "DELETE FROM metadata.dataset_fields WHERE dataset_id = $1";
				pg_prepare($this->adminPgConn, "", $deleteFieldsQuery);
				pg_execute($this->adminPgConn, "", array(
					$datasetId
				));

				// delete form model_datasets
				$deleteLinkQuery = "DELETE FROM metadata.model_datasets WHERE dataset_id = $1";
				pg_prepare($this->adminPgConn, "", $deleteLinkQuery);
				pg_execute($this->adminPgConn, "", array(
					$datasetId
				));

				// delete from dataset
				$deleteQuery = "DELETE FROM metadata.dataset WHERE dataset_id = $1";
				pg_prepare($this->adminPgConn, "", $deleteQuery);
				pg_execute($this->adminPgConn, "", array(
					$datasetId
				));
			}
		}
	}

	/**
	 * Checks if a model exists in the metadata schema.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 * @return boolean
	 */
	public function isModelPresentInProdSchema($modelId) {
		$sql = "SELECT DISTINCT count(*)
				FROM metadata.model AS m
				WHERE m.id = :modelId";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':modelId', $modelId);
		$stmt->execute();
		if ($stmt->fetchColumn(0) == 0) {
			return false;
		}
		return true;
	}

	/**
	 * Returns true if it is possible to unpublish a model.
	 * The model :
	 * - MUST be published
	 * - MUST NOT contain indirectly data
	 *
	 * @param $modelId: the
	 *        	of the model
	 * @return boolean
	 */
	public function isUnpublishable($modelId) {
		$unpublishable = (!$this->isUnpublished($modelId) || !$this->modelHasData($modelId));

		return $unpublishable;
	}

	/**
	 * Returns true if a model is unpublished.
	 *
	 * @param $modelid the
	 *        	id of the model
	 *
	 * @return boolean
	 */
	public function isUnpublished($modelId) {
		$unpublished = false;

		$sql = "SELECT count(*) from metadata.model WHERE id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		if ($stmt->fetchColumn(0) === 0) {
			$unpublished = true;
		}

		$this->conn->close();

		return $unpublished;
	}

	/**
	 * Checks if a model has data by checking that no tables of this model have data.
	 *
	 * @param string $modelId
	 *        	: the id of the model
	 * @return boolean
	 */
	public function modelHasData($modelId) {
		// Get model tables
		$sql = "SELECT DISTINCT table_schema AS schema,table_name AS label
				FROM information_schema.tables
				WHERE table_name LIKE ?";
		$stmt = $this->adminConn->prepare($sql);
		$stmt->bindValue(1, $modelId . '%');
		$stmt->execute();

		$results = $stmt->fetchAll();

		foreach ($results as $table) {
			$sql = "SELECT count(*) FROM " . $table['schema'] . '.' . $table['label'];
			$stmt = $this->adminConn->prepare($sql);
			$stmt->execute();
			if ($stmt->fetchColumn(0) > 0) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Retrieves all the import models linked to a data model.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 * @return multitype: the ids of the import models.
	 */
	public function getImportModelsFromDataModel($modelId) {
		$sql = "SELECT d.dataset_id
				FROM metadata_work.dataset AS d
				INNER JOIN metadata_work.model_datasets AS md ON md.dataset_id = d.dataset_id
				AND md.model_id = :modelId
				WHERE d.type = 'IMPORT'";

		$stmt = $this->conn->prepare($sql);
		$stmt->bindParam(':modelId', $modelId);
		$stmt->execute();
		$results = array();

		$i = 0;
		foreach ($stmt->fetchAll() as $row) {
			$results[$i] = $row['dataset_id'];
			$i = $i + 1;
		}
		return $results;
	}

	/**
	 * Drops all the tables generated for the model specified by its id.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 */
	public function dropTables($modelId) {
		$sql = "SELECT DISTINCT tfo.table_name
				FROM metadata_work.model m
				INNER JOIN metadata_work.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata_work.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = :modelId";

		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindParam(':modelId', $modelId);
		$selectStmt->execute();

		foreach ($selectStmt->fetchAll() as $row) {
			pg_query($this->adminPgConn, 'DROP TABLE IF EXISTS ' . 'raw_data.' . $row['table_name'] . ' CASCADE');
			pg_query($this->adminPgConn, 'DROP TABLE IF EXISTS ' . 'harmonized_data.' . $row['table_name'] . ' CASCADE');
		}
	}

	/**
	 * Drops trigger functions used to generate a unique id for primary keys
	 *
	 * @param
	 *        	$modelId
	 * @throws \Doctrine\DBAL\DBALException
	 */
	public function dropTriggerFunctions($modelId) {
		$sql = "SELECT DISTINCT tfo.table_name, tfo.schema_code
				FROM metadata_work.table_format tfo
				INNER JOIN metadata_work.model_tables as mt ON tfo.format = mt.table_id
				WHERE mt.model_id = :modelId";

		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindParam(':modelId', $modelId);
		$selectStmt->execute();

		foreach ($selectStmt->fetchAll() as $row) {
			$this->logger->debug("trigger function table name : " . $row['table_name']);

			$sqlSelectFunctions = "SELECT proname FROM pg_proc WHERE proname LIKE '%" . $row['table_name'] . "'";
			$selectFunctionsStmt = $this->conn->prepare($sqlSelectFunctions);
			$selectFunctionsStmt->execute();

			foreach ($selectFunctionsStmt->fetchAll() as $row2) {
				pg_query($this->adminPgConn, 'DROP FUNCTION IF EXISTS ' . $row['schema_code'] . '.' . $row2['proname'] . '() CASCADE');
			}
		}
	}

	/**
	 * Drops predefined requests
	 *
	 * @param string $datasetId
	 *        	the query dataset
	 * @throws \Doctrine\DBAL\DBALException
	 */
	public function dropPredefinedRequests($datasetId) {
		$this->logger->debug("drop predefined requests for dataset : " . $datasetId);

		// Get the predefined requests and group linked to the dataset_id
		$sql = "SELECT group_id
					FROM metadata.dataset d
					LEFT JOIN website.predefined_request_group prg on prg.label = d.label
					WHERE d.type = 'QUERY'
					AND d.dataset_id = :datasetId";
		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindParam(':datasetId', $datasetId);
		$selectStmt->execute();
		$row = $selectStmt->fetch();
		$datasetGroupId = $row['group_id'];

		if ($datasetId) {
			$sql = "DELETE FROM website.predefined_request WHERE dataset_id = $1";
			pg_prepare($this->adminPgConn, "", $sql);
			pg_execute($this->adminPgConn, "", array(
				$datasetId
			));
		}

		if ($datasetGroupId) {
			$sql = "DELETE FROM website.predefined_request_group WHERE group_id = $1";
			pg_prepare($this->adminPgConn, "", $sql);
			pg_execute($this->adminPgConn, "", array(
				$datasetGroupId
			));
		}
	}
}
