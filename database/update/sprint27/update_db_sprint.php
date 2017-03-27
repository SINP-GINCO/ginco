<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 26 to sprint 27
// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 26 to sprint 27\n");
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
	execCustSQLFile("$sprintDir/add_jdd_table.sql", $config);
	execCustSQLFile("$sprintDir/add_jdd_id_download_service_url.sql", $config);
	execCustSQLFile("$sprintDir/add_wfs_natural_spaces.sql", $config);
	execCustSQLFile("$sprintDir/update_dee_notification_mail.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


try {
	/* update espaces naturels */
	$config['sprintDir'] = $sprintDir;
	system("wget 'https://ginco.ign.fr/ref/ESPACES_NATURELS_INPN/espaces_naturels_inpn_20170228.csv' -O $sprintDir/en_inpn.csv --no-verbose");
	echo "Intégration des données espaces naturels dans la base...";
	execCustSQLFile("$sprintDir/update_espaces_naturels.sql", $config);
	echo "Intégration du référentiel espaces naturels terminée.";
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
 system("php $sprintDir/delete_all_datas.php $CLIParams", $returnCode1);
// system("php $sprintDir/script2.php $CLIParams", $returnCode2);

if ($returnCode1 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}
