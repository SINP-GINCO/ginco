CREATE SCHEMA raw_data;

SET SEARCH_PATH = raw_data, public;

--
-- WARNING: The DATASET_ID, PROVIDER_ID columns are used by the system and should keep their names.
--

DROP TABLE IF EXISTS SUBMISSION_FILE CASCADE;
DROP TABLE IF EXISTS SUBMISSION CASCADE;
DROP SEQUENCE IF EXISTS submission_id_seq;
DROP TABLE IF EXISTS CHECK_ERROR CASCADE;


/*==============================================================*/
/* Sequence : SUBMISSION_ID                                     */
/*==============================================================*/

CREATE SEQUENCE submission_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;


/*==============================================================*/
/* Table : SUBMISSION                                           */
/*==============================================================*/
create table IF NOT EXISTS SUBMISSION (
SUBMISSION_ID        INT4                 not null default nextval('submission_id_seq'),
STEP		 		 VARCHAR(36)          null,
STATUS    			 VARCHAR(36)          null,
PROVIDER_ID          VARCHAR(36)          not null,
DATASET_ID           VARCHAR(36)          not null,
USER_LOGIN           VARCHAR(50)          not null,
_CREATIONDT          DATE                 null DEFAULT current_timestamp,
_VALIDATIONDT        DATE                 null DEFAULT current_timestamp,
constraint PK_SUBMISSION primary key (SUBMISSION_ID)
);


COMMENT ON COLUMN SUBMISSION.SUBMISSION_ID IS 'The identifier of the submission';
COMMENT ON COLUMN SUBMISSION.STEP IS 'The submission step (INIT, INSERT, CHECK, VALIDATE, CANCEL)';
COMMENT ON COLUMN SUBMISSION.STATUS IS 'The submission status (OK, WARNING, ERROR, CRASH)';
COMMENT ON COLUMN SUBMISSION.PROVIDER_ID IS 'The data provider identifier (country code or organisation name)';
COMMENT ON COLUMN SUBMISSION.DATASET_ID IS 'The dataset identifier';
COMMENT ON COLUMN SUBMISSION.USER_LOGIN IS 'The login of the user doing the submission';
COMMENT ON COLUMN SUBMISSION._CREATIONDT IS 'The date of submission';
COMMENT ON COLUMN SUBMISSION._VALIDATIONDT IS 'The date of validation';



/*==============================================================*/
/* Table : SUBMISSION_FILE                                      */
/*==============================================================*/
create table SUBMISSION_FILE (
SUBMISSION_ID        INT4                 not null,
FILE_TYPE            VARCHAR(36)          not null,
FILE_NAME            VARCHAR(4000)         not null,
NB_LINE              INT4                 null,
constraint PK_SUBMISSION_FILE primary key (SUBMISSION_ID, FILE_TYPE)
);

COMMENT ON COLUMN SUBMISSION_FILE.SUBMISSION_ID IS 'The identifier of the submission';
COMMENT ON COLUMN SUBMISSION_FILE.FILE_TYPE IS 'The type of file (reference a DATASET_FILES.FORMAT)';
COMMENT ON COLUMN SUBMISSION_FILE.FILE_NAME IS 'The name of the file';
COMMENT ON COLUMN SUBMISSION_FILE.NB_LINE IS 'The number of lines of data in the file (excluding comment and empty lines)';


/*==============================================================*/
/* Table : CHECK_ERROR                                          */
/*==============================================================*/
create  table CHECK_ERROR (
CHECK_ERROR_ID       serial               not null,
CHECK_ID             INT4                 not null,
SUBMISSION_ID        INT4                 not null,
LINE_NUMBER          INT4                 not null,
SRC_FORMAT           VARCHAR(36)          null,
SRC_DATA             VARCHAR(36)          null,
PROVIDER_ID          VARCHAR(36)          null,
PLOT_CODE            VARCHAR(36)          null,
FOUND_VALUE          VARCHAR(255)         null,
EXPECTED_VALUE       VARCHAR(255)         null,
ERROR_MESSAGE        VARCHAR(4000)        null,
_CREATIONDT          DATE                 null  DEFAULT current_timestamp,
constraint PK_CHECK_ERROR primary key (CHECK_ID, SUBMISSION_ID, CHECK_ERROR_ID)
);

COMMENT ON COLUMN CHECK_ERROR.CHECK_ERROR_ID IS 'The identifier of the error (autoincrement)';
COMMENT ON COLUMN CHECK_ERROR.CHECK_ID IS 'The identifier of the check';
COMMENT ON COLUMN CHECK_ERROR.SUBMISSION_ID IS 'The identifier of the submission checked';
COMMENT ON COLUMN CHECK_ERROR.LINE_NUMBER IS 'The line number of the data in the original CSV file';
COMMENT ON COLUMN CHECK_ERROR.SRC_FORMAT IS 'The logical name the data source (CSV file or table name)';
COMMENT ON COLUMN CHECK_ERROR.SRC_DATA IS 'The logical name of the data (column)';
COMMENT ON COLUMN CHECK_ERROR.PROVIDER_ID IS 'The identifier of the data provider';
COMMENT ON COLUMN CHECK_ERROR.PLOT_CODE IS 'The identifier of the plot';
COMMENT ON COLUMN CHECK_ERROR.FOUND_VALUE IS 'The erroreous value (if available)';
COMMENT ON COLUMN CHECK_ERROR.EXPECTED_VALUE IS 'The expected value (if available)';
COMMENT ON COLUMN CHECK_ERROR.ERROR_MESSAGE IS 'The error message';
COMMENT ON COLUMN CHECK_ERROR._CREATIONDT IS 'The creation date';


