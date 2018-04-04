
-- We add users on default provider because we don't want to create other providers on the platform
INSERT INTO website.users(user_login, provider_id, email) VALUES
('cgimazane',1,'clement.gimazane@ign.fr'),
('rpas',1,'remi.pas@ign.fr')
;

INSERT INTO website.role_to_user(user_login, role_code) VALUES
('cgimazane', 1),
('rpas', 1)
;
