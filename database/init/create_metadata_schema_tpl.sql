/*==============================================================*/
/*	Metamodel initialization.
	Used to create a new and clean 'metadata'
	or 'metadata_work' schema.									*/
/*==============================================================*/
SET search_path TO public;

/**
 * This function only returns the result of unaccent function included in
 * 'unaccent' extension of PostgreSQL since version 9.1.
 * It is created in order to be usable as an immutable function for the creation
 * of indexes (in metadata creation script).
 */
CREATE OR REPLACE FUNCTION unaccent_immutable(varchar)
  RETURNS varchar AS
$func$
SELECT public.unaccent('public.unaccent', $1)  -- schema-qualify function and dictionary
$func$  LANGUAGE sql IMMUTABLE;


CREATE SCHEMA  @schema@ ;
SET search_path TO @schema@, public ;


/*==============================================================*/
/* Table : DATA                                                 */
/*==============================================================*/
create table DATA (
DATA                 VARCHAR(277)         not null,
UNIT                 VARCHAR(36)          not null,
LABEL                VARCHAR(125)         null,
DEFINITION           VARCHAR(255)         null,
COMMENT              VARCHAR(255)         null,
constraint PK_DATA primary key (DATA)
);

COMMENT ON COLUMN DATA.DATA IS 'The logical name of the data';
COMMENT ON COLUMN DATA.UNIT IS 'The unit of the data';
COMMENT ON COLUMN DATA.LABEL IS 'The label of the data';
COMMENT ON COLUMN DATA.DEFINITION IS 'The definition of the data (used in tooltips)';
COMMENT ON COLUMN DATA.COMMENT IS 'Any comment on the data';


/*==============================================================*/
/* Table : UNIT                                                 */
/*==============================================================*/
create table UNIT (
UNIT                 VARCHAR(36)          not null,
TYPE                 VARCHAR(36)          null,
SUBTYPE              VARCHAR(36)          null,
LABEL                VARCHAR(60)          null,
DEFINITION           VARCHAR(255)         null,
constraint PK_UNIT primary key (UNIT)
);

COMMENT ON COLUMN UNIT.UNIT IS 'The logical name of the unit';
COMMENT ON COLUMN UNIT.TYPE IS 'The type of the unit (BOOLEAN, CODE, ARRAY (of code), COORDINATE, DATE, INTEGER, NUMERIC or STRING)';
COMMENT ON COLUMN UNIT.SUBTYPE IS 'The sub-type of the unit (MODE, TREE or DYNAMIC for CODE or ARRAY, RANGE for numeric)';
COMMENT ON COLUMN UNIT.LABEL IS 'The label of the unit';
COMMENT ON COLUMN UNIT.DEFINITION IS 'The definition of the unit';


/*==============================================================*/
/* Table : MODE                                                 */
/*==============================================================*/
create table MODE (
UNIT                 VARCHAR(36)             not null,
CODE                 VARCHAR(36)             not null,
POSITION           	 INT4                 null,
LABEL                VARCHAR(255)         null,
DEFINITION           VARCHAR(255)         null,
constraint PK_MODE primary key (UNIT, CODE)
);

COMMENT ON COLUMN MODE.UNIT IS 'The unit';
COMMENT ON COLUMN MODE.CODE IS 'The code';
COMMENT ON COLUMN MODE.POSITION IS 'The position of this mode in the list';
COMMENT ON COLUMN MODE.LABEL IS 'The label';
COMMENT ON COLUMN MODE.DEFINITION IS 'The definition of the mode';

/*==============================================================*/
/* Table : GROUP_MODE                                                 */
/*==============================================================*/
create table GROUP_MODE (
SRC_UNIT                 VARCHAR(36)             not null,
SRC_CODE                 VARCHAR(36)             not null,
DST_UNIT           	     VARCHAR(36)             not null,
DST_CODE                 VARCHAR(36)             not null,
COMMENT                  VARCHAR(255)            null,
constraint PK_GROUP_MODE primary key (SRC_UNIT, SRC_CODE, DST_UNIT, DST_CODE)
);

COMMENT ON COLUMN GROUP_MODE.SRC_UNIT IS 'The source unit';
COMMENT ON COLUMN GROUP_MODE.SRC_CODE IS 'The source code';
COMMENT ON COLUMN GROUP_MODE.DST_UNIT IS 'The destination unit';
COMMENT ON COLUMN GROUP_MODE.DST_CODE IS 'The destination code';
COMMENT ON COLUMN GROUP_MODE.COMMENT IS 'Any comment';



/*==============================================================*/
/* Table : MODE_TREE                                            */
/*==============================================================*/
create table MODE_TREE (
UNIT                 VARCHAR(36)          not null,
CODE                 VARCHAR(36)          not null,
PARENT_CODE          VARCHAR(36)          null,
LABEL                VARCHAR(255)          null,
DEFINITION           VARCHAR(255)         null,
POSITION			 INTEGER              null,
IS_LEAF			     CHAR(1)              null,
constraint PK_MODE_TREE primary key (UNIT, CODE)
);

