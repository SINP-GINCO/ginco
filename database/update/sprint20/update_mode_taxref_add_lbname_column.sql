--Add new column
ALTER TABLE metadata.mode_taxref ADD COLUMN lb_name VARCHAR(500) NULL;
COMMENT ON COLUMN metadata.mode_taxref.lb_name IS 'The scientific name of the taxon (without the authority)';
--Populate
UPDATE metadata.mode_taxref SET lb_name = lb_nom
FROM referentiels.taxref
WHERE code = cd_nom;