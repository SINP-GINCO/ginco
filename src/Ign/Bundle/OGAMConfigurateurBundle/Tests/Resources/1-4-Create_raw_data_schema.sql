DROP SCHEMA IF EXISTS raw_data CASCADE;
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
