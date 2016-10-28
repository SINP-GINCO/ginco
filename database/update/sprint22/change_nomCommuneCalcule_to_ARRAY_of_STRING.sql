UPDATE metadata.unit SET subtype='STRING' WHERE unit='NomCommuneCalculeValue';
UPDATE metadata_work.unit SET subtype='STRING' WHERE unit='NomCommuneCalculeValue';

DELETE FROM metadata.dynamode WHERE unit='NomCommuneCalculeValue';
DELETE FROM metadata_work.dynamode WHERE unit='NomCommuneCalculeValue';

UPDATE metadata.form_field SET input_type='TEXT' WHERE data IN ('nomcommune','nomcommunecalcule');
UPDATE metadata_work.form_field SET input_type='TEXT' WHERE data IN ('nomcommune','nomcommunecalcule');
