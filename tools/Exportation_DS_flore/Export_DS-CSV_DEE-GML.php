<?php

// Connexion au serveur
// $conn_string = "host=mouton port=5432 dbname=test user=agneau password=bar options='--client_encoding=UTF8'";
$conn_string = "host=inv-exp.ign.fr port=5432 dbname=exploitation user=inv_exp_public";
$conn = pg_connect($conn_string);

// Creation et envoi de la requete
$query = "
CREATE TEMPORARY TABLE point (npp CHAR(16), idp CHAR(6), CONSTRAINT point_pkey PRIMARY KEY (npp));
INSERT INTO point
SELECT npp, incref || LPAD(position::VARCHAR(5), 5, '0')
FROM (
    SELECT npp, incref, RANK() OVER(PARTITION BY incref ORDER BY DIGEST(npp, 'sha1')) AS position
    FROM inv_exp_nm.e1point
    ORDER BY 3
) x;
Select DISTINCT
'TE' as \"StatutSource\",
p.idp || '_' || g3f.cd_ref as \"IdentifiantOrigine\",
'' as \"JddId\",
'exploitation' as \"JddCode\",
'' as \"IdentifiantPermanent\",
'PU' as \"DSPublique\",
'' as \"CodeIDCNP\",
'PR' as \"StatutObservation\",
'' as \"NomCite\",
g3f.cd_ref as \"CdNom\",
'Non' as \"Sensible\",
'Anonyme' as \"IdentiteObservateur\",
'IGN' as \"OrganismeObservateur\",
'Anonyme' as \"IdentiteGestionnaireDonnees\",
'IGN' as \"OrganismeGestionnaireDonnees\",
g3e.dateeco as \"DateDebut\",
g3e.dateeco as \"DateFin\",
xy.xl93 as \"X\",
xy.yl93 as \"Y\"--,
--'POINT(' || xy.xl93 || ' ' || xy.yl93 || ')' as \"Geometrie\"
FROM point p
INNER JOIN inv_exp_nm.g3flore g3f USING (npp)
LEFT JOIN inv_exp_nm.g3ecologie g3e USING (npp)
LEFT JOIN (
	SELECT     p.idp,
	    ST_X(geom.g)::INT AS xl93, ST_Y(geom.g)::INT AS yl93 -- lambert93
	FROM point p
	INNER JOIN (
	    SELECT p1.NPP, ST_Transform(ST_SetSRID(ST_MakePoint(p1.xl, p1.yl), 320002120), 310024140) AS g
	    FROM inv_exp_nm.e1point p1
	    WHERE p1.incref = 3
	) geom ON p.npp = geom.npp
	ORDER BY p.idp) as xy ON xy.idp = p.idp
WHERE g3f.cd_ref IS NOT NULL
AND g3f.incref = 3
GROUP BY p.idp || '_' || g3f.cd_ref, g3f.cd_ref, g3e.dateeco, xy.xl93, xy.yl93 
ORDER BY p.idp || '_' || g3f.cd_ref
LIMIT 10;
";

$result = pg_query($conn, $query);

// Recuperation des resultats
$observations = [];
while ($row = pg_fetch_row($result)){
	$observations[] = array(
		"StatutSource" => $row[0],
		"IdentifiantOrigine" => $row[1],
		"JddId" => $row[2],
		"JddCode" => $row[3],
		"IdentifiantPermanent" => $row[4],
		"DSPublique" => $row[5],
		"CodeIDCNP" => $row[6],
		"StatutObservation" => $row[7],
		"NomCite" => $row[8],
		"CdNom" => $row[9],
		"Sensible" => $row[10],
		"IdentiteObservateur" => $row[11],
		"OrganismeObservateur" => $row[12],
		"IdentiteGestionnaireDonnees" => $row[13],
		"OrganismeGestionnaireDonnees" => $row[14],
		"DateDebut" => $row[15],
		"DateFin" => $row[16],
		"X" => $row[17],
		"Y" => $row[18],
		"Geometrie" => $row[19]
	);
	echo $row[1] . " ok\n\r";
}

