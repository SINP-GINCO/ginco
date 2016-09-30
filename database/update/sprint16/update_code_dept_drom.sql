-- Modification du type de la colonne code
ALTER TABLE referentiels.departements ALTER COLUMN code TYPE varchar(3);

-- Changement des codes de départements pour les DROM
UPDATE referentiels.departements SET code = '971' WHERE nom = 'GUADELOUPE';
UPDATE referentiels.departements SET code = '972' WHERE nom = 'MARTINIQUE';
UPDATE referentiels.departements SET code = '973' WHERE nom = 'GUYANE';
UPDATE referentiels.departements SET code = '974' WHERE nom = 'REUNION';
UPDATE referentiels.departements SET code = '976' WHERE nom = 'MAYOTTE';
