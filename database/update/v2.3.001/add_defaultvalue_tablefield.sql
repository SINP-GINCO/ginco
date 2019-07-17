-- Ajout des colonnes de statut
ALTER TABLE metadata.table_field ADD default_value varchar(255);

-- Ajout d'une colonne sur la data indiquant si elle peut posséder une valeur par défaut.
ALTER TABLE metadata.data ADD can_have_default BOOLEAN DEFAULT true ;

UPDATE metadata.DATA SET can_have_default = FALSE 
	WHERE DATA IN ('deedatedernieremodification', 'deedatetransformation', 'orgtransformation', 'sensidateattribution', 'versionrefhabitat', 'versiontaxref') ;

