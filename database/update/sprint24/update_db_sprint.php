<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 23 to sprint 24
// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 23 to sprint 24\n");
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
	execCustSQLFile("$sprintDir/add_results_bbox_compute_threshold_in_app_parameters.sql", $config);
	execCustSQLFile("$sprintDir/add_date_order_check.sql", $config);
	execCustSQLFile("$sprintDir/add_nomvalide_to_dsr_model.sql", $config);
	execCustSQLFile("$sprintDir/update_sensitive_automatic_algorithm.sql", $config);
	execCustSQLFile("$sprintDir/put_fields_position_in_alphabetic_order.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
system("php $sprintDir/delete_deedatetransformation_column.php $CLIParams", $returnCode);
if ($returnCode != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

// try {
// 	/* update taxref to v10 */
// 	execCustSQLFile("$sprintDir/delete_taxref_v9.sql", $config);
	
// 	system("wget 'https://ginco.ign.fr/ref/TAXREFv10.0/TAXREFv10.0.txt' -O $sprintDir/taxref.txt --no-verbose");
// 	echo "Intégration des données taxref dans la base...";
// 	execCustSQLFile("$sprintDir/create_taxref10_tables.sql", $config);
	
// 	$config['sprintDir'] = $sprintDir;
// 	execCustSQLFile("$sprintDir/add_taxref_v10.sql", $config);
// 	echo "Intégration de TAXREF terminée.";
// } catch (Exception $e) {
// 	echo "$sprintDir/update_db_sprint.php\n";
// 	echo "exception: " . $e->getMessage() . "\n";
// 	exit(1);
// }