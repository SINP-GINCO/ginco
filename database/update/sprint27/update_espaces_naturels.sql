SET search_path TO referentiels;

-- Créée une table tampon
CREATE TABLE codeentampon
(
  typeen character varying(36) NOT NULL,
  codeen character varying(36) NOT NULL,
  libelleen character varying(255),
  labeltypeen character varying(255)
)
WITH (
OIDS=FALSE
);
ALTER TABLE codeentampon
  OWNER TO admin;

-- Copier le fichier dans la table tampon
COPY codeentampon ( codeen, libelleen, typeen, labeltypeen) FROM '@sprintDir@/en_inpn.csv' WITH DELIMITER ',' CSV HEADER;

-- Vide puis remplit la table typeenvalue à partir de la table tampon
TRUNCATE typeenvalue;
INSERT INTO typeenvalue (
  SELECT typeen, MIN(labeltypeen) FROM codeentampon GROUP BY typeen ORDER BY typeen
);

-- Vide puis remplit la table codeenvalue à partir de la table tampon
TRUNCATE codeenvalue;
INSERT INTO codeenvalue (
  SELECT typeen, codeen, libelleen FROM codeentampon
);

-- Efface la table tampon
DROP TABLE codeentampon;