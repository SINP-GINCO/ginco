-- spatial indexes on 'bac' geoms

SET SEARCH_PATH = mapping, public;
CREATE INDEX IX_BAC_GEOMETRIE_SPATIAL_INDEX   ON bac_geometrie   USING GIST ( geom  );
CREATE INDEX IX_BAC_COMMUNE_SPATIAL_INDEX     ON bac_commune     USING GIST ( geom  );
CREATE INDEX IX_BAC_DEPARTEMENT_SPATIAL_INDEX ON bac_departement USING GIST ( geom  );
CREATE INDEX IX_BAC_REGION_SPATIAL_INDEX      ON bac_region      USING GIST ( geom  );
CREATE INDEX IX_BAC_REGION_MAILLE_INDEX       ON bac_maille      USING GIST ( geom  );