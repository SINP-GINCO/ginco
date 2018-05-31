DELETE FROM website.application_parameters WHERE name='post_max_size';
DELETE FROM website.application_parameters WHERE name='upload_max_filesize';

DELETE FROM website.permission_per_role WHERE permission_code='CHECK_CONF';
DELETE FROM website.permission WHERE permission_code='CHECK_CONF';