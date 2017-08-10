-- This script is used for field mapping controller test.

SET search_path = metadata_work;

INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'model_to_edit', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'model_view', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'model', 'model', 'RAW_DATA');

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('3', 'dataset_import_to_edit', '1', 'definition', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('4', 'dataset_import_view', '0', 'definition', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('5', 'dataset_import', '0', 'definition', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('3', '3');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('4', '4');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('5', '5');

INSERT INTO format (format, type) VALUES ('table_to_delete', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_fields2', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_fields', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_cdnom', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_with_field', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_mapped_with_table_to_delete', 'FILE');
INSERT INTO format (format, type) VALUES ('file_with_fields', 'FILE');
INSERT INTO format (format, type) VALUES ('file_with_cdnom', 'FILE');
INSERT INTO format (format, type) VALUES ('file_with_field', 'FILE');
INSERT INTO format (format, type) VALUES ('file_with_mapping', 'FILE');
INSERT INTO format (format, type) VALUES ('file_without_mapping', 'FILE');
INSERT INTO format (format, type) VALUES ('table_view', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_auto_mapping', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_auto_mapping', 'FILE');

INSERT INTO field (data, format, type) VALUES ('datedebut', 'table_to_delete', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_with_fields', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'table_with_cdnom', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'file_with_cdnom', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('identite', 'table_with_fields2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('nomorganisme', 'table_with_fields2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('referencebiblio', 'table_with_fields2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'table_with_field', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('datedebut', 'file_mapped_with_table_to_delete', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_with_fields', 'FILE');
INSERT INTO field (data, format, type) VALUES ('jddcode', 'file_with_fields', 'FILE');
INSERT INTO field (data, format, type) VALUES ('jddid', 'file_with_fields', 'FILE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'file_with_fields', 'FILE');
INSERT INTO field (data, format, type) VALUES ('identite', 'file_with_field', 'FILE');
INSERT INTO field (data, format, type) VALUES ('identite', 'file_with_mapping', 'FILE');
INSERT INTO field (data, format, type) VALUES ('identite', 'table_view', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_auto_mapping', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_auto_mapping', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'table_auto_mapping', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('cdref', 'table_auto_mapping', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file_auto_mapping', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_auto_mapping', 'FILE');
INSERT INTO field (data, format, type) VALUES ('cdnom', 'file_auto_mapping', 'FILE');
INSERT INTO field (data, format, type) VALUES ('codecommune', 'file_auto_mapping', 'FILE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_to_delete', '_3_table_to_delete', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_to_delete', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_fields', '_3_table_with_fields', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_with_fields', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_cdnom', '_5_table_with_cdnom', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_with_cdnom', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_fields2', '_3_table_with_fields2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_with_fields2', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_with_field', '_3_table_with_field', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_with_field', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_view', '_4_table_view', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_view', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_auto_mapping', '_3_table_auto_mapping', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_auto_mapping', 'description');

INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_to_delete', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_fields', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_cdnom', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_fields2', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_with_field', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_view', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_auto_mapping', '*', NULL, NULL);


INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_to_delete');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_fields');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'table_with_cdnom');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_fields2');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_with_field');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_view');
INSERT INTO model_tables (model_id, table_id) VALUES ('3', 'table_auto_mapping');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('datedebut', 'table_to_delete', 'datedebut', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_with_fields', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_with_fields', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('cdnom', 'table_with_cdnom', 'cdnom', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('identite', 'table_with_fields2', 'identite', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('nomorganisme', 'table_with_fields2', 'nomorganisme', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('referencebiblio', 'table_with_fields2', 'referencebiblio', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('jddid', 'table_with_field', 'jddid', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('identite', 'table_view', 'identite', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_auto_mapping', 'altitudemax', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('cdnom', 'table_auto_mapping', 'cdnom', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('cdref', 'table_auto_mapping', 'cdref', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'table_auto_mapping', 'altitudemin', '0');

INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_with_fields', 'CSV', 'file_with_fields', '1', 'file_with_fields', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_with_cdnom', 'CSV', 'file_with_cdnom', '1', 'file_with_cdnom', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_with_field', 'CSV', 'file_with_field', '0', 'file_with_field', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_mapped_with_table_to_delete', 'CSV', 'file_mapped_with_table_to_delete', '0', 'file_mapped_with_table_to_delete', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_with_mapping', 'CSV', 'file_with_mapping', '0', 'file_with_mapping', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_without_mapping', 'CSV', 'file_without_mapping', '0', 'file_without_mapping', 'file_without_mapping');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_auto_mapping', 'CSV', 'file_auto_mapping', '0', 'file_auto_mapping', 'file_auto_mapping');

INSERT INTO dataset_files (dataset_id, format) VALUES ('3', 'file_mapped_with_table_to_delete');
INSERT INTO dataset_files (dataset_id, format) VALUES ('3', 'file_with_fields');
INSERT INTO dataset_files (dataset_id, format) VALUES ('3', 'file_with_field');
INSERT INTO dataset_files (dataset_id, format) VALUES ('3', 'file_auto_mapping');
INSERT INTO dataset_files (dataset_id, format) VALUES ('4', 'file_with_mapping');
INSERT INTO dataset_files (dataset_id, format) VALUES ('4', 'file_without_mapping');
INSERT INTO dataset_files (dataset_id, format) VALUES ('5', 'file_with_cdnom');

INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('datedebut', 'file_mapped_with_table_to_delete', '0', '', 'datedebut');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemax', 'file_with_fields', '0', '', 'altitudemax');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('jddcode', 'file_with_fields', '0', '', 'jddcode');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('jddid', 'file_with_fields', '0', '', 'jddid');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('cdnom', 'file_with_cdnom', '0', '', 'cdnom');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('identite', 'file_with_field', '0', '', 'identite');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('identite', 'file_with_mapping', '0', '', 'identite');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemin', 'file_auto_mapping', '0', '', 'altitudemin');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('altitudemax', 'file_auto_mapping', '0', '', 'altitudemax');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('cdnom', 'file_auto_mapping', '0', '', 'cdnom');
INSERT INTO file_field (data, format, is_mandatory, mask, label_csv) VALUES ('codecommune', 'file_auto_mapping', '0', '', 'codecommune');

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('datedebut', 'file_mapped_with_table_to_delete', 'datedebut', 'table_to_delete', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('jddid', 'file_with_fields', 'jddid', 'table_with_fields', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('jddcode', 'file_with_fields', 'referencebiblio', 'table_with_fields2', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('identite', 'file_with_field', 'identite', 'table_with_fields2', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('identite', 'file_with_mapping', 'identite', 'table_view', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'file_auto_mapping', 'altitudemin', 'table_auto_mapping', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('cdnom', 'file_with_cdnom', 'cdnom', 'table_with_cdnom', 'FILE');
