DELETE FROM website.application_parameters WHERE name='srs_harmonized_data';
DELETE FROM website.application_parameters WHERE name='featureinfo_typename';

DROP TABLE IF EXISTS mapping.result_location;