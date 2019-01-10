<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
    
    $config = loadPropertiesFromArgs();
    $config['sprintDir'] = $sprintDir;
    $conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
    $dbconn = pg_connect($conn_string) or die('Connection failed');
    
    echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";
    
    // Search list table model name
    $listModelsRequest = "SELECT table_name FROM metadata.table_format";
    $listModels = pg_query($listModelsRequest);
    
    if (! $listModels) {
        echo "An sql error occurred.\n";
        pg_close($dbconn);
        exit(1);
    }
    
  // Update provider for each model table
    while ($result = pg_fetch_assoc($listModels)) {
        
        $nameTableUpdate = "raw_data." . $result['table_name'];
        $updateCdNomModelRequest = "UPDATE " . $nameTableUpdate . 
           " SET nomvalide = t.nom_valide".
           " FROM referentiels.taxref t" .
	       " WHERE cdnom = t.cd_nom";
        $updateCdNomModel = pg_query($updateCdNomModelRequest);
        
        if (! $updateCdNomModel) {
            echo "An sql error occurred.\n";
            pg_close($dbconn);
            exit(1);
        }
    }
    
    pg_close($dbconn);
} catch (Exception $e) {
    echo "$sprintDir/update_db_sprint.php\n";
    echo "exception: " . $e->getMessage() . "\n";
    exit(1);
}
