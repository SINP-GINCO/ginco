-------------------------------------------------------------
-- Validation (= publication) des jeux de données
-------------------------------------------------------------

INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES
    ('VALIDATE_JDD_OWN', 'Publier ses jeux de données', 'JDD_MANAGEMENT', 'Permet de publier ses propres jeux de données.'),
    ('VALIDATE_JDD_PROVIDER', 'Publier les jeux de données du même organisme', 'JDD_MANAGEMENT', 'Permet de publier les jeux de données d''utilisateurs appartenant au même organisme que soi.'),
    ('VALIDATE_JDD_ALL', 'Publier tous les jeux de données', 'JDD_MANAGEMENT', 'Permet de publier n''importe quel jeu de données.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'VALIDATE_JDD_OWN'),
    (1, 'VALIDATE_JDD_PROVIDER'),
    (1, 'VALIDATE_JDD_ALL'),
    (2, 'VALIDATE_JDD_OWN'),
    (2, 'VALIDATE_JDD_PROVIDER'),
    (2, 'VALIDATE_JDD_ALL')
;


-------------------------------------------------------------
-- Validation (= publication) des soumissions
-------------------------------------------------------------

INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES
    ('VALIDATE_SUBMISSION_OWN', 'Publier ses soumissions', 'DATA_MANAGEMENT', 'Publier ses soumissions dans un jeu de données.'),
    ('VALIDATE_SUBMISSION_PROVIDER', 'Publier les soumissions du même organisme', 'DATA_MANAGEMENT', 'Publier des soumissions dans un jeu de données appartenant à son propre organisme.'),
    ('VALIDATE_SUBMISSION_ALL', 'Publier toutes les soumissions', 'DATA_MANAGEMENT', 'Publier n''importe quelle soumission de n''importe quel jeu de données.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'VALIDATE_SUBMISSION_OWN'),
    (1, 'VALIDATE_SUBMISSION_PROVIDER'),
    (1, 'VALIDATE_SUBMISSION_ALL'),
    (2, 'VALIDATE_SUBMISSION_OWN'),
    (2, 'VALIDATE_SUBMISSION_PROVIDER'),
    (2, 'VALIDATE_SUBMISSION_ALL')
;

DELETE FROM website.permission_per_role WHERE permission_code = 'CONFIRM_SUBMISSION' ;
DELETE FROM website.permission WHERE permission_code = 'CONFIRM_SUBMISSION' ;


-------------------------------------------------------------
-- Génération des DEE
-------------------------------------------------------------

UPDATE website.permission SET
    permission_code = 'GENERATE_DEE_OWN'
    WHERE permission_code = 'GENERATE_DEE_OWN_JDD'
;
UPDATE website.permission_per_role SET permission_code = 'GENERATE_DEE_OWN' WHERE permission_code = 'GENERATE_DEE_OWN_JDD' ;

UPDATE website.permission SET
    permission_code = 'GENERATE_DEE_ALL'
    WHERE permission_code = 'GENERATE_DEE_ALL_JDD'
;
UPDATE website.permission_per_role SET permission_code = 'GENERATE_DEE_ALL' WHERE permission_code = 'GENERATE_DEE_ALL_JDD' ;

INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES 
    ('GENERATE_DEE_PROVIDER', 'Gérer les DEE des jeux de données de son organisme', 'JDD_MANAGEMENT', 'Permet de génerer et gérer les DEE des jeux de données qui appartiennent à son propre organisme.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'GENERATE_DEE_PROVIDER'),
    (2, 'GENERATE_DEE_PROVIDER')
;


-------------------------------------------------------------
-- Editer et supprimer les données
-------------------------------------------------------------

UPDATE website.permission SET
    permission_code = 'EDIT_DATA_OWN',
    permission_label = 'Editer et supprimer ses propres données',
    description = 'Modifier ou supprimer ses propres données.'
    WHERE permission_code = 'DATA_EDITION'
;

UPDATE website.permission_per_role SET permission_code = 'EDIT_DATA_OWN' WHERE permission_code = 'DATA_EDITION' ;

UPDATE website.permission SET
    permission_code = 'EDIT_DATA_PROVIDER',
    permission_label = 'Editer et supprimer les données de son organisme',
    description = 'Modifier ou supprimer les données déposées par un membre de son organisme.'
    WHERE permission_code = 'DATA_EDITION_OTHER_PROVIDER'
;

UPDATE website.permission_per_role SET permission_code = 'EDIT_DATA_PROVIDER' WHERE permission_code = 'DATA_EDITION_OTHER_PROVIDER' ;

INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES
    ('EDIT_DATA_ALL', 'Editer et supprimer toutes les données', 'DATA_MANAGEMENT', 'Modifier ou supprimer toutes les données de la plateforme.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'EDIT_DATA_ALL'),
    (2, 'EDIT_DATA_ALL')
;

-- Ajout d'une colonne user_login dans la table des résultats.
DELETE FROM mapping.results ;
ALTER TABLE mapping.results ADD COLUMN user_login CHARACTER VARYING NOT NULL ;
ALTER TABLE mapping.results DROP CONSTRAINT results_pk ;
ALTER TABLE mapping.results ADD CONSTRAINT results_pk PRIMARY KEY (id_request, id_observation, id_provider, user_login) ;


-------------------------------------------------------------
-- Gestion des JDDs
-------------------------------------------------------------

INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES
    ('MANAGE_JDD_SUBMISSION_OWN', 'Créer et gérer ses propres jeux de données et ses soumissions', 'JDD_MANAGEMENT', 'Créer des jeux de données à partir d''une fiche de métadonnées, voir et supprimer ses propres jeux de données. Importer des données dans ses propres jeux de données, supprimer ses propres soumissions.'),
    ('MANAGE_JDD_SUBMISSION_PROVIDER', 'Voir les jeux de données et les soumissions de son organisme', 'JDD_MANAGEMENT', 'Voir les jeux de données et les imports rattachés à son propre organisme et créés par d''autres utilisateurs.'),
    ('MANAGE_JDD_SUBMISSION_ALL', 'Gérer tous les jeux de données et toutes les soumissions', 'JDD_MANAGEMENT', 'Voir et supprimer n''importe quel jeu de données. Modifier l''organisme de rattachement d''un jeu de données, ou créer un jeu de données pour un autre organisme. Importer des données dans n''importe quel jeu de données, supprimer n''importe quelle soumission'),
    ('DELETE_JDD_SUBMISSION_PROVIDER', 'Supprimer les jeux de données et les soumissions de son organisme', 'JDD_MANAGEMENT', 'Supprimer les jeux de données de son organisme.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'MANAGE_JDD_SUBMISSION_OWN'),
    (2, 'MANAGE_JDD_SUBMISSION_OWN'),
    (1, 'MANAGE_JDD_SUBMISSION_PROVIDER'),
    (2, 'MANAGE_JDD_SUBMISSION_PROVIDER'),
    (1, 'MANAGE_JDD_SUBMISSION_ALL'),
    (2, 'MANAGE_JDD_SUBMISSION_ALL'),
    (1, 'DELETE_JDD_SUBMISSION_PROVIDER'),
    (2, 'DELETE_JDD_SUBMISSION_PROVIDER')
;

-- Remove old permissions
DELETE FROM website.permission_per_role WHERE permission_code = 'MANAGE_DATASETS_OTHER_PROVIDER';
DELETE FROM website.permission WHERE permission_code = 'MANAGE_DATASETS_OTHER_PROVIDER';
DELETE FROM website.permission_per_role WHERE permission_code = 'DATA_INTEGRATION';
DELETE FROM website.permission WHERE permission_code = 'DATA_INTEGRATION';

DELETE FROM website.permission_per_role WHERE permission_code = 'CANCEL_SUBMISSION_ALL';
DELETE FROM website.permission_per_role WHERE permission_code = 'CANCEL_SUBMISSION_OWN';
DELETE FROM website.permission WHERE permission_code = 'CANCEL_SUBMISSION_ALL';
DELETE FROM website.permission WHERE permission_code = 'CANCEL_SUBMISSION_OWN';

DELETE FROM website.permission_per_role WHERE permission_code = 'CANCEL_VALIDATED_SUBMISSION';
DELETE FROM website.permission WHERE permission_code = 'CANCEL_VALIDATED_SUBMISSION';
DELETE FROM website.permission_per_role WHERE permission_code = 'CANCEL_OTHER_PROVIDER_SUBMISSION';
DELETE FROM website.permission WHERE permission_code = 'CANCEL_OTHER_PROVIDER_SUBMISSION';


