--#1299: Remove mandatory parameter for heuredatedebut and heuredatefin and set to calculated
ALTER TABLE model_1_observation ALTER COLUMN heuredatedebut DROP NOT NULL;
ALTER TABLE model_1_observation ALTER COLUMN heuredatefin DROP NOT NULL;

UPDATE metadata_work.table_field SET is_calculated = '1', is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'table_observation';
UPDATE metadata_work.file_field SET is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'file_observation';
UPDATE metadata.table_field SET is_calculated = '1', is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'table_observation';
UPDATE metadata.file_field SET is_mandatory = '0' WHERE data IN('heuredatedebut', 'heuredatefin') AND format = 'file_observation';