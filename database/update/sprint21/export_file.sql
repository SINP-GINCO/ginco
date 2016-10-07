ALTER TABLE raw_data.export_file
  DROP COLUMN file_size;
ALTER TABLE raw_data.export_file
  ALTER COLUMN created_at SET DEFAULT now();

