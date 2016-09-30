<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 16 to sprint 17
#-------------------------------------------------------------------------------
function usage($mess = NULL)
{
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 16 to sprint 17\n");
	echo("> php update_db_sprint.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)) {
	echo("$mess\n\n");
		exit(1);
	}
	exit;
}

if (count($argv) == 1) usage();
$config = loadPropertiesFromArgs();


try {
	execCustSQLFile("$sprintDir/update_postgis_to_2.2.2.sql", $config);
	execCustSQLFile("$sprintDir/migrationOgamV3/application_parameters.sql", $config);
	execCustSQLFile("$sprintDir/migrationOgamV3/mapping_schema.sql", $config);
	execCustSQLFile("$sprintDir/update_dsr_config.sql", $config);
	#FIXME: les références vers init posent deux problèmes:
	#       1. les sprints sont versionnés mais dans init il n'y a toujours que la dernière version
	#       2. le répertoire referentiel n'est pas mis dans le paquet de déploiement parce qu'il est trop volumineux...
	execCustSQLFile("$sprintDir/GEOFLAv2015.1/geofla_v2015.1_communes.sql", $config);
	execCustSQLFile("$sprintDir/GEOFLAv2015.1/geofla_v2015.1_departements.sql", $config);
	execCustSQLFile("$sprintDir/GEOFLAv2015.1/geofla_v2015.1_regions.sql", $config);
	execCustSQLFile("$sprintDir/codemaillevalue.sql", $config);
	execCustSQLFile("$sprintDir/select_rights_on_new_referentiels_tables.sql", $config);
	execCustSQLFile("$sprintDir/create_visu_bacs_and_association_tables.sql", $config);
	execCustSQLFile("$sprintDir/populate_visualization_bac_tables.sql", $config);
	execCustSQLFile("$sprintDir/update_mapserver_url.sql", $config);
	execCustSQLFile("$sprintDir/update_dynamodes.sql", $config);
	execCustSQLFile("$sprintDir/update_date_time.sql", $config);
	execCustSQLFile("$sprintDir/update_sensitive_trigger.sql", $config);
	execCustSQLFile("$sprintDir/update_submission_status.sql", $config);
	execCustSQLFile("$sprintDir/replace_name_by_code_in_mode_taxref.sql", $config);
	execCustSQLFile("$sprintDir/add_type_attribut_value.sql", $config);
	execCustSQLFile("$sprintDir/add_visitor_user.sql", $config);
	execCustSQLFile("$sprintDir/delete_deemetadonneeid.sql", $config);
	execCustSQLFile("$sprintDir/add_ogam_geometry_checks.sql", $config);
	execCustSQLFile("$sprintDir/reinit_mode_taxref.sql", $config);

}catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
