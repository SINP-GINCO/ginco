set search_path = website;

DROP TABLE IF EXISTS predefined_request_group_asso;
DROP TABLE IF EXISTS predefined_request_group;
DROP TABLE IF EXISTS predefined_request_criterion;
DROP TABLE IF EXISTS predefined_request_column;
DROP TABLE IF EXISTS predefined_request;

/*==============================================================*/
/* Table : PREDEFINED_REQUEST                                   */
/*==============================================================*/
create table website.predefined_request
(
  request_id serial NOT NULL, -- The request identifier
  dataset_id character varying(36) NOT NULL, -- The dataset used by this request
  schema_code character varying(36) NOT NULL, -- The schema used by this request
  user_login character varying(50), -- The user login of the creator of the request
  definition character varying(500), -- The description of the request
  label character varying(50) NOT NULL, -- The label of the request
  date date DEFAULT now(), -- Date of creation of the request
  is_public boolean NOT NULL DEFAULT false, -- True if the request is public
  CONSTRAINT pk_predefined_request PRIMARY KEY (request_id),
  CONSTRAINT fk_predefined_request_users FOREIGN KEY (user_login)
      REFERENCES website.users (user_login) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT uk_predefined_request UNIQUE (label, user_login, dataset_id, is_public)
);

COMMENT ON COLUMN website.predefined_request.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request.dataset_id IS 'The dataset used by this request';
COMMENT ON COLUMN website.predefined_request.schema_code IS 'The schema used by this request';
COMMENT ON COLUMN website.predefined_request.user_login IS 'The user login of the creator of the request';
COMMENT ON COLUMN website.predefined_request.definition IS 'The description of the request';
COMMENT ON COLUMN website.predefined_request.label IS 'The label of the request';
COMMENT ON COLUMN website.predefined_request.date IS 'Date of creation of the request';
COMMENT ON COLUMN website.predefined_request.is_public IS 'True if the request is public';

CREATE UNIQUE INDEX uk_predefined_request_2 ON website.predefined_request (label, dataset_id) WHERE is_public;

/*==============================================================*/
/* Table : PREDEFINED_REQUEST_CRITERION                         */
/*==============================================================*/
CREATE TABLE website.predefined_request_criterion
(
  request_id integer NOT NULL, -- The request identifier
  format character varying(36) NOT NULL, -- The form format of the criterion
  data character varying(36) NOT NULL, -- The form field of the criterion
  value text NOT NULL, -- The field value (multiple values are separated by a semicolon)
  CONSTRAINT pk_predefined_request_criterion PRIMARY KEY (request_id, format, data),
  CONSTRAINT fk_predefined_request_criterion_request_name FOREIGN KEY (request_id)
      REFERENCES website.predefined_request (request_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

COMMENT ON COLUMN website.predefined_request_criterion.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_criterion.format IS 'The form format of the criterion';
COMMENT ON COLUMN website.predefined_request_criterion.data IS 'The form field of the criterion';
COMMENT ON COLUMN website.predefined_request_criterion.value IS 'The field value (multiple values are separated by a semicolon)';

/*==============================================================*/
/* Table : PREDEFINED_REQUEST_COLUMN                  */
/*==============================================================*/
CREATE TABLE website.predefined_request_column
(
  request_id integer NOT NULL, -- The request identifier
  format character varying(36) NOT NULL, -- The form format of the column
  data character varying(36) NOT NULL, -- The form field of the column
  CONSTRAINT pk_predefined_request_column PRIMARY KEY (request_id, format, data),
  CONSTRAINT fk_predefined_request_column_request_name FOREIGN KEY (request_id)
      REFERENCES website.predefined_request (request_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

COMMENT ON COLUMN website.predefined_request_column.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_column.format IS 'The form format of the column';
COMMENT ON COLUMN website.predefined_request_column.data IS 'The form field of the column';


/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP                             */
/*==============================================================*/
CREATE TABLE website.predefined_request_group
(
  group_id serial NOT NULL, -- The group identifier
  label character varying(50) NOT NULL, -- The label of the group
  definition character varying(250), -- The definition of the group
  "position" smallint, -- The position of the group
  CONSTRAINT pk_predefined_request_group PRIMARY KEY (group_id)
);

COMMENT ON COLUMN website.predefined_request_group.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group.label IS 'The label of the group';
COMMENT ON COLUMN website.predefined_request_group.definition IS 'The definition of the group';
COMMENT ON COLUMN website.predefined_request_group."position" IS 'The position of the group';


/*==============================================================*/
/* Table : PREDEFINED_REQUEST_GROUP_ASSO                        */
/*==============================================================*/
CREATE TABLE website.predefined_request_group_asso
(
  group_id integer NOT NULL, -- The group identifier
  request_id integer NOT NULL, -- The request identifier
  "position" smallint, -- The position of the request inside the group
  CONSTRAINT pk_predefined_request_group_asso PRIMARY KEY (group_id, request_id),
  CONSTRAINT fk_predefined_request_group_name FOREIGN KEY (group_id)
      REFERENCES website.predefined_request_group (group_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_predefined_request_request_name FOREIGN KEY (request_id)
      REFERENCES website.predefined_request (request_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

COMMENT ON COLUMN website.predefined_request_group_asso.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group_asso.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_group_asso."position" IS 'The position of the request inside the group';
    

GRANT ALL ON SCHEMA website TO ogam WITH GRANT OPTION;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA website TO ogam;

