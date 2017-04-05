SET SEARCH_PATH = mapping, public;


-- Add the available map scales
DELETE FROM scales;
INSERT INTO scales(scale) VALUES (69885283);
INSERT INTO scales(scale) VALUES (34942642);
INSERT INTO scales(scale) VALUES (17471321);
INSERT INTO scales(scale) VALUES (8735660);
INSERT INTO scales(scale) VALUES (4367830);
INSERT INTO scales(scale) VALUES (2183915);
INSERT INTO scales(scale) VALUES (1091958);
INSERT INTO scales(scale) VALUES (545979);
INSERT INTO scales(scale) VALUES (272989);
INSERT INTO scales(scale) VALUES (136495);
INSERT INTO scales(scale) VALUES (68247);
INSERT INTO scales(scale) VALUES (34124);
INSERT INTO scales(scale) VALUES (17062);
INSERT INTO scales(scale) VALUES (8531);
INSERT INTO scales(scale) VALUES (4265);
INSERT INTO scales(scale) VALUES (2133);

-- Conf des services et des layers

DELETE FROM layer_tree;
DELETE FROM layer;
DELETE FROM layer_service;

-- Define the services

INSERT INTO layer_service (service_name, config) VALUES
  ('mapProxy','{"urls":["@site.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'),
  ('legend_mapProxy','{"urls":["@site.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}'),
  ('Local_MapProxy_WFS_GetFeature','{"urls":["@site.url@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}'),
  ('geoportal_wms','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('geoportal_wmts_png','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('EN_WFS_GetFeature', '{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wfs?"],"params":{"SERVICE":"WFS","VERSION":"1.0.0","REQUEST":"GetFeature", "outputFormat":"json"}}'),
  ('EN_WMS_Legend', '{"urls":["https://www.geoportail.gouv.fr/depot/layers/"],"params":{}}');

  
-- Define the layers and layer tree
INSERT INTO layer (layer_name, layer_label, service_layer_name, istransparent, default_opacity, isbaselayer, isuntiled, maxscale, minscale, has_legend, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
('Fonds', 'Fonds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL),
('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 100, 0, 0, 17471321, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL),
('en_pr', 'EN - Protections réglementaires', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pc', 'EN - Protections contractuelles', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pmf', 'EN - Protections par la maîtrise foncière', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pconv', 'EN - Protections au titre de conventions', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_n2000', 'EN - Natura 2000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_znieff', 'EN - ZNIEFF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.APB', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.CEN', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.CDL', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PN', 'Parcs nationaux', 'PROTECTEDAREAS.PN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PNM', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.PNR', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RB', 'Réserves biologiques', 'PROTECTEDAREAS.RB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.BIOS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RNC', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RN', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RNCF', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.SIC', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.ZPS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RAMSAR', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.UNESCO', 'Patrimoine mondial de l''UNESCO', 'PROTECTEDAREAS.UNESCO', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDAREAS.RIPN', 'Réserves intégrales de parc national', 'PROTECTEDAREAS.RIPN', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('Limites administratives', 'Limites administratives', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('regions', 'Régions', 'regions', 1, 100, 0, 0, 17471321, 4367830, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('departements', 'Départements', 'departements', 1, 100, 0, 0, 4367830, 272989, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('mailles', 'Mailles 10km', 'mailles', 1, 100, 0, 0, 1091958, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('communes', 'Communes', 'communes', 1, 100, 0, 0, 272989, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature'),
('results', 'Résultats de la recherche', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('result_departement', 'Départements', 'result_departement', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_maille', 'Mailles', 'result_maille', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_commune', 'Communes', 'result_commune', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 100, 0, 1, 272989, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL),
('PROTECTEDAREAS_APB_WFS', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB:wld_apb', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_BIOS_WFS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS:wld_bios', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_CEN_WFS', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN:cdl_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PN_WFS', 'Parcs nationaux', 'PROTECTEDAREAS.PN:pn', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNM_WFS', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM:pnm', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS_PNR_WFS', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR:pnr_wld', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
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
('PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES:wld_rnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS.MNHN.CONSERVATOIRES', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);


INSERT INTO layer_tree (item_id, parent_id, is_layer, is_checked, is_hidden, is_disabled, is_expended, name, "position", checked_group) VALUES
(2, '-1', 0, 1, 0, 0, 1, 'results', 1, NULL),
(24, '2', 1, 1, 0, 1, 0, 'result_departement', 24, 'results'),
(23, '2', 1, 0, 0, 1, 0, 'result_maille', 21, 'results'),
(22, '2', 1, 0, 0, 1, 0, 'result_commune', 23, 'results'),
(21, '2', 1, 0, 0, 1, 0, 'result_geometrie', 22, 'results'),
(3, '-1', 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL),
(31, '3', 1, 1, 0, 0, 0, 'regions', 34, NULL),
(32, '3', 1, 1, 0, 0, 0, 'departements', 31, NULL),
(34, '3', 1, 1, 0, 0, 0, 'mailles', 33, NULL),
(33, '3', 1, 1, 0, 0, 0, 'communes', 32, NULL),
(61, '-1', 0, 1, 0, 0, 0, 'en_pr', 61, NULL),
(62, '-1', 0, 1, 0, 0, 0, 'en_pc', 62, NULL),
(63, '-1', 0, 1, 0, 0, 0, 'en_pmf', 63, NULL),
(64, '-1', 0, 1, 0, 0, 0, 'en_pconv', 64, NULL),
(65, '-1', 0, 1, 0, 0, 0, 'en_n2000', 65, NULL),
(66, '-1', 0, 1, 0, 0, 0, 'en_znieff', 66, NULL),
(43, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 1, NULL),
(49, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 2, NULL),
(46, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 3, NULL),
(492, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 4, NULL),
(493, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 5, NULL),
(494, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 6, NULL),
(499, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RIPN', 7, NULL),
(4991, '61', 1, 0, 0, 0, 0, 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 8, NULL),
(47, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 1, NULL),
(48, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 2, NULL),
(44, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 1, NULL),
(45, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 2, NULL),
(461, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 3, NULL),
(491, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 1, NULL),
(497, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 2, NULL),
(498, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.UNESCO', 3, NULL),
(495, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 1, NULL),
(496, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 2, NULL),
(41, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 1, NULL),
(42, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 2, NULL),
(70, '-1', 0, 1, 0, 0, 1, 'Fonds', 70, NULL),
(51, '70', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 1, NULL),
(52, '70', 1, 0, 0, 0, 0, 'plan_ign', 2, NULL);

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
