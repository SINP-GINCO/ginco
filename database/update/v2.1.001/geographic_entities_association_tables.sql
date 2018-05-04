-- Association table beetween bac_maille and bac_departement

CREATE TABLE mapping.maille_departement
(
  id_maille character varying(20) NOT NULL, -- The id of the maille
  id_departement character varying(3) NOT NULL, -- The INSEE code id of the departement
  CONSTRAINT maille_departement_pkey PRIMARY KEY (id_maille, id_departement),
  CONSTRAINT fk_maille_departement_bac_maille FOREIGN KEY (id_maille)
      REFERENCES mapping.bac_maille (id_maille) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_maille_departement_bac_departement FOREIGN KEY (id_departement)
      REFERENCES mapping.bac_departement (id_departement) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED
)
WITH (
  OIDS=FALSE
);
ALTER TABLE mapping.maille_departement
  OWNER TO admin;
GRANT ALL ON TABLE mapping.maille_departement TO admin;
GRANT ALL ON TABLE mapping.maille_departement TO ogam;


-- Association table beetween bac_commune and bac_maille

CREATE TABLE mapping.commune_maille
(
  id_commune character varying(5) NOT NULL, -- The INSEE code id of the commune
  id_maille character varying(20) NOT NULL, -- The id of the maille
  CONSTRAINT commune_maille_pkey PRIMARY KEY (id_commune, id_maille),
  CONSTRAINT fk_commune_maille_bac_commmune FOREIGN KEY (id_commune)
      REFERENCES mapping.bac_commune (id_commune) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT fk_commune_maille_bac_maille FOREIGN KEY (id_maille)
      REFERENCES mapping.bac_maille(id_maille) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT DEFERRABLE INITIALLY DEFERRED
)
WITH (
  OIDS=FALSE
);
ALTER TABLE mapping.commune_maille
  OWNER TO admin;
GRANT ALL ON TABLE mapping.commune_maille TO admin;
GRANT ALL ON TABLE mapping.commune_maille TO ogam;


-- Populate maille_departement table
INSERT INTO mapping.maille_departement
SELECT id_maille, id_departement
FROM mapping.bac_maille, mapping.bac_departement
WHERE st_intersects(bac_maille.geom, bac_departement.geom);


-- Populate commune_maille table
INSERT INTO mapping.commune_maille
SELECT id_commune, id_maille
FROM mapping.bac_commune, mapping.bac_maille
WHERE st_intersects(bac_commune.geom, bac_maille.geom);


-- Add column for id_departement in bac_commune
ALTER table mapping.bac_commune
ADD column id_departement character varying(3);

-- Populate bac_commune.id_departement
UPDATE mapping.bac_commune SET id_departement=
(SELECT insee_dep FROM referentiels.commune_carto_2017 WHERE id_commune = insee_com);

-- Update event listener
DELETE FROM metadata.event_listener WHERE listener_id='GincoComputeGeoAssociationService';
INSERT INTO metadata.event_listener(listener_id, classname, _creationdt) VALUES ('GeoAssociationService', 'fr.ifn.ogam.integration.business.GeoAssociationService', now());


