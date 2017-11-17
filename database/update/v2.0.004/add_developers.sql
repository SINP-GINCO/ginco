INSERT INTO website.users(user_login, provider_id, email) VALUES
('gautam.pastakia',82,'gautam.pastakia@ign.fr'),
('anna.mouget@ign.fr',82,'anna.mouget@ign.fr'),
('scandel',82,'severine.candelier@ign.fr'),
('vsagniez',82,'vincent.sagniez@ign.fr'),
('jpanijel',1,'jpanijel@mnhn.fr'),
('nbotte',1,'noemie.botte@mnhn.fr')
;

INSERT INTO website.role_to_user(user_login, role_code) VALUES
('gautam.pastakia', 1),
('anna.mouget@ign.fr', 1),
('scandel', 1),
('vsagniez', 1),
('jpanijel', 2),
('nbotte', 2)
;

DELETE FROM website.users WHERE user_login IN ('assistance','developpeur') ;