// Deconnexion de la base de donnees
pg_close();
$fileName = "Flore.gml";
if (file_exists ($fileName)) unlink ($fileName);
$monfichier = fopen($fileName, 'a');

$out = '<wfs:FeatureCollection numberReturned="1" timeStamp="2005-06-29T09:30:30Z" numberMatched="1" xmlns:wfs="http://www.opengis.net/wfs/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sinp="http://www.naturefrance.fr/sinp/" xmlns:gml="http://www.opengis.net/gml/3.2" xsi:schemaLocation="http://www.opengis.net/wfs/2.0 http://schemas.opengis.net/wfs/2.0/wfs.xsd http://www.naturefrance.fr/sinp/ observation0.4.xsd">';
for($i = 0; $i < count($observations); $i++){
$observation = $observations[$i];
$out .= '
	<wfs:member>
		<sinp:Observation gml:id="ID_'.$observation["IdentifiantOrigine"].'">
			<sinp:statusSource>'.$observation["StatutSource"].'</sinp:statusSource>
			<sinp:identifiantPermament>'.$observation["IdentifiantPermanent"].'</sinp:identifiantPermament>
			<sinp:statusObservation>'.$observation["StatutObservation"].'</sinp:statusObservation>
			<sinp:cdNom>'.$observation["CdNom"].'</sinp:cdNom>
			<sinp:georeference>
				<sinp:Georeference>
					<sinp:geometriePoint>
						<gml:Point gml:id="p'.$observation["IdentifiantOrigine"].'" srsName="urn:ogc:def:crs:EPSG:6.6:2154">
							<gml:pos>'.$observation["X"].' '.$observation["Y"].'</gml:pos>
						</gml:Point>
					</sinp:geometriePoint>
				</sinp:Georeference>
			</sinp:georeference>
			<sinp:observateur>
				<sinp:Personne>
					<sinp:identite>'.$observation["IdentiteObservateur"].'</sinp:identite>
					<sinp:organisme>
						<sinp:Organisme>
							<sinp:nom>'.$observation["OrganismeObservateur"].'</sinp:nom>
						</sinp:Organisme>
					</sinp:organisme>
				</sinp:Personne>
			</sinp:observateur>
			<sinp:validateur>
				<sinp:Personne>
					<sinp:identite>'.$observation["IdentiteGestionnaireDonnees"].'</sinp:identite>
					<sinp:organisme>
						<sinp:Organisme>
							<sinp:nom>'.$observation["OrganismeGestionnaireDonnees"].'</sinp:nom>
						</sinp:Organisme>
					</sinp:organisme>
				</sinp:Personne>
			</sinp:validateur>
			<sinp:determinateur>
				<sinp:Personne>
					<sinp:identite/>
				</sinp:Personne>
			</sinp:determinateur>
			<sinp:empriseTemporelle>
				<sinp:EmpriseTemporelle>
					<sinp:dateDebut>'.$observation["DateDebut"].'T00:00:00Z</sinp:dateDebut>
					<sinp:dateFin>'.$observation["DateFin"].'T00:00:00Z</sinp:dateFin>
				</sinp:EmpriseTemporelle>
			</sinp:empriseTemporelle>
			<sinp:source>
				<sinp:Source>
					<sinp:jddId>'.$observation["JddId"].'</sinp:jddId>
					<sinp:jddCode>'.$observation["JddCode"].'</sinp:jddCode>
					<sinp:dSPublique>'.$observation["DSPublique"].'</sinp:dSPublique>
					<sinp:identifiantOrigine>'.$observation["IdentifiantOrigine"].'</sinp:identifiantOrigine>
					<sinp:codeIDCNP>'.$observation["CodeIDCNP"].'</sinp:codeIDCNP>
					<sinp:sensible>'.$observation["Sensible"].'</sinp:sensible>
					<sinp:nomScientifiqueCite>'.$observation["NomCite"].'</sinp:nomScientifiqueCite>
				</sinp:Source>
			</sinp:source>
		</sinp:Observation>
	</wfs:member>';
};
$out .= '
</wfs:FeatureCollection>';

fputs($monfichier, $out);
fclose($monfichier);
?>

