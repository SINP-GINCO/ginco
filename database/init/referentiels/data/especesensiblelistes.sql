CREATE TABLE referentiels.especesensiblelistes
(
  short_citation character varying(500),
  cd_insee_reg character varying(500),
  date_liste integer,
  full_citation character varying(500),
  url character varying(500),
  cd_doc integer,
  cd_sl integer,
  CONSTRAINT pk_cd_doc PRIMARY KEY (cd_doc)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE referentiels.especesensiblelistes
  OWNER TO admin;
 
GRANT ALL ON TABLE referentiels.especesensiblelistes TO admin;
GRANT ALL ON TABLE referentiels.especesensiblelistes TO ogam;
GRANT ALL ON TABLE referentiels.especesensiblelistes TO postgres;
  
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Touroult (2016)', NULL, 2016, 'Touroult, J. 2016. SINP. Liste nationale des taxons potentiellement sensibles et des conditions de sensibilité/non sensibilité de la donnée, Version 2.', NULL, 142869, 9);
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Anonyme (2015)', 91, 2015, 'Anonyme. 2015. <em>Référentiel des données sensibles du Languedoc-Roussillon. Version 1.0 validée le 10/11/2015 par le CSRPN Languedoc-Roussillon</em>. Fichier Excel.', 'http://www.naturefrance.fr/languedoc-roussillon/referentiel-des-donnees-sensibles', 158608, 11);
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Anonyme (2016)', 26, 2016, 'Anonyme. 2016. <em>Liste régionale des espèces potentiellement sensibles pour la diffusion des données. Bourgogne</em>. fichier Excel.', NULL, 161372, 12);
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Happe (2015)', 83, 2015, 'Happe, D. 2015. Liste régionale des espèces potentiellement sensibles pour la diffusion des données. Auvergne.<br>', NULL, 124583, 8);
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Caze & Leblond (2016)', 72, 2016, 'Caze G. & Leblond N. 2016. <em>Liste des especes sensibles de la flore vasculaire en Aquitaine dans le cadre du Systeme d Information sur la Nature et les Paysages (SINP), version 1.0</em>. Conservatoire Botanique National Sud-Atlantique.', NULL, 158568, 10);
INSERT INTO referentiels.especesensiblelistes(short_citation, cd_insee_reg, date_liste, full_citation, url, cd_doc, cd_sl)
    VALUES ('Anonyme (2015)', 24, 2015, 'Anonyme. 2015. Référentiel régional de données sensibles SINP Centre-Val de Loire Volet Occurrence de taxons (validé le 25 juin 2015 en CSRPN). 5 pp.', NULL, 189968, 13);
