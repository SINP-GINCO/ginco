<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
	
	// Add column for predefined_request id in tables
	$scriptSQL = 'set search_path to website;
		
		ALTER TABLE website.predefined_request ADD COLUMN id SERIAL;
		
		CREATE UNIQUE INDEX predefined_request_unique_request_name_user_login_not_null
		  ON website.predefined_request
		  USING btree
		  (request_name COLLATE pg_catalog."default", user_login COLLATE pg_catalog."default")
		  WHERE user_login IS NOT NULL;
		
		CREATE UNIQUE INDEX predefined_request_unique_request_name_user_login_null
		  ON website.predefined_request
		  USING btree
		  (request_name COLLATE pg_catalog."default")
		  WHERE user_login IS NULL;
		  
		  
		ALTER TABLE website.predefined_request_criteria ADD COLUMN id_predefined_request integer;
		ALTER TABLE website.predefined_request_result ADD COLUMN id_predefined_request integer;
		ALTER TABLE website.predefined_request_group_asso ADD COLUMN id_predefined_request integer;';
	
	pg_query($scriptSQL);
	
	$tablesToUpdate = ['predefined_request_criteria', 'predefined_request_result', 'predefined_request_group_asso'];
	
	// Fill predefined_request id, and put it to not null
	foreach ($tablesToUpdate as $tableToUpdate) {
	
		$getPredefinedRequest = "SELECT id, request_name FROM website.predefined_request;";
		$predefinedRequests = pg_query($getPredefinedRequest);
		
		while ($request = pg_fetch_assoc($predefinedRequests)) {
			$updateTable =  "UPDATE website." . $tableToUpdate . " SET id_predefined_request = '" . $request['id'] . "' WHERE request_name = '" . $request['request_name'] . "';";
			pg_query($updateTable);
		}

		$dropConstraintFk = "ALTER TABLE website." . $tableToUpdate . " DROP CONSTRAINT IF EXISTS fk_" . $tableToUpdate . "_request_name;";
		$notNull = "ALTER TABLE website." . $tableToUpdate . "  ALTER COLUMN id_predefined_request SET NOT NULL;";
		pg_query($dropConstraintFk . $notNull);
	}
	
	// Change pk and fk from request_name to id
	 $sql = "ALTER TABLE website.predefined_request_group_asso DROP CONSTRAINT IF EXISTS fk_predefined_request_request_name;
	 	ALTER TABLE website.predefined_request DROP CONSTRAINT pk_predefined_request;
	    ALTER TABLE website.predefined_request ADD CONSTRAINT PK_PREDEFINED_REQUEST primary key (id);";
	 pg_query($sql);
	
	 $tablesToUpdate = ['predefined_request_criteria', 'predefined_request_result'];
	 
	 foreach ($tablesToUpdate as $tableToUpdate) {
		 $dropConstraintPk = "ALTER TABLE website." . $tableToUpdate . " DROP CONSTRAINT pk_" . $tableToUpdate .";";
		 $addConstraintPk = "ALTER TABLE website." . $tableToUpdate . " ADD CONSTRAINT pk_" . $tableToUpdate . " PRIMARY KEY (id_predefined_request, format, data);";
		 $addConstraintFk = "ALTER TABLE website." . $tableToUpdate . " ADD CONSTRAINT fk_" . $tableToUpdate . "_id_predefined_request FOREIGN KEY (id_predefined_request) REFERENCES website.predefined_request (id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;";
		 $removeColumn = "ALTER TABLE website." . $tableToUpdate . " DROP COLUMN request_name;";
		 
		 pg_query($dropConstraintPk . $addConstraintPk . $addConstraintFk . $removeColumn);
	 }
	
		
	$dropConstraintPk = "ALTER TABLE website.predefined_request_group_asso DROP CONSTRAINT pk_predefined_request_group_asso;";
	$addConstraintPk = "ALTER TABLE website.predefined_request_group_asso ADD CONSTRAINT pk_predefined_request_group_asso PRIMARY KEY (group_name, id_predefined_request);";
	$addConstraintFk = "ALTER TABLE website.predefined_request_group_asso ADD CONSTRAINT fk_predefined_request_id_predefined_request FOREIGN KEY (id_predefined_request) REFERENCES website.predefined_request (id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;";
	$removeColumn = "ALTER TABLE website.predefined_request_group_asso DROP COLUMN request_name;";
	
	pg_query($dropConstraintPk . $addConstraintPk . $addConstraintFk . $removeColumn);
	
	
	// Change request_name when the request is a private or public one
	$requestNamesToChangeQuery = "SELECT request_name FROM website.predefined_request, website.predefined_request_group_asso WHERE predefined_request.id = predefined_request_group_asso.id_predefined_request AND group_name = 'private_requests' OR group_name = 'public_requests';";
	$requestNamesToChange = pg_query($requestNamesToChangeQuery);
	
	while ($request = pg_fetch_assoc($requestNamesToChange)) {
		$updateTable =  "UPDATE website.predefined_request SET request_name = '" . substr($request['request_name'], 21) . "' WHERE request_name = '" . $request['request_name'] . "';";
		pg_query($updateTable);
	}
	
	pg_close($dbconn);
	
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}




