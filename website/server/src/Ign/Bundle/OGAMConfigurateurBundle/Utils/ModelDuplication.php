<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;
use Doctrine\ORM\ORMException;

use Ign\Bundle\GincoBundle\Entity\Metadata\Model;
use Ign\Bundle\GincoBundle\Entity\Metadata\TableFormat;

use Monolog\Logger;

/**
 * Utility class for duplication of a model into a database.
 *
 * @author Gautam Pastakia
 *
 */
class ModelDuplication extends DatabaseUtils {

	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * Duplicate a model by copying all the data related to a specific model, then generates
	 * the model in the database.
	 * Algorithm : copy all the data directly, but by adding a '_copy' suffix to formats.
	 * Then update primary keys by updating all rows with a generated id, which is kept throughout
	 * the process to have the same id in every table.
	 *
	 *
	 * @param Model $model
	 *        	the model to copy
	 * @param $copyModelName string
	 *        	the name of the copied model.
	 * @param $copyModelDescription string
	 *        	the description of the copied model.
	 * @return a message id explaining the result of the operation.
	 */
	public function duplicateModel(Model $model, Model $copyModel) {
		$this->conn->beginTransaction();
		$copyUtils = new CopyUtils($this->conn, $this->logger, $this->adminName, $this->adminPassword);
		$modelId = $model->getId();

		if ($copyUtils->modelHasCopy($model->getName())) {
			return 'datamodel.duplicate.hasCopy';
		}

		$destSchema = 'metadata';
		
		$copyModelName = $copyModel->getName() ;
		$copyModelDescription = $copyModel->getDescription() ;
		$copyModelId = $copyModel->getId() ;
		
		// Copy data without modifying primary keys
		$copyUtils->copyModel($modelId, $destSchema, true, $copyModelId, $copyModelName, $copyModelDescription);
		$copyUtils->copyFormat($modelId, $destSchema, true);
		$copyUtils->copyTableFormat($modelId, $destSchema, true, $copyModelId);
		$copyUtils->copyTableTree($modelId, $destSchema, true);
		$copyUtils->copyField($modelId, $destSchema, true);
		$copyUtils->copyTableField($modelId, $destSchema, true);
		$copyUtils->copyModelTables($modelId, $destSchema, true, $copyModelId);

		// Change primary keys
		$this->updatePrimaryKeys($model, $copyModelId);

		try {
			$this->conn->commit();
			$this->conn->close();
		} catch (ORMException $e) {
			$this->conn->rollback();
			$this->conn->close();
			return 'datamodel.duplicate.fail';
		}

		return 'datamodel.duplicate.success';
	}

