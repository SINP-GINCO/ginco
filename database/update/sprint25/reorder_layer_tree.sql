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
With UpdateData As
(
    SELECT ROW_NUMBER() OVER (ORDER BY label) AS newpos, name, label
    FROM layer
    WHERE name LIKE 'PROTECTEDAREAS%'
)
UPDATE layer_tree_node SET "position"=newpos + 100
FROM UpdateData
WHERE layer_tree_node.layer_name = UpdateData.name
