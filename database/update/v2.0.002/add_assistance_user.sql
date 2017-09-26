-- Add the user 'assistance' if it doesn't exists, else do nothing (don't update it)

INSERT INTO website.users(user_login, user_password, user_name, provider_id, email)
  SELECT 'assistance','fd8de1f390d65e7d9dc80f281b988911ddebcec6', 'Compte assistance utilisateurs', 1, 'sinp-dev@ign.fr'
  WHERE NOT EXISTS (SELECT 1 FROM users WHERE user_login = 'assistance');

INSERT INTO website.role_to_user(user_login, role_code)
  SELECT 'assistance', 1
  WHERE NOT EXISTS (SELECT 1 FROM role_to_user WHERE user_login = 'assistance');