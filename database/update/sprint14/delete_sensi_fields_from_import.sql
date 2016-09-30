DELETE FROM metadata.field_mapping WHERE src_data = 'sensimanuelle' AND src_format = 'file_observation' AND dst_data = 'sensimanuelle' AND dst_format = 'table_observation' AND mapping_type = 'FILE';
DELETE FROM metadata.field_mapping WHERE src_data = 'sensialerte' AND src_format = 'file_observation' AND dst_data = 'sensimanuelle' AND dst_format = 'table_observation' AND mapping_type = 'FILE';
DELETE FROM metadata.file_field WHERE data = 'sensimanuelle' AND format = 'file_observation';
DELETE FROM metadata.file_field WHERE data = 'sensialerte' AND format = 'file_observation';

DELETE FROM metadata_work.field_mapping WHERE src_data = 'sensimanuelle' AND src_format = 'file_observation' AND dst_data = 'sensimanuelle' AND dst_format = 'table_observation' AND mapping_type = 'FILE';
DELETE FROM metadata_work.field_mapping WHERE src_data = 'sensialerte' AND src_format = 'file_observation' AND dst_data = 'sensimanuelle' AND dst_format = 'table_observation' AND mapping_type = 'FILE';
DELETE FROM metadata_work.file_field WHERE data = 'sensimanuelle' AND format = 'file_observation';
DELETE FROM metadata_work.file_field WHERE data = 'sensialerte' AND format = 'file_observation';
