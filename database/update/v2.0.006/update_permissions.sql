-- Replace fournisseur by organisme and precise DATA_QUERY_OTHER_PROVIDER permission : it means non published datas
UPDATE website.permission SET permission_label='Visualiser les données non publiées d''un autre organisme' WHERE permission_code='DATA_QUERY_OTHER_PROVIDER';
UPDATE website.permission SET permission_label='Editer les données d''un autre organisme' WHERE permission_code='DATA_EDITION_OTHER_PROVIDER';
UPDATE website.permission SET permission_label='Annuler une soumission de données d''un autre organisme' WHERE permission_code='CANCEL_OTHER_PROVIDER_SUBMISSION';

-- On ote la permission de voir les données d'un autre organisme non publiées au rôle Grand Public (ie il ne voit aucune donnée non publiée).
DELETE FROM website.permission_per_role 
WHERE permission_code = 'DATA_QUERY_OTHER_PROVIDER' AND role_code in (
    SELECT role_code
    FROM role
    WHERE role.role_label= 'Grand public');