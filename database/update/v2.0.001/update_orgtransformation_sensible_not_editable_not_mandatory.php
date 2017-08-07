<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	$columnToChange = 'orgtransformation';
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	// Update metadata and metadata_work
	$queryMetadata = "UPDATE metadata.table_field SET is_editable=0, is_mandatory=0 WHERE data = 'orgtransformation';
						UPDATE metadata.table_field SET is_editable=0 WHERE data = 'sensible';
						UPDATE metadata_work.table_field SET is_editable=0, is_mandatory=0 WHERE data = 'orgtransformation';
						UPDATE metadata_work.table_field SET is_editable=0 WHERE data = 'sensible';";
	$result = pg_query($queryMetadata);
	
	// Update raw_data tables
	$query = "select table_name from information_schema.columns where table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = '$columnToChange'";
	$result = pg_query($query);
	
	while ($table = pg_fetch_assoc($result)) {
		echo "Traitement sur la table : " . $table['table_name'] . "\n";
		
		$alterTable = "ALTER TABLE " . $table['table_name'] . " ALTER COLUMN $columnToChange DROP NOT NULL";
		
		pg_query($alterTable);
	}
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}