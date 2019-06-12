SET search_path TO metadata ;

BEGIN ;

----------------------------------------------------------------
-- 1. Standard
----------------------------------------------------------------

INSERT INTO standard VALUES ('habitat', 'Standard d''occurences d''habitats', 'v1.0') ;

----------------------------------------------------------------
-- 2. Model
----------------------------------------------------------------

INSERT INTO model VALUES ('model_1000','Occ_Habitat_DSR_1.0', 'Implémentation du standard "Occurences d''habitats" v1.0', 'RAW_DATA', TRUE, 'unpublished', null, 'habitat');


----------------------------------------------------------------
-- 3. Dataset
----------------------------------------------------------------

INSERT INTO dataset VALUES 
    ('dataset_1000', 'Occ_Habitat_DSR_import', 1, 'Modèle d''import par défaut pour le modèle Occ. Habitat.', 'IMPORT', 'unpublished')  
;


----------------------------------------------------------------
-- 4. Unit
----------------------------------------------------------------

INSERT INTO unit VALUES
    ('ComplexeHabitatValue', 'CODE', 'DYNAMIC', 'Type de complexe d''habitats', 'Type de complexe d''habitats'),
    ('ExpositionValue', 'CODE', 'DYNAMIC', 'Point cardinal dominant pour l''exposition du terrain', 'Point cardinal dominant pour l''exposition du terrain'),
    ('MethodeCalculSurfaceValue', 'CODE', 'DYNAMIC', 'Type de détermination d''une surface', 'Type de détermination d''une surface'),
    ('TypeSolValue', 'ARRAY', 'DYNAMIC', 'Type de sol observé', 'Type de sol observé'),
    ('GeologieValue', 'ARRAY', 'DYNAMIC', 'Type de géologie de la zone', 'Type de géologie de la zone'),
    ('AciditeValue', 'CODE', 'DYNAMIC', 'Acidité du sol', 'Acidité du sol'),
    ('TypeDeterminationValue', 'CODE', 'DYNAMIC', 'Type de détermination', 'Type de détermination'),
    ('TechniqueCollecteValue', 'STRING', 'DYNAMIC', 'Techniques de collecte de l''observation', 'Techniques de collecte de l''observation'),
    ('AbondanceHabitatValue', 'CODE', 'DYNAMIC', 'Coefficients de Braun-Blanquet et Pavillard', 'Coefficients de Braun-Blanquet et Pavillard'),
    ('NiveauSensiValue', 'CODE', 'DYNAMIC', 'Niveau de sensiblité des habitats', 'Niveau de sensiblité des habitats')
;

----------------------------------------------------------------
-- 5. Dynamode
----------------------------------------------------------------