COMMENT ON COLUMN MODE_TREE.UNIT IS 'The unit';
COMMENT ON COLUMN MODE_TREE.CODE IS 'The code of the mode';
COMMENT ON COLUMN MODE_TREE.PARENT_CODE IS 'The parent code';
COMMENT ON COLUMN MODE_TREE.LABEL IS 'The label';
COMMENT ON COLUMN MODE_TREE.DEFINITION IS 'The definition of the mode';
COMMENT ON COLUMN MODE_TREE.POSITION IS 'The position of the mode';
COMMENT ON COLUMN MODE_TREE.IS_LEAF IS 'Indicate if the node is a leaf (1 for true)';


/*==============================================================*/
/* Table : MODE_TAXREF                                          */
/*==============================================================*/
create table MODE_TAXREF (
UNIT                 VARCHAR(36)          not null,
CODE                 VARCHAR(36)          not null,
PARENT_CODE          VARCHAR(36)          null,
LABEL                 VARCHAR(500)         null,
LB_NAME              VARCHAR(500)         null,
DEFINITION           VARCHAR(500)         null,
COMPLETE_NAME        VARCHAR(500)         null,
VERNACULAR_NAME      VARCHAR(1000)        null,
IS_LEAF			     CHAR(1)              null,
IS_REFERENCE	     CHAR(1)              null,
POSITION		     INTEGER              null,
constraint PK_MODE_TAXREF primary key (UNIT, CODE)
);


COMMENT ON COLUMN MODE_TAXREF.UNIT IS 'The unit';
COMMENT ON COLUMN MODE_TAXREF.CODE IS 'The code of the mode';
COMMENT ON COLUMN MODE_TAXREF.PARENT_CODE IS 'The parent code';
COMMENT ON COLUMN MODE_TAXREF.LABEL IS 'The short name of the taxon';
COMMENT ON COLUMN MODE_TAXREF.LB_NAME IS 'The scientific name of the taxon (without the authority)';
COMMENT ON COLUMN MODE_TAXREF.DEFINITION IS 'The definition of the mode';
COMMENT ON COLUMN MODE_TAXREF.COMPLETE_NAME IS 'The complete name of the taxon (name and author)';
COMMENT ON COLUMN MODE_TAXREF.VERNACULAR_NAME IS 'The vernacular name';
COMMENT ON COLUMN MODE_TAXREF.IS_LEAF IS 'Indicate if the node is a taxon (1 for true)';
COMMENT ON COLUMN MODE_TAXREF.IS_REFERENCE IS 'Indicate if the taxon is a reference (1) or a synonym (0)';
COMMENT ON COLUMN MODE_TAXREF.POSITION IS 'The position of the mode';

CREATE INDEX mode_taxref_parent_code_idx
  ON mode_taxref USING btree (parent_code);
  
CREATE INDEX mode_taxref_label_idx
  ON mode_taxref USING gist (unaccent_immutable(label) gist_trgm_ops);
  
CREATE INDEX mode_taxref_complete_name_idx
  ON mode_taxref USING gist (unaccent_immutable(complete_name) gist_trgm_ops);
  
CREATE INDEX mode_taxref_vernacular_name_idx
  ON mode_taxref USING gist (unaccent_immutable(vernacular_name) gist_trgm_ops);


/*==============================================================*/
/* Table : DYNAMODE                                            */
/*==============================================================*/
create table DYNAMODE (
UNIT                 VARCHAR(36)          not null,
SQL                  TEXT          not null,
constraint PK_DYNAMODE primary key (UNIT)
);

COMMENT ON COLUMN DYNAMODE.UNIT IS 'The unit';
COMMENT ON COLUMN DYNAMODE.SQL IS 'The sql query that will generate the list of codes. A sorted list of uniques CODE, LABEL is expected';




/*==============================================================*/
/* Table : RANGE                                                */
/*==============================================================*/
create table RANGE (
UNIT                 VARCHAR(36)             not null,
MIN                  FLOAT8               null,
MAX                  FLOAT8               null,
constraint PK_RANGE primary key (UNIT)
);

COMMENT ON COLUMN RANGE.UNIT IS 'The unit';
COMMENT ON COLUMN RANGE.MIN IS 'The minimal value of the range';
COMMENT ON COLUMN RANGE.MAX IS 'The maximal value of the range';


/*==============================================================*/
/* Table : FORMAT                                               */
/*==============================================================*/
create table FORMAT (
FORMAT               VARCHAR(255)             not null,
TYPE                 VARCHAR(36)             null,
constraint PK_FORMAT primary key (FORMAT)
);

