<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// ------------------------------------------------
// Synopsis: migrate DB GINCO from v2.0.5 to v2.0.6
// ------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from v2.0.5 to v2.0.6\n");
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
	//execCustSQLFile("$sprintDir/xxxx.sql", $config);
	execCustSQLFile("$sprintDir/liste_referentiels.sql", $config);
	execCustSQLFile("$sprintDir/update_sensitivity_automatic_algorithm.sql", $config);
	execCustSQLFile("$sprintDir/drop_old_sequences.sql", $config);
	execCustSQLFile("$sprintDir/update_permissions.sql", $config);
	execCustSQLFile("$sprintDir/update_messages.sql", $config);
	execCustSQLFile("$sprintDir/delete_geosource_schema.sql", $config);
	execCustSQLFile("$sprintDir/index_mode_taxref_code.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch php here */
system("php $sprintDir/add_insee_dep_to_commune_carto_2017.php $CLIParams", $returnCode1);
system("php $sprintDir/update_sequences_currentval.php $CLIParams", $returnCode2);

if ($returnCode1 != 0 || $returnCode2 != 0 ) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
