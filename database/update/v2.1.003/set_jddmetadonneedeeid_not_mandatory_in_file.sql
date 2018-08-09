-- This script is a copy of update/sprint28/update_jddMtdDEEId.sql
-- I do not understand why test-grandest have models that does not correspond to what must have been set by this script in sprint 28.
-- The only reason I found is a problem during deployment ????


-- set jddMetadonneeDEEId calculated (and still mandatory) in data models

UPDATE metadata.table_field SET is_calculated='1', is_editable='0', is_insertable='0', is_mandatory='1'
  WHERE column_name='jddmetadonneedeeid';
UPDATE metadata_work.table_field SET is_calculated='1', is_editable='0', is_insertable='0', is_mandatory='1'
WHERE column_name='jddmetadonneedeeid';

-- set jddMetadonneeDEEId not mandatory in import models

UPDATE metadata.file_field SET is_mandatory='0' WHERE data='jddmetadonneedeeid';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='jddmetadonneedeeid';