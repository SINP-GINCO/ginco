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
  ('239','16'),
  ('82','39')
;

UPDATE jdd SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;
UPDATE submission SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;
-- là toutes les tables de données...
UPDATE model_1_observation SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;
UPDATE model_5943a4de78942_observation SET provider_id = tp.new_id FROM website.temp_providers tp WHERE provider_id = tp.old_id;


DROP TABLE website.temp_providers;

--

CREATE TABLE website.temp_users (
  old_login character varying NOT NULL,
  new_login character varying NOT NULL
);

INSERT INTO website.temp_users (old_login, new_login) VALUES
  ('developpeur','scandel2')
;

UPDATE dee SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;
UPDATE jdd SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;
UPDATE submission SET user_login = tp.new_login FROM website.temp_users tp WHERE user_login = tp.old_login;

DROP TABLE website.temp_users;
