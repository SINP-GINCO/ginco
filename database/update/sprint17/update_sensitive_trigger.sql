--some fields mandatory are calculated after the insert and can be considered as mandatory for OGAM.
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='sensible';
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='sensiniveau';
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='deedatetransformation';
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='deedatedernieremodification';
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='sensimanuelle';
UPDATE metadata.table_field SET is_mandatory='0' WHERE data='sensialerte';

UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='sensible';
UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='sensiniveau';
UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='deedatetransformation';
UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='deedatedernieremodification';
UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='sensimanuelle';
UPDATE metadata_work.table_field SET is_mandatory='0' WHERE data='sensialerte';

UPDATE metadata.file_field SET is_mandatory='0' WHERE data='sensible';
UPDATE metadata.file_field SET is_mandatory='0' WHERE data='sensiniveau';
UPDATE metadata.file_field SET is_mandatory='0' WHERE data='deedatetransformation';
UPDATE metadata.file_field SET is_mandatory='0' WHERE data='deedatedernieremodification';
UPDATE metadata.file_field SET is_mandatory='0' WHERE data='sensimanuelle';
UPDATE metadata.file_field SET is_mandatory='0' WHERE data='sensialerte';

UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='sensible';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='sensiniveau';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='deedatetransformation';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='deedatedernieremodification';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='sensimanuelle';
UPDATE metadata_work.file_field SET is_mandatory='0' WHERE data='sensialerte';

--update automatic sensitivity trigger function

CREATE OR REPLACE FUNCTION raw_data.sensitive_automatic()
  RETURNS trigger AS
$BODY$

	DECLARE
		rule referentiels.especesensible%ROWTYPE;
	BEGIN

	-- Automatic sensitivity is calculated after administrative attachement is computed
	-- (by an update on observation table, after the insert, in integration service)
	-- or when one of the params entering into account in the algo changes
	If (NEW.codedepartementcalcule = OLD.codedepartementcalcule AND NEW.cdnom = OLD.cdnom 
		AND NEW.cdref = OLD.cdref AND NEW.jourdatefin = OLD.jourdatefin AND NEW.occstatutbiologique = OLD.occstatutbiologique) Then
		RETURN NEW;
	End if;


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
		AND (DUREE IS NULL OR NEW.jourdatefin::date + DUREE < now())
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
	
	--update dEEDateDerniereModification
	NEW.deedatedernieremodification = now();
		
	RETURN NEW;
	
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_automatic()
  OWNER TO admin;

--update manual sensitivity trigger function

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