.. tableau-resultat

Tableau des résultats
=====================

Sous l’onglet Résultats, les résultats de la recherche sont affichés sous forme de grille.

.. image:: ../images/visu/visu-tableau.png

La liste des résultats est paginée, à raison de 20 lignes par page.
La navigation entre les pages de résultats se fait via les flèches au bas de la grille.

En cliquant à côté des titres des colonnes, il est possible d’ordonner l’affichage des résultats selon les valeurs de la colonne sélectionnée.

.. image:: ../images/visu/visu-tableau-tri.png

Il est aussi possible de masquer des colonnes en les décochant.

.. image:: ../images/visu/visu-tableau-masquer-colonnes.png

Vous pouvez déplacer les colonnes si vous le souhaitez en les glissant/déposant.

Les icones en début de ligne permettent d’afficher les détails, de visualiser sur la carte, ou d’éditer la donnée correspondante.
Selon les droits de l'utilisateur, elles ne sont pas toujours toutes disponibles.

.. image:: ../images/visu/visu-tableau-boutons.png

.. note:: Il est possible qu'une donnée ne comporte pas de géométrie, dans ce cas l'icone "Voir sur la carte" est grisée et inactive.

.. warning:: *Attention*, selon vos permissions, certaines valeurs de champs géométriques d'observations sensibles et/ou privées seront floutées (*i.e* : cachées). Par exemple, si l'application a déterminé qu'une observation est sensible et qu'elle ne peut pas être visualisée à une échelle plus précise que celle de la maille, les champs *codeCommune*, *codeCommuneCalcule*, *nomCommune*, *nomCommuneCalcule*, et *geometrie* afficheront une constante cachant l'information réelle. Vous trouverez plus de détails sur le fonctionnement du floutage dans le chapitre :ref:`fonctionnement-floutage`.


Export des résultats
--------------------

En haut à droite du tableau, un menu déroulant permet d'exporter les résultats aux format CSV.

 .. image:: ../images/visu/export-tableau-resultats.png

Lorsque le nombre d'observations à exporter est inférieur à 500, leur export est fait directement et au bout de quelques secondes l'application propose à l'utilisateur d'ouvrir ou d'enregistrer le fichier généré.

 .. image:: ../images/visu/export-direct.png
 
Lorsque l'export fait plus de 500 lignes, le temps de calcul est jugé trop important pour que le fichier soit renvoyé directement.
Il est donc généré en arrière plan, et l'utilisateur reçoit un mail une fois le fichier disponible. L'URL permettant d'obtenir le fichier est indiquée dans le mail.
Ce processus est signalé à l'utilisateur avant son lancement par un message d'avertissement lorsque l'export est trop volumineux.

 .. image:: ../images/visu/export-popup.png
 
 .. warning:: Lorsque l'export est généré en arrière plan (après apparition de la popup), il faut patienter plusieurs minutes pour recevoir le mail.
 
 .. note:: Si le mail ne parvient pas, il est conseillé de vérifier qu'il n'a pas été considéré comme un spam par sa messagerie.

Les données sont exportées sous forme tabulaire, avec des valeurs séparées par des ";".
En début de fichier sont rappelés les critères utilisés pour la requête.


 .. note:: Les géométries seront exportées dans la projection définies dans la configuration de la plateforme.