	/**
	 * Updates all formats referenced by the model to have correctly generated ids.
	 *
	 * @param Model $model
	 *        	the model
	 * @param string $copiedModelId
	 *        	the id of the duplicated model
	 */
	public function updatePrimaryKeys($model, $copiedModelId) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " port=" . $this->conn->getPort() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());
		// Trick to pass unit tests - deallocate all prepared statements
		pg_query($this->pgConn, "DEALLOCATE ALL");
		// Select all values from format
		$selectFormatQuery = "SELECT DISTINCT mt.table_id as format
				FROM metadata.model_tables mt
				WHERE mt.model_id = $1";
		pg_prepare($this->pgConn, "select_format_query", $selectFormatQuery);
		$formatResults = pg_execute($this->pgConn, "select_format_query", array(
			$copiedModelId
		));

		// Select values from table_format (but execute in while statement).
		$selectTableFormatQuery = "SELECT DISTINCT tfo.format, tfo.table_name, tfo.schema_code, tfo.primary_key, tfo.label , tfo.definition
				FROM metadata.table_format tfo
				WHERE tfo.format = $1";
		pg_prepare($this->pgConn, "select_table_format_query", $selectTableFormatQuery);

		// Select values from field (but execute in while statement).
		$selectFieldQuery = "SELECT DISTINCT f.data, f.format, f.type
				FROM metadata.field f
				WHERE f.format = $1";
		pg_prepare($this->pgConn, "select_field_query", $selectFieldQuery);

		// Prepare insert statement for format row
		$insertFormatQuery = "INSERT INTO metadata.format(format, type) VALUES ($1, $2)";
		pg_prepare($this->pgConn, "insert_format_query", $insertFormatQuery);
		// Prepare insert statement for table_format row
		$insertFormatQuery = "INSERT INTO metadata.table_format(format, table_name, schema_code, primary_key, label, definition)
						VALUES ($1, $2, $3, $4, $5, $6)";
		pg_prepare($this->pgConn, "insert_table_format_query", $insertFormatQuery);
		// Prepare insert statement for field row
		$insertFormatQuery = "INSERT INTO metadata.field(data, format, type) VALUES ($1, $2, $3)";
		pg_prepare($this->pgConn, "insert_field_query", $insertFormatQuery);

		// Prepare update statement for table_tree parent_table column
		$insertTableTreeParentQuery = "UPDATE metadata.table_tree SET parent_table = $1 WHERE parent_table = $2";
		pg_prepare($this->pgConn, "update_table_tree_parent_query", $insertTableTreeParentQuery);
		// Prepare update statement for table_tree child_table column
		$insertTableTreeParentQuery = "UPDATE metadata.table_tree SET child_table = $1 WHERE child_table = $2";
		pg_prepare($this->pgConn, "update_table_tree_child_query", $insertTableTreeParentQuery);
		// Prepare update statement for table_field row
		$insertTableFieldQuery = "UPDATE metadata.table_field SET format = $1 WHERE format = $2";
		pg_prepare($this->pgConn, "update_table_field_query", $insertTableFieldQuery);
		// Prepare update statement for model_tables row
		$insertModelTablesQuery = "UPDATE metadata.model_tables SET table_id = $1 WHERE table_id = $2";
		pg_prepare($this->pgConn, "update_model_tables_query", $insertModelTablesQuery);

		// Prepare delete statement for field rows
		$deleteFieldQuery = "DELETE FROM metadata.field WHERE format = $1";
		pg_prepare($this->pgConn, "delete_field_query", $deleteFieldQuery);
		// Prepare delete statement for table_format row
		$deleteTableFormatQuery = "DELETE FROM metadata.table_format WHERE format = $1";
		pg_prepare($this->pgConn, "delete_table_format_query", $deleteTableFormatQuery);
		// Prepare delete statement for format row
		$deleteFormatQuery = "DELETE FROM metadata.format WHERE format = $1";
		pg_prepare($this->pgConn, "delete_format_query", $deleteFormatQuery);

		// For each table format
		while ($row = pg_fetch_assoc($formatResults)) {
			// Generate new id for format
			$finalFormatId = uniqid('table_');
			// Insert new row in format
			pg_execute($this->pgConn, "insert_format_query", array(
				$finalFormatId,
				'TABLE'
			));
			// Select table_format row...
			$tableFormatPg = pg_execute($this->pgConn, "select_table_format_query", array(
				$row['format']
			));
			$tableFormat = pg_fetch_assoc($tableFormatPg);
			// ... and insert it
			$primaryKey = TableFormat::PK_PREFIX . $finalFormatId . ', PROVIDER_ID, USER_LOGIN';
			pg_execute($this->pgConn, "insert_table_format_query", array(
				$finalFormatId,
				$tableFormat['table_name'],
				$tableFormat['schema_code'],
				$primaryKey,
				$tableFormat['label'],
				$tableFormat['definition']
			));

			// Select field rows...
			$fieldRows = pg_execute($this->pgConn, "select_field_query", array(
				$row['format']
			));
			// ... and insert them
			while ($fieldRow = pg_fetch_assoc($fieldRows)) {
				pg_execute($this->pgConn, "insert_field_query", array(
					$fieldRow['data'],
					$finalFormatId,
					$fieldRow['type']
				));
			}

			// Execute all updates in all other tables
			pg_execute($this->pgConn, "update_table_tree_parent_query", array(
				$finalFormatId,
				$row['format']
			));
			pg_execute($this->pgConn, "update_table_tree_child_query", array(
				$finalFormatId,
				$row['format']
			));
			pg_execute($this->pgConn, "update_table_field_query", array(
				$finalFormatId,
				$row['format']
			));
			pg_execute($this->pgConn, "update_model_tables_query", array(
				$finalFormatId,
				$row['format']
			));

			// Delete former rows
			pg_execute($this->pgConn, "delete_field_query", array(
				$row['format']
			));
			pg_execute($this->pgConn, "delete_table_format_query", array(
				$row['format']
			));
			pg_execute($this->pgConn, "delete_format_query", array(
				$row['format']
			));

			// Handle primary key renaming
			$this->addPrimaryKeyToDataTable(explode(',', $tableFormat['primary_key'])[0], TableFormat::PK_PREFIX . $finalFormatId, $finalFormatId);
		}

		pg_close($this->pgConn);
	}

	/**
	 *
	 * Adds the correct primary key for the duplicated table. Updates the primary key
	 * for field and table_field tables. Updates column_name in table_field (necessary for
	 * tables generation part).
	 *
	 * @param string $originalPK
	 *        	the value of the original primary key (form: ogam_id_<table_format>)
	 * @param string $duplicatedPK
	 *        	the value of the duplicated primary key (form: ogam_id_<table_format>)
	 * @param string $tableFormat
	 *        	the format (id) of the table
	 */
	public function addPrimaryKeyToDataTable($originalPK, $duplicatedPK, $tableFormat) {
		// Get values of original PK
		$selectOGPKQuery = "SELECT * FROM metadata.data WHERE data = $1";
		pg_prepare($this->pgConn, "", $selectOGPKQuery);
		$results = pg_execute($this->pgConn, "", array(
			$originalPK
		));
		$originalPKRow = pg_fetch_assoc($results);

		// Get label of the table
		$selectTableLabel = "SELECT label FROM metadata.table_format WHERE format = $1";
		pg_prepare($this->pgConn, "", $selectTableLabel);
		$labelRes = pg_execute($this->pgConn, "", array(
			$tableFormat
		));
		$tableLabel = pg_fetch_result($labelRes, 'label');

		// Insert data field of PK in data table
		$insertPKDataFieldQuery = "INSERT INTO metadata.data(data, unit, label, definition) VALUES($1, $2, $3, $4)";
		pg_prepare($this->pgConn, "", $insertPKDataFieldQuery);
		pg_execute($this->pgConn, "", array(
			$duplicatedPK,
			$originalPKRow['unit'],
			"Clé primaire table " . $tableLabel,
			"Clé primaire table " . $tableLabel
		));

		// update field row for primary key (and via cascade table_field also)
		$insertFieldQuery = "UPDATE metadata.field SET data = $1 WHERE format = $2 AND data = $3";
		pg_prepare($this->pgConn, "", $insertFieldQuery);
		pg_execute($this->pgConn, "", array(
			$duplicatedPK,
			$tableFormat,
			$originalPK
		));

		// update tablefield row column name for primary key
		$insertTableFieldQuery = "UPDATE metadata.table_field SET column_name = $1 WHERE format = $2 AND data = $3";
		pg_prepare($this->pgConn, "", $insertTableFieldQuery);
		pg_execute($this->pgConn, "", array(
			strtolower($duplicatedPK),
			$tableFormat,
			$duplicatedPK
		));
	}
}