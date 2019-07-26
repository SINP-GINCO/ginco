DELETE FROM metadata.checks WHERE check_id IN (1214, 1215) ;

INSERT INTO metadata.checks (check_id, step, name, label, description, importance) VALUES
   (1214, 'CONFORMITY', 'CDHAB_EMPTY', 'cdHab est vide', 'cdHab ne doit pas être vide si nomCite est Inconnu ou Nom perdu', 'ERROR'),
   (1215, 'CONFORMITY', 'PRECISION_TECHNIQUE_EMPTY', 'precisionTechnqiue est vide', 'precisionTechnique ne doit pas être vide si techniqueCollecte = 10', 'ERROR')
;