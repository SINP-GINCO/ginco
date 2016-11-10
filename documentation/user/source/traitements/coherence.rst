.. cohérence

Contrôles de cohérence
======================

En plus des vérifications de conformité (format et appartenance aux référentiels), des vérifications spécifiques
au standard SINP sont effectuées lors de l'import.

* **Vérifications de cohérence entre plusieurs champs** : certains champs doivent être remplis
  (ou non) en fonction de la valeur prise par d'autres champs.
  Voir la :doc:`liste des erreurs de cohérence </gestion-jdd/rapport-erreur>` pour plus de détails, ainsi que le
  `détail du standard "Occurence de taxon" <http://standards-sinp.mnhn.fr/wp-content/uploads/sites/16/versionhtml/OccTax_v1_2_1/>`_.

* **l'unicité de l'identifiant producteur pour un producteur donné** : si un identifiant producteur est
  fourni dans le jeu de données (un champ dont le mapping le fait correspondre à la clé primaire de la table), cet identifiant
  doit être unique, par organisme producteur, sur l'ensemble des jeux de données importés dans l'application.
  Il n'est donc pas possible, par exemple, d'importer plusieurs fois un même jeu de données si celui-ci comporte un
  identifiant producteur.

* **l'identifiant de la fiche de métadonnées** doit correspondre à une fiche de métadonnées existante dans le Géosource de la plate-forme.
  Celle-ci doit donc avoir été livrée au préalable.
