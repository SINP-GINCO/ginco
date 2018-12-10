-- This script is used for data controller test.

SET search_path = metadata_work;

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'my_model', 'model', 'RAW_DATA');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('2', 'import_model', '0', 'def', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('2', '2');

INSERT INTO format (format, type) VALUES ('table_with_fields', 'TABLE');
INSERT INTO format (format, type) VALUES ('my_file', 'FILE');

INSERT INTO data (data, unit, label, definition, comment) VALUES ('data_field_to_edit', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('data_field_to_edit_2', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('data_field_to_override', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('data_field_to_delete', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('unrelated_data_field', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('related_data_field', 'BOOLEAN', 'Label', '', '');
INSERT INTO data (data, unit, label, definition, comment) VALUES ('related_to_file_data_field', 'BOOLEAN', 'Label', '', '');

INSERT INTO field (data, format, type) VALUES ('related_data_field', 'table_with_fields', 'TABLE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_fields', '_2_table_with_fields', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'table_with_fields');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('related_data_field', 'table_with_fields', 'related_data_field', '1');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_fields', '*', NULL, NULL);

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_file', 'CSV', 'file', 0, 'my_file', NULL);
INSERT INTO dataset_files (dataset_id, format) VALUES ('2', 'my_file');

INSERT INTO field (data, format, type) VALUES ('related_to_file_data_field', 'my_file', 'FILE');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('related_to_file_data_field', 'my_file', '1', '', 'related_to_file_data_field');