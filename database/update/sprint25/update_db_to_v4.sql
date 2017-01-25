/* Script add_extension_pg_trgm must be launched before this one */


set search_path to mapping;

/* Table mapping.scales is renamed in zoom_level, and columns are added */

CREATE TABLE zoom_level
(
  zoom_level           INT    NOT NULL,            -- The level of zoom
  resolution           DOUBLE PRECISION NOT NULL,  -- The resolution value
  approx_scale_denom   INT    NOT NULL,            -- The approximate scale denominator value corresponding to the resolution
  scale_label          VARCHAR(10),                -- Label used for the zoom level
  is_map_zoom_level    BOOLEAN,                    -- Indicates if that zoom level must be used for the map
  PRIMARY KEY  (zoom_level)
) WITHOUT OIDS;

COMMENT ON COLUMN zoom_level.zoom_level IS 'The level of zoom';
COMMENT ON COLUMN zoom_level.resolution IS 'The resolution value';
COMMENT ON COLUMN zoom_level.approx_scale_denom IS 'The approximate scale denominator value corresponding to the resolution';
COMMENT ON COLUMN zoom_level.scale_label IS 'Label used for the zoom level';
COMMENT ON COLUMN zoom_level.is_map_zoom_level IS 'Indicates if that zoom level must be used for the map';

INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (0, 156543.0339280410, 559082264, '1:560M', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (1, 78271.5169640205, 279541132, '1:280M', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (2, 39135.7584820102, 139770566, '1:140M', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (3, 19567.8792410051, 69885283, '1:70M', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (4, 9783.9396205026, 34942642, '1:35M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (5, 4891.9698102513, 17471321, '1:17M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (6, 2445.9849051256, 8735660, '1:8,7M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (7, 1222.9924525628, 4367830, '1:4,4M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (8, 611.4962262814, 2183915, '1:2,2M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (9, 305.7481131407, 1091958, '1:1,1M', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (10, 152.8740565704, 545979, '1:546K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (11, 76.4370282852, 272989, '1:273K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (12, 38.2185141426, 136495, '1:136K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (13, 19.1092570713, 68247, '1:68K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (14, 9.5546285356, 34124, '1:34K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (15, 4.7773142678, 17062, '1:17K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (16, 2.3886571339, 8531, '1:8,5K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (17, 1.1943285670, 4265, '1:4,3K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (18, 0.5971642835, 2133, '1:2,1K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (19, 0.2985821417, 1066, '1:1,1K', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (20, 0.1492910709, 533, '1:533', FALSE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (21, 0.0746455354, 267, '1:267', FALSE);


DROP TABLE IF EXISTS scales;


/* In mapping.layer_service rename column service_name to name */
ALTER TABLE layer_service RENAME COLUMN service_name TO name;


/* In mapping.layer rename or delete columns, add foreign keys */
ALTER TABLE layer RENAME COLUMN layer_name TO name;
ALTER TABLE layer RENAME COLUMN layer_label TO label;
ALTER TABLE layer RENAME COLUMN isTransparent TO is_transparent;
ALTER TABLE layer RENAME COLUMN isBaseLayer TO is_base_layer;
ALTER TABLE layer RENAME COLUMN isUntiled TO is_untiled;
ALTER TABLE layer RENAME COLUMN maxscale TO max_zoom_level;
ALTER TABLE layer RENAME COLUMN minscale TO min_zoom_level;

UPDATE layer SET max_zoom_level=11 WHERE max_zoom_level= 272989;
UPDATE layer SET max_zoom_level=7 WHERE max_zoom_level= 4367830;
UPDATE layer SET max_zoom_level=9 WHERE max_zoom_level= 1091958;
UPDATE layer SET max_zoom_level=5 WHERE max_zoom_level= 17471321;
UPDATE layer SET min_zoom_level=11 WHERE min_zoom_level= 272989;
UPDATE layer SET min_zoom_level=7 WHERE min_zoom_level= 4367830;

ALTER TABLE layer ADD FOREIGN KEY (max_zoom_level) REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE layer ADD FOREIGN KEY (min_zoom_level) REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE layer ADD FOREIGN KEY (view_service_name) REFERENCES mapping.layer_service (name) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE layer ADD FOREIGN KEY (legend_service_name) REFERENCES mapping.layer_service (name) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE layer ADD FOREIGN KEY (detail_service_name) REFERENCES mapping.layer_service (name) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE layer ADD FOREIGN KEY (feature_service_name) REFERENCES mapping.layer_service (name) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON TABLE layer IS 'Liste des layers';
COMMENT ON COLUMN layer.name IS 'Logical name of the layer';
COMMENT ON COLUMN layer.label IS 'Label of the layer';
COMMENT ON COLUMN layer.is_transparent IS 'Indicate if the layer is transparent';
COMMENT ON COLUMN layer.is_base_layer IS 'Indicate if the layer is a base layer (or an overlay)';
COMMENT ON COLUMN layer.is_untiled IS 'Force OpenLayer to request one image each time';
COMMENT ON COLUMN layer.max_zoom_level IS 'Max zoom level of apparation';
COMMENT ON COLUMN layer.min_zoom_level IS 'Min zoom level of apparition';


/* Rename mapping.layer_tree to layer_tree_node, rename or delete columns, add foreign keys */
ALTER TABLE layer_tree RENAME to layer_tree_node;

ALTER TABLE layer_tree_node RENAME COLUMN item_id TO node_id;
ALTER TABLE layer_tree_node RENAME COLUMN parent_id TO parent_node_id;
ALTER TABLE layer_tree_node RENAME COLUMN is_expended TO is_expanded;
ALTER TABLE layer_tree_node RENAME COLUMN name TO layer_name;
ALTER TABLE layer_tree_node ADD column label VARCHAR(30);
ALTER TABLE layer_tree_node ADD column definition VARCHAR(100);       

UPDATE layer SET name='espaces_naturels' WHERE name ='Espaces naturels';

ALTER TABLE layer_tree_node ADD FOREIGN KEY (layer_name) REFERENCES mapping.layer (name) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;

COMMENT ON COLUMN layer_tree_node.node_id IS 'Identify the layer_tree node';
COMMENT ON COLUMN layer_tree_node.parent_node_id IS 'Identify the parent of the node (-1 = root)';
COMMENT ON COLUMN layer_tree_node.label IS 'label of the node into the tree';
COMMENT ON COLUMN layer_tree_node.definition IS 'definition of the node into the tree';
COMMENT ON COLUMN layer_tree_node.is_layer IS 'If value = 1 then this is a layer, else it is only a node';
COMMENT ON COLUMN layer_tree_node.is_checked IS 'If value = 1 then the node is checked by default';
COMMENT ON COLUMN layer_tree_node.is_hidden IS 'If value = 1 then the node is hidden by default';
COMMENT ON COLUMN layer_tree_node.is_disabled IS 'If value = 1 then the node is displayed but grayed';
COMMENT ON COLUMN layer_tree_node.is_expanded IS 'If value = 1 then the node is expanded by default';
COMMENT ON COLUMN layer_tree_node.layer_name IS 'Logical name of the layer or label of the node';
COMMENT ON COLUMN layer_tree_node.position IS 'Position of the layer in its group';
COMMENT ON COLUMN layer_tree_node.checked_group IS 'Group of layers';


/* Rename mapping.bounding_box to provider_map_params */
ALTER TABLE bounding_box RENAME TO provider_map_params;
ALTER TABLE provider_map_params ADD FOREIGN KEY (zoom_level) REFERENCES mapping.zoom_level (zoom_level) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION;


set search_path to metadata, public;

/* Add column definition to mode_taxref and change index */
ALTER TABLE mode_taxref ADD COLUMN definition VARCHAR(500) null;
ALTER TABLE mode_taxref ADD COLUMN position INTEGER null;
COMMENT ON COLUMN mode_taxref.definition IS 'The definition of the mode';
COMMENT ON COLUMN mode_taxref.position IS 'The position of the mode';

DROP INDEX IF EXISTS mode_taxref_parent_code_idx;
DROP INDEX IF EXISTS mode_taxref_name_idx;
DROP INDEX IF EXISTS mode_taxref_complete_name_idx;
DROP INDEX IF EXISTS mode_taxref_vernacular_name_idx;

ALTER TABLE mode_taxref RENAME COLUMN "name" to label;

CREATE INDEX mode_taxref_parent_code_idx ON metadata.mode_taxref USING btree (parent_code);  
CREATE INDEX mode_taxref_name_idx ON metadata.mode_taxref USING gist (unaccent_immutable(label) gist_trgm_ops);
CREATE INDEX mode_taxref_complete_name_idx ON metadata.mode_taxref USING gist (unaccent_immutable(complete_name) gist_trgm_ops);
CREATE INDEX mode_taxref_vernacular_name_idx ON metadata.mode_taxref USING gist (unaccent_immutable(vernacular_name) gist_trgm_ops);


set search_path to metadata_work, public;

/* Add column definition to mode_taxref and change index */
ALTER TABLE mode_taxref ADD COLUMN definition VARCHAR(500) null;
COMMENT ON COLUMN mode_taxref.definition IS 'The definition of the mode';

ALTER TABLE mode_taxref RENAME COLUMN name to label;

DROP INDEX IF EXISTS mode_taxref_parent_code_idx;
DROP INDEX IF EXISTS mode_taxref_NAME_idx;
DROP INDEX IF EXISTS mode_taxref_complete_name_idx;
DROP INDEX IF EXISTS mode_taxref_vernacular_name_idx;

CREATE INDEX mode_taxref_parent_code_idx ON metadata_work.mode_taxref USING btree (parent_code);  
CREATE INDEX mode_taxref_name_idx ON metadata_work.mode_taxref USING gist (unaccent_immutable(label) gist_trgm_ops);
CREATE INDEX mode_taxref_complete_name_idx ON metadata_work.mode_taxref USING gist (unaccent_immutable(complete_name) gist_trgm_ops);
CREATE INDEX mode_taxref_vernacular_name_idx ON metadata_work.mode_taxref USING gist (unaccent_immutable(vernacular_name) gist_trgm_ops);


set search_path to website;
/* Delete column active in users table*/
ALTER TABLE users DROP column IF EXISTS active;

/* Change  layer_role_restriction foreign_key */
ALTER TABLE layer_role_restriction DROP CONSTRAINT IF EXISTS fk_layer_role_restriction_layer_name;
ALTER TABLE layer_role_restriction ADD FOREIGN KEY (layer_name) REFERENCES mapping.layer(name) ON UPDATE NO ACTION ON DELETE NO ACTION;

/* Rename column in table predefined_request, add constraint */
ALTER TABLE predefined_request RENAME COLUMN request_name TO name;
ALTER TABLE predefined_request add constraint fk_predefined_request_dataset foreign key (dataset_id) references metadata.dataset (dataset_id) on delete restrict on update restrict;

/* Rename table predefined_request_criteria to predefined_request_criterion */
ALTER TABLE predefined_request_criteria RENAME TO predefined_request_criterion;
COMMENT ON COLUMN predefined_request_criterion.format IS 'The form format of the criterion';
COMMENT ON COLUMN predefined_request_criterion.data IS 'The form field of the criterion';
COMMENT ON COLUMN predefined_request_criterion.fixed IS 'Indicate if the criterion is fixed or selectable';
ALTER TABLE predefined_request_criterion DROP CONSTRAINT IF EXISTS fk_predefined_request_criteria_request_name;
ALTER TABLE ONLY predefined_request_criterion ADD FOREIGN KEY (request_name) REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;

/* Rename table predefined_request_result to predefined_request_column */
ALTER TABLE predefined_request_result RENAME TO predefined_request_column;
COMMENT ON COLUMN predefined_request_column.format IS 'The form format of the column';
COMMENT ON COLUMN predefined_request_column.data IS 'The form field of the column';
ALTER TABLE predefined_request_column DROP CONSTRAINT IF EXISTS fk_predefined_request_result_request_name;
ALTER TABLE ONLY predefined_request_column ADD CONSTRAINT fk_predefined_request_column_request_name FOREIGN KEY (request_name) REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;

/* Change column name in table PREDEFINED_REQUEST_GROUP */
ALTER TABLE predefined_request_group RENAME COLUMN group_name to name;

/* Change foreign key on table predefined_request_group_asso */
ALTER TABLE predefined_request_group_asso DROP CONSTRAINT IF EXISTS fk_predefined_request_request_name;
ALTER TABLE ONLY predefined_request_group_asso ADD FOREIGN KEY (request_name) REFERENCES predefined_request(name) ON UPDATE RESTRICT ON DELETE RESTRICT;

/* Change all dynamodes beacuse now we need two more fields: definition and position (unused but mandatory) */
DELETE FROM metadata.dynamode;
INSERT INTO metadata.dynamode (unit, sql) VALUES
  ('CodeCommuneValue', 'SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY insee_com'),
  ('CodeDepartementValue', 'SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.geofla_departement ORDER BY code_dept'),
  ('region', 'SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.geofla_region ORDER BY code_reg'),
  ('CodeMailleValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig'),
  ('CodeENValue', 'SELECT codeen as code, codeen || '' ('' || libelleen || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codeenvalue ORDER BY codeEN'),
  ('StatutSourceValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutSourceValue ORDER BY code'),
  ('DSPubliqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.DSPubliqueValue ORDER BY code'),
  ('StatutObservationValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutObservationValue ORDER BY code'),
  ('ObjetDenombrementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObjetDenombrementValue ORDER BY code'),
  ('TypeDenombrementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeDenombrementValue ORDER BY code'),
  ('CodeHabitatValue', 'SELECT lb_code as code, lb_code as label, min(lb_hab_fr) as definition, ''''::text as position FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1'),
  ('CodeRefHabitatValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.CodeRefHabitatValue ORDER BY code'),
  ('NatureObjetGeoValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NatureObjetGeoValue ORDER BY code'),
  ('TypeENValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeENValue ORDER BY code'),
  ('CodeHabRefValue', 'SELECT cd_hab as code, cd_hab as label, lb_description as definition, ''''::text as position FROM referentiels.habref_20 ORDER BY code'),
  ('IDCNPValue', 'SELECT code, label, definition, ''''::text as position FROM referentiels.IDCNPValue ORDER BY code'),
  ('TypeInfoGeoValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeInfoGeoValue ORDER BY code'),
  ('VersionMasseDEauValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.VersionMasseDEauValue ORDER BY code'),
  ('NiveauPrecisionValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NiveauPrecisionValue ORDER BY code'),
  ('SensibleValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibleValue ORDER BY code'),
  ('SensibiliteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibiliteValue ORDER BY code'),
  ('TypeRegroupementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeRegroupementValue ORDER BY code'),
  ('OccurrenceNaturalisteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceNaturalisteValue ORDER BY code'),
  ('OccurrenceSexeValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceSexeValue ORDER BY code'),
  ('OccurrenceStadeDeVieValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code'),
  ('OccurrenceStatutBiologiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code'),
  ('PreuveExistanteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.PreuveExistanteValue ORDER BY code'),
  ('ObservationMethodeValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObservationMethodeValue ORDER BY code'),
  ('OccurrenceEtatBiologiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code'),
  ('OccurrenceStatutBiogeographiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiogeographiqueValue ORDER BY code'),
  ('PROVIDER_ID', 'SELECT id as code, label, definition, ''''::text as position FROM website.providers ORDER BY label'),
  ('SensiAlerteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiAlerteValue ORDER BY code'),
  ('SensiManuelleValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiManuelleValue ORDER BY code'),
  ('CodeMailleCalculeValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig'),
  ('CodeCommuneCalculeValue', 'SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY insee_com'),
  ('NomCommuneCalculeValue', 'SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY nom_com'),
  ('CodeDepartementCalculeValue', 'SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_departement ORDER BY code_dept'),
  ('TypeAttributValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.typeattributvalue ORDER BY code');

DELETE FROM metadata_work.dynamode;
INSERT INTO metadata_work.dynamode (unit, sql) VALUES
  ('CodeCommuneValue', 'SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY insee_com'),
  ('CodeDepartementValue', 'SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.geofla_departement ORDER BY code_dept'),
  ('region', 'SELECT code_reg as code, nom_reg || '' ('' || code_reg || '')'' as label, ''''::text as definition, ''''::text as position  FROM referentiels.geofla_region ORDER BY code_reg'),
  ('CodeMailleValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig'),
  ('CodeENValue', 'SELECT codeen as code, codeen || '' ('' || libelleen || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codeenvalue ORDER BY codeEN'),
  ('StatutSourceValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutSourceValue ORDER BY code'),
  ('DSPubliqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.DSPubliqueValue ORDER BY code'),
  ('StatutObservationValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.StatutObservationValue ORDER BY code'),
  ('ObjetDenombrementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObjetDenombrementValue ORDER BY code'),
  ('TypeDenombrementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeDenombrementValue ORDER BY code'),
  ('CodeHabitatValue', 'SELECT lb_code as code, lb_code as label, min(lb_hab_fr) as definition, ''''::text as position FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1'),
  ('CodeRefHabitatValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.CodeRefHabitatValue ORDER BY code'),
  ('NatureObjetGeoValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NatureObjetGeoValue ORDER BY code'),
  ('TypeENValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeENValue ORDER BY code'),
  ('CodeHabRefValue', 'SELECT cd_hab as code, cd_hab as label, lb_description as definition, ''''::text as position FROM referentiels.habref_20 ORDER BY code'),
  ('IDCNPValue', 'SELECT code, label, definition, ''''::text as position FROM referentiels.IDCNPValue ORDER BY code'),
  ('TypeInfoGeoValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeInfoGeoValue ORDER BY code'),
  ('VersionMasseDEauValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.VersionMasseDEauValue ORDER BY code'),
  ('NiveauPrecisionValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.NiveauPrecisionValue ORDER BY code'),
  ('SensibleValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibleValue ORDER BY code'),
  ('SensibiliteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensibiliteValue ORDER BY code'),
  ('TypeRegroupementValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.TypeRegroupementValue ORDER BY code'),
  ('OccurrenceNaturalisteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceNaturalisteValue ORDER BY code'),
  ('OccurrenceSexeValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceSexeValue ORDER BY code'),
  ('OccurrenceStadeDeVieValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code'),
  ('OccurrenceStatutBiologiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code'),
  ('PreuveExistanteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.PreuveExistanteValue ORDER BY code'),
  ('ObservationMethodeValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.ObservationMethodeValue ORDER BY code'),
  ('OccurrenceEtatBiologiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code'),
  ('OccurrenceStatutBiogeographiqueValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.OccurrenceStatutBiogeographiqueValue ORDER BY code'),
  ('PROVIDER_ID', 'SELECT id as code, label, definition, ''''::text as position FROM website.providers ORDER BY label'),
  ('SensiAlerteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiAlerteValue ORDER BY code'),
  ('SensiManuelleValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.SensiManuelleValue ORDER BY code'),
  ('CodeMailleCalculeValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.codemaillevalue ORDER BY cd_sig'),
  ('CodeCommuneCalculeValue', 'SELECT insee_com as code, insee_com as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY insee_com'),
  ('NomCommuneCalculeValue', 'SELECT nom_com as code, nom_com || '' ('' || insee_com || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_commune ORDER BY nom_com'),
  ('CodeDepartementCalculeValue', 'SELECT code_dept as code, nom_dept || '' ('' || code_dept || '')'' as label, ''''::text as definition, ''''::text as position FROM referentiels.geofla_departement ORDER BY code_dept'),
  ('TypeAttributValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.typeattributvalue ORDER BY code');
