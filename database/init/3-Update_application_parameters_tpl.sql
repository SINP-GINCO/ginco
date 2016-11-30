SET SEARCH_PATH = website;

DELETE FROM application_parameters;

-- TEST DATABASE Parameters
INSERT INTO application_parameters (name, value, description) values ('UploadDirectory','/var/data/ginco/@instance.name@/upload','Directory where the CSV files are uploaded');
INSERT INTO application_parameters (name, value, description) values ('Test','OK','For test purposes');
INSERT INTO application_parameters (name, value, description) values ('fromMail','sinp@ign.fr','The application email');
INSERT INTO application_parameters (name, value, description) values ('toMail','@contact.mail@','The destination email');

insert into application_parameters (name, value, description) values ( 'autoLogin' , 1 , 'DEFAULT LOGIN AND PAGE FOR PUBLIC ACCESS');
insert into application_parameters (name, value, description) values ( 'defaultUser' , 'visiteur' , 'DEFAULT LOGIN AND PAGE FOR PUBLIC ACCESS');
insert into application_parameters (name, value, description) values ( 'fileMaxSize' , 150 , 'UPLOAD');
insert into application_parameters (name, value, description) values ( 'integrationService_url' , '@ogam.services.host@/SINP@instance.name@IntegrationService/' , 'INTEGRATION SERVICE');
insert into application_parameters (name, value, description) values ( 'uploadDir' , '/var/data/ginco/@instance.name@/tmp' , 'INTEGRATION SERVICE');
insert into application_parameters (name, value, description) values ( 'harmonizationService_url' , '@ogam.services.host@/SINP@instance.name@HarmonizationService/' , 'HARMONIZATION SERVICE');
insert into application_parameters (name, value, description) values ( 'reportGenerationService_url' , '@ogam.services.host@/SINP@instance.name@RGService/' , 'REPORT GENERATION SERVICE');
insert into application_parameters (name, value, description) values ( 'errorReport' , 'ErrorReport.rptdesign' , 'REPORT GENERATION SERVICE');
insert into application_parameters (name, value, description) values ( 'plotErrorReport' , 'PlotErrorReport.rptdesign' , 'REPORT GENERATION SERVICE');
insert into application_parameters (name, value, description) values ( 'simplifiedReport' , 'SimplifiedReport.rptdesign' , 'REPORT GENERATION SERVICE');
insert into application_parameters (name, value, description) values ( 'max_report_generation_time' , 480 , 'REPORT GENERATION SERVICE');
insert into application_parameters (name, value, description) values ( 'useCache' , true , 'Cache');
insert into application_parameters (name, value, description) values ( 'max_execution_time' , 480 , 'Timeout , 0 : no limit');
insert into application_parameters (name, value, description) values ( 'memory_limit' , '1024M' , 'memory limit');
insert into application_parameters (name, value, description) values ( 'post_max_size' , '100M' , 'Note : "post_max_size" and "upload_max_filesize" are under the PHP_INI_PERDIR mode (php.ini, .htaccess or httpd.conf).The parameter must be set into the php.ini file because it s not possible in the other files when php is running under the CGI mode. So we can only check if it s done.');
insert into application_parameters (name, value, description) values ( 'upload_max_filesize' , '150M' , 'Note : "post_max_size" and "upload_max_filesize" are under the PHP_INI_PERDIR mode (php.ini, .htaccess or httpd.conf).The parameter must be set into the php.ini file because it s not possible in the other files when php is running under the CGI mode. So we can only check if it s done.');
insert into application_parameters (name, value, description) values ( 'image_upload_dir' , 'APPLICATION_PATH "/../../upload/images' , 'File Upload');
insert into application_parameters (name, value, description) VALUES ('image_dir_rights', '0662', 'File Upload');
insert into application_parameters (name, value, description) values ( 'image_extensions' , 'jpg,png,jpeg' , 'File Upload');
insert into application_parameters (name, value, description) values ( 'image_max_size' , 10000, 'image max size in bytes');
insert into application_parameters (name, value, description) values ( 'tilesize' , 256 , 'WEB MAPPING ');
-- #802 : desactivate card details map
--insert into application_parameters (name, value, description) values ( 'query_details_layers1' , 'ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO,communes,mailles,result_maille,result_commune,result_geometrie' , 'WEB MAPPING '); --,nuts_0
insert into application_parameters (name, value, description) values ( 'srs_visualisation' , 3857 , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'srs_raw_data' , 4326 , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'srs_harmonized_data' , 4326 , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'usePerProviderCenter' , 1 , 'if true the system will look in the "bounding_box" table for centering info for each provider');
insert into application_parameters (name, value, description) values ( 'bbox_x_min' , '-20037508' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'bbox_y_min' , '-20037508.342789244' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'bbox_x_max' , '20037508.342789244' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'bbox_y_max' , '20037508' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'zoom_level' , '0' , 'WEB MAPPING ');
insert into application_parameters (name, value, description) values ( 'mapserver_dpi' , 72 , 'Default number of dots per inch in mapserv');
insert into application_parameters (name, value, description) values ( 'mapserver_inch_per_kilometer' , 39370.1 , 'Inch to meter conversion factor');
insert into application_parameters (name, value, description) values ( 'featureinfo_margin' , 1000 , 'bounding box margin around the user click (in the unit of the map)');
insert into application_parameters (name, value, description) values ( 'featureinfo_typename' , 'result_locations' , 'Layer that is queried');
insert into application_parameters (name, value, description) values ( 'featureinfo_maxfeatures' , 20 , 'Max number of features returned by a click on the map. If 0 then there is no limit; If 1 the direct access to the detail');
insert into application_parameters (name, value, description) values ( 'contactEmailPrefix' , 'sinp' , 'Email');
insert into application_parameters (name, value, description) values ( 'contactEmailSufix' , 'ign.fr' , 'Email');
insert into application_parameters (name, value, description) values ( 'csvExportCharset' , 'UTF-8' , 'Csv Export');
insert into application_parameters (name, value, description) values ( 'language_flags1' , 'fr' , 'Language');
insert into application_parameters (name, value, description) values ( 'language_flags2' , 'en' , 'Language');
insert into application_parameters (name, value, description) values ( 'documentationUrl', 'http://ginco.ign.fr/doc', 'URL de base pour le site de documentation');
INSERT INTO application_parameters (name, value, description) VALUES ('showUploadFileDetail', 0, 'Display on the upload screen the columns for each file (0 for false, 1 for true)');
INSERT INTO application_parameters (name, value, description) VALUES ('showUploadFileModel', 1, 'Display on the upload screen a link to a sample CSV file (0 for false, 1 for true)');
INSERT INTO application_parameters (name, value, description) VALUES ('featureinfo_selectmode', 'buffer', 'Method to return closest features : "distance" or "buffer"');
insert into application_parameters (name, value, description) values ( 'mapserver_private_url' , '@ogam.local.map.services.url@/mapserv_@instance.name@.ginco?' , 'The private URL used by mapserverProxy to request a map server.');
insert into application_parameters (name, value, description) values ( 'hiding_value' , 'Masqué' , 'The value to display when a field value should not be displayed');
INSERT INTO application_parameters (name, value, description) VALUES ( 'site_name', '@site.name@', 'Name of the website');
INSERT INTO application_parameters (name, value, description) VALUES ( 'deePrivateDirectory','/var/data/ginco/@instance.name@/dee/private','Directory where DEE GML files are generated and stored');
INSERT INTO application_parameters (name, value, description) VALUES ( 'deePublicDirectory','/var/data/ginco/@instance.name@/dee/public','Directory where DEE archive are stored and can be downloaded');
INSERT INTO application_parameters (name, value, description) VALUES ( 'regionCode','@region.code@','INSEE Code for region, or ISO code for country');
INSERT INTO application_parameters (name, value, description) VALUES ( 'site_url','@ogam.map.services.url@','URL of the site');
INSERT INTO application_parameters (name, value, description) VALUES ( 'deeNotificationMail', 'sinp-dev@ign.fr', 'Contact mail to send notifications when the DEE is created/updated');
INSERT INTO application_parameters (name, value, description) VALUES ('sendEmail','1','Send emails for real ? 1/true, 0/false');
-- Pour utiliser le tilecache
-- insert into application_parameters (name, value, description) values ( 'tilecache_private_url' , 'http://localhost/tilecache-ogam?' , 'The private URL used by tilecacheProxy to request a tile cache.');
