--------------------------------------------------------------
--------------------------------------------------------------
--                                                          --
--     Modifications pour l'enregistrement des requêtes     --
--                                                          --
--------------------------------------------------------------
--------------------------------------------------------------

-----------------------------------------------------
--                                                 --
--     Renommage des tables et des contraintes     --
--                                                 --
-----------------------------------------------------

ALTER TABLE website.predefined_request RENAME TO predefined_request_old;
ALTER TABLE website.predefined_request_group_asso RENAME TO predefined_request_group_asso_old;
ALTER TABLE website.predefined_request_group RENAME TO predefined_request_group_old;
ALTER TABLE website.predefined_request_column RENAME TO predefined_request_column_old;
ALTER TABLE website.predefined_request_criterion RENAME TO predefined_request_criterion_old;

ALTER TABLE website.predefined_request_old RENAME CONSTRAINT pk_predefined_request TO pk_predefined_request_old;
ALTER TABLE website.predefined_request_old RENAME CONSTRAINT fk_predefined_request_dataset TO fk_predefined_request_dataset_old;
ALTER TABLE website.predefined_request_group_old RENAME CONSTRAINT pk_predefined_request_group TO pk_predefined_request_group_old;
ALTER TABLE website.predefined_request_group_asso_old RENAME CONSTRAINT pk_predefined_request_group_asso TO pk_predefined_request_group_asso_old;
ALTER TABLE website.predefined_request_group_asso_old RENAME CONSTRAINT fk_predefined_request_group_name TO fk_predefined_request_group_name_old;
ALTER TABLE website.predefined_request_group_asso_old RENAME CONSTRAINT fk_predefined_request_request_name TO fk_predefined_request_request_name_old;
ALTER TABLE website.predefined_request_criterion_old RENAME CONSTRAINT pk_predefined_request_criterion TO pk_predefined_request_criterion_old;
ALTER TABLE website.predefined_request_criterion_old RENAME CONSTRAINT fk_predefined_request_criterion_request_name TO fk_predefined_request_criterion_request_name_old;
ALTER TABLE website.predefined_request_column_old RENAME CONSTRAINT pk_predefined_request_column TO pk_predefined_request_column_old;
ALTER TABLE website.predefined_request_column_old RENAME CONSTRAINT fk_predefined_request_column_request_name TO fk_predefined_request_column_request_name_old;


-----------------------------------------------------
--                                                 --
--         Création des nouvelles tables           --
--                                                 --
-----------------------------------------------------

