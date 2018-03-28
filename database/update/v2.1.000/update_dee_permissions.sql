INSERT INTO website.permission (permission_code, permission_label)
VALUES
    ('GENERATE_DEE_OWN_JDD', 'Générer et transmettre à l''INPN les DEE de ses propres jeux de données' ),
    ('GENERATE_DEE_ALL_JDD', 'Générer et transmettre à l''INPN les DEE de tous les jeux de données' );

UPDATE website.permission_per_role
SET permission_code = 'GENERATE_DEE_OWN_JDD' WHERE permission_code = 'MANAGE_DATASETS';

INSERT INTO website.permission_per_role
    SELECT role_code, 'GENERATE_DEE_ALL_JDD'
    FROM website.permission_per_role
    WHERE permission_code = 'MANAGE_DATASETS_OTHER_PROVIDER';

DELETE FROM website.permission WHERE permission_code = 'MANAGE_DATASETS';