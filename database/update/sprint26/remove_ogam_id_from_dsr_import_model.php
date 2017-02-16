<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	$columnName = "OGAM_ID_table_observation";
	$fileFormat = 'file_observation';
	$tableFormat = 'table_observation';
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";

	/**
	 * ********************
	 * Update the metamodel
	 * ********************
	 */

	// Delete occurences of the column in any of the model description tables
	deleteFromMetadataModel('metadata', $columnName, $fileFormat, $tableFormat);
	deleteFromMetadataModel('metadata_work', $columnName, $fileFormat, $tableFormat);

	// Update metadata schemas table 'file_field' for positions
	updateFileFieldPositions('metadata', $fileFormat, $columnName);
	updateFileFieldPositions('metadata_work', $fileFormat, $columnName);

	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

function deleteFromMetadataModel($schema, $columnName, $fileFormat, $tableFormat) {
	echo "Deleting $columnName data from schema $schema\n";
	$deleteFromMetamodel = "
		DELETE FROM $schema.field_mapping WHERE src_data = '$columnName'
		AND src_format = '$fileFormat' AND dst_format = '$tableFormat';
		DELETE FROM $schema.file_field WHERE data='$columnName' AND format='$fileFormat';
		DELETE FROM $schema.field WHERE data='$columnName' AND format='$fileFormat';";

	pg_query($deleteFromMetamodel);
}

function updateFileFieldPositions($schema, $format, $columnName) {
	echo "Updating positions in 'file_field' table related to '$format' format in schema $schema\n";

	$getPositions = "
		SELECT DISTINCT data
		FROM $schema.file_field
		WHERE format = '$format'
		ORDER BY data ASC";

	$results = pg_query($getPositions);
	$position = 1;

	while ($row = pg_fetch_assoc($results)) {
		$data = $row['data'];
		$insert = "
			UPDATE $schema.file_field SET position = $position WHERE data = '$data'";
		pg_query($insert);
		$position ++;
	}
}
