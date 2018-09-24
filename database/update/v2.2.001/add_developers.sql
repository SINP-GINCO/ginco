
-- We add users on default provider because we don't want to create other providers on the platform
DELETE FROM website.role_to_user WHERE user_login = 'xthauvin' OR user_login = 'SimonF' ;
DELETE FROM website.users WHERE user_login = 'xthauvin' OR user_login = 'SimonF' ;

INSERT INTO website.users(user_login, provider_id, email) VALUES
  ('xthauvin',0,'xavier.thauvin@ign.fr'),
  ('SimonF',0,'simon.fauret@ign.fr')
;

INSERT INTO website.role_to_user(user_login, role_code) VALUES
  ('xthauvin', (SELECT role_code FROM website.role WHERE role_label = 'Développeur')),
  ('SimonF', (SELECT role_code FROM website.role WHERE role_label = 'Développeur'))
;
