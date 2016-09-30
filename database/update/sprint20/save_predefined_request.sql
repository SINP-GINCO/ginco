INSERT INTO website.predefined_request_group(group_name, label, definition, position) VALUES ('saved_requests', 'recherches sauvegardées', 'recherches sauvegardées', 1);

ALTER TABLE website.predefined_request ALTER date SET DEFAULT now();

