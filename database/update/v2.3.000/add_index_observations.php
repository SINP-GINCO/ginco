<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

// Application name
$pdo->exec("SET application_name = 'migration_taxref_data'") ;

// On récupère le nom de la table des observations.
$sth = $pdo->query("SELECT table_name, primary_key FROM metadata.table_format") ;
$items = $sth->fetchAll() ;

try {

	foreach ($items as $item) {

        $tableName = $item['table_name'] ;
        $primaryKeys = array_map(function($e) { return trim($e) ; }, explode(',', $item['primary_key'])) ;
        $primaryKey = null ;
        foreach ($primaryKeys as $pk) {
            if (strpos($pk, 'OGAM_ID') !== false) {
                $primaryKey = $pk ;
            }
        }

        $sql = "CREATE INDEX idx_$primaryKey ON raw_data.$tableName($primaryKey)" ;

        $pdo->query($sql) ;

    }
    
} catch (PDOException $e) {
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}



