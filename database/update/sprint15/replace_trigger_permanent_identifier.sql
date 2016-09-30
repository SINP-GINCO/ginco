SET SEARCH_PATH = raw_data, public;

CREATE OR REPLACE FUNCTION raw_data.perm_id_generatemodel_1_observation()
  RETURNS trigger AS
$BODY$
				BEGIN
				IF (NEW.identifiantPermanent IS NULL OR NEW.identifiantPermanent = '') THEN
				 NEW.identifiantPermanent  := concat('http://@instance.name@-ginco.ign.fr/occtax/',uuid_generate_v1());
				END IF;
				RETURN NEW;
				END;
				$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.perm_id_generatemodel_1_observation()
  OWNER TO ogam;
