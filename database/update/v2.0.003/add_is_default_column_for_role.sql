ALTER TABLE website.role ADD COLUMN is_default BOOLEAN DEFAULT FALSE NOT NULL;
UPDATE website.role SET is_default = true WHERE role_label = 'Producteur';