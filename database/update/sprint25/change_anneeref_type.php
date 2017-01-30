<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	/* Change anneerefcommune and anneerefdepartement type from date to integer, in metadata and metadata_work, and update the data in raw_data. */
	$columnsToChange = ['anneerefcommune','anneerefdepartement'];
	
	foreach ($columnsToChange as $columnToChange) {
		
		$updateMetadataQuery = "
			UPDATE metadata_work.data SET unit='Integer' WHERE data ='$columnToChange';
			UPDATE metadata.data SET unit='Integer' WHERE data = '$columnToChange';
			UPDATE metadata_work.form_field SET input_type='NUMERIC', mask=null WHERE data = '$columnToChange';
			UPDATE metadata.form_field SET input_type='NUMERIC', mask=null WHERE data = '$columnToChange';
			UPDATE metadata_work.file_field SET mask=null WHERE data = '$columnToChange';
			UPDATE metadata.file_field SET mask=null WHERE data = '$columnToChange';"
		;
		pg_query($updateMetadataQuery);
		
		$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = '$columnToChange' AND data_type= 'date'";
		$tablesToUpdate = pg_query($tablesToUpdateQuery);
		
		while ($table = pg_fetch_assoc($tablesToUpdate)) {
			echo "Traitement sur la table : " . $table['table_name'] . "\n";
			
			$alterTable = "ALTER TABLE " . $table['table_name'] . " ALTER COLUMN $columnToChange SET DATA TYPE Integer USING (EXTRACT(YEAR FROM $columnToChange))::integer";
			
			pg_query($alterTable);
		}
	}
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}