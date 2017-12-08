
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

INSERT INTO website.role_to_user(user_login, role_code) VALUES
('gautam.pastakia', 1),
('anna.mouget@ign.fr', 1),
('scandel', 1),
('vsagniez', 1),
('jpanijel', 2),
('nbotte', 2),
('tgerbeau', 1)
;
