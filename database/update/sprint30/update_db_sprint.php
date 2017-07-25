<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -----------------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 29 to sprint 30
// -----------------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 29 to 30\n");
	echo ("> php update_db_sprint.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)) {
		echo ("$mess\n\n");
		exit(1);
	}
	exit();
}

if (count($argv) == 1)
	usage();
$config = loadPropertiesFromArgs();

try {
	/* patch code here*/
	execCustSQLFile("$sprintDir/add_jdd_table_and_jdd_evolutions.sql", $config);
	execCustSQLFile("$sprintDir/add_jdd_id_download_service_url.sql", $config);
	execCustSQLFile("$sprintDir/add_event_listener_jdd_service.sql", $config);
	execCustSQLFile("$sprintDir/add_event_listener_generate_reports_service.sql", $config);
	execCustSQLFile("$sprintDir/update_bbox.sql", $config);
	execCustSQLFile("$sprintDir/update_sensitive_species.sql", $config);
	execCustSQLFile("$sprintDir/update_apb_and_pnr_en_layer_names.sql", $config);
	execCustSQLFile("$sprintDir/add_messages_table.sql", $config);
	execCustSQLFile("$sprintDir/add_dee_table.sql", $config);
	execCustSQLFile("$sprintDir/enable_model_to_be_null_in_jdd_table.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
//  system("php $sprintDir/script1.php $CLIParams", $returnCode1);
// system("php $sprintDir/script2.php $CLIParams", $returnCode2);
/*
if ($returnCode1 != 0 || $returnCode2 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
*/