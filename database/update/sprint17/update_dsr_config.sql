--fixme: ce script met à jour metadata_work pour le modèle DEE (qui joue le rôle de modèle de DSR.)
--il faut donc dépublier et republier le modèle DEE pour prendre en compte les modifications.
--Pour les modèles autres il faut les dépublier, ajouter les champs via le configurateur, et republier.

INSERT INTO metadata.dynamode(unit, sql) VALUES ('CodeMailleCalculeValue','SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO metadata.dynamode(unit, sql) VALUES ('CodeCommuneCalculeValue','SELECT insee_com as code, insee_com as label FROM referentiels.geofla_commune ORDER BY insee_com');
INSERT INTO metadata.dynamode(unit, sql) VALUES ('NomCommuneCalculeValue','SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label FROM referentiels.geofla_commune ORDER BY nom_com');
INSERT INTO metadata.dynamode(unit, sql) VALUES ('CodeDepartementCalculeValue','SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label FROM referentiels.geofla_departement ORDER BY code_dept');

INSERT INTO metadata_work.dynamode(unit, sql) VALUES ('CodeMailleCalculeValue','SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO metadata_work.dynamode(unit, sql) VALUES ('CodeCommuneCalculeValue','SELECT insee_com as code, insee_com as label FROM referentiels.geofla_commune ORDER BY insee_com');
INSERT INTO metadata_work.dynamode(unit, sql) VALUES ('NomCommuneCalculeValue','SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label FROM referentiels.geofla_commune ORDER BY nom_com');
INSERT INTO metadata_work.dynamode(unit, sql) VALUES ('CodeDepartementCalculeValue','SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label FROM referentiels.geofla_departement ORDER BY code_dept');

INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('CodeMailleCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) de la ou des mailles','Code de la maille calculé');
INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('CodeCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) de la ou des commune(s)','Code de la commune calculé');
INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('NomCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Nom(s) calculé(s) de la ou des commune(s)','Nom de la commune calculé');
INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('CodeDepartementCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) du ou des département(s)','Code du département calculé');

INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('CodeMailleCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) de la ou des mailles','Code de la maille calculé');
INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('CodeCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) de la ou des commune(s)','Code de la commune calculé');
INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('NomCommuneCalculeValue','ARRAY','DYNAMIC','[Liste] Nom(s) calculé(s) de la ou des commune(s)','Nom de la commune calculé');
INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('CodeDepartementCalculeValue','ARRAY','DYNAMIC','[Liste] Code(s) calculé(s) du ou des département(s)','Code du département calculé');

INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('codemaillecalcule','CodeMailleCalculeValue','codeMailleCalcule','Code de la maille calculé', NULL);
INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('codecommunecalcule','CodeCommuneCalculeValue','codeCommuneCalcule','Code de la commune calculé',NULL);
INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('nomcommunecalcule','NomCommuneCalculeValue','nomCommuneCalcule','Nom de la commune calculé',NULL);
INSERT INTO metadata.data(data, unit, label, definition, comment) VALUES ('codedepartementcalcule','CodeDepartementCalculeValue','codeDepartementCalcule','Code du département calculé',NULL);
 
INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('codemaillecalcule','CodeMailleCalculeValue','codeMailleCalcule','Code de la maille calculé',NULL);
INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('codecommunecalcule','CodeCommuneCalculeValue','codeCommuneCalcule','Code de la commune calculé',NULL);
INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('nomcommunecalcule','NomCommuneCalculeValue','nomCommuneCalcule','Nom de la commune calculé',NULL);
INSERT INTO metadata_work.data(data, unit, label, definition, comment) VALUES ('codedepartementcalcule','CodeDepartementCalculeValue','codeDepartementCalcule','Code du département calculé',NULL);

UPDATE metadata.unit SET subtype='STRING' WHERE unit='NomCommuneValue';
UPDATE metadata_work.unit SET subtype='STRING' WHERE unit='NomCommuneValue';

UPDATE metadata.form_field SET input_type='TEXT' WHERE data='nomcommune';
UPDATE metadata_work.form_field SET input_type='TEXT' WHERE data='nomcommune';

UPDATE metadata_work.dataset SET label = 'Occ_Taxon_DSR_exemple_import',  definition = 'Dataset d import pour le modèle ''occ_taxon_dsr_exemple ''' WHERE dataset_id = 'dataset_1';
UPDATE metadata_work.dataset SET label = 'Occ_Taxon_DSR_exemple_visu',  definition = 'Dataset de visualisation pour le modèle ''occ_taxon_dsr_exemple''' WHERE dataset_id = 'dataset_2';;

INSERT INTO metadata_work.field VALUES ('codemaillecalcule', 'table_observation', 'TABLE');
INSERT INTO metadata_work.field VALUES ('codecommunecalcule', 'table_observation', 'TABLE');
INSERT INTO metadata_work.field VALUES ('nomcommunecalcule', 'table_observation', 'TABLE');
INSERT INTO metadata_work.field VALUES ('codedepartementcalcule', 'table_observation', 'TABLE');
INSERT INTO metadata_work.field VALUES ('codemaillecalcule', 'form_localisation', 'FORM');
INSERT INTO metadata_work.field VALUES ('codecommunecalcule', 'form_localisation', 'FORM');
INSERT INTO metadata_work.field VALUES ('nomcommunecalcule', 'form_localisation', 'FORM');
INSERT INTO metadata_work.field VALUES ('codedepartementcalcule', 'form_localisation', 'FORM');

UPDATE metadata_work.file_format SET label = 'dsr_exemple_observation', definition = 'fichier_dsr_exemple_observation' WHERE format = 'file_observation';

INSERT INTO metadata_work.form_field VALUES ('codemaillecalcule', 'form_localisation', '1', '1', 'SELECT', 98, '0', '0', NULL, NULL, NULL);
INSERT INTO metadata_work.form_field VALUES ('codecommunecalcule', 'form_localisation', '1', '1', 'SELECT', 99, '0', '0', NULL, NULL, NULL);
INSERT INTO metadata_work.form_field VALUES ('nomcommunecalcule', 'form_localisation', '1', '1', 'SELECT', 100, '0', '0', NULL, NULL, NULL);
INSERT INTO metadata_work.form_field VALUES ('codedepartementcalcule', 'form_localisation', '1', '1', 'SELECT', 101, '0', '0', NULL, NULL, NULL);

UPDATE metadata_work.model SET name = 'Occ_Taxon_DSR_exemple', description = 'Occ_Taxon_DSR_exemple' WHERE id = 'model_1';

INSERT INTO metadata_work.table_field VALUES ('codemaillecalcule', 'table_observation', 'codemaillecalcule', '1', '0', '1', '0', 98, NULL);
INSERT INTO metadata_work.table_field VALUES ('codecommunecalcule', 'table_observation', 'codecommunecalcule', '1', '0', '1', '0', 99, NULL);
INSERT INTO metadata_work.table_field VALUES ('nomcommunecalcule', 'table_observation', 'nomcommunecalcule', '1', '0', '1', '0', 100, NULL);
INSERT INTO metadata_work.table_field VALUES ('codedepartementcalcule', 'table_observation', 'codedepartementcalcule', '1', '0', '1', '0', 101, NULL);

INSERT INTO metadata_work.field_mapping VALUES ('codemaillecalcule', 'form_localisation', 'codemaillecalcule', 'table_observation', 'FORM');
INSERT INTO metadata_work.field_mapping VALUES ('codecommunecalcule', 'form_localisation', 'codecommunecalcule', 'table_observation', 'FORM');
INSERT INTO metadata_work.field_mapping VALUES ('nomcommunecalcule', 'form_localisation', 'nomcommunecalcule', 'table_observation', 'FORM');
INSERT INTO metadata_work.field_mapping VALUES ('codedepartementcalcule', 'form_localisation', 'codedepartementcalcule', 'table_observation', 'FORM');

INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codemaillecalcule');
INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codecommunecalcule');
INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomcommunecalcule');
INSERT INTO metadata_work.dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codedepartementcalcule');
