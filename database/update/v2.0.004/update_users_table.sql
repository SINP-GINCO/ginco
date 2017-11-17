ALTER TABLE website.users ADD COLUMN created_at timestamp without time zone NOT null default NOW();
ALTER TABLE website.users ADD COLUMN last_login timestamp without time zone NULL;
