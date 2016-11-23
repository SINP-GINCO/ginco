SET search_path to mapping, public;
INSERT INTO bac_geometrie(geom) SELECT st_transform(RandomPointsInPolygon(geom, 15), 3857) FROM referentiels.geofla_region WHERE gid='23';