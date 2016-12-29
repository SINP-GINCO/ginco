-- This script is used for import model unpublication service test.

-- Published data (in 'metadata' schema)
SET search_path = metadata;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('specific_data_for_my_dataset', 'Integer', 'specific', 'comment', NULL);

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_dataset', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_to_unpublish', 'my_dataset', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('running_upload_dataset', 'my_dataset', '0', 'def', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model', 'model', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'my_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_to_unpublish');

INSERT INTO format (format, type) VALUES ('my_table', 'TABLE');
INSERT INTO format (format, type) VALUES ('my_file', 'FILE');
INSERT INTO format (format, type) VALUES ('a_file', 'FILE');

INSERT INTO table_format (format, table_name, primary_key) VALUES ('my_table', 'my_table', 'OGAM_ID_my_table, PROVIDER_ID');

INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'my_table');

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_file', 'CSV', 'my_file', 0, 'My file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('a_file', 'CSV', 'a_file', 0, 'A file', NULL);

INSERT INTO dataset_files (dataset_id, format) VALUES ('my_dataset', 'my_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('dataset_to_unpublish', 'a_file');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('specific_data_for_my_dataset', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_table', 'TABLE');

INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemin', 'my_file', '1', NULL, 1);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemax', 'my_file', '1', NULL, 2);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('specific_data_for_my_dataset', 'my_file', '1', NULL, 3);

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'my_file', 'altitudemax', 'my_table', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'my_file', 'altitudemin', 'my_table', 'FILE');

-- Test data for soon to be removed datase_fields table (doesn't belong here anyway, but coded to make publication/unpublication work with ogam)
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemin');
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemax');

-- Published data (in 'metadata_work' schema)
SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('specific_data_for_my_dataset', 'Integer', 'specific', 'comment', NULL);

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_dataset', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_to_unpublish', 'my_dataset', '0', 'def', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model', 'model', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'my_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_to_unpublish');

INSERT INTO format (format, type) VALUES ('my_table', 'TABLE');
INSERT INTO format (format, type) VALUES ('my_file', 'FILE');
INSERT INTO format (format, type) VALUES ('a_file', 'FILE');

INSERT INTO table_format (format, table_name, primary_key) VALUES ('my_table', 'my_table', 'OGAM_ID_my_table, PROVIDER_ID');

INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'my_table');

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_file', 'CSV', 'my_file', 0, 'My file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('a_file', 'CSV', 'a_file', 0, 'A file', NULL);

INSERT INTO dataset_files (dataset_id, format) VALUES ('my_dataset', 'my_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('dataset_to_unpublish', 'a_file');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('specific_data_for_my_dataset', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_table', 'TABLE');

INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemin', 'my_file', '1', NULL, 1);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemax', 'my_file', '1', NULL, 2);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('specific_data_for_my_dataset', 'my_file', '1', NULL, 3);

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'my_file', 'altitudemax', 'my_table', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'my_file', 'altitudemin', 'my_table', 'FILE');

-- Test data for soon to be removed datase_fields table (doesn't belong here anyway, but coded to make publication/unpublication work with ogam)
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemin');
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemax');

INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'OK', '3', 'my_dataset', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'RUNNING', '3', 'running_upload_dataset', 'admin');