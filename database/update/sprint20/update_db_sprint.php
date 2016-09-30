<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 16 to sprint 17
#-------------------------------------------------------------------------------
function usage($mess = NULL)
{
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 19 to sprint 20\n");
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
	execCustSQLFile("$sprintDir/add_znieff2_layer.sql", $config);
	execCustSQLFile("$sprintDir/save_predefined_request.sql", $config);
	execCustSQLFile("$sprintDir/add_precise_geom_layer_restriction_for_unlogged_user.sql", $config);
	execCustSQLFile("$sprintDir/remove_query_details_layer.sql", $config);
	execCustSQLFile("$sprintDir/update_mode_taxref_add_lbname_column.sql", $config);
	execCustSQLFile("$sprintDir/insert_hiding_value_in_app_parameters.sql", $config);

}catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
