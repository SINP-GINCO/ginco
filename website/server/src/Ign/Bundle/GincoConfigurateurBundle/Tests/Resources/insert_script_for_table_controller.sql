-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('custom_field', 'Integer', 'custom_field', 'custom_field that can be deleted', NULL);

INSERT INTO model (id, name, description, schema_code, is_ref) VALUES ('2', 'empty_model', 'model', 'RAW_DATA', false);
INSERT INTO model (id, name, description, schema_code, is_ref) VALUES ('3', 'model_to_edit', 'model', 'RAW_DATA', false);
INSERT INTO model (id, name, description, schema_code, is_ref) VALUES ('4', 'model_view', 'model description', 'RAW_DATA', false);

INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_to_delete', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_fields', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('jddid', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('custom_field', 'table_with_fields', 'TABLE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table', '3_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_to_delete', '3_table_to_delete', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_fields', '3_table_with_fields', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_to_delete');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_fields');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_with_fields', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddcode', 'table_with_fields', 'jddcode', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('custom_field', 'table_with_fields', 'custom_field', '1');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_to_delete', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_fields', '*', NULL, NULL);

