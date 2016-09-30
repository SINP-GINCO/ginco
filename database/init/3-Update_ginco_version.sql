-- La version de ginco à inserer en base est déduit du dernier répertoire de sprint du répertoire database/update

INSERT INTO website.application_parameters (name, value, description) values ('ginco_version','@ginco.version@','GINCO version for migration management');
