-- ---------------------------------------------
-- 1/ add indexes on referentiels.taxref (species are already in the table)
-- 2/ Delete from mode_taxref (in reset or update case), 
-- 3/ populate metadata.mode_taxref
-- 2/ add indexes on metadata.mode_taxref
--
-- REMARQUES:
-- Le fichier en entrée est supposé être en utf-8 => corriger le client-encoding si ce n'est pas le cas
-- ------------------------------------------------------------------------------------------
SET search_path = public, metadata, referentiels;
SET client_encoding = 'UTF-8';


CREATE INDEX taxref_cd_taxsup_idx
  ON referentiels.taxref
  USING btree
  (cd_taxsup COLLATE pg_catalog."default");

CREATE INDEX taxref_cd_nom_idx
  ON referentiels.taxref
  USING btree
  (cd_nom COLLATE pg_catalog."default");
  
CREATE INDEX taxref_cd_ref_idx
  ON referentiels.taxref
  USING btree
  (cd_ref COLLATE pg_catalog."default");


-- Clean table mode_taxref
DELETE FROM mode_taxref;

DROP INDEX IF EXISTS metadata.mode_taxref_complete_name_idx;
DROP INDEX IF EXISTS metadata.mode_taxref_label_idx;
DROP INDEX IF EXISTS metadata.mode_taxref_parent_code_idx;
DROP INDEX IF EXISTS metadata.mode_taxref_vernacular_name_idx;
DROP INDEX IF EXISTS metadata.mode_taxref_code;

--We insert cd_nom and not lb_name in name to see code in TAXREF subtype fields (cdNom and cdRef).

-- cd_taxsup not null
INSERT INTO mode_taxref (unit, code, parent_code, label, lb_name, complete_name, vernacular_name, is_leaf, is_reference)
(SELECT 'TaxRefValue', tx.cd_nom, tx.cd_taxsup, tx.cd_nom, tx.lb_nom, tx.nom_complet, tx.nom_vern, '0', case when (tx.cd_nom = tx.cd_ref) THEN 1 else 0 END
FROM taxref tx
WHERE tx.cd_taxsup IS NOT NULL);

-- cd_taxsup is null, we take the one of the cd_ref.
INSERT INTO mode_taxref (unit, code, parent_code, label, lb_name, complete_name, vernacular_name, is_leaf, is_reference)
(SELECT 'TaxRefValue', tx.cd_nom, rtf.cd_taxsup, tx.cd_nom, tx.lb_nom, tx.nom_complet, tx.nom_vern, '0', case when (tx.cd_nom = tx.cd_ref) THEN 1 else 0 END 
FROM taxref tx
INNER JOIN taxref rtf ON (rtf.cd_nom = tx.cd_ref)
WHERE tx.cd_taxsup IS NULL
AND rtf.cd_taxsup IS NOT NULL
AND tx.cd_nom != rtf.cd_nom);

-- Update is_leaf column
UPDATE mode_taxref SET is_leaf = '1'
WHERE code NOT IN
(SELECT DISTINCT parent_code
FROM mode_taxref
WHERE parent_code IS NOT NULL);

-- Replace '349525' values with '*' to signal a root to PHP code
UPDATE mode_taxref
SET parent_code='*'
WHERE parent_code='349525';


-- Index: metadata.mode_taxref_complete_name_idx

CREATE INDEX mode_taxref_complete_name_idx
  ON metadata.mode_taxref
  USING btree
  (unaccent_immutable(complete_name) COLLATE pg_catalog."default");

-- Index: metadata.mode_taxref_label_idx

CREATE INDEX mode_taxref_label_idx
  ON metadata.mode_taxref
  USING btree
  (unaccent_immutable(label) COLLATE pg_catalog."default");

-- Index: metadata.mode_taxref_parent_code_idx

CREATE INDEX mode_taxref_parent_code_idx
  ON metadata.mode_taxref
  USING btree
  (parent_code COLLATE pg_catalog."default");

-- Index: metadata.mode_taxref_vernacular_name_idx
CREATE INDEX mode_taxref_vernacular_name_idx
  ON metadata.mode_taxref
  USING btree
  (unaccent_immutable(vernacular_name) COLLATE pg_catalog."default");

-- Index: metadata.mode_taxref_code
CREATE UNIQUE INDEX mode_taxref_code
  ON metadata.mode_taxref
  USING btree
  (code COLLATE pg_catalog."default");