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
		execCustSQLFile("$sprintDir/migrate_taxref_to_v11.sql", $config) ;
		
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

		execCustSQLFile("$initDir/populate_mode_taxref_table.sql", $config) ;
	}

} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}

$CLIParams = implode(' ', array_slice($argv, 1));
/* patch php here */
//system("php $sprintDir/XXXX.php $CLIParams", $returnCode1);

try {

	system("php $sprintDir/migrate_taxref_v11_metadata.php $CLIParams", $returnCode1) ;
	if ($returnCode1 != 0) {
		echo "$sprintDir/migrate_taxref_v11_metadata.php crashed.\n" ; 
		exit(1) ;
	}
	
	system("php $sprintDir/add_userLogin_metadata.php $CLIParams", $returnCode4) ;
	if ($returnCode4 != 0) {
		echo "$sprintDir/add_userLogin_metadata.php crashed.\n" ; 
		exit(1) ;
	}
	

	if (!$isDlb) {
		system("php $sprintDir/migrate_taxref_v11_data.php $CLIParams", $returnCode3) ;
		if ($returnCode3 != 0) {
			echo "$sprintDir/migrate_taxref_v11_data.php crashed.\n";
			exit(1);
	   }
	}

} catch (Exception $e) {
	
	echo "$sprintDir/update_db_sprint.php : an exception has occured.\n" ;
	echo "Exception : {$e->getMessage()}" ;
	exit(1) ;
}






