SET search_path = mapping;

-- Drop obsolete columns
ALTER TABLE layer DROP COLUMN IF EXISTS isvector;
ALTER TABLE layer DROP COLUMN IF EXISTS print_service_name;

DELETE FROM layer_tree;
DELETE FROM layer;
DELETE FROM layer_service;

-- Define the services
INSERT INTO layer_service (service_name, config) VALUES
  ('local_mapserver','{"urls":["@ogam.local.map.services.url@/mapserv.sinp?"],"params":{"SERVICE":"WMS", "VERSION":"1.1.0","REQUEST":"GetMap"}}'),
  ('mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetMap"}}'),
  ('legend_mapProxy','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WMS","VERSION":"1.1.1","REQUEST":"GetLegendGraphic"}}'),
  ('Local_MapProxy_WFS_GetFeature','{"urls":["@ogam.map.services.url@/mapserverProxy.php?"],"params":{"SERVICE":"WFS","VERSION":"1.1.0","REQUEST":"GetFeature"}}'),
  ('geoportal_wms','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/r/wms?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}'),
  ('geoportal_wmts','{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}');

-- ('geoportal_wmts_print','{"urls":["http://wxs-i.ign.fr/7gr31kqe5xttprd2g7zbkqgo/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","style":"normal","matrixSet":"PM"}}');
-- INSERT INTO layer_service (service_name, config) VALUES ('proxy_wfs', '{"urls":["http://localhost.ogam-ginco.ign.fr/proxy/getwfs?"],"params":{"SERVICE":"WFS","VERSION":"1.0.0","REQUEST":"GetFeature"}}');
-- INSERT INTO layer_service (service_name, config) VALUES ('local_tilecache', '{"urls":["http://localhost.ogam-ginco.ign.fr/cgi-bin/tilecache/tilecache.cgi?"],"params":{"SERVICE":"WMS","VERSION":"1.0.0","REQUEST":"GetMap"}}');
-- INSERT INTO layer_service (service_name, config) VALUES ('proxy_tile', '{"urls":["http://localhost.ogam-ginco.ign.fr/proxy/gettile?"],"params":{"SERVICE":"WMS","VERSION":"1.3.0","REQUEST":"GetMap"}}');

-- Define the layers
INSERT INTO layer VALUES ('Fonds', 'Fonds', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('Limites administratives', 'Limites administratives', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO layer VALUES ('plan_ign', 'Carte IGN', 'GEOGRAPHICALGRIDSYSTEMS.PLANIGN', 0, 100, 0, 0, 17471321, NULL, 0, 'resize', 'jpeg', NULL, 0, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wmts', NULL);
INSERT INTO layer VALUES ('communes', 'Communes', 'communes', 1, 100, 0, 0, 272989, NULL, 1, NULL, 'PNG', NULL, 0, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('departements', 'Départements', 'departements', 1, 100, 0, 0, 4367830, 272989, 1, NULL, 'PNG', NULL, 0, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('ORTHOIMAGERY.ORTHOPHOTOS', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS', 0, 100, 0, 0, NULL, NULL, 0, 'resize', 'jpeg', NULL, 0, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL);
INSERT INTO layer VALUES ('ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 'Orthophotographies', 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO', 0, 100, 0, 0, NULL, NULL, 0, 'resize', 'jpeg', NULL, 0, 'NONE', 'geoportal_wmts', NULL, 'geoportal_wms', NULL);
INSERT INTO layer VALUES ('regions', 'Régions', 'regions', 1, 100, 0, 0, 17471321, 4367830, 1, NULL, 'PNG', NULL, 0, 'NONE', 'mapProxy', 'legend_mapProxy', 'mapProxy', 'Local_MapProxy_WFS_GetFeature');
INSERT INTO layer VALUES ('result_locations', 'Résultats de la recherche', 'result_locations', 1, 100, 0, 1, NULL, NULL, 0, NULL, 'PNG', NULL, 0, 'REQUEST', 'mapProxy', 'legend_mapProxy', 'mapProxy', NULL);
--
-- Define the layers legend
--
INSERT INTO layer_tree VALUES (1, '-1', 1, 0, 0, 1, 0, 'result_locations', 1, NULL);
INSERT INTO layer_tree VALUES (3, '-1', 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL);
INSERT INTO layer_tree VALUES (4, '-1', 0, 1, 0, 0, 1, 'Fonds', 4, NULL);
INSERT INTO layer_tree VALUES (41, '4', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 42, NULL);
INSERT INTO layer_tree VALUES (32, '3', 1, 1, 0, 0, 0, 'departements', 33, NULL);
INSERT INTO layer_tree VALUES (31, '3', 1, 1, 0, 0, 0, 'regions', 35, NULL);
INSERT INTO layer_tree VALUES (33, '3', 1, 1, 0, 0, 0, 'communes', 34, NULL);
INSERT INTO layer_tree VALUES (42, '4', 1, 0, 0, 0, 0, 'plan_ign', 41, NULL);
