CREATE OR REPLACE FUNCTION raw_data.sensitive_automatic()
  RETURNS trigger AS
$BODY$

	DECLARE
		rule referentiels.especesensible%ROWTYPE;
	BEGIN

	-- As users can update data with editor, one checks that there is realy something to do.
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

	-- by default a data is not sensitive
	NEW.sensible = '0';
	NEW.sensiniveau = '0';
	NEW.sensidateattribution = now();
	NEW.sensireferentiel = 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).';
	NEW.sensiversionreferentiel = 'version 0.';
	NEW.sensimanuelle = '0';
	NEW.sensialerte = '0';
		
	-- Does the data deals with sensitive taxon for the departement and is under the sensitive duration ?
	SELECT * INTO rule
	FROM referentiels.especesensible
	WHERE 
		(CD_NOM = NEW.cdNom
		OR CD_NOM = NEW.cdRef
		OR CD_NOM = ANY (
			WITH RECURSIVE node_list( code, parent_code, lb_name, vernacular_name) AS (
				SELECT code, parent_code, lb_name, vernacular_name
				FROM metadata.mode_taxref
				WHERE code = NEW.cdnom
		
				UNION
		
				SELECT parent.code, parent.parent_code, parent.lb_name, parent.vernacular_name
				FROM metadata.mode_taxref parent
				INNER JOIN node_list on node_list.parent_code = parent.code
				WHERE node_list.parent_code != '349525'
				)
			SELECT parent_code
			FROM node_list
			ORDER BY code
			)
		)
		AND CD_DEPT = ANY (NEW.codedepartementcalcule)
		AND (DUREE IS NULL OR (NEW.jourdatefin::date + DUREE * '1 year'::INTERVAL > now()))
		AND (NEW.occstatutbiologique IN (NULL, '0', '1', '2') OR cd_occ_statut_biologique IS NULL OR NEW.occstatutbiologique = CAST(cd_occ_statut_biologique AS text))
	
	--  Quand on a plusieurs règles applicables il faut choisir la règle avec le codage le plus fort
	--  puis prendre en priorité une règle sans commentaire (rule.autre is null)
	ORDER BY codage DESC, autre ASC
	--  enfin, on prend la première.
	LIMIT 1;
		
		
	-- No rules found, the obs is not sensitive
	IF NOT FOUND THEN
		RETURN NEW;
	End if;
		
	-- A rule has been found, the obs is sensitive
	NEW.sensible = '1';
	NEW.sensiniveau = rule.codage;
		
	-- If there is a comment, sensitivity must be defined manually
	If (rule.autre IS NOT NULL) Then
		NEW.sensialerte = '1';
	End if ;
			
	RETURN NEW;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_automatic()
  OWNER TO admin;
