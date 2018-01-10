<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	/* add commune carto 2017 ADMIN EXPRESS COG with insee_dep */
	$config = loadPropertiesFromArgs();
	$config['sprintDir'] = $sprintDir;
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
	
	// Drop foreign key to commune_carto_2017 table
	$queryMetadata = "ALTER TABLE bac_commune DROP CONSTRAINT FK_bac_commune_commune_carto_2017;
		DROP TABLE referentiels.commune_carto_2017;";
	$result = pg_query($queryMetadata);
	
	if (!$result) {
		echo "An sql error occurred.\n";
		pg_close($dbconn);
		exit(1);
	}
	
	// Load in database commune_carto_2017 with insee_dep column filled
	system("wget 'https://ginco.ign.fr/ref/commune_carto_2017.sql' -O $sprintDir/commune_carto_2017.sql --no-verbose");
	echo "Intégration des données communes dans la base...";
	execCustSQLFile("$sprintDir/commune_carto_2017.sql", $config);
	echo "Intégration du référentiel communes terminée.";
	
	// reAdd foreign_fey
	$queryMetadata = "ALTER TABLE bac_commune ADD CONSTRAINT FK_bac_commune_commune_carto_2017
FOREIGN KEY (id_commune) REFERENCES referentiels.commune_carto_2017 (insee_com)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;";
	$result = pg_query($queryMetadata);
	
	if (!$result) {
		echo "An sql error occurred.\n";
		pg_close($dbconn);
		exit(1);
	}
	
	pg_close($dbconn);
	
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}