-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_3__TABLE_FATHER', 'Integer', 'table_father FK', 'Foreign key towards table_father in model modele_to_publish', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_ID_table_to_delete', 'IDString', 'primary key', 'primary key', NULL);

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'empty_model', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'model_to_edit', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'model_view', 'model description', 'RAW_DATA');

INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_bis', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_to_delete', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_fields', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_field', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_checkbox', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_view1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_view2', 'TABLE');
INSERT INTO format (format, type) VALUES ('child_table', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('OGAM_FK_3__TABLE_FATHER', 'table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table_with_field', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table_checkbox', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'table_checkbox', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'table_view1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_to_delete', 'table_to_delete', 'TABLE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table', '3_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_bis', '3_table_bis', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_to_delete', '3_table_to_delete', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_fields', '3_table_with_fields', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_field', '3_table_with_field', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_checkbox', '3_table_checkbox', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_view1', '4_table_view1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_view1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_view2', '4_table_view2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_view2', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('child_table', '2_child_table', 'RAW_DATA', 'OGAM_ID_child_table, PROVIDER_ID', 'child_table', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_bis');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_to_delete');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_fields');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_field');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_checkbox');
INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'child_table');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_view1');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_view2');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_3__TABLE_FATHER', 'table', 'OGAM_FK_3__TABLE_FATHER', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_with_fields', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddcode', 'table_with_fields', 'jddcode', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_with_field', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_checkbox', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddcode', 'table_checkbox', 'jddcode', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddcode', 'table_view1', 'jddcode', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_to_delete', 'table_to_delete', 'OGAM_ID_table_to_delete', '0');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_bis', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_to_delete', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_fields', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_field', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_checkbox', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_view2', 'table_view1', 'OGAM_FK_3__TABLE_VIEW', NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_view1', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'child_table', '*', NULL, NULL);

