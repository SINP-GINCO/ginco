--Conformity Check 1: jddmetadonneedeeid exists in geosource

INSERT INTO metadata.checks(check_id, step, name, label, description, statement, importance)
VALUES (1, 'CONFORMITY', 'jddmetadonneedeeid', 'jddmetadonneedeeid', 'la métadonnée associée est inexistante',
    		'SELECT raw_data.check_jddMetadonneeDEEId_exists(?submissionid?);'
			, 'ERROR');

INSERT INTO metadata.checks_per_provider(check_id, dataset_id, provider_id)
    VALUES (1, '*', '*');
    
    

-- Function: raw_data.check_jddmetadonneedeeid_exists(integer)

DROP FUNCTION IF EXISTS raw_data.check_jddmetadonneedeeid_exists(integer);

CREATE OR REPLACE FUNCTION raw_data.check_jddmetadonneedeeid_exists(id_submission integer)
  RETURNS void AS
$BODY$
    
DECLARE
   raw_data_table character varying(278);
   res bool;
BEGIN

    	SELECT table_name, 1 into raw_data_table, res
    	FROM metadata.table_format tfo, metadata.table_field tfi, metadata.model_tables mt, metadata.model_datasets md, raw_data.submission
    	WHERE tfi.data = 'jddmetadonneedeeid'
    	AND tfi.format = tfo.format
    	AND tfo.format = mt.table_id
    	AND mt.model_id = md.model_id
    	AND md.dataset_id = submission.dataset_id
    	AND submission_id = id_submission;

    	If res Then
	EXECUTE '
		INSERT INTO raw_data.check_error (check_id, submission_id, line_number, src_format, src_data, provider_id, plot_code, found_value, expected_value, error_message) 
		SELECT 1, submission_id, 0, ''observation'', ''jddMetadonneeDEEId'', provider_id, ogam_id_table_observation, jddmetadonneedeeid, ''La valeur du champ jddMetadonnee DEEId doit correspondre à un identifiant de métadonnée.'', ''la donnée ne peut pas être importée car est sans métadonnée associée''
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
