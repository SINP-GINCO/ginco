-------------------------------------------------------------------------------
-- Init trigger : Initialise update calculated fields
-------------------------------------------------------------------------------
  
DROP FUNCTION IF EXISTS raw_data.init_trigger();
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
  
  
CREATE TRIGGER init_triggermodel_1_observation
  BEFORE INSERT
  ON raw_data.model_1_observation
  FOR EACH ROW
  EXECUTE PROCEDURE raw_data.init_trigger();