set search_path to mapping;

/* Now, "fake layers" used to create groups in layer tree don't have to be declared in mapping.layer any more.
 * --> Remove NOT NULL constraint on layer_tree_node.layer_name, as for groups, it must be NULL.
 * --> remove group layers from mapping.layer
 * Name of the group layers must be in the layer_tree_node.label column.
  */

ALTER TABLE layer_tree_node ALTER COLUMN layer_name DROP NOT NULL;

UPDATE layer_tree_node SET layer_name=NULL, label='Résultats de la recherche' WHERE layer_name='results';
UPDATE layer_tree_node SET layer_name=NULL, label='Limites administratives' WHERE layer_name='Limites administratives';
UPDATE layer_tree_node SET layer_name=NULL, label='Espaces naturels' WHERE layer_name='espaces_naturels';
UPDATE layer_tree_node SET layer_name=NULL, label='Fonds' WHERE layer_name='Fonds';

DELETE FROM layer WHERE name='results';
DELETE FROM layer WHERE name='Limites administratives';
DELETE FROM layer WHERE name='espaces_naturels';
DELETE FROM layer WHERE name='Fonds';
