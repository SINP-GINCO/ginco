SET search_path = metadata;

INSERT INTO checks (check_id, step, name, label, description, statement, importance) VALUES (1200, 'COHERENCE', 'INCOHERENT_FIELDS', 'Champs incohérents.', 'Les champs sont incohérents.', NULL, 'ERROR');

