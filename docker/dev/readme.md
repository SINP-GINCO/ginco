notes sur l'utilisation de Docker
---------------------------------

On se trouve dans le répertoire dockerfiles (ou se trouve en principe cette documentation).
On a un répertoire par image de base
ign_jessie: une extension de jessie officielle pour ajouter les mirroirs IGN et la locale
```bash
docker build -t ign/debian:jessie ./ign_jessie
```

ginco_db: un extension de ign_jessie avec ce qu'il faut pour la bdd ginco.
Les données, logs etc sont stockés dans un volume géré par docker.
```bash
docker build -t ginco/db ./ginco_db
```

On peut lancer le serveur ainsi:
```bash
docker run -i -t -p 5432:5432 ginco/db
```

Et on peut se connecter sur localhost:5432 avec les comptes admin et ogam (testé avec pgadmin).

*Remarque:* si on éteind ce container et qu'on en relance un autre, les 
modifications faites en bases ne sont plus visibles parce qu'un nouveau volume à été créé pour
le nouveau container.
Par contre si on relance le premier container:
```bash
docker start <nom_container>
```
On retrouve l'état de la base tel qu'il était avant d'éteindre le container.

Il faudrait donc toujours utiliser le même container ou bien remapper le volume avec celui du précédent.
Il y a un système un peu vaseu (de mon point de vue) utilisant des data container mais finalement,
le plus simple aujourd'hui est utiliser l'utilitaire docker-compose.

Il permet de lancer des containers nommé et si on relance avec le même fichier de conf il se 
débrouille pour reprendre le container arrêté précédemment. Comme, en plus il 
permet de définir plusieurs containers et leurs relation de manière plus simple 
qu'en ligne de commande on va s'en servir!

voir le fichier `docker-compose.yml` du répertoire `./dockerfiles`.

```bash
docker build -t ginco/front ./ginco_front
```