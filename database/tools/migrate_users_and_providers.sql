--
-- Utility scripts for managing Ginco databases
--


---------------------------------------------------
-- Migrate providers and users

CREATE TABLE website.temp_providers (
  old_id character varying NOT NULL,
  new_id character varying NOT NULL
);

INSERT INTO website.temp_providers (old_id, new_id) VALUES
  ('10','737'),
  ('11','735'),
  ('12','216'),
  ('13','738'),
  ('14','734'),
  ('15','172'),
  ('16','234'),
  ('17','736'),
  ('18','739'),
  ('19','740'),
  ('20','216'),
  ('3','415'),
  ('5','741'),
  ('6','394'),
  ('7','517'),
  ('8','46'),
  ('9','742')
;

UPDATE jdd SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;
UPDATE submission SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;
-- là toutes les tables de données...
UPDATE model_592e825dab701_observation SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;

-- Update providers in mapping.observation_xxx tables
UPDATE observation_commune SET id_provider = tp.new_id FROM website.temp_providers tp WHERE id_provider = tp.old_id;
UPDATE observation_departement SET id_provider = tp.new_id FROM website.temp_providers tp WHERE id_provider = tp.old_id;
UPDATE observation_geometrie SET id_provider = tp.new_id FROM website.temp_providers tp WHERE id_provider = tp.old_id;
UPDATE observation_maille SET id_provider = tp.new_id FROM website.temp_providers tp WHERE id_provider = tp.old_id;

DROP TABLE website.temp_providers;

-- Users

CREATE TABLE website.temp_users (
  old_login character varying NOT NULL,
  new_login character varying NOT NULL
);

INSERT INTO website.temp_users (old_login, new_login) VALUES
  ('developpeur','mathieu.willmes'),
  ('mwillmes','mathieu.willmes')
;

UPDATE dee SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;
UPDATE jdd SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;
UPDATE submission SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;
UPDATE predefined_request SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;

DROP TABLE website.temp_users;
