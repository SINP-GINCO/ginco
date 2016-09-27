-- This script is used for import model publication service test.

SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('specific_data_for_my_dataset', 'Integer', 'specific', 'comment', NULL);

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_dataset', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('non_publishable_dataset', 'non_publishable_dataset', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_to_publish', 'dataset_to_publish', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_with_no_file', 'dataset_with_no_file', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_with_no_fields', 'dataset_with_no_fields', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_with_no_mapping', 'dataset_with_no_mapping', '0', 'def', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'unpublished_model', 'model', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'my_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('3', 'non_publishable_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_to_publish');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_with_no_file');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_with_no_fields');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', 'dataset_with_no_mapping');

INSERT INTO format (format, type) VALUES ('my_table', 'TABLE');
INSERT INTO format (format, type) VALUES ('my_file', 'FILE');
INSERT INTO format (format, type) VALUES ('a_file', 'FILE');
INSERT INTO format (format, type) VALUES ('a_file_with_no_fields', 'FILE');
INSERT INTO format (format, type) VALUES ('a_file_with_fields', 'FILE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('my_table', '_2_my_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'my_table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'my_table');
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'my_table', '*', NULL, NULL);

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_file', 'CSV', 'my_file', 0, 'My file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('a_file', 'CSV', 'a_file', 0, 'A file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('a_file_with_no_fields', 'CSV', 'a_file_with_no_fields', 0, 'A file with no fields', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('a_file_with_fields', 'CSV', 'a_file_with_fields', 0, 'A file with fields', NULL);

INSERT INTO dataset_files (dataset_id, format) VALUES ('my_dataset', 'my_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('dataset_to_publish', 'a_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('dataset_with_no_fields', 'a_file_with_no_fields');
INSERT INTO dataset_files (dataset_id, format) VALUES ('dataset_with_no_mapping', 'a_file_with_fields');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('specific_data_for_my_dataset', 'my_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'my_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'my_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'a_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'a_file_with_fields', 'FILE');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'my_table', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'my_table', 'altitudemax', '0');

INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemin', 'my_file', '1', NULL, 1);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemax', 'my_file', '1', NULL, 2);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('specific_data_for_my_dataset', 'my_file', '1', NULL, 3);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemax', 'a_file', '1', NULL, 1);
INSERT INTO file_field (data, format, is_mandatory, mask, "position") VALUES ('altitudemax', 'a_file_with_fields', '1', NULL, 1);

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'my_file', 'altitudemax', 'my_table', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'my_file', 'altitudemin', 'my_table', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'a_file', 'altitudemax', 'my_table', 'FILE');

-- Test data for soon to be removed datase_fields table (doesn't belong here anyway, but coded to make publication/unpublication work with ogam)
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemin');
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('my_dataset', 'RAW_DATA', 'my_table', 'altitudemax');

-- Published data (we suppose that the target model is already published, as it is a condition for the publication
-- of an import model
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('2', 'model', 'model', 'RAW_DATA');
INSERT INTO metadata.format (format, type) VALUES ('my_table', 'TABLE');
INSERT INTO metadata.field (data, format, type) VALUES ('altitudemax', 'my_table', 'TABLE');
INSERT INTO metadata.field (data, format, type) VALUES ('altitudemin', 'my_table', 'TABLE');
