INSERT INTO permission(permission_code, permission_label, permission_group_code, description) VALUES 
  ('MANAGE_OWN_PROVIDER', 'Déclarer son propre organisme', 'USER_MANAGEMENT', 'Déclarer soi-même son propre organisme lors de sa première connexion à la plateforme.'),
  ('MANAGE_USERS_PROVIDER', 'Rattacher les utilisateurs à leur organisme', 'USER_MANAGEMENT', 'Rattacher les utilisateurs à leur organisme sur la page "Editer un utilisateur", à partir de l''annuaire de l''INPN.');

INSERT INTO website.permission_per_role
  SELECT role_code, 'MANAGE_USERS_PROVIDER'
  FROM website.role
  WHERE role_label = 'Développeur';
  
INSERT INTO website.permission_per_role
  SELECT role_code, 'MANAGE_USERS_PROVIDER'
  FROM website.role
  WHERE role_label = 'Administrateur';