GRANT ALL ON SCHEMA raw_data TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA raw_data TO ogam;
GRANT ALL ON TABLE raw_data.check_error_check_error_id_seq TO ogam;
GRANT ALL ON TABLE raw_data.submission_id_seq TO ogam;
GRANT SELECT, INSERT ON TABLE raw_data.check_error TO ogam;
GRANT ALL ON TABLE raw_data.submission TO ogam;
GRANT ALL ON TABLE raw_data.submission_file TO ogam;



-------------------------------------------------------------------------------
-- First sensitive trigger : in insert case (automatic sensitivity calculation)
-------------------------------------------------------------------------------
-- Function: raw_data.sensitive_automatic()
-- Sensitivity computation must be done after administrative linking.
-- Administrative linking is done after data integration with updates.
-- This trigger is then fired on updates and not inserts.
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION raw_data.sensitive_automatic()
  RETURNS trigger AS
$BODY$

	DECLARE
		rule_codage integer;
		rule_autre character varying(500);
		rule_full_citation character varying(500);
		rule_cd_doc integer;
	BEGIN

	-- As users can update data with the editor, first check that there is realy something to do.
	-- If none of the fields used for sensitivity computation have been modified we leave.
	If (NEW.codedepartementcalcule = OLD.codedepartementcalcule 
		AND NEW.cdnom = OLD.cdnom 
		AND NEW.cdref = OLD.cdref 
		AND NEW.jourdatefin = OLD.jourdatefin 
		AND NEW.occstatutbiologique = OLD.occstatutbiologique) Then
		RETURN NEW;
	End if;

	-- update dEEDateDerniereModification
	-- see #747 for discussion about when to update this date.
	NEW.deedatedernieremodification = now();

	-- We get the referential applied for the data departement
	SELECT especesensiblelistes.full_citation, especesensiblelistes.cd_doc INTO rule_full_citation, rule_cd_doc
	FROM referentiels.especesensible
	LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
	WHERE especesensible.cd_dept = ANY (NEW.codedepartementcalcule)
	LIMIT 1;
	
	-- by default a data is not sensitive
	NEW.sensible = '0';
	NEW.sensiniveau = '0';
	NEW.sensidateattribution = now();
	NEW.sensireferentiel = rule_full_citation;
	NEW.sensiversionreferentiel = rule_cd_doc;
	NEW.sensimanuelle = '0';
	NEW.sensialerte = '0';
		
	-- Does the data deals with sensitive taxon for the departement and is under the sensitive duration ?
	SELECT especesensible.codage, especesensible.autre INTO rule_codage, rule_autre
	FROM referentiels.especesensible
	LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
	WHERE 
		(CD_NOM = NEW.cdNom
		OR CD_NOM = NEW.cdRef
		OR CD_NOM = ANY (
			WITH RECURSIVE node_list( code, parent_code, lb_name, vernacular_name) AS (
				SELECT code, parent_code, lb_name, vernacular_name
				FROM metadata.mode_taxref
				WHERE code = NEW.cdnom
		
				UNION ALL
		
				SELECT parent.code, parent.parent_code, parent.lb_name, parent.vernacular_name
				FROM node_list, metadata.mode_taxref parent
				WHERE node_list.parent_code = parent.code
				AND node_list.parent_code != '349525'
				)
			SELECT parent_code
			FROM node_list
			ORDER BY code
			)
		)
		AND CD_DEPT = ANY (NEW.codedepartementcalcule)
		AND (DUREE IS NULL OR (NEW.jourdatefin::date + DUREE * '1 year'::INTERVAL > now()))
		AND (NEW.occstatutbiologique IN (NULL, '0', '1', '2') OR cd_occ_statut_biologique IS NULL OR NEW.occstatutbiologique = CAST(cd_occ_statut_biologique AS text))
	
	--  Quand on a plusieurs règles applicables il faut choisir en priorité
	--  Les règles avec le codage le plus fort
	--  Parmis elles, la règle sans commentaire (rule_autre is null)
	--  Voir #579
	ORDER BY codage DESC, autre DESC
	--  on prend la première règle, maintenant qu'elles ont été ordonnées
	LIMIT 1;
		
		
	-- No rules found, the obs is not sensitive
	IF NOT FOUND THEN
		RETURN NEW;
	End if;
		
	-- A rule has been found, the obs is sensitive
	NEW.sensible = '1';
	NEW.sensiniveau = rule_codage;
		
	-- If there is a comment, sensitivity must be defined manually
	If (rule_autre IS NOT NULL) Then
		NEW.sensialerte = '1';
	End if ;
			
	RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_automatic()
  OWNER TO admin;

