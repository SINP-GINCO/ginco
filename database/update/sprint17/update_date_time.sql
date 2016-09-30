--fixme: ce script met à jour metadata_work pour le modèle DEE (qui joue le rôle de modèle de DSR.)
--il faut donc dépublier et republier le modèle DEE pour prendre en compte les modifications.
--Pour les modèles autres il faut les dépublier, ajouter les champs avec le configurateur, et republier.

INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('Time','TIME',NULL,'time',NULL);

INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('Time','TIME',NULL,'time',NULL);

INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('heuredatedebut','Time','heureDateDebut','Heure du début de l''observation',NULL);
INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('heuredatefin','Time','heureDateFin','Heure de la fin de l''observation',NULL);

INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('heuredatedebut','Time','heureDateDebut','Heure du début de l''observation',NULL);
INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('heuredatefin','Time','heureDateFin','Heure de la fin de l''observation',NULL);

INSERT INTO metadata_work.field VALUES ('heuredatedebut', 'form_observation', 'FORM');
INSERT INTO metadata_work.field VALUES ('heuredatefin', 'form_observation', 'FORM');
INSERT INTO metadata_work.field VALUES ('heuredatedebut', 'file_observation', 'FILE');
INSERT INTO metadata_work.field VALUES ('heuredatefin', 'file_observation', 'FILE');
INSERT INTO metadata_work.field VALUES ('heuredatedebut', 'table_observation', 'TABLE');
INSERT INTO metadata_work.field VALUES ('heuredatefin', 'table_observation', 'TABLE');

INSERT INTO metadata_work.form_field VALUES ('heuredatedebut', 'form_observation', '1', '1', 'TIME', 102, '0', '0', NULL, NULL, 'HH:mm');
INSERT INTO metadata_work.form_field VALUES ('heuredatefin', 'form_observation', '1', '1', 'TIME', 103, '0', '0', NULL, NULL, 'HH:mm');

INSERT INTO metadata_work.table_field VALUES ('heuredatedebut', 'table_observation', 'heuredatedebut', '0', '1', '1', '1', 102, NULL);
INSERT INTO metadata_work.table_field VALUES ('heuredatefin', 'table_observation', 'heuredatefin', '0', '1', '1', '1', 103, NULL);

INSERT INTO metadata_work.file_field (data, format, is_mandatory, mask, "position") VALUES ('heuredatedebut','file_observation','1','HH:mm',94);
INSERT INTO metadata_work.file_field (data, format, is_mandatory, mask, "position") VALUES ('heuredatefin','file_observation','1','HH:mm',95);

INSERT INTO metadata_work.field_mapping VALUES ('heuredatedebut', 'form_observation', 'heuredatedebut', 'table_observation', 'FORM');
INSERT INTO metadata_work.field_mapping VALUES ('heuredatefin', 'form_observation', 'heuredatefin', 'table_observation', 'FORM');
INSERT INTO metadata_work.field_mapping VALUES ('heuredatedebut', 'file_observation', 'heuredatedebut', 'table_observation', 'FILE');
INSERT INTO metadata_work.field_mapping VALUES ('heuredatefin', 'file_observation', 'heuredatefin', 'table_observation', 'FILE');

INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatedebut');
INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatefin');




UPDATE metadata_work.data SET data='jourdatedebut', label = 'jourDateDebut', definition= 'Jour du début de l''observation' WHERE data='datedebut';
UPDATE metadata_work.data SET data='jourdatefin', label = 'jourDateFin', definition= 'Jour du fin de l''observation' WHERE data='datefin';

UPDATE metadata_work.file_field SET mask='yyyy-MM-dd' WHERE data='jourdatedebut';
UPDATE metadata_work.file_field SET mask='yyyy-MM-dd' WHERE data='jourdatefin';

UPDATE metadata_work.table_field SET column_name='jourdatedebut' WHERE data='jourdatedebut';
UPDATE metadata_work.table_field SET column_name='jourdatefin' WHERE data='jourdatefin';

UPDATE metadata_work.form_field SET mask='yyyy-MM-dd' WHERE data='jourdatedebut';
UPDATE metadata_work.form_field SET mask='yyyy-MM-dd' WHERE data='jourdatefin';

UPDATE metadata_work.field_mapping SET dst_data='jourdatedebut' WHERE src_data='jourdatedebut';
UPDATE metadata_work.field_mapping SET dst_data='jourdatefin' WHERE src_data='jourdatefin';




UPDATE metadata.data SET data='jourdatedebut', label = 'jourDateDebut', definition= 'Jour du début de l''observation' WHERE data='datedebut';
UPDATE metadata.data SET data='jourdatefin', label = 'jourDateFin', definition= 'Jour du fin de l''observation' WHERE data='datefin';

UPDATE metadata.file_field SET mask='yyyy-MM-dd' WHERE data='jourdatedebut';
UPDATE metadata.file_field SET mask='yyyy-MM-dd' WHERE data='jourdatefin';

UPDATE metadata.table_field SET column_name='jourdatedebut' WHERE data='jourdatedebut';
UPDATE metadata.table_field SET column_name='jourdatefin' WHERE data='jourdatefin';

UPDATE metadata.form_field SET mask='yyyy-MM-dd' WHERE data='jourdatedebut';
UPDATE metadata.form_field SET mask='yyyy-MM-dd' WHERE data='jourdatefin';

UPDATE metadata_work.field_mapping SET dst_data='jourdatedebut' WHERE src_data='jourdatedebut';
UPDATE metadata_work.field_mapping SET dst_data='jourdatefin' WHERE src_data='jourdatefin';

