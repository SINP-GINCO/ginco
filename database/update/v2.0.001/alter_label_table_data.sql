ALTER TABLE metadata_work.data
	ALTER COLUMN label TYPE varchar(125);
ALTER TABLE metadata.data
	ALTER COLUMN label TYPE varchar(125);
	
ALTER TABLE metadata_work.table_format
	ALTER COLUMN label TYPE varchar(100);
ALTER TABLE metadata.table_format
	ALTER COLUMN label TYPE varchar(100);
