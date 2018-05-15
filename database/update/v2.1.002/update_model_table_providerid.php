<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	/* Check that role with public request permission have private request permission */
	$config = loadPropertiesFromArgs();
	$config['sprintDir'] = $sprintDir;
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	// Get role with MANAGE_PUBLIC_REQUEST permission
	$listModelsRequest = "SELECT table_name FROM metadata.table_format";
	$listModels = pg_query($listModelsRequest);
	
	if (!$listModels) {
		echo "An sql error occurred.\n";
		pg_close($dbconn);
		exit(1);
	}
	
	// Check if selected roles have private request permission
	while ($result = pg_fetch_assoc($listModels)) {
		
	    $nameTableUpdate = "raw_data.".$result['table_name'];
		
	   $updateProviderModelRequest = "UPDATE ".$nameTableUpdate." SET provider_id = '0'
	       WHERE provider_id = '1'";
	    
		$updateProviderModel = pg_query($updateProviderModelRequest);
		
		if (!$updateProviderModel) {
			echo "An sql error occurred.\n";
			pg_close($dbconn);
			exit(1);
		}
		
	}
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
