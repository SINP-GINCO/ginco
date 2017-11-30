  DROP SEQUENCE website.provider_id_seq;
  ALTER TABLE website.providers ADD COLUMN uuid character varying;
  ALTER TABLE website.providers ALTER COLUMN id TYPE character varying;
  ALTER TABLE website.providers ALTER COLUMN id SET DEFAULT NULL;
  