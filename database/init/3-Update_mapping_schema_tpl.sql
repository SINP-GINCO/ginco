SET search_path = mapping, public;

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
  ('geoportal_wms','{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('geoportal_wmts_png','{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('EN_WFS_GetFeature', '{"urls":["@geoportail.wxs.url@/@view.geoportail.key@/geoportail/wfs?"],"params":{"SERVICE":"WFS","VERSION":"1.0.0","REQUEST":"GetFeature", "outputFormat":"json"}}'),
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
('PROTECTEDAREAS.MNHN.CDL.PARCELS', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.MNHN.CDL.PARCELS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.MNHN.CDL.PERIMETER', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.MNHN.CDL.PERIMETER', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
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
('PROTECTEDAREAS_BIOS_WFS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS:bios', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_MNHN_CDL_PARCELS_WFS', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.MNHN.CDL.PARCELS:cdl_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PN_WFS', 'Parcs nationaux', 'PROTECTEDAREAS.PN:pn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNM_WFS', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM:pnm', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNR_WFS', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR:pnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RAMSAR_WFS', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR:ramsar', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RB_WFS', 'Réserves biologiques', 'PROTECTEDAREAS.RB:rb_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RIPN_WFS', 'Réserves intégrales de parcs nationaux', 'PROTECTEDAREAS.RIPN:ripn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNC_WFS', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC:rnc', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNCF_WFS', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF:rncfs_fxx', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_RNN_WFS', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RNN:rnn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_SIC_WFS', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC:sic', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_UNESCO_WFS', 'Patrimoine mondial de l''UNESCO', 'PROTECTEDAREAS.UNESCO:unesco', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZNIEFF1_WFS', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1:znieff1', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZNIEFF2_WFS', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2:znieff2_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_ZPS_WFS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS:zps', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES:rnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS.MNHN.CONSERVATOIRES', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', 'EN_WMS_Legend', 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS_MNHN_CONSERVATOIRES_WFS', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES:cen2013_09', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_MNHN_CDL_PERIMETER_WFS', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.MNHN.CDL.PERIMETER:wld_perimetre_intervention_wm', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature');

--
-- And the layer tree
--
INSERT INTO layer_tree_node (
            node_id, parent_node_id, is_layer, is_checked, is_hidden, is_disabled, 
            is_expanded, layer_name, "position", checked_group, label, definition) 
VALUES (70, '-1', 0, 1, 0, 0, 1, 'Fonds', 70, NULL, 'Fonds', 'Fonds'),
 (51, '70', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 1, NULL, 'Orthophotographies', 'Orthophotographies'),
 (52, '70', 1, 0, 0, 0, 0, 'plan_ign', 2, NULL, 'Carte IGN', 'Carte IGN'),
 (61, '-1', 0, 1, 0, 0, 0, 'en_pr', 61, NULL, 'EN - Protections réglementaires', 'EN - Protections réglementaires'),
 (62, '-1', 0, 1, 0, 0, 0, 'en_pc', 62, NULL, 'EN - Protections contractuelles', 'EN - Protections contractuelles'),
 (63, '-1', 0, 1, 0, 0, 0, 'en_pmf', 63, NULL, 'EN - Protections par la maîtrise foncière', 'EN - Protections par la maîtrise foncière'),
 (64, '-1', 0, 1, 0, 0, 0, 'en_pconv', 64, NULL, 'EN - Protections au titre de conventions', 'EN - Protections au titre de conventions'),
 (65, '-1', 0, 1, 0, 0, 0, 'en_n2000', 65, NULL, 'EN - Natura 2000', 'EN - Natura 2000'),
 (66, '-1', 0, 1, 0, 0, 0, 'en_znieff', 66, NULL, 'EN - ZNIEFF', 'EN - ZNIEFF'),
 (41, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 1, NULL, 'ZNIEFF1', 'ZNIEFF1'),
 (42, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 2, NULL, 'ZNIEFF2', 'ZNIEFF2'),
 (43, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 1, NULL, 'Arrêtés de protection de biotope', 'Arrêtés de protection de biotope'),
 (46, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 3, NULL, 'Parcs nationaux', 'Parcs nationaux'),
 (47, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 1, NULL, 'Parcs naturels marins', 'Parcs naturels marins'),
 (48, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 2, NULL, 'Parcs naturels régionaux', 'Parcs naturels régionaux'),
 (49, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 2, NULL, 'Réserves biologiques', 'Réserves biologiques'),
 (491, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 1, NULL, 'Réserves de biosphère', 'Réserves de biosphère'),
 (492, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 4, NULL, 'Réserves naturelles de Corse', 'Réserves naturelles de Corse'),
 (493, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 5, NULL, 'Réserves naturelles nationales', 'Réserves naturelles nationales'),
 (494, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 6, NULL, 'Rés nation. chasse et faune sauvage', 'Rés nation. chasse et faune sauvage'),
 (495, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 1, NULL, 'Sites Natura 2000 (Directive Habitats)', 'Sites Natura 2000 (Directive Habitats)'),
 (496, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 2, NULL, 'Sites Natura 2000 (Directive Oiseaux)', 'Sites Natura 2000 (Directive Oiseaux)'),
 (497, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 2, NULL, 'Zones humides d''importance internat.', 'Zones humides d''importance internat.'),
 (498, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.UNESCO', 3, NULL, 'Patrimoine mondial de l''UNESCO', 'Patrimoine mondial de l''UNESCO'),
 (499, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RIPN', 7, NULL, 'Réserves intégrales de parc national', 'Réserves intégrales de parc national'),
 (3, '-1', 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL, 'Limites administratives', 'Limites administratives'),
 (31, '3', 1, 1, 0, 0, 0, 'regions', 31, NULL, 'Régions', 'Régions'),
 (32, '3', 1, 1, 0, 0, 0, 'departements', 34, NULL, 'Départements', 'Départements'),
 (34, '3', 1, 1, 0, 0, 0, 'mailles', 32, NULL, 'Mailles 10km', 'Mailles 10km'),
 (33, '3', 1, 1, 0, 0, 0, 'communes', 33, NULL, 'Communes', 'Communes'),
 (2, '-1', 0, 1, 0, 0, 1, 'results', 1, NULL, 'Résultats de la recherche', 'Résultats de la recherche'),
 (24, '2', 1, 1, 0, 1, 0, 'result_departement', 21, 'results', 'Départements', 'Départements'),
 (23, '2', 1, 0, 0, 1, 0, 'result_maille', 24, 'results', 'Mailles', 'Mailles'),
 (22, '2', 1, 0, 0, 1, 0, 'result_commune', 22, 'results', 'Communes', 'Communes'),
 (21, '2', 1, 0, 0, 1, 0, 'result_geometrie', 23, 'results', 'Géométries précises', 'Géométries précises'),
 (4991, '61', 1, 0, 0, 0, 0, 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 8, NULL, 'Réserves naturelles régionales', 'Réserves naturelles régionales'),
 (461, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 3, NULL, 'Sites acquis des Conservatoires d''espaces naturels', 'Sites acquis des Conservatoires d''espaces naturels'),
 (10001, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_APB_WFS', 10001, NULL, 'Arrêtés de protection de biotope', 'Arrêtés de protection de biotope'),
 (10002, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_BIOS_WFS', 10002, NULL, 'Réserves de biosphère', 'Réserves de biosphère'),
 (10005, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_MNHN_CONSERVATOIRES_WFS', 10005, NULL, 'Sites acquis des Conservatoires d''espaces naturels', 'Sites acquis des Conservatoires d''espaces naturels'),
 (10006, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PNM_WFS', 10006, NULL, 'Parcs naturels marins', 'Parcs naturels marins'),
 (10007, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PNR_WFS', 10007, NULL, 'Parcs naturels régionaux', 'Parcs naturels régionaux'),
 (10008, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_PN_WFS', 10008, NULL, 'Parcs nationaux', 'Parcs nationaux'),
 (10009, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RAMSAR_WFS', 10009, NULL, 'Zones humides d''importance internat.', 'Zones humides d''importance internat.'),
 (10010, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RB_WFS', 10010, NULL, 'Réserves biologiques', 'Réserves biologiques'),
 (10011, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RIPN_WFS', 10011, NULL, 'Réserves intégrales de parcs nationaux', 'Réserves intégrales de parcs nationaux'),
 (10012, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNCF_WFS', 10012, NULL, 'Rés nation. chasse et faune sauvage', 'Rés nation. chasse et faune sauvage'),
 (10013, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNC_WFS', 10013, NULL, 'Réserves naturelles de Corse', 'Réserves naturelles de Corse'),
 (10014, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_RNN_WFS', 10014, NULL, 'Réserves naturelles nationales', 'Réserves naturelles nationales'),
 (10015, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_SIC_WFS', 10015, NULL, 'Sites Natura 2000 (Directive Habitats)', 'Sites Natura 2000 (Directive Habitats)'),
 (10016, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_UNESCO_WFS', 10016, NULL, 'Patrimoine mondial de l''UNESCO', 'Patrimoine mondial de l''UNESCO'),
 (10017, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZNIEFF1_WFS', 10017, NULL, 'ZNIEFF1', 'ZNIEFF1'),
 (10018, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZNIEFF2_WFS', 10018, NULL, 'ZNIEFF2', 'ZNIEFF2'),
 (10019, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_ZPS_WFS', 10019, NULL, 'Sites Natura 2000 (Directive Oiseaux)', 'Sites Natura 2000 (Directive Oiseaux)'),
 (10020, '61', 1, 0, 0, 0, 0, 'PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 10020, NULL, 'Réserves naturelles régionales', 'Réserves naturelles régionales'),
 (45, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.MNHN.CDL.PERIMETER', 2, NULL, 'Conservatoire du littoral : périmètres d''intervention', 'Conservatoire du littoral : périmètres d''intervention'),
 (44, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.MNHN.CDL.PARCELS', 1, NULL, 'Conservatoire du littoral : parcelles protégées', 'Conservatoire du littoral : parcelles protégées'),
 (10003, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_MNHN_CDL_PERIMETER_WFS', 10003, NULL, 'Conservatoire du littoral : périmètres d''intervention', 'Conservatoire du littoral : périmètres d''intervention'),
 (10004, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS_MNHN_CDL_PARCELS_WFS', 10004, NULL, 'Conservatoire du littoral : parcelles protégées', 'Conservatoire du littoral : parcelles protégées');

  
UPDATE layer_tree_node SET label = layer.label FROM layer WHERE layer_tree_node.layer_name = layer.name;
UPDATE layer_tree_node SET definition = layer.label FROM layer WHERE layer_tree_node.layer_name = layer.name;


DELETE FROM provider_map_params;
-- Configure the provider_map_params for default data provider
INSERT INTO provider_map_params (provider_id, zoom_level, bb_xmin, bb_ymin, bb_xmax, bb_ymax) values ('0', '@bb.zoom@', '@bb.xmin@', '@bb.ymin@', '@bb.xmax@', '@bb.ymax@');

DELETE FROM bac_commune;
DELETE FROM bac_departement;
DELETE FROM bac_maille;
-- Populate the vizualisation bacs with the referentiels tables
INSERT INTO bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857), r.insee_dep FROM referentiels.commune_carto_2017 AS r;
INSERT INTO bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.departement_carto_2017 AS r;
INSERT INTO bac_maille SELECT r.code_10km, St_Transform(r.geom, 3857) FROM referentiels.codemaillevalue AS r;

-- Populate maille_departement table
INSERT INTO mapping.maille_departement
SELECT id_maille, id_departement FROM mapping.bac_maille, mapping.bac_departement WHERE st_intersects(bac_maille.geom, bac_departement.geom);

-- Populate commune_maille table
INSERT INTO mapping.commune_maille
SELECT id_commune, id_maille FROM mapping.bac_commune, mapping.bac_maille WHERE st_intersects(bac_commune.geom, bac_maille.geom);