COMMENT ON COLUMN FORMAT.FORMAT IS 'The logical name of the format';
COMMENT ON COLUMN FORMAT.TYPE IS 'The type of the format (FILE, FORM or TABLE)';

/*==============================================================*/
/* Table : FILE_FORMAT                                          */
/*==============================================================*/
create table FILE_FORMAT (
FORMAT				VARCHAR(255)	not null,
FILE_EXTENSION		VARCHAR(36)		null,
FILE_TYPE			VARCHAR(36)		not null,
POSITION			INTEGER			not null,
LABEL				VARCHAR(255)	null,
DEFINITION			VARCHAR(255)	null,
constraint PK_FILE_FORMAT primary key (FORMAT)
);

COMMENT ON COLUMN FILE_FORMAT.FORMAT IS 'The logical name of the format';
COMMENT ON COLUMN FILE_FORMAT.FILE_EXTENSION IS 'The extension of the file (not used)';
COMMENT ON COLUMN FILE_FORMAT.FILE_TYPE IS 'The identifier of the type of file (used to identify the file during the upload process)';
COMMENT ON COLUMN FILE_FORMAT.POSITION IS 'The position of the file in the upload screen';
COMMENT ON COLUMN FILE_FORMAT.LABEL IS 'The label associed with the file in the upload screen';
COMMENT ON COLUMN FILE_FORMAT.DEFINITION IS 'The definition associed with the file';

/*==============================================================*/
/* Table : FORM_FORMAT                                          */
/*==============================================================*/
create table FORM_FORMAT (
FORMAT			VARCHAR(255)	not null,
LABEL			VARCHAR(60)		null,
DEFINITION		VARCHAR(255)	null,
POSITION		INTEGER			not null,
IS_OPENED		CHAR(1)			null,
constraint PK_FORM_FORMAT primary key (FORMAT)
);

COMMENT ON COLUMN FORM_FORMAT.FORMAT IS 'The logical name of the format';
COMMENT ON COLUMN FORM_FORMAT.LABEL IS 'The label of the form displayed in the query screen';
COMMENT ON COLUMN FORM_FORMAT.DEFINITION IS 'The definition of the form';
COMMENT ON COLUMN FORM_FORMAT.POSITION IS 'The position of the form in the query screen';
COMMENT ON COLUMN FORM_FORMAT.IS_OPENED IS 'Indicate if the form is displayed as opened by default';

/*==============================================================*/
/* Table : TABLE_FORMAT                                         */
/*==============================================================*/
create table TABLE_FORMAT (
FORMAT				VARCHAR(255)		not null,
TABLE_NAME			VARCHAR(278)	null,
SCHEMA_CODE			VARCHAR(36)		null,
PRIMARY_KEY			VARCHAR(255)	null,
LABEL				VARCHAR(100)	null,
DEFINITION			VARCHAR(255)	null,	
constraint PK_TABLE_FORMAT primary key (FORMAT)
);

COMMENT ON COLUMN TABLE_FORMAT.FORMAT IS 'The logical name of the format';
COMMENT ON COLUMN TABLE_FORMAT.TABLE_NAME IS 'The real name of the table';
COMMENT ON COLUMN TABLE_FORMAT.SCHEMA_CODE IS 'The code of the schema (not used)';
COMMENT ON COLUMN TABLE_FORMAT.PRIMARY_KEY IS 'The list of table fields used to identify one line of this table (separated by commas)';
COMMENT ON COLUMN TABLE_FORMAT.LABEL IS 'A label for the table (displayed on the detail panel)';
COMMENT ON COLUMN TABLE_FORMAT.DEFINITION IS 'The definition of the table';


/*==============================================================*/
/* Table : FIELD                                                */
/*==============================================================*/
create table FIELD (
DATA                 VARCHAR(277)             not null,
FORMAT               VARCHAR(255)             not null,
TYPE                 VARCHAR(36)             null,
constraint PK_FIELD primary key (DATA, FORMAT)
);

COMMENT ON COLUMN FIELD.DATA IS 'The logical name of the field';
COMMENT ON COLUMN FIELD.FORMAT IS 'The name of the format containing this field';
COMMENT ON COLUMN FIELD.TYPE IS 'The type of the field (FILE, FORM or TABLE)';

/*==============================================================*/
/* Table : FILE_FIELD                                           */
/*==============================================================*/
create table FILE_FIELD (
DATA                 VARCHAR(277)          not null,
FORMAT               VARCHAR(255)          not null,
IS_MANDATORY         CHAR(1)          	  null,
MASK                 VARCHAR(100)         null,
LABEL_CSV			 VARCHAR(60)		   not null,
constraint PK_FILE_FIELD primary key (DATA, FORMAT),
constraint file_field_format_label_csv_key UNIQUE (format, label_csv)
);

