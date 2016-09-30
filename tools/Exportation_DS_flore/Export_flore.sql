-- Voilà la requête qui crée la correspondance entre notre identifiant NPP et l'identifiant des données brutes IDP :

------------------------------ Génération de l'identifiant du point ----------------------------
/*CREATE TEMPORARY TABLE point (npp CHAR(16), idp CHAR(6), CONSTRAINT point_pkey PRIMARY KEY (npp));

INSERT INTO point
SELECT npp, incref || LPAD(position::VARCHAR(5), 5, '0')
FROM (
    SELECT npp, incref, RANK() OVER(PARTITION BY incref ORDER BY DIGEST(npp, 'sha1')) AS position
    FROM inv_exp_nm.e1point
    ORDER BY 3
) x;*/

Select DISTINCT
'TE' as "StatutSource",
p.idp || '_' || g3f.cd_ref as "IdentifiantOrigine",
'' as "JddId",
'exploitation' as "JddCode",
'' as "IdentifiantPermanent",
'PU' as "DSPublique",
'' as "CodeIDCNP",
'PR' as "StatutObservation",
'' as "NomCite",
g3f.cd_ref as "CdNom",
'Non' as "Sensible",
'Anonyme' as "IdentiteObservateur",
'IGN' as "OrganismeObservateur",
'Anonyme' as "IdentiteGestionnaireDonnees",
'IGN' as "OrganismeGestionnaireDonnees",
g3e.dateeco as "DateDebut",
g3e.dateeco as "DateFin",
xy.xl93 as "X",
xy.yl93 as "Y",
'POINT(' || xy.xl93 || ' ' || xy.yl93 || ')' as "Geometrie"
FROM point p
INNER JOIN inv_exp_nm.g3flore g3f USING (npp)
LEFT JOIN inv_exp_nm.g3ecologie g3e USING (npp)
LEFT JOIN (
	-- Coordonnées des placettes (dégradées) en Lambert93
	SELECT     p.idp,
	-- données de reconnaissance placette
	    ST_X(geom.g)::INT AS xl93, ST_Y(geom.g)::INT AS yl93 -- lambert93
	FROM point p
	INNER JOIN (
	    SELECT p1.NPP, ST_Transform(ST_SetSRID(ST_MakePoint(p1.xl, p1.yl), 320002120), 310024140) AS g
	    FROM inv_exp_nm.e1point p1
	    --WHERE p1.incref = 3
	) geom ON p.npp = geom.npp
	ORDER BY p.idp) as xy ON xy.idp = p.idp
WHERE g3f.cd_ref IS NOT NULL
--AND g3f.incref = 3
GROUP BY p.idp || '_' || g3f.cd_ref, g3f.cd_ref, g3e.dateeco, xy.xl93, xy.yl93 
ORDER BY p.idp || '_' || g3f.cd_ref;

