-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('ginco_my_import_model', 'import_model', '0', 'import_model', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('14', 'ginco_model_view', 'model_description', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('14', 'ginco_my_import_model');

INSERT INTO format (format, type) VALUES ('file_auto', 'FILE');
INSERT INTO format (format, type) VALUES ('my_table', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file_auto', 'FILE');
INSERT INTO field (data, format, type) VALUES ('sensiniveau', 'file_auto', 'FILE');

INSERT INTO field VALUES ('PROVIDER_ID', 'my_table', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'my_table', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'my_table', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'my_table', 'FILE');
INSERT INTO field VALUES ('cdnom', 'my_table', 'FILE');
INSERT INTO field VALUES ('cdref', 'my_table', 'FILE');
INSERT INTO field VALUES ('sensiniveau', 'my_table', 'FILE');

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_auto', 'CSV', 'file', 0, 'file_auto', 'file_auto_description');

INSERT INTO dataset_files (dataset_id, format) VALUES ('ginco_my_import_model', 'file_auto');

INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemin', 'file_auto', '1', NULL, 'altitudemin');


INSERT INTO table_format VALUES ('my_table', '14_table', 'RAW_DATA', 'PROVIDER_ID', 'table', NULL);

INSERT INTO model_tables VALUES ('14', 'my_table');

INSERT INTO table_field VALUES ('PROVIDER_ID', 'my_table', 'PROVIDER_ID', '0', '0', '0', '1', NULL, NULL);
INSERT INTO table_field VALUES ('SUBMISSION_ID', 'my_table', 'SUBMISSION_ID', '1', '0', '0', '0', NULL, NULL);
INSERT INTO table_field VALUES ('altitudemax', 'my_table', 'altitudemax', '0', '1', '1', '0', NULL, NULL);
INSERT INTO table_field VALUES ('altitudemin', 'my_table', 'altitudemin', '0', '1', '1', '0', NULL, NULL);
INSERT INTO table_field VALUES ('cdnom', 'my_table', 'cdnom', '0', '1', '1', '1', NULL, NULL);
INSERT INTO table_field VALUES ('cdref', 'my_table', 'cdref', '0', '1', '1', '1', NULL, NULL);
INSERT INTO table_field VALUES ('sensiniveau', 'my_table', 'sensiniveau', '1', '1', '1', '0', NULL, NULL);
