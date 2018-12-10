-- This script is used for dataset import controller test.

SET search_path = metadata_work;

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('import_model_to_edit', 'import_model_to_edit', '0', 'import_model_to_edit', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('import_model_case', 'import_MODEL', '0', 'import_model_case', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('import_model_to_delete', 'import_model_del', '0', 'import_model_to_delete', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('2', 'unpublished_simple_import_model', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('3', 'unpublished_complex_import_model', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('4', 'unpublished_model_without_datamodel', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('5', 'published_import_model', '0', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('6', 'import_model_view', '1', 'description view', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('mapping_1', 'mapping_1 dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('mapping_2', 'mapping_2 dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('id_ordered_dataset', 'ordered dataset', '0', 'def', 'IMPORT');

INSERT INTO model (id, name, description, schema_code) VALUES ('8', 'model_published_with_data', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('9', 'model_to_publish', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('10', 'model_published', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('11', 'model_view2', 'model_description', 'RAW_DATA');

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'target_model', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('15', 'model_mappings', 'model_description', 'RAW_DATA');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('1', 'import_model_to_edit');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('1', 'import_model_case');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('10', '2');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('10', '3');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('9', '4');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('10', '5');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('11', '6');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('15', 'mapping_1');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('15', 'mapping_2');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('10', 'id_ordered_dataset');

INSERT INTO format (format, type) VALUES ('table_mappings_1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_mappings_2', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_mappings_1', 'FILE');
INSERT INTO format (format, type) VALUES ('file_mappings_2', 'FILE');
INSERT INTO format (format, type) VALUES ('file_order_a', 'FILE');
INSERT INTO format (format, type) VALUES ('file_order_b', 'FILE');
INSERT INTO format (format, type) VALUES ('file_order_c', 'FILE');

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

INSERT INTO table_format (format, table_name, label) VALUES ('table_mappings_1', 'table_mappings_1', 'table_mappings_1');
INSERT INTO table_format (format, table_name, label) VALUES ('table_mappings_2', 'table_mappings_1', 'table_mappings_2');

INSERT INTO file_format(format, file_type, "position") VALUES ('file_mappings_1', 'file_mappings_1', 1);
INSERT INTO file_format(format, file_type, "position") VALUES ('file_mappings_2', 'file_mappings_2', 2);
INSERT INTO file_format(format, file_type, "position") VALUES ('file_order_a', 'file_order_a', 1);
INSERT INTO file_format(format, file_type, "position") VALUES ('file_order_b', 'file_order_b', 2);
INSERT INTO file_format(format, file_type, "position") VALUES ('file_order_c', 'file_order_c', 3);

INSERT INTO dataset_files (dataset_id, format) VALUES ('mapping_1', 'file_mappings_1');
INSERT INTO dataset_files (dataset_id, format) VALUES ('mapping_2', 'file_mappings_2');
INSERT INTO dataset_files (dataset_id, format) VALUES ('id_ordered_dataset', 'file_order_a');
INSERT INTO dataset_files (dataset_id, format) VALUES ('id_ordered_dataset', 'file_order_b');
INSERT INTO dataset_files (dataset_id, format) VALUES ('id_ordered_dataset', 'file_order_c');

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

INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('8', 'model_published_with_data', 'model', 'RAW_DATA');
INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('10', 'model_published', 'model', 'RAW_DATA');

INSERT INTO metadata.dataset (dataset_id, label, is_default, definition, type) VALUES ('5', 'published_import_model', '0', 'def', 'IMPORT');

INSERT INTO metadata.model_datasets (model_id, dataset_id) VALUES ('10', '5');
