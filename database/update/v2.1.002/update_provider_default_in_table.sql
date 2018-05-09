UPDATE website.users SET provider_id = '0'
WHERE provider_id = '1';

UPDATE raw_data.check_error SET provider_id = '0'
WHERE provider_id = '1';

UPDATE raw_data.jdd SET provider_id = '0'
WHERE provider_id = '1';

UPDATE raw_data.model_1_observation SET provider_id = '0'
WHERE provider_id = '1';

UPDATE raw_data.submission SET provider_id = '0'
WHERE provider_id = '1';

UPDATE mapping.layer SET provider_id = '0'
WHERE provider_id = '1';

UPDATE mapping.provider_map_params SET provider_id = '0'
WHERE provider_id = '1';
UPDATE metadata.checks_per_provider SET provider_id = '0'
WHERE provider_id = '1';

UPDATE metadata_work.checks_per_provider SET provider_id = '0'
WHERE provider_id = '1';

DELETE FROM website.providers WHERE id= '1';