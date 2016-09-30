# Liste des problèmes rencontrés et leurs solutions

## Lors de l'éxécution de PHPUnit, une erreur apparaît concernant les cookies de Session : "No such file or directory"

PHPUnit utilise la configuration que l'on retrouve dans `/etc/php/7.0/cli/php.ini` sur PHP 7.0, ou dans `/etc/php5/cli/php.ini` pour PHP5.

Ce fichier est important pour le paramétrage des sessions, et il n'est pas configuré via les différents builds que l'on a sur le projet.

Pour les sessions, nous utilisons en effet le paramétrage à la volée via la configuration Apache2. Le build de ce fichier de configuration permet de faire fonctionner le site en local.

Pour PHPUnit, Il est nécessaire de corriger votre fichier php.ini et à paramétrer les variables suivantes :

`session.name = "GINCO_SID"`

`session.save_path = "le chemin complet du dossier server/ogamServer/sessions"`


