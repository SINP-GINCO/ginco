#!/usr/bin/python3
#-*- coding: utf-8 -*-

# FIXME:
# * pas de validation du gml par rapport au xsd
# * pas de gestion des attributs additionnels
# * pas de gestion du srs en entrée
# * la géométrie est prise telle quelle sans regarder son type (point dans l'exemple)


import xml.etree.ElementTree as ET
import sys

field_list=[
"sinp:identifiantPermanent",
"sinp:statutObservation",
"sinp:nomCite",
"sinp:cdNom",
"sinp:cdRef",
"sinp:identite",
"sinp:organisme",
"sinp:dateDebut",
"sinp:dateFin",
"sinp:determinateur",
"sinp:dateDetermination",
"sinp:denombrementMin",
"sinp:denombrementMax",
"sinp:objetDenombrement",
"sinp:typeDenombrement",
"sinp:refHabitat",
"sinp:codeHabitat",
"sinp:altitudeMin",
"sinp:altitudeMax",
"sinp:profondeurMin",
"sinp:profondeurMax",
"sinp:organismeStandard",
"sinp:validateur",
"sinp:commentaire",
"sinp:statutSource",
"sinp:identifiantOrigine",
"sinp:dSPublique",
"sinp:sensible",
"sinp:jddId",
"sinp:jddCode",
"sinp:referenceBiblio",
"sinp:organismeGestionnaireDonnee",
"sinp:codeIDCNPDispositif",
"sinp:codeCommune",
"sinp:nomCommune",
"sinp:natureObjetGeo",
"sinp:precisionGeometrie",
"gml:coordinates"
]

ns = {"sinp":"http://inpn.mnhn.fr/sinp/", "gml" : "http://www.opengis.net/gml"}

def usage():
  print("usage: "+sys.argv[0]+" <fichier.gml>")

if len(sys.argv) != 2 :
  usage()
  sys.exit(0)

gmlfilepath = sys.argv[1]
tree = ET.parse(gmlfilepath)
root = tree.getroot()

for member in root:
  #print(member.tag, member.attrib)
  csv_line = ""
  for field in field_list:
    #print(field)
    fn = member.find('.//' + field, ns)
    #print(fn)
    if fn is not None and fn.text is not None:
        #print("VAL:" + fn.text)
        csv_line += "\"" + fn.text + "\""
    csv_line += ';'
    #print(csv_line)
  print((csv_line[:-1]).encode('utf-8'))

