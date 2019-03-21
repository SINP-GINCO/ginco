-- Ajout des colonnes de statut
ALTER TABLE metadata.model ADD status varchar(12);
ALTER TABLE metadata.model ADD created_at TIMESTAMP;
ALTER TABLE metadata.dataset ADD status VARCHAR(12);

UPDATE metadata.model SET status = 'published', created_at = now() ;
UPDATE metadata.dataset SET status = 'published' WHERE "type" = 'IMPORT' ;

-- Création d'un lien entre table_tree et table_format
ALTER TABLE metadata.table_tree ALTER COLUMN parent_table DROP NOT NULL;
UPDATE metadata.table_tree SET parent_table = NULL WHERE parent_table = '*';
ALTER TABLE metadata.table_tree ADD CONSTRAINT fk_table_tree_parent_table FOREIGN KEY (parent_table) REFERENCES table_format(format) ;