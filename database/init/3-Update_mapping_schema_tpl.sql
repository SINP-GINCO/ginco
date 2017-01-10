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

-- Define the layers
INSERT INTO layer (name, label, service_layer_name, is_transparent, is_base_layer, is_untiled, has_legend, default_opacity, max_zoom_level, min_zoom_level, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
  ('Fonds', 'Fonds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  ('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 1, 0, 0, 100, 5, NULL, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL),
  ('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
  ('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),

  ('Limites administratives', 'Limites administratives', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  ('communes', 'Communes', 'communes', 1, 1, 0, 0, 100, 11, NULL, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('departements', 'Départements', 'departements', 1, 1, 0, 0, 100, 7, 11, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('mailles', 'Mailles 10km', 'mailles', 1, 1, 0, 0, 100, 9, NULL, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
  ('regions', 'Régions', 'regions', 1, 1, 0, 0, 100, 5, 7, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),

  ('espaces_naturels', 'Espaces naturels', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  ('PROTECTEDAREAS.BIOS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.CDL', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.CEN', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PN', 'Parcs nationaux', 'PROTECTEDAREAS.PN', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PNM', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.PNR', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RAMSAR', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RB', 'Réserves biologiques', 'PROTECTEDAREAS.RB', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RN', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RN', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RNC', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.RNCF', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.SIC', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.ZPS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
  ('PROTECTEDAREAS.APB', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB', 0, 1, 0, 0, 100, NULL, NULL, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),

  ('results', 'Résultats de la recherche', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
  ('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 1, 0, 1, 100, 11, NULL, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('result_maille', 'Mailles', 'result_maille', 1, 1, 0, 1, 100, NULL, NULL, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('result_commune', 'Communes', 'result_commune', 1, 1, 0, 1, 100, NULL, NULL, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
  ('result_departement', 'Départements', 'result_departement', 1, 1, 0, 1, 100, NULL, NULL, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);

--
-- Define the layers legend
--
INSERT INTO mapping.layer_tree_node VALUES (2, '-1', 'Résultats', NULL, 0, 1, 0, 0, 1, 'results', 1, NULL);
INSERT INTO mapping.layer_tree_node VALUES (24, '2', 'résultats département', NULL, 1, 1, 0, 1, 0, 'result_departement', 24, 'results');
INSERT INTO mapping.layer_tree_node VALUES (23, '2', 'résultats maille', NULL, 1, 0, 0, 1, 0, 'result_maille', 21, 'results');
INSERT INTO mapping.layer_tree_node VALUES (22, '2', 'résultats commune', NULL, 1, 0, 0, 1, 0, 'result_commune', 23, 'results');
INSERT INTO mapping.layer_tree_node VALUES (21, '2', 'résultats géométrie', NULL, 1, 0, 0, 1, 0, 'result_geometrie', 22, 'results');

INSERT INTO mapping.layer_tree_node VALUES (3, '-1', 'Limites administratives', NULL, 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL);
INSERT INTO mapping.layer_tree_node VALUES (31, '3', 'regions', NULL, 1, 1, 0, 0, 0, 'regions', 34, NULL);
INSERT INTO mapping.layer_tree_node VALUES (32, '3', 'departements', NULL, 1, 1, 0, 0, 0, 'departements', 31, NULL);
INSERT INTO mapping.layer_tree_node VALUES (34, '3', 'mailles', NULL, 1, 1, 0, 0, 0, 'mailles', 33, NULL);
INSERT INTO mapping.layer_tree_node VALUES (33, '3', 'communes', NULL, 1, 1, 0, 0, 0, 'communes', 32, NULL);

INSERT INTO mapping.layer_tree_node VALUES (4, '-1', 'Espaces naturels', NULL, 0, 1, 0, 0, 1, 'espaces_naturels', 4, NULL);
INSERT INTO mapping.layer_tree_node VALUES (41, '4', 'ZNIEFF1', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 42, NULL);
INSERT INTO mapping.layer_tree_node VALUES (42, '4', 'ZNIEFF2', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 41, NULL);
INSERT INTO mapping.layer_tree_node VALUES (43, '4', 'APB', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 43, NULL);
INSERT INTO mapping.layer_tree_node VALUES (44, '4', 'CEN', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 44, NULL);
INSERT INTO mapping.layer_tree_node VALUES (45, '4', 'CDL', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 45, NULL);
INSERT INTO mapping.layer_tree_node VALUES (46, '4', 'PN', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 46, NULL);
INSERT INTO mapping.layer_tree_node VALUES (47, '4', 'PNM', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 47, NULL);
INSERT INTO mapping.layer_tree_node VALUES (48, '4', 'PNR', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 48, NULL);
INSERT INTO mapping.layer_tree_node VALUES (49, '4', 'RB', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 49, NULL);
INSERT INTO mapping.layer_tree_node VALUES (491, '4', 'BIOS', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 491, NULL);
INSERT INTO mapping.layer_tree_node VALUES (492, '4', 'RNC', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 492, NULL);
INSERT INTO mapping.layer_tree_node VALUES (493, '4', 'RN', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 493, NULL);
INSERT INTO mapping.layer_tree_node VALUES (494, '4', 'RNCF', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 494, NULL);
INSERT INTO mapping.layer_tree_node VALUES (495, '4', 'SIC', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 495, NULL);
INSERT INTO mapping.layer_tree_node VALUES (496, '4', 'ZPS', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 496, NULL);
INSERT INTO mapping.layer_tree_node VALUES (497, '4', 'RAMSAR', NULL, 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 497, NULL);

INSERT INTO mapping.layer_tree_node VALUES (5, '-1', 'Fonds', NULL, 0, 1, 0, 0, 1, 'Fonds', 5, NULL);
INSERT INTO mapping.layer_tree_node VALUES (51, '5', 'orthophotos', NULL, 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 52, NULL);
INSERT INTO mapping.layer_tree_node VALUES (52, '5', 'plans IGN', NULL, 1, 0, 0, 0, 0, 'plan_ign', 51, NULL);

--
-- Forbid some layers for some profiles
--

DELETE FROM bounding_box;
-- Configure the bounding box for default data provider
INSERT INTO bounding_box (provider_id, zoom_level, bb_xmin, bb_ymin, bb_xmax, bb_ymax) values ('1', '@bb.zoom@', '@bb.xmin@', '@bb.ymin@', '@bb.xmax@', '@bb.ymax@');

DELETE FROM bac_commune;
DELETE FROM bac_departement;
DELETE FROM bac_maille;
-- Populate the vizualisation bacs with the referentiels tables
INSERT INTO bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857) FROM referentiels.geofla_commune AS r;
INSERT INTO bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.geofla_departement AS r;
INSERT INTO bac_maille SELECT r.code_10km, St_Transform(r.geom, 3857) FROM referentiels.codemaillevalue AS r;
