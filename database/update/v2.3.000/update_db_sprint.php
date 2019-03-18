<?php
$sprintDir = dirname(__FILE__);
$initDir = realpath(dirname(__FILE__)."/../../init/") ;
require_once "$sprintDir/../../../lib/share.php";

// ------------------------------------------------
// Synopsis: migrate DB GINCO from v2.2.3 to v2.3.0
// ------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from v2.2.3 to v2.3.0\n");
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

$isDlb = strpos($config['db.name'], 'dlb') !== FALSE ;
if ($isDlb) {
	echo "Database is DLB." ;
}

try {
	/* patch code here*/
	//execCustSQLFile("$sprintDir/xxxx.sql", $config);
	execCustSQLFile("$sprintDir/add_status_fields.sql", $config);
	execCustSQLFile("$sprintDir/add_standard.sql", $config);
	execCustSQLFile("$sprintDir/change_mapping_observation_provider.sql", $config);


} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch php here */

try {
    
	//system("php $sprintDir/XXXX.php $CLIParams", $returnCode1);
	
    system("php $sprintDir/change_model_nomvalide.php $CLIParams", $returnCode1) ;
    if ($returnCode1 != 0) {
        echo "$sprintDir/change_model_nomvalide.php crashed.\n";
        exit(1);
	}
	
	system("php $sprintDir/add_index_observations.php $CLIParams", $returnCode2) ;
    if ($returnCode2 != 0) {
		echo "$sprintDir/add_index_observations.php crashed.\n";
		// pas besoin d'exit -> on ne plante pas le processus si la création de l'index a échoué.
    }

} catch (Exception $e) {
	
	echo "$sprintDir/update_db_sprint.php : an exception has occured.\n" ;
	echo "Exception : {$e->getMessage()}" ;
	exit(1) ;
}






