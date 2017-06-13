-- Sequence: raw_data.jdd_id_seq

-- DROP SEQUENCE raw_data.jdd_id_seq;

CREATE SEQUENCE raw_data.jdd_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 5
CACHE 1;
ALTER TABLE raw_data.jdd_id_seq
  OWNER TO admin;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO admin;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO ogam;


-- Table: raw_data.jdd

-- DROP TABLE raw_data.jdd;

CREATE TABLE raw_data.jdd
(
  id integer NOT NULL DEFAULT nextval('jdd_id_seq'::regclass), -- Technical id of the jdd
  status character varying(16) NOT NULL, -- jdd status, can be 'active' or 'deleted' (deleted, but the row is kept)
  provider_id character varying(36), -- The data provider identifier (country code or organisation name)
  user_login character varying(50), -- The login of the user doing the submission
  model_id character varying(19) NOT NULL, -- Id of the data model in which the jdd is delivered
  created_at timestamp without time zone DEFAULT now(), -- jdd creation timestamp (delivery timestamp is in submission._creationdt)
  data_updated_at timestamp without time zone DEFAULT now(), -- DATA last edition timestamp
  CONSTRAINT pk_jdd_id PRIMARY KEY (id),

  CONSTRAINT fk_provider_id FOREIGN KEY (provider_id)
  REFERENCES website.providers (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE SET NULL ,

  CONSTRAINT fk_user_login FOREIGN KEY (user_login)
  REFERENCES website.users (user_login) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_model_id FOREIGN KEY (model_id)
  REFERENCES metadata.model (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE RESTRICT
)
WITH (
OIDS=FALSE
);
ALTER TABLE raw_data.jdd
  OWNER TO admin;

GRANT ALL ON TABLE raw_data.jdd TO admin;
GRANT ALL ON TABLE raw_data.jdd TO ogam;

COMMENT ON COLUMN raw_data.jdd.id IS 'Technical id of the jdd';
COMMENT ON COLUMN raw_data.jdd.status IS 'jdd status, can be ''empty'' (jdd created and active, no DSR nor DEE), ''active'' (at least the DSR or the DEE is created), ''deleted'' (deleted, but the row is kept)';
COMMENT ON COLUMN raw_data.jdd.provider_id IS 'The data provider identifier (country code or organisation name)';
COMMENT ON COLUMN raw_data.jdd.user_login IS 'The login of the user who created the jdd';
COMMENT ON COLUMN raw_data.jdd.model_id IS 'Id of the data model in which the jdd is delivered';
COMMENT ON COLUMN raw_data.jdd.created_at IS 'jdd creation timestamp (delivery timestamp is in submission._creationdt)';
COMMENT ON COLUMN raw_data.jdd.data_updated_at IS 'DATA last edition timestamp';

-- Table: raw_data.submission

ALTER TABLE raw_data.submission ADD COLUMN jdd_id integer;
ALTER TABLE raw_data.submission ADD CONSTRAINT fk_jdd_id FOREIGN KEY (jdd_id)
REFERENCES raw_data.jdd (id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;
COMMENT ON COLUMN raw_data.submission.jdd_id IS 'Reference of the jdd of the submission';