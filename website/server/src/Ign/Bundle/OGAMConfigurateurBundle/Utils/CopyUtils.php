<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;

use Ign\Bundle\GincoBundle\Entity\Metadata\Dataset;
use Ign\Bundle\GincoBundle\Entity\Metadata\Model;

use Monolog\Logger;

/**
 * Utility class for all copy methods in a database used for publication and duplication services.
 *
 * @author Gautam Pastakia
 *
 */
class CopyUtils extends DatabaseUtils {

	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * Copies the data located in data table, which belongs directly to the model
	 * specified by its id.
	 * Note : Use of pg_query function, without preparing the statement, is allowed here as the only
	 * parameter here is the model id, which is generated on the server side.
	 * It was chosen instead of prepared statement as it allows multiple queries, instead of one.
	 * Note 2 : We use bulk upsert with locking table feature. It is necessarry as table already
	 * contains rows that we want to insert.
	 *
	 * @param $modelId the
	 *        	id of the model
	 * @param
	 *        	dbconn PDO connection to the db
	 * @return boolean true if transaction succeeded, false otherwise
	 */
	public function copyData($modelId, $dbConn) {
		if ($dbConn == null) {
			$dbConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());
		}

		$sql = 'CREATE TEMPORARY TABLE data_temp(data varchar(174),
				unit varchar(36), label varchar(60), definition varchar(255),
				comment varchar(255)) ON COMMIT DROP;
				INSERT INTO data_temp(data, unit, label, definition, comment)
				SELECT DISTINCT dtj.data, dtj.unit, dtj.label, dtj.definition, dtj.comment FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = \'' . $modelId . '\'
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_field as tfi ON tfi.format = tfo.format
				INNER JOIN metadata.data as dtj ON dtj.data = tfi.data;
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
		if (!pg_query($dbConn, $sql)) {
			return false;
		}
		return true;
	}

	/**
	 * Copies the data located which belongs directly to the model specified by its id,
	 * from 'metadata.format' table to 'metadata.format' table, which belongs directly to the model.
	 *
	 * @param string $modelId
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 */
	public function copyFormat($modelId, $destSchema, $duplicate) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT fo.format, fo.type
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.format as fo ON fo.format = mt.table_id
				WHERE m.id = $1 AND fo.type = 'TABLE'";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".format(format, type) VALUES ($1, $2)";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				pg_execute($this->pgConn, "", array(
					$row['format'] . '_copy',
					$row['type']
				));
			} else {
				pg_execute($this->pgConn, "", array(
					$row['format'],
					$row['type']
				));
			}
		}
	}

	/**
	 * Copies the data located in metadata.table_format table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 * @param $copiedModelId string
	 *        	optional parameter used for table_name in duplication.
	 */
	public function copyTableFormat($modelId, $destSchema, $duplicate, $copiedModelId = NULL) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT tfo.format, tfo.table_name, tfo.schema_code, tfo.primary_key, tfo.label , tfo.definition
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = m.id
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				WHERE m.id = $1";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".table_format(format, table_name, schema_code, primary_key, label, definition)
						VALUES ($1, $2, $3, $4, $5, $6)";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				pg_execute($this->pgConn, "", array(
					$row['format'] . '_copy',
					$copiedModelId . '_' . $row['label'],
					$row['schema_code'],
					$row['primary_key'],
					$row['label'],
					$row['definition']
				));
			} else {
				pg_execute($this->pgConn, "", array(
					$row['format'],
					$row['table_name'],
					$row['schema_code'],
					$row['primary_key'],
					$row['label'],
					$row['definition']
				));
			}
		}
	}

	/**
	 * Copies the data located in metadata.table_tree table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 */
	public function copyTableTree($modelId, $destSchema, $duplicate) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT ttr.schema_code, ttr.child_table, ttr.parent_table, ttr.join_key, ttr.comment
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_schema as tsc ON tsc.schema_code = tfo.schema_code
				INNER JOIN metadata.table_tree as ttr ON ttr.schema_code = tsc.schema_code AND ttr.child_table = tfo.format";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".table_tree(schema_code, child_table, parent_table, join_key, comment)
						VALUES ($1, $2, $3, $4, $5)";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				if ($row['parent_table'] == null) {
					$parentTable = null;
				} else {
					$parentTable = $row['parent_table'] . '_copy';
				}
				pg_execute($this->pgConn, "", array(
					$row['schema_code'],
					$row['child_table'] . '_copy',
					$parentTable,
					$row['join_key'],
					$row['comment']
				));
			} else {
				pg_execute($this->pgConn, "", array(
					$row['schema_code'],
					$row['child_table'],
					$row['parent_table'],
					$row['join_key'],
					$row['comment']
				));
			}
		}
	}

	/**
	 * Copies the data located in metadata.field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 */
	public function copyField($modelId, $destSchema, $duplicate) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT f.data, f.format, f.type
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.field as f ON f.format = tfo.format";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".field(data, format, type) VALUES ($1, $2, $3);";
		pg_prepare($this->pgConn, "", $insertQuery);

		// Count the number of occurences of the data field. Only single occurences are deleted
		$count = "SELECT DISTINCT count(*) FROM metadata.field
					WHERE data = :data AND format = :format AND type = :type";
		$stmt = $this->conn->prepare($count);

		while ($row = pg_fetch_assoc($results)) {
			$stmt->bindParam(':data', $row['data']);
			$stmt->bindParam(':format', $row['format']);
			$stmt->bindParam(':type', $row['type']);
			$stmt->execute();
			$count = $stmt->fetchColumn(0);
			if ($duplicate) {
				pg_execute($this->pgConn, "", array(
					$row['data'],
					$row['format'] . '_copy',
					$row['type']
				));
			} else {
				if ($count == 0) {
					pg_execute($this->pgConn, "", array(
						$row['data'],
						$row['format'],
						$row['type']
					));
				}
			}
		}
	}

	/**
	 * Copies the data located in metadata.table_field table, which belongs directly to the model
	 * specified by its id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata or metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 */
	public function copyTableField($modelId, $destSchema, $duplicate) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT tfi.data, tfi.format, tfi.column_name, tfi.is_calculated, tfi.is_editable, tfi.is_insertable, tfi.is_mandatory, tfi.position, tfi.comment
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1
				INNER JOIN metadata.table_format as tfo ON tfo.format = mt.table_id
				INNER JOIN metadata.table_field as tfi ON tfi.format = tfo.format";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".table_field(data, format, column_name, is_calculated, is_editable, is_insertable, is_mandatory, position, comment) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9);";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				pg_execute($this->pgConn, "", array(
					$row['data'],
					$row['format'] . '_copy',
					$row['column_name'],
					$row['is_calculated'],
					$row['is_editable'],
					$row['is_insertable'],
					$row['is_mandatory'],
					$row['position'],
					$row['comment']
				));
			} else {
				pg_execute($this->pgConn, "", array(
					$row['data'],
					$row['format'],
					$row['column_name'],
					$row['is_calculated'],
					$row['is_editable'],
					$row['is_insertable'],
					$row['is_mandatory'],
					$row['position'],
					$row['comment']
				));
			}
		}
	}

	/**
	 * Copies the model located in metadata.model table, specified by the model id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata or metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 * @param $copyModelName string
	 *        	the name of the copied model. Only for duplication.
	 * @param $copyModelDescription string
	 *        	the description of the copied model. Only for duplication.
	 * @return the generated id of the model if duplicate is true.
	 */
	public function copyModel($modelId, $destSchema, $duplicate, $copyModelName = NULL, $copyModelDescription = NULL) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT m.id, m.name, m.description, m.schema_code, m.status
				FROM metadata.model m
				WHERE m.id = $1";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));

		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".model(id, name, description, schema_code, status) VALUES ($1, $2, $3, $4, $5);";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				$copiedModelId = uniqid('model_');
				pg_execute($this->pgConn, "", array(
					$copiedModelId,
					$copyModelName,
					$copyModelDescription,
					$row['schema_code'],
					Model::UNPUBLISHED
				));
				return $copiedModelId;
			} else {
				pg_execute($this->pgConn, "", array(
					$row['id'],
					$row['name'],
					$row['description'],
					$row['schema_code'],
					$row['status']
				));
			}
		}
	}

	/**
	 * Copies the data located in metadata.model_tables table, specified by the model id.
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @param $destSchema string
	 *        	the destination schema of the data (metadata or metadata)
	 * @param $duplicate boolean
	 *        	wether the method is called for duplication or not.
	 * @param $copiedModelId string
	 *        	the id of the copied model. Only for duplication.
	 */
	public function copyModelTables($modelId, $destSchema, $duplicate, $copiedModelId = NULL) {
		$this->pgConn = pg_connect("host=" . $this->conn->getHost() . " dbname=" . $this->conn->getDatabase() . " user=" . $this->conn->getUsername() . " password=" . $this->conn->getPassword()) or die('Connection is impossible : ' . pg_last_error());

		// Select all values
		$selectQuery = "SELECT DISTINCT mt.model_id, mt.table_id
				FROM metadata.model m
				INNER JOIN metadata.model_tables as mt ON mt.model_id = $1";

		pg_prepare($this->pgConn, "", $selectQuery);
		$results = pg_execute($this->pgConn, "", array(
			$modelId
		));
		// Prepare insert statement for each value
		$insertQuery = "INSERT INTO " . $destSchema . ".model_tables(model_id, table_id) VALUES ($1, $2);";
		pg_prepare($this->pgConn, "", $insertQuery);

		while ($row = pg_fetch_assoc($results)) {
			if ($duplicate) {
				pg_execute($this->pgConn, "", array(
					$copiedModelId,
					$row['table_id'] . '_copy'
				));
			} else {
				pg_execute($this->pgConn, "", array(
					$row['model_id'],
					$row['table_id']
				));
			}
		}
	}

	/**
	 * Creates a "query dataset", ie a dataset used by Ogam to visualize data
	 * What Ogam needs is entries in table 'dataset_fields', with dataset_id = our new dataset.
	 * The dataset must be linked to the model, and we use a special and new type, 'QUERY',
	 * to distinguish them from other types of dataset (IMPORT, ...)
	 *
	 * @param $modelId string
	 *        	the id of the model
	 * @throws \Doctrine\DBAL\DBALException
	 */
	public function createQueryDataset($modelId, $dbconn) {

		// Don't create a query dataset if a dataset linked to the model
		// already have entries in dataset_fields
		$datasetId = $this->hasQueryDataset($modelId) ;
		if ($datasetId) {
			return $datasetId;
		}

		// Get model attributes
		$sql = "SELECT name, schema_code FROM metadata.model
				WHERE id = $1";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$modelId
		));

		if (!$row = pg_fetch_assoc($result)) {
			return;
		}
		$modelName = $row['name'];

		// Generates an id for the dataset with the same method as for other datasets (uniqid())
		$datasetId = (new Dataset())->addId()->getId();

		// Create a query Dataset in metadata ;
		$definition = "Dataset de visualisation pour le modèle '$modelName '";
		$sql = "INSERT INTO metadata.dataset(dataset_id, label, is_default, definition, type )
 				VALUES ($1, $2, 0, $3, 'QUERY')";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array(
			$datasetId,
			$modelName,
			$definition
		));

		// Create a link with the model
		$sql = "INSERT INTO metadata.model_datasets(model_id, dataset_id)
 				VALUES ($1, $2)";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array(
			$modelId,
			$datasetId
		));

		// Creates all Datasets_Fields from tableFields linked to the model
		$sql = "SELECT tfo.schema_code, tfo.format, tfi.data
				FROM metadata.table_format tfo
				INNER JOIN metadata.model_tables mt ON mt.table_id = tfo.format
				INNER JOIN metadata.table_field as tfi ON tfi.format = tfo.format
				WHERE mt.model_id = $1";
		pg_prepare($dbconn, "", $sql);
		$result = pg_execute($dbconn, "", array(
			$modelId
		));
		$rows = pg_fetch_all($result);

		foreach ($rows as $row) {
			$sql = "INSERT INTO metadata.dataset_fields(dataset_id, schema_code, format, data)
					VALUES ($1, $2, $3, $4)";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$datasetId,
				$row['schema_code'],
				$row['format'],
				$row['data']
			));
		}

		return $datasetId;
	}

	/**
	 * Creates entries in Form_Field table, and also in Form_Format.
	 * Needed by OGAM to query the data.
	 *
	 * @param string $modelId
	 * @param unknown $datasetId
	 * @param unknown $dbconn
	 */
	public function createFormFields($modelId, $datasetId, $dbconn) {
		// Create a form_format entry for each table_format of the model.
		// Order results by format because format is like their time of creation
		$sql = "SELECT tfo.format, tfo.label
				FROM metadata.table_format tfo
				INNER JOIN metadata.model_tables mt ON mt.table_id = tfo.format
				WHERE mt.model_id = $1
				ORDER BY tfo.format";
		pg_prepare($dbconn, "", $sql);
		$results = pg_execute($dbconn, "", array(
			$modelId
		));
		$rows = pg_fetch_all($results);

		// A table for keeping track of which table_format corresponds to each form_format
		$table_form = array();

		foreach ($rows as $count => $row) {
			// Generate a new format using uniquid()
			$format = uniqid('form_');
			$table_form[$row['format']] = $format;

			// Inserting a format
			$sql = "INSERT INTO metadata.format(format, type)
					VALUES ($1, 'FORM')";
			pg_prepare($dbconn, "", $sql);
			$results = pg_execute($dbconn, "", array(
				$format
			));

			// Inserting the corresponding form_format
			$definition = "Formulaire de visualisation pour '" . $row['label'] . "'";
			$position = $count + 1;
			$sql = "INSERT INTO metadata.form_format(format, label, definition, position, is_opened)
					VALUES ($1, $2, $3, $4, 1)";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$format,
				$row['label'],
				$definition,
				$position
			));

			// Create dataset_forms
			$sql = "INSERT INTO metadata.dataset_forms(dataset_id, format)
					VALUES ($1, $2)";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$datasetId,
				$format
			));
		}

		// Insert form_field entries for each table_field
		$sql = "SELECT tfo.schema_code, tfo.format, tfi.data, u.type, u.subtype
				FROM metadata.table_format tfo
				INNER JOIN metadata.model_tables mt ON mt.table_id = tfo.format
				INNER JOIN metadata.table_field tfi ON tfi.format = tfo.format
				INNER JOIN metadata.data d ON d.data = tfi.data
				INNER JOIN metadata.unit u ON d.unit = u.unit
				WHERE mt.model_id = $1";
		pg_prepare($dbconn, "", $sql);
		$results = pg_execute($dbconn, "", array(
			$modelId
		));
		$rows = pg_fetch_all($results);

		foreach ($rows as $count => $row) {
			// Insert the field
			$sql = "INSERT INTO metadata.field(data, format, type)
					VALUES ($1, $2, 'FORM')";
			pg_prepare($dbconn, "", $sql);
			$results = pg_execute($dbconn, "", array(
				$row['data'],
				$table_form[$row['format']]
			));

			// Insert the form_field
			$convert = new TypesConvert();
			$type = $convert->UnitToInput($row['type'], $row['subtype']);
			$mask = ($type == 'DATE') ? 'yyyy-MM-dd' : null;
			$position = $count + 1;

			$sql = "INSERT INTO metadata.form_field(data, format, is_criteria, is_result,
					input_type, position, is_default_criteria, is_default_result, mask)
					VALUES ($1, $2, 1, 1, $3, $4, 0, 1, $5)";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$row['data'],
				$table_form[$row['format']],
				$type,
				$position,
				$mask
			));

			// Insert the field mapping
			$sql = "INSERT INTO metadata.field_mapping(src_data, src_format, dst_data, dst_format, mapping_type)
					VALUES ($1, $2, $3, $4, 'FORM')";
			pg_prepare($dbconn, "", $sql);
			pg_execute($dbconn, "", array(
				$row['data'],
				$table_form[$row['format']],
				$row['data'],
				$row['format']
			));
		}
	}

	/**
	 * Tests if there is already in metadata schema, one or several datasets related to the model,
	 * and with entries in 'dataset_fields' which refer to these datasets.
	 *
	 * @param
	 *        	$modelId
	 * @return int|false ($datasetId)
	 * @throws \Doctrine\DBAL\DBALException
	 */
	public function hasQueryDataset($modelId) {
		$sql = "SELECT d.dataset_id from metadata.dataset d
				INNER JOIN metadata.dataset_fields df ON d.dataset_id = df.dataset_id
				INNER JOIN metadata.model_datasets md ON d.dataset_id = md.dataset_id
 				WHERE md.model_id = ?";
		$stmt = $this->conn->prepare($sql);
		$stmt->bindValue(1, $modelId);
		$stmt->execute();

		if ($datasetId = $stmt->fetchColumn(0)) {
			return $datasetId;
		} else {
			return false;
		}
	}

	/**
	 * Checks if a copy of a model exists.
	 *
	 * @param string $modelName
	 *        	the name of the model
	 * @return boolean
	 */
	public function modelHasCopy($modelName) {
		$sql = "SELECT DISTINCT count(*)
				FROM metadata.model AS m
				WHERE m.name = :modelName";
		$stmt = $this->conn->prepare($sql);
		$copyName = $modelName . '_copy';

		$stmt->bindParam(':modelName', $copyName);
		$stmt->execute();
		if ($stmt->fetchColumn(0) == 0) {
			return false;
		}
		return true;
	}
}