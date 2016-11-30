SET search_path TO website;

INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIGURE_WEBSITE_PARAMETERS', 'Configurer les paramètres de la plateforme');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CONFIGURE_WEBSITE_PARAMETERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CONFIGURE_WEBSITE_PARAMETERS');
