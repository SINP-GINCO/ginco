<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

$tables = array(
    'data'              => ['data'],
    'dataset_fields'    => ['dataset_id', 'format', 'data'],
    'dataset_files'     => ['dataset_id', 'format'],
    'dataset_forms'     => ['dataset_id', 'format'],
    'field'             => ['data', 'format'],
    'field_mapping'     => ['src_data', 'src_format', 'dst_data', 'dst_format'],
    'file_field'        => ['data', 'format'],
    'file_format'       => ['format'],
    'form_field'        => ['data', 'format'],
    'form_format'       => ['format'],
    'format'            => ['format'],
    'model_datasets'    => ['model_id', 'dataset_id'],
    'model_tables'      => ['model_id', 'table_id'],
    'table_field'       => ['data', 'format'],
    'table_format'      => ['format'],
    'table_tree'        => ['schema_code', 'child_table']
);

// faire séparément model et dataset pour les statuts de publication

// INSERT INTO metadata."data" (
// 	SELECT *
// 	FROM metadata_work.data WHERE DATA IN (
// 		SELECT data FROM metadata_work."data"
// 		EXCEPT
// 		SELECT data FROM metadata.data
// 	)
// )


try {


    
} catch (PDOException $e) {
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}