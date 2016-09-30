-- ---------------------------------------------  
-- 1/ import dans taxref
-- 2/ mise à jour de la table metadata.mode_taxref
--
-- REMARQUES:
-- Le fichier en entrée est supposé être en Latin-1 => corriger le client-encoding si ce n'est pas le cas
-- ------------------------------------------------------------------------------------------
SET search_path TO public, metadata;
SET client_encoding = 'UTF-8';

-- Suppression des données de la table mode_taxref
DELETE FROM metadata.mode_taxref;
--
-- Recopie de la table referentiels.taxref vers la table metadata.mode_taxref 
--
--We insert cd_nom and not lb_name in name to see code in TAXREF subtype fields (cdNom and cdRef). 
--SELECT 'TaxRefValue', cd_nom,  cd_taxsup, lb_nom, nom_complet, nom_vern, '0', case when (cd_nom = cd_ref) then 1 else 0 end
INSERT INTO metadata.mode_taxref (unit, code, parent_code, "name", lb_name, complete_name, vernacular_name, is_leaf, is_reference)
SELECT 'TaxRefValue', cd_nom, cd_taxsup, cd_nom, nom_complet, lb_nom, nom_vern, '0', case when (cd_nom = cd_ref) then 1 else 0 end
FROM referentiels.taxref;

-- Marquage des feuilles
update metadata.mode_taxref set is_leaf = '1' where code not in (select distinct parent_code from metadata.mode_taxref where parent_code is not null);

-- Remplacement des valeurs 349525 pour * pour signaler une racine à Zend

UPDATE metadata.mode_taxref
SET parent_code='*'
WHERE parent_code='349525';

