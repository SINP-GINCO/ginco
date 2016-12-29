

DROP TABLE IF EXISTS model_1_observation CASCADE;

/*==============================================================*/
/* Table : model_1_observation  */
/*==============================================================*/
CREATE TABLE raw_data.model_1_observation
(
  occmethodedetermination character varying(255),
  identifiantregroupementpermanent character varying(255),
  profondeurmin double precision,
  versionrefmaille character varying(255),
  altitudemin double precision,
  determinateuridentite character varying(255),
  jddcode character varying(255),
  validateurnomorganisme character varying(255),
  organismegestionnairedonnee character varying(255) NOT NULL,
  provider_id character varying(255) NOT NULL,
  codecommune character varying(255)[],
  refhabitat character varying(255)[],
  anneerefcommune date,
  occstatutbiogeographique character varying(255),
  statutobservation character varying(255) NOT NULL,
  versionrefhabitat character varying(255),
  objetdenombrement character varying(255),
  datefin timestamp with time zone NOT NULL,
  natureobjetgeo character varying(255),
  jddmetadonneedeeid character varying(255) NOT NULL,
  denombrementmax bigint,
  obsdescription character varying(255),
  occstadedevie character varying(255),
  typeinfogeocommune character varying(255),
  preuvenumerique character varying(255),
  typeen character varying(255)[],
  sensireferentiel character varying(255),
  typeinfogeome character varying(255),
  jddid character varying(255),
  cdref character varying(255),
  obsmethode character varying(255),
  denombrementmin bigint,
  codemaille character varying(255)[],
  codeidcnpdispositif character varying(255),
  submission_id bigint,
  typeinfogeodepartement character varying(255),
  versionme character varying(255),
  observateurnomorganisme character varying(255),
  determinateurmail character varying(255),
  deedatedernieremodification timestamp with time zone NOT NULL,
  diffusionniveauprecision character varying(255),
  cdnom character varying(255),
  typeinfogeomaille character varying(255),
  sensible character varying(255) NOT NULL,
  occsexe character varying(255),
  commentaire character varying(255),
  organismestandard character varying(255),
  observateurmail character varying(255),
  typedenombrement character varying(255),
  profondeurmax double precision,
  preuvenonnumerique character varying(255),
  profondeurmoyenne double precision,
  validateurmail character varying(255),
  sensiversionreferentiel character varying(255),
  altitudemax double precision,
  codedepartement character varying(255)[],
  dateme date,
  identifiantorigine character varying(255),
  nomrefmaille character varying(255),
  validateuridentite character varying(255),
  versiontaxref character varying(255),
  occnaturalite character varying(255),
  ogam_id_table_observation character varying(255) NOT NULL,
  anneerefdepartement date,
  occstatutbiologique character varying(255),
  codeme character varying(255),
  altitudemoyenne double precision,
  precisiongeometrie bigint,
  determinateurnomorganisme character varying(255),
  typeregroupement character varying(255),
  deefloutage character varying(255),
  referencebiblio character varying(255),
  datedetermination timestamp with time zone,
  observateuridentite character varying(255),
  datedebut timestamp with time zone NOT NULL,
  sensiniveau character varying(255) NOT NULL,
  statutsource character varying(255) NOT NULL,
  orgtransformation character varying(255) NOT NULL,
  nomcommune character varying(255)[],
  occetatbiologique character varying(255),
  identifiantpermanent character varying(255) NOT NULL,
  preuveexistante character varying(255),
  nomcite character varying(255) NOT NULL,
  sensidateattribution timestamp with time zone,
  jddsourceid character varying(255),
  typeinfogeoen character varying(255),
  dspublique character varying(255) NOT NULL,
  obscontexte character varying(255),
  versionen date,
  methoderegroupement character varying(255),
  codehabitat character varying(255)[],
  codeen character varying(255)[],
  codehabref character varying(255)[],
  sensimanuelle character varying(255) NOT NULL,
  sensialerte character varying(255) NOT NULL,
  CONSTRAINT model_1_observation_pkey1 PRIMARY KEY (ogam_id_table_observation, provider_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE raw_data.model_1_observation
  OWNER TO ogam;
  
  -- Ajout de la colonne point PostGIS
SELECT AddGeometryColumn('raw_data','model_1_observation','geometrie', 4326,'GEOMETRY',2);

-- Index: raw_data.ixmodel_1_observation_geometrie_spatial_index

-- DROP INDEX raw_data.ixmodel_1_observation_geometrie_spatial_index;

CREATE INDEX ixmodel_1_observation_geometrie_spatial_index
  ON raw_data.model_1_observation
  USING gist
  (geometrie);


-- DROP FUNCTION raw_data.pkgeneratemodel_1_observation();

CREATE OR REPLACE FUNCTION raw_data.pkgeneratemodel_1_observation()
  RETURNS trigger AS
$BODY$
				BEGIN
				IF (NEW.OGAM_ID_table_observation IS NULL) THEN
				 NEW.OGAM_ID_table_observation  := uuid_generate_v1();
				END IF;
				RETURN NEW;
				END;
				$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.pkgeneratemodel_1_observation()
  OWNER TO ogam;
  
  
-- Function: raw_data.perm_id_generatemodel_1_observation()

-- DROP FUNCTION raw_data.perm_id_generatemodel_1_observation();

CREATE OR REPLACE FUNCTION raw_data.perm_id_generatemodel_1_observation()
  RETURNS trigger AS
$BODY$
				BEGIN
				IF (NEW.identifiantPermanent IS NULL OR NEW.identifiantPermanent = '') THEN
				 NEW.identifiantPermanent  := concat('http://localhost.ogam-sinp.ign.fr/occtax/',uuid_generate_v1());
				END IF;
				RETURN NEW;
				END;
				$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION raw_data.perm_id_generatemodel_1_observation()
  OWNER TO ogam;

  
  

-- Trigger: perm_id_generatemodel_1_observation on raw_data.model_1_observation

-- DROP TRIGGER perm_id_generatemodel_1_observation ON raw_data.model_1_observation;

CREATE TRIGGER perm_id_generatemodel_1_observation
  BEFORE INSERT
  ON raw_data.model_1_observation
  FOR EACH ROW
  EXECUTE PROCEDURE raw_data.perm_id_generatemodel_1_observation();

-- Trigger: pkgeneratemodel_1_observation on raw_data.model_1_observation

-- DROP TRIGGER pkgeneratemodel_1_observation ON raw_data.model_1_observation;

CREATE TRIGGER pkgeneratemodel_1_observation
  BEFORE INSERT
  ON raw_data.model_1_observation
  FOR EACH ROW
  EXECUTE PROCEDURE raw_data.pkgeneratemodel_1_observation();


GRANT ALL ON TABLE raw_data.model_1_observation TO ogam;
