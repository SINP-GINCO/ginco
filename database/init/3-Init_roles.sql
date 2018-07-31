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
INSERT INTO website.providers(id,label,definition) VALUES ('0', 'Pas d''organisme', 'Organisme par défaut');

-- Create users with rights on every platforms
-- We add users on default provider because we don't want to create other providers on the platform
INSERT INTO website.users(user_login, provider_id, email) VALUES
  ('gautam.pastakia',0,'gautam.pastakia@ign.fr'),
  ('anna.mouget@ign.fr',0,'anna.mouget@ign.fr'),
  ('scandel',0,'severine.candelier@ign.fr'),
  ('vsagniez',0,'vincent.sagniez@ign.fr'),
  ('jpanijel',0,'jpanijel@mnhn.fr'),
  ('nbotte',0,'noemie.botte@mnhn.fr'),
  ('tgerbeau',0,'thierry.gerbeau@ign.fr'),
  ('cgimazane',0,'clement.gimazane@ign.fr'),
  ('rpas',0,'remi.pas@ign.fr')
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
  ('tgerbeau', 1),
  ('cgimazane', 1),
  ('rpas', 1)
;
INSERT INTO role_to_user(user_login, role_code) VALUES ('visiteur', 4);

-- Link the role to schemas
INSERT INTO role_to_schema(role_code, schema_code) VALUES (1, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (2, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (3, 'RAW_DATA');
INSERT INTO role_to_schema(role_code, schema_code) VALUES (4, 'RAW_DATA');

-- List of permission groups.
INSERT INTO website.permission_group VALUES
	('USER_MANAGEMENT', 'Administration des utilisateurs'),
	('PLATFORM_ADMINISTRATION', 'Administration de la plateforme'),
	('MODEL_CONFIGURATION', 'Configuration des modèles'),
	('JDD_MANAGEMENT', 'Gestion et consultation des jeux de données'),
	('DATA_MANAGEMENT', 'Gestion et consultation des données'),
	('REGISTERED_QUERIES', 'Requêtes enregistrées')
;

-- List the permissions of the web site
INSERT INTO permission(permission_code, permission_label, permission_group_code, description) VALUES 
  ('MANAGE_USERS', 'Administrer les utilisateurs, rôles et permissions', 'USER_MANAGEMENT', 'Ajouter et supprimer les utilisateurs dans la plateforme. Définir les rôles et y associer des permissions. Attribuer les rôles et permissions aux utilisateurs.'),
  ('MANAGE_OWN_PROVIDER', 'Déclarer son propre organisme', 'USER_MANAGEMENT', 'Déclarer soi-même son propre organisme lors de sa première connexion à la plateforme.'),
  ('MANAGE_USERS_PROVIDER', 'Rattacher les utilisateurs à leur organisme', 'USER_MANAGEMENT', 'Rattacher les utilisateurs à leur organisme sur la page "Editer un utilisateur", à partir de l''annuaire de l''INPN.'),
  ('DATA_INTEGRATION', 'Créer et gérer ses propres jeux de données', 'DATA_MANAGEMENT', 'Créer des jeux de données à partir d''une fiche de métadonnées, voir et supprimer ses propres jeux de données. Importer des données dans ses propres jeux de données, supprimer ses propres imports.'),
  ('DATA_QUERY', 'Consulter les données publiées', 'DATA_MANAGEMENT', 'Requêter et visualiser les données publiées. L''accès aux informations de localisation plus ou moins précises dépend des éventuelles restrictions d''accès des données (sensibles, privées) et des autres permissions.'),
  ('DATA_QUERY_OTHER_PROVIDER', 'Consulter toutes les données non publiées', 'DATA_MANAGEMENT', 'Requêter et visualiser toutes les données non publiées.'),
  ('EXPORT_RAW_DATA', 'Exporter les données', 'DATA_MANAGEMENT', 'Exporter (au format CSV, GeoJson, kml…) les données sur lesquelles on a les droits de consultation. Les limitations d''accès aux informations de localisation sont les mêmes que pour la consultation.'),
  ('DATA_EDITION', 'Editer les données', 'DATA_MANAGEMENT', 'Editer les données.'),
  ('DATA_EDITION_OTHER_PROVIDER', 'Editer les données d''un autre organisme', 'DATA_MANAGEMENT', 'Editer les données d''un autre organisme.'),
  ('CANCEL_VALIDATED_SUBMISSION', 'Annuler une soumission de données validées', 'DATA_MANAGEMENT', 'Annuler une de ses soumissions de données pas encore publiée.'),
  ('CANCEL_OTHER_PROVIDER_SUBMISSION', 'Annuler une soumission de données d''un autre organisme', 'DATA_MANAGEMENT', 'Annuler une soumission de données d''un autre organisme pas encore publiée.'),
  ('CONFIGURE_METAMODEL', 'Configurer le méta-modèle', 'MODEL_CONFIGURATION', 'Configurer les modèles de données, les modèles d''import, et le dictionnaire de données.'),
  ('VIEW_SENSITIVE', 'Consulter toutes les données sensibles', 'DATA_MANAGEMENT', 'Outrepasser les restrictions d''accès aux informations de localisation précises lorsque les données sont sensibles, pour toutes les données.'),
  ('VIEW_PRIVATE', 'Consulter toutes les données privées', 'DATA_MANAGEMENT', 'Outrepasser les restrictions d''accès aux informations de localisation précises lorsque les données sont privées, pour toutes les données.'),
  ('MANAGE_DATASETS_OTHER_PROVIDER', 'Gérer tous les jeux de données', 'JDD_MANAGEMENT', 'Voir et supprimer n''importe quel jeu de données. Modifier l''organisme de rattachement d''un jeu de données, ou créer un jeu de données pour un autre organisme. Importer des données dans n''importe quel jeu de données, supprimer n''importe quel import. Attention cette permission n''est à confier qu''aux administrateurs.'),
  ('CONFIRM_SUBMISSION', 'Publier n''importe quelle soumission', 'DATA_MANAGEMENT', 'Publier et dépublier toutes les données. Attention cette permission n''est à confier qu''aux administrateurs.'),
  ('GENERATE_DEE_OWN_JDD', 'Gérer les DEE de ses propres jeux de données', 'JDD_MANAGEMENT', 'Générer et transmettre à l''INPN les DEE de ses propres jeux de données. Les regénérer et les supprimer (avec notification à l''INPN), les télécharger.'),
  ('GENERATE_DEE_ALL_JDD', 'Gérer les DEE de tous les jeux de données', 'JDD_MANAGEMENT', 'Générer et transmettre à l''INPN les DEE de tous les jeux de données. Les regénérer et les supprimer (avec notification à l''INPN), les télécharger.'),
  ('MANAGE_PUBLIC_REQUEST', 'Gérer les requêtes publiques', 'REGISTERED_QUERIES', 'Créer, éditer, supprimer des requêtes enregistrées publiques.'),
  ('MANAGE_OWNED_PRIVATE_REQUEST', 'Gérer ses requêtes privées', 'REGISTERED_QUERIES', 'Créer, éditer, supprimer des requêtes enregistrées privées.'),
  ('CONFIGURE_WEBSITE_PARAMETERS', 'Configurer les paramètres de la plateforme', 'PLATFORM_ADMINISTRATION', 'Configurer les paramètres de la plateforme ainsi que la page d''accueil et la page de présentation.'),
  ('VALIDATE_OWN_JDD', 'Publier ses jeux de données', 'JDD_MANAGEMENT', 'Permet de publier ses propres jeux de données.'),
  ('VALIDATE_PROVIDER_JDD', 'Publier les jeux de données du même organisme', 'JDD_MANAGEMENT', 'Permet de publier les jeux de données d''utilisateurs appartenant au même organisme que soi.'),
  ('VALIDATE_ALL_JDD', 'Publier tous les jeux de données', 'JDD_MANAGEMENT', 'Permet de publier n''importe quel jeu de données.')
;

-- Add the permissions for role Développeur
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_OWN_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_USERS_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'GENERATE_DEE_OWN_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'GENERATE_DEE_ALL_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'MANAGE_OWNED_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'CONFIGURE_WEBSITE_PARAMETERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VALIDATE_OWN_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VALIDATE_PROVIDER_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (1, 'VALIDATE_ALL_JDD');


-- Add the permissions for role Administrateur
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_USERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_USERS_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_INTEGRATION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_QUERY_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_VALIDATED_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CANCEL_OTHER_PROVIDER_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_METAMODEL');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_SENSITIVE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VIEW_PRIVATE');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'GENERATE_DEE_OWN_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_DATASETS_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'GENERATE_DEE_ALL_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'DATA_EDITION_OTHER_PROVIDER');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIRM_SUBMISSION');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_PUBLIC_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'MANAGE_OWNED_PRIVATE_REQUEST');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'CONFIGURE_WEBSITE_PARAMETERS');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VALIDATE_OWN_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VALIDATE_PROVIDER_JDD');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (2, 'VALIDATE_ALL_JDD');

-- Add the permissions for role Producteur
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'DATA_QUERY');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'EXPORT_RAW_DATA');
INSERT INTO permission_per_role(role_code, permission_code) VALUES (3, 'MANAGE_OWNED_PRIVATE_REQUEST');

-- Add the permissions for role Grand public
INSERT INTO permission_per_role(role_code, permission_code) VALUES (4, 'DATA_QUERY');
