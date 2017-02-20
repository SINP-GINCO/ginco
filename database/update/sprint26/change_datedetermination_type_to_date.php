<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	/* Change dateDetermination type from dateTime to date, in metadata and metadata_work, and update the data in raw_data. */
	$columnsToChange = ['datedetermination'];
	
	foreach ($columnsToChange as $columnToChange) {
		
		$updateMetadataQuery = "
			UPDATE metadata_work.data SET unit='Date' WHERE data ='$columnToChange';
			UPDATE metadata.data SET unit='Date' WHERE data = '$columnToChange';"
		;
		pg_query($updateMetadataQuery);
		
		$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = '$columnToChange' AND data_type= 'timestamp with time zone'";
		$tablesToUpdate = pg_query($tablesToUpdateQuery);
		
		while ($table = pg_fetch_assoc($tablesToUpdate)) {
			echo "Traitement sur la table : " . $table['table_name'] . "\n";
			
			$alterTable = "ALTER TABLE " . $table['table_name'] . " ALTER COLUMN $columnToChange SET DATA TYPE Date";
			
			pg_query($alterTable);
		}
	}
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}