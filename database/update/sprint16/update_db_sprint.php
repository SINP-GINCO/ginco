<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

#-------------------------------------------------------------------------------
# Synopsis: migrate DB GINCO from sprint 15 to sprint 16
#-------------------------------------------------------------------------------
function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo("\nUpdate DB from sprint 15 to sprint 16\n");
	echo("> php update_db_sprint.php -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}
if (count($argv)==1) usage();
$config=loadPropertiesFromArgs();


try{
	execCustSQLFile("$sprintDir/add_manage_datasets_permission.sql", $config);
	execCustSQLFile("$sprintDir/update_jddmetadonneedeeid_check.sql", $config);
	execCustSQLFile("$sprintDir/update_code_dept_drom.sql", $config);
	execCustSQLFile("$sprintDir/update_postgis_to_2.2.2.sql", $config);
}catch(Exception $e){
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: ". $e->getMessage() . "\n" ;
	exit(1);
}
