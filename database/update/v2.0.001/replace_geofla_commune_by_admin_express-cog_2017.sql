-- 1) First delete constraint
ALTER TABLE bac_commune DROP CONSTRAINT FK_bac_commune_geofla_commune;

DROP TABLE referentiels.geofla_commune;

-- 2) Update commune
DELETE FROM bac_commune;
-- Populate the vizualisation bacs with the referentiels tables
ALTER TABLE bac_commune ALTER COLUMN geom SET DATA TYPE geometry;
INSERT INTO bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857) FROM referentiels.commune_carto_2017 AS r;

-- I would like to execute the following command, but it brings problems with triggers ...???? 
--ALTER TABLE bac_commune ALTER COLUMN geom 
--    SET DATA TYPE geometry(MultiPolygon,3857) USING ST_Multi(geom);

-- Update dynamodes
UPDATE metadata.dynamode SET sql='SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com' WHERE unit='CodeCommuneCalculeValue';
UPDATE metadata.dynamode SET sql='SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com' WHERE unit='CodeCommuneValue';
UPDATE metadata.dynamode SET sql='SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY nom_com' WHERE unit='NomCommuneCalculeValue';

UPDATE metadata_work.dynamode SET sql='SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com' WHERE unit='CodeCommuneCalculeValue';
UPDATE metadata_work.dynamode SET sql='SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY insee_com' WHERE unit='CodeCommuneValue';
UPDATE metadata_work.dynamode SET sql='SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.commune_carto_2017 ORDER BY nom_com' WHERE unit='NomCommuneCalculeValue';

-- 3) Recreate constraints
ALTER TABLE bac_commune ADD CONSTRAINT FK_bac_commune_commune_carto_2017
FOREIGN KEY (id_commune) REFERENCES referentiels.commune_carto_2017 (insee_com)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

--Add a forgotten foreign key 
ALTER TABLE observation_commune ADD CONSTRAINT fk_observation_commune_id_commune FOREIGN KEY (id_commune)
 REFERENCES mapping.bac_commune (id_commune) MATCH SIMPLE
 ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

