update website.application_parameters set value='1' where name='autoLogin';
update website.application_parameters set value='visiteur' where name='defaultUser';

INSERT INTO website.role(role_code, role_label, role_definition) VALUES ('visiteur','Visiteur', 'Visiteur non loggué');

INSERT INTO website.users(user_login, user_password, user_name, provider_id, active, email) VALUES ('visiteur', '922391a72f5d8792a0b66b6cb3674d5eae454bda', 'visiteur', '1', '1', null);

INSERT INTO website.role_to_user(user_login, role_code) VALUES ('visiteur', 'visiteur');

INSERT INTO website.role_to_schema(ROLE_CODE, SCHEMA_CODE) VALUES ('visiteur', 'RAW_DATA');

INSERT INTO website.permission_per_role(role_code, permission_code) VALUES ('visiteur', 'DATA_QUERY');
INSERT INTO website.permission_per_role(role_code, permission_code) VALUES ('visiteur', 'DATA_QUERY_OTHER_PROVIDER');