-- Table: website.predefined_request
---------------------------------------
CREATE TABLE website.predefined_request
(
  request_id serial NOT NULL, -- The request identifier
  name character varying(50) NOT NULL, -- The request old name (Kept for the post-copy of the data)
  dataset_id character varying(36) NOT NULL, -- The dataset used by this request
  schema_code character varying(36) NOT NULL, -- The schema used by this request
  user_login character varying(50), -- The user login of the creator of the request
  definition character varying(500), -- The description of the request
  label character varying(50) NOT NULL, -- The label of the request
  date date DEFAULT now(), -- Date of creation of the request
  is_public boolean NOT NULL DEFAULT false, -- True if the request is public
  CONSTRAINT pk_predefined_request PRIMARY KEY (request_id),
  CONSTRAINT fk_predefined_request_dataset FOREIGN KEY (dataset_id)
      REFERENCES metadata.dataset (dataset_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_predefined_request_users FOREIGN KEY (user_login)
      REFERENCES website.users (user_login) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT uk_predefined_request UNIQUE (label, user_login, dataset_id, is_public)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE website.predefined_request
  OWNER TO postgres;
GRANT ALL ON TABLE website.predefined_request TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request TO ogam;
COMMENT ON COLUMN website.predefined_request.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request.dataset_id IS 'The dataset used by this request';
COMMENT ON COLUMN website.predefined_request.schema_code IS 'The schema used by this request';
COMMENT ON COLUMN website.predefined_request.user_login IS 'The user login of the creator of the request';
COMMENT ON COLUMN website.predefined_request.definition IS 'The description of the request';
COMMENT ON COLUMN website.predefined_request.label IS 'The label of the request';
COMMENT ON COLUMN website.predefined_request.date IS 'Date of creation of the request';
COMMENT ON COLUMN website.predefined_request.is_public IS 'True if the request is public';

CREATE UNIQUE INDEX uk_predefined_request_2 ON website.predefined_request (label, dataset_id) WHERE is_public;

-- Table: website.predefined_request_group
---------------------------------------------
CREATE TABLE website.predefined_request_group
(
  group_id serial NOT NULL, -- The group identifier
  name character varying(50) NOT NULL, -- The old name of the group (Kept for the post-copy of the data)
  label character varying(50) NOT NULL, -- The label of the group
  definition character varying(250), -- The definition of the group
  "position" smallint, -- The position of the group
  CONSTRAINT pk_predefined_request_group PRIMARY KEY (group_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE website.predefined_request_group
  OWNER TO postgres;
GRANT ALL ON TABLE website.predefined_request_group TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group TO ogam;
COMMENT ON COLUMN website.predefined_request_group.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group.label IS 'The label of the group';
COMMENT ON COLUMN website.predefined_request_group.definition IS 'The definition of the group';
COMMENT ON COLUMN website.predefined_request_group."position" IS 'The position of the group';

-- Table: website.predefined_request_group_asso
--------------------------------------------------
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
)
WITH (
  OIDS=FALSE
);
ALTER TABLE website.predefined_request_group_asso
  OWNER TO postgres;
GRANT ALL ON TABLE website.predefined_request_group_asso TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group_asso TO ogam;
COMMENT ON COLUMN website.predefined_request_group_asso.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group_asso.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_group_asso."position" IS 'The position of the request inside the group';

-- Table: website.predefined_request_column
----------------------------------------------
CREATE TABLE website.predefined_request_column
(
  request_id integer NOT NULL, -- The request identifier
  format character varying(36) NOT NULL, -- The form format of the column
  data character varying(36) NOT NULL, -- The form field of the column
  CONSTRAINT pk_predefined_request_column PRIMARY KEY (request_id, format, data),
  CONSTRAINT fk_predefined_request_column_request_name FOREIGN KEY (request_id)
      REFERENCES website.predefined_request (request_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
)
WITH (
  OIDS=FALSE
);
ALTER TABLE website.predefined_request_column
  OWNER TO postgres;
GRANT ALL ON TABLE website.predefined_request_column TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_column TO ogam;
COMMENT ON COLUMN website.predefined_request_column.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_column.format IS 'The form format of the column';
COMMENT ON COLUMN website.predefined_request_column.data IS 'The form field of the column';

-- Table: website.predefined_request_criterion
-------------------------------------------------
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
)
WITH (
  OIDS=FALSE
);
ALTER TABLE website.predefined_request_criterion
  OWNER TO postgres;
GRANT ALL ON TABLE website.predefined_request_criterion TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_criterion TO ogam;
COMMENT ON COLUMN website.predefined_request_criterion.request_id IS 'The request identifier';
COMMENT ON COLUMN website.predefined_request_criterion.format IS 'The form format of the criterion';
COMMENT ON COLUMN website.predefined_request_criterion.data IS 'The form field of the criterion';
COMMENT ON COLUMN website.predefined_request_criterion.value IS 'The field value (multiple values are separated by a semicolon)';


-----------------------------------------------------
--                                                 --
--         Récupération des données                --
--                                                 --
-----------------------------------------------------

INSERT INTO website.predefined_request(name, dataset_id, schema_code, definition, label, date, is_public)
  SELECT name, dataset_id, schema_code, definition, label, date, true FROM website.predefined_request_old;
INSERT INTO website.predefined_request_group(name, label, definition, "position")
  SELECT name, label, definition, "position" FROM website.predefined_request_group_old;
INSERT INTO website.predefined_request_group_asso(group_id, request_id, "position")
  SELECT group_id, request_id, prgao."position" FROM website.predefined_request_group_asso_old prgao
  LEFT JOIN website.predefined_request pr on prgao.request_name = pr.name
  LEFT JOIN website.predefined_request_group prg on prgao.group_name = prg.name;
INSERT INTO website.predefined_request_criterion(request_id, format, data, value)
  SELECT request_id, format, data, value
  FROM website.predefined_request_criterion_old prco
  LEFT JOIN website.predefined_request pr on prco.request_name = pr.name;
INSERT INTO website.predefined_request_column(request_id, format, data)
  SELECT request_id, format, data
  FROM website.predefined_request_column_old prco
  LEFT JOIN website.predefined_request pr on prco.request_name = pr.name;


-----------------------------------------------------
--                                                 --
--        Suppression des anciennes tables         --
--                                                 --
-----------------------------------------------------

DROP TABLE website.predefined_request_criterion_old;
DROP TABLE website.predefined_request_column_old;
DROP TABLE website.predefined_request_group_asso_old;
DROP TABLE website.predefined_request_group_old;
DROP TABLE website.predefined_request_old;


-----------------------------------------------------
--                                                 --
--     Suppression des colonnes de transition      --
--                                                 --
-----------------------------------------------------

ALTER TABLE website.predefined_request DROP COLUMN name;
ALTER TABLE website.predefined_request_group DROP COLUMN name;


-----------------------------------------------------
--                                                 --
--     		 Ajout des droits postgres             --
--                                                 --
-----------------------------------------------------

GRANT ALL ON SEQUENCE website.predefined_request_request_id_seq TO postgres;
GRANT ALL ON SEQUENCE website.predefined_request_request_id_seq TO ogam;
GRANT ALL ON SEQUENCE website.predefined_request_group_group_id_seq TO postgres;
GRANT ALL ON SEQUENCE website.predefined_request_group_group_id_seq TO ogam;


-----------------------------------------------------
--                                                 --
--     		    Ajout des permissions              --
--                                                 --
-----------------------------------------------------



INSERT INTO website.permission(permission_code, permission_label) VALUES ('MANAGE_OWNED_PRIVATE_REQUEST', 'Gérer ses requêtes privées');
INSERT INTO website.permission(permission_code, permission_label) VALUES ('MANAGE_PUBLIC_REQUEST', 'Gérer les requêtes publiques');

UPDATE website.permission_per_role SET permission_code='MANAGE_OWNED_PRIVATE_REQUEST' WHERE permission_code='MANAGE_PRIVATE_REQUESTS';
UPDATE website.permission_per_role SET permission_code='MANAGE_PUBLIC_REQUEST' WHERE permission_code='MANAGE_PUBLIC_REQUESTS';

DELETE FROM website.permission WHERE permission_code = 'MANAGE_PUBLIC_REQUESTS';
DELETE FROM website.permission WHERE permission_code = 'MANAGE_PRIVATE_REQUESTS';

--------------------------------------------------------------
--------------------------------------------------------------
--                                                          --
--                Modifications diverses                    --
--                                                          --
--------------------------------------------------------------
--------------------------------------------------------------

DROP TABLE website.layer_role_restriction;
