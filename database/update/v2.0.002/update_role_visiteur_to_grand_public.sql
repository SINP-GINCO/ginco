UPDATE role SET role_code = 'grand_public', role_label = 'Grand public', role_definition = 'Utilisateur par défaut non identifié et non-modifiable' WHERE role_code = 'visiteur';

UPDATE role_to_user SET role_code = 'grand_public' WHERE user_login = 'visiteur';

UPDATE role_to_schema SET role_code = 'grand_public' WHERE role_code = 'visiteur';

UPDATE permission_per_role SET role_code = 'grand_public' WHERE role_code = 'visiteur';