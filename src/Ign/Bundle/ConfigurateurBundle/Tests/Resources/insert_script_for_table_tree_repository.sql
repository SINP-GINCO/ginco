-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_3__TABLE1_FATHER', 'Integer', 'table1_father FK', 'Foreign key towards table1_father in model modele_to_publish', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_3__TABLE2_FATHER', 'Integer', 'table2_father FK', 'Foreign key towards table2_father in model modele_to_publish', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_3__TABLE3_FATHER', 'Integer', 'table3_father FK', 'Foreign key towards table3_father in model modele_to_publish', NULL);

INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'model_to_edit', 'model', 'RAW_DATA');

INSERT INTO format (format, type) VALUES ('table1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table2', 'TABLE');
INSERT INTO format (format, type) VALUES ('table3', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('OGAM_FK_3__TABLE1_FATHER', 'table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_FK_3__TABLE2_FATHER', 'table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_FK_3__TABLE3_FATHER', 'table3', 'TABLE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table1', '_3_table1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table2', '_3_table2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table2', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table3', '_3_table3', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table3', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table1');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table2');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table3');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_3__TABLE1_FATHER', 'table1', 'OGAM_FK_3__TABLE1_FATHER', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_3__TABLE2_FATHER', 'table2', 'OGAM_FK_3__TABLE2_FATHER', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_3__TABLE3_FATHER', 'table3', 'OGAM_FK_3__TABLE3_FATHER', '1');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table1', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table2', 'table1', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table3', 'table2', NULL, NULL);