COMMENT ON COLUMN FILE_FIELD.DATA IS 'The logical name of the field';
COMMENT ON COLUMN FILE_FIELD.FORMAT IS 'The name of the file format containing this field';
COMMENT ON COLUMN FILE_FIELD.IS_MANDATORY IS 'Is the field mandatory?';
COMMENT ON COLUMN FILE_FIELD.MASK IS 'A mask used to validate the data';

/*==============================================================*/
/* Table : FORM_FIELD                                           */
/*==============================================================*/
create table FORM_FIELD (
DATA                 VARCHAR(277)          not null,
FORMAT               VARCHAR(255)          not null,
IS_CRITERIA          CHAR(1)              null,
IS_RESULT            CHAR(1)              null,
INPUT_TYPE           VARCHAR(128)         null,
POSITION             INT4                 null,
IS_DEFAULT_CRITERIA  CHAR(1)              null,
IS_DEFAULT_RESULT    CHAR(1)              null,
DEFAULT_VALUE        VARCHAR(255)         null,
DECIMALS       		 INT		          null,
MASK                 VARCHAR(100)         null,
constraint PK_FORM_FIELD primary key (DATA, FORMAT)
);

COMMENT ON COLUMN FORM_FIELD.DATA IS 'The logical name of the field';
COMMENT ON COLUMN FORM_FIELD.FORMAT IS 'The name of the form format containing this field';
COMMENT ON COLUMN FORM_FIELD.IS_CRITERIA IS 'Can this field be used as a criteria?';
COMMENT ON COLUMN FORM_FIELD.IS_RESULT IS 'Can this field be displayed as a result?';
COMMENT ON COLUMN FORM_FIELD.INPUT_TYPE IS 'The input type associed with this field (TEXT, DATE, GEOM, NUMERIC, SELECT, CHECKBOX, MULTIPLE, TREE)';
COMMENT ON COLUMN FORM_FIELD.POSITION IS 'The position of this field in the form';
COMMENT ON COLUMN FORM_FIELD.IS_DEFAULT_CRITERIA IS 'Is this field selected by default as a criteria?';
COMMENT ON COLUMN FORM_FIELD.IS_DEFAULT_RESULT IS 'Is this field selected by default as a result?';
COMMENT ON COLUMN FORM_FIELD.DEFAULT_VALUE IS 'The default value for the criteria (multiple values are separated by a semicolon)';
COMMENT ON COLUMN FORM_FIELD.DECIMALS IS 'The number of decimals to be displayed for numeric values';
COMMENT ON COLUMN FORM_FIELD.MASK IS 'A mask used to validate the data (the format for date values)';

/*==============================================================*/
/* Table : TABLE_FIELD                                          */
/*==============================================================*/
create table TABLE_FIELD (
DATA                 VARCHAR(277)          not null,
FORMAT               VARCHAR(255)          not null,
COLUMN_NAME          VARCHAR(277)          null,
IS_CALCULATED        CHAR(1)		      null,
IS_EDITABLE          CHAR(1)		      null,
IS_INSERTABLE        CHAR(1)		      null,
IS_MANDATORY         CHAR(1)		      null,
POSITION             INT4                 null,
COMMENT		         VARCHAR(255)         null,
constraint PK_TABLE_FIELD primary key (DATA, FORMAT)
);

COMMENT ON COLUMN TABLE_FIELD.DATA IS 'The logical name of the field';
COMMENT ON COLUMN TABLE_FIELD.FORMAT IS 'The name of the table format containing this field';
COMMENT ON COLUMN TABLE_FIELD.COLUMN_NAME IS 'The real name of the column';
COMMENT ON COLUMN TABLE_FIELD.IS_CALCULATED IS 'Indicate if the field should be provided for insertion (value = 0) or if it is calculated by a trigger function (value = 1)';
COMMENT ON COLUMN TABLE_FIELD.IS_EDITABLE IS 'Indicate if the field can be edited in the edition module (value = 1)';
COMMENT ON COLUMN TABLE_FIELD.IS_INSERTABLE IS 'Indicate if the field can be inserted/added in the edition module (value = 1)';
COMMENT ON COLUMN TABLE_FIELD.IS_MANDATORY IS 'Indicate if the field is mandatory in the edition module. PKs are always mandatory.';
COMMENT ON COLUMN TABLE_FIELD.POSITION IS 'The position of this field in the table (for the detail panel and the edition module)';
COMMENT ON COLUMN TABLE_FIELD.COMMENT IS 'Any comment';

/*==============================================================*/
/* Table : FIELD_MAPPING                                        */
/*==============================================================*/
create table FIELD_MAPPING (
SRC_DATA             VARCHAR(277)             not null,
SRC_FORMAT           VARCHAR(255)             not null,
DST_DATA             VARCHAR(277)             not null,
DST_FORMAT           VARCHAR(255)             not null,
MAPPING_TYPE         VARCHAR(36)             not null,
constraint PK_FIELD_MAPPING primary key (SRC_DATA, SRC_FORMAT, DST_DATA, DST_FORMAT)
);

