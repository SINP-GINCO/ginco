-- This script is used for model controller test.

SET search_path = metadata_work;

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'model_to_edit', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'model_to_delete_simple', 'model_to_delete', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'model_to_delete_complex', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'model_that\%has''special_characters', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('6', 'unpublished_model', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('7', 'model_published_without_data', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('8', 'model_published_with_data', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('9', 'model_to_publish', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('10', 'model_to_unpublish', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('11', 'model_to_unpublish_0_running', 'model_11', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('12', 'model_to_unpublish_1_running', 'model_12', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('13', 'model_to_unpublish_all_running', 'model_13', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('14', 'model_view', 'model_description', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('15', 'model_mappings', 'model_description', 'RAW_DATA');

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('11_not_running_1', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('11_not_running_2', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('12_running', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('12_not_running', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('13_running_1', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('13_running_2', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('to_delete', 'my_dataset_to_delete', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('mapping_1', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('mapping_2', 'my_dataset', '1', 'def', 'IMPORT');


INSERT INTO model_datasets (model_id, dataset_id) VALUES ('11', '11_not_running_1');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('11', '11_not_running_2');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('12', '12_running');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('12', '12_not_running');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('13', '13_running_1');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('13', '13_running_2');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('3', 'to_delete');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('15', 'mapping_1');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('15', 'mapping_2');

INSERT INTO format (format, type) VALUES ('table_son', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_father', 'TABLE');
INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_view1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_mappings_1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_mappings_2', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_mappings_1', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_mappings_2', 'TABLE');

INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_mappings_1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_mappings_1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'table_mappings_1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('codecommune', 'table_mappings_2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'table_mappings_2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'table_mappings_2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_mappings_1', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file_mappings_1', 'FILE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'file_mappings_1', 'FILE');
INSERT INTO field (data, format, type) VALUES ('codecommune', 'file_mappings_1', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'file_mappings_2', 'FILE');
INSERT INTO field (data, format, type) VALUES ('datefin', 'file_mappings_2', 'FILE');

INSERT INTO table_format (format, table_name, label) VALUES ('table_son', '_2_table_son', 'table_son');
INSERT INTO table_format (format, table_name, label) VALUES ('table_father', '_2_table_father', 'table_father');
INSERT INTO table_format (format, table_name, label) VALUES ('table', '_8_table', 'table');
INSERT INTO table_format (format, table_name, label) VALUES ('table_view1', '_14_table', 'table_view1');
INSERT INTO table_format (format, table_name, label) VALUES ('table_mappings_1', 'table_mappings_1', 'table_mappings_1');
INSERT INTO table_format (format, table_name, label) VALUES ('table_mappings_2', 'table_mappings_1', 'table_mappings_2');

INSERT INTO file_format(format, file_type, "position") VALUES ('file_mappings_1', 'file_mappings_1', 1);
INSERT INTO file_format(format, file_type, "position") VALUES ('file_mappings_2', 'file_mappings_2', 1);

INSERT INTO dataset_files (dataset_id, format) VALUES ('mapping_1', 'file_mappings_1');
INSERT INTO dataset_files (dataset_id, format) VALUES ('mapping_2', 'file_mappings_2');

INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_son');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_father');
INSERT INTO model_tables (model_id, table_id) VALUES ('8', 'table');
INSERT INTO model_tables (model_id, table_id) VALUES ('14', 'table_view1');
INSERT INTO model_tables (model_id, table_id) VALUES ('15', 'table_mappings_1');
INSERT INTO model_tables (model_id, table_id) VALUES ('15', 'table_mappings_2');

INSERT INTO table_field (data, format) VALUES ('altitudemax', 'table_mappings_1');
INSERT INTO table_field (data, format) VALUES ('altitudemin', 'table_mappings_1');
INSERT INTO table_field (data, format) VALUES ('cdnom', 'table_mappings_1');
INSERT INTO table_field (data, format) VALUES ('codecommune', 'table_mappings_2');
INSERT INTO table_field (data, format) VALUES ('datedebut', 'table_mappings_2');
INSERT INTO table_field (data, format) VALUES ('datefin', 'table_mappings_2');

INSERT INTO file_field (data, format, label_csv) VALUES ('altitudemin', 'file_mappings_1', 'altitudemin');
INSERT INTO file_field (data, format, label_csv) VALUES ('altitudemax', 'file_mappings_1', 'altitudemax');
INSERT INTO file_field (data, format, label_csv) VALUES ('cdnom', 'file_mappings_1', 'cdnom');
INSERT INTO file_field (data, format, label_csv) VALUES ('codecommune', 'file_mappings_1', 'codecommune');
INSERT INTO file_field (data, format, label_csv) VALUES ('datedebut', 'file_mappings_2', 'datedebut');
INSERT INTO file_field (data, format, label_csv) VALUES ('datefin', 'file_mappings_2', 'datefin');

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'file_mappings_1', 'altitudemin', 'table_mappings_1', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'file_mappings_1', 'altitudemax', 'table_mappings_1', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('cdnom', 'file_mappings_1', 'cdnom', 'table_mappings_1', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('codecommune', 'file_mappings_1', 'codecommune', 'table_mappings_2', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('datedebut', 'file_mappings_2', 'datedebut', 'table_mappings_2', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('datefin', 'file_mappings_2', 'datefin', 'table_mappings_2', 'FILE');

INSERT INTO table_tree (schema_code, child_table, parent_table) VALUES ('RAW_DATA', 'table_son', 'table_father');
INSERT INTO table_tree (schema_code, child_table, parent_table) VALUES ('RAW_DATA', 'table_father', '*');
INSERT INTO table_tree (schema_code, child_table, parent_table) VALUES ('RAW_DATA', 'table', '*');

INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('7', 'model_published_without_data', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('8', 'model_published_with_data', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('10', 'model_to_unpublish', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('11', 'model_to_unpublish_0_running', 'model_11', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('12', 'model_to_unpublish_1_running', 'model_12', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('13', 'model_to_unpublish_all_running', 'model_13', 'RAW_DATA');

INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('11_not_running_1', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('11_not_running_2', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('12_running', 'my_dataset-121', '1', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('12_not_running', 'my_dataset-120', '1', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('13_running_1', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('13_running_2', 'my_dataset', '1', 'def', 'IMPORT');

INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('11', '11_not_running_1');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('11', '11_not_running_2');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('12', '12_running');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('12', '12_not_running');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('13', '13_running_1');
INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('13', '13_running_2');

INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'OK', '3', '11_not_running_1', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'OK', '3', '11_not_running_2', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'RUNNING', '3', '12_running', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'OK', '3', '12_not_running', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'RUNNING', '3', '13_running_1', 'admin');
INSERT INTO raw_data.submission(step, status, provider_id, dataset_id, user_login) VALUES ('INIT', 'RUNNING', '3', '13_running_2', 'admin');

CREATE TABLE RAW_DATA._8_table(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT _8_table_pkey PRIMARY KEY (ogam_id)
);

INSERT INTO RAW_DATA._8_table (ogam_id) VALUES ('1');