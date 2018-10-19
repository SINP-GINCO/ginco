<?php
$updateDir = dirname(__FILE__);
require_once "$updateDir/../../lib/share.php";

//------------------------------------------------------------------------------
// Synopsis: migrate DB GINCO from its current version to the latest version
//------------------------------------------------------------------------------
function usage($mess=NULL){
	echo "------------------------------------------------------------------------\n";
	echo("Migrate GINCO DB from its current version to the latest version\n\n");
	echo("> php update_db_to_lastest.php -f configFile [{-D<propertiesName>=<Value>}]\n\n");
	echo "o configFile: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)){
		echo("$mess\n\n");
		exit(1);
	}
	exit;
}

//------------------------------------------------------------------------------
function exitOnError($mess, $code=1){
	echo $mess;
	exit($code);
}

// db ginco version determination:
//------------------------------------------------------------------------------
function getDbVersion($conStr){
	$db = pg_connect( $conStr )
		or exitOnError("Error : Unable to open database\n");
	$ret = pg_query($db, "SELECT value FROM website.application_parameters WHERE name='ginco_version';");
	$row = pg_fetch_row($ret)
		or exitOnError("Error : no ginco_version found in application_parameters table. Can't migrate.\n");
	$dbVerStr = $row[0];
	// Version must be like "sprintX" or "X.Y.Z"
	if (preg_match('#^sprint(\d+)$#', $dbVerStr)) {
		$dbVerSprintNum = intval(explode('sprint', $dbVerStr)[1]);
		$dbVerNum = array(
			"type" => "sprint",
			"num" => $dbVerSprintNum
		);
	}
	else if (preg_match('#^\d+\.\d+\.\d+$#', $dbVerStr)) {
		$dbVerNum = array(
			"type" => "version",
			"num" => normalizeVersion($dbVerStr)
		);
	}
	else
		exitOnError("Error : ginco_version is not correct in application_parameters table .Can't migrate.\n");
	pg_close($db);
	return $dbVerNum;
}

// Normalise version numbers X.Y.Z with 3 digits per number:
// 1.2.3 ==> 001002003
// 1.2.30 ==> 001002030
// 1.12.0 ==> 001012000
function normalizeVersion($verStr){
	if (!preg_match('#^\d+\.\d+\.\d+$#', $verStr)) {
		return false;
	}
	$verNums = explode('.',$verStr);
	$verNums = array_map( function($x){ return sprintf("%'.03d",$x);}, $verNums );
	return intval(implode('', $verNums));
}

// Reduce version string by removing 0
function reduceVersion($verStr){
	if (!preg_match('#^\d+\.\d+\.\d+$#', $verStr)) {
		return false;
	}
	$verNums = explode('.',$verStr);
	$verNums = array_map( function($x){ return intval($x);}, $verNums );
	return implode('.', $verNums);
}




// find the right patches to apply (based on the update/sprint* and update/v*.*.* directories)
//------------------------------------------------------------------------------
function getApplicablePatches($dbVerNum, $updateDir){

	$sprintList = glob("$updateDir/sprint*",GLOB_ONLYDIR);
	$versionsList = glob("$updateDir/v*",GLOB_ONLYDIR);

	$applicablePatches = array();
	$verNum = $dbVerNum["num"];

	// if database was in "sprintX" state, look for updates in sprintY directories
	if ($dbVerNum['type'] == 'sprint') {
		foreach ($sprintList as $sprint) {
			$sprintNum = intval(explode('sprint', basename($sprint))[1]);
			if ($sprintNum > $verNum) {
				$applicablePatches[] = basename($sprint);
			}
		}
	}

	// In all cases, look (also) for updates in vX.Y.Z directories
	foreach ($versionsList as $version) {
		$versionNum = normalizeVersion(explode('v', basename($version))[1]);
		if ($versionNum > $verNum) {
			$applicablePatches[] = basename($version);
		}
	}

	return $applicablePatches;
}

