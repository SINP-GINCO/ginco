set search_path = website;

-- List the permissions of the web site
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIRM_SUBMISSION', 'Publier les données');

-- Add the permissions per role
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CONFIRM_SUBMISSION');
