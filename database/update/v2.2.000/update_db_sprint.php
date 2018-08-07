<?php
$sprintDir = dirname(__FILE__);
$initDir = realpath(dirname(__FILE__)."/../../init/") ;
require_once "$sprintDir/../../../lib/share.php";

// ------------------------------------------------
// Synopsis: migrate DB GINCO from v2.0.6 to v2.1.0
// ------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nUpdate DB from v2.0.6 to v2.1.0\n");
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
	execCustSQLFile("$sprintDir/permissions.sql", $config);
	execCustSQLFile("$sprintDir/jdd.sql", $config);
	execCustSQLFile("$sprintDir/layers.sql", $config);

	if (!$isDlb) {
		execCustSQLFile("$sprintDir/update_taxref_to_v11.sql", $config) ;
		
		$connectStr ="host="     .$config['db.host'];
		$connectStr.=" port="    .$config['db.port'];
		$connectStr.=" user="    .$config['db.adminuser'];
		$connectStr.=" password=".$config['db.adminuser.pw'];
		$connectStr.=" dbname="  .$config['db.name'];
		system("$sprintDir/populateTaxref.sh $connectStr", $returnCode2) ;
		if ($returnCode2 != 0) {
			echo "$sprintDir/update_db_sprint.php\n";
			echo "exception: " . $e->getMessage() . "\n";
			exit(1);
		}
	}

	execCustSQLFile("$initDir/populate_mode_taxref_table.sql", $config) ;	

} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch php here */
//system("php $sprintDir/XXXX.php $CLIParams", $returnCode1);
system("php $sprintDir/update_taxref_v11_metadata.php $CLIParams", $returnCode1) ;

if (!$isDlb) {
	system("php $sprintDir/update_taxref_v11_data.php $CLIParams", $returnCode3) ;
}

if ($returnCode1 != 0 || $returnCode3 != 0) {
 	echo "$sprintDir/update_db_sprint.php\n";
 	echo "exception: " . $e->getMessage() . "\n";
 	exit(1);
}


