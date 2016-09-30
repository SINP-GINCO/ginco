-- In correlation with task #523 (geo administrative attachment).
-- 1. referentiels tables are recreated with geometry in 4326 projection, columns renaming and table renaming.
-- Creation scripts are included in other scripts, while here former to be tables are deleted.
-- 2. visualization bacs tables with geometry in 3857 projection are created.
-- 3. association tables between observations and geometries or references to referentiels geometries are created.
-- 4. rights to ogam are given (all rights, creation and deletion included). 

DROP TABLE IF EXISTS referentiels.communes CASCADE;
DROP TABLE IF EXISTS referentiels.departements CASCADE;
DROP TABLE IF EXISTS referentiels.regions CASCADE;
DROP TABLE IF EXISTS mapping.bac_geometrie CASCADE;
DROP TABLE IF EXISTS mapping.bac_commune CASCADE;
DROP TABLE IF EXISTS mapping.bac_departement CASCADE;
DROP TABLE IF EXISTS mapping.bac_region CASCADE;
DROP TABLE IF EXISTS mapping.observation_geometrie CASCADE;
DROP TABLE IF EXISTS mapping.observation_commune CASCADE;
DROP TABLE IF EXISTS mapping.observation_maille CASCADE;
DROP TABLE IF EXISTS mapping.observation_departement CASCADE;

SET SEARCH_PATH = mapping, public;

/*==============================================================*/
/*  Table: bac_geometrie                                        */
/*==============================================================*/
CREATE TABLE bac_geometrie
(
  id_geometrie SERIAL,
  geom geometry(Geometry, 3857),
  CONSTRAINT geometrie_pk PRIMARY KEY (id_geometrie)
);

COMMENT ON TABLE bac_geometrie IS 'The visualization bac for precise geometries in web mercator';
COMMENT ON COLUMN bac_geometrie.id_geometrie IS 'The id of the geometrie';
COMMENT ON COLUMN bac_geometrie.geom IS 'The geometry in Web Mercator projection';

/*==============================================================*/
/*  Table: bac_commune                                          */
/*==============================================================*/
CREATE TABLE bac_commune
(
  id_commune character varying(5),
  geom geometry(MultiPolygon,3857),
  CONSTRAINT bac_commune_pkey PRIMARY KEY (id_commune)
);

COMMENT ON TABLE bac_commune IS 'The visualization bac for communes geometries in web mercator';
COMMENT ON COLUMN bac_commune.id_commune IS 'The INSEE code id of the commune';
COMMENT ON COLUMN bac_commune.geom IS 'The geometry of the commune in Web Mercator projection';

ALTER TABLE bac_commune ADD CONSTRAINT FK_bac_commune_geofla_commune
FOREIGN KEY (id_commune) REFERENCES referentiels.geofla_commune (insee_com)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

/*==============================================================*/
/*  Table: bac_departement                                      */
/*==============================================================*/
CREATE TABLE bac_departement
(
  id_departement character varying(3),
  geom geometry(MultiPolygon,3857),
  CONSTRAINT bac_departement_pkey PRIMARY KEY (id_departement)
);

COMMENT ON TABLE bac_departement IS 'The visualization bac for departements geometries in web mercator';
COMMENT ON COLUMN bac_departement.id_departement IS 'The INSEE code id of the departement';
COMMENT ON COLUMN bac_departement.geom IS 'The geometry of the departement in Web Mercator projection';

ALTER TABLE bac_departement ADD CONSTRAINT FK_bac_departement_geofla_departement
FOREIGN KEY (id_departement) REFERENCES referentiels.geofla_departement (code_dept)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

/*==============================================================*/
/*  Table: bac_region                                           */
/*==============================================================*/
CREATE TABLE bac_region
(
  id_region character varying(3),
  geom geometry(MultiPolygon,3857),
  CONSTRAINT bac_region_pkey PRIMARY KEY (id_region)
);

COMMENT ON TABLE bac_region IS 'The visualization bac for regions geometries in web mercator';
COMMENT ON COLUMN bac_region.id_region IS 'The code id of the region';
COMMENT ON COLUMN bac_region.geom IS 'The geometry of the region in Web Mercator projection';

ALTER TABLE bac_region ADD CONSTRAINT FK_bac_region_geofla_region
FOREIGN KEY (id_region) REFERENCES referentiels.geofla_region (code_reg)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

/*==============================================================*/
/*  Table: bac_maille                                           */
/*==============================================================*/
CREATE TABLE bac_maille
(
  id_maille character varying(20),
  geom geometry(MultiPolygon,3857),
  CONSTRAINT bac_maille_pkey PRIMARY KEY (id_maille)
);

