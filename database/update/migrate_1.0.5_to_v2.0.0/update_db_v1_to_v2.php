<?php
$currentDir = dirname(__FILE__);
require_once "$currentDir/../../../lib/share.php";

// -----------------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 30 to sprint 32
// -----------------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint v1.0.5 (zend) to v2.0.0 (SF2)\n");
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

//-- Sprint 25 - MInus migration of predefined requests
//
$sprintDir = realpath($currentDir . '/../sprint25');

try {
	// Zend 1 --> Symfony 2 migration
	execCustSQLFile("$sprintDir/add_extension_pg_trgm.sql", $config);
	execCustSQLFile("$currentDir/update_db_to_v4.sql", $config); // new one - without predefined requests migration
	execCustSQLFile("$sprintDir/update_layers_and_layer_tree.sql", $config);
	/* Restore a result_location table - temporary - to test visu in Ogam */
	execCustSQLFile("$sprintDir/restore_result_location.sql", $config);

	// Other
	execCustSQLFile("$sprintDir/reorder_layer_tree.sql", $config);
	execCustSQLFile("$sprintDir/add_integration_service_event_listener.sql", $config);

} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

//-- Sprint 26
//
// C'est bon rien à faire

//-- Sprint 27
//
//// C'est bon rien à faire

//-- Sprint 28 / v1.0.1
//
$sprintDir = realpath($currentDir . '/../sprint28');

try {
	execCustSQLFile("$sprintDir/update_users_table.sql", $config);
} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


//-- Sprint 29 / v1.0.2
//
$sprintDir = realpath($currentDir . '/../sprint29');

try {
	execCustSQLFile("$sprintDir/ref_deefloutagevalue.sql", $config);
	execCustSQLFile("$sprintDir/update_bbox_params.sql", $config);
	execCustSQLFile("$sprintDir/change_time_case.sql", $config);
} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


//-- Sprint 30 / v1.0.3
//
$sprintDir = realpath($currentDir . '/../sprint30');

try {
	execCustSQLFile("$sprintDir/add_event_listener_jdd_service.sql", $config);
	execCustSQLFile("$sprintDir/add_event_listener_generate_reports_service.sql", $config);
	execCustSQLFile("$sprintDir/update_bbox.sql", $config);
	execCustSQLFile("$sprintDir/enable_model_to_be_null_in_jdd_table.sql", $config);
} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


//-- Migration of jdd and dee tables
//
try {
	$sprintDir = realpath($currentDir . '/../sprint30');
	execCustSQLFile("$sprintDir/add_messages_table.sql", $config); // DROP jobs and CREATE messages
	execCustSQLFile("$currentDir/migrate_jdds_and_dee.sql", $config); // Migrate structure and datas
} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


//-- Migration of predefined requests with datas
//
try {
	execCustSQLFile("$currentDir/migrate_saved_requests.sql", $config); // Migrate structure and datas
} catch (Exception $e) {
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

//-- Version update
//
try {
	execCustSQLFile("$currentDir/version.sql", $config); // Migrate structure and datas
} catch (Exception $e) {
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