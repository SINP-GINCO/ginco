-- Create table permission_group
CREATE TABLE IF NOT EXISTS website.permission_group(
	code TEXT NOT NULL,
	label TEXT,
	CONSTRAINT pk_permission_group PRIMARY KEY (code)
);

ALTER TABLE website.permission_group OWNER TO admin;
GRANT ALL ON TABLE website.permission_group TO admin;
GRANT ALL ON TABLE website.permission_group TO ogam;


COMMENT ON TABLE website.permission_group IS 'List of permission groups';
COMMENT ON COLUMN PERMISSION_GROUP.CODE IS 'Code of the group';
COMMENT ON COLUMN PERMISSION_GROUP.LABEL IS 'Group description';

-- Add foreign key to permission
ALTER TABLE website.permission ADD COLUMN permission_group_code TEXT REFERENCES website.permission_group(code) ;

-- Add description column
ALTER TABLE website.permission ADD COLUMN description TEXT ;

-- Populate permission_group
DELETE FROM website.permission_group ;
INSERT INTO website.permission_group VALUES
	('USER_MANAGEMENT', 'Administration des utilisateurs'),
	('PLATFORM_ADMINISTRATION', 'Administration de la plateforme'),
	('MODEL_CONFIGURATION', 'Configuration des modèles'),
	('JDD_MANAGEMENT', 'Gestion et consultation des jeux de données'),
	('DATA_MANAGEMENT', 'Gestion et consultation des données'),
	('REGISTERED_QUERIES', 'Requêtes enregistrées')
;

-- UPDATE permission TABLE
UPDATE website.permission SET permission_group_code = NULL ;

UPDATE website.permission SET permission_group_code = 'PLATFORM_ADMINISTRATION'
	WHERE permission_code IN ('CONFIGURE_WEBSITE_PARAMETERS') ;

UPDATE website.permission SET permission_group_code = 'USER_MANAGEMENT' 
	WHERE permission_code IN ('MANAGE_USERS') ;
	
UPDATE website.permission SET permission_group_code = 'MODEL_CONFIGURATION'
	WHERE permission_code IN ('CONFIGURE_METAMODEL') ;
	
UPDATE website.permission SET permission_group_code = 'JDD_MANAGEMENT'
	WHERE permission_code IN ('MANAGE_DATASETS_OTHER_PROVIDER', 'CONFIRM_SUBMISSION', 'GENERATE_DEE_OWN_JDD', 'GENERATE_DEE_ALL_JDD') ;
	
UPDATE website.permission SET permission_group_code = 'DATA_MANAGEMENT'
	WHERE permission_code IN ('DATA_INTEGRATION', 'DATA_QUERY', 'DATA_QUERY_OTHER_PROVIDER',
		'EXPORT_RAW_DATA', 'DATA_EDITION', 'DATA_EDITION_OTHER_PROVIDER',
		'CANCEL_VALIDATED_SUBMISSION', 'CANCEL_OTHER_PROVIDER_SUBMISSION',
		'VIEW_SENSITIVE', 'VIEW_PRIVATE'
	) ;
	
UPDATE website.permission SET permission_group_code = 'REGISTERED_QUERIES'
	WHERE permission_code IN ('MANAGE_PUBLIC_REQUEST', 'MANAGE_OWNED_PRIVATE_REQUEST') ;
	
-- UPDATE permission labels and description
UPDATE website.permission SET 
	permission_label = 'Administrer les utilisateurs, rôles, et permissions',
	description = 'Ajouter et supprimer les utilisateurs dans la plateforme. Définir les rôles et y associer des permissions. Attribuer les rôles et permissions aux utilisateurs.'
	WHERE permission_code = 'MANAGE_USERS';

UPDATE website.permission SET 
	permission_label = 'Exporter les données',
	description = 'Exporter (au format CSV, GeoJson, kml…) les données sur lesquelles on a les droits de consultation. Les limitations d''accès aux informations de localisation sont les mêmes que pour la consultation.'
	WHERE permission_code = 'EXPORT_RAW_DATA';

UPDATE website.permission SET 
	permission_label = 'Gérer les DEE de ses propres jeux de données',
	description = 'Générer et transmettre à l''INPN les DEE de ses propres jeux de données. Les regénérer et les supprimer (avec notification à l''INPN), les télécharger.'
	WHERE permission_code = 'GENERATE_DEE_OWN_JDD';

