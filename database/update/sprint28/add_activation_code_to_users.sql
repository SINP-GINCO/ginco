ALTER TABLE website.users ADD column activation_code VARCHAR(50);
COMMENT ON COLUMN USERS.ACTIVATION_CODE IS 'The activation code for password reset';