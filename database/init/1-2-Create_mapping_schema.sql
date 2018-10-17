SET client_encoding='UTF8';
CREATE SCHEMA mapping;
SET SEARCH_PATH = mapping, public;


/*==============================================================*/
/* Tables : REQUESTS and RESULTS                                */
/*==============================================================*/

-- A tester en postgresql 9.1 : create UNLOGGED table RESULTS

-- requests: stores redondant information about request

-- DROP TABLE requests;
--  DROP SEQUENCE mapping.requests_id_seq;

CREATE SEQUENCE requests_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER TABLE requests_id_seq
OWNER TO admin;
GRANT ALL ON SEQUENCE requests_id_seq TO admin;
GRANT ALL ON SEQUENCE requests_id_seq TO ogam;

CREATE TABLE requests
(
  id integer NOT NULL DEFAULT nextval('requests_id_seq'::regclass),
  session_id character varying(32) NOT NULL,
  _creationdt date DEFAULT now(),
  CONSTRAINT requests_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE requests
OWNER TO admin;
GRANT ALL ON TABLE requests TO admin;
GRANT ALL ON TABLE requests TO ogam;
COMMENT ON TABLE requests
IS 'Stores redondant information about request';

-- results : n-m association table between requests and results, supporting access information

-- DROP TABLE mapping.results

CREATE TABLE results
(
  id_request integer NOT NULL,
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  user_login character varying NOT NULL,
  table_format character varying NOT NULL,
  hiding_level integer,
  CONSTRAINT results_pk PRIMARY KEY (id_request, id_observation, id_provider, user_login)
)
WITH (
OIDS=FALSE
);
ALTER TABLE results
OWNER TO admin;
GRANT ALL ON TABLE results TO admin;
GRANT ALL ON TABLE results TO ogam;
COMMENT ON TABLE results
IS 'n-m association table between requests and results, supporting access information';
COMMENT ON COLUMN results.id_request IS 'The foreign key id of the request';
COMMENT ON COLUMN results.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN results.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN results.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN results.hiding_level IS 'The value of hiding (floutage)';

-- fk to requests, with cascade on delete

ALTER TABLE results
ADD CONSTRAINT fk_request FOREIGN KEY (id_request) REFERENCES requests (id)
ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX fki_request
ON results(id_request);
            
/*==============================================================*/
-- table zoom_level : List the available map scales
-- Warning : The map approx_scale_denom should match the tilecache configuration
/*==============================================================*/
CREATE TABLE zoom_level
(
  zoom_level           INT    NOT NULL,            -- The level of zoom
  resolution           DOUBLE PRECISION NOT NULL,  -- The resolution value
  approx_scale_denom   INT    NOT NULL,            -- The approximate scale denominator value corresponding to the resolution
  scale_label          VARCHAR(10),                -- Label used for the zoom level
  is_map_zoom_level    BOOLEAN,                    -- Indicates if that zoom level must be used for the map
  PRIMARY KEY  (zoom_level)
) WITHOUT OIDS;

COMMENT ON COLUMN zoom_level.zoom_level IS 'The level of zoom';
COMMENT ON COLUMN zoom_level.resolution IS 'The resolution value';
COMMENT ON COLUMN zoom_level.approx_scale_denom IS 'The approximate scale denominator value corresponding to the resolution';
COMMENT ON COLUMN zoom_level.scale_label IS 'Label used for the zoom level';
COMMENT ON COLUMN zoom_level.is_map_zoom_level IS 'Indicates if that zoom level must be used for the map';


/*==============================================================*/
/* Table: layer_service                                      */
/*==============================================================*/
CREATE TABLE layer_service
(
 name 			VARCHAR(50)    NOT NULL,
 config 		VARCHAR(1000),     -- Si version postgresql >= 9.2, utiliser un type json
 PRIMARY KEY  (name)
)WITHOUT OIDS;

COMMENT ON TABLE layer_service IS 'Liste des fournisseurs de services (Mapservers, Géoportail, ...)';
COMMENT ON COLUMN layer_service.name IS 'Logical name of the service';


/*==============================================================*/
/* Table: layer                                      */
/*==============================================================*/
CREATE TABLE layer
(
  name 					VARCHAR(50)    NOT NULL,   -- Logical name of the layer
  label 				VARCHAR(100),  -- Label of the layer
  service_layer_name 	VARCHAR(500),  -- Name of the corresponding layer(s)
  is_transparent 		INT,           -- Indicate if the layer is transparent
  is_base_layer	 		INT,		   -- Indicate if the layer is a base layer (or an overlay)
  is_untiled			INT,           -- Force OpenLayer to request one image each time
  has_legend    		INT, 	   	   -- If value = 1 is the layer has a legend that should be displayed
  default_opacity       INT,           -- Default value of the layer opacity : 0 to 100
  max_zoom_level		INT,           -- Max scale of apparation
  min_zoom_level		INT,           -- Min scale of apparition
  provider_id 		    VARCHAR(36),   -- If empty, the layer can be seen by any country, if not it is limited to one country
  activate_type         VARCHAR(36),   -- Group of event that will activate this layer (NONE, REQUEST, AGGREGATION or HARMONIZATION)
  view_service_name	    VARCHAR(50),   -- Indicates the service for the map visualisation
  legend_service_name	VARCHAR(50),   -- Indicates the service for the legend
  detail_service_name	VARCHAR(50),   -- Indicates the service for the detail panel display
  feature_service_name	VARCHAR(50),   -- Indicates the service for the wfs
  PRIMARY KEY  (name),
  FOREIGN KEY (max_zoom_level)
      REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (min_zoom_level)
      REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (view_service_name)
      REFERENCES mapping.layer_service (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (legend_service_name)
      REFERENCES mapping.layer_service (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (detail_service_name)
      REFERENCES mapping.layer_service (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  FOREIGN KEY (feature_service_name)
      REFERENCES mapping.layer_service (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) WITHOUT OIDS;

COMMENT ON TABLE layer IS 'Liste des layers';
COMMENT ON COLUMN layer.name IS 'Logical name of the layer';
COMMENT ON COLUMN layer.label IS 'Label of the layer';
COMMENT ON COLUMN layer.service_layer_name IS 'Name of the corresponding layer(s) in the service';
COMMENT ON COLUMN layer.default_opacity IS 'Default value of the layer opacity : 0 to 100';
COMMENT ON COLUMN layer.is_transparent IS 'Indicate if the layer is transparent';
COMMENT ON COLUMN layer.is_base_layer IS 'Indicate if the layer is a base layer (or an overlay)';
COMMENT ON COLUMN layer.is_untiled IS 'Force OpenLayer to request one image each time';
COMMENT ON COLUMN layer.max_zoom_level IS 'Max scale of apparation';
COMMENT ON COLUMN layer.min_zoom_level IS 'Min scale of apparition';
COMMENT ON COLUMN layer.has_legend IS 'If value = 1 is the layer has a legend that should be displayed';
COMMENT ON COLUMN layer.provider_id IS 'If empty, the layer can be seen by any provider if not it is limited to one provider';
COMMENT ON COLUMN layer.activate_type IS 'Group of event that will activate this layer (NONE, REQUEST, AGGREGATION or INTERPOLATION)';
COMMENT ON COLUMN layer.view_service_name IS 'Indicates the service for the map visualisation';
COMMENT ON COLUMN layer.legend_service_name IS 'Indicates the service for the legend';
COMMENT ON COLUMN layer.detail_service_name IS 'Indicates the service for the detail panel display';
COMMENT ON COLUMN layer.feature_service_name IS 'Indicates the service for the wfs';

/*==============================================================*/
/*  Table: Layer_tree_node                                               */
/*==============================================================*/
CREATE TABLE layer_tree_node
(
	node_id INT,						     -- identify the node
	parent_node_id  VARCHAR(50)    NOT NULL, -- identify the parent of the node (-1 = root)
	label VARCHAR(150),                       -- label of the node into the tree
	definition VARCHAR(255),                 -- definition of the node into the tree
	is_layer INT, 						     -- if value = 1 then this is a layer, else it is only a node
	is_checked INT, 					     -- if value = 1 then the node is checked by default
	is_hidden INT, 						     -- if value = 1 then the node is hidden by default
	is_disabled INT, 					     -- if value = 1 then the node is displayed but grayed
	is_expanded INT, 					     -- if value = 1 then the node is expanded by default
	layer_name VARCHAR(50), 	             -- logical name of the layer or label of the node
	position INT, 						     -- position of the layer in its group 
	checked_group 		VARCHAR(36),         -- Allow to regroup layers. If two layers are in the same group, they will appear with a radio button in the layer tree
  	PRIMARY KEY  (node_id),
    FOREIGN KEY (layer_name)
      REFERENCES mapping.layer (name) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
) WITHOUT OIDS;

COMMENT ON COLUMN layer_tree_node.node_id IS 'Identify the layer_tree node';
COMMENT ON COLUMN layer_tree_node.parent_node_id IS 'Identify the parent of the node (-1 = root)';
COMMENT ON COLUMN layer_tree_node.label IS 'label of the node into the tree';
COMMENT ON COLUMN layer_tree_node.definition IS 'definition of the node into the tree';
COMMENT ON COLUMN layer_tree_node.is_layer IS 'If value = 1 then this is a layer, else it is only a node';
COMMENT ON COLUMN layer_tree_node.is_checked IS 'If value = 1 then the node is checked by default';
COMMENT ON COLUMN layer_tree_node.is_hidden IS 'If value = 1 then the node is hidden by default';
COMMENT ON COLUMN layer_tree_node.is_disabled IS 'If value = 1 then the node is displayed but grayed';
COMMENT ON COLUMN layer_tree_node.is_expanded IS 'If value = 1 then the node is expanded by default';
COMMENT ON COLUMN layer_tree_node.layer_name IS 'Logical name of the layer or label of the node';
COMMENT ON COLUMN layer_tree_node.position IS 'Position of the layer in its group';
COMMENT ON COLUMN layer_tree_node.checked_group IS 'Group of layers';


/*==============================================================*/
/*  Table: provider_map_params                                  */
/*==============================================================*/
CREATE TABLE provider_map_params
(
  provider_id character varying NOT NULL, -- code_country get in the metadata code table
  bb_xmin numeric, -- min longitude coordinate
  bb_ymin numeric, -- min latitude coordinate
  bb_xmax numeric, -- max longitude coordinate
  bb_ymax numeric, -- max latitude coordinate
  zoom_level int, -- default zoom level for the country
  CONSTRAINT provider_map_params_pk PRIMARY KEY (provider_id),
  FOREIGN KEY (zoom_level)
    REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION
) WITHOUT OIDS;

COMMENT ON COLUMN provider_map_params.provider_id IS 'The provider id (as found in the metadata code table)';
COMMENT ON COLUMN provider_map_params.bb_xmin IS 'Min longitude coordinate';
COMMENT ON COLUMN provider_map_params.bb_ymin IS 'Min latitude coordinate';
COMMENT ON COLUMN provider_map_params.bb_xmax IS 'Max longitude coordinate';
COMMENT ON COLUMN provider_map_params.bb_ymax IS 'Max latitude coordinate';
COMMENT ON COLUMN provider_map_params.zoom_level IS 'Default zoom level for the data provider';

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
-- Spatial Index on the geom
CREATE INDEX IX_BAC_GEOMETRIE_SPATIAL_INDEX ON bac_geometrie USING GIST ( geom  );

/*==============================================================*/
/*  Table: bac_commune                                          */
/*==============================================================*/
CREATE TABLE bac_commune
(
  id_commune character varying(5),
  geom geometry(Geometry,3857),
  id_departement character varying(3),
  CONSTRAINT bac_commune_pkey PRIMARY KEY (id_commune)
);

COMMENT ON TABLE bac_commune IS 'The visualization bac for communes geometries in web mercator';
COMMENT ON COLUMN bac_commune.id_commune IS 'The INSEE code id of the commune';
COMMENT ON COLUMN bac_commune.geom IS 'The geometry of the commune in Web Mercator projection';
COMMENT ON COLUMN bac_commune.id_departement IS 'The INSEE code id of the departement';

ALTER TABLE bac_commune ADD CONSTRAINT FK_bac_commune_commune_carto_2017
FOREIGN KEY (id_commune) REFERENCES referentiels.commune_carto_2017 (insee_com)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX IX_BAC_COMMUNE_SPATIAL_INDEX ON bac_commune USING GIST ( geom  );

/*==============================================================*/
/*  Table: bac_departement                                      */
/*==============================================================*/
CREATE TABLE bac_departement
(
  id_departement character varying(3),
  geom geometry(Geometry,3857),
  CONSTRAINT bac_departement_pkey PRIMARY KEY (id_departement)
);

COMMENT ON TABLE bac_departement IS 'The visualization bac for departements geometries in web mercator';
COMMENT ON COLUMN bac_departement.id_departement IS 'The INSEE code id of the departement';
COMMENT ON COLUMN bac_departement.geom IS 'The geometry of the departement in Web Mercator projection';

ALTER TABLE bac_departement ADD CONSTRAINT FK_bac_departement_departement_carto_2017
FOREIGN KEY (id_departement) REFERENCES referentiels.departement_carto_2017 (code_dept)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX IX_BAC_DEPARTEMENT_SPATIAL_INDEX ON bac_departement USING GIST ( geom  );
/*==============================================================*/
/*  Table: bac_region                                           */
/*==============================================================*/
CREATE TABLE bac_region
(
  id_region character varying(3),
  geom geometry(Geometry,3857),
  CONSTRAINT bac_region_pkey PRIMARY KEY (id_region)
);

COMMENT ON TABLE bac_region IS 'The visualization bac for regions geometries in web mercator';
COMMENT ON COLUMN bac_region.id_region IS 'The code id of the region';
COMMENT ON COLUMN bac_region.geom IS 'The geometry of the region in Web Mercator projection';

ALTER TABLE bac_region ADD CONSTRAINT FK_bac_region_region_carto_2017
FOREIGN KEY (id_region) REFERENCES referentiels.region_carto_2017 (code_reg)
ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX IX_BAC_REGION_SPATIAL_INDEX ON bac_region USING GIST ( geom  );
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
CREATE INDEX IX_BAC_REGION_MAILLE_INDEX ON bac_maille USING GIST ( geom  );

/*==============================================================*/
/*  Table: bac_maille                                           */
/*==============================================================*/

CREATE TABLE maille_departement
(
  id_maille character varying(20) NOT NULL, -- The id of the maille
  id_departement character varying(3) NOT NULL, -- The INSEE code id of the departement
  CONSTRAINT maille_departement_pkey PRIMARY KEY (id_maille, id_departement),
  CONSTRAINT fk_maille_departement_bac_maille FOREIGN KEY (id_maille)
      REFERENCES mapping.bac_maille (id_maille) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_maille_departement_bac_departement FOREIGN KEY (id_departement)
      REFERENCES mapping.bac_departement (id_departement) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE maille_departement IS 'Association table beetween bac_maille and bac_departement';
COMMENT ON COLUMN maille_departement.id_maille IS 'The code id of the maille';
COMMENT ON COLUMN maille_departement.id_departement IS 'The code id of the department';

/*==============================================================*/
/*  Table: bac_maille                                           */
/*  Association table beetween bac_commune and bac_maille   */
/*==============================================================*/

CREATE TABLE commune_maille
(
  id_commune character varying(5) NOT NULL, -- The INSEE code id of the commune
  id_maille character varying(20) NOT NULL, -- The id of the maille
  CONSTRAINT commune_maille_pkey PRIMARY KEY (id_commune, id_maille),
  CONSTRAINT fk_commune_maille_bac_commmune FOREIGN KEY (id_commune)
      REFERENCES mapping.bac_commune (id_commune) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_commune_maille_bac_maille FOREIGN KEY (id_maille)
      REFERENCES mapping.bac_maille(id_maille) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED
);

COMMENT ON TABLE commune_maille IS 'Association table beetween bac_commune and bac_maille';
COMMENT ON COLUMN commune_maille.id_commune IS 'The code id of the commune';
COMMENT ON COLUMN commune_maille.id_maille IS 'The code id of the maille';

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

CREATE INDEX idx_observation_geometrie_id_observation ON mapping.observation_geometrie(id_observation) ;
CREATE INDEX idx_observation_geometrie_id_geom ON mapping.observation_geometrie(id_geom) ;

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

CREATE INDEX idx_observation_commune_id_observation ON mapping.observation_commune(id_observation) ;
CREATE INDEX idx_observation_commune_id_commune ON mapping.observation_commune(id_commune) ;

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

CREATE INDEX idx_observation_maille_id_observation ON mapping.observation_maille(id_observation) ;
CREATE INDEX idx_observation_maille_id_maille ON mapping.observation_maille(id_maille) ;

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

CREATE INDEX idx_observation_departement_id_observation ON mapping.observation_departement(id_observation) ;
CREATE INDEX idx_observation_departement_id_departement ON mapping.observation_departement(id_departement) ;

COMMENT ON TABLE observation_departement IS 'The association table between an observation and its calculated departement';
COMMENT ON COLUMN observation_departement.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN observation_departement.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN observation_departement.id_departement IS 'The foreign key id of the departement (code dept)';
COMMENT ON COLUMN observation_departement.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN observation_departement.percentage IS 'The percentage of coverage of the geometry of the observation on the departement';

ALTER TABLE observation_geometrie ADD CONSTRAINT FK_OBSERVATION_GEOMETRIE_ID_GEOMETRIE
	FOREIGN KEY (id_geom) REFERENCES mapping.bac_geometrie (id_geometrie)
	ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE observation_commune ADD CONSTRAINT fk_observation_commune_id_commune
	FOREIGN KEY (id_commune) REFERENCES mapping.bac_commune (id_commune) 
	ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;
	
ALTER TABLE observation_maille ADD CONSTRAINT FK_OBSERVATION_MAILLE_ID_MAILLE
	FOREIGN KEY (id_maille) REFERENCES mapping.bac_maille (id_maille)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE observation_departement ADD CONSTRAINT FK_OBSERVATION_DEPARTEMENT_ID_DEPARTEMENT
	FOREIGN KEY (id_departement) REFERENCES mapping.bac_departement (id_departement)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

-- mapping
GRANT ALL ON SCHEMA "mapping" TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA mapping TO ogam;
GRANT ALL ON ALL SEQUENCES IN SCHEMA mapping TO ogam;
