<?php
namespace Ign\Bundle\OGAMConfigurateurBundle\Utils;

use Doctrine\DBAL\Connection;

use Monolog\Logger;

/**
 * Utility class for table generation service.
 *
 * TODO : translate this comment
 * Note :Ogam stocke dans table_format.primary_keys des colonnes qui sont plus des champs techniques que des clés primaires.
 * TODO : à vérifier : Cela permet à OGAM de savoir qu'il ne faut pas afficher ces champs lors de la saisie ?
 * Quel rapport avec is_calculated ?
 * Ce ne serait pas un problème de définir la clé primaire suivant cette colonne.
 * $sqlcreatetable = $sqlcreatetable . "constraint PK_" . $table_name . " primary key (" . $table_primary_key . "),
 * unique (" . $table_primary_key . "))";
 * Cependant, on ne saurait pas sur lesquels il faudrait définir une séquence ou non.
 * Les clés primaires peuvent en effet soit être remplies par l'utilisateur (dans ce cas is_calculated vaut 0),
 * soit être "calculées", et dans ce cas, on ne sait pas si ils doivent être remplis par une séquence ou par un trigger.
 *
 * Update 30/11/15 S.Candelier :
 * Pour les besoins de la configuration des liens entre fichiers, qui doivent indiquer les liens entre tables (parent/enfant),
 * on créée pour chaque table une nouvelle entrée dans Data qui est la clé primaire : OGAM_ID_<format_table>
 * Cette clé contient, dans raw_data, soit les valeurs fournies lors de l'import de données, soit un identifiant unique
 * généré par postgre. Un trigger à l'insertion génère cet identifiant si la valeur de la clé primaire n'est pas fournie.
 *
 * @author Anna Mouget
 *
 */
class TablesGeneration extends DatabaseUtils {

	public function __construct(Connection $conn, Logger $logger, $adminName, $adminPassword) {
		parent::__construct($conn, $logger, $adminName, $adminPassword);
	}

	/**
	 * Gets all the tables related to a model, and then generates each one.
	 * Adds foreign key constraints afterwise.
	 *
	 * @param string $modelId
	 */
	public function createTables($modelId, $dbconn) {
		$stmt = $this->selectTablesFormat($modelId);

		while ($row = $stmt->fetch()) {
			$tableFormat = $row['format'];
			$tableSchema = $row['schema_code'];
			$tableName = $row['table_name'];
			$tablePrimaryKey = $row['primary_key'];
			// The "OGAM_ID_xxx" field, part of the pkey.
			$pkeyParts = array_map('trim', explode(',', $tablePrimaryKey));
			$OGAM_ID = 'OGAM_ID_' . $tableFormat; // default, but not always (duplicated model)
			foreach ($pkeyParts as $pkeyPart) {
				if (substr($pkeyPart, 0, 7) == 'OGAM_ID') {
					$OGAM_ID = $pkeyPart;
				}
			}
			$this->createTable($tableFormat, $tableName, $tableSchema, $tablePrimaryKey, $dbconn);
			$this->createPrimaryKeyTrigger($tableSchema, $OGAM_ID, $tableName);
			$this->createGeometryColumn($tableName, $tableSchema, $tableFormat);
			$this->grantAllRights($tableSchema);
		}

		$this->addConstraints($modelId);
	}

	/**
	 * Returns DBAL statement already executed to get list of all tables of model.
	 *
	 * @param string $modelId
	 * @return \Doctrine\DBAL\Statement Statement
	 */
	public function selectTablesFormat($modelId, $dbconn) {
		$sql = "SELECT schema_code,table_name, tf.label, primary_key, format, mt.model_id
				FROM metadata.table_format AS tf, metadata.model_tables AS mt
				WHERE mt.model_id = $1
				AND mt.model_id = $1
				AND mt.table_id = tf.format;";
		pg_prepare($dbconn, "", $sql);

		return pg_execute($dbconn, "", array(
			$modelId
		));
	}