COMMENT ON COLUMN FIELD_MAPPING.SRC_DATA IS 'The source data';
COMMENT ON COLUMN FIELD_MAPPING.SRC_FORMAT IS 'The source format';
COMMENT ON COLUMN FIELD_MAPPING.DST_DATA IS 'The destination data';
COMMENT ON COLUMN FIELD_MAPPING.DST_FORMAT IS 'The destination format';
COMMENT ON COLUMN FIELD_MAPPING.MAPPING_TYPE IS 'The type of mapping (FORM, FIELD)';


/*==============================================================*/
/* Table : DATASET                                              */
/*==============================================================*/
create table DATASET (
DATASET_ID           VARCHAR(23)          not null,
LABEL                VARCHAR(255)         null,
IS_DEFAULT           CHAR(1)              null,
DEFINITION           VARCHAR(512)         null,
TYPE                 VARCHAR(36)          null,
constraint PK_DATASET primary key (DATASET_ID)
);

COMMENT ON COLUMN DATASET.DATASET_ID IS 'The logical name of the dataset';
COMMENT ON COLUMN DATASET.LABEL IS 'The label of the dataset';
COMMENT ON COLUMN DATASET.IS_DEFAULT IS 'Indicate if the dataset is selected by default (only 1 possible)';
COMMENT ON COLUMN DATASET.DEFINITION IS 'The definition of the dataset (used in tooltips)';
COMMENT ON COLUMN DATASET.TYPE IS 'The type of the dataset (IMPORT, INPUT)';

/*==============================================================*/
/* Table : DATASET_FILES                                        */
/*==============================================================*/
create table DATASET_FILES (
DATASET_ID           VARCHAR(36)          not null,
FORMAT               VARCHAR(255)          not null,
constraint PK_DATASET_FILES primary key (DATASET_ID, FORMAT)
);

COMMENT ON COLUMN DATASET_FILES.DATASET_ID IS 'The logical name of the dataset';
COMMENT ON COLUMN DATASET_FILES.FORMAT IS 'The file format associed with the dataset (used when importing data)';

/*==============================================================*/
/* Table : DATASET_FORMS                                        */
/*==============================================================*/
create table DATASET_FORMS (
DATASET_ID           VARCHAR(36)          not null,
FORMAT               VARCHAR(255)          not null,
constraint PK_DATASET_FORMS primary key (DATASET_ID, FORMAT)
);

COMMENT ON COLUMN DATASET_FORMS.DATASET_ID IS 'The logical name of the dataset';
COMMENT ON COLUMN DATASET_FORMS.FORMAT IS 'The form format associed with the dataset (used when visualizing or requesting data)';


/*==============================================================*/
/* Table : DATASET_FIELDS                                       */
/*==============================================================*/
create table DATASET_FIELDS (
DATASET_ID           VARCHAR(36)          not null,
SCHEMA_CODE          VARCHAR(36)          not null,
FORMAT               VARCHAR(255)          not null,
DATA                 VARCHAR(277)          not null,
constraint PK_DATASET_FIELDS primary key (DATASET_ID, SCHEMA_CODE, FORMAT, DATA)
);

COMMENT ON COLUMN DATASET_FIELDS.DATASET_ID IS 'The logical name of the dataset';
COMMENT ON COLUMN DATASET_FIELDS.SCHEMA_CODE IS 'The code of the schema';
COMMENT ON COLUMN DATASET_FIELDS.FORMAT IS 'The table format associed with the dataset';
COMMENT ON COLUMN DATASET_FIELDS.DATA IS 'The table field associed with the dataset (used when querying data)';


/*==============================================================*/
/* Table : TABLE_SCHEMA                                         */
/*==============================================================*/
create table TABLE_SCHEMA (
SCHEMA_CODE          VARCHAR(36)             not null,
SCHEMA_NAME          VARCHAR(36)             not null,
LABEL                VARCHAR(36)             null,
DESCRIPTION          VARCHAR(255)            null,
constraint PK_TABLE_SCHEMA primary key (SCHEMA_CODE)
);

COMMENT ON COLUMN TABLE_SCHEMA.SCHEMA_CODE IS 'The code of the schema';
COMMENT ON COLUMN TABLE_SCHEMA.SCHEMA_CODE IS 'The name of the schema (name in the database)';
COMMENT ON COLUMN TABLE_SCHEMA.LABEL IS 'The label of the schema';
COMMENT ON COLUMN TABLE_SCHEMA.DESCRIPTION IS 'The description of the schema';


/*==============================================================*/
/* Table : TABLE_TREE                                           */
/*==============================================================*/
create table TABLE_TREE (
SCHEMA_CODE          VARCHAR(36)             not null,
CHILD_TABLE          VARCHAR(255)             not null,
PARENT_TABLE         VARCHAR(255)             not null,
JOIN_KEY             VARCHAR(255)            null,
COMMENT              VARCHAR(255)            null,
constraint PK_TABLE_TREE primary key (SCHEMA_CODE, CHILD_TABLE)
);

