-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_import_model', 'import_model', '0', 'import_model', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('import_model_view', 'import_model_view', '0', 'import_model_view', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('13', 'model_view', 'model_description', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('13', 'import_model_view');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('13', 'my_import_model');

INSERT INTO format (format, type) VALUES ('my_file', 'FILE');
INSERT INTO format (format, type) VALUES ('my_add_file', 'FILE');
INSERT INTO format (format, type) VALUES ('my_remove_file', 'FILE');
INSERT INTO format (format, type) VALUES ('file_to_delete', 'FILE');
INSERT INTO format (format, type) VALUES ('file_to_delete_complex', 'FILE');
INSERT INTO format (format, type) VALUES ('file_positions', 'FILE');
INSERT INTO format (format, type) VALUES ('file_increase', 'FILE');
INSERT INTO format (format, type) VALUES ('file_decrease', 'FILE');
INSERT INTO format (format, type) VALUES ('file_view', 'FILE');
INSERT INTO format (format, type) VALUES ('file_auto', 'FILE');
INSERT INTO format (format, type) VALUES ('my_table', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('jddid', 'my_add_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'my_remove_file', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file_to_delete_complex', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_to_delete_complex', 'FILE');
INSERT INTO field (data, format, type) VALUES ('commentaire', 'file_to_delete_complex', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_positions', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'file_increase', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'file_increase', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'file_decrease', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'file_decrease', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'file_view', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file_auto', 'FILE');

INSERT INTO field VALUES ('PROVIDER_ID', 'my_table', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'my_table', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID', 'my_table', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'my_table', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'my_table', 'FILE');
INSERT INTO field VALUES ('cdnom', 'my_table', 'FILE');
INSERT INTO field VALUES ('cdref', 'my_table', 'FILE');

INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_file', 'CSV', 'file', 0, 'my_file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_add_file', 'CSV', 'file', 0, 'my_add_file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('my_remove_file', 'CSV', 'file', 0, 'my_remove_file', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_to_delete', 'CSV', 'file', 0, 'file_to_delete', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_to_delete_complex', 'CSV', 'file', 0, 'file_to_delete_complex', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_positions', 'CSV', 'file', 0, 'file_positions', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_increase', 'CSV', 'file', 0, 'file_increase', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_decrease', 'CSV', 'file', 0, 'file_decrease', NULL);
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_view', 'CSV', 'file', 0, 'file_view', 'file_view_description');
INSERT INTO file_format (format, file_extension, file_type, "position", label, definition) VALUES ('file_auto', 'CSV', 'file', 0, 'file_auto', 'file_auto_description');

INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'my_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'my_add_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'my_remove_file');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_to_delete');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_to_delete_complex');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_positions');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_increase');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_decrease');
INSERT INTO dataset_files (dataset_id, format) VALUES ('import_model_view', 'file_view');
INSERT INTO dataset_files (dataset_id, format) VALUES ('my_import_model', 'file_auto');

INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('jddid', 'my_add_file', '0', NULL, 'jddid');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('jddid', 'my_remove_file', '0', NULL, 'jddid');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemin', 'file_to_delete_complex', '0', NULL, 'altitudemin');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemax', 'file_to_delete_complex', '0', NULL, 'altitudemax');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('commentaire', 'file_to_delete_complex', '0', NULL, 'commentaire');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemax', 'file_positions', '0', NULL, 'altitudemax');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datedebut', 'file_increase', '0', NULL, 'datedebut');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datefin', 'file_increase', '0', NULL, 'datefin');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datefin', 'file_decrease', '0', NULL, 'datefin');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datedebut', 'file_decrease', '0', NULL, 'datedebut');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datefin', 'file_view', '0', NULL, 'datefin');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemin', 'file_auto', '1', NULL, 'altitudemin');


INSERT INTO table_format VALUES ('my_table', '13_table', 'RAW_DATA', 'OGAM_ID,PROVIDER_ID', 'table', NULL);

INSERT INTO model_tables VALUES ('13', 'my_table');

INSERT INTO table_field VALUES ('PROVIDER_ID', 'my_table', 'PROVIDER_ID', '0', '0', '0', '1', NULL, NULL);
INSERT INTO table_field VALUES ('SUBMISSION_ID', 'my_table', 'SUBMISSION_ID', '1', '0', '0', '0', NULL, NULL);
INSERT INTO table_field VALUES ('OGAM_ID', 'my_table', 'OGAM_ID', '1', '0', '0', '1', NULL, NULL);
INSERT INTO table_field VALUES ('altitudemax', 'my_table', 'altitudemax', '0', '1', '1', '0', NULL, NULL);
INSERT INTO table_field VALUES ('altitudemin', 'my_table', 'altitudemin', '0', '1', '1', '0', NULL, NULL);
INSERT INTO table_field VALUES ('cdnom', 'my_table', 'cdnom', '0', '1', '1', '1', NULL, NULL);
INSERT INTO table_field VALUES ('cdref', 'my_table', 'cdref', '0', '1', '1', '1', NULL, NULL);
