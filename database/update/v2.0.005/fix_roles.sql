INSERT INTO website.users(user_login, provider_id, email)
  SELECT 'hlambert',1,'helene.lambert@ign.fr'
  WHERE NOT EXISTS (SELECT user_login FROM website.users WHERE user_login = 'hlambert');

INSERT INTO website.role_to_user(user_login, role_code)
    SELECT 'hlambert', 1
      WHERE NOT EXISTS (SELECT user_login FROM website.role_to_user WHERE user_login = 'hlambert');

UPDATE website.role_to_user SET role_code=1 WHERE user_login IN ('jpanijel','nbotte');