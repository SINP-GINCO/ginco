<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

$tables = array(
    'data'              => ['data'],
    'format'            => ['format'],
    'field'             => ['data', 'format'],
    'table_format'      => ['format'],
    'file_format'       => ['format'],
    'form_format'       => ['format'],
    'dataset_forms'     => ['dataset_id', 'format'],
    'model_datasets'    => ['model_id', 'dataset_id'],
    'dataset_files'     => ['dataset_id', 'format'],
    'model_tables'      => ['model_id', 'table_id'],
    'dataset_fields'    => ['dataset_id', 'format', 'data'],
    'field_mapping'     => ['src_data', 'src_format', 'dst_data', 'dst_format'],
    'form_field'        => ['data', 'format'],
    'table_field'       => ['data', 'format'],
    'file_field'        => ['data', 'format']
);


try {

    $pdo->beginTransaction() ;

    // Insertion des modèles, non publié.
    $sql = "INSERT INTO metadata.model (
                SELECT *, 'unpublished', NULL, 'occtax'
                FROM metadata_work.model WHERE id IN (
                    SELECT id FROM metadata_work.model
                    EXCEPT
                    SELECT id FROM metadata.model
                )
            )
    ";
    $pdo->exec($sql) ;

    // Insertion des dataset, non publié.
    $sql = "INSERT INTO metadata.dataset (
                SELECT *, 'unpublished'
                FROM metadata_work.dataset WHERE dataset_id IN (
                    SELECT dataset_id FROM metadata_work.dataset
                    EXCEPT
                    SELECT dataset_id FROM metadata.dataset
                )
            )
    ";
    $pdo->exec($sql) ;

    foreach ($tables as $table => $ids) {

        $implodedIds = implode(',', $ids) ;
        $sql = "INSERT INTO metadata.$table (
                    SELECT *
                    FROM metadata_work.$table WHERE ($implodedIds) IN (
                        SELECT $implodedIds FROM metadata_work.$table
                        EXCEPT
                        SELECT $implodedIds FROM metadata.$table
                    )
            )
        ";
        $pdo->exec($sql) ; 
    }

    // table_tree : remplacement * par NULL.
    $sql = "INSERT INTO metadata.table_tree (
            SELECT schema_code, child_table, NULL, join_key, comment
            FROM metadata_work.table_tree WHERE (schema_code, child_table) IN (
                SELECT (schema_code, child_table) FROM metadata_work.table_tree
                EXCEPT
                SELECT d(schema_code, child_table) FROM metadata.table_tree
            )
        )
    ";
    
    $pdo->commit() ;
    
} catch (PDOException $e) {
    
    $pdo->rollBack() ;
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}