-- extra spaces had been inserted at the end of label_csv, and mapping_type, making import not working...
UPDATE metadata.file_field SET label_csv=trim(trailing from label_csv);
UPDATE metadata.field_mapping SET mapping_type=trim(trailing from mapping_type);

UPDATE metadata_work.file_field SET label_csv=trim(trailing from label_csv);
UPDATE metadata_work.field_mapping SET mapping_type=trim(trailing from mapping_type);