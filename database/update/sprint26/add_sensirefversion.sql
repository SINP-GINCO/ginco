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

    
    
CREATE OR REPLACE FUNCTION raw_data.sensitive_automatic()
  RETURNS trigger AS
$BODY$

	DECLARE
		rule_codage integer;
		rule_autre character varying(500);
		rule_full_citation character varying(500);
		rule_cd_doc integer;
	BEGIN

	-- As users can update data with the editor, first check that there is realy something to do.
	-- If none of the fields used for sensitivity computation have been modified we leave.
	If (NEW.codedepartementcalcule = OLD.codedepartementcalcule 
		AND NEW.cdnom = OLD.cdnom 
		AND NEW.cdref = OLD.cdref 
		AND NEW.jourdatefin = OLD.jourdatefin 
		AND NEW.occstatutbiologique = OLD.occstatutbiologique) Then
		RETURN NEW;
	End if;

	-- update dEEDateDerniereModification
	-- see #747 for discussion about when to update this date.
	NEW.deedatedernieremodification = now();

	-- We get the referential applied for the data departement
	SELECT especesensiblelistes.full_citation, especesensiblelistes.cd_doc INTO rule_full_citation, rule_cd_doc
	FROM referentiels.especesensible
	LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
	WHERE especesensible.cd_dept = ANY (NEW.codedepartementcalcule)
	LIMIT 1;
	
	-- by default a data is not sensitive
	NEW.sensible = '0';
	NEW.sensiniveau = '0';
	NEW.sensidateattribution = now();
	NEW.sensireferentiel = rule_full_citation;
	NEW.sensiversionreferentiel = rule_cd_doc;
	NEW.sensimanuelle = '0';
	NEW.sensialerte = '0';
		
	-- Does the data deals with sensitive taxon for the departement and is under the sensitive duration ?
	SELECT especesensible.codage, especesensible.autre INTO rule_codage, rule_autre
	FROM referentiels.especesensible
	LEFT JOIN referentiels.especesensiblelistes ON especesensiblelistes.cd_sl = especesensible.cd_sl
	WHERE 
		(CD_NOM = NEW.cdNom
		OR CD_NOM = NEW.cdRef
		OR CD_NOM = ANY (
			WITH RECURSIVE node_list( code, parent_code, lb_name, vernacular_name) AS (
				SELECT code, parent_code, lb_name, vernacular_name
				FROM metadata.mode_taxref
				WHERE code = NEW.cdnom
		
				UNION ALL
		
				SELECT parent.code, parent.parent_code, parent.lb_name, parent.vernacular_name
				FROM node_list, metadata.mode_taxref parent
				WHERE node_list.parent_code = parent.code
				AND node_list.parent_code != '349525'
				)
			SELECT parent_code
			FROM node_list
			ORDER BY code
			)
		)
		AND CD_DEPT = ANY (NEW.codedepartementcalcule)
		AND (DUREE IS NULL OR (NEW.jourdatefin::date + DUREE * '1 year'::INTERVAL > now()))
		AND (NEW.occstatutbiologique IN (NULL, '0', '1', '2') OR cd_occ_statut_biologique IS NULL OR NEW.occstatutbiologique = CAST(cd_occ_statut_biologique AS text))
	
	--  Quand on a plusieurs règles applicables il faut choisir en priorité
	--  Les règles avec le codage le plus fort
	--  Parmis elles, la règle sans commentaire (rule_autre is null)
	--  Voir #579
	ORDER BY codage DESC, autre DESC
	--  on prend la première règle, maintenant qu'elles ont été ordonnées
	LIMIT 1;
		
		
	-- No rules found, the obs is not sensitive
	IF NOT FOUND THEN
		RETURN NEW;
	End if;
		
	-- A rule has been found, the obs is sensitive
	NEW.sensible = '1';
	NEW.sensiniveau = rule_codage;
		
	-- If there is a comment, sensitivity must be defined manually
	If (rule_autre IS NOT NULL) Then
		NEW.sensialerte = '1';
	End if ;
			
	RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_automatic()
  OWNER TO admin;
