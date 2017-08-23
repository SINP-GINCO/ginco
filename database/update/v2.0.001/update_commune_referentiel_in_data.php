<?php
$sprintDir = dirname(__FILE__);
require_once "$sprintDir/../../../lib/share.php";

try {
	
	$config = loadPropertiesFromArgs();
	$conn_string = "host={$config['db.host']} port={$config['db.port']} user={$config['db.adminuser']} password={$config['db.adminuser.pw']} dbname={$config['db.name']}";
	$dbconn = pg_connect($conn_string) or die('Connection failed');
		
	$tablesToUpdateQuery = "SELECT table_name FROM information_schema.columns WHERE table_schema = 'raw_data' AND table_name LIKE 'model%' AND column_name = 'codecommunecalcule'";
	$tablesToUpdate = pg_query($tablesToUpdateQuery);

	while ($table = pg_fetch_assoc($tablesToUpdate)) {
		echo "Traitement sur la table : " . $table['table_name'] . "\n";
		
		/* Get, for codes which disappeared between the 2 versions :  old code insee, old nom commune, new code insee, new nom commune
		 * The results are obtained with spatial intersection. Intersections smaller than 13% of the ancient commune are ignored
		 * Use it to replace calculated insee com and nom_com in data (raw_data tables)
		 */
		$sqlCodesToUpdate = "UPDATE " . $table['table_name'] . " 
			SET codeCommuneCalcule =  array_replace(codeCommuneCalcule, subquery.old_insee_com, subquery.new_insee_com),
			nomCommuneCalcule = array_replace(nomCommuneCalcule, subquery.old_nom_com, subquery.new_nom_com)
			FROM (
			select geofla_commune.insee_com as old_insee_com, geofla_commune.nom_com as old_nom_com, commune_carto_2017.insee_com as new_insee_com, commune_carto_2017.nom_com as new_nom_com
			from geofla_commune, commune_carto_2017
			where st_intersects (commune_carto_2017.geom, geofla_commune.geom)
			and (st_area(st_intersection(commune_carto_2017.geom, geofla_commune.geom))/st_area(geofla_commune.geom)) > 0.13
			and geofla_commune.insee_com IN (
				SELECT geofla_commune.insee_com 
				FROM geofla_commune 
				LEFT JOIN
				commune_carto_2017
				ON geofla_commune.insee_com = commune_carto_2017.insee_com
				where commune_carto_2017.insee_com is null)
			    ) As subquery
			    WHERE codeCommuneCalcule @> ARRAY[subquery.old_insee_com];";
		
		pg_query($sqlCodesToUpdate);

	}
	
	echo "Traitement sur la table : observation_commune \n";
	
	/* Do the same.
	 * Use it to replace id_commune in observation_commune
	 */
	$sqlCodesToUpdate = "UPDATE mapping.observation_commune
			SET id_commune = subquery.new_insee_com
			FROM (
			select geofla_commune.insee_com as old_insee_com, geofla_commune.nom_com as old_nom_com, commune_carto_2017.insee_com as new_insee_com, commune_carto_2017.nom_com as new_nom_com
			from geofla_commune, commune_carto_2017
			where st_intersects (commune_carto_2017.geom, geofla_commune.geom)
			and (st_area(st_intersection(commune_carto_2017.geom, geofla_commune.geom))/st_area(geofla_commune.geom)) > 0.13
			and geofla_commune.insee_com IN (
				SELECT geofla_commune.insee_com
				FROM geofla_commune
				LEFT JOIN
				commune_carto_2017
				ON geofla_commune.insee_com = commune_carto_2017.insee_com
				where commune_carto_2017.insee_com is null)
			    ) As subquery
			    WHERE id_commune = subquery.old_insee_com;";
	
	pg_query($sqlCodesToUpdate);
	
	pg_close($dbconn);
} catch (Exception $e) {
	echo "$sprintDir/update_db_sprint.php\n";
	echo "exception: " . $e->getMessage() . "\n";
	exit(1);
}