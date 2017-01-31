set search_path to mapping;

/* Resultats : du plus fin au plus grossier */
UPDATE layer_tree_node SET "position"=21 WHERE layer_name='result_geometrie';
UPDATE layer_tree_node SET "position"=22 WHERE layer_name='result_commune';
UPDATE layer_tree_node SET "position"=23 WHERE layer_name='result_maille';
UPDATE layer_tree_node SET "position"=24 WHERE layer_name='result_departement';

/* Limites administratives : idem */
UPDATE layer_tree_node SET "position"=31 WHERE layer_name='communes';
UPDATE layer_tree_node SET "position"=32 WHERE layer_name='mailles';
UPDATE layer_tree_node SET "position"=33 WHERE layer_name='departements';
UPDATE layer_tree_node SET "position"=34 WHERE layer_name='regions';

/* Fonds*/
UPDATE layer_tree_node SET "position"=51 WHERE layer_name='ORTHOIMAGERY.ORTHOPHOTOS';
UPDATE layer_tree_node SET "position"=52 WHERE layer_name='plan_ign';

/* Espaces naturels: ordre alphabétique*/
/*With UpdateData As
(
    SELECT ROW_NUMBER() OVER (ORDER BY label) AS newpos, name, label
    FROM layer
    WHERE name LIKE 'PROTECTEDAREAS%'
)
UPDATE layer_tree_node SET "position"=newpos + 100, node_id=newpos + 100
FROM UpdateData
WHERE layer_tree_node.layer_name = UpdateData.name;
*/

/* Espaces naturels: sous-groupes */
ALTER TABLE layer_tree_node ALTER COLUMN label TYPE character varying(50);

DELETE FROM layer_tree_node;

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

