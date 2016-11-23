INSERT INTO website.application_parameters(name, value, description)
VALUES ('deePrivateDirectory','/var/www/localhost/website/dee','Directory where DEE GML files are generated and stored'),
       ('deePublicDirectory','/var/www/localhost/website/public/dee','Directory where DEE archive are stored and can be downloaded'),
       ('regionCode','@region.code@','INSEE Code for region, or ISO code for country')
;
