-- --------------------------------------------------
-- 1/ Création des tables du référentiel TAXREF (V11)
-- --------------------------------------------------

set search_path = referentiels;

-- Création d'une table pour le référentiel taxonomique
create table taxref (
REGNE				VARCHAR(100)	null,
PHYLUM				VARCHAR(100)	null,
CLASSE				VARCHAR(100)	null,
ORDRE				VARCHAR(100)	null,
FAMILLE				VARCHAR(100)	null,
SOUS_FAMILLE		VARCHAR(100)	null,
TRIBU				VARCHAR(100)	null,
GROUP1_INPN			VARCHAR(100)	null,
GROUP2_INPN			VARCHAR(100)	null,
CD_NOM				VARCHAR(100)	not null, -- identifiant unique du taxon
CD_TAXSUP			VARCHAR(100)	null, -- identifiant du parent
CD_SUP				VARCHAR(100)	null,
CD_REF				VARCHAR(100)	not null, -- synonymes
RANG				VARCHAR(100)	null,
LB_NOM				VARCHAR(500)	null,
LB_AUTEUR			VARCHAR(500)	null,
NOM_COMPLET			VARCHAR(500)	null,
NOM_COMPLET_HTML	VARCHAR(1000)	null,
NOM_VALIDE			VARCHAR(500)	null,
NOM_VERN			VARCHAR(1000)	null,
NOM_VERN_ENG		VARCHAR(1000)	null,
HABITAT				VARCHAR(100)	null,
FR					VARCHAR(100)	null,
GF					VARCHAR(100)	null,
MAR					VARCHAR(100)	null,
GUA					VARCHAR(100)	null,
SM					VARCHAR(100)	null,
SB					VARCHAR(100)	null,
SPM					VARCHAR(100)	null,
MAY					VARCHAR(100)	null,
EPA					VARCHAR(100)	null,
REU					VARCHAR(100)	null,
SA					VARCHAR(100)	null,
TA					VARCHAR(100)	null,
TAAF				VARCHAR(100)	null,
PF					VARCHAR(100)	null,
NC					VARCHAR(100)	null,
WF					VARCHAR(100)	null,
CLI					VARCHAR(100)	null,
URL					VARCHAR(100)	null,
constraint PK_taxref primary key (CD_NOM)
);

