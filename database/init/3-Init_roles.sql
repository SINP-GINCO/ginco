-- Initialisation des rôles et des utilisateurs par défaut.
-- Ne doit pas être exécuté QUE pour initialiser la base et jamais pour une mise à jour.


set search_path = website;

DELETE FROM providers;
DELETE FROM permission_per_role;
DELETE FROM role_to_user;
DELETE FROM role;
DELETE FROM users;
DELETE FROM role_to_schema;
DELETE FROM permission;

-- Create some roles
INSERT INTO role(role_label, role_definition) VALUES ('Développeur', 'developpeur');
INSERT INTO role(role_label, role_definition) VALUES ('Administrateur', 'Administrateur de plateforme régionale ou thématique');
INSERT INTO role(role_label, role_definition) VALUES ('Producteur', 'producteur');
INSERT INTO role(role_label, role_definition) VALUES ('Grand public', 'Rôle par défaut non-modifiable pour un utilisateur non identifié');

-- Create a provider
INSERT INTO website.providers(id,label,definition) VALUES ('1', 'Defaut', 'Organisme par défaut');
ALTER sequence website.provider_id_seq restart with 2;

-- Create some users
-- password are equals to login, they must be changed for production
INSERT INTO users(user_login, user_password, user_name, provider_id, email) VALUES ('developpeur', 'ccd46ad476382e50b51f52a5574c2cb511125f0e', 'developpeur', '1', 'sinp-dev@ign.fr');
INSERT INTO users(user_login, user_password, user_name, provider_id, email) VALUES ('visiteur', '922391a72f5d8792a0b66b6cb3674d5eae454bda', 'visiteur', '1', 'sinp-dev@ign.fr');

-- Link the users to their roles
INSERT INTO role_to_user(user_login, role_code) VALUES ('developpeur', 1);
INSERT INTO role_to_user(user_login, role_code) VALUES ('visiteur', 4);

-- Link the role to schemas
INSERT INTO role_to_schema(role_code, schema_code) VALUES (1, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (2, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (3, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (4, 'RAW_DATA');

-- List the permissions of the web site
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_USERS', 'Administrer les utilisateurs');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_INTEGRATION', 'Importer des données');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_QUERY', 'Visualiser les données régionales');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_QUERY_OTHER_PROVIDER', 'Visualiser les données d''un autre fournisseur');
INSERT INTO permission(permission_code, permission_label) VALUES ('EXPORT_RAW_DATA', 'Exporter les données (au format CSV, GeoJson, kml...)');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_EDITION', 'Editer les données');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_EDITION_OTHER_PROVIDER', 'Editer les données d''un autre fournisseur');
INSERT INTO permission(permission_code, permission_label) VALUES ('CANCEL_VALIDATED_SUBMISSION', 'Annuler une soumission de données validées');
INSERT INTO permission(permission_code, permission_label) VALUES ('CANCEL_OTHER_PROVIDER_SUBMISSION', 'Annuler une soumission de données d''un autre fournisseur');
INSERT INTO permission(permission_code, permission_label) VALUES ('CHECK_CONF', 'Vérifier la configuration technique (PHP, mémoire,...)');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIGURE_METAMODEL', 'Configurer le méta-modèle');
INSERT INTO permission(permission_code, permission_label) VALUES ('VIEW_SENSITIVE', 'Visualiser les données sensibles');
INSERT INTO permission(permission_code, permission_label) VALUES ('VIEW_PRIVATE', 'Visualiser les données privées');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_DATASETS', 'Gérer les jeux de données (export GML, ,..)');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIRM_SUBMISSION', 'Publier les données');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_PUBLIC_REQUEST', 'Gérer les requêtes publiques');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_OWNED_PRIVATE_REQUEST', 'Gérer ses requêtes privées');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIGURE_WEBSITE_PARAMETERS', 'Configurer les paramètres de la plateforme');

-- Add the permissions per role
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CHECK_CONF');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_DATASETS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIGURE_WEBSITE_PARAMETERS');

INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_WEBSITE_PARAMETERS');

INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'MANAGE_PRIVATE_REQUEST');

INSERT INTO permission_per_role(role_code, permission_code) VALUES (4, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (4, 'DATA_QUERY_OTHER_PROVIDER');
