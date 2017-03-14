<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 25 to sprint 26
// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 25 to sprint 26\n");
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
	execCustSQLFile("$sprintDir/update_postgis_to_2.3.1.sql", $config);
	execCustSQLFile("$sprintDir/add_sensirefversion.sql", $config);
	execCustSQLFile("$sprintDir/update_referentiel_especesensible.sql", $config);
	execCustSQLFile("$sprintDir/add_missing_indexes.sql", $config);
	execCustSQLFile("$sprintDir/add_jdd_table.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
system("php $sprintDir/remove_ogam_id_from_dsr_import_model.php $CLIParams", $returnCode1);
system("php $sprintDir/change_datedetermination_type_to_date.php $CLIParams", $returnCode2);
system("php $sprintDir/updateCalculatedFields.php $CLIParams", $returnCode3);
system("php $sprintDir/add_id_predefined_request.php $CLIParams", $returnCode4);
system("php $sprintDir/change_identifiantpermanent.php $CLIParams", $returnCode5);

if ($returnCode1 != 0 || $returnCode2 != 0 || $returnCode3 != 0 || $returnCode4 != 0 || $returnCode5 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
