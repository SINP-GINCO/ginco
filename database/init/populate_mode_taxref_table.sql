-- -----------------------------------------------
-- 1/ import in mode_taxref
-- 2/ Update table metadata.mode_taxref
--
-- WARNING:
-- Entry file is supposed to be in UTF-8 encoding
-- => correct client-encoding if it is not the case
-- ------------------------------------------------
SET search_path = public, metadata, referentiels;
SET client_encoding = 'UTF-8';

-- Clean table mode_taxref
DELETE FROM mode_taxref;

--We insert cd_nom and not lb_name in name to see code in TAXREF subtype fields (cdNom and cdRef).

-- cd_taxsup not null
INSERT INTO mode_taxref (unit, code, parent_code, "name", lb_name, complete_name, vernacular_name, is_leaf, is_reference)
(SELECT 'TaxRefValue', tx.cd_nom, tx.cd_taxsup, tx.cd_nom, tx.lb_nom, tx.nom_complet, tx.nom_vern, '0', case when (tx.cd_nom = tx.cd_ref) THEN 1 else 0 END
FROM taxref tx
WHERE tx.cd_taxsup IS NOT NULL);

-- cd_taxsup is null, we take the one of the cd_ref.
INSERT INTO mode_taxref (unit, code, parent_code, "name", lb_name, complete_name, vernacular_name, is_leaf, is_reference)
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