INSERT INTO dynamode VALUES 
    ('ComplexeHabitatValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.complexehabitatvalue ORDER BY code'),
    ('ExpositionValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.expositionvalue ORDER BY code'),
    ('MethodeCalculSurfaceValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.methodecalculsurfacevalue ORDER BY code'),
    ('TypeSolValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.typesolvalue ORDER BY code'),
    ('GeologieValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.geologievalue ORDER BY code'),
    ('AciditeValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.aciditevalue ORDER BY code'),
    ('TypeDeterminationValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.typedeterminationvalue ORDER BY code'),
    ('TechniqueCollecteValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.techniquecollectevalue ORDER BY code'),
    ('AbondanceHabitatValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.abondancehabitatvalue ORDER BY code'),
    ('NiveauSensiValue', 'SELECT code, label || '' ('' || code || '')'' as label, definition, ''''::text as position FROM referentiels.niveausensivalue ORDER BY code')
;

----------------------------------------------------------------
-- 6. Nomenclatures
----------------------------------------------------------------

-- ComplexeHabitatValue
-----------------------

CREATE TABLE referentiels.complexehabitatvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT complexehabitatvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.complexehabitatvalue OWNER TO postgres ;

INSERT INTO referentiels.complexehabitatvalue (code, label, definition) VALUES
    ('1', 'Mosaïque spatiale', 'Mosaïque spatiale'),
    ('2', 'Mosaïque temporelle', 'Mosaïque temporelle'),
    ('3', 'Complexe d''habitats', 'Complexe d''habitats')
;


-- ExpositionValue
------------------

CREATE TABLE referentiels.expositionvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT expositionvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.expositionvalue OWNER TO postgres ;

INSERT INTO referentiels.expositionvalue (code, label, definition) VALUES 
    ('E', 'Est : 78,75° - 101,25°', 'Est : 78,75° - 101,25°'),
    ('ENE', 'Est-Nord-Est : 56.25° - 78.75°', 'Est-Nord-Est : 56.25° - 78.75°'),
    ('ESE', 'Est-Sud-Est : 101.25° - 123.75°', 'Est-Sud-Est : 101.25° - 123.75°'),
    ('N', 'Nord : 348.75° - 11.25°', 'Nord : 348.75° - 11.25°'),
    ('NE', 'Nord-Est : 33.75° - 56.25°', 'Nord-Est : 33.75° - 56.25°'),
    ('NNE', 'Nord-Nord-Est : 11.25° - 33.75°', 'Nord-Nord-Est : 11.25° - 33.75°'),
    ('NNO', 'Nord-Nord-Ouest : 326.25° - 348.75°', 'Nord-Nord-Ouest : 326.25° - 348.75°'),
    ('NO', 'Nord-Ouest : 303.75° - 326.25 °', 'Nord-Ouest : 303.75° - 326.25 °'),
    ('O', 'Ouest : 258.75° - 281.25°', 'Ouest : 258.75° - 281.25°'),
    ('ONO', 'Ouest-Nord-Ouest : 281.25° - 303.75°', 'Ouest-Nord-Ouest : 281.25° - 303.75°'),
    ('OSO', 'Ouest-Sud-Ouest : 236.25° - 258.75°', 'Ouest-Sud-Ouest : 236.25° - 258.75°'),
    ('S', 'Sud : 168.75° - 191.25°', 'Sud : 168.75° - 191.25°'),
    ('SE', 'Sud-Est : 123.75°- 146.25°', 'Sud-Est : 123.75°- 146.25°'),
    ('SO', 'Sud-Ouest : 213.75° - 236.25°', 'Sud-Ouest : 213.75° - 236.25°'),
    ('SSE', 'Sud-Sud-Est : 146.25° - 168.75°', 'Sud-Sud-Est : 146.25° - 168.75°'),
    ('SSO', 'Sud-Sud-Ouest : 191.25° - 213.75°', 'Sud-Sud-Ouest : 191.25° - 213.75°')
;


-- MethodeCalculSurfaceValue
----------------------------

CREATE TABLE referentiels.methodecalculsurfacevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT methodecalculsurfacevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.methodecalculsurfacevalue OWNER TO postgres ;

INSERT INTO referentiels.methodecalculsurfacevalue (code, label, definition) VALUES
    ('es', 'Estimée : la surface est estimée par l''opérateur.', 'Estimée : la surface est estimée par l''opérateur.'),
    ('lin', 'Calculée à partir de la largeur du linéaire', 'Calculée à partir de la largeur du linéaire'), 
    ('sig', 'La surface est calculée directement par usage d''un logiciel SIG.', 'La surface est calculée directement par usage d''un logiciel SIG.'),
    ('nsp', 'Ne sait pas : la méthode de calcul est inconnue.', 'Ne sait pas : la méthode de calcul est inconnue.')
;

-- TypeSolValue
---------------

CREATE TABLE referentiels.typesolvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT typesolvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.typesolvalue OWNER TO postgres ;

INSERT INTO referentiels.typesolvalue (code, label, definition) VALUES 
    ('1', 'Anthroposol', 'Anthroposol'),
    ('2', 'Lithosol', 'Lithosol'),
    ('3', 'Régosol', 'Régosol'),
    ('4', 'Cryosol', 'Cryosol'),
    ('5', 'Rédoxisol', 'Rédoxisol'),
    ('6', 'Réductisol', 'Réductisol'),
    ('7', 'Histosol', 'Histosol'),
    ('8', 'Colluviosol', 'Colluviosol'),
    ('9', 'Peyrosol', 'Peyrosol'),
    ('10', 'Arénosol', 'Arénosol'),
    ('11', 'Vertisol', 'Vertisol'),
    ('12', 'Leptimectisol', 'Leptimectisol'),
    ('13', 'Pélosol', 'Pélosol'),
    ('14', 'Nitosol', 'Nitosol'),
    ('15', 'Andosol', 'Andosol'),
    ('16', 'Gyposol', 'Gyposol'),
    ('17', 'Salisol', 'Salisol'),
    ('18', 'Sodisol', 'Sodisol'),
    ('19', 'Organosol', 'Organosol'),
    ('20', 'Rankosol', 'Rankosol'),
    ('21', 'Veracrisol', 'Veracrisol'),
    ('22', 'Chernosol', 'Chernosol'),
    ('23', 'Phaerosol', 'Phaerosol'),
    ('24', 'Podzosol', 'Podzosol'),
    ('25', 'Fersialsol', 'Fersialsol'),
    ('26', 'Brunisol', 'Brunisol'),
    ('27', 'Alocrisol', 'Alocrisol'),
    ('28', 'Luvisol', 'Luvisol'),
    ('29', 'Planosol', 'Planosol'),
    ('30', 'Pélosol', 'Pélosol'),
    ('31', 'Basisol', 'Basisol')
;


-- GeologieValue
----------------

CREATE TABLE referentiels.geologievalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT geologievalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.geologievalue OWNER TO postgres ;

INSERT INTO referentiels.geologievalue (code, label, definition) VALUES
    ('1','Alluvions','Alluvions'),
    ('10','Andésite','Andésite'),
    ('100','Roche magmatique','Roche magmatique'),
    ('101','Roche métamorphique','Roche métamorphique'),
    ('102','Roche plutonique','Roche plutonique'),
    ('103','Roche sédimentaire','Roche sédimentaire'),
    ('104','Roche ultrabasique','Roche ultrabasique'),
    ('105','Roche volcanique','Roche volcanique'),
    ('106','Sables','Sables'),
    ('107','Sables argileux','Sables argileux'),
    ('108','Sables fins','Sables fins'),
    ('109','Sables grossiers','Sables grossiers'),
    ('11','Anhydrite','Anhydrite'),
    ('110','Sables moyens','Sables moyens'),
    ('111','Sancyte','Sancyte'),
    ('112','Schistes','Schistes'),
    ('113','Schistes bitumeux','Schistes bitumeux'),
    ('114','Schistes bleus','Schistes bleus'),
    ('115','Schistes cristallins','Schistes cristallins'),
    ('116','Schistes verts','Schistes verts'),
    ('117','Serpentinite','Serpentinite'),
    ('118','Silt','Silt'),
    ('119','Syénite','Syénite'),
    ('12','Ardoise','Ardoise'),
    ('120','Syénite néphélinique','Syénite néphélinique'),
    ('121','Sylvinite (Potasse)','Sylvinite (Potasse)'),
    ('122','Tahitite','Tahitite'),
    ('123','Tonalite','Tonalite'),
    ('124','Tourbe','Tourbe'),
    ('125','Trachy-andésite','Trachy-andésite'),
    ('126','Trachy-basalte','Trachy-basalte'),
    ('127','Trachyte','Trachyte'),
    ('128','Tufs et travertin','Tufs et travertin'),
    ('129','Turbidite','Turbidite'),
    ('13','Arènes (granitiques ou gneissiques)','Arènes (granitiques ou gneissiques)'),
    ('130','Vases consolidées','Vases consolidées'),
    ('131','Vaugnerite','Vaugnerite'),
    ('132','Vogesite','Vogesite'),
    ('133','Vosgesite','Vosgesite'),
    ('134','Werhlite','Werhlite'),
    ('14','Argiles','Argiles'),
    ('15','Argiles sableuses','Argiles sableuses'),
    ('16','Ariegite','Ariegite'),
    ('17','Arkoses','Arkoses'),
    ('18','Avezacite','Avezacite'),
    ('19','Basalte','Basalte'),
    ('2','Alluvions caillouteuses (galets, graviers, sables)','Alluvions caillouteuses (galets, graviers, sables)'),
    ('20','Blavierite','Blavierite'),
    ('21','Blocs','Blocs'),
    ('22','Calcaires','Calcaires'),
    ('23','Calcaires dolomitiques','Calcaires dolomitiques'),
    ('24','Calcaires marneux','Calcaires marneux'),
    ('25','Calcschistes','Calcschistes'),
    ('26','Cantalite','Cantalite'),
    ('27','Conglomérat (brèches ou poudingues)','Conglomérat (brèches ou poudingues)'),
    ('28','Conglomérats compacts','Conglomérats compacts'),
    ('29','Cornéenne','Cornéenne'),
    ('3','Alluvions graveleuses (graviers, sables)','Alluvions graveleuses (graviers, sables)'),
    ('30','Corsite','Corsite'),
    ('31','Craie','Craie'),
    ('32','Craie marneuse','Craie marneuse'),
    ('33','Dacite','Dacite'),
    ('34','Diorite','Diorite'),
    ('35','Dolomies','Dolomies'),
    ('36','Domite','Domite'),
    ('37','Doreite','Doreite'),
    ('38','Dunite','Dunite'),
    ('39','Eclogite','Eclogite'),
    ('4','Altérites','Altérites'),
    ('40','Esterellite','Esterellite'),
    ('41','Evisite','Evisite'),
    ('42','Falun (sable coquillier)','Falun (sable coquillier)'),
    ('43','Florinite','Florinite'),
    ('44','Flysh argileux','Flysh argileux'),
    ('45','Flysh calcaire','Flysh calcaire'),
    ('46','Fraidonite','Fraidonite'),
    ('47','Gabbro','Gabbro'),
    ('48','Gaize','Gaize'),
    ('49','Galets (et cailloux)','Galets (et cailloux)'),
    ('5','Alternance gréso-calcaire','Alternance gréso-calcaire'),
    ('50','Gelé','Gelé'),
    ('51','Gneiss','Gneiss'),
    ('52','Granite','Granite'),
    ('53','Granitoide','Granitoide'),
    ('54','Granodiorite','Granodiorite'),
    ('55','Granulite','Granulite'),
    ('56','Graviers','Graviers'),
    ('57','Grès','Grès'),
    ('58','Gypse','Gypse'),
    ('59','Halite (Sel Gemme)','Halite (Sel Gemme)'),
    ('6','Alternance gréso-schisteuse','Alternance gréso-schisteuse'),
    ('60','Harzburgite','Harzburgite'),
    ('61','Hauynite, hauynitite','Hauynite, hauynitite'),
    ('62','Houille','Houille'),
    ('63','Jaspes (phtanites)','Jaspes (phtanites)'),
    ('64','Kersantite','Kersantite'),
    ('65','Lapillis (ou pouzzolane)','Lapillis (ou pouzzolane)'),
    ('66','Latite','Latite'),
    ('67','Lherzite','Lherzite'),
    ('68','Lherzolite','Lherzolite'),
    ('69','Lignite','Lignite'),
    ('7','Alternance marno-calcaire','Alternance marno-calcaire'),
    ('70','Limburgite','Limburgite'),
    ('71','Limon argileux','Limon argileux'),
    ('72','Limons','Limons'),
    ('73','Lindinosite','Lindinosite'),
    ('74','Lithologie inconnue','Lithologie inconnue'),
    ('75','Loess','Loess'),
    ('76','Luscladite','Luscladite'),
    ('77','Marbres et/ou cipolins','Marbres et/ou cipolins'),
    ('78','Mareugite','Mareugite'),
    ('79','Marnes','Marnes'),
    ('8','Alternance sablo-argileuse','Alternance sablo-argileuse'),
    ('80','Miagite','Miagite'),
    ('81','Micaschiste','Micaschiste'),
    ('82','Migmatites','Migmatites'),
    ('83','Molasse','Molasse'),
    ('84','Monzonite','Monzonite'),
    ('85','Moraines','Moraines'),
    ('86','Mylonite','Mylonite'),
    ('87','Napoleonite','Napoleonite'),
    ('88','Oceanite','Oceanite'),
    ('89','Ordanchite','Ordanchite'),
    ('9','Amphibolite','Amphibolite'),
    ('90','Ouenite','Ouenite'),
    ('91','Pegmatite','Pegmatite'),
    ('92','Peleite, peléeite','Peleite, peléeite'),
    ('93','Pélite','Pélite'),
    ('94','Péridotite','Péridotite'),
    ('95','Phonolite','Phonolite'),
    ('96','Pyromeride','Pyromeride'),
    ('97','Quartzites (métaquartzites)','Quartzites (métaquartzites)'),
    ('98','Quartzites (orthoquartzites)','Quartzites (orthoquartzites)'),
    ('99','Rhyolite','Rhyolite')
;


-- AciditeValue
---------------

CREATE TABLE referentiels.aciditevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT aciditevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.aciditevalue OWNER TO postgres ;

INSERT INTO referentiels.aciditevalue (code, label, definition) VALUES 
    ('1', 'Acide', 'Acide'),
    ('2', 'Neutre', 'Neutre'),
    ('3', 'Basique', 'Basique')
;


-- TypeDeterminationValue
-------------------------

CREATE TABLE referentiels.typedeterminationvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT typedeterminationvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.typedeterminationvalue OWNER TO postgres ;

INSERT INTO referentiels.typedeterminationvalue (code, label, definition) VALUES
    ('0', 'Inconnu', 'Inconnu'),
    ('1', 'Attribué terrain', 'Attribué terrain'),
    ('2', 'Expertise a posteriori', 'Expertise a posteriori'),
    ('3', 'Correspondance typologique', 'Correspondance typologique')
;


-- TechniqueCollecteValue
-------------------------

CREATE TABLE referentiels.techniquecollectevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT techniquecollectevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.techniquecollectevalue OWNER TO postgres ;

INSERT INTO referentiels.techniquecollectevalue (code, label, definition) VALUES
    ('0', 'Ne sait pas', 'Ne sait pas'),
    ('1', 'In situ : observation directe, sur le terrain', 'In situ : observation directe, sur le terrain'),
    ('2', 'Télédétection (satellite, LIDAR...)', 'Télédétection (satellite, LIDAR...)'),
    ('2.1', 'Lidar', 'Lidar'),
    ('2.2', 'Radar', 'Radar'),
    ('2.3', 'Imagerie numérique aéroportée', 'Imagerie numérique aéroportée'),
    ('2.4', 'Imagerie satellitaire', 'Imagerie satellitaire'),
    ('3', 'Techniques acoustiques', 'Techniques acoustiques'),
    ('3.1', 'Sonar à balayage latéral', 'Sonar à balayage latéral'),
    ('3.2', 'Sondeur multifaisceaux', 'Sondeur multifaisceaux'),
    ('3.3', 'Sonar à interféromètre', 'Sonar à interféromètre'),
    ('3.4', 'Système acoustique de classification automatique des natures de fonds', 'Système acoustique de classification automatique des natures de fonds'),
    ('3.5', 'Imagerie sismique', 'Imagerie sismique'),
    ('3.6', 'Sondeur de sédiments', 'Sondeur de sédiments'),
    ('3.7', 'Sondeur monofaisceau', 'Sondeur monofaisceau'),
    ('4', 'Modélisation', 'Modélisation'),
    ('5', 'Observation à distance (jumelles par exemple)', 'Observation à distance (jumelles par exemple)'),
    ('6', 'Observation directe marine (observation en plongée)', 'Observation directe marine (observation en plongée)'),
    ('7', 'Extrapolation', 'Extrapolation'),
    ('8', 'Techniques de prélèvements in situ', 'Techniques de prélèvements in situ'),
    ('8.1', 'Plongées', 'Plongées'),
    ('8.2', 'Mesures géotechniques', 'Mesures géotechniques'),
    ('8.3', 'Prélèvement à la benne', 'Prélèvement à la benne'),
    ('8.4', 'Prélèvement au chalut ou à la drague', 'Prélèvement au chalut ou à la drague'),
    ('8.4.1', 'Prélèvement au chalut', 'Prélèvement au chalut'),
    ('8.4.2', 'Prélèvement à la drague', 'Prélèvement à la drague'),
    ('8.5', 'Carottage', 'Carottage'),
    ('9', 'Vidéo et photographies', 'Vidéo et photographies'),
    ('9.1', 'Imagerie des profils sédimentaires', 'Imagerie des profils sédimentaires'),
    ('9.2', 'Caméra tractée ou téléguidée', 'Caméra tractée ou téléguidée'),
    ('9.3', 'Observation marine photographique (observation photographique en plongée)', 'Observation marine photographique (observation photographique en plongée)'),
    ('9.4', 'Observation photographique aérienne, prise de vue aérienne, suivie d''une photointerprétation', 'Observation photographique aérienne, prise de vue aérienne, suivie d''une photointerprétation'),
    ('9.5', 'Observation photographique terrestre suivie d''une photointerprétation.', 'Observation photographique terrestre suivie d''une photointerprétation.'),
    ('10', 'Autre, préciser.', 'Autre, préciser.')
;

-- AbondanceHabitatValue
------------------------

CREATE TABLE referentiels.abondancehabitatvalue (
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT abondancehabitatvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.abondancehabitatvalue OWNER TO postgres ;

INSERT INTO referentiels.abondancehabitatvalue (code, label, definition) VALUES
    ('1', 'Recouvrement très faible', 'Recouvrement très faible'),
    ('2', 'Habitat recouvrant environ 1/20 à 1/4 de la surface (5 à 25 %)', 'Habitat recouvrant environ 1/20 à 1/4 de la surface (5 à 25 %)'),
    ('3', 'Habitat recouvrant environ 1/4 à 1/2 de la surface (25 à 50 %)', 'Habitat recouvrant environ 1/4 à 1/2 de la surface (25 à 50 %)'),
    ('4', 'Habitat recouvrant environ 1/2 à 3/4 de la surface (50 à 75 %)', 'Habitat recouvrant environ 1/2 à 3/4 de la surface (50 à 75 %)'),
    ('5', 'Habitat recouvrant plus des 3/4 de la surface (>75 %)', 'Habitat recouvrant plus des 3/4 de la surface (>75 %)')
;



-- NiveauSensiValue
-------------------

CREATE TABLE referentiels.niveausensivalue (
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT niveausensivalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.niveausensivalue OWNER TO postgres ;

INSERT INTO referentiels.niveausensivalue (code, label, definition) VALUES
    ('0', 'Pas de sensibilité particulière', 'Pas de sensibilité particulière'),
    ('2', 'Sensible', 'Sensible')
;


REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO ogam;



----------------------------------------------------------------
-- 7. Data
----------------------------------------------------------------

INSERT INTO data(data, unit, label, definition) VALUES 
    ('OGAM_ID_table_station', 'IDString', 'Clé primaire table station', 'Clé primaire table station'),
    ('identifiantstasinp', 'CharacterString', 'identifiantStaSINP', 'Identifiant unique de la station observée.'),
    ('identifiantoriginestation', 'CharacterString', 'identifiantOrigineStation', 'Identifiant unique de la donnée de station dans la base de données du producteur où est stockée et initialement gérée la donnée d''origine.'),
    ('dateimprecise', 'BOOLEAN', 'dateImprecise', 'Permet d''indiquer qu''une date est imprécise et que jourDateDebut / jourDateFin recouvre une période d''imprécision.'),
    ('observateur', 'CharacterString', 'observateur', 'Identité et organisme de la ou des personnes ayant réalisé l''observation.'),
    ('nomstation', 'CharacterString', 'nomStation', 'Nom ou code éventuel de la station.'),
    ('estcomplexehabitats', 'ComplexeHabitatValue', 'estComplexeHabitats', 'Permet de préciser que la station est un complexe d''habitats.'),
    ('exposition', 'ExpositionValue', 'exposition', 'Exposition de la station.'),
    ('surface', 'Decimal', 'surface', 'Superficie de la station.'),
    ('methodecalculsurface', 'MethodeCalculSurfaceValue', 'methodeCalculSurface', 'Méthode de calcul pour la détermination de la surface.'),
    ('usage', 'CharacterString', 'usage', 'Usage/activité pratiquée sur l''habitat, si nécessaire, fondé sur la notion d''impact anthropique.'),
    ('typesol', 'TypeSolValue', 'typeSol', 'Type de sol de la zone considérée.'),
    ('geologie', 'GeologieValue', 'geologie', 'Géologie de la zone considérée.'),
    ('acidite', 'AciditeValue', 'acidite', 'Acidité du sol.'),
    ('OGAM_ID_table_habitat', 'IDString', 'Clé primaire table habitat', 'Clé primaire table station'),
    ('identifianthabsinp', 'CharacterString', 'identifiantHabSINP', 'Identifiant unique de l''habitat observé.'),
    ('cdhab', 'CodeHabRefValue', 'cdHab', 'Code l''habitat suivant HABREF.'),
    ('typedeterm', 'TypeDeterminationValue', 'typeDeterm', 'Type de détermination.'),
    ('determinateur', 'CharacterString', 'determinateur', 'Personne ayant procédé à la détermination du code de l''habitat contenu dans cdHab, ainsi que son éventuel organisme.'),
    ('techniquecollecte', 'TechniqueCollecteValue', 'techniqueCollecte', 'Technique de collecte ayant permis la génération de l''observation.'),
    ('recouvrement', 'Decimal', 'recouvrement', 'Pourcentage de recouvrement de l''habitat par rapport à la station.'),
    ('abondancehabitat', 'AbondanceHabitatValue', 'abondanceHabitat', 'Abondance relative de l''habitat par rapport à la station.'),
    ('precisiontechnique', 'CharacterString', 'precisionTechnique', 'Précisions sur la technique de collecte quand techniqueCollecte prend la valeur 10.'),
    ('releveespeces', 'CharacterString', 'relevesEspeces', 'Identifiant d''un regroupement au sein du standard Occurences de taxons du SINP.'),
    ('relevephyto', 'CharacterString', 'relevePhyto', 'Identifiant d''un relevé phytosociologique de l''extension relevés phytosociologiques du standard occurrences de taxons.'),
    ('sensibilitehab', 'NiveauSensiValue', 'sensibiliteHab', 'Sensibilité de l''habitat selon le producteur.'),
    ('echellenumerisation', 'CharacterString', 'echelleNumerisation', 'Echelle de carte à laquelle la numérisation de l''information géographique a été effectuée.')
;


----------------------------------------------------------------
-- Format
----------------------------------------------------------------

INSERT INTO format (format, type) VALUES
    ('table_station', 'TABLE'),
    ('table_habitat', 'TABLE'),
    ('file_station', 'FILE'),
    ('file_habitat', 'FILE')
;

----------------------------------------------------------------
-- 8. Table format
----------------------------------------------------------------

INSERT INTO table_format (format,table_name,schema_code,primary_key,label,definition) VALUES 
    ('table_station','model_1000_station','RAW_DATA','OGAM_ID_table_station, PROVIDER_ID, USER_LOGIN','station','table_dsr_exemple_station'),
    ('table_habitat','model_1000_habitat','RAW_DATA','OGAM_ID_table_habitat, PROVIDER_ID, USER_LOGIN','habitat','table_dsr_exemple_habitat')
;


----------------------------------------------------------------
-- File format
----------------------------------------------------------------

INSERT INTO file_format (format,file_extension,file_type,position,label,definition) VALUES
    ('file_station','CSV','file_station',0,'dsr_exemple_station','fichier_dsr_exemple_station'),
    ('file_habitat','CSV','file_habitat',1,'dsr_exemple_habitat','fichier_dsr_exemple_habitat')
;



----------------------------------------------------------------
-- Model tables
----------------------------------------------------------------

INSERT INTO model_tables (model_id,table_id) VALUES ('model_1000','table_station');
INSERT INTO model_tables (model_id,table_id) VALUES ('model_1000','table_habitat');



----------------------------------------------------------------
-- Model datasets
----------------------------------------------------------------

INSERT INTO model_datasets (model_id,dataset_id) VALUES ('model_1000','dataset_1000');
INSERT INTO model_datasets (model_id,dataset_id) VALUES ('model_1000','dataset_1002');

----------------------------------------------------------------
-- Dataset files
----------------------------------------------------------------

INSERT INTO dataset_files (dataset_id,format) VALUES ('dataset_1000','file_station');
INSERT INTO dataset_files (dataset_id,format) VALUES ('dataset_1000','file_habitat');



----------------------------------------------------------------
-- Table tree
----------------------------------------------------------------

INSERT INTO table_tree (schema_code,child_table,parent_table,join_key,comment) VALUES ('RAW_DATA','table_station',NULL,NULL,NULL);
INSERT INTO table_tree (schema_code,child_table,parent_table,join_key,comment) VALUES ('RAW_DATA','table_habitat','table_station','identifiantstasinp',NULL);


----------------------------------------------------------------
-- Field
----------------------------------------------------------------

-- Table
--------

INSERT INTO field (type,"data",format) VALUES ('TABLE','identifianthabsinp','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','nomcite','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','preuvenumerique','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','cdhab','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','typedeterm','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','determinateur','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','techniquecollecte','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','recouvrement','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','abondancehabitat','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','identifiantorigine','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','precisiontechnique','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','releveespeces','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','relevephyto','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','sensibilitehab','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','OGAM_ID_table_habitat','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','SUBMISSION_ID','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','PROVIDER_ID','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','USER_LOGIN','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','identifiantstasinp','table_habitat');
INSERT INTO field (type,"data",format) VALUES ('TABLE','identifiantstasinp','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','jddmetadonneedeeid','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','dspublique','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','referencebiblio','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','identifiantoriginestation','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','jourdatedebut','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','jourdatefin','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','dateimprecise','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','observateur','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','nomstation','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','estcomplexehabitats','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','exposition','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','altitudemin','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','altitudemax','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','altitudemoyenne','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','profondeurmin','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','profondeurmax','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','profondeurmoyenne','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','surface','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','methodecalculsurface','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','usage','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','typesol','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','geologie','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','acidite','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','commentaire','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','geometrie','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','natureobjetgeo','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','precisiongeometrie','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','echellenumerisation','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','codemaillecalcule','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','codecommunecalcule','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','nomcommunecalcule','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','codedepartementcalcule','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','OGAM_ID_table_station','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','SUBMISSION_ID','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','PROVIDER_ID','table_station');
INSERT INTO field (type,"data",format) VALUES ('TABLE','USER_LOGIN','table_station');

-- File
-------

INSERT INTO field (type,"data",format) VALUES 
    ('FILE','abondancehabitat','file_habitat'),
    ('FILE','cdhab','file_habitat'),
    ('FILE','determinateur','file_habitat'),
    ('FILE','identifiantorigine','file_habitat'),
    ('FILE','precisiontechnique','file_habitat'),
    ('FILE','preuvenumerique','file_habitat'),
    ('FILE','recouvrement','file_habitat'),
    ('FILE','releveespeces','file_habitat'),
    ('FILE','relevephyto','file_habitat'),
    ('FILE','sensibilitehab','file_habitat'),
    ('FILE','typedeterm','file_habitat'),
    ('FILE','identifianthabsinp','file_habitat'),
    ('FILE','nomcite','file_habitat'),
    ('FILE','techniquecollecte','file_habitat'),
    ('FILE','identifiantstasinp','file_habitat'),
    ('FILE','acidite','file_station'),
    ('FILE','altitudemax','file_station'),
    ('FILE','altitudemin','file_station'),
    ('FILE','altitudemoyenne','file_station'),
    ('FILE','commentaire','file_station'),
    ('FILE','dateimprecise','file_station'),
    ('FILE','echellenumerisation','file_station'),
    ('FILE','estcomplexehabitats','file_station'),
    ('FILE','exposition','file_station'),
    ('FILE','geologie','file_station'),
    ('FILE','geometrie','file_station'),
    ('FILE','identifiantoriginestation','file_station'),
    ('FILE','methodecalculsurface','file_station'),
    ('FILE','natureobjetgeo','file_station'),
    ('FILE','nomstation','file_station'),
    ('FILE','precisiongeometrie','file_station'),
    ('FILE','profondeurmax','file_station'),
    ('FILE','profondeurmin','file_station'),
    ('FILE','profondeurmoyenne','file_station'),
    ('FILE','referencebiblio','file_station'),
    ('FILE','surface','file_station'),
    ('FILE','typesol','file_station'),
    ('FILE','usage','file_station'),
    ('FILE','dspublique','file_station'),
    ('FILE','identifiantstasinp','file_station'),
    ('FILE','jddmetadonneedeeid','file_station'),
    ('FILE','jourdatedebut','file_station'),
    ('FILE','jourdatefin','file_station'),
    ('FILE','observateur','file_station')
;



----------------------------------------------------------------
-- Table field
----------------------------------------------------------------

-- Table habitat
----------------

INSERT INTO table_field ("data",format,column_name,is_calculated,is_editable,is_insertable,is_mandatory,"position") VALUES 
    ('identifianthabsinp','table_habitat','identifianthabsinp','0','0','1','1',1),
    ('nomcite','table_habitat','nomcite','0','1','1','1',2),
    ('preuvenumerique','table_habitat','preuvenumerique','0','1','1','0',3),
    ('cdhab','table_habitat','cdhab','0','1','1','0',4),
    ('typedeterm','table_habitat','typedeterm','0','1','1','0',5),
    ('determinateur','table_habitat','determinateur','0','1','1','0',6),
    ('techniquecollecte','table_habitat','techniquecollecte','0','1','1','1',7),
    ('recouvrement','table_habitat','recouvrement','0','1','1','0',8),
    ('abondancehabitat','table_habitat','abondancehabitat','0','1','1','0',9),
    ('identifiantorigine','table_habitat','identifiantorigine','0','1','1','0',10),
    ('precisiontechnique','table_habitat','precisiontechnique','0','1','1','0',11),
    ('releveespeces','table_habitat','releveespeces','0','1','1','0',12),
    ('relevephyto','table_habitat','relevephyto','0','1','1','0',13),
    ('sensibilitehab','table_habitat','sensibilitehab','0','1','1','0',14),
    ('OGAM_ID_table_habitat','table_habitat','ogam_id_table_habitat','1','0','0','1',15),
    ('SUBMISSION_ID','table_habitat','submission_id','1','0','0','0',16),
    ('PROVIDER_ID','table_habitat','provider_id','0','0','0','1',17),
    ('USER_LOGIN','table_habitat','user_login','0','0','0','1',18),
    ('identifiantstasinp','table_habitat','identifiantstasinp','0','1','1','1',19)
;

-- Table station
----------------

INSERT INTO table_field ("data",format,column_name,is_calculated,is_editable,is_insertable,is_mandatory,"position") VALUES
    ('identifiantstasinp','table_station','identifiantstasinp','0','0','1','1',1),
    ('jddmetadonneedeeid','table_station','metadonneid','0','1','1','1',2),
    ('dspublique','table_station','dspublique','0','1','1','1',3),
    ('referencebiblio','table_station','referencebiblio','0','1','1','0',4),
    ('identifiantoriginestation','table_station','identifiantoriginestation','0','1','1','0',5),
    ('jourdatedebut','table_station','jourdatedebut','0','1','1','1',6),
    ('jourdatefin','table_station','jourdatefin','0','1','1','1',7),
    ('dateimprecise','table_station','dateimprecise','0','1','1','0',8),
    ('observateur','table_station','observateur','0','1','1','1',9),
    ('nomstation','table_station','nomstation','0','1','1','0',10),
    ('estcomplexehabitats','table_station','estcomplexehabitats','0','1','1','0',11),
    ('exposition','table_station','exposition','0','1','1','0',12),
    ('altitudemin','table_station','altitudemin','0','1','1','0',13),
    ('altitudemax','table_station','altitudemax','0','1','1','0',14),
    ('altitudemoyenne','table_station','altitudemoyenne','0','1','1','0',15),
    ('profondeurmin','table_station','profondeurmin','0','1','1','0',16),
    ('profondeurmax','table_station','profondeurmax','0','1','1','0',17),
    ('profondeurmoyenne','table_station','profondeurmoyenne','0','1','1','0',18),
    ('surface','table_station','surface','0','1','1','0',19),
    ('methodecalculsurface','table_station','methodecalculsurface','0','1','1','0',20),
    ('usage','table_station','usage','0','1','1','0',21),
    ('typesol','table_station','typesol','0','1','1','0',22),
    ('geologie','table_station','geologie','0','1','1','0',23),
    ('acidite','table_station','acidite','0','1','1','0',24),
    ('commentaire','table_station','commentaire','0','1','1','0',25),
    ('geometrie','table_station','geometrie','1','1','1','0',26),
    ('natureobjetgeo','table_station','natureobjetgeo','0','1','1','0',27),
    ('precisiongeometrie','table_station','precisiongeometrie','0','1','1','0',28),
    ('echellenumerisation','table_station','echellenumerisation','0','1','1','0',29),
    ('codemaillecalcule','table_station','codemaillecalcule','1','0','1','0',30),
    ('codecommunecalcule','table_station','codecommunecalcule','1','0','1','0',31),
    ('nomcommunecalcule','table_station','nomcommunecalcule','1','0','1','0',32),
    ('codedepartementcalcule','table_station','codedepartementcalcule','1','0','1','0',33),
    ('OGAM_ID_table_station','table_station','ogam_id_table_station','1','0','0','1',26),
    ('SUBMISSION_ID','table_station','submission_id','1','0','0','0',27),
    ('PROVIDER_ID','table_station','provider_id','0','0','0','1',28),
    ('USER_LOGIN','table_station','user_login','0','0','0','1',29)
;


----------------------------------------------------------------
-- File field
----------------------------------------------------------------

INSERT INTO file_field ("data",format,is_mandatory,mask,label_csv) VALUES 
    ('abondancehabitat','file_habitat','0',NULL,'abondanceHabitat'),
    ('cdhab','file_habitat','0',NULL,'cdHab'),
    ('determinateur','file_habitat','0',NULL,'determinateur'),
    ('identifiantorigine','file_habitat','0',NULL,'identifiantOrigine'),
    ('precisiontechnique','file_habitat','0',NULL,'precisionTechnique'),
    ('preuvenumerique','file_habitat','0',NULL,'preuveNumerique'),
    ('recouvrement','file_habitat','0',NULL,'recouvrement'),
    ('releveespeces','file_habitat','0',NULL,'relevesEspeces'),
    ('relevephyto','file_habitat','0',NULL,'relevePhyto'),
    ('sensibilitehab','file_habitat','0',NULL,'sensibiliteHab'),
    ('typedeterm','file_habitat','0',NULL,'typeDeterm'),
    ('identifianthabsinp','file_habitat','1',NULL,'identifiantHabSINP'),
    ('nomcite','file_habitat','1',NULL,'nomCite'),
    ('techniquecollecte','file_habitat','1',NULL,'techniqueCollecte'),
    ('identifiantstasinp','file_habitat','1',NULL,'identifiantStaSINP'),
    ('acidite','file_station','0',NULL,'acidite'),
    ('altitudemax','file_station','0',NULL,'altitudeMax'),
    ('altitudemin','file_station','0',NULL,'altitudeMin'),
    ('altitudemoyenne','file_station','0',NULL,'altitudeMoyenne'),
    ('commentaire','file_station','0',NULL,'commentaire'),
    ('dateimprecise','file_station','0',NULL,'dateImprecise'),
    ('echellenumerisation','file_station','0',NULL,'echelleNumerisation'),
    ('estcomplexehabitats','file_station','0',NULL,'estComplexeHabitats'),
    ('exposition','file_station','0',NULL,'exposition'),
    ('geologie','file_station','0',NULL,'geologie'),
    ('geometrie','file_station','0',NULL,'geometrie'),
    ('identifiantoriginestation','file_station','0',NULL,'identifiantOrigineStation'),
    ('methodecalculsurface','file_station','0',NULL,'methodeCalculSurface'),
    ('natureobjetgeo','file_station','0',NULL,'natureObjetGeo'),
    ('nomstation','file_station','0',NULL,'nomStation'),
    ('precisiongeometrie','file_station','0',NULL,'precisionGeometrie'),
    ('profondeurmax','file_station','0',NULL,'profondeurMax'),
    ('profondeurmin','file_station','0',NULL,'profondeurMin'),
    ('profondeurmoyenne','file_station','0',NULL,'profondeurMoyenne'),
    ('referencebiblio','file_station','0',NULL,'referenceBiblio'),
    ('surface','file_station','0',NULL,'surface'),
    ('typesol','file_station','0',NULL,'typeSol'),
    ('usage','file_station','0',NULL,'usage'),
    ('dspublique','file_station','1',NULL,'dSPublique'),
    ('identifiantstasinp','file_station','1',NULL,'identifiantStaSINP'),
    ('jddmetadonneedeeid','file_station','1',NULL,'jddMetadonneeDEEId'),
    ('jourdatedebut','file_station','1','yyyy-MM-dd','jourDateDebut'),
    ('jourdatefin','file_station','1','yyyy-MM-dd','jourDateFin'),
    ('observateur','file_station','1',NULL,'observateur')
;



----------------------------------------------------------------
-- Field mapping
----------------------------------------------------------------

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type)
    SELECT data, format, data, 'table_habitat', 'FILE'
    FROM field
    WHERE format = 'file_habitat'
;

INSERT INTO field_mapping (src_data, src_format, dst_data, dst_format, mapping_type)
    SELECT data, format, data, 'table_station', 'FILE'
    FROM field
    WHERE format = 'file_station'
;

----------------------------------------------------------------
-- Dataset fields
----------------------------------------------------------------

INSERT INTO dataset_fields (dataset_id, schema_code, format, data)
    SELECT 'dataset_1002', 'RAW_DATA', format, data
    FROM field
    WHERE format IN ('table_station', 'table_habitat')
;

COMMIT ;

ROLLBACK;