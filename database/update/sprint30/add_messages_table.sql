-- Sequence: website.messages_id_seq

-- DROP SEQUENCE website.messages_id_seq;

CREATE SEQUENCE website.messages_id_seq
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 5
CACHE 1;
ALTER TABLE website.messages_id_seq
  OWNER TO admin;
GRANT ALL ON SEQUENCE website.messages_id_seq TO admin;
GRANT ALL ON SEQUENCE website.messages_id_seq TO ogam;


-- Table: website.messages

-- DROP TABLE website.messages;

CREATE TABLE website.messages
(
  id integer NOT NULL DEFAULT nextval('messages_id_seq'::regclass),
  action character varying(50) NOT NULL,
  parameters character varying,
  status character varying(20) NOT NULL,
  length integer,
  progress integer,
  created_at timestamp without time zone NOT NULL ,
  updated_at timestamp without time zone NOT NULL ,
  CONSTRAINT pk_messages PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE website.messages
  OWNER TO admin;
GRANT ALL ON TABLE website.messages TO admin;
GRANT ALL ON TABLE website.messages TO ogam;

-- Drop old table job_queue
ALTER TABLE raw_data.export_file DROP COLUMN IF EXISTS job_id;

DROP TABLE IF EXISTS website.job_queue;
