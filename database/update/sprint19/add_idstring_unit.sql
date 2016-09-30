INSERT INTO metadata.unit (unit, type, subtype, label, definition) VALUES ('IDString','STRING','ID','identifiant sous forme de texte','Les recherches d''un motif pour un champ de ce type seront strictes (exactes).');
INSERT INTO metadata_work.unit (unit, type, subtype, label, definition) VALUES ('IDString','STRING','ID','identifiant sous forme de texte','Les recherches d''un motif pour un champ de ce type seront strictes (exactes).');

UPDATE metadata.unit SET label='texte', definition='Lors d''une recherche on regardera l''appartenance du motif recherché aux valeurs du champ.' WHERE unit='CharacterString';
UPDATE metadata_work.unit SET label='texte', definition='Lors d''une recherche on regardera l''appartenance du motif recherché aux valeurs du champ.' WHERE unit='CharacterString';


UPDATE metadata.data SET unit='IDString' WHERE data='OGAM_ID_table_observation';
UPDATE metadata_work.data SET unit='IDString' WHERE data='OGAM_ID_table_observation';
