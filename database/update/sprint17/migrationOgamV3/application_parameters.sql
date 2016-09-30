SET SEARCH_PATH = website;

-- Nouveautés OGAM V3
INSERT INTO application_parameters (name, value, description)
VALUES ('showUploadFileDetail', 0, 'Display on the upload screen the columns for each file (0 for false, 1 for true)');
INSERT INTO application_parameters (name, value, description)
VALUES ('showUploadFileModel', 1, 'Display on the upload screen a link to a sample CSV file (0 for false, 1 for true)');
INSERT INTO application_parameters (name, value, description)
VALUES ('featureinfo_selectmode', 'buffer', 'Method to return closest features : "distance" or "buffer"');

-- Modifs
UPDATE application_parameters
SET value = '0662'
WHERE name = 'image_dir_rights';

-- A virer car plus de MapFish
DELETE FROM application_parameters
WHERE name = 'mapReportGenerationService_url';
-- Obsolète
DELETE FROM application_parameters
WHERE name LIKE 'indices_pdfIndex_%';

-- Modifications du tilecache
DELETE FROM application_parameters
WHERE name = 'proxy_service_name';
insert into application_parameters (name, value, description) values
  ( 'mapserver_private_url' , '@ogam.local.map.services.url@/mapserv.sinp?' , 'The private URL used by mapserverProxy to request a map server.');
-- Pour utiliser le tilecache
-- insert into application_parameters (name, value, description) values
--  ( 'tilecache_private_url' , 'http://localhost/tilecache-ogam?' , 'The private URL used by tilecacheProxy to request a tile cache.');
