.. _format-des-dates:

Format des dates
================

Dans le configurateur, l'administrateur peut définir son propre format de date.


Les éléments les plus importants de ce format sont désignés par les symboles suivants :

=========   ======================  =============   ====================================
Caractère   Description             Type            Exemple
=========   ======================  =============   ====================================
y           Année                   Nombre          06; 2006
M           Mois dans l'année       Texte/Nombre    Septembre; Sept; 07
w           Semaine dans l'année    Nombre          34
W           Semaine dans le mois    Nombre          2
D           Jour dans l'année       Nombre          192
d           Jour dans le mois       Nombre          23
E           Jour de la semaine      Texte           Mercredi; Mer.
a           Marqueur AM/PM          Texte           PM, AM
H           Heure (0-23)            Nombre          0
k           Heure (1-24)            Nombre          1
K           Heure en AM/PM (0-11)   Nombre          6
h           Heure en AM/PM (1-12)   Nombre          7
m           Minutes                 Nombre          59
s           Secondes                Nombre          59
z           Zone horaire générale   Texte           CEST; Heure d'été d'Europe Centrale
Z           Zone horaire (RFC 822)  Texte           +0200
=========   ======================  =============   ====================================

*Note :* Les formats de date permis dans GINCO sont ceux du language JAVA, l'intégralité de ces formats est disponible ici :
`Formats de date JAVA <https://docs.oracle.com/javase/7/docs/api/java/text/SimpleDateFormat.html>`_

Chaque caractère du tableau est interprété de façon particulière. Pour utiliser les caractères sans qu'ils soient
interprétés, il faut les encadrer par de simples quotes. Pour utiliser une quote il faut
en mettre deux consécutives dans le modèle. Par exemple, pour indiquer les heures avec un 'h'
comme dans ``31/07/2016 06h30``, le format doit être : ``dd/MM/yyyy hh'h'mm``.

Ces caractères peuvent être répétés pour préciser le format à utiliser :

* Pour les caractères de type Texte : moins de 4 caractères consécutifs représentent la version
  abrégée sinon c'est la version longue qui est utilisée.

* Pour les caractères de type Nombre : c'est le nombre de répétitions qui désigne le nombre
  de chiffres utilisés, complété si nécessaire par des 0 à gauche.

* Pour les caractères de type Années: 2 caractères précisent que l'année est codée sur deux
  caractères.

* Pour les caractères de type Mois : 3 caractères ou plus représentent la forme littérale, sinon
  c'est la forme numérique du mois.

==============================  ==========================================
Format de date                  Exemple
==============================  ==========================================
dd-MM-yy                        27-06-06
ddMMyy                          270606
h:mm a                          9:37 PM
K:mm a,z                        9:37 PM, CEST
hh:mm a,zzzz                    09:37 PM, Heure d'été d'Europe centrale
HH:mm                           21:37
EEEE, d MMMM yyyy               mardi, 27 juin 2006
'le' dd/MM/yyyy 'à' hh:mm:ss    le 27/06/2006 à 09:37:10
'le' dd MMMM yyyy 'à' hh:mm:ss  le 27 juin 2006 à 09:37:10
yyyy-MM-dd'T'HH:mmZ             2016-12-21T04:12+0100
==============================  ==========================================
