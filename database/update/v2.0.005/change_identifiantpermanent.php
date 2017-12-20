<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	/* Change identifiantpermanent, keep only the uuid. Update the data in raw_data. */
	$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = 'identifiantpermanent'";
	$tablesToUpdate = pg_query($tablesToUpdateQuery);

	while ($table = pg_fetch_assoc($tablesToUpdate)) {
		echo "Traitement sur la table : " . $table['table_name'] . "\n";

		// Change identifiantpermanent
		$valuesToChangeQuery = "SELECT identifiantpermanent FROM " . $table['table_name'] . ";";
		$valuesToChange = pg_query($valuesToChangeQuery);

		while ($request = pg_fetch_assoc($valuesToChange)) {
			$updateTable =  "UPDATE " . $table['table_name'] . "  SET identifiantpermanent = '" . substr($request['identifiantpermanent'], -36) . "' WHERE identifiantpermanent = '" . $request['identifiantpermanent'] . "';";
			pg_query($updateTable);
		}

		// Replace existing functions called by the trigger
		$replaceExistingFunction = "
		SET SEARCH_PATH = raw_data, public;
		
		CREATE OR REPLACE FUNCTION raw_data.perm_id_generate" . $table['table_name'] . "()
		RETURNS trigger AS " .
		'$BODY$' . " 
		BEGIN
		IF (NEW.identifiantPermanent IS NULL OR NEW.identifiantPermanent = '') THEN
		NEW.identifiantPermanent  := uuid_generate_v1();
		END IF;
		RETURN NEW;
		END; " . '
		$BODY$' . " 
		LANGUAGE plpgsql VOLATILE
		COST 100;
		ALTER FUNCTION raw_data.perm_id_generate" . $table['table_name'] . "()
		OWNER TO ogam;";
		pg_query($replaceExistingFunction);

	}

	// Make sure identifiantpermanent is not mandatory in dsr import model example, calculated, and not insertable
	$identifiantPermanentMandatory = "
		UPDATE metadata.table_field SET is_mandatory=1, is_calculated=1, is_editable=0 WHERE data = 'identifiantpermanent';
		UPDATE metadata_work.table_field SET is_mandatory=1, is_calculated=1, is_editable=0 WHERE data = 'identifiantpermanent';
		
		UPDATE metadata.file_field SET is_mandatory=0 WHERE data = 'identifiantpermanent';
		UPDATE metadata_work.file_field SET is_mandatory=0 WHERE data = 'identifiantpermanent';";
	pg_query($identifiantPermanentMandatory);

	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}