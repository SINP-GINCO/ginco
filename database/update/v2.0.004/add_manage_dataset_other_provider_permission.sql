-----------------------------------------------------------
--#1223 : Add new MANAGE_DATASETS_OTHER_PROVIDER permission
-----------------------------------------------------------

-- Create new permission
INSERT INTO website.permission (permission_code, permission_label) VALUES ('MANAGE_DATASETS_OTHER_PROVIDER', 'Gérer tous les jeux de données (dont ceux des autres utilisateurs)');
-- Update older permission
UPDATE website.permission SET permission_label = 'Exporter les jeux de données au format DEE' WHERE permission_code = 'MANAGE_DATASETS';
-- Add permission to admin and dev roles
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS_OTHER_PROVIDER');