COMMENT ON COLUMN TABLE_TREE.SCHEMA_CODE IS 'The code of the schema';
COMMENT ON COLUMN TABLE_TREE.CHILD_TABLE IS 'The name of the child table (should correspond to a table format)';
COMMENT ON COLUMN TABLE_TREE.PARENT_TABLE IS 'The name of the parent table (should correspond to a table format, * when this is a root table)';
COMMENT ON COLUMN TABLE_TREE.JOIN_KEY IS 'The list of table fields used to make the join between the table (separated by commas)';
COMMENT ON COLUMN TABLE_TREE.COMMENT IS 'Any comment';




/*==============================================================*/
/* Table : CHECKS                                               */
/*==============================================================*/
create table CHECKS (
CHECK_ID             INT4                 not null,
STEP                 VARCHAR(50)          null,
NAME                 VARCHAR(50)          null,
LABEL                VARCHAR(60)          null,
DESCRIPTION          VARCHAR(500)         null,
STATEMENT            VARCHAR(4000)        null,
IMPORTANCE           VARCHAR(36)          null,
_CREATIONDT          timestamp without time zone DEFAULT now(),
constraint PK_CHECKS primary key (CHECK_ID)
);

COMMENT ON COLUMN CHECKS.CHECK_ID IS 'The identifier of the check';
COMMENT ON COLUMN CHECKS.STEP IS 'The step of the check (COMPLIANCE or CONFORMITY)';
COMMENT ON COLUMN CHECKS.NAME IS 'The name the check';
COMMENT ON COLUMN CHECKS.LABEL IS 'The label of the check';
COMMENT ON COLUMN CHECKS.DESCRIPTION IS 'The description the check';
COMMENT ON COLUMN CHECKS.STATEMENT IS 'The SQL statement corresponding to the check';
COMMENT ON COLUMN CHECKS.IMPORTANCE IS 'The importance of the check (WARNING or ERROR)';
COMMENT ON COLUMN CHECKS._CREATIONDT IS 'The creation date';


/*==============================================================*/
/* Table : CHECKS_PER_PROVIDER                                  */
/* A '*' provider code means that the check is always done      */
/*==============================================================*/
create table CHECKS_PER_PROVIDER (
CHECK_ID             INT4                 not null,
DATASET_ID           VARCHAR(36)          not null,
PROVIDER_ID          VARCHAR(36)          null,
constraint PK_CHECKS_PER_PROVIDER primary key (CHECK_ID, DATASET_ID, PROVIDER_ID)
);

COMMENT ON COLUMN CHECKS_PER_PROVIDER.CHECK_ID IS 'The identifier of the check';
COMMENT ON COLUMN CHECKS_PER_PROVIDER.DATASET_ID IS 'The identifier of the dataset';
COMMENT ON COLUMN CHECKS_PER_PROVIDER.PROVIDER_ID IS 'The identifier of the provider (* for all providers)';


/*==============================================================*/
/* Table : PROCESS                                              */
/*==============================================================*/
CREATE TABLE process
(
  process_id character varying(50) NOT NULL, -- The name/identifier of the post-processing treatment
  step character varying(50), -- The step of the process (INTEGRATION or HARMONIZATION)
  label character varying(60), -- The label of the process
  description character varying(500), -- The description the process
  "statement" character varying(4000), -- The SQL statement corresponding to the process
  _creationdt timestamp without time zone DEFAULT now(), -- The creation date
  CONSTRAINT pk_process PRIMARY KEY (process_id)
)
WITH (
  OIDS=FALSE
);


COMMENT ON COLUMN process.process_id IS 'The name/identifier of the post-processing treatment';
COMMENT ON COLUMN process.step IS 'The step of the process (INTEGRATION or HARMONIZATION)';
COMMENT ON COLUMN process.label IS 'The label of the process';
COMMENT ON COLUMN process.description IS 'The description the process';
COMMENT ON COLUMN process."statement" IS 'The SQL statement corresponding to the process';
COMMENT ON COLUMN process._creationdt IS 'The creation date';

/*==============================================================*/
/* Table : TRANSLATION                                          */
/*==============================================================*/
create table TRANSLATION (
TABLE_FORMAT            VARCHAR(256)             not null,
ROW_PK                  VARCHAR(255)            not null,
LANG                    VARCHAR(36)             not null,
LABEL                   VARCHAR(255)            null,
DEFINITION              VARCHAR(255)            null,
constraint PK_TRANSLATION primary key (TABLE_FORMAT, ROW_PK, LANG)
);

