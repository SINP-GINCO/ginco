-- observation_geometrie
CREATE INDEX idx_observation_geometrie_id_observation ON mapping.observation_geometrie(id_observation) ;
CREATE INDEX idx_observation_geometrie_id_geom ON mapping.observation_geometrie(id_geom) ;

-- observation_commune
CREATE INDEX idx_observation_commune_id_observation ON mapping.observation_commune(id_observation) ;
CREATE INDEX idx_observation_commune_id_commune ON mapping.observation_commune(id_commune) ;

-- observation_maille
CREATE INDEX idx_observation_maille_id_observation ON mapping.observation_maille(id_observation) ;
CREATE INDEX idx_observation_maille_id_maille ON mapping.observation_maille(id_maille) ;

-- observation_departement
CREATE INDEX idx_observation_departement_id_observation ON mapping.observation_departement(id_observation) ;
CREATE INDEX idx_observation_departement_id_departement ON mapping.observation_departement(id_departement) ;