COMMENT ON TABLE bac_maille IS 'The visualization bac for mailles geometries in web mercator';
COMMENT ON COLUMN bac_maille.id_maille IS 'The code id of the maille';
COMMENT ON COLUMN bac_maille.geom IS 'The geometry of the maille in Web Mercator projection';

ALTER TABLE bac_maille ADD CONSTRAINT FK_bac_maille_codemaillevalue
FOREIGN KEY (id_maille) REFERENCES referentiels.codemaillevalue (code_10km)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

/*==============================================================*/
/*  Table: observation_geometrie                                */
/*==============================================================*/
CREATE TABLE observation_geometrie
(
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  table_format character varying NOT NULL,
  id_geom integer NOT NULL,
  CONSTRAINT observation_geometrie_pk PRIMARY KEY (id_observation, id_provider, table_format, id_geom)
);

COMMENT ON TABLE observation_geometrie IS 'The association table between an observation and its most precise geometry';
COMMENT ON COLUMN observation_geometrie.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN observation_geometrie.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN observation_geometrie.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN observation_geometrie.id_geom IS 'The foreign key id of the geometry';

/*==============================================================*/
/*  Table: observation_commune                                  */
/*==============================================================*/
CREATE TABLE observation_commune
(
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  table_format character varying NOT NULL,
  id_commune character varying NOT NULL,
  percentage numeric(4,3) NOT NULL,
  CONSTRAINT observation_commune_pk PRIMARY KEY (id_observation, id_provider, table_format, id_commune)
);

COMMENT ON TABLE observation_commune IS 'The association table between an observation and its calculated commune';
COMMENT ON COLUMN observation_commune.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN observation_commune.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN observation_commune.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN observation_commune.id_commune IS 'The foreign key id of the commune (code insee)';
COMMENT ON COLUMN observation_commune.percentage IS 'The percentage of coverage of the geometry of the observation on the commune';

/*==============================================================*/
/*  Table: observation_maille                                   */
/*==============================================================*/
CREATE TABLE observation_maille
(
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  table_format character varying NOT NULL,
  id_maille character varying NOT NULL,
  percentage numeric(4,3) NOT NULL,
  CONSTRAINT observation_maille_pk PRIMARY KEY (id_observation, id_provider, table_format, id_maille)
);

COMMENT ON TABLE observation_maille IS 'The association table between an observation and its calculated maille';
COMMENT ON COLUMN observation_maille.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN observation_maille.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN observation_maille.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN observation_maille.id_maille IS 'The foreign key id of the maille (code 10km)';
COMMENT ON COLUMN observation_maille.percentage IS 'The percentage of coverage of the geometry of the observation on the maille';

/*==============================================================*/
/*  Table: observation_departement                              */
/*==============================================================*/
CREATE TABLE observation_departement
(
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  table_format character varying NOT NULL,
  id_departement character varying NOT NULL,
  percentage numeric(4,3) NOT NULL,
  CONSTRAINT observation_departement_pk PRIMARY KEY (id_observation, id_provider, table_format, id_departement)
);

COMMENT ON TABLE observation_departement IS 'The association table between an observation and its calculated departement';
COMMENT ON COLUMN observation_departement.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN observation_departement.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN observation_departement.id_departement IS 'The foreign key id of the departement (code dept)';
COMMENT ON COLUMN observation_departement.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN observation_departement.percentage IS 'The percentage of coverage of the geometry of the observation on the departement';

ALTER TABLE observation_geometrie ADD CONSTRAINT FK_OBSERVATION_GEOMETRIE_ID_GEOMETRIE
	FOREIGN KEY (id_geom) REFERENCES mapping.bac_geometrie (id_geometrie)
	ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE observation_maille ADD CONSTRAINT FK_OBSERVATION_MAILLE_ID_MAILLE
	FOREIGN KEY (id_maille) REFERENCES mapping.bac_maille (id_maille)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE observation_departement ADD CONSTRAINT FK_OBSERVATION_DEPARTEMENT_ID_DEPARTEMENT
	FOREIGN KEY (id_departement) REFERENCES mapping.bac_departement (id_departement)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

GRANT ALL ON SCHEMA "mapping" TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA mapping TO ogam;
GRANT ALL ON ALL SEQUENCES IN SCHEMA mapping TO ogam;

GRANT ALL ON SCHEMA referentiels TO ogam;
GRANT SELECT ON ALL TABLES IN schema referentiels to ogam;