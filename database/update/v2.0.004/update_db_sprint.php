<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// ----------------------------------------------------
// Synopsis: migrate DB GINCO from v2.0.002 to v2.0.003
// ----------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from v2.0.002 to v2.0.003\n");
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
	/* patch code here */
	// execCustSQLFile("$sprintDir/xxx.sql", $config);
	execCustSQLFile("$sprintDir/add_manage_dataset_other_provider_permission.sql", $config);
	execCustSQLFile("$sprintDir/add_manage_dataset_permission_to_admin_role.sql", $config);
	execCustSQLFile("$sprintDir/update_url_related_parameters.sql", $config);
	execCustSQLFile("$sprintDir/update_data_query_permission.sql", $config);
	execCustSQLFile("$sprintDir/create_import_model_for_shapefile.sql", $config);
	execCustSQLFile("$sprintDir/add_cas_parameters.sql", $config);
	execCustSQLFile("$sprintDir/update_users_table.sql", $config);
	execCustSQLFile("$sprintDir/add_developers.sql", $config);
	execCustSQLFile("$sprintDir/update_mnhn_layer_names.sql", $config);
	execCustSQLFile("$sprintDir/add_results_and_export_epsg.sql", $config);
	execCustSQLFile("$sprintDir/update_heuredate_parameters.sql", $config);
	execCustSQLFile("$sprintDir/update_providers.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
// system("php $sprintDir/script1.php $CLIParams", $returnCode1);
// system("php $sprintDir/script2.php $CLIParams", $returnCode2);

/* if ($returnCode1 != 0 || $returnCode2) {
 	echo "$sprintDir/update_db_sprint.php\n";
 	echo "exception: error code returned from php sql script \n";
 	exit(1);
 }*/
