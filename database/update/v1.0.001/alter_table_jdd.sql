-- Remove unique constraint on jdd_metadata_id column
ALTER TABLE raw_data.jdd DROP CONSTRAINT IF EXISTS jdd_jdd_metadata_id_key;
-- Rename the column referenced in the foreign key constraint towards export_file
ALTER TABLE raw_data.jdd DROP CONSTRAINT IF EXISTS fk_export_file_id;
ALTER TABLE raw_data.jdd ADD CONSTRAINT fk_export_file_id FOREIGN KEY (export_file_id)
REFERENCES raw_data.export_file (id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE SET NULL;
-- Update status for deleted instead of suppressed
COMMENT ON COLUMN jdd.status IS 'jdd status, can be ''empty'' (jdd created and active, no DSR nor DEE), ''active'' (at least the DSR or the DEE is created), ''deleted'' (deleted, but the row is kept)';