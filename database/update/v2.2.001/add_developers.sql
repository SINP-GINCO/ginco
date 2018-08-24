
-- We add users on default provider because we don't want to create other providers on the platform
INSERT INTO website.users(user_login, provider_id, email) VALUES
('xthauvin',0,'xavier.thauvin@ign.fr'),
  ('SimonF',0,'simon.fauret@ign.fr')
;

INSERT INTO website.role_to_user(user_login, role_code) VALUES
('xthauvin',1),
 ('SimonF',1)
;
