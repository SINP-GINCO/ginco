UPDATE metadata_work.data SET unit='Time' WHERE unit ='TIME';
UPDATE metadata.data SET unit='Time' WHERE unit ='TIME';
UPDATE metadata_work.unit SET unit='Time' WHERE unit ='TIME';
UPDATE metadata.unit SET unit='Time' WHERE unit ='TIME';

UPDATE metadata_work.form_field SET mask='yyyy-MM-dd' WHERE data='datedetermination';
UPDATE metadata.form_field SET mask='yyyy-MM-dd' WHERE data='datedetermination';
UPDATE metadata_work.file_field SET mask='yyyy-MM-dd' WHERE data='datedetermination';
UPDATE metadata.file_field SET mask='yyyy-MM-dd' WHERE data='datedetermination';