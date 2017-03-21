SET search_path TO referentiels;

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