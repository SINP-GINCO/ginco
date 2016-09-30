set search_path = referentiels;

-- DROP INDEX referentiels.codemaillevalue_code_10km_idx;

CREATE INDEX codemaillevalue_code_10km_idx
  ON referentiels.codemaillevalue
  USING btree
  (code_10km COLLATE pg_catalog."default");

-- DROP INDEX referentiels.codeenvalue_codeen_idx;

CREATE INDEX codeenvalue_codeen_idx
  ON referentiels.codeenvalue
  USING btree
  (codeen COLLATE pg_catalog."default");

-- DROP INDEX referentiels.habref_20_cd_hab_idx;

CREATE INDEX habref_20_cd_hab_idx
  ON referentiels.habref_20
  USING btree
  (cd_hab COLLATE pg_catalog."default");
