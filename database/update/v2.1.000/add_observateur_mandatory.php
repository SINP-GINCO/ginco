<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	/* Make observateuridentite and observateurorganisme mandatory. Update the data in raw_data. */
	$columnsToSetMandatory = [
		'observateuridentite',
		'observateurnomorganisme'
	];
	
	foreach ($columnsToSetMandatory as $columnToChange) {
		// Update metadata and metadata_work
		$observateurMandatory = "
		UPDATE metadata.table_field SET is_mandatory=1 WHERE data = '" . $columnToChange . "';
		UPDATE metadata_work.table_field SET is_mandatory=1 WHERE data = '" . $columnToChange . "';
		
		UPDATE metadata.file_field SET is_mandatory=1 WHERE data = '" . $columnToChange . "';
		UPDATE metadata_work.file_field SET is_mandatory=1 WHERE data = '" .  $columnToChange . "';";
		$observateurMandatoryResult = pg_query($observateurMandatory);
		
		if (!$observateurMandatoryResult) {
			echo "An sql error occurred.\n";
			pg_close($dbconn);
			exit(1);
		}
		
		$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns 
			WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = '" . $columnToChange . "';";
		$tablesToUpdate = pg_query($tablesToUpdateQuery);
		
		while ($table = pg_fetch_assoc($tablesToUpdate)) {
			echo "Traitement sur la table : " . $table['table_name'] . " pour la colonne " . $columnToChange . "\n";
			
			// Set column mandatory in raw_data. If value is null, fill it with Inconnu
			$queryToSetMandatory =
				"UPDATE " . $table['table_name'] . " SET $columnToChange = 'Inconnu' WHERE $columnToChange IS NULL;
				ALTER TABLE " . $table['table_name'] . " ALTER COLUMN $columnToChange SET NOT NULL;";
			$setMandatoryResult = pg_query($queryToSetMandatory);
			
			if (!$setMandatoryResult) {
				echo "An sql error occurred.\n";
				pg_close($dbconn);
				exit(1);
			}
		}
	}
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}