<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 22 to sprint 23
#-------------------------------------------------------------------------------
function usage($mess = NULL)
{
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 22 to sprint 23\n");
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
    execCustSQLFile("$sprintDir/increase_columns_lengths_for_dee_export.sql", $config);
    execCustSQLFile("$sprintDir/insert_dee_gml_parameters.sql", $config);
    execCustSQLFile("$sprintDir/add_user_column_in_export_file_table.sql", $config);
    execCustSQLFile("$sprintDir/add_site_url_in_app_parameters.sql", $config);
} catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