GRANT SELECT on table referentiels.taxref to ogam; --FIXME: why here?

-------------------------------------------------------------------------------
-- Second sensitive trigger : in update case (manual sensitivity)
-------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS raw_data.sensitive_manual();
CREATE OR REPLACE FUNCTION raw_data.sensitive_manual()
  RETURNS trigger AS
$BODY$

  BEGIN
	  
	  -- sensitivity is has been changed manually if sensiniveau or sensimanuelle change
	  -- else the modifications do not concern sensitivity
	  IF (NEW.sensiniveau = OLD.sensiniveau AND NEW.sensimanuelle = OLD.sensimanuelle) Then
			RETURN NEW;
	  END IF;
	  
		NEW.sensidateattribution = now();
		NEW.sensimanuelle = '1';
		NEW.sensialerte = '0';

		--update dEEDateDerniereModification
		NEW.deedatedernieremodification = now();
		
		RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_manual()
  OWNER TO admin;
  
-------------------------------------------------------------------------------
-- Init trigger : Initialise update calculated fields
-------------------------------------------------------------------------------
  
DROP FUNCTION IF EXISTS raw_data.init_trigger();
CREATE OR REPLACE FUNCTION raw_data.init_trigger()
  RETURNS trigger AS
$BODY$

  BEGIN
	  	NEW.sensible = '0';
		NEW.sensiniveau = '0';
		NEW.deedatedernieremodification = now();
			
		RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.init_trigger()
  OWNER TO admin;


-------------------------------------------------------------------------------
-- Table: raw_data.export_file
-------------------------------------------------------------------------------

-- DROP TABLE raw_data.export_file;

CREATE TABLE raw_data.export_file
(
	id SERIAL,
	job_id integer,
	user_login character varying(50),
	file_name character varying(500),
	created_at timestamp without time zone DEFAULT now(),
	CONSTRAINT PK_EXPORT_FILE PRIMARY KEY (id),
	CONSTRAINT fk_job_id FOREIGN KEY (job_id)
	REFERENCES website.job_queue (id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_user_login FOREIGN KEY (user_login)
	REFERENCES website.users (user_login) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE SET NULL
)
WITH (
OIDS=FALSE
);
ALTER TABLE raw_data.export_file
	OWNER TO admin;
GRANT ALL ON TABLE raw_data.export_file TO admin;
GRANT ALL ON TABLE raw_data.export_file TO ogam;

-------------------------------------------------------------------------------
-- Table: raw_data.jdd
-------------------------------------------------------------------------------

-- DROP TABLE raw_data.jdd;

CREATE TABLE jdd
(
	id serial,
	jdd_metadata_id character varying(36),
	title character varying(512),
	status character varying(16) NOT NULL,
	model_id character varying(19) NOT NULL,
	created_at timestamp without time zone DEFAULT now(),
	dsr_updated_at timestamp without time zone DEFAULT now(),
	submission_id int4,
	export_file_id integer,
	CONSTRAINT pk_jdd_id PRIMARY KEY (id),
	CONSTRAINT fk_model_id FOREIGN KEY (model_id)
	REFERENCES metadata.model (id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_submission_id FOREIGN KEY (submission_id)
	REFERENCES raw_data.submission (submission_id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_export_file_id FOREIGN KEY (export_file_id)
	REFERENCES raw_data.export_file (id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE SET NULL
)
WITH (
OIDS=FALSE
);

COMMENT ON COLUMN jdd.id IS 'Technical id of the jdd';
COMMENT ON COLUMN jdd.jdd_metadata_id IS 'Id of the jdd metadata sheet';
COMMENT ON COLUMN jdd.title IS 'Title of the jdd, from the metadata';
COMMENT ON COLUMN jdd.status IS 'jdd status, can be ''empty'' (jdd created and active, no DSR nor DEE), ''active'' (at least the DSR or the DEE is created), ''deleted'' (deleted, but the row is kept)';
COMMENT ON COLUMN jdd.model_id IS 'Id of the data model in which the jdd is delivered';
COMMENT ON COLUMN jdd.created_at IS 'jdd creation timestamp (delivery timestamp is in submission._creationdt)';
COMMENT ON COLUMN jdd.dsr_updated_at IS 'DSR last edition timestamp';
COMMENT ON COLUMN jdd.submission_id IS 'The id of the submission which can be null (foreign key)';
COMMENT ON COLUMN jdd.export_file_id IS 'The id of the export file of the jdd (foreign key)';

ALTER TABLE raw_data.jdd
	OWNER TO admin;
GRANT ALL ON TABLE raw_data.jdd TO admin;
GRANT ALL ON TABLE raw_data.jdd TO ogam;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO admin;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO ogam;
