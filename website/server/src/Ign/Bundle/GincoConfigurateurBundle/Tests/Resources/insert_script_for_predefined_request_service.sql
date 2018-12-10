-- This script is used for publication service test and also CopyUtils class.
-- It inserts a unit test model named "model_to_publish".

SET search_path = metadata_work;


INSERT INTO format (format, type) VALUES ('table2', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurmin', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurmax', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdref', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jourdatefin', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('heuredatefin', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jourdatedebut', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('heuredatedebut', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('nomcite', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('observateuridentite', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('observateurnomorganisme', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('statutobservation', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('dspublique', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('identifiantpermanent', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddmetadonneedeeid', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('organismegestionnairedonnee', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('orgtransformation', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensible', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensiniveau', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('statutsource', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('PROVIDER_ID', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('SUBMISSION_ID', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('geometrie', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_observation', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('nomcommune', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('codedepartement', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('codeen', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('occstatutbiogeographique', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensialerte', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensidateattribution', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensimanuelle', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensireferentiel', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('sensiversionreferentiel', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table2', 'TABLE');
		  	
INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model_to_publish_for_predefined_request', 'model used for predefined requests', 'RAW_DATA');

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_1_predefined', 'dataset_1_not_pub', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_2_predefined', 'dataset_2_not_pub', '0', 'def', 'QUERY');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_1_predefined');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_2_predefined');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table2', '_2_table', 'RAW_DATA', 'OGAM_ID_table_observation, PROVIDER_ID', 'table', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'table2');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'table2', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table2', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurmin', 'table2', 'profondeurmin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurmax', 'table2', 'profondeurmax', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('datefin', 'table2', 'datefin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('datedebut', 'table2', 'datedebut', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jourdatefin', 'table2', 'jourdatefin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jourdatedebut', 'table2', 'jourdatedebut', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('heuredatedebut', 'table2', 'heuredatedebut', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('heuredatefin', 'table2', 'heuredatefin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('cdnom', 'table2', 'cdnom', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('cdref', 'table2', 'cdref', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('PROVIDER_ID', 'table2', 'PROVIDER_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('SUBMISSION_ID', 'table2', 'SUBMISSION_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_observation', 'table2', 'OGAM_ID_table_observation', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('geometrie', 'table2', 'geometrie', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('nomcite', 'table2', 'nomcite', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('observateuridentite', 'table2', 'observateuridentite', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('observateurnomorganisme', 'table2', 'observateurnomorganisme', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('statutobservation', 'table2', 'statutobservation', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('dspublique', 'table2', 'dspublique', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('identifiantpermanent', 'table2', 'identifiantpermanent', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddmetadonneedeeid', 'table2', 'jddmetadonneedeeid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('organismegestionnairedonnee', 'table2', 'organismegestionnairedonnee', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('orgtransformation', 'table2', 'orgtransformation', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensible', 'table2', 'sensible', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensiniveau', 'table2', 'sensiniveau', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('statutsource', 'table2', 'statutsource', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('nomcommune', 'table2', 'nomcommune','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('codedepartement', 'table2', 'codedepartement','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('codeen', 'table2', 'codeen','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('occstatutbiogeographique', 'table2', 'occstatutbiogeographique','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensialerte', 'table2', 'sensialerte','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensidateattribution', 'table2', 'sensidateattribution','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensimanuelle', 'table2', 'sensimanuelle','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensireferentiel', 'table2', 'sensireferentiel','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('sensiversionreferentiel', 'table2', 'sensiversionreferentiel','0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table2', 'jddid','0');

SET search_path TO metadata;

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_2_predefined', 'dataset_2_not_pub', '0', 'def', 'QUERY');

SET search_path TO mapping;

INSERT INTO requests (id, session_id) VALUES (115, '785kl');

SET search_path TO website;

INSERT INTO predefined_request (request_id, dataset_id, schema_code, label) VALUES (115, 'dataset_2_predefined', 'RAW_DATA', 'testAddPredefinedRequestCriterion');
INSERT INTO predefined_request_group (group_id, label) VALUES (10, 'testCreatePredefinedRequest');
