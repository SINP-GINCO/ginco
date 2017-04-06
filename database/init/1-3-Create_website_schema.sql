CREATE SCHEMA website;

SET SEARCH_PATH = website, public;

/*==============================================================*/
/* Table : APPLICATION_PARAMETERS                               */
/*==============================================================*/
create table APPLICATION_PARAMETERS (
NAME                 VARCHAR(50)          not null,
VALUE                VARCHAR(500)         null,
DESCRIPTION          VARCHAR(500)         null,
constraint PK_APPLICATION_PARAMETERS primary key (NAME)
);

COMMENT ON TABLE APPLICATION_PARAMETERS IS 'Table used to store parameters for the application';
COMMENT ON COLUMN APPLICATION_PARAMETERS.NAME IS 'Name of the parameter';
COMMENT ON COLUMN APPLICATION_PARAMETERS.VALUE IS 'Value of the parameter';
COMMENT ON COLUMN APPLICATION_PARAMETERS.DESCRIPTION IS 'Description of the parameter';

/*==============================================================*/
/* Table : users                                                */
/*==============================================================*/
create table USERS (
USER_LOGIN           VARCHAR(50)          null,
USER_PASSWORD        VARCHAR(50)          null,
USER_NAME            VARCHAR(50)          null,
PROVIDER_ID          VARCHAR(36)          null,
EMAIL                VARCHAR(250)         null,
ACTIVATION_CODE		   VARCHAR(50)          null,
constraint PK_USERS primary key (USER_LOGIN)
);

COMMENT ON TABLE USERS IS 'The users of the application';
COMMENT ON COLUMN USERS.USER_LOGIN IS 'The login of the user (unique identifier)';
COMMENT ON COLUMN USERS.USER_PASSWORD IS 'The password of the user';
COMMENT ON COLUMN USERS.USER_NAME IS 'The user name';
COMMENT ON COLUMN USERS.PROVIDER_ID IS 'The identifier of the provider (used to group users and manage dataset accessibility)';
COMMENT ON COLUMN USERS.EMAIL IS 'The user email address';
COMMENT ON COLUMN USERS.ACTIVATION_CODE IS 'The activation code for password reset';

/*==============================================================*/
/* Table : ROLE                                                 */
/*==============================================================*/
create table ROLE (
ROLE_CODE            VARCHAR(36)             	not null,
ROLE_LABEL           VARCHAR(100)             	null,
ROLE_DEFINITION      VARCHAR(255)         		null,
constraint PK_ROLE primary key (ROLE_CODE)
);

COMMENT ON TABLE ROLE IS 'A role in the application';
COMMENT ON COLUMN ROLE.ROLE_CODE IS 'Code of the role';
COMMENT ON COLUMN ROLE.ROLE_LABEL IS 'Label';
COMMENT ON COLUMN ROLE.ROLE_DEFINITION IS 'Definition of the role';

/*==============================================================*/
/* Table : ROLE_TO_SCHEMA                                       */
/*==============================================================*/
create table ROLE_TO_SCHEMA (
ROLE_CODE            VARCHAR(36)             	not null,
SCHEMA_CODE       	 VARCHAR(100)             	not null,
constraint PK_ROLE_TO_SCHEMA  primary key (ROLE_CODE, SCHEMA_CODE)
);

COMMENT ON TABLE ROLE_TO_SCHEMA IS 'A link a role to a list of accessible database schemas';
COMMENT ON COLUMN ROLE_TO_SCHEMA.ROLE_CODE IS 'Code of the role';
COMMENT ON COLUMN ROLE_TO_SCHEMA.SCHEMA_CODE IS 'Code of the schema (as defined in the metadata)';


/*==============================================================*/
/* Table : ROLE_TO_USER                                         */
/*==============================================================*/
create table ROLE_TO_USER (
USER_LOGIN              VARCHAR(50)                 not null,
ROLE_CODE              	VARCHAR(36)                 not null,
constraint PK_ROLE_TO_USER primary key (USER_LOGIN, ROLE_CODE)
);

COMMENT ON TABLE ROLE_TO_USER IS 'Link a user to a role';
COMMENT ON COLUMN ROLE_TO_USER.USER_LOGIN IS 'The user';
COMMENT ON COLUMN ROLE_TO_USER.ROLE_CODE IS 'The role';

/*==============================================================*/
/* Table : PERMISSION                                           */
/*==============================================================*/
create table PERMISSION (
PERMISSION_CODE      	VARCHAR(36)             not null,
PERMISSION_LABEL      	VARCHAR(255)             not null,
constraint PK_PERMISSION primary key (PERMISSION_CODE)
);

COMMENT ON TABLE PERMISSION IS 'Define a permission in the application';
COMMENT ON COLUMN PERMISSION.PERMISSION_CODE IS 'The code of the permission';
COMMENT ON COLUMN PERMISSION.PERMISSION_LABEL IS 'The label';


/*==============================================================*/
/* Table : PERMISSION_PER_ROLE                                  */
/*==============================================================*/
create table PERMISSION_PER_ROLE (
ROLE_CODE              	VARCHAR(36)                 not null,
PERMISSION_CODE      	VARCHAR(36)             not null,
constraint PK_PERMISSION_PER_ROLE primary key (ROLE_CODE, PERMISSION_CODE)
);

