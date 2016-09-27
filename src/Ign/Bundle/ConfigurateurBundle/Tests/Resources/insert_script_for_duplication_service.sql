-- This script is used for duplication service test.

SET search_path = metadata_work;

INSERT INTO format (format, type) VALUES ('table_1', 'TABLE');
INSERT INTO format (format, type) VALUES ('format_2_copy', 'TABLE');

INSERT INTO data (data, unit, label, definition) VALUES ('OGAM_ID_table_1', 'IDString', 'Clé primaire table_1', 'Clé primaire table_1');
INSERT INTO data (data, unit, label, definition) VALUES ('OGAM_ID_format_2_copy', 'IDString', 'Clé primaire format_2_copy', 'Clé primaire format_2_copy');

INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_1', 'table_1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_format_2_copy', 'format_2_copy', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'format_2_copy', 'TABLE');

INSERT INTO model (id, name, schema_code) VALUES ('2', 'model_copied', 'RAW_DATA');
INSERT INTO model (id, name, schema_code) VALUES ('3', 'model_copied_copy', 'RAW_DATA');
INSERT INTO model (id, name, schema_code) VALUES ('4', 'model_not_copied', 'RAW_DATA');
INSERT INTO model (id, name, schema_code) VALUES ('5', 'model_bad_id', 'RAW_DATA');
INSERT INTO model (id, name, schema_code) VALUES ('6', 'model_for_pk', 'RAW_DATA');

INSERT INTO table_format (format, table_name, primary_key) VALUES ('table_1', '_4_table_1', 'OGAM_ID_table_1, PROVIDER_ID');
INSERT INTO table_format (format, table_name, primary_key) VALUES ('format_2_copy', '_6_table_2', 'OGAM_ID_format_2_copy, PROVIDER_ID');

INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_1');
INSERT INTO model_tables (model_id, table_id) VALUES ('6', 'format_2_copy');

INSERT INTO table_field (data, format) VALUES ('OGAM_ID_table_1', 'table_1');
INSERT INTO table_field (data, format) VALUES ('altitudemin', 'table_1');
INSERT INTO table_field (data, format) VALUES ('OGAM_ID_format_2_copy', 'format_2_copy');
INSERT INTO table_field (data, format) VALUES ('altitudemin', 'format_2_copy');

INSERT INTO table_tree (schema_code, child_table, parent_table) VALUES ('RAW_DATA', 'table_1', '*');
INSERT INTO table_tree (schema_code, child_table, parent_table) VALUES ('RAW_DATA', 'format_2_copy', '*');
