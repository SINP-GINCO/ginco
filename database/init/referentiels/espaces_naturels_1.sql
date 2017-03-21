SET search_path TO referentiels;

-- Créée les tables du référentiel

CREATE TABLE TypeENValue (
  code character varying(32),
  label character varying(128),
  definition character varying(510)
);

ALTER TABLE TypeENValue OWNER TO postgres;

CREATE TABLE codeenvalue
(
  typeen character varying(36) NOT NULL,
  codeen character varying(36) NOT NULL,
  libelleen character varying(255),
  CONSTRAINT "PK_typeen_codeen" PRIMARY KEY (typeen, codeen)
)
WITH (
OIDS=FALSE
);
ALTER TABLE codeenvalue
  OWNER TO postgres;


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