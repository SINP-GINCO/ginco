SET SEARCH_PATH = mapping, public;


-- Add the available map zoom_level
DELETE FROM zoom_level;
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


-- Conf des services et des layers

DELETE FROM layer_tree_node;
DELETE FROM layer;
DELETE FROM layer_service;

-- Define the services

INSERT INTO layer_service (name, config) VALUES
  ('mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'),
  ('legend_mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}'),
  ('Local_MapProxy_WFS_GetFeature','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}'),
  ('geoportal_wms','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('geoportal_wmts_png','{"urls":["http://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}');

--
-- Define the layers
--
INSERT INTO layer (name, label, service_layer_name, is_transparent, default_opacity, is_base_layer, is_untiled, max_zoom_level, min_zoom_level, has_legend, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
  ('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
  ('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
  ('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('result_commune', 'Communes', 'result_commune', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('result_departement', 'Départements', 'result_departement', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('result_maille', 'Mailles', 'result_maille', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('communes', 'Communes', 'communes', 1, 100, 0, 0, 11, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 100, 0, 1, 11, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('mailles', 'Mailles 10km', 'mailles', 1, 100, 0, 0, 9, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 100, 0, 0, 5, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL),
  ('departements', 'Départements', 'departements', 1, 100, 0, 0, 7, 11, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('regions', 'Régions', 'regions', 1, 100, 0, 0, 5, 7, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('PROTECTEDAREAS.BIOS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.CDL', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.CEN', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PN', 'Parcs nationaux', 'PROTECTEDAREAS.PN', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PNM', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PNR', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RAMSAR', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RB', 'Réserves biologiques', 'PROTECTEDAREAS.RB', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RN', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RN', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RNC', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RNCF', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.SIC', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.ZPS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.APB', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB', 0, 100, 1, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);

--
-- And the layer tree
--
INSERT INTO layer_tree_node (node_id, parent_node_id, is_layer, is_checked, is_hidden, is_disabled, is_expanded, layer_name, "position", checked_group, label, definition) VALUES
  (2, '-1', 0, 1, 0, 0, 1, NULL, 1, NULL, 'Résultats de la recherche', NULL),
  (3, '-1', 0, 1, 0, 0, 1, NULL, 3, NULL, 'Limites administratives', NULL),
  (4, '-1', 0, 1, 0, 0, 1, NULL, 4, NULL, 'Espaces naturels', NULL),
  (5, '-1', 0, 1, 0, 0, 1, NULL, 5, NULL, 'Fonds', NULL),
  (21, '2', 1, 0, 0, 1, 0, 'result_geometrie', 21, 'results', NULL, NULL),
  (22, '2', 1, 0, 0, 1, 0, 'result_commune', 22, 'results', NULL, NULL),
  (23, '2', 1, 0, 0, 1, 0, 'result_maille', 23, 'results', NULL, NULL),
  (24, '2', 1, 1, 0, 1, 0, 'result_departement', 24, 'results', NULL, NULL),
  (31, '3', 1, 1, 0, 0, 0, 'communes', 31, NULL, NULL, NULL),
  (32, '3', 1, 1, 0, 0, 0, 'mailles', 32, NULL, NULL, NULL),
  (33, '3', 1, 1, 0, 0, 0, 'departements', 33, NULL, NULL, NULL),
  (34, '3', 1, 1, 0, 0, 0, 'regions', 34, NULL, NULL, NULL),
  (51, '5', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 51, NULL, NULL, NULL),
  (52, '5', 1, 0, 0, 0, 0, 'plan_ign', 52, NULL, NULL, NULL),
  (41, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 114, NULL, NULL, NULL),
  (42, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 115, NULL, NULL, NULL),
  (43, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 101, NULL, NULL, NULL),
  (44, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 102, NULL, NULL, NULL),
  (45, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 103, NULL, NULL, NULL),
  (46, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 104, NULL, NULL, NULL),
  (47, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 105, NULL, NULL, NULL),
  (48, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 106, NULL, NULL, NULL),
  (49, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 107, NULL, NULL, NULL),
  (491, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 108, NULL, NULL, NULL),
  (492, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 109, NULL, NULL, NULL),
  (493, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 110, NULL, NULL, NULL),
  (494, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 111, NULL, NULL, NULL),
  (495, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 112, NULL, NULL, NULL),
  (496, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 113, NULL, NULL, NULL),
  (497, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 116, NULL, NULL, NULL);
--
-- Forbid some layers for some profiles
--

DELETE FROM provider_map_params;
-- Configure the provider_map_params for default data provider
INSERT INTO provider_map_params (provider_id, zoom_level, bb_xmin, bb_ymin, bb_xmax, bb_ymax) values ('1', '@bb.zoom@', '@bb.xmin@', '@bb.ymin@', '@bb.xmax@', '@bb.ymax@');

DELETE FROM bac_commune;
DELETE FROM bac_departement;
DELETE FROM bac_maille;
-- Populate the vizualisation bacs with the referentiels tables
INSERT INTO bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857) FROM referentiels.geofla_commune AS r;
INSERT INTO bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.geofla_departement AS r;
INSERT INTO bac_maille SELECT r.code_10km, St_Transform(r.geom, 3857) FROM referentiels.codemaillevalue AS r;
