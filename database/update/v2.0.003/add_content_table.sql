CREATE TABLE website.content (
  name VARCHAR(50) NOT NULL,
  value TEXT DEFAULT NULL,
  description VARCHAR(500) DEFAULT NULL,
  PRIMARY KEY(name)
);
CREATE UNIQUE INDEX UNIQ_3211DD035E237E06 ON website.content (name);

ALTER TABLE website.content
  OWNER TO admin;
GRANT ALL ON TABLE website.content TO admin;
GRANT ALL ON TABLE website.content TO ogam;
