INSERT INTO website.permission(permission_code, permission_label) VALUES ('MANAGE_OWNED_PRIVATE_REQUEST', 'Gérer ses requêtes privées');
INSERT INTO website.permission(permission_code, permission_label) VALUES ('MANAGE_PUBLIC_REQUEST', 'Gérer les requêtes publiques');

UPDATE website.permission_per_role SET permission_code='MANAGE_OWNED_PRIVATE_REQUEST' WHERE permission_code='MANAGE_PRIVATE_REQUESTS';
UPDATE website.permission_per_role SET permission_code='MANAGE_PUBLIC_REQUEST' WHERE permission_code='MANAGE_PUBLIC_REQUESTS';

DELETE FROM website.permission WHERE permission_code = 'MANAGE_PUBLIC_REQUESTS';
DELETE FROM website.permission WHERE permission_code = 'MANAGE_PRIVATE_REQUESTS';