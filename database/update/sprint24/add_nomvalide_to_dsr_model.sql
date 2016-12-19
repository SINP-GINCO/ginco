--fixme: ce script met à jour metadata_work pour le modèle DEE (qui joue le rôle de modèle de DSR.)
--il faut donc dépublier et republier le modèle DEE pour prendre en compte les modifications.
--Pour les modèles autres il faut les dépublier, ajouter les champs avec le configurateur, et republier.

INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('nomvalide','CharacterString','nomValide','Le nomValide est le nom du taxon correspondant au cd_ref',NULL);

INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('nomvalide','CharacterString','nomValide','Le nomValide est le nom du taxon correspondant au cd_ref',NULL);

INSERT INTO metadata_work.field VALUES ('nomvalide', 'form_observation', 'FORM');
INSERT INTO metadata_work.field VALUES ('nomvalide', 'file_observation', 'FILE');
INSERT INTO metadata_work.field VALUES ('nomvalide', 'table_observation', 'TABLE');

INSERT INTO metadata_work.form_field VALUES ('nomvalide', 'form_observation', '1', '1', 'TEXT', 104, '0', '0', NULL, NULL, NULL);

INSERT INTO metadata_work.table_field VALUES ('nomvalide', 'table_observation', 'nomvalide', '1', '1', '1', '0', 104, NULL);

INSERT INTO metadata_work.file_field (data, format, is_mandatory, mask, "position") VALUES ('nomvalide','file_observation','0', NULL, 89);

INSERT INTO metadata_work.field_mapping VALUES ('nomvalide', 'file_observation', 'nomvalide', 'table_observation', 'FILE');

INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomvalide');