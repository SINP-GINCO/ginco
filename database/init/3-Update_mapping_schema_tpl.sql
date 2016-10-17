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
  ('mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'),
  ('legend_mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}'),
  ('Local_MapProxy_WFS_GetFeature','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}'),
  ('geoportal_wms','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}'),
  ('geoportal_wmts_png','{"urls":["http://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}');

-- Define the layers
INSERT INTO layer VALUES ('Fonds', 'Fonds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL);
INSERT INTO layer VALUES ('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL);
INSERT INTO layer VALUES ('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 100, 0, 0, 17471321, NULL, 0, NULL, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL);

INSERT INTO layer VALUES ('Espaces naturels', 'Espaces naturels', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.APB', 'Arrêtés de protection de biotope', 'PROTECTEDAREAS.APB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.CEN', 'Conservatoire du littoral : parcelles protégées', 'PROTECTEDAREAS.CEN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.CDL', 'Conservatoire du littoral : périmètres d''intervention', 'PROTECTEDAREAS.CDL', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.PN', 'Parcs nationaux', 'PROTECTEDAREAS.PN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.PNM', 'Parcs naturels marins', 'PROTECTEDAREAS.PNM', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.PNR', 'Parcs naturels régionaux', 'PROTECTEDAREAS.PNR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.RB', 'Réserves biologiques', 'PROTECTEDAREAS.RB', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.BIOS', 'Réserves de biosphère', 'PROTECTEDAREAS.BIOS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.RNC', 'Réserves naturelles de Corse', 'PROTECTEDAREAS.RNC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.RN', 'Réserves naturelles nationales', 'PROTECTEDAREAS.RN', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.RNCF', 'Rés nation. chasse et faune sauvage', 'PROTECTEDAREAS.RNCF', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.SIC', 'Sites Natura 2000 (Directive Habitats)', 'PROTECTEDAREAS.SIC', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.ZPS', 'Sites Natura 2000 (Directive Oiseaux)', 'PROTECTEDAREAS.ZPS', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO layer VALUES ('PROTECTEDAREAS.RAMSAR', 'Zones humides d''importance internat.', 'PROTECTEDAREAS.RAMSAR', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);

INSERT INTO layer VALUES ('Limites administratives', 'Limites administratives', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('regions', 'Régions', 'regions', 1, 100, 0, 0, 17471321, 4367830, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('departements', 'Départements', 'departements', 1, 100, 0, 0, 4367830, 272989, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('mailles', 'Mailles 10km', 'mailles', 1, 100, 0, 0, 1091958, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('communes', 'Communes', 'communes', 1, 100, 0, 0, 272989, NULL, 1, NULL, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');

INSERT INTO layer VALUES ('results', 'Résultats de la recherche', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('result_departement', 'Départements', 'result_departement', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_maille', 'Mailles', 'result_maille', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_commune', 'Communes', 'result_commune', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
INSERT INTO layer VALUES ('result_geometrie', 'Géométries précises', 'result_geometrie', 1, 100, 0, 1, 272989, NULL, 0, NULL, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);

--
-- Define the layers legend
--
INSERT INTO mapping.layer_tree VALUES (2, '-1', 0, 1, 0, 0, 1, 'results', 1, NULL);
INSERT INTO mapping.layer_tree VALUES (24, '2', 1, 1, 0, 1, 0, 'result_departement', 24, 'results');
INSERT INTO mapping.layer_tree VALUES (23, '2', 1, 0, 0, 1, 0, 'result_maille', 21, 'results');
INSERT INTO mapping.layer_tree VALUES (22, '2', 1, 0, 0, 1, 0, 'result_commune', 23, 'results');
INSERT INTO mapping.layer_tree VALUES (21, '2', 1, 0, 0, 1, 0, 'result_geometrie', 22, 'results');

INSERT INTO mapping.layer_tree VALUES (3, '-1', 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL);
INSERT INTO mapping.layer_tree VALUES (31, '3', 1, 1, 0, 0, 0, 'regions', 34, NULL);
INSERT INTO mapping.layer_tree VALUES (32, '3', 1, 1, 0, 0, 0, 'departements', 31, NULL);
INSERT INTO mapping.layer_tree VALUES (34, '3', 1, 1, 0, 0, 0, 'mailles', 33, NULL);
INSERT INTO mapping.layer_tree VALUES (33, '3', 1, 1, 0, 0, 0, 'communes', 32, NULL);

INSERT INTO mapping.layer_tree VALUES (4, '-1', 0, 1, 0, 0, 1, 'espaces_naturels', 4, NULL);
INSERT INTO mapping.layer_tree VALUES (41, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 42, NULL);
INSERT INTO mapping.layer_tree VALUES (42, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 41, NULL);
INSERT INTO mapping.layer_tree VALUES (43, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 43, NULL);
INSERT INTO mapping.layer_tree VALUES (44, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 44, NULL);
INSERT INTO mapping.layer_tree VALUES (45, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 45, NULL);
INSERT INTO mapping.layer_tree VALUES (46, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 46, NULL);
INSERT INTO mapping.layer_tree VALUES (47, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 47, NULL);
INSERT INTO mapping.layer_tree VALUES (48, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 48, NULL);
INSERT INTO mapping.layer_tree VALUES (49, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 49, NULL);
INSERT INTO mapping.layer_tree VALUES (491, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 491, NULL);
INSERT INTO mapping.layer_tree VALUES (492, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 492, NULL);
INSERT INTO mapping.layer_tree VALUES (493, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 493, NULL);
INSERT INTO mapping.layer_tree VALUES (494, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 494, NULL);
INSERT INTO mapping.layer_tree VALUES (495, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 495, NULL);
INSERT INTO mapping.layer_tree VALUES (496, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 496, NULL);
INSERT INTO mapping.layer_tree VALUES (497, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 497, NULL);

INSERT INTO mapping.layer_tree VALUES (5, '-1', 0, 1, 0, 0, 1, 'Fonds', 5, NULL);
INSERT INTO mapping.layer_tree VALUES (51, '5', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 52, NULL);
INSERT INTO mapping.layer_tree VALUES (52, '5', 1, 0, 0, 0, 0, 'plan_ign', 51, NULL);

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
