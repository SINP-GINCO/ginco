<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	
	$columnToChange = 'deedatetransformation';
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	$query = "SELECT tablename FROM pg_tables WHERE schemaname = 'raw_data' AND tablename LIKE 'model%'";
	
	$result = pg_query($query);
	
	while ($table = pg_fetch_assoc($result)) {
		echo "Traitement sur la table : " . $table['tablename'] . "\n";
		
		$alterTable = "ALTER TABLE " . $table['tablename'] . " DROP COLUMN IF EXISTS $columnToChange";
		
		pg_query($alterTable);
	}
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}