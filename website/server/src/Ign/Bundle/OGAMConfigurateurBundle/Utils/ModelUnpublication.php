<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\DBALException;
use Doctrine\ORM\EntityManagerInterface ;

use Monolog\Logger;

use Symfony\Component\Debug\Exception\ContextErrorException;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;

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
	
	/**
	 *
	 * @var EntityManagerInterface
	 */
	private $entityManager ;

	
	
	public function __construct(EntityManagerInterface $entityManager, Logger $logger, $adminName, $adminPassword) {
		
		$this->entityManager = $entityManager ;
		$conn = $entityManager->getConnection() ;
		
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
	public function unpublishModel(Model $model) {
		
		$model->setStatus(Model::UNPUBLISHED) ;
		$this->entityManager->flush() ;
		return true ;
	}
	
	
	/**
	 * Unpublishes a model by deleting all the data related to a specific model, then
	 * dropping generated tables and sequences related to these tables.
	 *
	 * @param $modelId the
	 *        	id of the model
	 * @return true if unpublication succeded, false otherwise
	 */
	public function deleteModel(Model $model) {
		
		try {
			
			$queries = array() ;
			
			$this->adminPgConn = pg_connect($this->connParams);
			$queries[] = "BEGIN";
			$queries = array_merge($queries, $this->deleteFormFields($model));
			$queries = array_merge($queries, $this->deleteQueryDataset($model));
			$queries = array_merge($queries, $this->deleteTranslationData($model));
			$queries = array_merge($queries, $this->deleteModelTablesData($model));
			$queries = array_merge($queries, $this->deleteTableTreeData($model));
			$queries = array_merge($queries, $this->deleteTableFieldData($model));
			$queries = array_merge($queries, $this->deleteFieldData($model));
			$queries = array_merge($queries, $this->deleteDataData($model));
			$queries = array_merge($queries, $this->deleteTableFormatData($model));
			$queries = array_merge($queries, $this->deleteFormatData($model));
			$queries = array_merge($queries, $this->deleteModelData($model));
			$queries = array_merge($queries, $this->dropTables($model));
			$queries = array_merge($queries, $this->dropTriggerFunctions($model));
			$queries[] = "COMMIT";
			
			foreach ($queries as $query) {
				pg_query($this->adminPgConn, $query) ;
			}
			
			$this->entityManager->remove($model) ;
			$this->entityManager->flush() ;
			
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
	private function deleteDataData(Model $model) {
		
		$queries = array() ;
		
		// Select all data values
		$selectQuery = "SELECT DISTINCT dtj.data
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON m.id = mt.model_id
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_field as tfi ON tfi.format = tfo.format
				INNER JOIN metadata.data as dtj ON dtj.data = tfi.data
				AND m.id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each data value
		$deleteSql = "DELETE FROM metadata.data WHERE data = '%s'";

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field WHERE data = :data";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':data', $row['data']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($count == 0) {
				$queries[] = sprintf($deleteSql, row['data']) ;
			}
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.format table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteFormatData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT fo.format, fo.type
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.format as fo ON fo.format = mt.table_id
				WHERE m.id = $1 AND fo.type = 'TABLE'";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.format WHERE format = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['format']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.table_format table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteTableFormatData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT tfo.format
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = $1";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_format WHERE format = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['format']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.table_tree table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteTableTreeData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT ttr.schema_code, ttr.child_table
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_schema as tsc ON tsc.schema_code = tfo.schema_code
				INNER JOIN metadata.table_tree as ttr ON ttr.schema_code = tsc.schema_code AND ttr.child_table = tfo.format";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_tree WHERE schema_code = '%s' AND child_table = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['schema_code'], $row['child_table']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteFieldData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT f.data, f.format
					FROM metadata.model m
					INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
					INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
					INNER JOIN metadata.field as f ON f.format = tfo.format";

		pg_prepare($this->adminPgConn, "", $selectQuery);

		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.field WHERE data = '%s' AND format = '%s'";

		while ($row = pg_fetch_assoc($results)) {	
			$queries[] = sprintf($deleteQuery, $row['data'], $row['format']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.table_field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteTableFieldData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT tfi.data, tfi.format
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_field as tfi ON tfi.format = tfo.format";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.table_field WHERE data = '%s' AND format = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['data'], $row['format']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the model located in metadata.model table, specified by the model id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteModelData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT m.id
				FROM metadata.model m
				WHERE m.id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.model WHERE id = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['id']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.model_tables table, specified by the model id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteModelTablesData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT mt.model_id, mt.table_id
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1";
		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.model_tables WHERE model_id = '%s' AND table_id = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['model_id'], $row['table_id']) ;
		}
		
		return $queries ;
	}

	/**
	 * Deletes all the data located in metadata.translation table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId the
	 *        	id of the model
	 */
	private function deleteTranslationData(Model $model) {
		
		$queries = array() ;
		
		// Select all values
		$selectQuery = "SELECT DISTINCT t.table_format, t.row_pk
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.translation as t ON t.table_format = mt.table_id
				WHERE m.id = $1";

		pg_prepare($this->adminPgConn, "", $selectQuery);
		$results = pg_execute($this->adminPgConn, "", array(
			$model->getId()
		));

		// Prepare delete statement for each value
		$deleteQuery = "DELETE FROM metadata.translation WHERE table_format = '%s'";

		while ($row = pg_fetch_assoc($results)) {
			$queries[] = sprintf($deleteQuery, $row['table_format']) ;
		}
		
		return $queries ;
	}

	/**
	 * Delete entries in Form_Field table, and Form_Format.
	 * created at the time of publication in createFormFields.
	 *
	 * @param
	 *        	$modelId
	 */
	private function deleteFormFields(Model $model) {
		
		$queries = array() ;
		
		// Searches all Query Datasets linked to the model ;
		$sql = "SELECT md.dataset_id FROM metadata.model_datasets md
				INNER JOIN metadata.dataset d ON d.dataset_id = md.dataset_id
				WHERE md.model_id = $1
				AND d.type = 'QUERY'";
		pg_prepare($this->adminPgConn, "", $sql);
		$result = pg_execute($this->adminPgConn, "", array(
			$model->getId()
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
						$deleteQuery = "DELETE FROM metadata.field_mapping WHERE src_format = '%s'";
						$queries[] = sprintf($deleteQuery, $format) ;
						
						$deleteQuery = "DELETE FROM metadata.form_field WHERE format = '%s'";
						$queries[] = sprintf($deleteQuery, $format) ;
						
						$deleteQuery = "DELETE FROM metadata.field WHERE format = '%s'";
						$queries[] = sprintf($deleteQuery, $format);
						
						
						// Delete form_format, format and dataset_forms
						$deleteQuery = "DELETE FROM metadata.dataset_forms WHERE format = '%s'";
						$queries[] = sprintf($deleteQuery, $format) ;
						
						$deleteQuery = "DELETE FROM metadata.form_format WHERE format = '%s'";
						$queries[] = sprintf($deleteQuery, $format) ;
						
						$deleteQuery = "DELETE FROM metadata.format WHERE format = '%s'";
						$queries[] = sprintf($deleteQuery, $format) ;
					}
				}
			}
		}
		
		return $queries ;
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
	private function deleteQueryDataset(Model $model) {
		
		$queries = array() ;
		
		$queryDatasets = $model->getQueryDatasets() ;

		// Delete all results (one or zero expected...)
		foreach ($queryDatasets as $dataset) {
			$datasetId = $dataset->getId();

			// Delete possible predefined requests on this dataset
			$queries = array_merge($queries, $this->dropPredefinedRequests($dataset));

			// delete from dataset_fields
			$deleteFieldsQuery = "DELETE FROM metadata.dataset_fields WHERE dataset_id = '%s'";
			$queries[] = sprintf($deleteFieldsQuery, $datasetId) ;

			// delete form model_datasets
			$deleteLinkQuery = "DELETE FROM metadata.model_datasets WHERE dataset_id = '%s'";
			$queries[] = sprintf($deleteLinkQuery, $datasetId) ;
			
			// delete from dataset
			$deleteQuery = "DELETE FROM metadata.dataset WHERE dataset_id = '%s'";
			$queries[] = sprintf($deleteQuery, $datasetId) ;
		}
		
		return $queries ;
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
	 * Drops all the tables generated for the model specified by its id.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 */
	private function dropTables(Model $model) {
		
		$queries = array() ;
		
		$sql = "SELECT DISTINCT tfo.table_name
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = :modelId";

		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindValue(':modelId', $model->getId());
		$selectStmt->execute();

		foreach ($selectStmt->fetchAll() as $row) {
			$queries[] = 'DROP TABLE IF EXISTS ' . 'raw_data.' . $row['table_name'] . ' CASCADE' ;
			$queries[] = 'DROP TABLE IF EXISTS ' . 'harmonized_data.' . $row['table_name'] . ' CASCADE';
		}
		
		return $queries ;
	}

	/**
	 * Drops trigger functions used to generate a unique id for primary keys
	 *
	 * @param
	 *        	$modelId
	 * @throws \Doctrine\DBAL\DBALException
	 */
	private function dropTriggerFunctions(Model $model) {
		
		$queries = array() ;
		
		$sql = "SELECT DISTINCT tfo.table_name, tfo.schema_code
				FROM metadata.table_format tfo
				INNER JOIN metadata.model_tables as mt ON tfo.format = mt.table_id
				WHERE mt.model_id = :modelId";

		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindValue(':modelId', $model->getId());
		$selectStmt->execute();

		foreach ($selectStmt->fetchAll() as $row) {
			$this->logger->debug("trigger function table name : " . $row['table_name']);

			$sqlSelectFunctions = "SELECT proname FROM pg_proc WHERE proname LIKE '%" . $row['table_name'] . "'";
			$selectFunctionsStmt = $this->conn->prepare($sqlSelectFunctions);
			$selectFunctionsStmt->execute();

			foreach ($selectFunctionsStmt->fetchAll() as $row2) {
				$queries[] = 'DROP FUNCTION IF EXISTS ' . $row['schema_code'] . '.' . $row2['proname'] . '() CASCADE' ;
			}
		}
		
		return $queries ;
	}

	/**
	 * Drops predefined requests
	 *
	 * @param string $datasetId
	 *        	the query dataset
	 * @throws \Doctrine\DBAL\DBALException
	 */
	private function dropPredefinedRequests(Dataset $dataset) {
		
		$queries = array() ;
		
		$this->logger->debug("drop predefined requests for dataset : " . $dataset->getId());

		// Get the predefined requests and group linked to the dataset_id
		$sql = "SELECT group_id
					FROM metadata.dataset d
					LEFT JOIN website.predefined_request_group prg on prg.label = d.label
					WHERE d.type = 'QUERY'
					AND d.dataset_id = :datasetId";
		$selectStmt = $this->conn->prepare($sql);
		$selectStmt->bindValue(':datasetId', $dataset->getId());
		$selectStmt->execute();
		$row = $selectStmt->fetch();
		$datasetGroupId = $row['group_id'];

		if ($dataset) {
			$sql = "DELETE FROM website.predefined_request WHERE dataset_id = '%s'";
			$queries[] = sprintf($sql, $dataset->getId()) ;
		}

		if ($datasetGroupId) {
			$sql = "DELETE FROM website.predefined_request_group WHERE group_id = '%s'";
			$queries[] = sprintf($sql, $datasetGroupId) ;
		}
	
		return $queries ;		
	}
}
