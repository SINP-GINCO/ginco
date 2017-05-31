ALTER TABLE website.predefined_request_column DROP CONSTRAINT fk_predefined_request_column_request_name,
ADD CONSTRAINT fk_predefined_request_column_request_id FOREIGN KEY (request_id)
   REFERENCES website.predefined_request (request_id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE website.predefined_request_criterion DROP CONSTRAINT fk_predefined_request_criterion_request_name,
ADD CONSTRAINT fk_predefined_request_criterion_request_id FOREIGN KEY (request_id)
   REFERENCES website.predefined_request (request_id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE website.predefined_request_group_asso DROP CONSTRAINT fk_predefined_request_group_name,
ADD CONSTRAINT fk_predefined_request_group_id FOREIGN KEY (group_id)
   REFERENCES website.predefined_request_group (group_id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;

ALTER TABLE website.predefined_request_group_asso DROP CONSTRAINT fk_predefined_request_request_name,
ADD CONSTRAINT fk_predefined_request_request_id FOREIGN KEY (request_id)
   REFERENCES website.predefined_request (request_id) MATCH SIMPLE ON UPDATE RESTRICT ON DELETE CASCADE;
   
ALTER TABLE website.predefined_request DROP CONSTRAINT fk_predefined_request_dataset;

ALTER TABLE website.predefined_request_criterion ALTER COLUMN value TYPE text;

DELETE FROM website.predefined_request_group WHERE label='Recherches sauvegardées publiques';
DELETE FROM website.predefined_request_group WHERE label='Recherches sauvegardées privées';