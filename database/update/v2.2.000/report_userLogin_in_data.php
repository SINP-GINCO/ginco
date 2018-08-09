<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

// On récupère le nom de la table des observations.
$sth = $pdo->query("SELECT table_name FROM metadata.table_format") ;
$tableNames = $sth->fetchAll() ;

// Begin transaction
$pdo->beginTransaction() ;

try {
	foreach ($tableNames as $index => $value) {

		$tableName = $value['table_name'] ;

		// Désactivation temporaire des triggers de sensibilité.

		$pdo->exec("UPDATE raw_data.$tableName 
					SET user_login = (
						SELECT user_login 
						FROM raw_data.submission 
						WHERE submission.submission_id = $tableName.submission_id
						);");
		
	}
    
} catch (PDOException $e) {
	
	$pdo->rollback() ;
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


// Commit transaction
$pdo->commit() ;

