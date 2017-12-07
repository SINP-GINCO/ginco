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
INSERT INTO role(role_label, role_definition, is_default) VALUES ('Développeur', 'developpeur', false);
INSERT INTO role(role_label, role_definition, is_default) VALUES ('Administrateur', 'Administrateur de plateforme régionale ou thématique', false);
INSERT INTO role(role_label, role_definition, is_default) VALUES ('Producteur', 'producteur', true);
INSERT INTO role(role_label, role_definition, is_default) VALUES ('Grand public', 'Rôle par défaut non-modifiable pour un utilisateur non identifié', false);

-- Create default provider
INSERT INTO website.providers(id,label,definition) VALUES ('1', 'Defaut', 'Organisme par défaut');

-- Create users with rights on every platforms
-- We add users on default provider because we don't want to create other providers on the platform
INSERT INTO website.users(user_login, provider_id, email) VALUES
  ('gautam.pastakia',1,'gautam.pastakia@ign.fr'),
  ('anna.mouget@ign.fr',1,'anna.mouget@ign.fr'),
  ('scandel',1,'severine.candelier@ign.fr'),
  ('vsagniez',1,'vincent.sagniez@ign.fr'),
  ('jpanijel',1,'jpanijel@mnhn.fr'),
  ('nbotte',1,'noemie.botte@mnhn.fr'),
  ('tgerbeau',1,'thierry.gerbeau@ign.fr')
;
-- Create visiteur special user
INSERT INTO users(user_login, user_name, provider_id, email) VALUES ('visiteur', 'visiteur', '1', 'sinp-dev@ign.fr');

-- Link the users to their roles
INSERT INTO website.role_to_user(user_login, role_code) VALUES
  ('gautam.pastakia', 1),
  ('anna.mouget@ign.fr', 1),
  ('scandel', 1),
  ('vsagniez', 1),
  ('jpanijel', 2),
  ('nbotte', 2),
  ('tgerbeau', 1)
;
INSERT INTO role_to_user(user_login, role_code) VALUES ('visiteur', 4);

-- Link the role to schemas
INSERT INTO role_to_schema(role_code, schema_code) VALUES (1, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (2, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (3, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (4, 'RAW_DATA');

-- List the permissions of the web site
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_USERS', 'Administrer les utilisateurs');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_INTEGRATION', 'Importer des données');
INSERT INTO permission(permission_code, permission_label) VALUES ('DATA_QUERY', 'Visualiser les données régionales publiées');
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
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_DATASETS', 'Exporter les jeux de données au format DEE');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_DATASETS_OTHER_PROVIDER', 'Gérer les jeux de données de tous les utilisateurs');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIRM_SUBMISSION', 'Publier les données');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_PUBLIC_REQUEST', 'Gérer les requêtes publiques');
INSERT INTO permission(permission_code, permission_label) VALUES ('MANAGE_OWNED_PRIVATE_REQUEST', 'Gérer ses requêtes privées');
INSERT INTO permission(permission_code, permission_label) VALUES ('CONFIGURE_WEBSITE_PARAMETERS', 'Configurer les paramètres de la plateforme');

-- Add the permissions for role Développeur
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
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIGURE_WEBSITE_PARAMETERS');

-- Add the permissions for role Administrateur
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
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_WEBSITE_PARAMETERS');

-- Add the permissions for role Producteur
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'MANAGE_PRIVATE_REQUEST');

-- Add the permissions for role Grand public
INSERT INTO permission_per_role(role_code, permission_code) VALUES (4, 'DATA_QUERY');
