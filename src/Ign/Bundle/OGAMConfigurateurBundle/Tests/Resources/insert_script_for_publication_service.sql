-- This script is used for publication service test and also CopyUtils class.
-- It inserts a unit test model named "model_to_publish".

SET search_path = metadata_work;

INSERT INTO data (data, unit, label, definition, comment) VALUES ('my_special_data', 'Integer', 'table_father FK', 'Foreign key towards table_father in model modele_to_publish', NULL);

INSERT INTO format (format, type) VALUES ('table_son', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_father', 'TABLE');
INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_no_fields', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('my_special_data', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('PROVIDER_ID', 'table_no_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('SUBMISSION_ID', 'table_no_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID', 'table_no_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('PROVIDER_ID', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('SUBMISSION_ID', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('PROVIDER_ID', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('SUBMISSION_ID', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('geometrie', 'table_father', 'TABLE');

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model_to_publish', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'model_with_data', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'model_with_no_table', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'model_with_no_fields_in_table', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('6', 'model_with_unpublished_import_models', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('6', 'model_with_unpublished_import_models', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('7', 'model_with_all_import_models_published', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('7', 'model_with_all_import_models_published', 'model', 'RAW_DATA');

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_1_not_pub', 'dataset_1_not_pub', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_2_not_pub', 'dataset_2_not_pub', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_1_pub', 'dataset_1_pub', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_2_pub', 'dataset_2_pub', '0', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_1_pub', 'dataset_1_pub', '0', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('dataset_2_pub', 'dataset_2_pub', '0', 'def', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('6', 'dataset_1_not_pub');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('6', 'dataset_2_not_pub');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('7', 'dataset_1_pub');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('7', 'dataset_2_pub');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('7', 'dataset_1_pub');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('7', 'dataset_2_pub');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_son', '_2_table_son', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_son', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_father', '_2_table_father', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_father', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table', '_3_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_no_fields', '_4_table_no_fields', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_no_fields', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'table_son');
INSERT INTO model_tables (model_id, table_id) VALUES ('2', 'table_father');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'table_no_fields');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'table_son', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_son', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('my_special_data', 'table_son', 'my_special_data', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'table_father', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'table_father', 'profondeurMax', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('PROVIDER_ID', 'table_no_fields', 'PROVIDER_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('SUBMISSION_ID', 'table_no_fields', 'SUBMISSION_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID', 'table_no_fields', 'OGAM_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('PROVIDER_ID', 'table_father', 'PROVIDER_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('SUBMISSION_ID', 'table_father', 'SUBMISSION_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID', 'table_father', 'OGAM_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('geometrie', 'table_father', 'geometrie', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('PROVIDER_ID', 'table_son', 'PROVIDER_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('SUBMISSION_ID', 'table_son', 'SUBMISSION_ID', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID', 'table_son', 'OGAM_ID', '0');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_son', 'table_father', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_father', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_no_fields', '*', NULL, NULL);

CREATE TABLE RAW_DATA._2_table_father(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT _2_table_father_pkey PRIMARY KEY (ogam_id)
);

CREATE TABLE RAW_DATA._3_table(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT _3_table_pkey PRIMARY KEY (ogam_id)
);

INSERT INTO RAW_DATA._3_table (ogam_id) VALUES ('1');


