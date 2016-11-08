SET search_path = metadata;

INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1200, 'CONFORMITY', 'MANDATORY_CONDITIONAL_FIELDS', 'Champs obligatoires conditionnels manquants.', 'Champs obligatoires conditionnels manquants.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1201, 'CONFORMITY', 'ARRAY_OF_SAME_LENGTH', 'Tableaux n''ayant pas le même nombre d''éléments.', 'Tableaux n''ayant pas le même nombre d''éléments.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1202, 'CONFORMITY', 'TAXREF_VERSION', 'Version Taxref manquante.', 'Version Taxref manquante.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1203, 'CONFORMITY', 'BIBLIO_REF', 'Référence bibliographique manquante.', 'Référence bibliographique manquante.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1204, 'CONFORMITY', 'PROOF', 'Incohérence entre les champs de preuve.', 'Incohérence entre les champs de preuve.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1205, 'CONFORMITY', 'NUMERIC_PROOF_URL', 'PreuveNumerique n''est pas une url.', 'PreuveNumerique n''est pas une url.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1206, 'CONFORMITY', 'HABITAT', 'Incohérence entre les champs d''habitat.', 'Incohérence entre les champs d''habitat.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1207, 'CONFORMITY', 'NO_GEOREFERENCE', 'Géoréférencement manquant.', 'Géoréférencement manquant.', 'ERROR');
INSERT INTO checks (check_id, step, name, label, description, importance) VALUES (1208, 'CONFORMITY', 'MORE_THAN_ONE_GEOREFERENCE', 'Plusieurs géoréférencements.', 'Plusieurs géoréférencements.', 'ERROR');
