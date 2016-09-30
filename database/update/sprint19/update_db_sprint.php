<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 16 to sprint 17
#-------------------------------------------------------------------------------
function usage($mess = NULL)
{
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 17 to sprint 19 (there no sprint 18)\n");
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
	/* patch code here */
	execCustSQLFile("$sprintDir/add_confirm_submission_permission.sql", $config);
	execSQLFile("$sprintDir/geom_idx.sql", $config);
	execCustSQLFile("$sprintDir/layers_for_vizualisation_bacs.sql", $config);
	execCustSQLFile("$sprintDir/new_result_and_request_tables.sql", $config);
	execCustSQLFile("$sprintDir/add_view_private_permission.sql", $config);
	execCustSQLFile("$sprintDir/add_update_calculated_fields_init_trigger.sql", $config);
	execCustSQLFile("$sprintDir/update_dsr_config.sql", $config);
	execCustSQLFile("$sprintDir/add_idstring_unit.sql", $config);
	execCustSQLFile("$sprintDir/fix_details_layers.sql", $config);

}catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
