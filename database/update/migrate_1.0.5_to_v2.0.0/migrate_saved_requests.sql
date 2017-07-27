---- Rename old tables

ALTER TABLE predefined_request RENAME TO old_predefined_request;
ALTER TABLE predefined_request_criteria RENAME TO old_predefined_request_criteria;
ALTER TABLE predefined_request_group RENAME TO old_predefined_request_group;
ALTER TABLE predefined_request_group_asso RENAME TO old_predefined_request_group_asso;
ALTER TABLE predefined_request_result RENAME TO old_predefined_request_result;

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
  is_public boolean NOT NULL DEFAULT false -- True if the request is public
);
COMMENT ON COLUMN website.predefined_request.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request.dataset_id IS 'The dataset used by this request';
COMMENT ON COLUMN website.predefined_request.schema_code IS 'The schema used by this request';
COMMENT ON COLUMN website.predefined_request.user_login IS 'The user login of the creator of the request';
COMMENT ON COLUMN website.predefined_request.definition IS 'The description of the request';
COMMENT ON COLUMN website.predefined_request.label IS 'The label of the request';
COMMENT ON COLUMN website.predefined_request.date IS 'Date of creation of the request';
COMMENT ON COLUMN website.predefined_request.is_public IS 'True if the request is public';

/*==============================================================*/
/* Table : PREDEFINED_REQUEST_CRITERION                         */
/*==============================================================*/
CREATE TABLE website.predefined_request_criterion
(
  request_id integer NOT NULL, -- The request identifier
  format character varying(36) NOT NULL, -- The form format of the criterion
  data character varying(36) NOT NULL, -- The form field of the criterion
  value text NOT NULL -- The field value (multiple values are separated by a semicolon)
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
  data character varying(36) NOT NULL -- The form field of the column
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
  group_name character varying(50) NOT NULL,
  label character varying(50) NOT NULL, -- The label of the group
  definition character varying(250), -- The definition of the group
  "position" smallint -- The position of the group
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
  group_name character varying(50) NOT NULL,
  request_id integer NOT NULL, -- The request identifier
  "position" smallint -- The position of the request inside the group
);

COMMENT ON COLUMN website.predefined_request_group_asso.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group_asso.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_group_asso."position" IS 'The position of the request inside the group';

GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_criterion TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group_asso TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_column TO ogam;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;

------ End of table creation schemas ------------

------ Data migration --------------


INSERT INTO predefined_request (request_id, schema_code, dataset_id, definition, label, date, user_login, is_public)
  SELECT id, schema_code, dataset_id, definition, label, date, user_login, TRUE
  FROM old_predefined_request;

UPDATE predefined_request
SET is_public = FALSE
WHERE user_login IS NOT NULL;

INSERT INTO predefined_request_criterion (request_id, format, data, value)
  SELECT id_predefined_request, format, data, value
  FROM old_predefined_request_criteria;

INSERT INTO predefined_request_column (request_id, format, data)
  SELECT id_predefined_request, format, data
  FROM old_predefined_request_result;

-- group_id is filled by its sequence
INSERT INTO predefined_request_group (group_name, label, definition, "position")
  SELECT group_name, label, definition, "position"
  FROM old_predefined_request_group;

INSERT INTO predefined_request_group_asso (group_id, group_name, request_id, "position")
  SELECT 1, group_name, id_predefined_request , "position"
  FROM old_predefined_request_group_asso;

-- Adjust group_id
UPDATE predefined_request_group_asso
SET group_id = predefined_request_group.group_id
FROM predefined_request_group
WHERE predefined_request_group.group_name = predefined_request_group_asso.group_name ;


ALTER TABLE predefined_request_group_asso DROP COLUMN group_name;
ALTER TABLE predefined_request_group DROP COLUMN group_name;

------ End of data migration --------------

---- Drop old tables

DROP TABLE old_predefined_request CASCADE;
DROP TABLE old_predefined_request_criteria CASCADE;
DROP TABLE old_predefined_request_group CASCADE;
DROP TABLE old_predefined_request_group_asso CASCADE;
DROP TABLE old_predefined_request_result CASCADE;


---- Constraints and indexes
ALTER TABLE predefined_request ADD CONSTRAINT pk_predefined_request PRIMARY KEY (request_id);
ALTER TABLE predefined_request ADD CONSTRAINT fk_predefined_request_users FOREIGN KEY (user_login)
REFERENCES website.users (user_login) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE predefined_request ADD CONSTRAINT uk_predefined_request UNIQUE (label, user_login, dataset_id, is_public);

CREATE UNIQUE INDEX uk_predefined_request_2 ON website.predefined_request (label, dataset_id) WHERE is_public;


ALTER TABLE predefined_request_criterion ADD CONSTRAINT pk_predefined_request_criterion PRIMARY KEY (request_id, format, data);
ALTER TABLE predefined_request_criterion ADD CONSTRAINT fk_predefined_request_criterion_request_name FOREIGN KEY (request_id)
REFERENCES website.predefined_request (request_id) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE CASCADE;


ALTER TABLE predefined_request_column ADD CONSTRAINT pk_predefined_request_column PRIMARY KEY (request_id, format, data);
ALTER TABLE predefined_request_column ADD   CONSTRAINT fk_predefined_request_column_request_name FOREIGN KEY (request_id)
REFERENCES website.predefined_request (request_id) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE predefined_request_group ADD CONSTRAINT pk_predefined_request_group PRIMARY KEY (group_id);


ALTER TABLE predefined_request_group_asso ADD   CONSTRAINT pk_predefined_request_group_asso PRIMARY KEY (group_id, request_id);
ALTER TABLE predefined_request_group_asso ADD CONSTRAINT fk_predefined_request_group_name FOREIGN KEY (group_id)
REFERENCES website.predefined_request_group (group_id) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE predefined_request_group_asso ADD CONSTRAINT fk_predefined_request_request_name FOREIGN KEY (request_id)
REFERENCES website.predefined_request (request_id) MATCH SIMPLE
ON UPDATE RESTRICT ON DELETE CASCADE;

-- DELETE unused groups
DELETE FROM predefined_request_group WHERE label='Recherches sauvegardées publiques';
DELETE FROM predefined_request_group WHERE label='Recherches sauvegardées privées';