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

GRANT ALL ON SEQUENCE website.job_queue_id_seq TO admin;
GRANT ALL ON SEQUENCE website.job_queue_id_seq TO ogam;

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
  command character varying(200) NOT NULL,
  pid integer,
  CONSTRAINT pk PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE website.job_queue
  OWNER TO admin;

GRANT ALL ON TABLE website.job_queue TO admin;
GRANT ALL ON TABLE website.job_queue TO ogam;


-- Table: raw_data.export_file

-- DROP TABLE raw_data.export_file;

CREATE TABLE raw_data.export_file
(
  submission_id integer NOT NULL,
  job_id integer,
  file_name character varying(100),
  file_size integer,
  created_at timestamp without time zone,
  CONSTRAINT pk_submission_id PRIMARY KEY (submission_id),
  CONSTRAINT fk_job_id FOREIGN KEY (job_id)
  REFERENCES website.job_queue (id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_submission_id FOREIGN KEY (submission_id)
  REFERENCES raw_data.submission (submission_id) MATCH SIMPLE
  ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
OIDS=FALSE
);
ALTER TABLE raw_data.export_file
  OWNER TO admin;
GRANT ALL ON TABLE raw_data.export_file TO admin;
GRANT ALL ON TABLE raw_data.export_file TO ogam;
