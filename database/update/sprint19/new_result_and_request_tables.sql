SET search_path = mapping;

-- drop old table - now unused
DROP TABLE IF EXISTS result_location;

-- create new tabbles

-- requests: stores redondant information about request

-- DROP TABLE requests;
--  DROP SEQUENCE mapping.requests_id_seq;

CREATE SEQUENCE requests_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;
ALTER TABLE requests_id_seq
OWNER TO admin;
GRANT ALL ON SEQUENCE requests_id_seq TO admin;
GRANT ALL ON SEQUENCE requests_id_seq TO ogam;

CREATE TABLE requests
(
  id integer NOT NULL DEFAULT nextval('requests_id_seq'::regclass),
  session_id character varying(32) NOT NULL,
  _creationdt date DEFAULT now(),
  CONSTRAINT requests_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE requests
OWNER TO admin;
GRANT ALL ON TABLE requests TO admin;
GRANT ALL ON TABLE requests TO ogam;
COMMENT ON TABLE requests
IS 'Stores redondant information about request';

-- results : n-m association table between requests and results, supporting access information

-- DROP TABLE mapping.results

CREATE TABLE results
(
  id_request integer NOT NULL,
  id_observation character varying NOT NULL,
  id_provider character varying NOT NULL,
  table_format character varying NOT NULL,
  hiding_level integer,
  CONSTRAINT results_pk PRIMARY KEY (id_request, id_observation, id_provider)
)
WITH (
OIDS=FALSE
);
ALTER TABLE results
OWNER TO admin;
GRANT ALL ON TABLE results TO admin;
GRANT ALL ON TABLE results TO ogam;
COMMENT ON TABLE results
IS 'n-m association table between requests and results, supporting access information';
COMMENT ON COLUMN results.id_request IS 'The foreign key id of the request';
COMMENT ON COLUMN results.id_observation IS 'The foreign key id of the observation (part of the primary key for an observation)';
COMMENT ON COLUMN results.id_provider IS 'The foreign key id of the provider (part of the primary key for an observation)';
COMMENT ON COLUMN results.table_format IS 'The foreign key id of the table format';
COMMENT ON COLUMN results.hiding_level IS 'The value of hiding (floutage)';

-- fk to requests, with cascade on delete

ALTER TABLE results
ADD CONSTRAINT fk_request FOREIGN KEY (id_request) REFERENCES requests (id)
ON UPDATE CASCADE ON DELETE CASCADE;
CREATE INDEX fki_request
ON results(id_request);