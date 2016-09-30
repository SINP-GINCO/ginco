-- Initialisation des rôles et des utilisateurs par défaut.
-- Ne doit pas être exécuté QUE pour initialiser la base et jamais pour une mise à jour.


set search_path = website;

DELETE FROM providers;
DELETE FROM permission_per_role;
DELETE FROM layer_role_restriction;
DELETE FROM role_to_user;
DELETE FROM role;
DELETE FROM users;
DELETE FROM role_to_schema;
DELETE FROM permission;

-- Create some roles
INSERT INTO role(role_code, role_label, role_definition) VALUES ('developpeur','Développeur', 'developpeur');
INSERT INTO role(role_code, role_label, role_definition) VALUES ('administrateur','Administrateur', 'Administrateur de plateforme régionale ou thématique');
INSERT INTO role(role_code, role_label, role_definition) VALUES ('producteur','Producteur', 'producteur');
INSERT INTO role(role_code, role_label, role_definition) VALUES ('visiteur','Visiteur', 'Visiteur non loggué');

-- Create a provider
INSERT INTO website.providers(id,label,definition) VALUES ('1', 'Defaut', 'Organisme par défaut');
ALTER sequence website.provider_id_seq restart with 2;

-- Create some users
-- password are equals to login, they must be changed for production
INSERT INTO users(user_login, user_password, user_name, provider_id, active, email) VALUES ('developpeur', 'ccd46ad476382e50b51f52a5574c2cb511125f0e', 'developpeur', '1', '1', null);
INSERT INTO users(user_login, user_password, user_name, provider_id, active, email) VALUES ('visiteur', '922391a72f5d8792a0b66b6cb3674d5eae454bda', 'visiteur', '1', '1', null);

-- Link the users to their roles
INSERT INTO role_to_user(user_login, role_code) VALUES ('developpeur', 'developpeur');
INSERT INTO role_to_user(user_login, role_code) VALUES ('visiteur', 'visiteur');

-- Link the role to schemas
INSERT INTO ROLE_TO_SCHEMA(ROLE_CODE, SCHEMA_CODE) VALUES ('developpeur', 'RAW_DATA');
INSERT INTO ROLE_TO_SCHEMA(ROLE_CODE, SCHEMA_CODE) VALUES ('administrateur', 'RAW_DATA');
INSERT INTO ROLE_TO_SCHEMA(ROLE_CODE, SCHEMA_CODE) VALUES ('producteur', 'RAW_DATA');
INSERT INTO role_to_schema(ROLE_CODE, SCHEMA_CODE) VALUES ('visiteur', 'RAW_DATA');

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
INSERT INTO permission(permission_code, permission_label) VALUES ('ACCESS_GEOSOURCE', 'Consulter les métadonnées');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_DATASETS', 'Gérer les jeux de données (export GML, ,..)');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIRM_SUBMISSION', 'Publier les données');


-- Add the permissions per role
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CHECK_CONF');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'ACCESS_GEOSOURCE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'MANAGE_DATASETS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('developpeur', 'CONFIRM_SUBMISSION');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'ACCESS_GEOSOURCE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('administrateur', 'CONFIRM_SUBMISSION');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('producteur', 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('producteur', 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('producteur', 'ACCESS_GEOSOURCE');

INSERT INTO permission_per_role(role_code, permission_code) VALUES ('visiteur', 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES ('visiteur', 'DATA_QUERY_OTHER_PROVIDER');

INSERT INTO layer_role_restriction (layer_name, role_code) VALUES ('result_geometrie', 'visiteur');