UPDATE website.permission SET 
	permission_label = 'Gérer les DEE de tous les jeux de données', 
	description = 'Générer et transmettre à l''INPN les DEE de tous les jeux de données. Les regénérer et les supprimer (avec notification à l''INPN), les télécharger.'
	WHERE permission_code = 'GENERATE_DEE_ALL_JDD';

UPDATE website.permission SET 
	permission_label = 'Gérer tous les jeux de données',
	description = 'Voir et supprimer n''importe quel jeu de données. Modifier l''organisme de rattachement d''un jeu de données, ou créer un jeu de données pour un autre organisme. Importer des données dans n''importe quel jeu de données, supprimer n''importe quel import. Attention cette permission n''est à confier qu''aux administrateurs.'
	WHERE permission_code = 'MANAGE_DATASETS_OTHER_PROVIDER';

UPDATE website.permission SET 
	permission_label = 'Créer et gérer ses propres jeux de données',
	description = 'Créer des jeux de données à partir d''une fiche de métadonnées, voir et supprimer ses propres jeux de données. Importer des données dans ses propres jeux de données, supprimer ses propres imports.' 
	WHERE permission_code = 'DATA_INTEGRATION';

UPDATE website.permission SET 
	permission_label = 'Publier n''importe quel jeu de données',
	description = 'Publier et dépublier tous les jeux de données.  Attention cette permission n''est à confier qu''aux administrateurs.' 
	WHERE permission_code = 'CONFIRM_SUBMISSION';

UPDATE website.permission SET 
	permission_label = 'Consulter toutes les données non publiées',
	description = 'Requêter et visualiser toutes les données non publiées.'
	WHERE permission_code = 'DATA_QUERY_OTHER_PROVIDER';

UPDATE website.permission SET 
	permission_label = 'Consulter toutes les données sensibles',
	description = 'Outrepasser les restrictions d''accès aux informations de localisation précises lorsque les données sont sensibles, pour toutes les données.'
	WHERE permission_code = 'VIEW_SENSITIVE';

UPDATE website.permission SET 
	permission_label = 'Consulter toutes les données privées',
	description = 'Outrepasser les restrictions d''accès aux informations de localisation précises lorsque les données sont privées, pour toutes les données.'
	WHERE permission_code = 'VIEW_PRIVATE';

UPDATE website.permission SET 
	permission_label = 'Consulter les données publiées',
	description = 'Requêter et visualiser les données publiées. L''accès aux informations de localisation plus ou moins précises dépend des éventuelles restrictions d''accès des données (sensibles, privées) et des autres permissions.' 
	WHERE permission_code = 'DATA_QUERY';

UPDATE website.permission SET
	description = 'Configurer les paramètres de la plateforme ainsi que la page d''accueil et la page de présentation.'
	WHERE permission_code = 'CONFIGURE_WEBSITE_PARAMETERS';

UPDATE website.permission SET
	description = 'Configurer les modèles de données, les modèles d''import, et le dictionnaire de données.'
	WHERE permission_code = 'CONFIGURE_METAMODEL';

UPDATE website.permission SET
	description = 'Editer les données.'
	WHERE permission_code = 'DATA_EDITION';

UPDATE website.permission SET
	description = 'Editer les données d''un autre organisme.'
	WHERE permission_code = 'DATA_EDITION_OTHER_PROVIDER';

UPDATE website.permission SET
	description = 'Annuler une de ses soumissions de données pas encore publiée.'
	WHERE permission_code = 'CANCEL_VALIDATED_SUBMISSION';

UPDATE website.permission SET 
	description = 'Annuler une soumission de données d''un autre organisme pas encore publiée.'
	WHERE permission_code = 'CANCEL_OTHER_PROVIDER_SUBMISSION';

UPDATE website.permission SET
	description = 'Créer, éditer, supprimer des requêtes enregistrées publiques.'
	WHERE permission_code = 'MANAGE_PUBLIC_REQUEST';

UPDATE website.permission SET
	description = 'Créer, éditer, supprimer des requêtes enregistrées privées.'
	WHERE permission_code = 'MANAGE_OWNED_PRIVATE_REQUEST';
