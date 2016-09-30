# OGAM  - Déploiement du site SINP

## Déploiement du code 

Le déploiement du site (c'est-à-dire la copie du code vers le répertoire du serveur web et le déploiement des services JAVA) s'effectue via le fichier de build situé à la racine du projet **`build.xml`**.

### 1) Déploiement du site avec ANT 

`sudo ant deployWebsite`

Ceci provoque la copie des fichiers vers le répertoire `/var/www/sinp`

### 2) Attribution des droits

#### Donner les droits à Apache 

Se placer dans le répertoire `/var/www`

```bash
# Attribue le groupe et l'utilisateur www-data (= Apache) 
sudo chmod -R 777 sinp
sudo chown www-data sinp
sudo chgrp www-data sinp
# Attribue de manière définitive le groupe www-data à tous les sous-fichiers / sous-répertoires 
sudo chmod g+s sinp
```

#### Donner les droits à Zend 

ZEND requiert le droit en écriture sur les dossiers suivants  (au sein de `/var/www/sinp`): 

Changer les droits de ces répertoires via `chmod` pour autoriser ZEND à écrire et lire dessus : 
`chmod -R 777 nom_du_dossier`

* **tmp**
* **sessions** (mise en cache par Zend)
* **logs**   
* **upload** (répertoire de chargement des fichiers lors des livraisons)




