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
    
    //
    // Step 1 : drop unused tables
    //
    $pdo->exec("DROP TABLE IF EXISTS referentiels.taxref_rang") ;
    $pdo->exec("DROP TABLE IF EXISTS referentiels.taxref_statut") ;

    //
    // Step 2 : update taxref informations
    //
    $sql = "UPDATE referentiels.liste_referentiels SET
                version = 'v11',
                updated_at = now()::date,
                url = 'https://inpn.mnhn.fr/telechargement/referentielEspece/taxref/11.0/menu'
            WHERE table_name = 'taxref' ;"
    ;
    $pdo->exec($sql) ;

    //
    // Step 3 : add new list of values : taxostatutvalue and taxomodifvalue
    //
    $pdo->exec("CREATE TABLE referentiels.taxostatutvalue(
			code varchar(32) NOT NULL,
			label varchar(128) NULL,
			definition varchar(510) NULL,
			CONSTRAINT taxostatutvalue_pkey PRIMARY KEY (code)
		)"
    );
    
    $pdo->exec("INSERT INTO referentiels.taxostatutvalue(code, label, definition) VALUES
		('0', 'Diffusé', 'Diffusé'),
		('1', 'Gel', 'Gel'),
		('2', 'Suppression', 'Suppression')
	");
    
    $pdo->exec("CREATE TABLE referentiels.taxomodifvalue(
			code varchar(32) NOT NULL,
			label varchar(128) NULL,
			definition varchar(510) NULL,
			CONSTRAINT taxomodifvalue_pkey PRIMARY KEY (code)
		)"
    );
	
	$pdo->exec("GRANT ALL ON SCHEMA referentiels TO ogam") ;
	$pdo->exec("GRANT SELECT ON ALL TABLES IN schema referentiels to ogam") ;
    
    $pdo->exec("INSERT INTO referentiels.taxomodifvalue(code, label, definition) VALUES
		('0', 'Modification TAXREF', 'Modification TAXREF'),
		('1', 'Gel TAXREF', 'Gel TAXREF'),
		('2', 'Suppression TAXREF', 'Suppression TAXREF'),
		('3', 'Splittage TAXREF', 'Splittage TAXREF')		
	");
	
	$pdo->exec("CREATE TABLE referentiels.taxoalertevalue(
			code varchar(32) NOT NULL,
			label varchar(128) NULL,
			definition varchar(510) NULL,
			CONSTRAINT taxoalertvalue_pkey PRIMARY KEY (code)
		)"
	);

	$pdo->exec("GRANT ALL ON SCHEMA referentiels TO ogam") ;
	$pdo->exec("GRANT SELECT ON ALL TABLES IN SCHEMA referentiels TO ogam") ;

	$pdo->exec("INSERT INTO referentiels.taxoalertevalue(code, label, definition) VALUES
		('0', 'Oui', 'Taxon en alerte suite au passage V11'),
		('1', 'Non', 'Taxon sans alerte suite au passage V11')
	");

    $schemas = array('metadata', 'metadata_work') ;

    foreach ($schemas as $schema) {
    	
    	// Insertion des unit taxostatutvalue et taxomodifstatut
    	$sql = "INSERT INTO $schema.dynamode(unit, sql) VALUES
			('TaxoStatutValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoStatutValue ORDER BY code'),
			('TaxoModifValue',  'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoModifValue ORDER BY code'),
			('TaxoAlerteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TaxoAlerteValue ORDER BY code')
		";
    	$pdo->exec($sql) ;
		
		$sql = "INSERT INTO $schema.unit(unit, type, subtype, label, definition) VALUES
			('TaxoStatutValue', 'CODE', 'DYNAMIC', '[Liste] Statut du taxon pour le passage TAXREF V11', 'Statut du taxon pour le passage TAXREF V11'),
			('TaxoModifValue', 'CODE', 'DYNAMIC', '[Liste] Modification effectuée lors du passage TAXREF V11', 'Modification effectuée sur le taxon lors du passage TAXREF V11'),
			('TaxoAlerteValue', 'CODE', 'DYNAMIC', '[Liste] Taxon en alerte ou non pour le passage TAXREF V11', 'Taxon en alerte ou non pour le passage TAXREF V11')
		";
		$pdo->exec($sql) ;
    	
    	// Insertion dans la table data.
    	$sql = "INSERT INTO $schema.data(data, unit, label, definition) VALUES
            ('cdnomcalcule', 'TaxRefValue',     'cdNomCalcule', 'Code du taxon \"cd_nom\" calculé.'),
            ('cdrefcalcule', 'TaxRefValue',     'cdRefCalcule', 'Code du taxon \"cd_ref\" calculé.'),
			('taxostatut',   'TaxoStatutValue', 'taxoStatut',   'Statut du taxon pour le passage TAXREF V11'),
			('taxomodif',    'TaxoModifValue',  'taxoModif',    'Modification effectuée sur le taxon lors du passage TAXREF V11'),
			('taxoalerte',   'TaxoAlerteValue', 'taxoAlerte',   'Alerte sur le taxon pour le passage TAXREF V11')
		";
    	$pdo->exec($sql) ;
		
		// L'unité de cdnom et cdref devient CharacterString
		$pdo->exec("UPDATE $schema.data SET unit='CharacterString' WHERE data = 'cdnom' OR data = 'cdref'");
		$pdo->exec("UPDATE $schema.form_field SET input_type='TEXT' WHERE data = 'cdnom' OR data = 'cdref'");
    	
    	// Recherche des formats qui possèdent des champs cdnom et cdref.
    	$sth = $pdo->query("SELECT fo.* FROM $schema.format fo
			JOIN $schema.field fi ON fo.format = fi.format
			WHERE fi.type = 'TABLE'
			AND fi.data = 'cdnom'");
    	$formatsTable = $sth->fetchAll() ;
    	
    	$sth = $pdo->query("SELECT fo.* FROM $schema.format fo
			JOIN $schema.field fi ON fo.format = fi.format
			WHERE fi.type = 'FORM'
			AND fi.data = 'cdnom'");
    	$formatsForm = $sth->fetchAll() ;
    	
    	
    	// Format TABLE
    	foreach ($formatsTable as $format) {
    		
    		// pour tous les formats, insertion dans la table field
    		$pdo->exec("INSERT INTO $schema.field (data, format, type) VALUES
				('cdnomcalcule', '{$format['format']}', '{$format['type']}'),
				('cdrefcalcule', '{$format['format']}', '{$format['type']}'),
				('taxostatut',   '{$format['format']}', '{$format['type']}'),
				('taxomodif',    '{$format['format']}', '{$format['type']}'),
				('taxoalerte',   '{$format['format']}', '{$format['type']}')
			");
    		
    		$sth = $pdo->query("SELECT max(position) FROM $schema.table_field") ;
    		$position = $sth->fetchColumn() ;
    		
    		$pdo->exec("INSERT INTO $schema.table_field (data, format, column_name, is_calculated, is_editable, is_insertable, is_mandatory, position) VALUES
				('cdnomcalcule', '{$format['format']}', 'cdnomcalcule', 1, 0, 1, 0, ++$position),
				('cdrefcalcule', '{$format['format']}', 'cdrefcalcule', 1, 0, 1, 0, ++$position),
				('taxostatut',   '{$format['format']}', 'taxostatut',   1, 1, 0, 0, ++$position),
				('taxomodif',    '{$format['format']}', 'taxomodif',    1, 1, 0, 0, ++$position),
				('taxoalerte',   '{$format['format']}', 'taxoalerte',   1, 1, 0, 0, ++$position)
			");
    		
    		// Insertion dans dataset_fields, ce qui permet d'afficher les champs dans le requêteur.
    		$sth = $pdo->query("SELECT dataset_id FROM $schema.dataset_fields WHERE data='cdnom' AND format='{$format['format']}'") ;
    		$datasets = $sth->fetchAll() ;
    		
    		foreach ($datasets as $dataset) {
    			$pdo->exec("INSERT INTO $schema.dataset_fields (dataset_id, schema_code, format, data) VALUES
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'cdnomcalcule'),
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'cdrefcalcule'),
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'taxostatut'),
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'taxomodif'),
					('{$dataset['dataset_id']}', 'RAW_DATA', '{$format['format']}', 'taxoalerte')
				");
    		}
    		
    	}
    	
    	
    	// Formats FORM
    	foreach ($formatsForm as $format) {
    		
    		// pour tous les formats, insertion dans la table field
    		$pdo->exec("INSERT INTO $schema.field (data, format, type) VALUES
					('cdnomcalcule', '{$format['format']}', '{$format['type']}'),
					('cdrefcalcule', '{$format['format']}', '{$format['type']}'),
					('taxostatut',   '{$format['format']}', '{$format['type']}'),
					('taxomodif',    '{$format['format']}', '{$format['type']}'),
					('taxoalerte',   '{$format['format']}', '{$format['type']}')
			");
    		
    			
    		// décalage des positions pour les champs après cdnom  
    		$pdo->exec("UPDATE $schema.form_field
				SET position=position+1
				WHERE position > (SELECT position FROM $schema.form_field WHERE data='cdnom' AND format = '{$format['format']}')
			");
    		
    		// décalage des positions pour les champs après cdref
    		$pdo->exec("UPDATE $schema.form_field
				SET position=position+1
				WHERE position > (SELECT position FROM $schema.form_field WHERE data = 'cdref' AND format = '{$format['format']}')
			");
    			
    		// insertion cdnomcalcule et cdrefcalcule
    		$pdo->exec("INSERT INTO $schema.form_field (data, format, is_criteria, is_result, input_type, position, is_default_criteria, is_default_result) VALUES
				('cdnomcalcule', '{$format['format']}', 1, 1, 'TAXREF', (SELECT position+1 FROM $schema.form_field WHERE data='cdnom' AND format = '{$format['format']}'), 0, 0),
				('cdrefcalcule', '{$format['format']}', 1, 1, 'TAXREF', (SELECT position+1 FROM $schema.form_field WHERE data='cdref' AND format = '{$format['format']}'), 0, 0),
				('taxostatut',  '{$format['format']}', 1, 1, 'SELECT', (SELECT max(position) + 1 FROM $schema.form_field WHERE format = '{$format['format']}'), 0, 0),
				('taxomodif',   '{$format['format']}', 1, 1, 'SELECT', (SELECT max(position) + 1 FROM $schema.form_field WHERE format = '{$format['format']}'), 0, 0),
				('taxoalerte',  '{$format['format']}', 1, 1, 'SELECT', (SELECT max(position) + 1 FROM $schema.form_field WHERE format = '{$format['format']}'), 0, 0)
			");
		}
		
		// Field mapping
		$sth = $pdo->query("SELECT * FROM $schema.field_mapping WHERE src_data = 'cdnom'") ;
		$fieldMappings = $sth->fetchAll() ;
		foreach ($fieldMappings as $fieldMapping) {
			$pdo->exec("INSERT INTO $schema.field_mapping(src_data, src_format, dst_data, dst_format, mapping_type) VALUES
				('cdnomcalcule', '{$fieldMapping['src_format']}', 'cdnomcalcule', '{$fieldMapping['dst_format']}', 'FORM'),
				('cdrefcalcule', '{$fieldMapping['src_format']}', 'cdrefcalcule', '{$fieldMapping['dst_format']}', 'FORM'),
				('taxostatut',   '{$fieldMapping['src_format']}', 'taxostatut',   '{$fieldMapping['dst_format']}', 'FORM'),
				('taxomodif',    '{$fieldMapping['src_format']}', 'taxomodif',    '{$fieldMapping['dst_format']}', 'FORM'),
				('taxoalerte',   '{$fieldMapping['src_format']}', 'taxoalerte',   '{$fieldMapping['dst_format']}', 'FORM')
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
    	
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN cdnomcalcule VARCHAR(255)") ;
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN cdrefcalcule VARCHAR(255)") ;
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN taxostatut VARCHAR(255)") ;
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN taxomodif VARCHAR(255)") ;
    	$pdo->query("ALTER TABLE raw_data.$tableName ADD COLUMN taxoalerte VARCHAR(255)") ;
    	
    }
    
    
} catch (PDOException $e) {
	
	$pdo->rollback() ;
	
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}


// Commit transaction
$pdo->commit() ;



