-- This script is used for jdd controller test.

INSERT INTO metadata.model (id, name, description, schema_code) VALUES ('2', 'my_model', 'model', 'RAW_DATA');

INSERT INTO website.providers (id, label) VALUES ('1', 'ogam_jdd');
INSERT INTO website.users (user_login, provider_id, email) VALUES ('ogam_user', '1', 'email');
INSERT INTO website.application_parameters (name, value) VALUES ('site_url', 'http://localhost');

INSERT INTO raw_data.jdd (id, status, provider_id, user_login, model_id) VALUES (1, 'empty', '1', 'ogam_user', '2');