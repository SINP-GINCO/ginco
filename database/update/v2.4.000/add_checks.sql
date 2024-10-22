DELETE FROM metadata.checks WHERE check_id IN (1214, 1215) ;

INSERT INTO metadata.checks (check_id, step, name, label, description, importance) VALUES
   (1214, 'CONFORMITY', 'CDHAB_EMPTY', 'cdHab est vide', 'cdHab ne doit pas être vide si nomCite est Inconnu ou Nom perdu', 'ERROR'),
   (1215, 'CONFORMITY', 'PRECISION_TECHNIQUE_EMPTY', 'precisionTechnqiue est vide', 'precisionTechnique ne doit pas être vide si techniqueCollecte = 10', 'ERROR'),
   (1216, 'CONFORMITY', 'CDHAB_INTERET_COMMUNAUTAIRE_EMPTY', 'cdHabInteretCommunautaire est vide', 'cdHabInteretCommunautaire ne doit pas être vide si habitatInteretCommunautaire est égal à 1 ou 3', 'ERROR'),
   (1217, 'CONFORMITY', 'IDENTIFIANT_PERMANENT_NOT_UNIQUE', 'L''identifiant permanent fourni existe déjà', 'L''identifiant permanent fourni existe déjà', 'ERROR'),
   (1218, 'CONFORMITY', 'CLE_STATION_NOT_FOUND', 'La clé station fournie pour les habitats n''existe pas', 'La clé station fournie pour les habitats n''existe pas', 'ERROR'),
   (1219, 'CONFORMITY', 'HABITAT_INTERET_COMMUNAUTAIRE_EMPTY', 'habitatInteretCommunautaire est vide', 'habitatInteretCommunautaire est vide', 'ERROR')
;