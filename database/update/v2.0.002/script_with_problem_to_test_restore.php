<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	$sqlCodeWithError = "SELECT erreur FROM erreur;";
	
	$result = pg_query($sqlCodeWithError);
	
	// If an error occurred pg_query will return false
	if (!$result) {
		echo "An sql error occurred.\n";
		echo "$sprintDir/update_db_sprint.php\n";
		echo "exception: " . pg_last_error($dbconn) . "\n";
		exit(1);
	}
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}