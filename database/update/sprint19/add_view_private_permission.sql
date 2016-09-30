SET search_path TO website;

INSERT INTO permission(permission_code, permission_label) VALUES ('VIEW_PRIVATE', 'Visualiser les données privées');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'VIEW_PRIVATE');
