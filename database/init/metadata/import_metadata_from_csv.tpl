-- script de peuplement de metadata ou metadata_work
/*==============================================================*/
/*	Metamodel initialization - populate script
	Reads and copies data from CSV files to metadata
	or metadata_work schema, which are generated from
	metadata.ods
	To update data, modify the metadata.ods file first
	then generate the CSV files, and run this script		*/
/*==============================================================*/

SET client_encoding='UTF8';
SET search_path TO @SCHEMA@, public;

BEGIN;
SET CONSTRAINTS ALL DEFERRED;

--
-- Remove old data
--
delete from translation;
delete from table_tree;
delete from event_listener;

delete from file_field;
delete from table_field;
delete from form_field;
delete from field_mapping;
delete from dataset_fields;
delete from model_tables;
delete from dataset_files;

delete from group_mode;
delete from checks_per_provider;
delete from checks;
delete from model_datasets;
delete from dataset_forms;

delete from form_format;
delete from file_format;
delete from table_format;

delete from field;
delete from format;
delete from dynamode;
delete from mode_tree;
delete from mode;
delete from range;
delete from data;
delete from unit;
delete from model;
delete from dataset;
delete from table_schema;

@INSERT@ unit.csv
@INSERT@ data.csv
@INSERT@ range.csv
@INSERT@ mode.csv
@INSERT@ group_mode.csv
@INSERT@ mode_tree.csv
@INSERT@ dataset.csv
@INSERT@ dynamode.csv
@INSERT@ form_format.csv
@INSERT@ table_schema.csv
@INSERT@ model.csv
@INSERT@ table_format.csv
@INSERT@ model_tables.csv
@INSERT@ model_datasets.csv
@INSERT@ file_format.csv
@INSERT@ event_listener.csv

-- Fill the parent table
INSERT INTO format (format, type)
SELECT format, 'FILE'
FROM   file_format;

INSERT INTO format (format, type)
SELECT format, 'TABLE'
FROM   table_format;

INSERT INTO format (format, type)
SELECT format, 'FORM'
FROM   form_format;

@INSERT@ form_field.csv
@INSERT@ file_field.csv
@INSERT@ table_field.csv

-- Fill the parent table
INSERT INTO field (data, format, type)
SELECT data, format, 'FILE'
FROM   file_field;

INSERT INTO field (data, format, type)
SELECT data, format, 'TABLE'
FROM   table_field;

INSERT INTO field (data, format, type)
SELECT data, format, 'FORM'
FROM   form_field;


@INSERT@ field_mapping.csv

@INSERT@ checks.csv
@INSERT@ checks_per_provider.csv

@INSERT@ dataset_fields.csv
@INSERT@ dataset_files.csv
@INSERT@ dataset_forms.csv

@INSERT@ table_tree.csv

@INSERT@ translation.csv


-- Fill the empty label and definition for the need of the tests
UPDATE translation t
   SET label= 'EN...' || t2.label
   FROM translation t2
 WHERE t.table_format = t2.table_format and t.row_pk = t2.row_pk and t.lang = 'EN' and t2.lang = 'FR' and t.label is null;

 UPDATE translation t
   SET definition= 'EN...' || t2.definition
   FROM translation t2
 WHERE t.table_format = t2.table_format and t.row_pk = t2.row_pk and t.lang = 'EN' and t2.lang = 'FR' and t.definition is null;

COMMIT;

--
-- Consistency checks
--

-- Units of type CODE should have an entry in the CODE table
SELECT UNIT, 'This unit of type CODE is not described in the MODE table'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'MODE'
AND unit not in (SELECT UNIT FROM MODE WHERE MODE.UNIT=UNIT)
UNION
-- Units of type RANGE should have an entry in the RANGE table
SELECT UNIT, 'This unit of type RANGE is not described in the RANGE table'
FROM unit
WHERE TYPE = 'NUMERIC' AND SUBTYPE = 'RANGE'
AND unit not in (SELECT UNIT FROM RANGE WHERE RANGE.UNIT=UNIT)
UNION
-- File fields should have a FILE mapping
SELECT format||'_'||data, 'This file field has no FILE mapping defined'
FROM file_field
WHERE format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'FILE'
	)
UNION
-- Form fields should have a FORM mapping
SELECT format||'_'||data, 'This form field has no FORM mapping defined'
FROM form_field
WHERE format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'FORM'
	)
