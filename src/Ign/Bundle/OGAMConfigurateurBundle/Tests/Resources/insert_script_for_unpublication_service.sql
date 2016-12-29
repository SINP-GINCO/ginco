-- This script is used for model unpublication service test.

-- public schema is added to access postgis types and functions
SET search_path = metadata, public;

-- data for each table delete method

INSERT INTO data (data, unit, label, definition, comment) VALUES ('my_special_data', 'Integer', 'table_father FK', 'Foreign key towards table_father in model modele_to_publish', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_ID_table_son', 'IDString', 'Clé primaire', 'Clé primaire', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_ID_table_father', 'IDString', 'Clé primaire', 'Clé primaire', NULL);
INSERT INTO format (format, type) VALUES ('table_son', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_father', 'TABLE');
INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('my_special_data', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_son', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_father', 'table_father', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('model_2', 'model_to_publish', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('model_3', 'model_with_data', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_son', '_2_table_son', 'RAW_DATA', 'OGAM_ID_table_son, PROVIDER_ID', 'table_son', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_father', '_2_table_father', 'RAW_DATA', 'OGAM_ID_table_father, PROVIDER_ID', 'table_father', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table', '_3_table', 'RAW_DATA', 'OGAM_ID_table, PROVIDER_ID', 'table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_2', 'table_son');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_2', 'table_father');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_3', 'table');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'table_son', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_son', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('my_special_data', 'table_son', 'my_special_data', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'table_father', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'table_father', 'profondeurMax', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_son', 'table_son', 'ogam_id_table_son', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_father', 'table_father', 'ogam_id_table_father', '1');
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_son', 'table_father', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_father', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table', '*', NULL, NULL);

CREATE TABLE RAW_DATA.model_2_table_father(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT model_2_table_father_pkey PRIMARY KEY (ogam_id)
);

CREATE TABLE RAW_DATA.model_3_table(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT model_3_table_pkey PRIMARY KEY (ogam_id)
);

INSERT INTO RAW_DATA.model_3_table (ogam_id) VALUES ('1');

-- data for testGetImportModelsFromDataModel
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_dataset', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_other_dataset', 'my_other_dataset', '0', 'def', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('model_2', 'my_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('model_2', 'my_other_dataset');

-- data for testDeleteQueryDataset et testDeleteFormFields
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('query_dataset', 'query_dataset', '0', 'def', 'QUERY');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('model_2', 'query_dataset');

INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('query_dataset', 'RAW_DATA', 'table_son', 'altitudemin');
INSERT INTO dataset_fields (dataset_id, schema_code, format, data) VALUES ('query_dataset', 'RAW_DATA', 'table_son', 'altitudemax');

INSERT INTO format (format, type) VALUES ('form_table_son', 'FORM');
INSERT INTO form_format (format, label, definition, position, is_opened) VALUES ('form_table_son', 'form for table_son', 'form for table_son',1,1);
INSERT INTO dataset_forms (dataset_id, format) VALUES ('query_dataset', 'form_table_son');

INSERT INTO field (data, format, type) VALUES ('altitudemin', 'form_table_son', 'FORM');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'form_table_son', 'FORM');
INSERT INTO form_field (data, format, is_criteria, is_result, input_type, position, is_default_criteria, is_default_result) VALUES ('altitudemin', 'form_table_son', 1, 1, 'NUMERIC', 1, 0, 0);
INSERT INTO form_field (data, format, is_criteria, is_result, input_type, position, is_default_criteria, is_default_result) VALUES ('altitudemax', 'form_table_son', 1, 1, 'NUMERIC', 2, 0, 0);

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemin', 'form_table_son', 'altitudemin', 'table_son', 'FORM');
INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type) VALUES ('altitudemax', 'form_table_son', 'altitudemax', 'table_son', 'FORM');


-- data for testUnpublish simple model
INSERT INTO format (format, type) VALUES ('simple_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'simple_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'simple_table', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'simple_model', 'model used for unpublishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('simple_table', '_4_simple_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'simple_table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'simple_table');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'simple_table', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'simple_table', 'profondeurMax', '0');

CREATE TABLE RAW_DATA._4_simple_table(
	OGAM_ID bigint NOT NULL,
	CONSTRAINT _4_simple_table_pkey PRIMARY KEY (ogam_id)
);

-- data for testUnpublish complex model

INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'Integer', 'complex_table2 FK', 'Foreign key towards complex_table2 in model complex_model', NULL);
INSERT INTO format (format, type) VALUES ('complex_table1', 'TABLE');
INSERT INTO format (format, type) VALUES ('complex_table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('THE_GEOM', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'complex_table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'complex_table2', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'complex_model', 'model used for unpublishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('complex_table1', '_5_complex_table1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'complex_table1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('complex_table2', '_5_complex_table2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'complex_table2', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'complex_table1');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'complex_table2');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'complex_table1', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'complex_table1', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'complex_table1', 'OGAM_FK_5__COMPLEX_TABLE2', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('THE_GEOM', 'complex_table1', 'THE_GEOM', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'complex_table2', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'complex_table2', 'profondeurMax', '0');
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'complex_table1', 'complex_table2', NULL, NULL);

