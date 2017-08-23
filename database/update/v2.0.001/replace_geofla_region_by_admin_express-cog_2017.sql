-- 1) First delete constraint
ALTER TABLE bac_region DROP CONSTRAINT FK_bac_region_geofla_region;

-- 2) Update departement
DROP TABLE referentiels.geofla_region;

-- Update bac_region
DELETE FROM bac_region;
-- Populate the vizualisation bacs with the referentiels tables
ALTER TABLE bac_region ALTER COLUMN geom SET DATA TYPE geometry;
INSERT INTO bac_region SELECT r.code_reg, St_Transform(r.geom, 3857) FROM referentiels.region_carto_2017 AS r;

-- I would like to execute the following command, but it brings problems with triggers ...???? 
--ALTER TABLE bac_region ALTER COLUMN geom 
--    SET DATA TYPE geometry(MultiPolygon,3857) USING ST_Multi(geom);

UPDATE metadata.dynamode SET sql='SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.region_carto_2017 ORDER BY code_reg' WHERE unit='region';

UPDATE metadata_work.dynamode SET sql='SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.region_carto_2017 ORDER BY code_reg' WHERE unit='region';

-- 3) Recreate constraint
ALTER TABLE bac_region ADD CONSTRAINT FK_bac_region_region_carto_2017
FOREIGN KEY (id_region) REFERENCES referentiels.region_carto_2017 (code_reg)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;