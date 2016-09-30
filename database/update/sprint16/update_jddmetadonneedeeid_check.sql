-- Function: raw_data.check_jddmetadonneedeeid_exists(integer)

DROP FUNCTION IF EXISTS raw_data.check_jddmetadonneedeeid_exists(integer);

CREATE OR REPLACE FUNCTION raw_data.check_jddmetadonneedeeid_exists(id_submission integer)
  RETURNS void AS
$BODY$

DECLARE
   raw_data_table character varying(278);
   submission_file_name character varying(278);
   res bool;
BEGIN

    	SELECT table_name, 1, sf.file_type into raw_data_table, res, submission_file_name
    	FROM metadata.table_format tfo, metadata.table_field tfi, metadata.model_tables mt, metadata.model_datasets md, raw_data.submission s
    	LEFT JOIN raw_data.submission_file sf ON (sf.submission_id = s.submission_id)
    	WHERE tfi.data = 'jddmetadonneedeeid'
    	AND tfi.format = tfo.format
    	AND tfo.format = mt.table_id
    	AND mt.model_id = md.model_id
    	AND md.dataset_id = s.dataset_id
    	AND s.submission_id = id_submission;

    	If res Then
	EXECUTE '
		INSERT INTO raw_data.check_error (check_id, submission_id, line_number, src_format, src_data, provider_id, plot_code, found_value, expected_value, error_message)
		SELECT 1, submission_id, 0, ''' ||submission_file_name|| ''', ''jddmetadonneedeeid'', provider_id, null, jddmetadonneedeeid,
		 ''La valeur du champ jddMetadonneeDEEId doit correspondre à un identifiant de métadonnée.'', ''La donnée ne peut pas être importée car est sans métadonnée associée.''
		FROM raw_data.' ||quote_ident(raw_data_table)|| '
		WHERE submission_id = ' || id_submission ||'
  		AND (LEFT(RIGHT(jddmetadonneedeeid, 40),36) NOT IN (SELECT uuid FROM geosource.metadata))';
	End if;
  END;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.check_jddmetadonneedeeid_exists(integer)
  OWNER TO admin;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA raw_data TO ogam;