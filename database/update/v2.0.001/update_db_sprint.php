<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

// -----------------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from sprint 30 to v2.0.0 (Nothing to do because it's the same)
// -----------------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from sprint 30 to v2.0.0\n");
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
	execCustSQLFile("$sprintDir/alter_label_table_data.sql", $config);
	execCustSQLFile("$sprintDir/update_mtd_to_preprod.sql", $config);
	execCustSQLFile("$sprintDir/add_limit_import_error.sql", $config);
	execCustSQLFile("$sprintDir/add_label_csv_in_file_field.sql", $config);
	execCustSQLFile("$sprintDir/enable_zoom_levels.sql", $config);
	execCustSQLFile("$sprintDir/delete_position_column_in_file_field_table.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

try {
	/* add commune carto 2017 ADMIN EXPRESS COG */
	$config['sprintDir'] = $sprintDir;
	system("wget 'https://ginco.ign.fr/ref/commune_carto_2017.sql' -O $sprintDir/commune_carto_2017.sql --no-verbose");
	echo "Intégration des données communes dans la base...";
	execCustSQLFile("$sprintDir/commune_carto_2017.sql", $config);
	echo "Intégration du référentiel communes terminée.";
	
	/* update departement carto 2017 ADMIN EXPRESS COG */
	$config['sprintDir'] = $sprintDir;
	system("wget 'https://ginco.ign.fr/ref/departement_carto_2017.sql' -O $sprintDir/departement_carto_2017.sql --no-verbose");
	echo "Intégration des données departements dans la base...";
	execCustSQLFile("$sprintDir/departement_carto_2017.sql", $config);
	echo "Intégration du référentiel departements terminée.";
	
	/* update region carto 2017 ADMIN EXPRESS COG */
	$config['sprintDir'] = $sprintDir;
	system("wget 'https://ginco.ign.fr/ref/region_carto_2017.sql' -O $sprintDir/region_carto_2017.sql --no-verbose");
	echo "Intégration des données regions dans la base...";
	execCustSQLFile("$sprintDir/region_carto_2017.sql", $config);
	echo "Intégration du référentiel regions terminée.";
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch user raw_data here */
system("php $sprintDir/update_orgtransformation_sensible_not_editable_not_mandatory.php $CLIParams", $returnCode1);
system("php $sprintDir/update_commune_referentiel_in_data.php $CLIParams", $returnCode2);

if ($returnCode1 != 0 || $returnCode2 != 0) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

try {
	execCustSQLFile("$sprintDir/replace_geofla_commune_by_admin_express-cog_2017.sql", $config);
	execCustSQLFile("$sprintDir/replace_geofla_departement_by_admin_express-cog_2017.sql", $config);
	execCustSQLFile("$sprintDir/replace_geofla_region_by_admin_express-cog_2017.sql", $config);
	execCustSQLFile("$sprintDir/fix_saved_request_permission_name.sql", $config);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}