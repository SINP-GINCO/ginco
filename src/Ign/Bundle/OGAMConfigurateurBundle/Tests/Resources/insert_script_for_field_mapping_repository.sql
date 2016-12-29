-- This script is used for field mapping controller test.

SET search_path = metadata_work;

INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'model', 'model', 'RAW_DATA');

INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('4', 'dataset_import', '1', 'definition', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('4', '4');

INSERT INTO format (format, type) VALUES ('table1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_removeAllByTableField', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_removeAllByTableFormat', 'TABLE');
INSERT INTO format (format, type) VALUES ('file_removeAllByFileFormat', 'FILE');
INSERT INTO format (format, type) VALUES ('file_removeAllByFileField', 'FILE');
INSERT INTO format (format, type) VALUES ('file1', 'FILE');

INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_removeAllByTableField', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_removeAllByTableFormat', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_removeAllByFileFormat', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file_removeAllByFileField', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'file1', 'FILE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'file1', 'FILE');

INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table1', '_4_table1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_removeAllByTableField', '_4_table_removeAllByTableField', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_removeAllByTableField', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_removeAllByTableFormat', '_4_table_removeAllByTableFormat', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_removeAllByTableFormat', 'description');

INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_removeAllByTableField');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'table_removeAllByTableFormat');

INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table1', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_removeAllByTableField', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_removeAllByTableFormat', 'altitudemax', '1');

INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_removeAllByFileFormat', 'CSV', 'file_removeAllByFileFormat', '0', 'file_removeAllByFileFormat', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file_removeAllByFileField', 'CSV', 'file_removeAllByFileField', '1', 'file_removeAllByFileField', 'definition');
INSERT INTO file_format (format, file_extension, file_type, position, label, definition) VALUES ('file1', 'CSV', 'file1', '1', 'file1', 'definition');

INSERT INTO dataset_files (dataset_id, format) VALUES ('4', 'file_removeAllByFileFormat');
INSERT INTO dataset_files (dataset_id, format) VALUES ('4', 'file_removeAllByFileField');
INSERT INTO dataset_files (dataset_id, format) VALUES ('4', 'file1');

INSERT INTO file_field (data, format, is_mandatory, mask, position) VALUES ('altitudemax', 'file_removeAllByFileFormat', '0', '', '1');
INSERT INTO file_field (data, format, is_mandatory, mask, position) VALUES ('altitudemax', 'file_removeAllByFileField', '0', '', '1');
INSERT INTO file_field (data, format, is_mandatory, mask, position) VALUES ('altitudemax', 'file1', '0', '', '0');
INSERT INTO file_field (data, format, is_mandatory, mask, position) VALUES ('altitudemin', 'file1', '0', '', '1');

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'file_removeAllByFileFormat', 'altitudemax', 'table1', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'file_removeAllByFileField', 'altitudemax', 'table1', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'file1', 'altitudemax', 'table_removeAllByTableFormat', 'FILE');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'file1', 'altitudemax', 'table_removeAllByTableField', 'FILE');
