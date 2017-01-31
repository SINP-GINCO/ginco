/* Group layers of Espaces naturels*/

DELETE FROM layer WHERE layer_name='Espaces naturels';

INSERT INTO layer (layer_name, layer_label, service_layer_name, istransparent, default_opacity, isbaselayer, isuntiled, maxscale, minscale, has_legend, provider_id, activate_type, view_service_name, legend_service_name, detail_service_name, feature_service_name) VALUES
('en_pr', 'EN - Protections réglementaires', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pc', 'EN - Protections contractuelles', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pmf', 'EN - Protections par la maîtrise foncière', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_pconv', 'EN - Protections au titre de conventions', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_n2000', 'EN - Natura 2000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('en_znieff', 'EN - ZNIEFF', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

DELETE FROM layer_tree;

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
(41, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF1', 42, NULL),
(42, '66', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZNIEFF2', 41, NULL),
(43, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.APB', 43, NULL),
(44, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CEN', 44, NULL),
(45, '63', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.CDL', 45, NULL),
(46, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PN', 46, NULL),
(47, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNM', 47, NULL),
(48, '62', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.PNR', 48, NULL),
(49, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RB', 49, NULL),
(491, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.BIOS', 491, NULL),
(492, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNC', 492, NULL),
(493, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RN', 493, NULL),
(494, '61', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RNCF', 494, NULL),
(495, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.SIC', 495, NULL),
(496, '65', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.ZPS', 496, NULL),
(497, '64', 1, 0, 0, 0, 0, 'PROTECTEDAREAS.RAMSAR', 497, NULL),
(70, '-1', 0, 1, 0, 0, 1, 'Fonds', 70, NULL),
(51, '70', 1, 1, 0, 0, 0, 'ORTHOIMAGERY.ORTHOPHOTOS', 52, NULL),
(52, '70', 1, 0, 0, 0, 0, 'plan_ign', 51, NULL);
