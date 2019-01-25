ALTER ROLE ogam SET search_path=public, website, metadata, mapping, raw_data;

-- website
GRANT ALL ON SCHEMA website TO ogam WITH GRANT OPTION;
GRANT SELECT ON TABLE website.permission TO ogam;
GRANT SELECT ON TABLE website.application_parameters TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.users TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.role_to_user TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.role_to_schema TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website."role" TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.permission_per_role TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_criterion TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_group_asso TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.predefined_request_column TO ogam;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE website.dataset_role_restriction TO ogam;
GRANT ALL ON ALL SEQUENCES IN SCHEMA website TO ogam;

-- raw-data
GRANT ALL ON SCHEMA raw_data TO ogam;
GRANT ALL ON TABLE raw_data.check_error_check_error_id_seq TO ogam;
GRANT ALL ON TABLE raw_data.submission_id_seq TO ogam;
GRANT SELECT, INSERT ON TABLE raw_data.check_error TO ogam;
GRANT ALL ON TABLE raw_data.submission TO ogam;
GRANT ALL ON TABLE raw_data.submission_file TO ogam;
--GRANT EXECUTE ON FUNCTION raw_data.geomfromcoordinate() TO ogam;
GRANT ALL ON ALL SEQUENCES IN SCHEMA raw_data TO ogam;

-- metadata
GRANT ALL ON SCHEMA metadata TO ogam;
GRANT ALL ON ALL TABLES IN SCHEMA metadata TO ogam;

-- mapping
GRANT ALL ON SCHEMA "mapping" TO ogam;
GRANT SELECT ON TABLE "mapping".provider_map_params TO ogam;
GRANT SELECT ON TABLE "mapping".layer TO ogam;
GRANT SELECT ON TABLE "mapping".layer_service TO ogam;
GRANT SELECT ON TABLE "mapping".layer_tree_node TO ogam;
GRANT ALL ON TABLE "mapping".results TO ogam;
GRANT ALL ON TABLE "mapping".requests TO ogam;
GRANT SELECT ON TABLE "mapping".zoom_level TO ogam;

-- public
GRANT INSERT, DELETE ON TABLE public.geometry_columns TO ogam;

-- referentiels
GRANT ALL ON SCHEMA referentiels TO ogam;
GRANT SELECT ON ALL TABLES IN schema referentiels to ogam;
