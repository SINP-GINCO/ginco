SET search_path to raw_data;

delete from model_1_observation;

alter table model_1_observation drop column ogam_id_table_observation;
DROP SEQUENCE IF EXISTS model_1_observation_ogam_id_seq;
CREATE SEQUENCE model_1_observation_ogam_id_seq;
ALTER TABLE model_1_observation ADD COLUMN ogam_id_table_observation varchar(255) DEFAULT nextval('model_1_observation_ogam_id_seq') NOT NULL;

SET search_path to mapping;

delete from observation_geometrie;
delete from observation_commune;
delete from observation_maille;
delete from observation_departement;
delete from bac_geometrie;

alter table bac_geometrie drop column id_geometrie;
DROP SEQUENCE IF EXISTS bac_geometrie_id_geometrie_seq;
CREATE SEQUENCE bac_geometrie_id_geometrie_seq;
ALTER TABLE bac_geometrie ADD COLUMN id_geometrie integer DEFAULT nextval('bac_geometrie_id_geometrie_seq') NOT NULL;

alter table observation_geometrie drop column id_observation;
DROP SEQUENCE IF EXISTS observation_geometrie_ogam_id_seq;
CREATE SEQUENCE observation_geometrie_ogam_id_seq;
ALTER TABLE mapping.observation_geometrie ADD COLUMN id_observation varchar(255) DEFAULT nextval('observation_geometrie_ogam_id_seq') NOT NULL;

alter table observation_geometrie drop column id_geom;
DROP SEQUENCE IF EXISTS observation_geometrie_id_geom_seq;
CREATE SEQUENCE observation_geometrie_id_geom_seq;
ALTER TABLE observation_geometrie ADD COLUMN id_geom integer not null DEFAULT nextval('observation_geometrie_id_geom_seq') NOT NULL;

alter table observation_commune drop column id_observation;
DROP SEQUENCE IF EXISTS observation_commune_ogam_id_seq;
CREATE SEQUENCE observation_commune_ogam_id_seq;
ALTER TABLE observation_commune ADD COLUMN id_observation varchar(255) DEFAULT nextval('observation_commune_ogam_id_seq') NOT NULL;

alter table observation_maille drop column id_observation;
DROP SEQUENCE IF EXISTS observation_maille_ogam_id_seq;
CREATE SEQUENCE observation_maille_ogam_id_seq;
ALTER TABLE observation_maille ADD COLUMN id_observation varchar(255) DEFAULT nextval('observation_maille_ogam_id_seq') NOT NULL;

alter table mapping.observation_departement drop column id_observation;
DROP SEQUENCE IF EXISTS observation_departement_ogam_id_seq;
CREATE SEQUENCE observation_departement_ogam_id_seq;
ALTER TABLE observation_departement ADD COLUMN id_observation varchar(255) DEFAULT nextval('observation_departement_ogam_id_seq') NOT NULL;

