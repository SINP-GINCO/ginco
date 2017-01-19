<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	$columnName = "nomvalide";
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";

	/**
	 * ********************
	 * Update the metamodel
	 * ********************
	 */

	// Delete occurences of nomvalide in any of the model description tables
	deleteFromMetadataModel('metadata', $columnName);
	deleteFromMetadataModel('metadata_work', $columnName);

	// Update metadata schemas table 'data'
	updateData('metadata', $columnName);
	updateData('metadata_work', $columnName);

	// Update metadata schemas table 'field'
	updateFields('metadata', 'TABLE', $columnName);
	updateFields('metadata', 'FORM', $columnName);
	updateFields('metadata_work', 'TABLE', $columnName);
	updateFields('metadata_work', 'FORM', $columnName);

	// Update metadata schemas table 'table_field'
	updateTableFields('metadata', $columnName);
	updateTableFields('metadata_work', $columnName);

	// Update metadata schemas table 'form_field'
	updateFormFields('metadata', $columnName);
	updateFormFields('metadata_work', $columnName);

	// Update metadata schemas table 'form_field'
	updateDatasetFields('metadata', $columnName);
	updateDatasetFields('metadata_work', $columnName);

	// Update metadata schemas table 'field_mapping'
	updateFieldMapping('metadata', $columnName);
	updateFieldMapping('metadata_work', $columnName);

	/**
	 * *************
	 * Update tables
	 * *************
	 */

	$query = "SELECT tablename FROM pg_tables WHERE schemaname = 'raw_data' AND tablename LIKE 'model%'";
	$result = pg_query($query);

	while ($table = pg_fetch_assoc($result)) {

		$tableName = $table['tablename'];
		echo "Traitement sur la table : $tableName\n";

		$dropColumn = "ALTER TABLE $tableName DROP COLUMN IF EXISTS $columnName";
		pg_query($dropColumn);

		$addColumn = "ALTER TABLE $tableName ADD COLUMN $columnName varchar(500)";
		pg_query($addColumn);

		$getPrimaryKeys = "
			SELECT a.attname AS pk_column
			FROM pg_index i
			JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
			WHERE i.indrelid = '$tableName'::regclass AND i.indisprimary;";
		$results = pg_query($getPrimaryKeys);

		$pkeys = array();
		while ($row = pg_fetch_assoc($results)) {
			$pkeys[] = $row['pk_column'];
		}

		$fillColumn = "
			UPDATE $tableName AS m SET $columnName = lb_name
			FROM (
				SELECT lb_name, $pkeys[0], $pkeys[1]
				FROM metadata.mode_taxref AS t, $tableName AS m
				WHERE COALESCE(cdref, cdnom) = t.code
			) AS lb_names
			WHERE lb_names.$pkeys[0] = m.$pkeys[0]
			AND lb_names.$pkeys[1] = m.$pkeys[1]";
		pg_query($fillColumn);
	}
	echo "Traitement sur la table terminé.\n";
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

function deleteFromMetadataModel($schema, $columnName) {
	echo "Deleting nomvalide data from schema $schema\n";
	$deleteFromMetamodel = "
		DELETE FROM $schema.dataset_fields WHERE data='$columnName';
		DELETE FROM $schema.field_mapping WHERE src_data='$columnName';
		DELETE FROM $schema.file_field WHERE data='$columnName';
		DELETE FROM $schema.table_field WHERE data='$columnName';
		DELETE FROM $schema.form_field WHERE data='$columnName';
		DELETE FROM $schema.field WHERE data='$columnName';
		DELETE FROM $schema.data WHERE data='$columnName';";

	pg_query($deleteFromMetamodel);
}

function updateData($schema, $columnName) {
	echo "Adding nomvalide in table data in schema $schema\n";
	$insert = "
		INSERT INTO $schema.data(data, unit, label, definition, comment)
		VALUES ('$columnName','CharacterString','$columnName','Le nomValide est le nom du taxon correspondant au cd_ref',NULL);";
	pg_query($insert);
}