CREATE SEQUENCE RAW_DATA.ogam_id_5_complex_table2_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;
	
CREATE SEQUENCE RAW_DATA.ogam_id_5_complex_table1_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;
	
CREATE TABLE RAW_DATA._5_complex_table2(
	OGAM_ID bigint NOT NULL DEFAULT nextval('raw_data.ogam_id_5_complex_table2_seq'::regclass),
	CONSTRAINT _4_complex_table2_pkey PRIMARY KEY (ogam_id)
);

CREATE TABLE RAW_DATA._5_complex_table1(
	OGAM_ID bigint NOT NULL DEFAULT nextval('raw_data.ogam_id_5_complex_table2_seq'::regclass),
	the_geom geometry(Geometry,4326),
  
	CONSTRAINT _5_complex_table1_pkey PRIMARY KEY (ogam_id),
	CONSTRAINT ogam_fk_5__5_complex_table1 FOREIGN KEY (ogam_id)
      REFERENCES raw_data._5_complex_table2 (ogam_id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- data test for testDropTables and testDropSequences
INSERT INTO model (id, name, description, schema_code) VALUES ('6', 'model_table_drop', 'model used for dropping tables', 'RAW_DATA');
INSERT INTO format (format, type) VALUES ('table_drop1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_drop2', 'TABLE');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_drop1', '_6_table_drop1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_drop1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_drop2', '_6_table_drop2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_drop2', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('6', 'table_drop1');
INSERT INTO model_tables (model_id, table_id) VALUES ('6', 'table_drop2');

CREATE SEQUENCE RAW_DATA.ogam_id_6_table_drop1_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;
	
CREATE SEQUENCE RAW_DATA.ogam_id_6_table_drop2_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;

CREATE TABLE RAW_DATA._6_table_drop1(
	OGAM_ID bigint NOT NULL DEFAULT nextval('raw_data.ogam_id_6_table_drop1_seq'::regclass),
	CONSTRAINT _6_table_drop1_pkey PRIMARY KEY (ogam_id)
);

CREATE TABLE RAW_DATA._6_table_drop2(
	OGAM_ID bigint NOT NULL DEFAULT nextval('raw_data.ogam_id_6_table_drop2_seq'::regclass),
	CONSTRAINT _6_table_drop2_pkey PRIMARY KEY (ogam_id)
);

SET search_path = metadata_work;

-- data for each table delete method
INSERT INTO data (data, unit, label, definition, comment) VALUES ('my_special_data', 'Integer', 'table_father FK', 'Foreign key towards table_father in model modele_to_publish', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_ID_table_son', 'CharacterString', 'Clé primaire', 'Clé primaire', NULL);
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_ID_table_father', 'CharacterString', 'Clé primaire', 'Clé primaire', NULL);
INSERT INTO format (format, type) VALUES ('table_son', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_father', 'TABLE');
INSERT INTO format (format, type) VALUES ('table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('my_special_data', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'table_father', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_son', 'table_son', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_ID_table_father', 'table_father', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('model_2', 'model_to_publish', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('model_3', 'model_with_data', 'model used for publishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_son', '_2_table_son', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_son', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_father', '_2_table_father', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_father', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table', '_3_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_2', 'table_son');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_2', 'table_father');
INSERT INTO model_tables (model_id, table_id) VALUES ('model_3', 'table');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'table_son', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'table_son', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('my_special_data', 'table_son', 'my_special_data', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'table_father', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'table_father', 'profondeurMax', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_son', 'table_son', 'ogam_id_table_son', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_ID_table_father', 'table_father', 'ogam_id_table_father', '1');
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_son', 'table_father', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table_father', '*', NULL, NULL);
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'table', '*', NULL, NULL);

-- data for testGetImportModelsFromDataModel
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_dataset', 'my_dataset', '1', 'def', 'IMPORT');
INSERT INTO dataset (dataset_id, label, is_default, definition, type) VALUES ('my_other_dataset', 'my_other_dataset', '0', 'def', 'IMPORT');

INSERT INTO model_datasets (model_id, dataset_id) VALUES ('model_2', 'my_dataset');
INSERT INTO model_datasets (model_id, dataset_id) VALUES ('model_2', 'my_other_dataset');

-- data for testUnpublish simple model
INSERT INTO format (format, type) VALUES ('simple_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'simple_table', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'simple_table', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'simple_model', 'model used for unpublishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('simple_table', '_4_simple_table', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'simple_table', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('4', 'simple_table');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'simple_table', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'simple_table', 'profondeurMax', '0');

-- data for testUnpublish complex model
INSERT INTO data (data, unit, label, definition, comment) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'Integer', 'complex_table2 FK', 'Foreign key towards complex_table2 in model complex_model', NULL);
INSERT INTO format (format, type) VALUES ('complex_table1', 'TABLE');
INSERT INTO format (format, type) VALUES ('complex_table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemin', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('altitudemax', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('THE_GEOM', 'complex_table1', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMin', 'complex_table2', 'TABLE');
INSERT INTO field (data, format, type) VALUES ('profondeurMax', 'complex_table2', 'TABLE');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'complex_model', 'model used for unpublishing tests', 'RAW_DATA');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('complex_table1', '_5_complex_table1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'complex_table1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('complex_table2', '_5_complex_table2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'complex_table2', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'complex_table1');
INSERT INTO model_tables (model_id, table_id) VALUES ('5', 'complex_table2');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemin', 'complex_table1', 'altitudemin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('altitudemax', 'complex_table1', 'altitudemax', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('OGAM_FK_5__COMPLEX_TABLE2', 'complex_table1', 'OGAM_FK_5__COMPLEX_TABLE2', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('THE_GEOM', 'complex_table1', 'THE_GEOM', '1');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMin', 'complex_table2', 'profondeurMin', '0');
INSERT INTO table_field (data, format, column_name, is_mandatory) VALUES ('profondeurMax', 'complex_table2', 'profondeurMax', '0');
INSERT INTO table_tree (schema_code, child_table, parent_table, join_key, comment) VALUES ('RAW_DATA', 'complex_table1', 'complex_table2', NULL, NULL);

-- data test for testDropTablesFromModel
INSERT INTO model (id, name, description, schema_code) VALUES ('6', 'model_table_drop', 'model used for dropping tables', 'RAW_DATA');
INSERT INTO format (format, type) VALUES ('table_drop1', 'TABLE');
INSERT INTO format (format, type) VALUES ('table_drop2', 'TABLE');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_drop1', '_6_table_drop1', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_drop1', 'description');
INSERT INTO table_format (format, table_name, schema_code, primary_key, label, definition) VALUES ('table_drop2', '_6_table_drop2', 'RAW_DATA', 'OGAM_ID, PROVIDER_ID', 'table_drop2', 'description');
INSERT INTO model_tables (model_id, table_id) VALUES ('6', 'table_drop1');
INSERT INTO model_tables (model_id, table_id) VALUES ('6', 'table_drop2');

