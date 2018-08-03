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