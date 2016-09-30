UPDATE website.application_parameters
SET value='ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO,communes,mailles,result_maille,result_commune,result_geometrie'
WHERE name='query_details_layers1';

DELETE FROM website.application_parameters
WHERE name='query_details_layers2';