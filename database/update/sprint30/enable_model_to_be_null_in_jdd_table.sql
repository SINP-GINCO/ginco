ALTER TABLE raw_data.jdd ALTER COLUMN model_id DROP NOT NULL;

UPDATE raw_data.jdd SET model_id = NULL where status = 'deleted';