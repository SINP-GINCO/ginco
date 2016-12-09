--Add new column
ALTER TABLE metadata.model ADD COLUMN is_ref BOOLEAN;
COMMENT ON COLUMN metadata.model.is_ref IS 'Wether the model is a reference or standard model or not';
ALTER TABLE metadata_work.model ADD COLUMN is_ref BOOLEAN;
COMMENT ON COLUMN metadata_work.model.is_ref IS 'Wether the model is a reference or standard model or not';
--Populate
UPDATE metadata.model SET is_ref = true
WHERE id = 'model_1';
UPDATE metadata_work.model SET is_ref = true
WHERE id = 'model_1';