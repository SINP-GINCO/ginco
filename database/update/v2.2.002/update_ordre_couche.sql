--- UPDATE Resultats de la recherche
--- UPDATE position Géométries précises
UPDATE layer_tree_node SET position = 23  WHERE node_id= 21;

--- UPDATE position Communes
UPDATE layer_tree_node SET position = 22  WHERE node_id= 22;

--- UPDATE Département
UPDATE layer_tree_node SET position = 21  WHERE node_id= 24;

--- UPDATE Mailles
UPDATE layer_tree_node SET position = 24  WHERE node_id= 23;

--- UPDATE  LIMITES ADMINISTRATIVES

--- UPDATE Mailles 10km
UPDATE layer_tree_node SET position = 32  WHERE node_id= 34;

--- UPDATE position Communes
UPDATE layer_tree_node SET position = 33  WHERE node_id= 33;

--- UPDATE Département
UPDATE layer_tree_node SET position = 34  WHERE node_id= 32;

--- UPDATE Régions
UPDATE layer_tree_node SET position = 31  WHERE node_id= 31;

