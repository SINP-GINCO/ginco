
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='sensible';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='sensiniveau';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='sensidateattribution';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='sensireferentiel';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='sensiversionreferentiel';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='deedatetransformation';
DELETE FROM metadata.field_mapping WHERE mapping_type='FILE' AND src_data='deedatedernieremodification';

DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='sensible';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='sensiniveau';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='sensidateattribution';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='sensireferentiel';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='sensiversionreferentiel';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='deedatetransformation';
DELETE FROM metadata_work.field_mapping WHERE mapping_type='FILE' AND src_data='deedatedernieremodification';

DELETE FROM metadata.file_field WHERE data='sensible';
DELETE FROM metadata.file_field WHERE data='sensiniveau';
DELETE FROM metadata.file_field WHERE data='sensidateattribution';
DELETE FROM metadata.file_field WHERE data='sensireferentiel';
DELETE FROM metadata.file_field WHERE data='sensiversionreferentiel';
DELETE FROM metadata.file_field WHERE data='deedatetransformation';
DELETE FROM metadata.file_field WHERE data='deedatedernieremodification';

DELETE FROM metadata_work.file_field WHERE data='sensible';
DELETE FROM metadata_work.file_field WHERE data='sensiniveau';
DELETE FROM metadata_work.file_field WHERE data='sensidateattribution';
DELETE FROM metadata_work.file_field WHERE data='sensireferentiel';
DELETE FROM metadata_work.file_field WHERE data='sensiversionreferentiel';
DELETE FROM metadata_work.file_field WHERE data='deedatetransformation';
DELETE FROM metadata_work.file_field WHERE data='deedatedernieremodification';

DELETE FROM metadata.field WHERE data='sensible' AND type='FILE';
DELETE FROM metadata.field WHERE data='sensiniveau' AND type='FILE';
DELETE FROM metadata.field WHERE data='sensidateattribution' AND type='FILE';
DELETE FROM metadata.field WHERE data='sensireferentiel' AND type='FILE';
DELETE FROM metadata.field WHERE data='sensiversionreferentiel' AND type='FILE';
DELETE FROM metadata.field WHERE data='deedatetransformation' AND type='FILE';
DELETE FROM metadata.field WHERE data='deedatedernieremodification' AND type='FILE';

DELETE FROM metadata_work.field WHERE data='sensible' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='sensiniveau' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='sensidateattribution' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='sensireferentiel' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='sensiversionreferentiel' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='deedatetransformation' AND type='FILE';
DELETE FROM metadata_work.field WHERE data='deedatedernieremodification' AND type='FILE';

UPDATE metadata.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='sensible';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='sensiniveau';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensidateattribution';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensireferentiel';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensiversionreferentiel';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='deedatetransformation';
UPDATE metadata.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='deedatedernieremodification';

UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='sensible';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='sensiniveau';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensidateattribution';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensireferentiel';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0' WHERE data='sensiversionreferentiel';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='deedatetransformation';
UPDATE metadata_work.table_field SET is_calculated='1', is_insertable='0', is_mandatory='1' WHERE data='deedatedernieremodification';
