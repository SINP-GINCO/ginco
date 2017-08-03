-- Add label_csv column to file_field
ALTER TABLE metadata.file_field ADD COLUMN label_csv varchar(60);
ALTER TABLE metadata_work.file_field ADD COLUMN label_csv varchar(60);

-- Fill it with data.label
UPDATE metadata_work.file_field SET label_csv =
(SELECT data.label
  FROM data
  WHERE data.data = file_field.data)
  
UPDATE metadata.file_field SET label_csv =
(SELECT data.label
  FROM data
  WHERE data.data = file_field.data)

-- Add unicity constraint
ALTER TABLE metadata.file_field ADD UNIQUE (format, label_csv);
ALTER TABLE metadata_work.file_field ADD UNIQUE (format, label_csv);
  
-- Add checks for file header
INSERT INTO metadata.checks(check_id, step, name, label, description, statement, importance) VALUES ('1114', 'COMPLIANCE', 'WRONG_FILE_FIELD_CSV_LABEL', 'Nom du champ incorrect.', 'Le nom de la colonne du fichier csv n''existe pas dans le modèle d''import.', null, 'ERROR');
INSERT INTO metadata.checks(check_id, step, name, label, description, statement, importance) VALUES ('1115', 'COMPLIANCE', 'DUPLICATED_FILE_LABEL', 'Des noms de colonnes sont en double.', 'Des noms de colonnes sont en double.', null, 'ERROR');
INSERT INTO metadata.checks(check_id, step, name, label, description, statement, importance) VALUES ('1116', 'COMPLIANCE', 'MANDATORY_HEADER_LABEL_MISSING', 'Colonne obligatoire manquante.	', 'Colonne obligatoire manquante, veuillez l''ajouter à votre fichier.', null, 'ERROR');

INSERT INTO metadata_work.checks(check_id, step, name, label, description, statement, importance) VALUES ('1114', 'COMPLIANCE', 'WRONG_FILE_FIELD_CSV_LABEL', 'Nom du champ incorrect.', 'Le nom de la colonne du fichier csv n''existe pas dans le modèle d''import.', null, 'ERROR');
INSERT INTO metadata_work.checks(check_id, step, name, label, description, statement, importance) VALUES ('1115', 'COMPLIANCE', 'DUPLICATED_FILE_LABEL', 'Des noms de colonnes sont en double.', 'Des noms de colonnes sont en double.', null, 'ERROR');
INSERT INTO metadata_work.checks(check_id, step, name, label, description, statement, importance) VALUES ('1116', 'COMPLIANCE', 'MANDATORY_HEADER_LABEL_MISSING', 'Colonne obligatoire manquante.	', 'Colonne obligatoire manquante, veuillez l''ajouter à votre fichier.', null, 'ERROR');
