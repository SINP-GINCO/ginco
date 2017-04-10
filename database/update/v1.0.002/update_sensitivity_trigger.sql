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
	If (NEW.codedepartementcalcule is not distinct from OLD.codedepartementcalcule 
		AND NEW.cdnom is not distinct from OLD.cdnom 
		AND NEW.cdref is not distinct from OLD.cdref 
		AND NEW.jourdatefin is not distinct from OLD.jourdatefin 
		AND NEW.occstatutbiologique is not distinct from OLD.occstatutbiologique) Then
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
  
  
  
CREATE OR REPLACE FUNCTION raw_data.sensitive_manual()
  RETURNS trigger AS
$BODY$

  BEGIN
	  -- sensitivity is has been changed manually if sensiniveau or sensimanuelle change
	  -- else the modifications do not concern sensitivity
	  IF (NEW.sensiniveau is not distinct from OLD.sensiniveau AND NEW.sensimanuelle is not distinct from OLD.sensimanuelle) Then
			RETURN NEW;
	  END IF;
		NEW.sensidateattribution = now();
		NEW.sensimanuelle = '1';
		NEW.sensialerte = '0';

		--update dEEDateDerniereModification
		NEW.deedatedernieremodification = now();
		
		RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_manual()
  OWNER TO admin;