COMMENT ON TABLE PERMISSION_PER_ROLE IS 'Link a role to a list of permissions';
COMMENT ON COLUMN PERMISSION_PER_ROLE.ROLE_CODE IS 'The role';
COMMENT ON COLUMN PERMISSION_PER_ROLE.PERMISSION_CODE IS 'A permission';


/*==============================================================*/
/* Table : DATASET_ROLE_RESTRICTION                             */
/*==============================================================*/
create table DATASET_ROLE_RESTRICTION (
DATASET_ID           VARCHAR(36)          NOT NULL,
ROLE_CODE            VARCHAR(36)          NOT NULL,
constraint PK_DATASET_ROLE_RESTRICTION primary key (DATASET_ID, ROLE_CODE)
);

COMMENT ON COLUMN DATASET_ROLE_RESTRICTION.DATASET_ID IS 'The logical name of the dataset';
COMMENT ON COLUMN DATASET_ROLE_RESTRICTION.ROLE_CODE IS 'Code of the role';

ALTER TABLE dataset_role_restriction 
ADD CONSTRAINT fk_dataset_role_restriction_dataset_id 
FOREIGN KEY (dataset_id) REFERENCES metadata.dataset (dataset_id)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE dataset_role_restriction 
ADD CONSTRAINT fk_dataset_role_restriction_role_code 
FOREIGN KEY (role_code) REFERENCES website."role" (role_code)
ON UPDATE NO ACTION ON DELETE NO ACTION;


/*==============================================================*/
/* Table: layer_profile_restriction                             */
/* Mark some layers as forbidden for some user profiles         */
/*==============================================================*/
CREATE TABLE layer_role_restriction
(
  layer_name 			VARCHAR(50)    NOT NULL,   -- Logical name of the layer
  role_code				VARCHAR(36)    NOT NULL,   -- Role for whom this layer is forbidden
  PRIMARY KEY  (layer_name, role_code)
) WITHOUT OIDS;

COMMENT ON COLUMN layer_role_restriction.layer_name IS 'Logical name of the layer';
COMMENT ON COLUMN layer_role_restriction.role_code IS 'Role for whom this layer is forbidden';

ALTER TABLE layer_role_restriction 
ADD CONSTRAINT fk_layer_role_restriction_layer_name 
FOREIGN KEY (layer_name) REFERENCES mapping.layer(name)
ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE layer_role_restriction 
ADD CONSTRAINT fk_layer_role_restriction_role_code 
FOREIGN KEY (role_code) REFERENCES website."role" (role_code)
ON UPDATE NO ACTION ON DELETE NO ACTION;



alter table PERMISSION_PER_ROLE
   add constraint FK_PERMISSI_PERMISSIO_ROLE foreign key (ROLE_CODE)
      references ROLE (ROLE_CODE)
      on delete restrict on update restrict;

alter table PERMISSION_PER_ROLE
   add constraint FK_PERMISSI_PERMISSIO_PERMISSI foreign key (PERMISSION_CODE)
      references PERMISSION (PERMISSION_CODE)
      on delete restrict on update restrict;

alter table ROLE_TO_USER
   add constraint FK_ROLE_TO__ROLE_TO_U_USER foreign key (USER_LOGIN)
      references users (USER_LOGIN)
      on delete restrict on update restrict;

alter table ROLE_TO_USER
   add constraint FK_ROLE_TO__ROLE_TO_U_ROLE foreign key (ROLE_CODE)
      references ROLE (ROLE_CODE)
      on delete restrict on update restrict;

/*==============================================================*/
/* Table : PROVIDERS                                            */
/*==============================================================*/
CREATE SEQUENCE provider_id_seq;
CREATE TABLE providers (
id          character varying NOT NULL DEFAULT nextval('website.provider_id_seq'::text),
label       character varying,
definition  character varying,
CONSTRAINT pk_provider PRIMARY KEY (id)
);


/*==============================================================*/
/* Table : PREDEFINED_REQUEST                                   */
/*==============================================================*/
create table PREDEFINED_REQUEST (
NAME             VARCHAR(50)          not null,
SCHEMA_CODE          	 VARCHAR(36)          not null,
DATASET_ID               VARCHAR(36)          not null,
DEFINITION				 VARCHAR(500)         null,
LABEL 					 VARCHAR(50)	      null,
DATE 					 date				DEFAULT now(),
USER_LOGIN 				 VARCHAR(50),
constraint PK_PREDEFINED_REQUEST primary key (NAME)
);



alter table PREDEFINED_REQUEST
add constraint FK_PREDEFINED_REQUEST_DATASET foreign key (DATASET_ID)
      references METADATA.DATASET (DATASET_ID)
      on delete restrict on update restrict;

COMMENT ON COLUMN PREDEFINED_REQUEST.NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST.SCHEMA_CODE IS 'The schema used by this request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DATASET_ID IS 'The dataset used by this request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DEFINITION IS 'The description of the request';
COMMENT ON COLUMN PREDEFINED_REQUEST.LABEL IS 'The label of the request';
COMMENT ON COLUMN PREDEFINED_REQUEST.DATE IS 'Date of creation of the request';
COMMENT ON COLUMN PREDEFINED_REQUEST.USER_LOGIN IS 'The login of the user who created the request';



