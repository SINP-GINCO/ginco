<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	/* Change dateDetermination type from dateTime to date, in metadata and metadata_work, and update the data in raw_data. */
	$columnsToChange = ['jourdatedebut', 'jourdatefin'];
	
	foreach ($columnsToChange as $columnToChange) {
		$updateMetadataQuery = "
			UPDATE metadata_work.data SET unit='Date' WHERE data ='$columnToChange';
			UPDATE metadata.data SET unit='Date' WHERE data = '$columnToChange';"
		;
		pg_query($updateMetadataQuery);
		
		$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = '$columnToChange'";
		$tablesToUpdate = pg_query($tablesToUpdateQuery);

		while ($table = pg_fetch_assoc($tablesToUpdate)) {
			echo "Traitement sur la table : " . $table['table_name'] . "\n";
			
			// Drop trigger to change jourdatefin type (as we cannot modify the type of a column if used in a trigger)
			$disableTrigger = "DROP TRIGGER sensitive_automatic" . $table['table_name'] . " ON raw_data." . $table['table_name'] . ";";
			pg_query($disableTrigger);
			
			$alterTable = "ALTER TABLE " . $table['table_name'] . " ALTER COLUMN $columnToChange SET DATA TYPE Date";
			pg_query($alterTable);
			
			// Recreate trigger
			$enableTrigger = "CREATE TRIGGER sensitive_automatic" . $table['table_name'] . "
								BEFORE UPDATE OF cdref, cdnom, jourdatefin, occstatutbiologique, codedepartementcalcule
								ON raw_data." . $table['table_name'] . "
								FOR EACH ROW
								EXECUTE PROCEDURE raw_data.sensitive_automatic();";
			pg_query($enableTrigger);
		}
	}
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

