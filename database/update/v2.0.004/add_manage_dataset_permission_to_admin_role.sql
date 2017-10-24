----------------------------------------------
--#1223 : Add missing permission to admin role
----------------------------------------------
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS');