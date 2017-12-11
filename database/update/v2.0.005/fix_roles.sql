INSERT INTO website.users(user_login, provider_id, email) VALUES
  ('hlambert',1,'helene.lambert@ign.fr');
INSERT INTO website.role_to_user(user_login, role_code) VALUES
  ('hlambert', 1);

UPDATE website.role_to_user SET role_code=1 WHERE user_login IN ('jpanijel','nbotte');