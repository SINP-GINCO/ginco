ALTER TABLE bac_departement DROP CONSTRAINT FK_bac_departement_geofla_departement,
ADD CONSTRAINT FK_bac_departement_departement_carto_2017
FOREIGN KEY (id_departement) REFERENCES referentiels.departement_carto_2017 (code_dept)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

DROP TABLE referentiels.geofla_departement;

-- Update bac_departement
DELETE FROM bac_departement;
-- Populate the vizualisation bacs with the referentiels tables
ALTER TABLE bac_departement ALTER COLUMN geom SET DATA TYPE geometry;
INSERT INTO bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.departement_carto_2017 AS r;

-- I would like to execute the following command, but it brings problems with triggers ...???? 
--ALTER TABLE bac_departement ALTER COLUMN geom 
--    SET DATA TYPE geometry(MultiPolygon,3857) USING ST_Multi(geom);

UPDATE metadata.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.departement_carto_2017 ORDER BY code_dept' WHERE unit='CodeDepartementCalculeValue';
UPDATE metadata.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.departement_carto_2017 ORDER BY code_dept' WHERE unit='CodeDepartementValue';

UPDATE metadata_work.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.departement_carto_2017 ORDER BY code_dept' WHERE unit='CodeDepartementCalculeValue';
UPDATE metadata_work.dynamode SET sql='SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.departement_carto_2017 ORDER BY code_dept' WHERE unit='CodeDepartementValue';