COMMENT ON COLUMN taxref.REGNE IS 'Règne auquel le taxon appartient (champ calculé à partir du CD_TAXSUP)';
COMMENT ON COLUMN taxref.PHYLUM IS 'Embranchement auquel le taxon appartient (champ calculé à partir du CD_TAXSUP)';
COMMENT ON COLUMN taxref.CLASSE IS 'Classe à laquelle le taxon appartient (champ calculé à partir du CD_TAXSUP)';
COMMENT ON COLUMN taxref.ORDRE IS 'Ordre auquel le taxon appartient (champ calculé à partir du CD_TAXSUP)';
COMMENT ON COLUMN taxref.FAMILLE IS 'Famille à laquelle le taxon appartient (champ calculé à partir du CD_TAXSUP)';
COMMENT ON COLUMN taxref.SOUS_FAMILLE IS 'Sous-famille à laquelle le taxon appartient';
COMMENT ON COLUMN taxref.TRIBU IS 'Tribu à laquelle le taxon appartient';
COMMENT ON COLUMN taxref.CD_NOM IS 'Identifiant unique du nom scientifique';
COMMENT ON COLUMN taxref.CD_TAXSUP IS 'Identifiant (CD_NOM) du taxon supérieur';
COMMENT ON COLUMN taxref.CD_SUP IS 'Identifiant (CD_NOM) du taxon supérieur';
COMMENT ON COLUMN taxref.CD_REF IS 'Identifiant (CD_NOM) du taxon de référence (nom retenu)';
COMMENT ON COLUMN taxref.RANG IS 'Rang taxonomique (lien vers TAXREF_RANG) ';
COMMENT ON COLUMN taxref.LB_NOM IS 'Nom scientifique du taxon';
COMMENT ON COLUMN taxref.LB_AUTEUR IS 'Autorité du taxon (Auteur, année, gestion des parenthèses)';
COMMENT ON COLUMN taxref.NOM_COMPLET IS 'Nom scientifique complet du taxon (généralement LB_NOM + LB_AUTEUR)';
COMMENT ON COLUMN taxref.NOM_VALIDE IS 'Le NOM_COMPLET du CD_REF';
COMMENT ON COLUMN taxref.CD_REF IS 'Renvoi au CD_NOM du taxon de référence';
COMMENT ON COLUMN taxref.NOM_VERN IS 'Nom vernaculaire du taxon en français';
COMMENT ON COLUMN taxref.NOM_VERN_ENG IS 'Nom vernaculaire du taxon en anglais';
COMMENT ON COLUMN taxref.FR IS 'Statut biogéographique en France métropolitaine';
COMMENT ON COLUMN taxref.GF IS 'Statut biogéographique en Guyane française';
COMMENT ON COLUMN taxref.MAR IS 'Statut biogéographique en Martinique';
COMMENT ON COLUMN taxref.GUA IS 'Statut biogéographique en Guadeloupe';
COMMENT ON COLUMN taxref.SM IS 'Statut biogéographique à Saint-Martin';
COMMENT ON COLUMN taxref.SB IS 'Statut biogéographique à Saint-Barthélémy';
COMMENT ON COLUMN taxref.SPM IS 'Statut biogéographique à Saint-Pierre et Miquelon';
COMMENT ON COLUMN taxref.MAY IS 'Statut biogéographique à Mayotte';
COMMENT ON COLUMN taxref.EPA IS 'Statut biogéographique aux Iles Eparses';
COMMENT ON COLUMN taxref.REU IS 'Statut biogéographique à la Réunion';
COMMENT ON COLUMN taxref.SA IS 'Statut biogéographique aux ??';
COMMENT ON COLUMN taxref.TA IS 'Statut biogéographique aux ??';
COMMENT ON COLUMN taxref.TAAF IS 'Statut biogéographique aux Terres australes et antarctiques françaises';
COMMENT ON COLUMN taxref.NC IS 'Statut biogéographique en Nouvelle-Calédonie';
COMMENT ON COLUMN taxref.WF IS 'Statut biogéographique à Wallis et Futuna';
COMMENT ON COLUMN taxref.PF IS 'Statut biogéographique en Polynésie française';
COMMENT ON COLUMN taxref.CLI IS 'Statut biogéographique à Clipperton';
COMMENT ON COLUMN taxref.URL IS 'Permalien INPN = ‘http://inpn.mnhn.fr/espece/cd_nom/’ + CD_NOM';

-- Droits
GRANT SELECT ON TABLE taxref TO ogam;

-- Ajout de la définition des rangs
create table taxref_rang (
	RANG		VARCHAR(5)		not null,
	DETAIL		VARCHAR(100)		null,
	constraint PK_taxref_rang primary key (RANG)
);

