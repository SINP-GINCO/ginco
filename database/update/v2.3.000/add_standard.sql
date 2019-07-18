CREATE TABLE metadata.standard (
    name TEXT PRIMARY KEY,
    label TEXT,
    version TEXT
);

GRANT ALL ON TABLE metadata.standard TO ogam ;

ALTER TABLE metadata.model ADD COLUMN standard TEXT ;
ALTER TABLE metadata.model ADD CONSTRAINT fk_model_standard FOREIGN KEY (standard) REFERENCES metadata.standard(name) ;

INSERT INTO metadata.standard VALUES(
    'occtax',
    'Standard d''occurrences de taxons',
    'v1.2.1'
);

UPDATE metadata.model SET standard = 'occtax' ;