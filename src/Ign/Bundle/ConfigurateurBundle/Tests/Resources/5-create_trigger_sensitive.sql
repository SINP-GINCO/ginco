
DROP TRIGGER IF EXISTS sensitive_automatic ON raw_data.model_1_observation;

DROP FUNCTION IF EXISTS raw_data.sensitive_automatic();

-- First sensitive trigger : in insert case (automatic sensitivity calculation)

CREATE OR REPLACE FUNCTION raw_data.sensitive_automatic()
  RETURNS trigger AS
$BODY$

  DECLARE 
    ref_autre varchar(200);
    ref_cd_occ varchar(200);
    ref_duree integer;
    ref_codage integer;
    res bool;
	
  BEGIN

	-- by default a data is not sensitive
    NEW.sensible = '0';
    NEW.sensiniveau = '0';
    NEW.sensidateattribution = now();
    NEW.sensireferentiel = 'Touroult, J. 2016. SINP. Liste nationale des taxons potentiellement sensibles et des conditions de sensibilité/non sensibilité de la donnée.';
    NEW.sensiversionreferentiel = 'Version 2.';
    NEW.sensimanuelle = 'NON';
	NEW.sensialerte = 'NON';

	-- Does the data deals with sensitive taxon for the departement and is under the sensitive duration ?
    SELECT autre, cd_occ_statut_biologique, duree, codage, 1 as res
    INTO ref_autre, ref_cd_occ, ref_duree, ref_codage, res
    FROM referentiels.especesensible
    WHERE (CD_NOM = NEW.cdNom 
	OR CD_NOM = NEW.cdRef 
	OR CD_NOM = ANY (WITH RECURSIVE node_list( cd_nom, cd_taxsup, lb_nom, nom_vern) AS (
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
			ORDER BY cd_nom))
    AND CD_DEPT = ANY (NEW.codedepartement)
    AND NEW.datefin::date + DUREE < now();


  If res Then
    If ((ref_cd_occ IS NULL AND ref_duree IS NULL) OR (ref_cd_occ IS NOT NULL AND NEW.occstatutbiologique = ref_cd_occ)) Then
        NEW.sensible = '1';
        NEW.sensiniveau = ref_codage;
        NEW.sensidateattribution = now();
        NEW.sensireferentiel = 'Touroult, J. 2016. SINP. Liste nationale des taxons potentiellement sensibles et des conditions de sensibilité/non sensibilité de la donnée.';
        NEW.sensiversionreferentiel = 'Version 2.';
        NEW.sensimanuelle = 'NON';
	NEW.sensialerte = 'NON';
    End if ;

	-- If there is a comment, sensitivity must be defined manually
    If (ref_autre IS NOT NULL) Then
        NEW.sensible = '1';
        NEW.sensiniveau = ref_codage;
        NEW.sensidateattribution = now();
        NEW.sensireferentiel = 'Touroult, J. 2016. SINP. Liste nationale des taxons potentiellement sensibles et des conditions de sensibilité/non sensibilité de la donnée.';
        NEW.sensiversionreferentiel = 'Version 2.';
	NEW.sensimanuelle = 'NON';
	NEW.sensialerte = 'OUI';
    End if ;
  End if;

    RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_automatic()
  OWNER TO admin;




CREATE TRIGGER sensitive_automatic
  BEFORE INSERT
  ON raw_data.model_1_observation
  FOR EACH ROW
  EXECUTE PROCEDURE raw_data.sensitive_automatic();
 
 
 
 
 
  
  
  
DROP TRIGGER IF EXISTS sensitive_manual ON raw_data.model_1_observation;

DROP FUNCTION IF EXISTS raw_data.sensitive_manual();

-- Second sensitive trigger : in update case (manual sensitivity)

CREATE OR REPLACE FUNCTION raw_data.sensitive_manual()
  RETURNS trigger AS
$BODY$	

  BEGIN
    NEW.sensible = '1';
    NEW.sensiDateAttribution = now();
    NEW.sensiManuelle = 'OUI';
	NEW.sensiAlerte = 'NON';
	
  RETURN NEW;
  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.sensitive_manual()
  OWNER TO admin;


CREATE TRIGGER sensitive_manual
  BEFORE UPDATE OF sensiniveau
  ON raw_data.model_1_observation
  FOR EACH ROW
  EXECUTE PROCEDURE raw_data.sensitive_manual();
  
