-------------------------------------------------------------------------------
-- Table: raw_data.jdd
-------------------------------------------------------------------------------
SET search_path TO raw_data;
DROP TABLE IF EXISTS jdd;

CREATE TABLE jdd
(
	id serial,
	jdd_metadata_id character varying(36) UNIQUE,
	title character varying(512),
	status character varying(16) NOT NULL,
	model_id character varying(19) NOT NULL,
	created_at timestamp without time zone DEFAULT now(),
	dsr_updated_at timestamp without time zone DEFAULT now(),
	submission_id int4,
	export_file_id integer,
	CONSTRAINT pk_jdd_id PRIMARY KEY (id),
	CONSTRAINT fk_model_id FOREIGN KEY (model_id)
	REFERENCES metadata.model (id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_submission_id FOREIGN KEY (submission_id)
	REFERENCES raw_data.submission (submission_id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_export_file_id FOREIGN KEY (export_file_id)
	REFERENCES raw_data.export_file (submission_id) MATCH SIMPLE
	ON UPDATE CASCADE ON DELETE SET NULL
)
WITH (
OIDS=FALSE
);

COMMENT ON COLUMN jdd.id IS 'Technical id of the jdd';
COMMENT ON COLUMN jdd.jdd_metadata_id IS 'Id of the jdd metadata sheet';
COMMENT ON COLUMN jdd.title IS 'Title of the jdd, from the metadata';
COMMENT ON COLUMN jdd.status IS 'jdd status, can be ''empty'' (jdd created and active, no DSR nor DEE), ''active'' (at least the DSR or the DEE is created), ''suppressed'' (deleted, but the row is kept)';
COMMENT ON COLUMN jdd.model_id IS 'Id of the data model in which the jdd is delivered';
COMMENT ON COLUMN jdd.created_at IS 'jdd creation timestamp (delivery timestamp is in submission._creationdt)';
COMMENT ON COLUMN jdd.dsr_updated_at IS 'DSR last edition timestamp';
COMMENT ON COLUMN jdd.submission_id IS 'The id of the submission which can be null (foreign key)';
COMMENT ON COLUMN jdd.export_file_id IS 'The id of the export file of the jdd (foreign key)';

ALTER TABLE raw_data.jdd
	OWNER TO admin;
GRANT ALL ON TABLE raw_data.jdd TO admin;
GRANT ALL ON TABLE raw_data.jdd TO ogam;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO admin;
GRANT ALL ON SEQUENCE raw_data.jdd_id_seq TO ogam;