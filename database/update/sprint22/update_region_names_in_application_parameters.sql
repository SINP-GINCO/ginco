SET SEARCH_PATH = website;

UPDATE application_parameters SET value='/var/www/@instance.name@/website/upload' WHERE name='UploadDirectory';
UPDATE application_parameters SET value='@ogam.services.host@/SINP@instance.name@IntegrationService/' WHERE name='integrationService_url';
UPDATE application_parameters SET value='/var/www/@instance.name@/website/tmp' WHERE name='uploadDir';
UPDATE application_parameters SET value='@ogam.services.host@/SINP@instance.name@HarmonizationService/' WHERE name='harmonizationService_url';
UPDATE application_parameters SET value='@ogam.services.host@/SINP@instance.name@RGService/' WHERE name='reportGenerationService_url';
UPDATE application_parameters SET value='@ogam.local.map.services.url@/mapserv_@instance.name@.ginco?' WHERE name='mapserver_private_url';