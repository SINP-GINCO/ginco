-- This script is used for dataset import controller test.

SET search_path = metadata_work;

INSERT INTO dataset (dataset_id, label, type) VALUES ('1', 'import_2', 'IMPORT');
INSERT INTO dataset (dataset_id, label, type) VALUES ('2', 'import_1', 'IMPORT');
INSERT INTO dataset (dataset_id, label, type) VALUES ('3', 'import_bis', 'INPUT');
INSERT INTO dataset (dataset_id, label, type) VALUES ('4', 'import_ok', 'IMPORT');
INSERT INTO dataset (dataset_id, label, type) VALUES ('5', 'import_152_a', 'IMPORT');
