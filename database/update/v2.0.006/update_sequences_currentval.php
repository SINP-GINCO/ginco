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

	// Get sql commands to update sequences currentval to max id in the table
	$updateSequencesRequests = "SELECT 'SELECT SETVAL(' ||
		       quote_literal(quote_ident(PGT.schemaname) || '.' || quote_ident(S.relname)) ||
		       ', COALESCE(MAX(' ||quote_ident(C.attname)|| '), 1) ) FROM ' ||
		       quote_ident(PGT.schemaname)|| '.'||quote_ident(T.relname)|| ';' as updatesequencerequest
		FROM pg_class AS S,
		     pg_depend AS D,
		     pg_class AS T,
		     pg_attribute AS C,
		     pg_tables AS PGT
		WHERE S.relkind = 'S'
		    AND S.oid = D.objid
		    AND D.refobjid = T.oid
		    AND D.refobjid = C.attrelid
		    AND D.refobjsubid = C.attnum
		    AND T.relname = PGT.tablename
		ORDER BY S.relname;";
			$updateSequencesRequestsResult = pg_query($updateSequencesRequests);

	if (!$updateSequencesRequestsResult) {
		echo "An sql error occurred.\n";
		pg_close($dbconn);
		exit(1);
	}
	
	// Update sequences currentval one by one
	while ($updateSequenceRequest = pg_fetch_assoc($updateSequencesRequestsResult)) {
		$updateResult = pg_query($updateSequenceRequest['updatesequencerequest']);
		
		if (!$updateResult) {
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


