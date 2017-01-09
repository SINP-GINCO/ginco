DELETE FROM metadata.checks WHERE check_id=1209;
DELETE FROM metadata_work.checks WHERE check_id=1209;

INSERT INTO metadata.checks(check_id, step, name, label, description, statement, importance) VALUES (1209, 'CONFORMITY', 'DATE_ORDER', 'Incohérence sur la chronologie des dates.', 'Incohérence sur la chronologie des dates.', null, 'ERROR');
INSERT INTO metadata_work.checks(check_id, step, name, label, description, statement, importance) VALUES (1209, 'CONFORMITY', 'DATE_ORDER', 'Incohérence sur la chronologie des dates.', 'Incohérence sur la chronologie des dates.', null, 'ERROR');