	/**
	 * Create a Trigger on the primary key column :
	 * if the value of the key isn't given by the user, generate a unique id.
	 *
	 * @param $pKeyPart :
	 *        	the "OGAM_ID_XXX" field used in pkey
	 * @param
	 *        	$tableName
	 * @throws \Doctrine\DBAL\DBALException
	 */
	public function createPrimaryKeyTrigger($tableSchema, $pKeyPart, $tableName, $dbconn) {
		$sql = "CREATE OR REPLACE FUNCTION " . $tableSchema . ".pkgenerate" . $tableName . "()
				RETURNS TRIGGER
				LANGUAGE plpgsql
				AS $$
				BEGIN
				IF (NEW." . $pKeyPart . " IS NULL) THEN
				 NEW." . $pKeyPart . "  := uuid_generate_v1();
				END IF;
				RETURN NEW;
				END;
				$$;";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());

		$sql = "CREATE TRIGGER pkgenerate" . $tableName . " BEFORE INSERT ON " . $tableSchema . "." . $tableName . "
				FOR EACH ROW
				EXECUTE PROCEDURE " . $tableSchema . ".pkgenerate" . $tableName . "();";
		pg_prepare($dbconn, "", $sql);
		pg_execute($dbconn, "", array());
	}

	/**
	 *
	 * Generates a table.
	 *
	 * * @param string $modelId
	 * the id of the model
	 *
	 * @param string $tableFormat
	 *        	the format of the table
	 * @param string $label
	 *        	the label of the table
	 * @param string $tableName
	 *        	the name of the table
	 * @param string $tableSchema
	 *        	the schema code of the table
	 */
	public function createTable($tableFormat, $tableName, $tableSchema, $tablePrimaryKey, $dbconn) {
		// Get list of table columns
		$sql = "SELECT lower(column_name) AS column_name, unit.type, unit.unit, table_field.is_mandatory
				FROM metadata.table_field, metadata.unit, metadata.data
				WHERE table_field.data = data.data
				AND data.unit = unit.unit
				AND table_field.format = $1";
		pg_prepare($dbconn, "", $sql);

		$results = pg_execute($dbconn, "", array(
			$tableFormat
		));

		$sqlCreateTable = "CREATE TABLE IF NOT EXISTS " . $tableSchema . "." . $tableName . "(";
		// For each column to create
		while ($row = pg_fetch_assoc($results)) {
			$column_name = $row['column_name'];
			$column_type = $row['type'];
			$column_unit = $row['unit'];
			$column_mandatory = $row['is_mandatory'];

			if ($column_type != "GEOM") {
				$sqlCreateTable = $sqlCreateTable . $column_name . " " . $this->getPostgresTypeFromOgamType($column_type, $column_unit, $column_name);
				if ($column_mandatory == '1') {
					$sqlCreateTable = $sqlCreateTable . ' NOT NULL';
				}
				$sqlCreateTable = $sqlCreateTable . ',';
			}
		}
		$sqlCreateTable = substr($sqlCreateTable, 0, -1) . ")";
		pg_query($dbconn, $sqlCreateTable);

		// Add primary key constraint
		$sqlPK = "ALTER TABLE " . $tableSchema . "." . $tableName . "
  				  ADD PRIMARY KEY (" . $tablePrimaryKey . ");";
		pg_query($dbconn, $sqlPK);
	}

	/**
	 *
	 * Adds constraints to tables (foreign keys).
	 *
	 * @param string $modelId
	 *        	the id of the model
	 */
	public function addConstraints($modelId, $dbconn) {
		$sql = "SELECT tree.schema_code, child.table_name AS child_name, parent.table_name AS parent_name, tree.child_table, tree.parent_table, tree.join_key
				FROM metadata.table_tree tree
				INNER JOIN metadata.table_format child ON tree.child_table = child.format
				INNER JOIN metadata.table_format parent ON tree.parent_table = parent.format
				INNER JOIN metadata.model_tables mt ON mt.table_id = parent.format
				WHERE mt.model_id = $1
				AND tree.parent_table IS NOT NULL";
		pg_prepare($dbconn, "", $sql);
		$results = pg_execute($dbconn, "", array(
			$modelId
		));
		while ($row = pg_fetch_assoc($results)) {

			// Get format of the table referenced
			$schema = $row['schema_code'];
			$childName = $row['child_name'];
			$parentName = $row['parent_name'];
			$joinKey = $row['join_key'];

			$sqlFK = "ALTER TABLE " . $schema . "." . $childName . "
					ADD CONSTRAINT fk" . $parentName . " FOREIGN KEY (" . $joinKey . ")
					REFERENCES " . $schema . "." . $parentName . " (" . $joinKey . ")
					ON DELETE RESTRICT ON UPDATE RESTRICT;";

			pg_prepare($dbconn, "", $sqlFK);
			$results = pg_execute($dbconn, "", array());
		}
	}

