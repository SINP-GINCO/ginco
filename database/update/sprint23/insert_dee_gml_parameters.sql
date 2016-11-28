INSERT INTO website.application_parameters(name, value, description)
VALUES ('deePrivateDirectory','/var/data/ginco/@instance.name@/dee/private','Directory where DEE GML files are generated and stored'),
       ('deePublicDirectory','/var/data/ginco/@instance.name@/dee/public','Directory where DEE archive are stored and can be downloaded'),
       ('regionCode','@region.code@','INSEE Code for region, or ISO code for country'),
       ('deeNotificationMail', 'sinp-dev@ign.fr', 'Contact mail to send notifications when the DEE is created/updated')
;
