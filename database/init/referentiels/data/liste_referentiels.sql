-- table listing all the referentiels used in the application

CREATE TABLE referentiels.liste_referentiels (
  table_name varchar(50) NOT NULL,
  "name" varchar(50) NOT NULL,
  label varchar(255) NULL,
  description text NULL,
  "version" varchar(50) NULL,
  "type" varchar(20) NOT NULL  DEFAULT 'nomenclature',
  updated_at date NULL,
  url varchar(255) NULL
)
WITH (
OIDS=FALSE
) ;
ALTER TABLE referentiels.liste_referentiels ADD CONSTRAINT liste_referentiels_pk PRIMARY KEY (table_name) ;

COMMENT ON COLUMN referentiels.liste_referentiels.table_name IS 'Name of the table in the referentiels schema' ;
COMMENT ON COLUMN referentiels.liste_referentiels."name" IS 'Computer name of the referentiel (as in the INPN list)' ;
COMMENT ON COLUMN referentiels.liste_referentiels.label IS 'Readable name of the referentiel' ;
COMMENT ON COLUMN referentiels.liste_referentiels.description IS 'Readable description of the referentiel' ;
COMMENT ON COLUMN referentiels.liste_referentiels."version" IS 'Current version of the referentiel used in the application' ;
COMMENT ON COLUMN referentiels.liste_referentiels."type" IS 'Type: nomenclature or referentiel' ;
COMMENT ON COLUMN referentiels.liste_referentiels.updated_at IS 'Date of last update of the data in the referentiel; can be the date of publication of the referentiel, or the date when data where exported from a database' ;
COMMENT ON COLUMN referentiels.liste_referentiels.url IS 'Url where the referntiel can be downloaded or where information can be found' ;

ALTER TABLE referentiels.liste_referentiels
  OWNER TO admin;
GRANT ALL ON TABLE referentiels.liste_referentiels TO admin;
GRANT ALL ON TABLE referentiels.liste_referentiels TO ogam;



INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'codeenvalue','Espaces naturels français','Référentiel des espaces naturels en France métropolitaine et d’outre-mer. Le référentiel est géré par la MNHN. Il n’y a pas de numéros de version, il est en perpétuelle évolution.','?','referentiel','EN','2017-02-28','https://inpn.mnhn.fr/telechargement/cartes-et-information-geographique');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'codemaillevalue','Grille nationale (10km x 10km) - Métropole/DOM','Ce référentiel compile les grilles 10km x 10km des territoires métropolitain et d’outre-mer. ','2011-2012','referentiel','MAILLES_10x10','2012-01-01','https://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref/referentiels');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'coderefhabitatvalue','Référentiels d''habitats et typologies','Nomenclature des référentiels d''habitats et typologies utilisés pour rapporter un habitat au sein du standard. La référence à paraître prochainement est HABREF. http://inpn.mnhn.fr/telechargement/referentiels/habitats Les typologies sont disponibles à la même adresse, mais seront prochainement à l''adresse suivante : http://inpn.mnhn.fr/telechargement/referentiels/habitats/typologies','Occtax v1.2.1','nomenclature','REF_HAB','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'commune_carto_2017','Communes françaises','Référentiel administratif et géométrique des communes de France métropolitaine et d’outre-mer. Issu du produit IGN : ADMIN EXPRESS-COG carto millésimé 2017.','2017','referentiel','COMMUNES','2017-06-19','http://professionnels.ign.fr/adminexpress');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'departement_carto_2017','Départements français','Référentiel administratif et géométrique des départements de France métropolitaine et d’outre-mer. Issu du produit IGN : ADMIN EXPRESS-COG carto millésimé 2017.','2017','referentiel','DEPARTEMENTS','2017-06-19','http://professionnels.ign.fr/adminexpress');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'especesensible','Liste nationale des espèces sensibles','La liste nationale des espèces sensibles compile les listes régionales, quand elles existent, et une liste nationale, par défaut,  pour les régions qui ne sont pas dotés d’une liste régionale. Le MNHN maintient ce référentiel.','?','referentiel','ESPECES_SENSIBLES','2017-06-06','');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'especesensiblelistes','Liste des listes régionales d’espèces sensibles','Cette liste recense les listes utilisées dans la construction de la liste nationale des espèces sensibles.','?','referentiel','LISTES_ESPECES_SENSIBLES','2017-06-06','');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'habref_20','Référentiel des typologies d’habitats et de végétation pour la France HABREF','HABREF est un référentiel national réunissant les versions officielles de référence des typologies d’habitats ou de végétation couvrant les milieux marins et/ou continentaux des territoires français de métropole et d’outre-mer. Sont prises en compte les typologies nationales ou relatives à un territoire d’outre-mer et les typologies internationales, quand elles concernent la France. ','2.0','referentiel','HABREF','2015-10-01','https://inpn.mnhn.fr/telechargement/referentiels/habitats');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'idcnpvalue','Protocoles de collecte','Obsolete – non utilisé','','referentiel','IDCNP',NULL,'');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'region_carto_2017','Régions françaises','Référentiel administratif et géométrique des régions de France métropolitaine et d’outre-mer. Issu du produit IGN : ADMIN EXPRESS-COG carto millésimé 2017.','2017','referentiel','REGIONS','2017-06-19','http://professionnels.ign.fr/adminexpress');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'taxref','Référentiel taxonomique TAXREF','Référentiel taxonomique : Faune, flore et fonge de France métropolitaine et d''outre-mer ','v11','referentiel','TAXREF','2018-06-26','https://inpn.mnhn.fr/telechargement/referentielEspece/taxref/11.0/menu');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrencestadedevievalue','Stade de vie : stade de développement du sujet','Nomenclature des stades de vie : stades de développement du sujet de l''observation.','Occtax v1.2.1','nomenclature','STADE_VIE','2016-03-24','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'natureobjetgeovalue','Nature d''objet géographique','Nomenclature des natures d''objets géographiques','Occtax v1.2.1','nomenclature','NAT_OBJ_GEO ','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'sensiblevalue','Valeurs de sensibilité qualitative','Nomenclature des valeurs de sensibilité qualitative (oui/non)','Occtax v1.2.1','nomenclature','SENSIBLE ','2016-04-07','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrencenaturalistevalue','Niveau de naturalité','Nomenclature des niveaux de naturalité','Occtax v1.2.1','nomenclature','NATURALITE','2015-10-19','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'observationmethodevalue','Méthodes d''observation','Nomenclature des méthodes d''observation, indiquant de quelle manière ou avec quel indice on a pu observer le sujet.','Occtax v1.2.1','nomenclature','METH_OBS','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrencesexevalue','Sexe','Nomenclature des sexes','Occtax v1.2.1','nomenclature','SEXE','2015-10-19','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'statutsourcevalue','Statut de la source','Nomenclature des statuts possibles de la source.','Occtax v1.2.1','nomenclature','STATUT_SOURCE','2013-12-04','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrencestatutbiogeographiquevalue','Statut biogéographique','Nomenclature des statuts biogéographiques.','Occtax v1.2.1','nomenclature','STAT_BIOGEO','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'sensibilitevalue','Niveau de sensibilité','Nomenclature des niveaux de sensibilité possibles','Occtax v1.2.1','nomenclature','SENSIBILITE ','2016-04-07','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'versionmassedeauvalue','Version des masses d''eau','Nomenclature des versions du référentiel SANDRE utilisé pour les masses d''eau.','Occtax v1.2.1','nomenclature','VERS_ME','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'deefloutagevalue','Existence d''un floutage sur la donnée','Nomenclature indiquant l''existence d''un floutage sur la donnée lors de sa création en tant que DEE.','Occtax v1.2.1','nomenclature','DEE_FLOU','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'typeenvalue','Type d''espace naturel','Nomenclature des types d''espaces naturels.','Occtax v1.2.1','nomenclature','TYP_EN','2016-06-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrencestatutbiologiquevalue','Statut biologique','Nomenclature des statuts biologiques.','Occtax v1.2.1','nomenclature','STATUT_BIO','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'dspubliquevalue','Code d''origine de la donnée','Nomenclature des codes d''origine de la donnée : publique, privée, mixte...','Occtax v1.2.1','nomenclature','DS_PUBLIQUE ','2013-12-05','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'statutobservationvalue','Statut d''observation','Nomenclature des statuts d''observation.','Occtax v1.2.1','nomenclature','STATUT_OBS ','2016-03-24','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'preuveexistantevalue','Preuve existante','Nomenclature de l''existence des preuves.','Occtax v1.2.1','nomenclature','PREUVE_EXIST','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'objetdenombrementvalue','Objet du dénombrement','Nomenclature des objets qui peuvent être dénombrés','Occtax v1.2.1','nomenclature','OBJ_DENBR','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'typeattributvalue','Type de l''attribut','Nomenclature des types d''attributs additionnels.','Occtax v1.2.1','nomenclature','TYP_ATTR ','2015-12-07','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'niveauprecisionvalue','Niveaux de précision de diffusion souhaités','Nomenclature des niveaux de précision de diffusion souhaités par le producteur.','Occtax v1.2.1','nomenclature','NIV_PRECIS','2015-10-15','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'typeregroupementvalue','Type de regroupement','Nomenclature listant les valeurs possibles pour le type de regroupement.','Occtax v1.2.1','nomenclature','TYP_GRP','2015-12-07','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'typedenombrementvalue','Type de dénombrement','Nomenclature des types de dénombrement possibles (comptage, estimation...)','Occtax v1.2.1','nomenclature','DENBR','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'typeinfogeovalue','Type d''information géographique','Nomenclature des types d''information géographique dans le cas de l''utilisation d''un rattachement à un objet géographique (commune, département, espace naturel, masse d''eau...).','Occtax v1.2.1','nomenclature','TYP_INF_GEO','2015-12-16','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');
INSERT INTO referentiels.liste_referentiels (table_name,label,description,"version","type","name",updated_at,url) VALUES (
  'occurrenceetatbiologiquevalue','Etat biologique de l''observation','Nomenclature des états biologiques de l''observation.','Occtax v1.2.1','nomenclature','ETA_BIO','2015-10-19','https://inpn.mnhn.fr/telechargement/standard-occurrence-taxon');