	/**
	 *
	 * Creates a geometry column if the table requires it.
	 *
	 * @param string $tableName
	 * @param string $tableSchema
	 * @param string $tableFormat
	 */
	public function createGeometryColumn($tableName, $tableSchema, $tableFormat, $dbconn) {
		// Will the table contain a geometrical column?
		$sqlGeometryType = "SELECT data.data
				FROM metadata.table_field, metadata.unit, metadata.data
				WHERE table_field.data = data.data
				AND data.unit = unit.unit
				AND table_field.format = $1
				AND unit.type = 'GEOM'";
		pg_prepare($dbconn, "", $sqlGeometryType);
		$results = pg_execute($dbconn, "", array(
			$tableFormat
		));

		while ($row = pg_fetch_assoc($results)) {

			$geometrical_column = $row['data'];

			// Add geometrical column
			$sqlGeometryColumn = "SELECT AddGeometryColumn ($1, $2, $3, 4326,'GEOMETRY',2)";
			pg_prepare($dbconn, "", $sqlGeometryColumn);
			pg_execute($dbconn, "", array(
				strtolower($tableSchema),
				strtolower($tableName),
				strtolower($geometrical_column)
			));

			// Add index on the geometry
			$sqlSpatialIndex = "CREATE INDEX " . 'ix' . $tableName . '_' . $geometrical_column . '_spatial_index' . " ON " . $tableSchema . "." . $tableName . " USING GIST(" . $geometrical_column . ")";
			pg_prepare($dbconn, "", $sqlSpatialIndex);
			pg_execute($dbconn, "", array());
		}
	}

	/**
	 * Grants all rights on schema, sequences and tables.
	 * This method use a connection with admin user rights.
	 *
	 * @param $tableSchema schema
	 *        	in which the model is to be published
	 */
	public function grantAllRights($tableSchema) {
		$sqlGrantSch = "GRANT ALL ON SCHEMA " . $tableSchema . " TO ogam, " . $this->adminName . ";";
		$stmt = $this->adminConn->prepare($sqlGrantSch);
		$stmt->execute();

		$sqlGrantSeq = "GRANT ALL ON ALL SEQUENCES IN SCHEMA " . $tableSchema . " TO ogam, " . $this->adminName . ";";
		$stmt = $this->adminConn->prepare($sqlGrantSeq);
		$stmt->execute();

		$sqlGrantTab = "GRANT ALL ON ALL TABLES IN SCHEMA " . $tableSchema . " TO ogam, " . $this->adminName . ";";
		$stmt = $this->adminConn->prepare($sqlGrantTab);
		$stmt->execute();
	}

	/**
	 * Returns the Postgres type corresponding to Ogam type.
	 *
	 * @param $ogamType ogam
	 *        	type coming from unit table type column.
	 *
	 * @return Postgres type
	 */
	public function getPostgresTypeFromOgamType($ogamType, $ogamUnit, $columnName) {
		switch ($ogamType) {
			case "NUMERIC":
				$result = "float8";
				break;
			case "ARRAY":
				$result = "varchar(255)[]";
				break;
			case "CODE":
				$result = "varchar(255)";
				break;
			case "STRING":
				$result = "varchar(255)";
				break;
			case "DATE":
				switch ($ogamUnit) {
					case "Date":
						$result = "date";
						break;
					case "DateTime":
						$result = "timestamp with time zone";
						break;
					default:
						$result = "date";
				}
				break;
			case "TIME":
				$result = "time";
				break;
			case "INTEGER":
				$result = "int8";
				break;
			default:
				$result = "varchar(255)";
		}
		return $result;
	}
}