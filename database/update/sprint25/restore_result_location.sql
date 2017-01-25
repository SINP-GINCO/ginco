SET SEARCH_PATH = mapping, public;

/*==============================================================*/
/* Table : result_location                                      */
/*==============================================================*/

-- Before postgresql 9.1, use : create table RESULT_LOCATION (
create UNLOGGED table RESULT_LOCATION (
  SESSION_ID           VARCHAR(50)          not null,
  FORMAT 			 VARCHAR(36)		  not null,
  PK 			 VARCHAR(100)		  not null,
  _CREATIONDT          DATE                 null DEFAULT current_timestamp,
  constraint PK_RESULT_LOCATION primary key (SESSION_ID, PK)
)
WITH OIDS; -- Important : Needed by mapserv

-- Ajout de la colonne point PostGIS
SELECT AddGeometryColumn('mapping','result_location','the_geom',3857,'GEOMETRY',2);

-- Spatial Index on the_geom
CREATE INDEX IX_RESULT_LOCATION_SPATIAL_INDEX ON mapping.RESULT_LOCATION USING GIST
( the_geom  );

CREATE INDEX RESULT_LOCATION_SESSION_IDX ON mapping.RESULT_LOCATION USING btree (SESSION_ID);

COMMENT ON COLUMN RESULT_LOCATION.SESSION_ID IS 'Identifier of the user session';
COMMENT ON COLUMN RESULT_LOCATION.FORMAT IS 'The identifier of the table containing the geometry';
COMMENT ON COLUMN RESULT_LOCATION.PK IS 'The primary key of the line containing the geometry';
COMMENT ON COLUMN RESULT_LOCATION._CREATIONDT IS 'Creation date (used to know when to purge the base)';
