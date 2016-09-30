ALTER TABLE mapping.layer DROP COLUMN imageformat;
ALTER TABLE mapping.layer DROP COLUMN has_sld;
ALTER TABLE mapping.layer DROP COLUMN transitioneffect;

INSERT INTO mapping.layer_service(service_name, config) VALUES ('geoportal_wmts_png', '{"urls":["https://wxs.ign.fr/@view.geoportail.key@/geoportail/wmts?"],"params":{"SERVICE":"WMTS","VERSION":"1.0.0","REQUEST":"getTile","format":"image/png","style":"normal","matrixSet":"PM","requestEncoding":"KVP","maxExtent":[-20037508, -20037508, 20037508, 20037508],"serverResolutions":[156543.033928,78271.516964,39135.758482,19567.879241,9783.939621,4891.969810,2445.984905,1222.992453,611.496226,305.748113,152.874057,76.437028,38.218514,19.109257,9.554629,4.777302,2.388657,1.194329,0.597164,0.298582,0.149291,0.074646],"tileOrigin":[-20037508,20037508]}}');

INSERT INTO mapping.layer VALUES ('espaces_naturels', 'Espaces naturels', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO mapping.layer VALUES ('PROTECTEDAREAS.ZNIEFF1', 'ZNIEFF1', 'PROTECTEDAREAS.ZNIEFF1', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);
INSERT INTO mapping.layer VALUES ('PROTECTEDAREAS.ZNIEFF2', 'ZNIEFF2', 'PROTECTEDAREAS.ZNIEFF2', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);

DELETE FROM mapping.layer_tree;

-- l'ordre des layers est correct avec cette config... mais je ne sais pas pourquoi...
INSERT INTO mapping.layer_tree VALUES (2, '-1', 0, 1, 0, 0, 1, 'results', 1, NULL);
INSERT INTO mapping.layer_tree VALUES (21, '2', 1, 1, 0, 1, 0, 'result_geometrie', 24, NULL);
INSERT INTO mapping.layer_tree VALUES (22, '2', 1, 1, 0, 1, 0, 'result_commune', 21, NULL);
INSERT INTO mapping.layer_tree VALUES (23, '2', 1, 1, 0, 1, 0, 'result_maille', 23, NULL);
INSERT INTO mapping.layer_tree VALUES (24, '2', 1, 1, 0, 1, 0, 'result_departement', 22, NULL);

INSERT INTO mapping.layer_tree VALUES (3, '-1', 0, 1, 0, 0, 1, 'Limites administratives', 3, NULL);
INSERT INTO mapping.layer_tree VALUES (31, '3', 1, 1, 0, 0, 0, 'communes', 34, NULL);
INSERT INTO mapping.layer_tree VALUES (32, '3', 1, 1, 0, 0, 0, 'mailles', 31, NULL);
INSERT INTO mapping.layer_tree VALUES (33, '3', 1, 1, 0, 0, 0, 'departements', 33, NULL);
INSERT INTO mapping.layer_tree VALUES (34, '3', 1, 1, 0, 0, 0, 'regions', 32, NULL);

INSERT INTO mapping.layer_tree VALUES (4, '-1', 0, 1, 0, 0, 1, 'espaces_naturels', 4, NULL);
INSERT INTO mapping.layer_tree VALUES (41, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 42, NULL);
INSERT INTO mapping.layer_tree VALUES (42, '4', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 41, NULL);

INSERT INTO mapping.layer_tree VALUES (5, '-1', 0, 1, 0, 0, 1, 'Fonds', 5, NULL);
INSERT INTO mapping.layer_tree VALUES (51, '5', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 52, NULL);
INSERT INTO mapping.layer_tree VALUES (52, '5', 1, 0, 0, 0, 0, 'plan_ign', 51, NULL);