COMMENT ON COLUMN TRANSLATION.TABLE_FORMAT IS 'The table_format code';
COMMENT ON COLUMN TRANSLATION.ROW_PK IS 'The row pk in the primary_key order defined in the table_format (separated by commas)';
COMMENT ON COLUMN TRANSLATION.LANG IS 'The translation language';
COMMENT ON COLUMN TRANSLATION.LABEL IS 'The translated label';
COMMENT ON COLUMN TRANSLATION.DEFINITION IS 'The translated definition';

/*==============================================================*/
/* Table : VERSION                                              */
/*==============================================================*/
  
CREATE TABLE VERSION (
NUM_VERSION_METADATA VARCHAR(12)          not null,
DATE_MAJ		     timestamp with time zone DEFAULT now(),
ETAT				 VARCHAR(50)		  not null,
CONSTRAINT PK_VERSION PRIMARY KEY (NUM_VERSION_METADATA)
);

COMMENT ON TABLE VERSION IS 'Metadata table containing the history of last applied updates to metamodel schema.';
COMMENT ON COLUMN VERSION.NUM_VERSION_METADATA IS 'Numéro de version du métamodèle';
COMMENT ON COLUMN VERSION.DATE_MAJ IS 'Date de l''application de la mise à jour';
COMMENT ON COLUMN VERSION.ETAT IS 'Etat de la mise à jour :  INIT, SUCCESS, FAIL';

/*==============================================================*/
/* Table : MODEL                                               */
/*==============================================================*/
  
CREATE TABLE MODEL (
ID					 VARCHAR(19)			not null,
NAME			     VARCHAR(128)			not null,
DESCRIPTION		     VARCHAR(1024)			null,	
SCHEMA_CODE			 VARCHAR(36)			not null,
IS_REF				 BOOLEAN				null,
CONSTRAINT PK_MODEL PRIMARY KEY (ID)
);
COMMENT ON TABLE MODEL IS 'A data model represents a list of tables';
COMMENT ON COLUMN MODEL.ID IS 'The id of the model';
COMMENT ON COLUMN MODEL.NAME IS 'The name of the model';
COMMENT ON COLUMN MODEL.DESCRIPTION IS 'The description of the model';
COMMENT ON COLUMN MODEL.SCHEMA_CODE IS 'The schema code of the model';
COMMENT ON COLUMN MODEL.IS_REF IS 'Wether the model is a reference or standard model or not';


/*==============================================================*/
/* Table : MODEL_DATASETS                                      */
/*==============================================================*/
create table MODEL_DATASETS (
MODEL_ID		VARCHAR(19)		not null,
DATASET_ID		VARCHAR(36)		unique not null,
constraint PK_MODEL_DATASETS primary key (MODEL_ID, DATASET_ID)
);

COMMENT ON COLUMN MODEL_DATASETS.MODEL_ID IS 'The id of the model';
COMMENT ON COLUMN MODEL_DATASETS.DATASET_ID IS 'The id of the dataset';

/*==============================================================*/
/* Table : MODEL_TABLES                                        */
/*==============================================================*/
create table MODEL_TABLES (
MODEL_ID		VARCHAR(19)		not null,
TABLE_ID		VARCHAR(256)	unique not null,
constraint PK_MODEL_TABLES primary key (MODEL_ID, TABLE_ID)
);

COMMENT ON COLUMN MODEL_TABLES.MODEL_ID IS 'The id of the model';
COMMENT ON COLUMN MODEL_TABLES.TABLE_ID IS 'The id of the table';

/*==============================================================*/
/* Table : EVENT_LISTENER                                       */
/*==============================================================*/
CREATE TABLE event_listener
(
LISTENER_ID character varying(50) NOT NULL,
CLASSNAME character varying(255),
_CREATIONDT timestamp without time zone DEFAULT now(),
CONSTRAINT pk_event_listener PRIMARY KEY (listener_id)
);

COMMENT ON COLUMN event_listener.listener_id IS 'The name/identifier of the post-processing treatment';
COMMENT ON COLUMN event_listener.classname IS 'The fully qualified name of the listener (Ex : fr.ifn.ogam.integration.business.SimpleEventLogger)';
COMMENT ON COLUMN event_listener._creationdt IS 'The creation date';


/*==========================================================================*/
/*	Metamodel initialization - constraints.
	Used to create a new and clean 'metadata'
	or 'metadata_work' schema.
	All constraints are deferrable, meaning check constraint happens 
	only at end of transaction and if constraints are marked as deferred.	*/
/*==========================================================================*/

