INSERT INTO metadata.unit( unit, type, subtype, label,definition) VALUES ('TypeAttributValue','CODE','DYNAMIC','Type de l''attribut additionnel','Type de l''attribut additionnel (quantitatif ou qualitatif)');
INSERT INTO metadata_work.unit( unit, type, subtype, label,definition) VALUES ('TypeAttributValue','CODE','DYNAMIC','Type de l''attribut additionnel','Type de l''attribut additionnel (quantitatif ou qualitatif)');

UPDATE metadata.data SET unit='TypeAttributValue', label='typeAttribut', definition='Indique si l''attribut additionnel est de type quantitatif ou qualitatif.' WHERE data='typeattribut';
UPDATE metadata_work.data SET unit='TypeAttributValue', label='typeAttribut', definition='Indique si l''attribut additionnel est de type quantitatif ou qualitatif.' WHERE data='typeattribut';

INSERT INTO metadata.dynamode(unit, sql) VALUES ('TypeAttributValue','SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.typeattributvalue ORDER BY code');
INSERT INTO metadata_work.dynamode(unit, sql) VALUES ('TypeAttributValue','SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.typeattributvalue ORDER BY code');

UPDATE metadata_work.form_field SET input_type='SELECT' WHERE data='typeattribut';
UPDATE metadata.form_field SET input_type='SELECT' WHERE data='typeattribut';

CREATE TABLE typeattributvalue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.typeattributvalue OWNER TO postgres;

ALTER TABLE ONLY typeattributvalue ADD CONSTRAINT typeattributvalue_pkey PRIMARY KEY (code);

INSERT INTO typeattributvalue VALUES ('QTA','QTA','Le paramètre est de type quantitatif : il peut être mesuré par une valeur numérique.');
INSERT INTO typeattributvalue VALUES ('QUAL','QUAL','Le paramètre est de type qualitatif : Il décrit une qualité qui ne peut être définie par une quantité numérique.');


REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO ogam;