  DROP SEQUENCE website.provider_id_seq;
  ALTER TABLE website.providers ADD COLUMN uuid character varying;
  ALTER TABLE website.providers ALTER COLUMN id TYPE character varying;
  ALTER TABLE website.providers ALTER COLUMN id SET DEFAULT NULL;

  INSERT INTO application_parameters (name, value, description) VALUES
    ('INPN_providers_webservice', 'https://odata-inpn.mnhn.fr/solr-ws/organismes/records?', 'INPN Solr webservice to query the providers directory');
  