<?php
$initDir = dirname(__FILE__);
require_once "$initDir/../../lib/share.php";

// -------------------------------------------------------------------------------
// Synopsis: Populates the table model_1_observation and all the observation_XXX tables.
// Parameters are filed in a properties file.
//
// FIXME: system calls to psql could be replaced by a php stuff.
// -------------------------------------------------------------------------------

// -------------------------------------------------------------------------------
function usage($mess = NULL) {
	echo "------------------------------------------------------------------------\n";
	echo ("\nCreate and initiate the DB for the configuration:\n");
	echo ("> create_db -f <configFile> [{-D<propertiesName>=<Value>}]\n\n");
	echo "o <configFile>: a java style properties file for the instance on which you work\n";
	echo "o -D : inline options to complete or override the config file.\n";
	echo "------------------------------------------------------------------------\n";
	if (!is_null($mess)) {
		echo ("$mess\n\n");
		exit(1);
	}
	exit();
}

// -------------------------------------------------------------------------------
// MAIN
// -------------------------------------------------------------------------------

// parameters analyze
if (count($argv) == 1)
	usage();

	// get config
$config = loadPropertiesFromArgs();
$paramStr = implode(' ', array_slice($argv, 1));

$initDir = dirname(__FILE__);

echo ("Peuplement de la base de données\n");
$i = 0;
if ($config['reset']) {
	execSQLFile("$initDir/reset_data_and_sequences.sql", $config);
}
while ($i < $config['iterations']) {
	execSQLFile("$initDir/fill_model_1_observation.sql", $config);
	execSQLFile("$initDir/fill_bac_geometrie.sql", $config);
	execSQLFile("$initDir/fill_observation_bac_links.sql", $config);
	$i ++;
}

echo ("Peuplement terminé.\n");
