-- --------------------------------------------------
-- COPY v10 FROM referentiels.taxref
-- --------------------------------------------------

--We insert cd_nom and not lb_name in name to see code in TAXREF subtype fields (cdNom and cdRef).

-- cd_taxsup not null
INSERT INTO metadata.mode_taxref (unit, code, parent_code, "name", lb_name, complete_name, vernacular_name, is_leaf, is_reference) 
(SELECT 'TaxRefValue', taxref.cd_nom, taxref.cd_taxsup, taxref.cd_nom, taxref.lb_nom, taxref.nom_complet, taxref.nom_vern, '0', case when (taxref.cd_nom = taxref.cd_ref) then 1 else 0 end 
FROM referentiels.taxref taxref 
WHERE taxref.cd_taxsup is not null);

-- cd_taxsup is null, we take the one of the cd_ref.
INSERT INTO metadata.mode_taxref (unit, code, parent_code, "name", lb_name, complete_name, vernacular_name, is_leaf, is_reference) 
(SELECT 'TaxRefValue', taxref.cd_nom, rtf.cd_taxsup, taxref.cd_nom, taxref.lb_nom, taxref.nom_complet, taxref.nom_vern, '0', case when (taxref.cd_nom = taxref.cd_ref) then 1 else 0 end 
FROM referentiels.taxref taxref 
INNER JOIN referentiels.taxref rtf on (rtf.cd_nom = taxref.cd_ref) 
WHERE taxref.cd_taxsup is null 
AND rtf.cd_taxsup is not null 
AND taxref.cd_nom != rtf.cd_nom);

-- Marquage des feuilles
UPDATE metadata.mode_taxref SET is_leaf = '1' 
WHERE code not in 
(select distinct parent_code 
from metadata.mode_taxref 
where parent_code is not null);

-- Remplacement des valeurs 349525 pour * pour signaler une racine à Zend
UPDATE metadata.mode_taxref 
SET parent_code='*' 
WHERE parent_code='349525';