/*==============================================================*/
/* Table : PREDEFINED_REQUEST_CRITERION                         */
/*==============================================================*/
create table PREDEFINED_REQUEST_CRITERION (
REQUEST_NAME           VARCHAR(50)          not null,
FORMAT         		   VARCHAR(36)          not null,
DATA                   VARCHAR(36)          not null,
VALUE        		   VARCHAR(500)          not null,
FIXED 				   boolean,
constraint PK_PREDEFINED_REQUEST_CRITERION primary key (REQUEST_NAME, FORMAT, DATA)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERION.REQUEST_NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERION.FORMAT IS 'The form format of the criterion';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERION.DATA IS 'The form field of the criterion';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERION.VALUE IS 'The field value (multiple values are separated by a semicolon)';
COMMENT ON COLUMN PREDEFINED_REQUEST_CRITERION.FIXED IS 'Indicate if the file is fixed or selectable';

ALTER TABLE ONLY predefined_request_criterion
    ADD CONSTRAINT fk_predefined_request_criterion_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;

/*==============================================================*/
/* Table : PREDEFINED_REQUEST_COLUMN                 		    */
/*==============================================================*/
create table PREDEFINED_REQUEST_COLUMN (
REQUEST_NAME           VARCHAR(50)          not null,
FORMAT         		   VARCHAR(36)          not null,
DATA                   VARCHAR(36)          not null,
constraint PK_PREDEFINED_REQUEST_COLUMN primary key (REQUEST_NAME, FORMAT, DATA)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_COLUMN.REQUEST_NAME IS 'The request name';
COMMENT ON COLUMN PREDEFINED_REQUEST_COLUMN.FORMAT IS 'The form format of the column';
COMMENT ON COLUMN PREDEFINED_REQUEST_COLUMN.DATA IS 'The form field of the column';

ALTER TABLE ONLY predefined_request_column
    ADD CONSTRAINT fk_predefined_request_column_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Sequence: website.predefined_request_group_position_seq

/*DROP SEQUENCE IF EXISTS website.predefined_request_group_position_seq;

CREATE SEQUENCE website.predefined_request_group_position_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE website.predefined_request_group_position_seq
  OWNER TO admin;*/


/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP                             */
/*==============================================================*/
CREATE TABLE PREDEFINED_REQUEST_GROUP (
NAME 		VARCHAR(50) 	NOT NULL,
LABEL			VARCHAR(50),
DEFINITION  	VARCHAR(250),
/*POSITION		integer NOT NULL DEFAULT nextval('predefined_request_group_position_seq'::regclass),*/
POSITION		smallint,
constraint PK_PREDEFINED_REQUEST_GROUP primary key (NAME)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.NAME IS 'The name of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.LABEL IS 'The label of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.DEFINITION IS 'The definition of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP.POSITION IS 'The position of the group';



/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP_ASSO                        */
/*==============================================================*/
CREATE TABLE PREDEFINED_REQUEST_GROUP_ASSO (
GROUP_NAME 			VARCHAR(50) 	NOT NULL,
REQUEST_NAME 	VARCHAR(50),
POSITION		smallint,
constraint PK_PREDEFINED_REQUEST_GROUP_ASSO primary key (GROUP_NAME, REQUEST_NAME)
);

COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.GROUP_NAME IS 'The name of the group';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.REQUEST_NAME IS 'The label of the predefined request';
COMMENT ON COLUMN PREDEFINED_REQUEST_GROUP_ASSO.POSITION IS 'The position of the request inside the group';


ALTER TABLE ONLY predefined_request_group_asso
    ADD CONSTRAINT fk_predefined_request_group_name 
    FOREIGN KEY (GROUP_NAME) 
    REFERENCES predefined_request_group(name) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY predefined_request_group_asso
    ADD CONSTRAINT fk_predefined_request_request_name 
    FOREIGN KEY (request_name) 
    REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;


/*==============================================================*/
/* Table : JOB_QUEUE                                            */
/*==============================================================*/

-- Sequence: website.job_queue_id_seq

-- DROP SEQUENCE website.job_queue_id_seq;

CREATE SEQUENCE website.job_queue_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER TABLE website.job_queue_id_seq
  OWNER TO admin;


-- Table: website.jobs_queue

-- DROP TABLE website.jobs_queue;

CREATE TABLE website.job_queue
(
  id integer NOT NULL DEFAULT nextval('job_queue_id_seq'::regclass),
  type character varying(20),
  status character varying(10) NOT NULL DEFAULT 'PENDING'::character varying,
  length integer,
  progress integer,
  created_at timestamp without time zone DEFAULT now(),
  command character varying(1000) NOT NULL,
  pid integer,
  CONSTRAINT pk PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE website.job_queue
  OWNER TO admin;


GRANT ALL ON SCHEMA website TO ogam WITH GRANT OPTION;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA website TO ogam;

