ALTER TABLE website.predefined_request_group RENAME TO predefined_request_group_old;

CREATE TABLE website.predefined_request_group
(
  group_id serial NOT NULL, -- The group identifier
  label character varying(128) NOT NULL, -- The label of the group
  definition character varying(1024), -- The definition of the group
  "position" smallint, -- The position of the group
  CONSTRAINT pk_predefined_request_group PRIMARY KEY (group_id)
);

COMMENT ON COLUMN website.predefined_request_group.group_id IS 'The group identifier';
COMMENT ON COLUMN website.predefined_request_group.label IS 'The label of the group';
COMMENT ON COLUMN website.predefined_request_group.definition IS 'The definition of the group';
COMMENT ON COLUMN website.predefined_request_group."position" IS 'The position of the group';

INSERT INTO website.predefined_request_group(name, label, definition, position)
  SELECT name, label, definition, position FROM website.predefined_request_group_old;
  
DROP TABLE website.predefined_request_group_old;