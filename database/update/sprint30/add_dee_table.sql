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
  submissions text NOT NULL,
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


-- Drop old table export_file
DROP TABLE IF EXISTS raw_data.export_file;
