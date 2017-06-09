set search_path = website;

/* Predefined request are created by the configurator when publishing models */
DELETE FROM predefined_request_group_asso;
DELETE FROM predefined_request_group;
DELETE FROM predefined_request_criterion;
DELETE FROM predefined_request_column;
DELETE FROM predefined_request;

GRANT ALL ON SCHEMA "website" TO ogam;
GRANT ALL ON ALL TABLES IN schema website to ogam;