UNION
-- Raw data field should be mapped with harmonized fields
SELECT format||'_'||data, 'This raw_data table field is not mapped with an harmonized field'
FROM table_field
JOIN table_format using (format)
WHERE schema_code = 'RAW_DATA'
AND data <> 'SUBMISSION_ID'
AND data <> 'LINE_NUMBER'
AND format||'_'||data NOT IN (
	SELECT (src_format||'_'||src_data )
	FROM field_mapping
	WHERE mapping_type = 'HARMONIZE'
	)
UNION
-- Raw data field should be mapped with harmonized fields
SELECT format||'_'||data, 'This harmonized_data table field is not used by a mapping'
FROM table_field
JOIN table_format using (format)
WHERE schema_code = 'HARMONIZED_DATA'
AND column_name <> 'REQUEST_ID'  -- request ID added automatically
AND is_calculated <> '1'  -- field is not calculated
AND format||'_'||data NOT IN (
	SELECT (dst_format||'_'||dst_data )
	FROM field_mapping
	WHERE mapping_type = 'HARMONIZE'
	)
UNION
-- the SUBMISSION_ID field is mandatory for raw data tables
SELECT format, 'This raw table format is missing the SUBMISSION_ID field'
FROM table_format
WHERE schema_code = 'RAW_DATA'
AND NOT EXISTS (SELECT * FROM table_field WHERE table_format.format = table_field.format AND table_field.data='SUBMISSION_ID')
UNION
-- the INPUT_TYPE is not in the list
SELECT format||'_'||data, 'The INPUT_TYPE type is not in the list'
FROM form_field
WHERE input_type NOT IN ('TEXT', 'SELECT', 'DATE', 'GEOM', 'NUMERIC', 'CHECKBOX', 'MULTIPLE', 'TREE', 'TAXREF', 'IMAGE')
UNION
-- the UNIT type is not in the list
SELECT unit||'_'||type, 'The UNIT type is not in the list'
FROM unit
WHERE type NOT IN ('BOOLEAN', 'CODE', 'ARRAY', 'DATE', 'INTEGER', 'NUMERIC', 'STRING', 'GEOM', 'IMAGE')
UNION
-- the subtype is not consistent with the type
SELECT unit||'_'||type, 'The UNIT subtype is not consistent with the type'
FROM unit
WHERE (type = 'CODE' AND subtype NOT IN ('MODE', 'TREE', 'DYNAMIC', 'TAXREF'))
OR    (type = 'ARRAY' AND subtype NOT IN ('MODE', 'TREE', 'DYNAMIC'))
OR    (type = 'NUMERIC' AND subtype NOT IN ('RANGE', 'COORDINATE'))
UNION
-- the unit type is not consistent with the form field input type
SELECT form_field.format || '_' || form_field.data, 'The form field input type (' || input_type || ') is not consistent with the unit type (' || type || ')'
FROM form_field
LEFT JOIN data using (data)
LEFT JOIN unit using (unit)
WHERE (input_type = 'NUMERIC' AND type NOT IN ('NUMERIC', 'INTEGER'))
OR (input_type = 'DATE' AND type <> 'DATE')
OR (input_type = 'SELECT' AND NOT (type = 'ARRAY' or TYPE = 'CODE') AND (subtype = 'CODE' OR subtype = 'DYNAMIC'))
OR (input_type = 'TEXT' AND type <> 'STRING')
OR (input_type = 'CHECKBOX' AND type <> 'BOOLEAN')
OR (input_type = 'GEOM' AND type <> 'GEOM')
OR (input_type = 'IMAGE' AND type <> 'IMAGE')
OR (input_type = 'TREE' AND NOT ((type = 'ARRAY' or TYPE = 'CODE') AND subtype = 'TREE'))
UNION
-- TREE_MODEs should be defined
SELECT unit, 'The unit should have at least one MODE_TREE defined'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'TREE'
AND (SELECT count(*) FROM mode_tree WHERE mode_tree.unit = unit.unit) = 0
UNION
-- DYNAMODEs should be defined
SELECT unit, 'The unit should have at least one DYNAMODE defined'
FROM unit
WHERE (type = 'CODE' OR type = 'ARRAY')
AND subtype = 'DYNAMIC'
AND (SELECT count(*) FROM dynamode WHERE dynamode.unit = unit.unit) = 0
