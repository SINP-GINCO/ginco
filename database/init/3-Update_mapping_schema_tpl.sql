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
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (13, 19.1092570713, 68247, '1:68K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (14, 9.5546285356, 34124, '1:34K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (15, 4.7773142678, 17062, '1:17K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (16, 2.3886571339, 8531, '1:8,5K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (17, 1.1943285670, 4265, '1:4,3K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (18, 0.5971642835, 2133, '1:2,1K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (19, 0.2985821417, 1066, '1:1,1K', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (20, 0.1492910709, 533, '1:533', TRUE);
INSERT INTO zoom_level (zoom_level, resolution, approx_scale_denom, scale_label, is_map_zoom_level) VALUES (21, 0.0746455354, 267, '1:267', TRUE);


-- Conf des services et des layers

DELETE FROM layer_tree_node;
DELETE FROM layer;
DELETE FROM layer_service;

-- Define the services

INSERT INTO layer_service (name, config) VALUES
  ('mapProxy','{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'),
  ('legend_mapProxy','{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}'),
  ('Local_MapProxy_WFS_GetFeature','{"urls":["@url.protocol@://@url.domain@@url.basepath@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}'),
  ('geoportal_wms','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('geoportal_wmts_png','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('EN_WFS_GetFeature', '{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wfs?"],"params":{"SERVICE":"WFS","VERSION":"1.0.0","REQUEST":"GetFeature", "outputFormat":"json"}}'),
  ('EN_WMS_Legend', '{"urls":["https://www.geoportail.gouv.fr/depot/layers/"],"params":{}}');
--
-- Define the layers
--
INSERT INTO layer (name, label, service_layer_name, is_transparent, default_opacity, is_base_layer, is_untiled, max_zoom_level, min_zoom_level, has_legend, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
('Fonds', 'Fonds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 100, 0, 0, 5, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL),
('en_pr', 'EN - Protections réglementaires', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pc', 'EN - Protections contractuelles', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pmf', 'EN - Protections par la maîtrise foncière', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pconv', 'EN - Protections au titre de conventions', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_n2000', 'EN - Natura 2000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_znieff', 'EN - ZNIEFF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.APB', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.CEN', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.CDL', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PN', 'Parcs nationaux', 'PROTECTEDAREAS.PN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PNM', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PNR', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RB', 'Réserves biologiques', 'PROTECTEDAREAS.RB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.BIOS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RNC', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RN', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RNCF', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.SIC', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.ZPS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RAMSAR', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.UNESCO', 'Patrimoine mondial de l''UNESCO', 'PROTECTEDAREAS.UNESCO', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RIPN', 'Réserves intégrales de parc national', 'PROTECTEDAREAS.RIPN', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('Limites administratives', 'Limites administratives', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('regions', 'Régions', 'regions', 1, 100, 0, 0, 5, 7, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('departements', 'Départements', 'departements', 1, 100, 0, 0, 7, 11, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('mailles', 'Mailles 10km', 'mailles', 1, 100, 0, 0, 9, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('communes', 'Communes', 'communes', 1, 100, 0, 0, 11, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('results', 'Résultats de la recherche', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('result_departement', 'Départements', 'result_departement', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_maille', 'Mailles', 'result_maille', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_commune', 'Communes', 'result_commune', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 100, 0, 1, 11, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('PROTECTEDAREAS_APB_WFS', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB:apb', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_BIOS_WFS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS:wld_bios', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_CEN_WFS', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN:cdl_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PN_WFS', 'Parcs nationaux', 'PROTECTEDAREAS.PN:pn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNM_WFS', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM:pnm', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNR_WFS', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR:pnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RAMSAR_WFS', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR:ramsar', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RB_WFS', 'Réserves biologiques', 'PROTECTEDAREAS.RB:rb_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RIPN_WFS', 'Réserves intégrales de parcs nationaux', 'PROTECTEDAREAS.RIPN:ripn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNC_WFS', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC:rnc_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNCF_WFS', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF:wld_rncfs', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNN_WFS', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RNN:rnn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_SIC_WFS', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC:sic', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_UNESCO_WFS', 'Patrimoine mondial de l''UNESCO', 'PROTECTEDAREAS.UNESCO:unesco', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZNIEFF1_WFS', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1:znieff1', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZNIEFF2_WFS', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2:znieff2_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZPS_WFS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS:zps', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES:wld_rnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS.MNHN.CONSERVATOIRES', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS_MNHN_CONSERVATOIRES_WFS', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES:cen2013_09', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_CDL_WFS', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL:wld_perimetre_intervention_wm', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature');

--
-- And the layer tree
--
INSERT INTO layer_tree_node (node_id, parent_node_id, is_layer, is_checked, is_hidden, is_disabled, is_expanded, layer_name, "position", checked_group, label, definition) VALUES
  (33, '3', 1, 1, 0, 0, 0, 'departements', 33, NULL, NULL, NULL),
  (34, '3', 1, 1, 0, 0, 0, 'regions', 34, NULL, NULL, NULL),
  (71, '70', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 71, NULL, NULL, NULL),
  (72, '70', 1, 0, 0, 0, 0, 'plan_ign', 72, NULL, NULL, NULL),
  (109, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 109, NULL, NULL, NULL),
  (61, '-1', 0, 1, 0, 0, 0, NULL, 61, NULL, 'EN - Protections réglementaires', NULL),
  (62, '-1', 0, 1, 0, 0, 0, NULL, 62, NULL, 'EN - Protections contractuelles', NULL),
  (63, '-1', 0, 1, 0, 0, 0, NULL, 63, NULL, 'EN - Protections par la maîtrise foncière', NULL),
  (64, '-1', 0, 1, 0, 0, 0, NULL, 64, NULL, 'EN - Protections au titre de conventions', NULL),
  (65, '-1', 0, 1, 0, 0, 0, NULL, 65, NULL, 'EN - Natura 2000', NULL),
  (114, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 114, NULL, NULL, NULL),
  (66, '-1', 0, 1, 0, 0, 0, NULL, 66, NULL, 'EN - ZNIEFF', NULL),
  (70, '-1', 0, 1, 0, 0, 0, NULL, 70, NULL, 'Fonds', NULL),
  (115, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 115, NULL, NULL, NULL),
  (2, '-1', 0, 1, 0, 0, 1, NULL, 2, NULL, 'Résultats de la recherche', NULL),
  (3, '-1', 0, 1, 0, 0, 1, NULL, 3, NULL, 'Limites administratives', NULL),
  (102, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 102, NULL, NULL, NULL),
  (103, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 103, NULL, NULL, NULL),
  (104, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 104, NULL, NULL, NULL),
  (108, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 108, NULL, NULL, NULL),
  (110, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 110, NULL, NULL, NULL),
  (112, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 112, NULL, 'Directive Habitats', NULL),
  (113, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 113, NULL, 'Directive Oiseaux', NULL),
  (116, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 116, NULL, NULL, NULL),
  (101, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 101, NULL, NULL, NULL),
  (107, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 107, NULL, NULL, NULL),
  (111, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 111, NULL, NULL, NULL),
  (105, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 105, NULL, NULL, NULL),
  (106, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 106, NULL, NULL, NULL),
  (21, '2', 1, 0, 0, 1, 0, 'result_geometrie', 21, 'results', NULL, NULL),
  (22, '2', 1, 0, 0, 1, 0, 'result_commune', 22, 'results', NULL, NULL),
  (23, '2', 1, 0, 0, 1, 0, 'result_maille', 23, 'results', NULL, NULL),
  (24, '2', 1, 1, 0, 1, 0, 'result_departement', 24, 'results', NULL, NULL),
  (31, '3', 1, 1, 0, 0, 0, 'communes', 31, NULL, NULL, NULL),
  (32, '3', 1, 1, 0, 0, 0, 'mailles', 32, NULL, NULL, NULL);
  
UPDATE layer_tree_node SET label = layer.label FROM layer WHERE layer_tree_node.layer_name = layer.name;
UPDATE layer_tree_node SET definition = layer.label FROM layer WHERE layer_tree_node.layer_name = layer.name;

-- WFS layer need to be in layer tree
INSERT INTO mapping.layer_tree_node(
            node_id, parent_node_id, label, definition, is_layer, is_checked, 
            is_hidden, is_disabled, is_expanded, layer_name, "position", 
            checked_group)
    VALUES (10001, 10000, 'Arrêtés de protection de biotope', 'Arrêtés de protection de biotope', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_APB_WFS', 10001, NULL),
    (10002, 10000, 'Réserves de biosphère', 'Réserves de biosphère', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_BIOS_WFS', 10002, NULL),
    (10003, 10000, 'Conservatoire du littoral : périmètres d''intervention', 'Conservatoire du littoral : périmètres d''intervention', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_CDL_WFS', 10003, NULL),
    (10004, 10000, 'Conservatoire du littoral : parcelles protégées', 'Conservatoire du littoral : parcelles protégées', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_CEN_WFS', 10004, NULL),
    (10005, 10000, 'Sites acquis des Conservatoires d''espaces naturels', 'Sites acquis des Conservatoires d''espaces naturels', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_MNHN_CONSERVATOIRES_WFS', 10005, NULL),
    (10006, 10000, 'Parcs naturels marins', 'Parcs naturels marins', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PNM_WFS', 10006, NULL),
    (10007, 10000, 'Parcs naturels régionaux', 'Parcs naturels régionaux', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PNR_WFS', 10007, NULL),
    (10008, 10000, 'Parcs nationaux', 'Parcs nationaux', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PN_WFS', 10008, NULL),
    (10009, 10000, 'Zones humides d''importance internat.', 'Zones humides d''importance internat.', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RAMSAR_WFS', 10009, NULL),
    (10010, 10000, 'Réserves biologiques', 'Réserves biologiques', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RB_WFS', 10010, NULL),
    (10011, 10000, 'Réserves intégrales de parcs nationaux', 'Réserves intégrales de parcs nationaux', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RIPN_WFS', 10011, NULL),
    (10012, 10000, 'Rés nation. chasse et faune sauvage', 'Rés nation. chasse et faune sauvage', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNCF_WFS', 10012, NULL),
    (10013, 10000, 'Réserves naturelles de Corse', 'Réserves naturelles de Corse', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNC_WFS', 10013, NULL),
    (10014, 10000, 'Réserves naturelles nationales', 'Réserves naturelles nationales', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNN_WFS', 10014, NULL),
    (10015, 10000, 'Sites Natura 2000 (Directive Habitats)', 'Sites Natura 2000 (Directive Habitats)', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_SIC_WFS', 10015, NULL),
    (10016, 10000, 'Patrimoine mondial de l''UNESCO', 'Patrimoine mondial de l''UNESCO', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_UNESCO_WFS', 10016, NULL),
    (10017, 10000, 'ZNIEFF1', 'ZNIEFF1', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZNIEFF1_WFS', 10017, NULL),
    (10018, 10000, 'ZNIEFF2', 'ZNIEFF2', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZNIEFF2_WFS', 10018, NULL),
    (10019, 10000, 'Sites Natura 2000 (Directive Oiseaux)', 'Sites Natura 2000 (Directive Oiseaux)', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZPS_WFS', 10019, NULL),
    (10020, 10000, 'Réserves naturelles régionales', 'Réserves naturelles régionales', 1, 0, 0, 0, 0, 'PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 10020, NULL);

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
INSERT INTO bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857) FROM referentiels.commune_carto_2017 AS r;
INSERT INTO bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.departement_carto_2017 AS r;
INSERT INTO bac_maille SELECT r.code_10km, St_Transform(r.geom, 3857) FROM referentiels.codemaillevalue AS r;
