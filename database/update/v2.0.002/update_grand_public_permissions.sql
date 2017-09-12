SET search_path TO website;
DELETE FROM permission_per_role WHERE role_code = (SELECT role_code FROM role WHERE role_label = 'Grand public') AND permission_code = 'DATA_QUERY_OTHER_PROVIDER';