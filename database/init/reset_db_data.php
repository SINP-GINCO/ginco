<?php
$initDir = dirname(__FILE__);
require_once "$initDir/../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: Create a database from scratch for GINCO.
// Parameters are filed in a properties file.
//
// FIXME: system calls to psql could be replaced by a php stuff.
// -------------------------------------------------------------------------------

// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nResets the values in schemas metadata, metadata_work and website:\n");
	echo ("> reset_db_data -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)) {
		echo ("$mess\n\n");
		exit(1);
	}
	exit();
}

// -------------------------------------------------------------------------------
// MAIN
// -------------------------------------------------------------------------------

// parameters analyze
if (count($argv) == 1)
	usage();

	// get config
$config = loadPropertiesFromArgs();
$paramStr = implode(' ', array_slice($argv, 1));

$initDir = dirname(__FILE__);

echo ("Réinitialisation des schémas metadata (_work) et website à jour de la base de données\n");

system("php $initDir/metadata/import_metadata_from_csv.php $paramStr -Dschema=metadata");
system("php $initDir/metadata/import_metadata_from_csv.php $paramStr -Dschema=metadata_work");

execCustSQLFile("$initDir/3-Update_application_parameters_tpl.sql", $config);
execCustSQLFile("$initDir/3-Update_predefined_requests.sql", $config);
execCustSQLFile("$initDir/3-Init_roles.sql", $config);

// set ginco_version from the last update directory
$updateDir = "$initDir/../update";
$sprintList = glob("$updateDir/sprint*", GLOB_ONLYDIR);
$lastUpdate = basename(array_pop($sprintList));
execCustSQLFile("$initDir/3-Update_ginco_version.sql", $config + [
	"ginco.version" => $lastUpdate
]);

echo ("Réinitialisation des schémas de {$config['db.name']} effectuée.\n");
