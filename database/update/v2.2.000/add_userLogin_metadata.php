<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";


$config = loadPropertiesFromArgs();

$dsn = "pgsql:host={$config['db.host']};port={$config['db.port']};dbname={$config['db.name']}" ;
$pdo = new PDO($dsn, $config['db.adminuser'], $config['db.adminuser.pw']) ;

$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION) ;

// Begin transaction
$pdo->beginTransaction() ;

try {

    $schemas = array('metadata', 'metadata_work') ;

    foreach ($schemas as $schema) {
    	
    	// Insertion des unit USER_LOGIN
    	$sql = "INSERT INTO $schema.dynamode(unit, sql) VALUES
			('USER_LOGIN', 'SELECT user_login as code, user_name as label, user_name as definition, ''''::text as position FROM website.users ORDER BY user_login')
		";
    	$pdo->exec($sql) ;
		
		$sql = "INSERT INTO $schema.unit(unit, type, subtype, label, definition) VALUES
			('USER_LOGIN', 'STRING', 'DYNAMIC', 'Utilisateur', 'Utilisateur')
		";
		$pdo->exec($sql) ;
    	
    	// Insertion dans la table data.
    	$sql = "INSERT INTO $schema.data(data, unit, label, definition) VALUES
            ('USER_LOGIN', 'USER_LOGIN', 'Utilisateur', 'Utilisateur')
		";
    	$pdo->exec($sql) ;
		    	
    	// Recherche des formats qui possèdent des champs PROVIDER_ID.
    	$sth = $pdo->query("SELECT fo.* FROM $schema.format fo
			JOIN $schema.field fi ON fo.format = fi.format
			WHERE fi.type = 'TABLE'
			AND fi.data = 'PROVIDER_ID'");
    	$formatsTable = $sth->fetchAll() ;
    	
    	$sth = $pdo->query("SELECT fo.* FROM $schema.format fo
			JOIN $schema.field fi ON fo.format = fi.format
			WHERE fi.type = 'FORM'
			AND fi.data = 'PROVIDER_ID'");
    	$formatsForm = $sth->fetchAll() ;
    	
    	
    	// Format TABLE
    	foreach ($formatsTable as $format) {
    		
    		// pour tous les formats, insertion dans la table field
    		$pdo->exec("INSERT INTO $schema.field (data, format, type) VALUES
				('USER_LOGIN', '{$format['format']}', '{$format['type']}')
			");
    		
    		$sth = $pdo->query("SELECT max(position) FROM $schema.table_field") ;
    		$position = $sth->fetchColumn() ;
    		
    		$pdo->exec("INSERT INTO $schema.table_field (data, format, column_name, is_calculated, is_editable, is_insertable, is_mandatory, position) VALUES
				('USER_LOGIN', '{$format['format']}', 'USER_LOGIN', 0, 0, 0, 1, ++$position)
			");
    		
    		// Insertion dans dataset_fields, ce qui permet d'afficher les champs dans le requêteur.
    		$sth = $pdo->query("SELECT dataset_id FROM $schema.dataset_fields WHERE data='PROVIDER_ID'") ;
    		$datasets = $sth->fetchAll() ;
    		
    		foreach ($datasets as $dataset) {
    			$pdo->exec("INSERT INTO $schema.dataset_fields (dataset_id, schema_code, format, data) VALUES
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'USER_LOGIN')
				");
			}
			    		
    	}
    	
    	// Ajout d'une primary key 
		$pdo->exec("UPDATE $schema.table_format SET primary_key = primary_key || ', USER_LOGIN'") ;
    	
    	
    	// Formats FORM
    	foreach ($formatsForm as $format) {
    		
    		// pour tous les formats, insertion dans la table field
    		$pdo->exec("INSERT INTO $schema.field (data, format, type) VALUES
					('USER_LOGIN', '{$format['format']}', '{$format['type']}')
			");
    		
    			
    		// décalage des positions pour les champs après PROVIDER_ID  
    		$pdo->exec("UPDATE $schema.form_field
				SET position=position+1
				WHERE position > (SELECT position FROM $schema.form_field WHERE data='PROVIDER_ID' AND format = '{$format['format']}')
			");
    		
    			
    		// insertion USER_LOGIN
    		$pdo->exec("INSERT INTO $schema.form_field (data, format, is_criteria, is_result, input_type, position, is_default_criteria, is_default_result) VALUES
				('USER_LOGIN', '{$format['format']}', 1, 1, 'SELECT', (SELECT position+1 FROM $schema.form_field WHERE data='PROVIDER_ID' AND format = '{$format['format']}'), 0, 0)
			");
    		
    		$formatTable = $formatsTable[0] ; // normalement, il n'y en a qu'un.
    		
    		// field_mapping
    		$pdo->exec("INSERT INTO $schema.field_mapping(src_data, src_format, dst_data, dst_format, mapping_type) VALUES
				('USER_LOGIN', '{$format['format']}', 'USER_LOGIN', '{$formatTable['format']}', 'FORM')
			");
    	}
	}
	
    //
    // insertion des nouvelles colonnes dans les tables de raw_data.
    //
    $sth = $pdo->query("SELECT table_name FROM metadata.table_format") ;
    $tables = $sth->fetchAll() ;
    
    foreach ($tables as $table) {
    	
    	$tableName = $table['table_name'] ;
    	
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN user_login VARCHAR(255)") ;
    	
    }
    
    
} catch (PDOException $e) {
	
	$pdo->rollback() ;
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


// Commit transaction
$pdo->commit() ;



