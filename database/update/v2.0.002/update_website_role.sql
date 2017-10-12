set search_path = website;
---- Rename old tables

ALTER TABLE role RENAME TO old_role;
ALTER TABLE role_to_schema RENAME TO old_role_to_schema;
ALTER TABLE role_to_user RENAME TO old_role_to_user;
ALTER TABLE permission_per_role RENAME TO old_permission_per_role;
ALTER TABLE dataset_role_restriction RENAME TO old_dataset_role_restriction;


ALTER TABLE old_role_to_schema DROP CONSTRAINT PK_ROLE_TO_SCHEMA CASCADE;
ALTER TABLE old_role_to_user DROP CONSTRAINT PK_ROLE_TO_USER CASCADE;
ALTER TABLE old_permission_per_role DROP CONSTRAINT PK_PERMISSION_PER_ROLE CASCADE;
ALTER TABLE old_dataset_role_restriction DROP CONSTRAINT PK_DATASET_ROLE_RESTRICTION CASCADE;

/*==============================================================*/
/* Table : ROLE                                                 */
/*==============================================================*/
create table ROLE (
ROLE_CODE            SERIAL PRIMARY KEY,
ROLE_LABEL           VARCHAR(100)             	UNIQUE NOT NULL,
ROLE_DEFINITION      VARCHAR(255)         		null
);

COMMENT ON TABLE ROLE IS 'A role in the application';
COMMENT ON COLUMN ROLE.ROLE_CODE IS 'Code of the role';
COMMENT ON COLUMN ROLE.ROLE_LABEL IS 'Label';
COMMENT ON COLUMN ROLE.ROLE_DEFINITION IS 'Definition of the role';

/*==============================================================*/
/* Table : ROLE_TO_SCHEMA                                       */
/*==============================================================*/
create table ROLE_TO_SCHEMA (
ROLE_CODE            INTEGER					not null,
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
ROLE_CODE              	INTEGER                		not null,
constraint PK_ROLE_TO_USER primary key (USER_LOGIN, ROLE_CODE)
);

COMMENT ON TABLE ROLE_TO_USER IS 'Link a user to a role';
COMMENT ON COLUMN ROLE_TO_USER.USER_LOGIN IS 'The user';
COMMENT ON COLUMN ROLE_TO_USER.ROLE_CODE IS 'The role';

/*==============================================================*/
/* Table : PERMISSION_PER_ROLE                                  */
/*==============================================================*/
create table PERMISSION_PER_ROLE (
ROLE_CODE              	INTEGER               	not null,
PERMISSION_CODE      	VARCHAR(36)           	not null,
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
ROLE_CODE            INTEGER          	  NOT NULL,
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

------ Data migration --------------


INSERT INTO role (role_label, role_definition)
  SELECT role_label, role_definition
  FROM old_role;


INSERT INTO role_to_schema(role_code,schema_code)
  SELECT  r.role_code, ors.schema_code
  FROM old_role_to_schema ors, role r,old_role oldr
  WHERE ors.role_code = oldr.role_code 
  AND oldr.role_label = r.role_label;

INSERT INTO role_to_user(user_login,role_code)
  SELECT u.user_login,r.role_code
   FROM role r, old_role_to_user u,old_role oldr
   WHERE u.role_code = oldr.role_code
   AND oldr.role_label = r.role_label;
   
INSERT INTO permission_per_role(role_code,permission_code)
SELECT r.role_code, ppr.permission_code
   FROM role r, old_permission_per_role ppr, old_role oldr
   WHERE ppr.role_code = oldr.role_code
   AND oldr.role_label = r.role_label;
   
INSERT INTO dataset_role_restriction(dataset_id,role_code)
 SELECT odrr.dataset_id, r.role_code
   FROM role r, old_dataset_role_restriction odrr, old_role oldr
   WHERE odrr.role_code = oldr.role_code
   AND oldr.role_label = r.role_label;

-- Add user rights on tables
GRANT ALL ON SCHEMA website TO ogam WITH GRANT OPTION;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA website TO ogam;

------ End of data migration --------------

---- Drop old tables

DROP TABLE old_role CASCADE;
DROP TABLE old_role_to_schema CASCADE;
DROP TABLE old_role_to_user CASCADE;
DROP TABLE old_dataset_role_restriction CASCADE;
DROP TABLE old_permission_per_role CASCADE;

