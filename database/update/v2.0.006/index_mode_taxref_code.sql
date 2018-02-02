-- Index: metadata.mode_taxref_code
CREATE UNIQUE INDEX mode_taxref_code
  ON metadata.mode_taxref
  USING btree
  (code COLLATE pg_catalog."default");