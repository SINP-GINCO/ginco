<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -----------------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 27 to v1.0.0 (Nothing to do because it's the same)
// -----------------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 27 to v1.0.0\n");
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
	execCustSQLFile("$sprintDir/update_jddMtdDEEId.sql", $config);
	// !!!! Attention de script vide la table export_file (donc détruit les DEE générées !!!!
	execCustSQLFile("$sprintDir/change_export_file_id_column.sql", $config);
	execCustSQLFile("$sprintDir/alter_table_jdd.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
/* system("php $sprintDir/script2.php $CLIParams", $returnCode1);

if ($returnCode1 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
*/