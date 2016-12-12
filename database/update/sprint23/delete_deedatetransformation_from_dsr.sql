DELETE FROM metadata_work.field_mapping WHERE src_data = 'deedatetransformation';
DELETE FROM metadata_work.file_field WHERE data = 'deedatetransformation';
DELETE FROM metadata_work.table_field WHERE data = 'deedatetransformation';
DELETE FROM metadata_work.form_field WHERE data = 'deedatetransformation';
DELETE FROM metadata_work.dataset_fields WHERE data = 'deedatetransformation';
DELETE FROM metadata_work.field WHERE data = 'deedatetransformation';

DELETE FROM metadata.field_mapping WHERE src_data = 'deedatetransformation';
DELETE FROM metadata.file_field WHERE data = 'deedatetransformation';
DELETE FROM metadata.table_field WHERE data = 'deedatetransformation';
DELETE FROM metadata.form_field WHERE data = 'deedatetransformation';
DELETE FROM metadata.dataset_fields WHERE data = 'deedatetransformation';
DELETE FROM metadata.field WHERE data = 'deedatetransformation';

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
			WITH RECURSIVE node_list( cd_nom, cd_taxsup, lb_nom, nom_vern) AS (
				SELECT cd_nom, cd_taxsup, lb_nom, nom_vern
				FROM referentiels.taxref
				WHERE cd_nom = NEW.cdnom
		
				UNION
		
				SELECT parent.cd_nom, parent.cd_taxsup, parent.lb_nom, parent.nom_vern
				FROM referentiels.taxref parent
				INNER JOIN node_list on node_list.cd_taxsup = parent.cd_nom
				WHERE node_list.cd_taxsup != '349525'
				)
			SELECT cd_taxsup
			FROM node_list
			ORDER BY cd_nom
			)
		)
		AND CD_DEPT = ANY (NEW.codedepartementcalcule)
		AND (DUREE IS NULL OR NEW.jourdatefin::date + DUREE > now())
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
  
  
CREATE OR REPLACE FUNCTION raw_data.sensitive_manual()
  RETURNS trigger AS
$BODY$

  BEGIN
	  
	  -- sensitivity is has been changed manually if sensiniveau or sensimanuelle change
	  -- else the modifications do not concern sensitivity
	  IF (NEW.sensiniveau = OLD.sensiniveau AND NEW.sensimanuelle = OLD.sensimanuelle) Then
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
  
  
  CREATE OR REPLACE FUNCTION raw_data.init_trigger()
  RETURNS trigger AS
$BODY$

  BEGIN
	  	NEW.sensible = '0';
		NEW.sensiniveau = '0';
		NEW.deedatedernieremodification = now();
			
		RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.init_trigger()
  OWNER TO admin;