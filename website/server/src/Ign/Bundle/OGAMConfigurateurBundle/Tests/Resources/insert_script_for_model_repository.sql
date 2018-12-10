-- This script is used for model repository test.

SET search_path = metadata_work;

INSERT INTO model (id, name, description, schema_code) VALUES ('2', 'albatros', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('3', 'zebre', 'model_to_delete', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('4', 'brebis', 'model', 'RAW_DATA');
INSERT INTO model (id, name, description, schema_code) VALUES ('5', 'Corbeaux', 'model', 'RAW_DATA');