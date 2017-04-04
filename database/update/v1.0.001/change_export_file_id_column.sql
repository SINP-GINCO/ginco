-- Rename export_file table id column
ALTER TABLE raw_data.export_file RENAME COLUMN submission_id TO id;
-- Remove foreign constraint towards submission
ALTER TABLE raw_data.export_file DROP CONSTRAINT IF EXISTS fk_submission_id;
-- Change its type to serial (step-by-step as serial is not recognized for alter table)
CREATE SEQUENCE raw_data.export_file_id_seq;
ALTER TABLE export_file ALTER COLUMN id SET DATA TYPE integer;
ALTER TABLE export_file ALTER COLUMN id SET NOT NULL;
ALTER TABLE export_file ALTER COLUMN id SET DEFAULT nextval('raw_data.export_file_id_seq');
-- Grant rights
GRANT ALL ON SEQUENCE raw_data.export_file_id_seq TO ogam;