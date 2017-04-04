<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	/* Delete all data in raw_data tables. */
	$tablesToUpdateQuery = "SELECT DISTINCT(table_name) FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%'";
	$tablesToUpdate = pg_query($tablesToUpdateQuery);
		
	while ($table = pg_fetch_assoc($tablesToUpdate)) {
		echo "Effacement des données de la table : " . $table['table_name'] . "\n";
		$deleteQuery = "TRUNCATE " . $table['table_name'] . ";";
		pg_query($deleteQuery);
				
	}

	/* And in submission, submission_file, export_file */
	pg_query("TRUNCATE raw_data.submission_file;");
	pg_query("TRUNCATE raw_data.export_file CASCADE;");
	pg_query("TRUNCATE raw_data.submission RESTART IDENTITY CASCADE ;");

	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}