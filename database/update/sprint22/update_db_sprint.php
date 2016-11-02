<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 20 to sprint 21
#-------------------------------------------------------------------------------
function usage($mess = NULL)
{
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 20 to sprint 21\n");
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
    execCustSQLFile("$sprintDir/update_region_names.sql", $config);
    execCustSQLFile("$sprintDir/add_site_name.sql", $config);
    execCustSQLFile("$sprintDir/change_codeME_to_array.sql", $config);
    execCustSQLFile("$sprintDir/change_nomCommuneCalcule_to_ARRAY_of_STRING.sql", $config);
    execCustSQLFile("$sprintDir/add_dsr_checks.sql", $config);
} catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