// execute a dump of the database described in $config, and save it in $sqlDumpFile.
//------------------------------------------------------------------------------
function dumpSql($sqlDumpFile, $conStr){
	mkdir(dirname($sqlDumpFile), 0777, true);
	system("pg_dump \"$conStr\" --create --clean -f \"$sqlDumpFile\"", $returnCode);

	if ($returnCode != 0){
		exitOnError("Error while dumping db to  $sqlDumpFile\n");
	}
	echo "Info : DB : pg_dump done to $sqlDumpFile\n";
}

// restore dump sql
//------------------------------------------------------------------------------
function restoreSql($sqlDumpFile, $config){

	$conStr ="host="     .$config['db.host'];
	$conStr.=" port="    .$config['db.port'];
	$conStr.=" user="    .$config['db.adminuser'];
	$conStr.=" password=".$config['db.adminuser.pw'];
	$conStr.=" dbname=postgres";

	// stop all process 
	system("psql \"$conStr\" -c \"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='{$config['db.name']}'\"", $returnCodeStop) ;
	if ($returnCodeStop != 0) {
		exitOnError("Can't terminate process for db {$config['db.name']}\n");
	}

	// restore database from the dump file
	system("psql \"$conStr\" --set ON_ERROR_STOP=on -f $sqlDumpFile", $returnCode);

	if ($returnCode != 0){
		exitOnError("Error while restoring db whith $sqlDumpFile\n");
	}
	echo "Info : DB restore done from $sqlDumpFile\n";
}

//------------------------------------------------------------------------------
// Main
//------------------------------------------------------------------------------
if (count($argv)==1) usage();

$config = loadPropertiesFromArgs();
$conStr = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";

$dbVerNum = getDbVersion($conStr);
echo ("INFO : db ginco version is " . $dbVerNum["num"]. "\n");

$applicablePatches = getApplicablePatches($dbVerNum, $updateDir);
if (count($applicablePatches)==0){
	echo "INFO : DB ginco version is already up to date. There is nothing to do.\n";
	exit();
}
else {
	echo "INFO: applying patches in: \n";
	foreach($applicablePatches as $patch) {
		echo $patch ."\n";
	}
}

// sauvegarde de la base avant une quelconque modification
$sqlDumpFilemane = "dump_" . $config['db.name'] . "_update_db.sql";
$sqlDumpFilePath = "$updateDir/dumps/$sqlDumpFilemane";
dumpSql($sqlDumpFilePath, $conStr);


// apply patches
// $CLIParams is argv without the command name. Useful to give the params to the sprint scripts 
/* FIXME: dans $CLIParams il faudrait s'assurer que le chemin vers le fichier de conf est bien en absolu
          parce que le script de sprint n'est pas dans le même répertoire.*/
$CLIParams = implode(' ',array_slice($argv,1));
foreach ($applicablePatches as $patchDir) {
	// Update php scripts are appliad in alphabetic order.
	$updateScripts = glob("$updateDir/$patchDir/update_*.php");
	foreach ($updateScripts as $script) {
		system("php $script $CLIParams", $returnCode);
		if ($returnCode != 0) {
			echo "ERROR : Problem occured on patch $patchDir: DB is going to be restored...";
			restoreSql($sqlDumpFilePath, $config);
			exit(1);
		}
	}
}
echo "DB patches applied. \n";

// update db version tag
$db = pg_connect( $conStr )
	or exitOnError("ERROR : Unable to open database\n");

$currentVersion = end($applicablePatches);
if (preg_match('#^v\d+\.\d+\.\d+$#', $currentVersion)) {
	$currentVersion = reduceVersion(explode('v', end($applicablePatches))[1]);
}

$ret = pg_query($db, "UPDATE website.application_parameters SET value = '$currentVersion' WHERE name='ginco_version';");
pg_close($db);
echo "DB sprint version updated to " . $currentVersion . "\n";