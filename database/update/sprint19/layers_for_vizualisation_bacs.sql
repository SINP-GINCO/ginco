SET search_path = mapping;

--
-- Define the new layers
--
-- A new "limites administratives" : Mailles 10x10km
INSERT INTO layer VALUES ('mailles', 'Mailles 10km', 'mailles', 1, 100, 0, 0, 1091958, NULL, 1, NULL, 'PNG', NULL, 0, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
-- New result layers
INSERT INTO layer VALUES ('results', 'Résultats de la recherche', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
DELETE FROM layer WHERE layer_name='result_locations';
INSERT INTO layer VALUES ('result_departement', 'Départements', 'result_departement', 1, 100, 0, 1, NULL, 8735660, 0, NULL, 'PNG', NULL, 0, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_maille', 'Mailles', 'result_maille', 1, 100, 0, 1, 8735660, 272989, 0, NULL, 'PNG', NULL, 0, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_commune', 'Communes', 'result_commune', 1, 100, 0, 1, 272989, 136495, 0, NULL, 'PNG', NULL, 0, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 100, 0, 1, 136495, NULL, 0, NULL, 'PNG', NULL, 0, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);

--
-- Define the new layers legend
--
INSERT INTO layer_tree VALUES (34, '3', 1, 1, 0, 0, 0, 'mailles', 3, NULL);
--
INSERT INTO layer_tree VALUES (2, '-1', 0, 1, 0, 0, 1, 'results', 1, NULL);
-- todo Changer le parent id = -1 en '2' quand ce sera ok pour que OGAM reconnaisse les request_layers à l'intérieur des groupes
DELETE FROM layer_tree WHERE  name='result_locations';
INSERT INTO layer_tree VALUES (21, '-1', 1, 1, 0, 1, 0, 'result_geometrie', 1, NULL);
INSERT INTO layer_tree VALUES (22, '-1', 1, 1, 0, 1, 0, 'result_commune', 2, NULL);
INSERT INTO layer_tree VALUES (23, '-1', 1, 1, 0, 1, 0, 'result_maille', 3, NULL);
INSERT INTO layer_tree VALUES (24, '-1', 1, 1, 0, 1, 0, 'result_departement', 4, NULL);


-- Change layers-related application parameters
SET search_path = website;

UPDATE application_parameters SET value='result_geometrie' WHERE name='featureinfo_typename';