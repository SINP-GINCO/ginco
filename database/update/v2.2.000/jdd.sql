INSERT INTO website.permission(permission_code, permission_label, permission_group_code, description) VALUES
    ('VALIDATE_OWN_JDD', 'Publier ses jeux de données', 'JDD_MANAGEMENT', 'Permet de publier ses propres jeux de données.'),
    ('VALIDATE_PROVIDER_JDD', 'Publier les jeux de données du même organisme', 'JDD_MANAGEMENT', 'Permet de publier les jeux de données d''utilisateurs appartenant au même organisme que soi.'),
    ('VALIDATE_ALL_JDD', 'Publier tous les jeux de données', 'JDD_MANAGEMENT', 'Permet de publier n''importe quel jeu de données.')
;

INSERT INTO website.permission_per_role (role_code, permission_code) VALUES
    (1, 'VALIDATE_OWN_JDD'),
    (1, 'VALIDATE_PROVIDER_JDD'),
    (1, 'VALIDATE_ALL_JDD'),
    (2, 'VALIDATE_OWN_JDD'),
    (2, 'VALIDATE_PROVIDER_JDD'),
    (2, 'VALIDATE_ALL_JDD')
;

ALTER TABLE raw_data.jdd ALTER COLUMN status TYPE text;

UPDATE website.permission SET
    permission_label = 'Publier n''importe quelle soumission',
    permission_group_code = 'DATA_MANAGEMENT',
    description = 'Publier et dépublier toutes les données. Attention cette permission n''est à confier qu''aux administrateurs.'
WHERE permission_code = 'CONFIRM_SUBMISSION' ;
