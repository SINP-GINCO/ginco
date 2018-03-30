<?php
$initDir = dirname(__FILE__);
require_once "$initDir/../../lib/share.php";

// -------------------------------------------------------------------------------
// Switch all instance-related parameters in a database.
// Allows to switch a test database to prod, for instance.
//
// After passing this script, one may still need to:
//
// * replace jdd_metadata_ids (case of test --> prod)
// * copy content of directory /var/data/ginco/@instance@/ on the server
// -------------------------------------------------------------------------------

// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nSwitch all instance-related parameters in a database.:\n");
	echo ("> php switch_instance_properties.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
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

$currentDir = dirname(__FILE__);
$initDir = dirname(__FILE__)."/../init";

echo("Réinitialisation de la table website.application_parameters...\n");
execCustSQLFile("$initDir/3-Update_application_parameters_tpl.sql", $config);

echo("Réinitialisation de la table website.content...\n");
execCustSQLFile("$initDir/3-Update_content_tpl.sql", $config);

echo("Réinitialisation des tables mapping.layer_service et mapping.provider_map_params...\n");
execCustSQLFile("$currentDir/update_mapping_tables.sql", $config);

echo("Correction des chemins de fichiers dans raw_data.submission_file...\n");
execCustSQLFile("$currentDir/fix_paths_submission_file.sql", $config);


echo ("\nSwitch des paramètres instance de la base {$config['db.name']} effectué.\n");
echo("Penser à : \n");
echo("* Remplacer les ids de métadonnées de jdd dans les jdd_fields et les données si nécessaire (test --> prod) ;\n");
echo("* copier le répertoire de l'ancienne instance (test --> prod) /var/data/ginco/@instance@/ sur la VM\n\n");