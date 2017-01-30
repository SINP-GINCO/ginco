<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 24 to sprint 25
// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 24 to sprint 25\n");
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

	/* Zend 1 --> Symfony 2 migration */
	execCustSQLFile("$sprintDir/add_extension_pg_trgm.sql", $config);
	execCustSQLFile("$sprintDir/update_db_to_v4.sql", $config);
	execCustSQLFile("$sprintDir/update_layers_and_layer_tree.sql", $config);

	/* Restore a result_location table - temporary - to test visu in Ogam */
	execCustSQLFile("$sprintDir/restore_result_location.sql", $config);

	execCustSQLFile("$sprintDir/reorder_layer_tree.sql", $config);

} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
system("php $sprintDir/change_anneeref_type.php $CLIParams", $returnCode);
if ($returnCode != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
