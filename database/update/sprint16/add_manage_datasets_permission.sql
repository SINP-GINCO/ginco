-- Ajout d'une permission MANAGE_DATASETS "Gestion des jeux de données", qui permet entre autres l'export GML

set search_path = website;

-- Add the permission
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_DATASETS', 'Gérer les jeux de données (export GML, ,..)');

-- Add the permission per role
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'MANAGE_DATASETS');
