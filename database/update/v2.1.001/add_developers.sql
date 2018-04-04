DELETE FROM website.role_to_user
 WHERE user_login IN ('cgimazane', 'rpas');

DELETE FROM website.users
 WHERE user_login IN ('cgimazane', 'rpas');

-- We add users on default provider because we don't want to create other providers on the platform
INSERT INTO website.users(user_login, provider_id, email) VALUES
('cgimazane',1,'clement.gimazane@ign.fr'),
('rpas',1,'remi.pas@ign.fr');

INSERT INTO website.role_to_user(user_login, role_code) VALUES
('cgimazane', 1),
('rpas', 1);

UPDATE website.role_to_user SET role_code = rc.role_code
FROM (SELECT role_code FROM website.role where role_label = 'Développeur') as rc
WHERE user_login IN ('cgimazane', 'rpas');