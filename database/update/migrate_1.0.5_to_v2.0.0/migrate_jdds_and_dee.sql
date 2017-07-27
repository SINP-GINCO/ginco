-- Create jdd_field, and migrate title and metadata_ids (datas)

-- Table: raw_data.jdd_field

-- DROP TABLE raw_data.jdd_field;

CREATE TABLE raw_data.jdd_field
(
  jdd_id integer NOT NULL, -- foreign key to the jdd
  key character varying(255) NOT NULL, -- key for the field
  type character varying(20) NOT NULL, -- type of the data stored
  value_string character varying(255), -- value if of type string
  value_text text, -- value if of type text
  value_integer integer, -- value if of type integer
  value_float double precision, -- value if of type float
  CONSTRAINT pk_jdd_field_id PRIMARY KEY (jdd_id, key),
  CONSTRAINT fk_jdd_id FOREIGN KEY (jdd_id)
  REFERENCES raw_data.jdd (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
OIDS=FALSE
);
ALTER TABLE raw_data.jdd_field
  OWNER TO admin;
GRANT ALL ON TABLE raw_data.jdd_field TO admin;
GRANT ALL ON TABLE raw_data.jdd_field TO ogam;
COMMENT ON COLUMN raw_data.jdd_field.jdd_id IS 'foreign key to the jdd';
COMMENT ON COLUMN raw_data.jdd_field.key IS 'key for the field';
COMMENT ON COLUMN raw_data.jdd_field.type IS 'type of the data stored';
COMMENT ON COLUMN raw_data.jdd_field.value_string IS 'value if of type string';
COMMENT ON COLUMN raw_data.jdd_field.value_text IS 'value if of type text';
COMMENT ON COLUMN raw_data.jdd_field.value_integer IS 'value if of type integer';
COMMENT ON COLUMN raw_data.jdd_field.value_float IS 'value if of type float';

-- migrate metadata_Ids and titles

INSERT INTO jdd_field (jdd_id, key, type, value_string)
SELECT id, 'metadataId', 'string', jdd_metadata_id
FROM jdd;

INSERT INTO jdd_field (jdd_id, key, type, value_string)
SELECT id, 'title', 'string', title
FROM jdd;

-- Add jdd_id to submission and fill it

ALTER TABLE submission ADD COLUMN jdd_id integer;
ALTER TABLE submission ADD CONSTRAINT fk_jdd_id FOREIGN KEY (jdd_id)
REFERENCES raw_data.jdd (id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;

COMMENT ON COLUMN raw_data.submission.jdd_id IS 'Reference of the jdd of the submission';

UPDATE submission
SET jdd_id = jdd.id
FROM jdd
WHERE jdd.submission_id = submission.submission_id;

-- Delete orphan submissions
DELETE FROM raw_data.submission
WHERE jdd_id IS NULL;


-- Add provider and user columns to jdd and fill them
ALTER TABLE  jdd ADD COLUMN provider_id character varying(36);
ALTER TABLE  jdd ADD COLUMN user_login character varying(50);
ALTER TABLE  jdd ADD CONSTRAINT fk_provider_id FOREIGN KEY (provider_id)
REFERENCES website.providers (id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE  jdd ADD CONSTRAINT fk_user_login FOREIGN KEY (user_login)
REFERENCES website.users (user_login) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE SET NULL;

UPDATE jdd
SET provider_id = submission.provider_id,
  user_login = submission.user_login
FROM submission
WHERE jdd.submission_id = submission.submission_id;

-- Table export_file --> dee, and complete data

-- Sequence: raw_data.dee_id_seq

-- DROP SEQUENCE raw_data.dee_id_seq;

CREATE SEQUENCE raw_data.dee_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER TABLE raw_data.dee_id_seq
  OWNER TO admin;
GRANT ALL ON SEQUENCE raw_data.dee_id_seq TO admin;
GRANT ALL ON SEQUENCE raw_data.dee_id_seq TO ogam;


-- Table: raw_data.dee

-- DROP TABLE raw_data.dee;

CREATE TABLE raw_data.dee
(
  id integer NOT NULL,
  jdd_id integer,
  user_login character varying(50) DEFAULT NULL::character varying,
  message_id integer,
  filepath character varying(500) DEFAULT NULL::character varying,
  status character varying(20) NOT NULL,
  version integer NOT NULL,
  comment text,
  submissions text,
  createdat timestamp(0) without time zone NOT NULL,
  CONSTRAINT dee_pkey PRIMARY KEY (id),
  CONSTRAINT fk_fc60c94448ca3048 FOREIGN KEY (user_login)
  REFERENCES website.users (user_login) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_fc60c944537a1329 FOREIGN KEY (message_id)
  REFERENCES website.messages (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_fc60c944595b2064 FOREIGN KEY (jdd_id)
  REFERENCES raw_data.jdd (id) MATCH SIMPLE
  ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
OIDS=FALSE
);
ALTER TABLE raw_data.dee
  OWNER TO admin;
GRANT ALL ON TABLE raw_data.dee TO admin;
GRANT ALL ON TABLE raw_data.dee TO ogam;

-- Index: raw_data.idx_fc60c94448ca3048

-- DROP INDEX raw_data.idx_fc60c94448ca3048;

CREATE INDEX idx_fc60c94448ca3048
  ON raw_data.dee
  USING btree
  (user_login COLLATE pg_catalog."default");

-- Index: raw_data.idx_fc60c944595b2064

-- DROP INDEX raw_data.idx_fc60c944595b2064;

CREATE INDEX idx_fc60c944595b2064
  ON raw_data.dee
  USING btree
  (jdd_id);

-- Index: raw_data.uniq_fc60c944537a1329

-- DROP INDEX raw_data.uniq_fc60c944537a1329;

CREATE UNIQUE INDEX uniq_fc60c944537a1329
  ON raw_data.dee
  USING btree
  (message_id);

-- migrate datas from export_file


INSERT INTO dee (id, user_login, filepath, status, version, createdat)
  SELECT id, user_login, file_name, 'OK', 1, created_at
  FROM export_file;

UPDATE dee
SET jdd_id = jdd.id,
  submissions = jdd.submission_id
FROM jdd
WHERE jdd.export_file_id = dee.id;

-- New filepaths
UPDATE dee
SET filepath = '/dee/' || replace(regexp_replace(filepath, '^.+[/\\]', ''), 'xml', 'zip');

-- Drop old table export_file
DROP TABLE IF EXISTS raw_data.export_file CASCADE;

-- Clean table jdd
ALTER TABLE jdd DROP COLUMN jdd_metadata_id;
ALTER TABLE jdd DROP COLUMN title;
ALTER TABLE jdd DROP COLUMN submission_id;
ALTER TABLE jdd DROP COLUMN export_file_id;
ALTER TABLE jdd RENAME COLUMN dsr_updated_at TO data_updated_at;

COMMENT ON COLUMN raw_data.jdd.id IS 'Technical id of the jdd';
COMMENT ON COLUMN raw_data.jdd.status IS 'jdd status, can be ''empty'' (jdd created and active, no DSR nor DEE), ''active'' (at least the DSR or the DEE is created), ''deleted'' (deleted, but the row is kept)';
COMMENT ON COLUMN raw_data.jdd.provider_id IS 'The data provider identifier (country code or organisation name)';
COMMENT ON COLUMN raw_data.jdd.user_login IS 'The login of the user who created the jdd';
COMMENT ON COLUMN raw_data.jdd.model_id IS 'Id of the data model in which the jdd is delivered';
COMMENT ON COLUMN raw_data.jdd.created_at IS 'jdd creation timestamp (delivery timestamp is in submission._creationdt)';
COMMENT ON COLUMN raw_data.jdd.data_updated_at IS 'DSR last edition timestamp';

GRANT ALL ON ALL SEQUENCES IN SCHEMA raw_data TO ogam;