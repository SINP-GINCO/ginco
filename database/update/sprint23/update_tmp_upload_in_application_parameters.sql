SET SEARCH_PATH = website;

UPDATE application_parameters SET value='/var/data/ginco/@instance.name@/upload' WHERE name='UploadDirectory';
UPDATE application_parameters SET value='/var/data/ginco/@instance.name@/tmp' WHERE name='uploadDir';