INSERT INTO taxref_rang (rang, detail) VALUES ('Dumm','Dommaine');
INSERT INTO taxref_rang (rang, detail) VALUES ('SRPG','Super-Règne');
INSERT INTO taxref_rang (rang, detail) VALUES ('KD','Règne');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSRG','Sous-Règne');
INSERT INTO taxref_rang (rang, detail) VALUES ('IFRG','Infra-Règne');
INSERT INTO taxref_rang (rang, detail) VALUES ('PH','Phylum/Embranchement');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBPH','Sous-Phylum');
INSERT INTO taxref_rang (rang, detail) VALUES ('IFPH','Infra-Phylum');
INSERT INTO taxref_rang (rang, detail) VALUES ('DV','Division');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBDV','Sous-Division');
INSERT INTO taxref_rang (rang, detail) VALUES ('SPCL','Super-Classe');
INSERT INTO taxref_rang (rang, detail) VALUES ('CLAD','Cladus');
INSERT INTO taxref_rang (rang, detail) VALUES ('CL','Classe');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBCL','Sous-Classe');
INSERT INTO taxref_rang (rang, detail) VALUES ('IFCL','Infra-Classe');
INSERT INTO taxref_rang (rang, detail) VALUES ('LEG','Legio');
INSERT INTO taxref_rang (rang, detail) VALUES ('SPOR','Super-Ordre');
INSERT INTO taxref_rang (rang, detail) VALUES ('COH','Cohorte');
INSERT INTO taxref_rang (rang, detail) VALUES ('OR','Ordre');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBOR','Sous-Ordre');
INSERT INTO taxref_rang (rang, detail) VALUES ('IFOR','Infra-Ordre');
INSERT INTO taxref_rang (rang, detail) VALUES ('SPFM','Super-Famille');
INSERT INTO taxref_rang (rang, detail) VALUES ('FM','Famille');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBFM','Sous-Famille');
INSERT INTO taxref_rang (rang, detail) VALUES ('TR','Tribu');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSTR','Sous-Tribu');
INSERT INTO taxref_rang (rang, detail) VALUES ('GN','Genre');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSGN','Sous-Genre');
INSERT INTO taxref_rang (rang, detail) VALUES ('SC','Section');
INSERT INTO taxref_rang (rang, detail) VALUES ('SBSC','Sous-Section');
INSERT INTO taxref_rang (rang, detail) VALUES ('SER','Série');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSER','Sous-Série');
INSERT INTO taxref_rang (rang, detail) VALUES ('AGES','Agrégat');
INSERT INTO taxref_rang (rang, detail) VALUES ('ES','Espèce');
INSERT INTO taxref_rang (rang, detail) VALUES ('SMES','Semi-Espèce');
INSERT INTO taxref_rang (rang, detail) VALUES ('MES','Micro-Espèce');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSES','Sous-Espèce');
INSERT INTO taxref_rang (rang, detail) VALUES ('NAT','Natio');
INSERT INTO taxref_rang (rang, detail) VALUES ('VAR','Variété');
INSERT INTO taxref_rang (rang, detail) VALUES ('SVAR','Sous-Variété');
INSERT INTO taxref_rang (rang, detail) VALUES ('FO','Forme');
INSERT INTO taxref_rang (rang, detail) VALUES ('SSFO','Sous-Forme');
INSERT INTO taxref_rang (rang, detail) VALUES ('FOES','Forma-Species');
INSERT INTO taxref_rang (rang, detail) VALUES ('LIN','Linea');
INSERT INTO taxref_rang (rang, detail) VALUES ('CLO','Clône');
INSERT INTO taxref_rang (rang, detail) VALUES ('RACE','Race');
INSERT INTO taxref_rang (rang, detail) VALUES ('CAR','Cultivar');
INSERT INTO taxref_rang (rang, detail) VALUES ('MO','Morpha');
INSERT INTO taxref_rang (rang, detail) VALUES ('AB','Abberatio');

-- Ajout de la définition des statuts
create table taxref_statut (
statut		VARCHAR(1)	not null,
description	VARCHAR(100)	null,
constraint PK_taxref_statut primary key (statut)
);

INSERT INTO taxref_statut (statut, description) VALUES ('A','Absente');
INSERT INTO taxref_statut (statut, description) VALUES ('B','Occasionnel');
INSERT INTO taxref_statut (statut, description) VALUES ('C','Cryptogène');
INSERT INTO taxref_statut (statut, description) VALUES ('D','Douteux');
INSERT INTO taxref_statut (statut, description) VALUES ('E','Endémique');
INSERT INTO taxref_statut (statut, description) VALUES ('I','Introduit');
INSERT INTO taxref_statut (statut, description) VALUES ('J','Introduit envahissant');
INSERT INTO taxref_statut (statut, description) VALUES ('M','Introduit non établi (dont domestique)');
INSERT INTO taxref_statut (statut, description) VALUES ('P','Présent (indigène ou indéterminé)');
INSERT INTO taxref_statut (statut, description) VALUES ('S','Subendémique');
INSERT INTO taxref_statut (statut, description) VALUES ('W','Disparu');
INSERT INTO taxref_statut (statut, description) VALUES ('X','Eteint');
INSERT INTO taxref_statut (statut, description) VALUES ('Y','Introduit éteint / disparu');
INSERT INTO taxref_statut (statut, description) VALUES ('Z','Endémique éteint');
INSERT INTO taxref_statut (statut, description) VALUES ('Q','Mentionné par erreur');