function updateFields($schema, $type, $columnName) {
	echo "Adding nomvalide in table field in schema $schema with type $type\n";

	$select = "
		SELECT DISTINCT format FROM $schema.field
		WHERE data IN ('cdref', 'cdnom')
		AND type = '$type'";

	$results = pg_query($select);

	while ($row = pg_fetch_assoc($results)) {
		$format = $row['format'];
		$insert = "
			INSERT INTO $schema.field
			VALUES ('$columnName', '$format', '$type')";
		pg_query($insert);
	}
}

function updateTableFields($schema, $columnName) {
	echo "Adding nomvalide in table table_field in schema $schema\n";

	$select = "
			SELECT DISTINCT format FROM $schema.table_field
			WHERE data IN ('cdref', 'cdnom')";

	$results = pg_query($select);

	while ($row = pg_fetch_assoc($results)) {
		$tableFormat = $row['format'];
		// There is no need to update the position of the table_fields as this attribute is not used in the application
		$insert = "
			INSERT INTO $schema.table_field(data, format, column_name, is_calculated, is_editable, is_insertable, is_mandatory, comment)
			VALUES ('$columnName', '$tableFormat', '$columnName', '1', '1', '1', '0', NULL)";
		pg_query($insert);
	}
}

function updateFormFields($schema, $columnName) {
	echo "Adding nomvalide in table form_field in schema $schema\n";

	$select = "
		SELECT DISTINCT format FROM $schema.form_field
		WHERE data IN ('cdref', 'cdnom')";

	$results = pg_query($select);

	while ($row = pg_fetch_assoc($results)) {
		$formFormat = $row['format'];
		$insert = "
			INSERT INTO $schema.form_field(
			data, format, is_criteria, is_result, input_type, is_default_criteria,
			is_default_result, default_value, decimals, mask)
			VALUES ('$columnName', '$formFormat', '1', '1', 'TEXT', '0', '0', NULL, NULL, NULL)";
		pg_query($insert);
	}

	// Update the position of the form_fields
	echo "Updating positions in table form_field in schema $schema\n";
	$getPositions = "
		SELECT DISTINCT data, format
		FROM $schema.form_field
		ORDER BY data ASC";

	$results = pg_query($getPositions);
	$position = 1;

	while ($row = pg_fetch_assoc($results)) {
		$data = $row['data'];
		$format = $row['format'];
		$insert = "
			UPDATE $schema.form_field SET position = $position WHERE data = '$data' AND format = '$format'";
		pg_query($insert);
		$position ++;
	}
}

function updateDatasetFields($schema, $columnName) {
	echo "Adding nomvalide in table dataset_fields in schema $schema\n";

	$select = "
		SELECT DISTINCT dataset_id, format FROM $schema.dataset_fields AS d
		WHERE data IN ('cdref', 'cdnom')";

	$results = pg_query($select);

	while ($row = pg_fetch_assoc($results)) {
		$dataset = $row['dataset_id'];
		$format = $row['format'];
		$insert = "
			INSERT INTO $schema.dataset_fields VALUES('$dataset', 'RAW_DATA', '$format', '$columnName');";
		pg_query($insert);
	}
}

function updateFieldMapping($schema, $columnName) {
	echo "Adding nomvalide in table field_mapping in schema $schema\n";

	$select = "
		SELECT DISTINCT src_format, dst_format FROM $schema.field_mapping AS d
		WHERE dst_data IN ('cdref', 'cdnom')
		AND mapping_type = 'FORM'";

	$results = pg_query($select);

	while ($row = pg_fetch_assoc($results)) {
		$srcformat = $row['src_format'];
		$dstFormat = $row['dst_format'];
		$insert = "
			INSERT INTO $schema.field_mapping VALUES('$columnName', '$srcformat', '$columnName', '$dstFormat', 'FORM');";
		pg_query($insert);
	}
}
