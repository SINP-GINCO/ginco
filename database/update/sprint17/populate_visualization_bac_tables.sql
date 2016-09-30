-- In correlation with task #523 (geo administrative attachment) :
-- Populate the vizualisation bacs with the referentiels tables
INSERT INTO mapping.bac_commune SELECT r.insee_com, St_Transform(r.geom, 3857) FROM referentiels.geofla_commune AS r;
INSERT INTO mapping.bac_departement SELECT r.code_dept, St_Transform(r.geom, 3857) FROM referentiels.geofla_departement AS r;
INSERT INTO mapping.bac_maille SELECT r.code_10km, St_Transform(r.geom, 3857) FROM referentiels.codemaillevalue AS r;
INSERT INTO mapping.bac_region SELECT r.code_reg, St_Transform(r.geom, 3857) FROM referentiels.geofla_region AS r;