<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {

	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');

	$columnName = "nomvalide";
	echo "executing " . dirname(__FILE__) . "/" . basename(__FILE__) . " ...\n";

	$query = "SELECT tablename FROM pg_tables WHERE schemaname = 'raw_data' AND tablename LIKE 'model%'";
	$result = pg_query($query);

	while ($table = pg_fetch_assoc($result)) {
		$tableName = $table['tablename'];
		echo "Traitement sur la table : $tableName\n";

		$dropColumn = "ALTER TABLE $tableName DROP COLUMN IF EXISTS $columnName";
		pg_query($dropColumn);

		$addColumn = "ALTER TABLE $tableName ADD COLUMN $columnName varchar(500)";
		pg_query($addColumn);

		$getPrimaryKeys = "
			SELECT a.attname AS pk_column
			FROM pg_index i
			JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
			WHERE i.indrelid = 'model_1_observation'::regclass AND i.indisprimary;";
		$results = pg_query($getPrimaryKeys);

		$pkeys = array();
		while ($row = pg_fetch_assoc($results)) {
			$pkeys[] = $row['pk_column'];
		}

		$fillColumn = "
			UPDATE $tableName AS m SET $columnName = lb_name
			FROM (
				SELECT lb_name, $pkeys[0], $pkeys[1]
				FROM metadata.mode_taxref AS t, $tableName AS m
				WHERE COALESCE(cdref, cdnom) = t.code
			) AS lb_names
			WHERE lb_names.$pkeys[0] = m.$pkeys[0]
			AND lb_names.$pkeys[1] = m.$pkeys[1]";
		pg_query($fillColumn);
	}
	echo "Traitement sur la table terminé.\n";
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}