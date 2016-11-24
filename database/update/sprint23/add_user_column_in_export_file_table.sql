ALTER TABLE raw_data.export_file
  ADD COLUMN user_login character varying(50);
ALTER TABLE raw_data.export_file
  ADD CONSTRAINT fk_user_login FOREIGN KEY (user_login) REFERENCES website.users (user_login) ON UPDATE CASCADE ON DELETE SET NULL;