.. Administrer les rôles

Administrer les rôles
=====================

Plusieurs rôles GINCO sont livrés à l'initialisation de chaque plateforme :

 * Administrateur
 * Producteur
 * Grand Public

Auxquels s'ajoute le rôle *Développeur*, réservé à l'équipe de maintenance, et qu'il ne faut pas modifier ou supprimer.

Ces rôles sont configurables par les administrateurs de la plateforme, qui peuvent enlever ou rajouter des permissions
à chacun des rôles, mais aussi créer de nouveaux rôles, ou supprimer les rôles fournis par défaut.

.. note:: Le rôle *Grand Public* est un rôle technique non-modifiable, attribué par défaut aux utilisateurs non
  authentifiés, qui ont par défaut accès uniquement au module de visualisation de données.

Visualiser les rôles
--------------------

Pour accéder à la liste des rôles, cliquer sur le lien de menu "Administration > Rôles et permissions".

Ajouter un rôle
---------------

Pour ajouter un rôle, cliquez sur le lien "Créer un rôle" en bas de la liste des rôles.

.. image:: ../images/administration-role-visu-creer.png
 
Après avoir indiqué le code, le libellé et la définition du rôle, il faut sélectionner les droits (permissions) à attacher à ce rôle.
Une case indique si le rôle est le rôle par défaut.
Enfin, cliquez sur "Valider".

.. note:: Le rôle par défaut ne peut pas être supprimé. Par ailleurs, il ne peut y avoir qu'un seul rôle par défaut sur la plateforme. Vous pouvez choisir le rôle par défaut sur la page de configuration de la plateforme.
 
.. image:: ../images/administration-role-ajouter.png

Les rôles livrés avec les plateformes ont les permissions suivantes :

==========================================================  ==============  ==========  ============
Permissions                                                 administrateur  producteur  grand_public
==========================================================  ==============  ==========  ============
Administrer les utilisateurs                                 **Oui**          Non         Non
Annuler une soumission de données d'un autre organisme       **Oui**          Non         Non
Annuler une soumission de données validées                   **Oui**          Non         Non
Configurer le méta-modèle                                    **Oui**          Non         Non
Editer les données                                           **Oui**          Non         Non
Editer les données d'un autre organisme                      **Oui**          Non         Non
Exporter les données (au format CSV, GeoJson, kml...)        **Oui**        **Oui**       Non
Exporter les jeux de données au format DEE                   **Oui**          Non         Non
Gérer les jeux de données de tous les utilisateurs           **Oui**          Non         Non
Gérer les requêtes publiques                                 **Oui**          Non         Non
Gérer ses requêtes privées                                   **Oui**        **Oui**       Non
Importer des données                                         **Oui**          Non         Non
Publier les données                                          **Oui**          Non         Non
Vérifier la configuration technique (PHP, mémoire,...)         Non            Non         Non
Visualiser les données non publiées d'un autre organisme     **Oui**          Non         Non
Visualiser les données privées                               **Oui**          Non         Non
Visualiser les données régionales publiées                   **Oui**        **Oui**     **Oui**
Visualiser les données sensibles                             **Oui**          Non         Non
==========================================================  ==============  ==========  ============

Modifier un rôle
----------------

Pour modifier un rôle, à partir de la page de visualisation des rôles, cliquez sur l'icône "Modifier" à gauche du rôle à modifier.

Vous pouvez alors modifier les code, libellé, définition et permissions du rôle.

Supprimer un rôle
-----------------

Pour supprimer un rôle, à partir de la page de visualisation des rôles, cliquez sur l'icône "Supprimer" à droite du rôle à supprimer.

Il n'est pas possible de supprimer un rôle dans plusieurs cas:

* Si le rôle est attribué à des utilisateurs ; dans ce cas, il faut attribuer un autre rôle à chacun de ces utilisateurs avant de pouvoir le supprimer ;
* Si le rôle est le rôle par défaut attribué aux nouveaux utilisateurs ;
* Si il s'agit du rôle "Grand Public", rôle attribué aux visiteurs non connectés.


Rôle par défaut
---------------

Le rôle par défaut est le rôle attribué aux nouveaux utilisateurs de la plateforme, c'est à dire ceux qui se connectent pour la première fois à
une plateforme avec leur compte INPN.

L'administrateur peut choisir le rôle par défaut sur la page "Administration > Configuration de la Plateforme > onglet Paramètres de la plateforme".

Le rôle par défaut à la livraison d'une plateforme est "Producteur".

.. note:: Etant donné que chacun peut se créer un compte sur l'INPN, et que chaque détenteur d'un compte INPN aura ce rôle par défaut
  lors de la connexion à la plateforme Ginco, il est recommandé de **ne pas attribuer de permission sensible à ce rôle**.

