SET search_path TO website;

INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_PUBLIC_REQUESTS', 'Gérer les requêtes publiques');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_PRIVATE_REQUESTS', 'Gérer ses requêtes privées');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'MANAGE_PUBLIC_REQUESTS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'MANAGE_PRIVATE_REQUESTS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'MANAGE_PUBLIC_REQUESTS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'MANAGE_PRIVATE_REQUESTS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('producteur', 'MANAGE_PRIVATE_REQUESTS');


INSERT INTO website.predefined_request_group(group_name, label, definition, "position") VALUES ('public_requests', 'Recherches sauvegardées publiques', 'Recherches visibles par tous les utilisateurs.', 1);
INSERT INTO website.predefined_request_group(group_name, label, definition, "position") VALUES ('private_requests', 'Recherches sauvegardées privées', 'Recherches visibles par moi uniquement.', 2);

UPDATE website.predefined_request_group_asso SET group_name='public_requests' WHERE group_name='saved_requests';
DELETE FROM website.predefined_request_group WHERE group_name='saved_requests';


ALTER TABLE website.predefined_request ADD COLUMN user_login character varying(50);
COMMENT ON COLUMN PREDEFINED_REQUEST.USER_LOGIN IS 'The login of the user who created the request';