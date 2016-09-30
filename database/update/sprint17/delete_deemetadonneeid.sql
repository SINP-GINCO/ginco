DROP FUNCTION IF EXISTS raw_data.check_jddmetadonneedeeid_exists(integer);

DELETE FROM metadata.checks WHERE check_id='1';
DELETE FROM metadata_work.checks WHERE check_id='1';

DELETE FROM metadata.checks_per_provider WHERE check_id='1';
DELETE FROM metadata_work.checks_per_provider WHERE check_id='1';