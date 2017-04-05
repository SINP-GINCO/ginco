DELETE * FROM mapping.layer_tree;

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

INSERT INTO layer (layer_name, layer_label, service_layer_name, istransparent, default_opacity, isbaselayer, isuntiled, maxscale, minscale, has_legend, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
('PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL),
('PROTECTEDSITES_MNHN_RESERVES-REGIONALES_WFS', 'Réserves naturelles régionales', 'PROTECTEDSITES.MNHN.RESERVES-REGIONALES:wld_rnr', 1, 100, 0, 1, NULL, NULL, 1, NULL, 'NONE', NULL, NULL, NULL, 'EN_WFS_GetFeature'),
('PROTECTEDAREAS.MNHN.CONSERVATOIRES', 'Sites acquis des Conservatoires d''espaces naturels', 'PROTECTEDAREAS.MNHN.CONSERVATOIRES', 0, 100, 0, 0, NULL, NULL, 0, NULL, 'NONE', 'geoportal_wmts_png', NULL, 'geoportal_wmts_png', NULL);

INSERT INTO layer_service VALUES ('EN_WMS_Legend', '{"urls":["https://www.geoportail.gouv.fr/depot/layers/"],"params":{}}');
