set search_path = referentiels;

-- DROP INDEX referentiels.codeenvalue_codeen_idx;
-- There is still an index btree(typeen, codeen), as it is the primary key, but, "a two-column index does not support searching on the second column alone",
-- so we add one on codeen only.
CREATE INDEX codeenvalue_codeen_idx
  ON referentiels.codeenvalue
  USING btree
  (codeen COLLATE pg_catalog."default");

-- DROP INDEX referentiels.habref_20_cd_hab_idx;

CREATE INDEX habref_20_cd_hab_idx
  ON referentiels.habref_20
  USING btree
  (cd_hab COLLATE pg_catalog."default");
