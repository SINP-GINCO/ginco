set search_path = website;

DROP TABLE predefined_request_group_asso;
DROP TABLE predefined_request_group;
DROP TABLE predefined_request_criteria;
DROP TABLE predefined_request_result;
DROP TABLE predefined_request;

/*==============================================================*/
/* Table : PREDEFINED_REQUEST                                   */
/*==============================================================*/
create table PREDEFINED_REQUEST (
REQUEST_NAME             VARCHAR(50)          not null,
SCHEMA_CODE          	 VARCHAR(36)          not null,
DATASET_ID               VARCHAR(36)          not null,
DEFINITION				 VARCHAR(500)         null,
LABEL 					 VARCHAR(50)	      null,
DATE 					 date,
constraint PK_PREDEFINED_REQUEST primary key (REQUEST_NAME)
);



/*alter table PREDEFINED_REQUEST*/
/*add constraint FK_PREDEFINED_REQUEST_DATASET foreign key (DATASET_ID)*/
/*      references METADATA.DATASET (DATASET_ID)*/
/*      on delete restrict on update restrict;*/

COMMENT ON COLUMN PREDEFINED_REQUEST.REQUEST_NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST.SCHEMA_CODE IS 'The schema used by this request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DATASET_ID IS 'The dataset used by this request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DEFINITION IS 'The description of the request';
COMMENT ON COLUMN PREDEFINED_REQUEST.LABEL IS 'The label of the request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DATE IS 'Date of creation of the request';



/*==============================================================*/
/* Table : PREDEFINED_REQUEST_CRITERIA                          */
/*==============================================================*/
create table PREDEFINED_REQUEST_CRITERIA (
REQUEST_NAME           VARCHAR(50)          not null,
FORMAT         		   VARCHAR(36)          not null,
DATA                   VARCHAR(36)          not null,
VALUE        		   VARCHAR(500)          not null,
FIXED 				   boolean,
constraint PK_PREDEFINED_REQUEST_CRITERIA primary key (REQUEST_NAME, FORMAT, DATA)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERIA.REQUEST_NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERIA.FORMAT IS 'The form format of the criteria';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERIA.DATA IS 'The form field of the criteria';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERIA.VALUE IS 'The field value (multiple values are separated by a semicolon)';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERIA.FIXED IS 'Indicate if the file is fixed or selectable';

ALTER TABLE ONLY predefined_request_criteria
    ADD CONSTRAINT fk_predefined_request_criteria_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(request_name) ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table : PREDEFINED_REQUEST_RESULT                  */
/*==============================================================*/
create table PREDEFINED_REQUEST_RESULT (
REQUEST_NAME           VARCHAR(50)          not null,
FORMAT         		   VARCHAR(36)          not null,
DATA                   VARCHAR(36)          not null,
constraint PK_PREDEFINED_REQUEST_RESULT primary key (REQUEST_NAME, FORMAT, DATA)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_RESULT.REQUEST_NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST_RESULT.FORMAT IS 'The form format of the result column';
COMMENT ON COLUMN PREDEFINED_REQUEST_RESULT.DATA IS 'The form field of the result column';

ALTER TABLE ONLY predefined_request_result
    ADD CONSTRAINT fk_predefined_request_result_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(request_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Sequence: website.predefined_request_group_position_seq

DROP SEQUENCE IF EXISTS website.predefined_request_group_position_seq;

CREATE SEQUENCE website.predefined_request_group_position_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE website.predefined_request_group_position_seq
  OWNER TO admin;


/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP                             */
/*==============================================================*/
CREATE TABLE PREDEFINED_REQUEST_GROUP (
GROUP_NAME 		VARCHAR(50) 	NOT NULL,
LABEL			VARCHAR(50),
DEFINITION  	VARCHAR(250),
POSITION		integer NOT NULL DEFAULT nextval('predefined_request_group_position_seq'::regclass),
constraint PK_PREDEFINED_REQUEST_GROUP primary key (GROUP_NAME)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.GROUP_NAME IS 'The name of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.LABEL IS 'The label of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.DEFINITION IS 'The definition of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.POSITION IS 'The position of the group';



/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP_ASSO                        */
/*==============================================================*/
CREATE TABLE PREDEFINED_REQUEST_GROUP_ASSO (
GROUP_NAME 		VARCHAR(50) 	NOT NULL,
REQUEST_NAME 	VARCHAR(50),
POSITION		smallint,
constraint PK_PREDEFINED_REQUEST_GROUP_ASSO primary key (GROUP_NAME, REQUEST_NAME)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.GROUP_NAME IS 'The name of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.REQUEST_NAME IS 'The label of the predefined request';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.POSITION IS 'The position of the request inside the group';


ALTER TABLE ONLY predefined_request_group_asso
    ADD CONSTRAINT fk_predefined_request_group_name 
    FOREIGN KEY (group_name) 
    REFERENCES predefined_request_group(group_name) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY predefined_request_group_asso
    ADD CONSTRAINT fk_predefined_request_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(request_name) ON UPDATE RESTRICT ON DELETE RESTRICT;


GRANT ALL ON SCHEMA website TO ogam WITH GRANT OPTION;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA website TO ogam;