ALTER TABLE DATA ADD CONSTRAINT FK_DATA_ASSOCIATI_UNIT
	FOREIGN KEY (UNIT) REFERENCES UNIT (UNIT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE TRANSLATION ADD CONSTRAINT FK_TABLE_FORMAT_TRANSLATION
	FOREIGN KEY (TABLE_FORMAT) REFERENCES TABLE_FORMAT (FORMAT)
	ON UPDATE RESTRICT ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FIELD ADD CONSTRAINT FK_FIELD_ASSOCIATI_DATA
	FOREIGN KEY (DATA) REFERENCES DATA (DATA)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FIELD ADD CONSTRAINT FK_FIELD_ASSOCIATI_FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FIELD_MAPPING ADD CONSTRAINT FK_FIELD_MAPPING_FIELD_SRC
	FOREIGN KEY (SRC_DATA, SRC_FORMAT) REFERENCES FIELD (DATA, FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FIELD_MAPPING ADD CONSTRAINT FK_FIELD_MAPPING_FIELD_DST
	FOREIGN KEY (DST_DATA, DST_FORMAT) REFERENCES FIELD (DATA, FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FILE_FIELD ADD CONSTRAINT FK_FILE_FIE_HERITAGE__FIELD
	FOREIGN KEY (DATA, FORMAT) REFERENCES FIELD (DATA, FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FILE_FORMAT ADD CONSTRAINT FK_FILE_FOR_HERITAGE__FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FORM_FIELD ADD CONSTRAINT FK_FORM_FIE_HERITAGE__FIELD
	FOREIGN KEY (DATA, FORMAT) REFERENCES FIELD (DATA, FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE FORM_FORMAT ADD CONSTRAINT FK_FORM_FOR_HERITAGE__FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE TABLE_FIELD ADD CONSTRAINT FK_TABLE_FI_HERITAGE__FIELD
	FOREIGN KEY (DATA, FORMAT) REFERENCES FIELD (DATA, FORMAT)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE TABLE_FORMAT ADD CONSTRAINT FK_TABLE_FO_HERITAGE__FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE TABLE_FORMAT ADD CONSTRAINT FK_TABLE_FORMAT_SCHEMA_CODE
	FOREIGN KEY (SCHEMA_CODE) REFERENCES TABLE_SCHEMA (SCHEMA_CODE)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODE ADD CONSTRAINT FK_MODE_ASSOCIATI_UNIT
	FOREIGN KEY (UNIT) REFERENCES UNIT (UNIT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE GROUP_MODE ADD CONSTRAINT FK_GROUP_MODE_ASSOCIATI_SRC_MODE
	FOREIGN KEY (SRC_UNIT, SRC_CODE) REFERENCES MODE (UNIT, CODE)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE GROUP_MODE ADD CONSTRAINT FK_GROUP_MODE_ASSOCIATI_DST_MODE
	FOREIGN KEY (DST_UNIT, DST_CODE) REFERENCES MODE (UNIT, CODE)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE RANGE ADD CONSTRAINT FK_RANGE_ASSOCIATI_UNIT
	FOREIGN KEY (UNIT) REFERENCES UNIT (UNIT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;;

ALTER TABLE TABLE_TREE ADD CONSTRAINT FK_TABLE_TREE_SCHEMA
	FOREIGN KEY (SCHEMA_CODE) REFERENCES TABLE_SCHEMA (SCHEMA_CODE)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE TABLE_TREE ADD CONSTRAINT FK_TABLE_TREE_CHILD_TABLE
	FOREIGN KEY (CHILD_TABLE) REFERENCES TABLE_FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DATASET_FIELDS ADD CONSTRAINT FK_DATASET_FIELDS_DATASET
	FOREIGN KEY (DATASET_ID) REFERENCES DATASET (DATASET_ID)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DATASET_FIELDS ADD CONSTRAINT FK_DATASET_FIELDS_FIELD
	FOREIGN KEY (FORMAT, DATA) REFERENCES FIELD (FORMAT, DATA)
	ON DELETE RESTRICT ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DATASET_FILES ADD CONSTRAINT FK_DATASET_FILES_FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FILE_FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DATASET_FORMS ADD CONSTRAINT FK_DATASET_FORM_FORMAT
	FOREIGN KEY (FORMAT) REFERENCES FORM_FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODEL ADD CONSTRAINT FK_MODEL_SCHEMA_CODE
	FOREIGN KEY (SCHEMA_CODE) REFERENCES TABLE_SCHEMA (SCHEMA_CODE) 
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODEL_DATASETS ADD CONSTRAINT FK_MODEL_DATASETS_MODEL
	FOREIGN KEY (MODEL_ID) REFERENCES MODEL (ID)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODEL_DATASETS ADD CONSTRAINT FK_MODEL_DATASETS_DATASET
	FOREIGN KEY (DATASET_ID) REFERENCES DATASET (DATASET_ID)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODEL_TABLES ADD CONSTRAINT FK_MODEL_TABLES_MODEL
	FOREIGN KEY (MODEL_ID) REFERENCES MODEL (ID)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE MODEL_TABLES ADD CONSTRAINT FK_MODEL_TABLES_TABLE
	FOREIGN KEY (TABLE_ID) REFERENCES TABLE_FORMAT (FORMAT)
	ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED;
