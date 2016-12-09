-- This script is the comon script for unit testing.
-- It purges metadata schema, then populates it with DEE model.
-- It purges metadata_work schema, then populates it with DEE model.

SET search_path = metadata;

-- Purge metadata schema
delete from translation;
delete from table_tree;

delete from dataset_fields;
delete from dataset_files;
delete from dataset_forms;
delete from model_tables;
delete from model_datasets;

delete from file_field;
delete from table_field;
delete from form_field;
delete from field_mapping;
delete from field;
delete from file_format;
delete from table_format;
delete from form_format;
delete from format;

delete from dynamode;
delete from group_mode;
delete from mode;
delete from range;

delete from data;

delete from unit;

delete from checks where check_id <= 1200;

delete from model;
delete from table_schema;
delete from dataset;

-- Data for Name: checks; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO checks VALUES (1000, 'COMPLIANCE', 'EMPTY_FILE_ERROR', 'Fichier vide.', 'Les fichiers ne doivent pas être vides.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1001, 'COMPLIANCE', 'WRONG_FIELD_NUMBER', 'Nombre de champs incorrect.', 'Le fichier doit contenir le bon nombre de champs, séparés par des points-virgules et aucun ne doit contenir de point-virgule.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1002, 'COMPLIANCE', 'INTEGRITY_CONSTRAINT', 'Contrainte d''intégrité non respectée.', 'La valeur de la clé étrangère n''existe pas dans la table mère.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1003, 'COMPLIANCE', 'UNEXPECTED_SQL_ERROR', 'Erreur SQL non répertoriée.', 'Erreur SQL non répertoriée, veuillez contacter l''administrateur.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1004, 'COMPLIANCE', 'DUPLICATE_ROW', 'Ligne dupliquée.', 'Ligne dupliquée. La donnée existe déjà.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1101, 'COMPLIANCE', 'MANDATORY_FIELD_MISSING', 'Champ obligatoire manquant.', 'Champ obligatoire manquant, veuillez indiquer une valeur.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1102, 'COMPLIANCE', 'INVALID_FORMAT', 'Format non respecté.', 'Le format du champ ne correspond pas au format attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1103, 'COMPLIANCE', 'INVALID_TYPE_FIELD', 'Type de champ erroné.', 'Le type du champ ne correspond pas au type attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1104, 'COMPLIANCE', 'INVALID_DATE_FIELD', 'Date erronée.', 'Le format de la date est erroné, veuillez respecter le format indiqué.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1105, 'COMPLIANCE', 'INVALID_CODE_FIELD', 'Code erroné.', 'Le code du champ ne correspond pas au code attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1106, 'COMPLIANCE', 'INVALID_RANGE_FIELD', 'Valeur du champ hors limites.', 'La valeur du champ n''entre pas dans la plage attendue (min et max).', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1107, 'COMPLIANCE', 'STRING_TOO_LONG', 'Chaîne de caractères trop longue.', 'La valeur du champ comporte trop de caractères.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1108, 'COMPLIANCE', 'UNDEFINED_COLUMN', 'Colonne indéfinie.', 'Colonne indéfinie.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1109, 'COMPLIANCE', 'NO_MAPPING', 'Pas de mapping pour ce champ.', 'Le champ dans le fichier n''a pas de colonne de destination dans une table en base.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1110, 'COMPLIANCE', 'TRIGGER_EXCEPTION', 'Valeur incorrecte.', 'La valeur donnée n''est pas reconnue et empêche l''exécution du code (remplissage automatique de champs).', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1, 'CONFORMITY    ', 'jddmetadonneedeeid', 'jddmetadonneedeeid', 'La métadonnée associée est inexistante.', 'SELECT raw_data.check_jddMetadonneeDEEId_exists(?submissionid?);', 'ERROR', '2016-04-11 10:07:06.861496');


--
-- Data for Name: checks_per_provider; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: unit; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO unit VALUES ('Integer', 'INTEGER', NULL, 'integer', NULL);
INSERT INTO unit VALUES ('Decimal', 'NUMERIC', NULL, 'float', NULL);
INSERT INTO unit VALUES ('CharacterString', 'STRING', NULL, 'text', NULL);
INSERT INTO unit VALUES ('Date', 'DATE', NULL, 'date', NULL);
INSERT INTO unit VALUES ('DateTime', 'DATE', NULL, 'date time', NULL);
INSERT INTO unit VALUES ('BOOLEAN', 'BOOLEAN', NULL, 'boolean', NULL);
INSERT INTO unit VALUES ('GEOM', 'GEOM', NULL, 'The geometrical position of an observation', 'The geometrical position of an observation');
INSERT INTO unit VALUES ('PROVIDER_ID', 'CODE', 'DYNAMIC', 'fournisseur de données', 'fournisseur de données');
INSERT INTO unit VALUES ('region', 'ARRAY', 'DYNAMIC', '[Liste] Région', 'Région');
INSERT INTO unit VALUES ('StatutSourceValue', 'CODE', 'DYNAMIC', 'Statut de la source', 'Statut de la source');
INSERT INTO unit VALUES ('DSPubliqueValue', 'CODE', 'DYNAMIC', 'DS de la DEE publique ou privée', 'DS de la DEE publique ou privée');
INSERT INTO unit VALUES ('StatutObservationValue', 'CODE', 'DYNAMIC', 'Statut de l''observation', 'Statut de l''observation');
INSERT INTO unit VALUES ('TaxRefValue', 'CODE', 'TAXREF', 'Code cd_nom du taxon', 'Code cd_nom du taxon');
INSERT INTO unit VALUES ('ObjetDenombrementValue', 'CODE', 'DYNAMIC', 'Objet du dénombrement', 'Objet du dénombrement');
INSERT INTO unit VALUES ('TypeDenombrementValue', 'CODE', 'DYNAMIC', 'Méthode de dénombrement', 'Méthode de dénombrement');
INSERT INTO unit VALUES ('CodeHabitatValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de l''habitat du taxon', 'Code de l''habitat du taxon');
INSERT INTO unit VALUES ('CodeRefHabitatValue', 'ARRAY', 'DYNAMIC', '[Liste] Référentiel identifiant l''habitat', 'Référentiel identifiant l''habitat');
INSERT INTO unit VALUES ('NatureObjetGeoValue', 'CODE', 'DYNAMIC', 'Nature de l’objet géographique ', 'Nature de l’objet géographique ');
INSERT INTO unit VALUES ('CodeMailleValue', 'ARRAY', 'DYNAMIC', '[Liste] Maille INPN 10*10 kms', 'Maille INPN 10*10 kms');
INSERT INTO unit VALUES ('CodeCommuneValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de la commune', 'Code de la commune');
INSERT INTO unit VALUES ('NomCommuneValue', 'ARRAY', 'DYNAMIC', '[Liste] Nom de la commune', 'Nom de la commune');
INSERT INTO unit VALUES ('CodeENValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de l''espace naturel', 'Code de l''espace naturel');
INSERT INTO unit VALUES ('TypeENValue', 'ARRAY', 'DYNAMIC', '[Liste] Type d''espace naturel oude zonage', 'Type d''espace naturel oude zonage');
INSERT INTO unit VALUES ('CodeDepartementValue', 'ARRAY', 'DYNAMIC', '[Liste] Code INSEE du département', 'Code INSEE du département');
INSERT INTO unit VALUES ('CodeHabRefValue', 'ARRAY', 'DYNAMIC', '[Liste] Code HABREF de l''habitat', 'Code HABREF de l''habitat');
INSERT INTO unit VALUES ('IDCNPValue', 'CODE', 'DYNAMIC', 'Code dispositif de collecte', 'Code dispositif de collecte');
INSERT INTO unit VALUES ('TypeInfoGeoValue', 'CODE', 'DYNAMIC', 'Type d''information géographique', 'Type d''information géographique');
INSERT INTO unit VALUES ('VersionMasseDEauValue', 'CODE', 'DYNAMIC', 'Version du référentiel Masse d''Eau', 'Version du référentiel Masse d''Eau');
INSERT INTO unit VALUES ('NiveauPrecisionValue', 'CODE', 'DYNAMIC', 'Niveau maximal de diffusion', 'Niveau maximal de diffusion');
INSERT INTO unit VALUES ('DEEFloutageValue', 'CODE', 'DYNAMIC', 'Floutage transformation DEE', 'Floutage transformation DEE');
INSERT INTO unit VALUES ('SensibleValue', 'CODE', 'DYNAMIC', 'Observation sensible', 'Observation sensible');
INSERT INTO unit VALUES ('SensibiliteValue', 'CODE', 'DYNAMIC', 'Degré de sensibilité', 'Degré de sensibilité');
INSERT INTO unit VALUES ('TypeRegroupementValue', 'CODE', 'DYNAMIC', 'Type de regroupement', 'Type de regroupement');
INSERT INTO unit VALUES ('OccurrenceNaturalisteValue', 'CODE', 'DYNAMIC', 'Naturalité de l''occurrence', 'Naturalité de l''occurrence');
INSERT INTO unit VALUES ('OccurrenceSexeValue', 'CODE', 'DYNAMIC', 'Sexe', 'Sexe');
INSERT INTO unit VALUES ('OccurrenceStadeDeVieValue', 'CODE', 'DYNAMIC', 'Stade de développement', 'Stade de développement');
INSERT INTO unit VALUES ('OccurrenceStatutBiologiqueValue', 'CODE', 'DYNAMIC', 'Comportement', 'Comportement');
INSERT INTO unit VALUES ('PreuveExistanteValue', 'CODE', 'DYNAMIC', 'Preuve de l''existance', 'Preuve de l''existance');
INSERT INTO unit VALUES ('ObservationMethodeValue', 'CODE', 'DYNAMIC', 'Méthode d''observation', 'Méthode d''observation');
INSERT INTO unit VALUES ('OccurrenceEtatBiologiqueValue', 'CODE', 'DYNAMIC', 'Code de l''état biologique', 'Code de l''état biologique');
INSERT INTO unit VALUES ('OccurrenceStatutBiogeographiqueValue', 'CODE', 'DYNAMIC', 'Code de l''état biogéographique', 'Code de l''état biogéographique');
INSERT INTO unit VALUES ('SensiManuelleValue', 'CODE', 'DYNAMIC', 'Mode de calcul de la sensibilité', 'Mode de calcul de la sensibilité');
INSERT INTO unit VALUES ('SensiAlerteValue', 'CODE', 'DYNAMIC', 'Alerte calcul sensibilité', 'Alerte calcul sensibilité');

--
-- Data for Name: data; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO data VALUES ('PROVIDER_ID', 'PROVIDER_ID', 'Organisme utilisateur', 'Organisme de l''utilisateur authentifié', NULL);
INSERT INTO data VALUES ('SUBMISSION_ID', 'Integer', 'Identifiant de la soumission', 'Identifiant de la soumission', NULL);
INSERT INTO data VALUES ('OGAM_ID_table_observation', 'CharacterString', 'Clé primaire table observation', 'Clé primaire table observation', NULL);
INSERT INTO data VALUES ('codecommune', 'CodeCommuneValue', 'codeCommune', 'Code de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur. ', NULL);
INSERT INTO data VALUES ('nomcommune', 'NomCommuneValue', 'nomCommune', 'Libellé de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur.', NULL);
INSERT INTO data VALUES ('anneerefcommune', 'Date', 'anneeRefCommune', 'Année de production du référentiel INSEE, qui sert à déterminer quel est le référentiel en vigueur pour le code et le nom de la commune.', NULL);
INSERT INTO data VALUES ('typeinfogeocommune', 'TypeInfoGeoValue', 'typeInfoGeoCommune', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('denombrementmin', 'Integer', 'denombrementMin', 'Nombre minimum d''individus du taxon composant l''observation.', NULL);
INSERT INTO data VALUES ('denombrementmax', 'Integer', 'denombrementMax', 'Nombre maximum d''individus du taxon composant l''observation.', NULL);
INSERT INTO data VALUES ('objetdenombrement', 'ObjetDenombrementValue', 'objetDenombrement', 'Objet sur lequel porte le dénombrement.', NULL);
INSERT INTO data VALUES ('typedenombrement', 'TypeDenombrementValue', 'typeDenombrement', 'Méthode utilisée pour le dénombrement (Inspire).', NULL);
INSERT INTO data VALUES ('codedepartement', 'CodeDepartementValue', 'codeDepartement', 'Code INSEE en vigueur suivant l''année du référentiel INSEE des départements, auquel l''information est rattachée.', NULL);
INSERT INTO data VALUES ('anneerefdepartement', 'Date', 'anneeRefDepartement', 'Année du référentiel INSEE utilisé.', NULL);
INSERT INTO data VALUES ('typeinfogeodepartement', 'TypeInfoGeoValue', 'typeInfoGeoDepartement', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('typeen', 'TypeENValue', 'typeEN', 'Indique le type d’espace naturel protégé, ou de zonage (Natura 2000, Znieff1, Znieff2).', NULL);
INSERT INTO data VALUES ('codeen', 'CodeENValue', 'codeEN', 'Code de l’espace naturel sur lequel a été faite l’observation, en fonction du type d''espace naturel.', NULL);
INSERT INTO data VALUES ('versionen', 'Date', 'versionEN', 'Version du référentiel consulté respectant la norme ISO 8601, sous la forme YYYY-MM-dd (année-mois-jour), YYYY-MM (année-mois), ou YYYY (année).', NULL);
INSERT INTO data VALUES ('typeinfogeoen', 'TypeInfoGeoValue', 'typeInfoGeoEN', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('refhabitat', 'CodeRefHabitatValue', 'refHabitat', 'RefHabitat correspond au référentiel utilisé pour identifier l''habitat de l''observation. Il est codé selon les acronymes utilisés sur le site de l''INPN mettant à disposition en téléchargement les référentiels "habitats" et "typologies".', NULL);
INSERT INTO data VALUES ('codehabitat', 'CodeHabitatValue', 'codeHabitat', 'Code métier de l''habitat où le taxon de l''observation a été identifié. Le référentiel Habitat est indiqué dans le champ « RefHabitat ». Il peut être trouvé dans la colonne "LB_CODE" d''HABREF.', NULL);
INSERT INTO data VALUES ('versionrefhabitat', 'CharacterString', 'versionRefHabitat', 'Version du référentiel utilisé (suivant la norme ISO 8601, sous la forme YYYY-MM-dd, YYYY-MM, ou YYYY).', NULL);
INSERT INTO data VALUES ('codehabref', 'CodeHabRefValue', 'codeHabRef', 'Code HABREF de l''habitat où le taxon de l''observation a été identifié. Il peut être trouvé dans la colonne "CD_HAB" d''HabRef.', NULL);
INSERT INTO data VALUES ('codemaille', 'CodeMailleValue', 'codeMaille', 'Code de la cellule de la grille de référence nationale 10kmx10km dans laquelle se situe l’observation.', NULL);
INSERT INTO data VALUES ('versionrefmaille', 'CharacterString', 'versionRefMaille', 'Version du référentiel des mailles utilisé.', NULL);
INSERT INTO data VALUES ('nomrefmaille', 'CharacterString', 'nomRefMaille', 'Nom de la couche de maille utilisée : Concaténation des éléments des colonnes "couche" et "territoire" de la page http://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref.', NULL);
INSERT INTO data VALUES ('typeinfogeomaille', 'TypeInfoGeoValue', 'typeInfoGeoMaille', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('codeme', 'CharacterString', 'codeME', 'Code de la ou les masse(s) d''eau à la (aux)quelle(s) l''observation a été rattachée.', NULL);
INSERT INTO data VALUES ('versionme', 'VersionMasseDEauValue', 'versionME', 'Version du référentiel masse d''eau utilisé et prélevé sur le site du SANDRE, telle que décrite sur le site du SANDRE.', NULL);
INSERT INTO data VALUES ('dateme', 'Date', 'dateME', 'Date de consultation ou de prélèvement du référentiel sur le site du SANDRE.', NULL);
INSERT INTO data VALUES ('typeinfogeome', 'TypeInfoGeoValue', 'typeInfoGeoME', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('geometrie', 'GEOM', 'geometrie', 'La géométrie de la localisationl (au format WKT)', NULL);
INSERT INTO data VALUES ('natureobjetgeo', 'NatureObjetGeoValue', 'natureObjetGeo', 'Nature de la localisation transmise ', NULL);
INSERT INTO data VALUES ('precisiongeometrie', 'Integer', 'precisionGeometrie', 'Estimation en mètres d’une zone tampon autour de l''objet géographique. Cette précision peut inclure la précision du moyen technique d’acquisition des coordonnées (GPS,…) et/ou du protocole naturaliste.', NULL);
INSERT INTO data VALUES ('observateurnomorganisme', 'CharacterString', 'observateurNomOrganisme', 'Organisme(s) de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('observateuridentite', 'CharacterString', 'observateurIdentite', 'Nom(s), prénom de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('observateurmail', 'CharacterString', 'observateurMail', 'Mail(s) de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('determinateurnomorganisme', 'CharacterString', 'determinateurNomOrganisme', 'Organisme de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('determinateuridentite', 'CharacterString', 'determinateurIdentite', 'Prénom, nom de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('determinateurmail', 'CharacterString', 'determinateurMail', 'Mail de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('validateurnomorganisme', 'CharacterString', 'validateurNomOrganisme', 'Organisme de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('validateuridentite', 'CharacterString', 'validateurIdentite', 'Prénom, nom de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('validateurmail', 'CharacterString', 'validateurMail', 'Mail de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('identifiantorigine', 'CharacterString', 'identifiantOrigine', 'Identifiant unique de la Donnée Source de l’observation dans la base de données du producteur où est stockée et initialement gérée la Donnée Source. La DS est caractérisée par jddId et/ou jddCode,.', NULL);
INSERT INTO data VALUES ('dspublique', 'DSPubliqueValue', 'dSPublique', 'Indique explicitement si la DS de la DEE est publique ou privée. Définit uniquement les droits nécessaires et suffisants des DS pour produire une DEE. Ne doit être utilisé que pour indiquer si la DEE résultante est susceptible d’être floutée.', NULL);
INSERT INTO data VALUES ('obsmethode', 'ObservationMethodeValue', 'obsMethode', 'Indique de quelle manière on a pu constater la présence d''un sujet d''observation.', NULL);
INSERT INTO data VALUES ('diffusionniveauprecision', 'NiveauPrecisionValue', 'diffusionNiveauPrecision', 'Niveau maximal de précision de la diffusion souhaitée par le producteur vers le grand public. Ne concerne que les DEE non sensibles.', NULL);
INSERT INTO data VALUES ('deefloutage', 'DEEFloutageValue', 'dEEFloutage', 'Indique si un floutage a été effectué lors de la transformation en DEE. Cela ne concerne que des données d''origine privée.', NULL);
INSERT INTO data VALUES ('sensible', 'SensibleValue', 'sensible', 'Indique si l''observation est sensible d''après les principes du SINP. Va disparaître.', NULL);
INSERT INTO data VALUES ('sensiniveau', 'SensibiliteValue', 'sensiNiveau', 'Indique si l''observation ou le regroupement est sensible d''après les principes du SINP et à quel degré. La manière de déterminer la sensibilité est définie dans le guide technique des données sensibles disponible sur la plate-forme naturefrance.', NULL);
INSERT INTO data VALUES ('sensidateattribution', 'DateTime', 'sensiDateAttribution', 'Date à laquelle on a attribué un niveau de sensibilité à la donnée. C''est également la date à laquelle on a consulté le référentiel de sensibilité associé.', NULL);
INSERT INTO data VALUES ('sensireferentiel', 'CharacterString', 'sensiReferentiel', 'Référentiel de sensibilité consulté lors de l''attribution du niveau de sensibilité.', NULL);
INSERT INTO data VALUES ('sensiversionreferentiel', 'CharacterString', 'sensiVersionReferentiel', 'Version du référentiel consulté. Peut être une date si le référentiel n''a pas de numéro de version. Doit être rempli par "NON EXISTANTE" si un référentiel n''existait pas au moment de l''attribution de la sensibilité par un Organisme.', NULL);
INSERT INTO data VALUES ('statutsource', 'StatutSourceValue', 'statutSource', 'Indique si la DS de l’observation provient directement du terrain (via un document informatisé ou une base de données), d''une collection, de la littérature, ou n''est pas connu.', NULL);
INSERT INTO data VALUES ('jddcode', 'CharacterString', 'jddCode', 'Nom, acronyme, ou code de la collection du jeu de données dont provient la donnée source.', NULL);
INSERT INTO data VALUES ('jddid', 'CharacterString', 'jddId', 'Identifiant pour la collection ou le jeu de données source d''où provient l''enregistrement.', NULL);
INSERT INTO data VALUES ('jddsourceid', 'CharacterString', 'jddSourceId', 'Il peut arriver, pour un besoin d''inventaire, par exemple, qu''on réutilise une donnée en provenance d''un autre jeu de données DEE déjà existant au sein du SINP.', NULL);
INSERT INTO data VALUES ('jddmetadonneedeeid', 'CharacterString', 'jddMetadonneeDEEId', 'Identifiant permanent et unique de la fiche métadonnées du jeu de données auquel appartient la donnée.', NULL);
INSERT INTO data VALUES ('organismegestionnairedonnee', 'CharacterString', 'organismeGestionnaireDonnee', 'Nom de l’organisme qui détient la Donnée Source (DS) de la DEE et qui en a la responsabilité. Si plusieurs organismes sont nécessaires, les séparer par des virgules.', NULL);
INSERT INTO data VALUES ('codeidcnpdispositif', 'IDCNPValue', 'codeIDCNPDispositif', 'Code du dispositif de collecte dans le cadre duquel la donnée a été collectée.', NULL);
INSERT INTO data VALUES ('deedatetransformation', 'DateTime', 'dEEDateTransformation', 'Date de transformation de la donnée source (DSP ou DSR) en donnée élémentaire d''échange (DEE).', NULL);
INSERT INTO data VALUES ('deedatedernieremodification', 'DateTime', 'dEEDateDerniereModification', 'Date de dernière modification de la donnée élémentaire d''échange. Postérieure à la date de transformation en DEE, égale dans le cas de l''absence de modification.', NULL);
INSERT INTO data VALUES ('referencebiblio', 'CharacterString', 'referenceBiblio', 'Référence de la source de l’observation lorsque celle-ci est de type « Littérature », au format ISO690. La référence bibliographique doit concerner l''observation même et non uniquement le taxon ou le protocole.', NULL);
INSERT INTO data VALUES ('orgtransformation', 'CharacterString', 'orgTransformation', 'Nom de l''organisme ayant créé la DEE finale (plate-forme ou organisme mandaté par elle).', NULL);
INSERT INTO data VALUES ('identifiantpermanent', 'CharacterString', 'identifiantPermanent', 'Identifiant unique et pérenne de la Donnée Elémentaire d’Echange de l''observation dans le SINP attribué par la plateforme régionale ou thématique.', NULL);
INSERT INTO data VALUES ('statutobservation', 'StatutObservationValue', 'statutObservation', 'Indique si le taxon a été observé directement ou indirectement (indices de présence), ou non observé ', NULL);
INSERT INTO data VALUES ('nomcite', 'CharacterString', 'nomCite', 'Nom du taxon cité à l’origine par l’observateur. Celui-ci peut être le nom scientifique reprenant idéalement en plus du nom latin, l’auteur et la date. ', NULL);
INSERT INTO data VALUES ('datedebut', 'DateTime', 'dateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('datefin', 'DateTime', 'dateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('jourdatedebut', 'DateTime', 'jourDateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('jourdatefin', 'DateTime', 'jourDateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('heuredatedebut', 'DateTime', 'heureDateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('heuredatefin', 'DateTime', 'heureDateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('altitudemin', 'Decimal', 'altitudeMin', 'Altitude minimum de l’observation en mètres.', NULL);
INSERT INTO data VALUES ('altitudemax', 'Decimal', 'altitudeMax', 'Altitude maximum de l’observation en mètres.', NULL);
INSERT INTO data VALUES ('profondeurmin', 'Decimal', 'profondeurmin', 'Profondeur minimale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).', NULL);
INSERT INTO data VALUES ('profondeurmax', 'Decimal', 'profondeurmax', 'Profondeur maximale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).', NULL);
INSERT INTO data VALUES ('cdnom', 'TaxRefValue', 'cdNom', 'Code du taxon « cd_nom » de TaxRef référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.', NULL);
INSERT INTO data VALUES ('cdref', 'TaxRefValue', 'cdRef', 'Code du taxon « cd_ref » de TAXREF référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.', NULL);
INSERT INTO data VALUES ('versiontaxref', 'CharacterString', 'versionTAXREF', 'Version du référentiel TAXREF utilisée pour le cdNom et le cdRef.', NULL);
INSERT INTO data VALUES ('datedetermination', 'DateTime', 'dateDetermination', 'Date/heure de la dernière détermination du taxon de l’observation dans le système grégorien.', NULL);
INSERT INTO data VALUES ('organismestandard', 'CharacterString', 'organismeStandard', 'Nom(s) de(s) organisme(s) qui ont participés à la standardisation de la DS en DEE (codage, formatage, recherche des données obligatoires) ', NULL);
INSERT INTO data VALUES ('commentaire', 'CharacterString', 'commentaire', 'Champ libre pour informations complémentaires indicatives sur le sujet d''observation.', NULL);
INSERT INTO data VALUES ('nomattribut', 'CharacterString', 'nomAttribut', 'Libellé court et implicite de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('definitionattribut', 'CharacterString', 'definitionAttribut', 'Définition précise et complète de l''attribut additionnel.', NULL);
INSERT INTO data VALUES ('valeurattribut', 'CharacterString', 'valeurAttribut', 'Valeur qualitative ou quantitative de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('uniteattribut', 'CharacterString', 'uniteAttribut', 'Unité de mesure de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('thematiqueattribut', 'CharacterString', 'thematiqueAttribut', 'Thématique relative à l''attribut additionnel (mot-clé).', NULL);
INSERT INTO data VALUES ('typeattribut', 'CharacterString', 'typeAttribut', 'Indique si l''attribut additionnel est de type quantitatif ou qualitatif.', NULL);
INSERT INTO data VALUES ('obsdescription', 'CharacterString', 'obsDescription', 'Description libre de l''observation, aussi succincte et précise que possible.', NULL);
INSERT INTO data VALUES ('occetatbiologique', 'OccurrenceEtatBiologiqueValue', 'occEtatBiologique', 'Code de l''état biologique de l''organisme au moment de l''observation.', NULL);
INSERT INTO data VALUES ('occmethodedetermination', 'CharacterString', 'occMethodeDetermination', 'Description de la méthode utilisée pour déterminer le taxon lors de l''observation.', NULL);
INSERT INTO data VALUES ('occnaturalite', 'OccurrenceNaturalisteValue', 'occNaturalite', 'Naturalité de l''occurrence, conséquence de l''influence anthropique directe qui la caractérise. Elle peut être déterminée immédiatement par simple observation, y compris par une personne n''ayant pas de formation dans le domaine de la biologie considéré.', NULL);
INSERT INTO data VALUES ('occsexe', 'OccurrenceSexeValue', 'occSexe', 'Sexe du sujet de l''observation.', NULL);
INSERT INTO data VALUES ('occstadedevie', 'OccurrenceStadeDeVieValue', 'occStadeDeVie', 'Stade de développement du sujet de l''observation.', NULL);
INSERT INTO data VALUES ('occstatutbiologique', 'OccurrenceStatutBiologiqueValue', 'occStatutBiologique', 'Comportement général de l''individu sur le site d''observation.', NULL);
INSERT INTO data VALUES ('occstatutbiogeographique', 'OccurrenceStatutBiogeographiqueValue', 'occStatutBioGeographique', 'Couvre une notion de présence (présence/absence), et d''origine (indigénat ou introduction)', NULL);
INSERT INTO data VALUES ('preuveexistante', 'PreuveExistanteValue', 'preuveExistante', 'Indique si une preuve existe ou non. Par preuve on entend un objet physique ou numérique permettant de démontrer l''existence de l''occurrence et/ou d''en vérifier l''exactitude.', NULL);
INSERT INTO data VALUES ('preuvenonnumerique', 'CharacterString', 'preuveNonNumerique', 'Adresse ou nom de la personne ou de l''organisme qui permettrait de retrouver la preuve non numérique de L''observation.', NULL);
INSERT INTO data VALUES ('preuvenumerique', 'CharacterString', 'preuveNumerique', 'Adresse web à laquelle on pourra trouver la preuve numérique ou l''archive contenant toutes les preuves numériques (image(s), sonogramme(s), film(s), séquence(s) génétique(s)...).', NULL);
INSERT INTO data VALUES ('obscontexte', 'CharacterString', 'obsContexte', 'Description libre du contexte de l''observation, aussi succincte et précise que possible.', NULL);
INSERT INTO data VALUES ('identifiantregroupementpermanent', 'CharacterString', 'identifiantRegroupementPermanent', 'Identifiant permanent du regroupement, sous forme d''UUID.', NULL);
INSERT INTO data VALUES ('methoderegroupement', 'CharacterString', 'methodeRegroupement', 'Description de la méthode ayant présidé au regroupement, de façon aussi succincte que possible : champ libre.', NULL);
INSERT INTO data VALUES ('typeregroupement', 'TypeRegroupementValue', 'typeRegroupement', 'Indique quel est le type du regroupement suivant la liste typeRegroupementValue.', NULL);
INSERT INTO data VALUES ('altitudemoyenne', 'Decimal', 'altitudeMoyenne', 'Altitude moyenne considérée pour le regroupement.', NULL);
INSERT INTO data VALUES ('profondeurmoyenne', 'Decimal', 'profondeurMoyenne', 'Profondeur moyenne considérée pour le regroupement.', NULL);
INSERT INTO data VALUES ('region', 'region', 'Région', 'Région', NULL);
INSERT INTO data VALUES ('sensimanuelle', 'SensiManuelleValue', 'sensiManuelle', 'Indique si la sensibilité a été attribuée manuellement.', NULL);
INSERT INTO data VALUES ('sensialerte', 'SensiAlerteValue', 'sensiAlerte', 'Indique si la sensibilité est à attribuer manuellement.', NULL);



--
-- Data for Name: dataset; Type: TABLE DATA; Schema: metadata; Owner: admin
--


INSERT INTO dataset VALUES ('dataset_1', 'Std occ taxon dee v1-2-1', '1', 'std_occ_taxon_dee_v1-2-1', 'IMPORT');
INSERT INTO dataset VALUES ('dataset_2', 'Std occ taxon dee v1-2-1', '0', 'Dataset de visualisation pour le modèle ''Std occ taxon dee v1-2-1 ''', 'QUERY');


--
-- Data for Name: format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO format VALUES ('file_observation', 'FILE');
INSERT INTO format VALUES ('table_observation', 'TABLE');
INSERT INTO format VALUES ('form_observation', 'FORM');
INSERT INTO format VALUES ('form_localisation', 'FORM');
INSERT INTO format VALUES ('form_regroupements', 'FORM');
INSERT INTO format VALUES ('form_standardisation', 'FORM');
INSERT INTO format VALUES ('form_autres', 'FORM');



--
-- Data for Name: field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field VALUES ('OGAM_ID_table_observation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codecommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomcommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('anneerefcommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeocommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('denombrementmin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('denombrementmax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('objetdenombrement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typedenombrement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codedepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('anneerefdepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeodepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeoen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('refhabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codehabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionrefhabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codehabref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codemaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionrefmaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomrefmaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeomaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('dateme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeome', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantorigine', 'file_observation', 'FILE');
INSERT INTO field VALUES ('dspublique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('diffusionniveauprecision', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deefloutage', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensible', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensiniveau', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensidateattribution', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensireferentiel', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensiversionreferentiel', 'file_observation', 'FILE');
INSERT INTO field VALUES ('statutsource', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddcode', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddsourceid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeidcnpdispositif', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deedatetransformation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deedatedernieremodification', 'file_observation', 'FILE');
INSERT INTO field VALUES ('referencebiblio', 'file_observation', 'FILE');
INSERT INTO field VALUES ('orgtransformation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantpermanent', 'file_observation', 'FILE');
INSERT INTO field VALUES ('statutobservation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomcite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('heuredatedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('heuredatefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jourdatedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jourdatefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('cdnom', 'file_observation', 'FILE');
INSERT INTO field VALUES ('cdref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versiontaxref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datedetermination', 'file_observation', 'FILE');
INSERT INTO field VALUES ('organismestandard', 'file_observation', 'FILE');
INSERT INTO field VALUES ('commentaire', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obsdescription', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obsmethode', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occetatbiologique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occmethodedetermination', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occnaturalite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occsexe', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstadedevie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstatutbiologique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstatutbiogeographique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuveexistante', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuvenonnumerique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuvenumerique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obscontexte', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'file_observation', 'FILE');
INSERT INTO field VALUES ('methoderegroupement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeregroupement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemoyenne', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmoyenne', 'file_observation', 'FILE');
INSERT INTO field VALUES ('geometrie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('natureobjetgeo', 'file_observation', 'FILE');
INSERT INTO field VALUES ('precisiongeometrie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_table_observation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codecommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomcommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('anneerefcommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeocommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('denombrementmin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('denombrementmax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('objetdenombrement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typedenombrement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codedepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('anneerefdepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeodepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeoen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('refhabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codehabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionrefhabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codehabref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codemaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionrefmaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomrefmaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeomaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('dateme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeome', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantorigine', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('dspublique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('diffusionniveauprecision', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deefloutage', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensible', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensiniveau', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensidateattribution', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensireferentiel', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensiversionreferentiel', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('statutsource', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddcode', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddsourceid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeidcnpdispositif', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deedatetransformation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deedatedernieremodification', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('referencebiblio', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('orgtransformation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantpermanent', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('statutobservation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomcite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jourdatedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jourdatefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('heuredatedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('heuredatefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('cdref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versiontaxref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datedetermination', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('organismestandard', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('commentaire', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obsdescription', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obsmethode', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occetatbiologique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstatutbiogeographique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occmethodedetermination', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occnaturalite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occsexe', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstadedevie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstatutbiologique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuveexistante', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuvenonnumerique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuvenumerique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obscontexte', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('methoderegroupement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeregroupement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemoyenne', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmoyenne', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('geometrie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('natureobjetgeo', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('precisiongeometrie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensimanuelle', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensialerte', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('altitudemin', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('altitudemoyenne', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('anneerefcommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('anneerefdepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('cdnom', 'form_observation', 'FORM');
INSERT INTO field VALUES ('cdref', 'form_observation', 'FORM');
INSERT INTO field VALUES ('codecommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codedepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codehabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codehabref', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeidcnpdispositif', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('codemaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('commentaire', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('jourdatedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('jourdatefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('heuredatedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('heuredatefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datedetermination', 'form_observation', 'FORM');
INSERT INTO field VALUES ('dateme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('deedatedernieremodification', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('deedatetransformation', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('deefloutage', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('denombrementmax', 'form_observation', 'FORM');
INSERT INTO field VALUES ('denombrementmin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateuridentite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateurmail', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateurnomorganisme', 'form_observation', 'FORM');
INSERT INTO field VALUES ('diffusionniveauprecision', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('dspublique', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('geometrie', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('identifiantorigine', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('identifiantpermanent', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('jddcode', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddsourceid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('methoderegroupement', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('natureobjetgeo', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('nomcite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('nomcommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('nomrefmaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('objetdenombrement', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obscontexte', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obsdescription', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateuridentite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateurmail', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateurnomorganisme', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obsmethode', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occetatbiologique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occmethodedetermination', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occnaturalite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occsexe', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstadedevie', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstatutbiogeographique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstatutbiologique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_table_observation', 'form_autres', 'FORM');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('organismestandard', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('orgtransformation', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('precisiongeometrie', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('preuveexistante', 'form_observation', 'FORM');
INSERT INTO field VALUES ('preuvenonnumerique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('preuvenumerique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('profondeurmax', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('profondeurmin', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('profondeurmoyenne', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'form_autres', 'FORM');
INSERT INTO field VALUES ('referencebiblio', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('refhabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('sensible', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensidateattribution', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensiniveau', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensireferentiel', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensiversionreferentiel', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('statutobservation', 'form_observation', 'FORM');
INSERT INTO field VALUES ('statutsource', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('SUBMISSION_ID', 'form_autres', 'FORM');
INSERT INTO field VALUES ('typedenombrement', 'form_observation', 'FORM');
INSERT INTO field VALUES ('typeen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeocommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeodepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeoen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeomaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeome', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeregroupement', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('validateuridentite', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('validateurmail', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('validateurnomorganisme', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('versionen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionrefhabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionrefmaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versiontaxref', 'form_observation', 'FORM');
INSERT INTO field VALUES ('sensimanuelle', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensialerte', 'form_standardisation', 'FORM');
--
-- Data for Name: dataset_fields; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'SUBMISSION_ID');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'PROVIDER_ID');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'OGAM_ID_table_observation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codecommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomcommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'anneerefcommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeocommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'denombrementmin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'denombrementmax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'objetdenombrement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typedenombrement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codedepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'anneerefdepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeodepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeoen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'refhabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codehabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionrefhabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codehabref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codemaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeomaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'dateme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeome');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantorigine');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'dspublique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'diffusionniveauprecision');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deefloutage');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensible');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensiniveau');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensidateattribution');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensireferentiel');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensiversionreferentiel');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'statutsource');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddcode');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddsourceid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddmetadonneedeeid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'organismegestionnairedonnee');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeidcnpdispositif');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deedatetransformation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deedatedernieremodification');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'referencebiblio');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'orgtransformation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantpermanent');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'statutobservation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomcite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jourdatedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jourdatefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'cdnom');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'cdref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versiontaxref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datedetermination');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'organismestandard');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'commentaire');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obsdescription');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obsmethode');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occetatbiologique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstatutbiogeographique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occmethodedetermination');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occnaturalite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occsexe');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstadedevie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstatutbiologique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuveexistante');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuvenonnumerique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuvenumerique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obscontexte');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantregroupementpermanent');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'methoderegroupement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeregroupement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemoyenne');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmoyenne');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'geometrie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'natureobjetgeo');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'precisiongeometrie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensimanuelle');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensialerte');


--
-- Data for Name: file_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_format VALUES ('file_observation', 'CSV', 'file_observation', 0, 'dee_v1-2-1_observation', 'fichier_dee_v1-2-1_observation');


--
-- Data for Name: dataset_files; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_files VALUES ('dataset_1', 'file_observation');

--
-- Data for Name: form_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_format VALUES ('form_observation', 'Observation', 'Groupement des champs d''observation', 1, '1');
INSERT INTO form_format VALUES ('form_localisation', 'Localisation', 'Groupement des champs de localisation', 2, '1');
INSERT INTO form_format VALUES ('form_regroupements', 'Regroupements', 'Groupement des champs de regroupement', 3, '1');
INSERT INTO form_format VALUES ('form_standardisation', 'Standardisation', 'Groupement des champs de standardisation', 4, '1');
INSERT INTO form_format VALUES ('form_autres', 'Autres', 'Autres champs', 6, '1');


--
-- Data for Name: dataset_forms; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_forms VALUES ('dataset_2', 'form_observation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_localisation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_regroupements');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_standardisation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_autres');

--
-- Data for Name: dynamode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dynamode VALUES ('CodeCommuneValue', 'SELECT code as code, code as label FROM referentiels.communes ORDER BY code');
INSERT INTO dynamode VALUES ('NomCommuneValue', 'SELECT nom as code, nom || '' ('' || code || '')'' as label FROM referentiels.communes ORDER BY nom');
INSERT INTO dynamode VALUES ('CodeDepartementValue', 'SELECT dp as code, nom_depart || '' ('' || dp || '')'' as label FROM referentiels.departements ORDER BY dp');
INSERT INTO dynamode VALUES ('region', 'SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.regions ORDER BY code');
INSERT INTO dynamode VALUES ('CodeMailleValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeENValue', 'SELECT codeen as code, codeen || '' ('' || libelleen || '')'' as label FROM referentiels.codeenvalue ORDER BY codeEN');
INSERT INTO dynamode VALUES ('StatutSourceValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.StatutSourceValue ORDER BY code');
INSERT INTO dynamode VALUES ('DSPubliqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.DSPubliqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('StatutObservationValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.StatutObservationValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObjetDenombrementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.ObjetDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeDenombrementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabitatValue', 'SELECT lb_code as code, lb_code as label FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1 ');
INSERT INTO dynamode VALUES ('CodeRefHabitatValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.CodeRefHabitatValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NatureObjetGeoValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.NatureObjetGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeENValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeENValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeMasseEauValue', 'SELECT cdeumassedeau as code, cdeumassedeau || '' ('' || nommassedeau || '')'' as label FROM referentiels.CodeMasseEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabRefValue', 'SELECT cd_hab as code, cd_hab as label FROM referentiels.habref_20 ORDER BY code ');
INSERT INTO dynamode VALUES ('IDCNPValue', 'SELECT code as code, label as label FROM referentiels.IDCNPValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeInfoGeoValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeInfoGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('VersionMasseDEauValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.VersionMasseDEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NiveauPrecisionValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.NiveauPrecisionValue ORDER BY code ');
INSERT INTO dynamode VALUES ('DEEFloutageValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.DEEFloutageValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibleValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensibleValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibiliteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensibiliteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeRegroupementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeRegroupementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceNaturalisteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceNaturalisteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceSexeValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceSexeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStadeDeVieValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiologiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PreuveExistanteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.PreuveExistanteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObservationMethodeValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.ObservationMethodeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceEtatBiologiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiogeographiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStatutBiogeographiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PROVIDER_ID', 'SELECT id as code, label FROM website.providers ORDER BY label');
INSERT INTO dynamode VALUES ('SensiAlerteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensiAlerteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensiManuelleValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensiManuelleValue ORDER BY code ');


--
-- Data for Name: field_mapping; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field_mapping VALUES ('OGAM_ID_table_observation', 'file_observation', 'OGAM_ID_table_observation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codecommune', 'file_observation', 'codecommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomcommune', 'file_observation', 'nomcommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('anneerefcommune', 'file_observation', 'anneerefcommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeocommune', 'file_observation', 'typeinfogeocommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('denombrementmin', 'file_observation', 'denombrementmin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('denombrementmax', 'file_observation', 'denombrementmax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('objetdenombrement', 'file_observation', 'objetdenombrement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typedenombrement', 'file_observation', 'typedenombrement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codedepartement', 'file_observation', 'codedepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('anneerefdepartement', 'file_observation', 'anneerefdepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement', 'file_observation', 'typeinfogeodepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeen', 'file_observation', 'typeen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeen', 'file_observation', 'codeen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionen', 'file_observation', 'versionen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeoen', 'file_observation', 'typeinfogeoen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('refhabitat', 'file_observation', 'refhabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codehabitat', 'file_observation', 'codehabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionrefhabitat', 'file_observation', 'versionrefhabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codehabref', 'file_observation', 'codehabref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codemaille', 'file_observation', 'codemaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionrefmaille', 'file_observation', 'versionrefmaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomrefmaille', 'file_observation', 'nomrefmaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeomaille', 'file_observation', 'typeinfogeomaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeme', 'file_observation', 'codeme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionme', 'file_observation', 'versionme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('dateme', 'file_observation', 'dateme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeome', 'file_observation', 'typeinfogeome', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateurnomorganisme', 'file_observation', 'observateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateuridentite', 'file_observation', 'observateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateurmail', 'file_observation', 'observateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme', 'file_observation', 'determinateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateuridentite', 'file_observation', 'determinateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateurmail', 'file_observation', 'determinateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateurnomorganisme', 'file_observation', 'validateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateuridentite', 'file_observation', 'validateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateurmail', 'file_observation', 'validateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantorigine', 'file_observation', 'identifiantorigine', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('dspublique', 'file_observation', 'dspublique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('diffusionniveauprecision', 'file_observation', 'diffusionniveauprecision', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deefloutage', 'file_observation', 'deefloutage', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensible', 'file_observation', 'sensible', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensiniveau', 'file_observation', 'sensiniveau', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensidateattribution', 'file_observation', 'sensidateattribution', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensireferentiel', 'file_observation', 'sensireferentiel', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensiversionreferentiel', 'file_observation', 'sensiversionreferentiel', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('statutsource', 'file_observation', 'statutsource', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddcode', 'file_observation', 'jddcode', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddid', 'file_observation', 'jddid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddsourceid', 'file_observation', 'jddsourceid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddmetadonneedeeid', 'file_observation', 'jddmetadonneedeeid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee', 'file_observation', 'organismegestionnairedonnee', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeidcnpdispositif', 'file_observation', 'codeidcnpdispositif', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deedatetransformation', 'file_observation', 'deedatetransformation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deedatedernieremodification', 'file_observation', 'deedatedernieremodification', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('referencebiblio', 'file_observation', 'referencebiblio', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('orgtransformation', 'file_observation', 'orgtransformation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantpermanent', 'file_observation', 'identifiantpermanent', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('statutobservation', 'file_observation', 'statutobservation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomcite', 'file_observation', 'nomcite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datedebut', 'file_observation', 'datedebut', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datefin', 'file_observation', 'datefin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemin', 'file_observation', 'altitudemin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemax', 'file_observation', 'altitudemax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmin', 'file_observation', 'profondeurmin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmax', 'file_observation', 'profondeurmax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('cdnom', 'file_observation', 'cdnom', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('cdref', 'file_observation', 'cdref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versiontaxref', 'file_observation', 'versiontaxref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datedetermination', 'file_observation', 'datedetermination', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('organismestandard', 'file_observation', 'organismestandard', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('commentaire', 'file_observation', 'commentaire', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obsdescription', 'file_observation', 'obsdescription', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obsmethode', 'file_observation', 'obsmethode', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occetatbiologique', 'file_observation', 'occetatbiologique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occmethodedetermination', 'file_observation', 'occmethodedetermination', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occnaturalite', 'file_observation', 'occnaturalite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occsexe', 'file_observation', 'occsexe', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstadedevie', 'file_observation', 'occstadedevie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstatutbiologique', 'file_observation', 'occstatutbiologique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique', 'file_observation', 'occstatutbiogeographique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuveexistante', 'file_observation', 'preuveexistante', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuvenonnumerique', 'file_observation', 'preuvenonnumerique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuvenumerique', 'file_observation', 'preuvenumerique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obscontexte', 'file_observation', 'obscontexte', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent', 'file_observation', 'identifiantregroupementpermanent', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('methoderegroupement', 'file_observation', 'methoderegroupement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeregroupement', 'file_observation', 'typeregroupement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemoyenne', 'file_observation', 'altitudemoyenne', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmoyenne', 'file_observation', 'profondeurmoyenne', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('geometrie', 'file_observation', 'geometrie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('natureobjetgeo', 'file_observation', 'natureobjetgeo', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('precisiongeometrie', 'file_observation', 'precisiongeometrie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemax', 'form_localisation', 'altitudemax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('altitudemin', 'form_localisation', 'altitudemin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('altitudemoyenne', 'form_localisation', 'altitudemoyenne', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('anneerefcommune', 'form_localisation', 'anneerefcommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('anneerefdepartement', 'form_localisation', 'anneerefdepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('cdnom', 'form_observation', 'cdnom', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('cdref', 'form_observation', 'cdref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codecommune', 'form_localisation', 'codecommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codedepartement', 'form_localisation', 'codedepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeen', 'form_localisation', 'codeen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codehabitat', 'form_localisation', 'codehabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codehabref', 'form_localisation', 'codehabref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeidcnpdispositif', 'form_standardisation', 'codeidcnpdispositif', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codemaille', 'form_localisation', 'codemaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeme', 'form_localisation', 'codeme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('commentaire', 'form_observation', 'commentaire', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datedetermination', 'form_observation', 'datedetermination', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datefin', 'form_observation', 'datefin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datedebut', 'form_observation', 'datedebut', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('heuredatefin', 'form_observation', 'datefin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('heuredatedebut', 'form_observation', 'datedebut', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jourdatefin', 'form_observation', 'datefin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jourdatedebut', 'form_observation', 'datedebut', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('dateme', 'form_localisation', 'dateme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deedatedernieremodification', 'form_standardisation', 'deedatedernieremodification', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deedatetransformation', 'form_standardisation', 'deedatetransformation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deefloutage', 'form_standardisation', 'deefloutage', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('denombrementmax', 'form_observation', 'denombrementmax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('denombrementmin', 'form_observation', 'denombrementmin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateuridentite', 'form_observation', 'determinateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateurmail', 'form_observation', 'determinateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme', 'form_observation', 'determinateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('diffusionniveauprecision', 'form_standardisation', 'diffusionniveauprecision', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('dspublique', 'form_standardisation', 'dspublique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('geometrie', 'form_localisation', 'geometrie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantorigine', 'form_standardisation', 'identifiantorigine', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantpermanent', 'form_standardisation', 'identifiantpermanent', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent', 'form_regroupements', 'identifiantregroupementpermanent', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddcode', 'form_standardisation', 'jddcode', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddid', 'form_standardisation', 'jddid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddmetadonneedeeid', 'form_standardisation', 'jddmetadonneedeeid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddsourceid', 'form_standardisation', 'jddsourceid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('methoderegroupement', 'form_regroupements', 'methoderegroupement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('natureobjetgeo', 'form_localisation', 'natureobjetgeo', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomcite', 'form_observation', 'nomcite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomcommune', 'form_localisation', 'nomcommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomrefmaille', 'form_localisation', 'nomrefmaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('objetdenombrement', 'form_observation', 'objetdenombrement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obscontexte', 'form_observation', 'obscontexte', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obsdescription', 'form_observation', 'obsdescription', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateuridentite', 'form_observation', 'observateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateurmail', 'form_observation', 'observateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateurnomorganisme', 'form_observation', 'observateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obsmethode', 'form_observation', 'obsmethode', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occetatbiologique', 'form_observation', 'occetatbiologique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occmethodedetermination', 'form_observation', 'occmethodedetermination', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occnaturalite', 'form_observation', 'occnaturalite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occsexe', 'form_observation', 'occsexe', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstadedevie', 'form_observation', 'occstadedevie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique', 'form_observation', 'occstatutbiogeographique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstatutbiologique', 'form_observation', 'occstatutbiologique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_table_observation', 'form_autres', 'OGAM_ID_table_observation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee', 'form_standardisation', 'organismegestionnairedonnee', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('organismestandard', 'form_standardisation', 'organismestandard', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('orgtransformation', 'form_standardisation', 'orgtransformation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('precisiongeometrie', 'form_localisation', 'precisiongeometrie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuveexistante', 'form_observation', 'preuveexistante', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuvenonnumerique', 'form_observation', 'preuvenonnumerique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuvenumerique', 'form_observation', 'preuvenumerique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmax', 'form_localisation', 'profondeurmax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmin', 'form_localisation', 'profondeurmin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmoyenne', 'form_localisation', 'profondeurmoyenne', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('PROVIDER_ID', 'form_autres', 'PROVIDER_ID', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('referencebiblio', 'form_standardisation', 'referencebiblio', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('refhabitat', 'form_localisation', 'refhabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensible', 'form_standardisation', 'sensible', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensidateattribution', 'form_standardisation', 'sensidateattribution', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensiniveau', 'form_standardisation', 'sensiniveau', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensireferentiel', 'form_standardisation', 'sensireferentiel', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensiversionreferentiel', 'form_standardisation', 'sensiversionreferentiel', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('statutobservation', 'form_observation', 'statutobservation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('statutsource', 'form_standardisation', 'statutsource', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('SUBMISSION_ID', 'form_autres', 'SUBMISSION_ID', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typedenombrement', 'form_observation', 'typedenombrement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeen', 'form_localisation', 'typeen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeocommune', 'form_localisation', 'typeinfogeocommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement', 'form_localisation', 'typeinfogeodepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeoen', 'form_localisation', 'typeinfogeoen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeomaille', 'form_localisation', 'typeinfogeomaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeome', 'form_localisation', 'typeinfogeome', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeregroupement', 'form_regroupements', 'typeregroupement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateuridentite', 'form_standardisation', 'validateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateurmail', 'form_standardisation', 'validateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateurnomorganisme', 'form_standardisation', 'validateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionen', 'form_localisation', 'versionen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionme', 'form_localisation', 'versionme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionrefhabitat', 'form_localisation', 'versionrefhabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionrefmaille', 'form_localisation', 'versionrefmaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versiontaxref', 'form_observation', 'versiontaxref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensimanuelle', 'form_standardisation', 'sensimanuelle', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensialerte', 'form_standardisation', 'sensialerte', 'table_observation', 'FORM');


--
-- Data for Name: file_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_field VALUES ('OGAM_ID_table_observation', 'file_observation', '1', NULL, 1);
INSERT INTO file_field VALUES ('codecommune', 'file_observation', '0', NULL, 2);
INSERT INTO file_field VALUES ('nomcommune', 'file_observation', '0', NULL, 3);
INSERT INTO file_field VALUES ('anneerefcommune', 'file_observation', '0', 'yyyy', 4);
INSERT INTO file_field VALUES ('typeinfogeocommune', 'file_observation', '0', NULL, 5);
INSERT INTO file_field VALUES ('denombrementmin', 'file_observation', '0', NULL, 6);
INSERT INTO file_field VALUES ('denombrementmax', 'file_observation', '0', NULL, 7);
INSERT INTO file_field VALUES ('objetdenombrement', 'file_observation', '0', NULL, 8);
INSERT INTO file_field VALUES ('typedenombrement', 'file_observation', '0', NULL, 9);
INSERT INTO file_field VALUES ('codedepartement', 'file_observation', '0', NULL, 10);
INSERT INTO file_field VALUES ('anneerefdepartement', 'file_observation', '0', 'yyyy', 11);
INSERT INTO file_field VALUES ('typeinfogeodepartement', 'file_observation', '0', NULL, 12);
INSERT INTO file_field VALUES ('typeen', 'file_observation', '0', NULL, 13);
INSERT INTO file_field VALUES ('codeen', 'file_observation', '0', NULL, 14);
INSERT INTO file_field VALUES ('versionen', 'file_observation', '0', NULL, 15);
INSERT INTO file_field VALUES ('typeinfogeoen', 'file_observation', '0', NULL, 16);
INSERT INTO file_field VALUES ('refhabitat', 'file_observation', '0', NULL, 17);
INSERT INTO file_field VALUES ('codehabitat', 'file_observation', '0', NULL, 18);
INSERT INTO file_field VALUES ('versionrefhabitat', 'file_observation', '0', NULL, 19);
INSERT INTO file_field VALUES ('codehabref', 'file_observation', '0', NULL, 20);
INSERT INTO file_field VALUES ('codemaille', 'file_observation', '0', NULL, 21);
INSERT INTO file_field VALUES ('versionrefmaille', 'file_observation', '0', NULL, 22);
INSERT INTO file_field VALUES ('nomrefmaille', 'file_observation', '0', NULL, 23);
INSERT INTO file_field VALUES ('typeinfogeomaille', 'file_observation', '0', NULL, 24);
INSERT INTO file_field VALUES ('codeme', 'file_observation', '0', NULL, 25);
INSERT INTO file_field VALUES ('versionme', 'file_observation', '0', NULL, 26);
INSERT INTO file_field VALUES ('dateme', 'file_observation', '0', 'yyyy-MM-dd', 27);
INSERT INTO file_field VALUES ('typeinfogeome', 'file_observation', '0', NULL, 28);
INSERT INTO file_field VALUES ('observateurnomorganisme', 'file_observation', '0', NULL, 29);
INSERT INTO file_field VALUES ('observateuridentite', 'file_observation', '0', NULL, 30);
INSERT INTO file_field VALUES ('observateurmail', 'file_observation', '0', NULL, 31);
INSERT INTO file_field VALUES ('determinateurnomorganisme', 'file_observation', '0', NULL, 32);
INSERT INTO file_field VALUES ('determinateuridentite', 'file_observation', '0', NULL, 33);
INSERT INTO file_field VALUES ('determinateurmail', 'file_observation', '0', NULL, 34);
INSERT INTO file_field VALUES ('validateurnomorganisme', 'file_observation', '0', NULL, 35);
INSERT INTO file_field VALUES ('validateuridentite', 'file_observation', '0', NULL, 36);
INSERT INTO file_field VALUES ('validateurmail', 'file_observation', '0', NULL, 37);
INSERT INTO file_field VALUES ('identifiantorigine', 'file_observation', '0', NULL, 38);
INSERT INTO file_field VALUES ('dspublique', 'file_observation', '1', NULL, 39);
INSERT INTO file_field VALUES ('diffusionniveauprecision', 'file_observation', '0', NULL, 40);
INSERT INTO file_field VALUES ('deefloutage', 'file_observation', '0', NULL, 41);
INSERT INTO file_field VALUES ('sensible', 'file_observation', '1', NULL, 42);
INSERT INTO file_field VALUES ('sensiniveau', 'file_observation', '1', NULL, 43);
INSERT INTO file_field VALUES ('sensidateattribution', 'file_observation', '0', 'yyyy-MM-dd''T''HH:mmZ', 44);
INSERT INTO file_field VALUES ('sensireferentiel', 'file_observation', '0', NULL, 45);
INSERT INTO file_field VALUES ('sensiversionreferentiel', 'file_observation', '0', NULL, 46);
INSERT INTO file_field VALUES ('statutsource', 'file_observation', '1', NULL, 47);
INSERT INTO file_field VALUES ('jddcode', 'file_observation', '0', NULL, 48);
INSERT INTO file_field VALUES ('jddid', 'file_observation', '0', NULL, 49);
INSERT INTO file_field VALUES ('jddsourceid', 'file_observation', '0', NULL, 50);
INSERT INTO file_field VALUES ('jddmetadonneedeeid', 'file_observation', '1', NULL, 51);
INSERT INTO file_field VALUES ('organismegestionnairedonnee', 'file_observation', '1', NULL, 52);
INSERT INTO file_field VALUES ('codeidcnpdispositif', 'file_observation', '0', NULL, 53);
INSERT INTO file_field VALUES ('deedatetransformation', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 54);
INSERT INTO file_field VALUES ('deedatedernieremodification', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 55);
INSERT INTO file_field VALUES ('referencebiblio', 'file_observation', '0', NULL, 56);
INSERT INTO file_field VALUES ('orgtransformation', 'file_observation', '0', NULL, 57);
INSERT INTO file_field VALUES ('identifiantpermanent', 'file_observation', '1', NULL, 58);
INSERT INTO file_field VALUES ('statutobservation', 'file_observation', '1', NULL, 59);
INSERT INTO file_field VALUES ('nomcite', 'file_observation', '1', NULL, 60);
INSERT INTO file_field VALUES ('datedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('datefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('heuredatedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('heuredatefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('jourdatedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('jourdatefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('altitudemin', 'file_observation', '0', NULL, 63);
INSERT INTO file_field VALUES ('altitudemax', 'file_observation', '0', NULL, 64);
INSERT INTO file_field VALUES ('profondeurmin', 'file_observation', '0', NULL, 65);
INSERT INTO file_field VALUES ('profondeurmax', 'file_observation', '0', NULL, 66);
INSERT INTO file_field VALUES ('cdnom', 'file_observation', '0', NULL, 67);
INSERT INTO file_field VALUES ('cdref', 'file_observation', '0', NULL, 68);
INSERT INTO file_field VALUES ('versiontaxref', 'file_observation', '0', NULL, 69);
INSERT INTO file_field VALUES ('datedetermination', 'file_observation', '0', 'yyyy-MM-dd''T''HH:mmZ', 70);
INSERT INTO file_field VALUES ('organismestandard', 'file_observation', '0', NULL, 71);
INSERT INTO file_field VALUES ('commentaire', 'file_observation', '0', NULL, 72);
INSERT INTO file_field VALUES ('obsdescription', 'file_observation', '0', NULL, 73);
INSERT INTO file_field VALUES ('obsmethode', 'file_observation', '0', NULL, 74);
INSERT INTO file_field VALUES ('occetatbiologique', 'file_observation', '0', NULL, 75);
INSERT INTO file_field VALUES ('occmethodedetermination', 'file_observation', '0', NULL, 76);
INSERT INTO file_field VALUES ('occnaturalite', 'file_observation', '0', NULL, 77);
INSERT INTO file_field VALUES ('occsexe', 'file_observation', '0', NULL, 78);
INSERT INTO file_field VALUES ('occstadedevie', 'file_observation', '0', NULL, 79);
INSERT INTO file_field VALUES ('occstatutbiologique', 'file_observation', '0', NULL, 80);
INSERT INTO file_field VALUES ('occstatutbiogeographique', 'file_observation', '0', NULL, 81);
INSERT INTO file_field VALUES ('preuveexistante', 'file_observation', '0', NULL, 82);
INSERT INTO file_field VALUES ('preuvenonnumerique', 'file_observation', '0', NULL, 83);
INSERT INTO file_field VALUES ('preuvenumerique', 'file_observation', '0', NULL, 84);
INSERT INTO file_field VALUES ('obscontexte', 'file_observation', '0', NULL, 85);
INSERT INTO file_field VALUES ('identifiantregroupementpermanent', 'file_observation', '0', NULL, 86);
INSERT INTO file_field VALUES ('methoderegroupement', 'file_observation', '0', NULL, 87);
INSERT INTO file_field VALUES ('typeregroupement', 'file_observation', '0', NULL, 88);
INSERT INTO file_field VALUES ('altitudemoyenne', 'file_observation', '0', NULL, 89);
INSERT INTO file_field VALUES ('profondeurmoyenne', 'file_observation', '0', NULL, 90);
INSERT INTO file_field VALUES ('geometrie', 'file_observation', '0', NULL, 91);
INSERT INTO file_field VALUES ('natureobjetgeo', 'file_observation', '0', NULL, 92);
INSERT INTO file_field VALUES ('precisiongeometrie', 'file_observation', '0', NULL, 93);

--
-- Data for Name: form_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_field VALUES ('altitudemax', 'form_localisation', '1', '1', 'NUMERIC', 1, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('altitudemin', 'form_localisation', '1', '1', 'NUMERIC', 2, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('altitudemoyenne', 'form_localisation', '1', '1', 'NUMERIC', 3, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('anneerefcommune', 'form_localisation', '1', '1', 'DATE', 4, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('anneerefdepartement', 'form_localisation', '1', '1', 'DATE', 5, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('cdnom', 'form_observation', '1', '1', 'TAXREF', 6, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('cdref', 'form_observation', '1', '1', 'TAXREF', 7, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codecommune', 'form_localisation', '1', '1', 'SELECT', 8, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codedepartement', 'form_localisation', '1', '1', 'SELECT', 9, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeen', 'form_localisation', '1', '1', 'SELECT', 10, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codehabitat', 'form_localisation', '1', '1', 'SELECT', 11, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codehabref', 'form_localisation', '1', '1', 'SELECT', 12, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeidcnpdispositif', 'form_standardisation', '1', '1', 'SELECT', 13, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codemaille', 'form_localisation', '1', '1', 'SELECT', 14, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeme', 'form_localisation', '1', '1', 'TEXT', 15, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('commentaire', 'form_observation', '1', '1', 'TEXT', 16, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('datedebut', 'form_observation', '1', '1', 'DATE', 17, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('datefin', 'form_observation', '1', '1', 'DATE', 19, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('heuredatedebut', 'form_observation', '1', '1', 'DATE', 17, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('heuredatefin', 'form_observation', '1', '1', 'DATE', 19, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('jourdatedebut', 'form_observation', '1', '1', 'DATE', 17, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('jourdatefin', 'form_observation', '1', '1', 'DATE', 19, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('datedetermination', 'form_observation', '1', '1', 'DATE', 18, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('dateme', 'form_localisation', '1', '1', 'DATE', 20, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deedatedernieremodification', 'form_standardisation', '1', '1', 'DATE', 21, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deedatetransformation', 'form_standardisation', '1', '1', 'DATE', 22, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deefloutage', 'form_standardisation', '1', '1', 'SELECT', 23, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('denombrementmax', 'form_observation', '1', '1', 'NUMERIC', 24, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('denombrementmin', 'form_observation', '1', '1', 'NUMERIC', 25, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateuridentite', 'form_observation', '1', '1', 'TEXT', 26, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateurmail', 'form_observation', '1', '1', 'TEXT', 27, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateurnomorganisme', 'form_observation', '1', '1', 'TEXT', 28, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('diffusionniveauprecision', 'form_standardisation', '1', '1', 'SELECT', 29, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('dspublique', 'form_standardisation', '1', '1', 'SELECT', 30, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('geometrie', 'form_localisation', '1', '1', 'GEOM', 31, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantorigine', 'form_standardisation', '1', '1', 'TEXT', 32, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantpermanent', 'form_standardisation', '1', '1', 'TEXT', 33, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantregroupementpermanent', 'form_regroupements', '1', '1', 'TEXT', 34, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddcode', 'form_standardisation', '1', '1', 'TEXT', 35, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddid', 'form_standardisation', '1', '1', 'TEXT', 36, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddmetadonneedeeid', 'form_standardisation', '1', '1', 'TEXT', 37, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddsourceid', 'form_standardisation', '1', '1', 'TEXT', 38, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('methoderegroupement', 'form_regroupements', '1', '1', 'TEXT', 39, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('natureobjetgeo', 'form_localisation', '1', '1', 'SELECT', 40, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomcite', 'form_observation', '1', '1', 'TEXT', 41, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomcommune', 'form_localisation', '1', '1', 'SELECT', 42, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomrefmaille', 'form_localisation', '1', '1', 'TEXT', 43, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('objetdenombrement', 'form_observation', '1', '1', 'SELECT', 44, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obscontexte', 'form_observation', '1', '1', 'TEXT', 45, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obsdescription', 'form_observation', '1', '1', 'TEXT', 46, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateuridentite', 'form_observation', '1', '1', 'TEXT', 47, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateurmail', 'form_observation', '1', '1', 'TEXT', 48, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateurnomorganisme', 'form_observation', '1', '1', 'TEXT', 49, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obsmethode', 'form_observation', '1', '1', 'SELECT', 50, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occetatbiologique', 'form_observation', '1', '1', 'SELECT', 51, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occmethodedetermination', 'form_observation', '1', '1', 'TEXT', 52, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occnaturalite', 'form_observation', '1', '1', 'SELECT', 53, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occsexe', 'form_observation', '1', '1', 'SELECT', 54, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstadedevie', 'form_observation', '1', '1', 'SELECT', 55, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstatutbiogeographique', 'form_observation', '1', '1', 'SELECT', 56, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstatutbiologique', 'form_observation', '1', '1', 'SELECT', 57, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('OGAM_ID_table_observation', 'form_autres', '1', '1', 'TEXT', 58, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('organismegestionnairedonnee', 'form_standardisation', '1', '1', 'TEXT', 59, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('organismestandard', 'form_standardisation', '1', '1', 'TEXT', 60, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('orgtransformation', 'form_standardisation', '1', '1', 'TEXT', 61, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('precisiongeometrie', 'form_localisation', '1', '1', 'NUMERIC', 62, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuveexistante', 'form_observation', '1', '1', 'SELECT', 63, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuvenonnumerique', 'form_observation', '1', '1', 'TEXT', 64, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuvenumerique', 'form_observation', '1', '1', 'TEXT', 65, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmax', 'form_localisation', '1', '1', 'NUMERIC', 66, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmin', 'form_localisation', '1', '1', 'NUMERIC', 67, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmoyenne', 'form_localisation', '1', '1', 'NUMERIC', 68, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID', 'form_autres', '1', '1', 'SELECT', 69, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('referencebiblio', 'form_standardisation', '1', '1', 'TEXT', 70, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('refhabitat', 'form_localisation', '1', '1', 'SELECT', 71, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensible', 'form_standardisation', '1', '1', 'SELECT', 72, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensidateattribution', 'form_standardisation', '1', '1', 'DATE', 73, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('sensiniveau', 'form_standardisation', '1', '1', 'SELECT', 74, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensireferentiel', 'form_standardisation', '1', '1', 'TEXT', 75, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensiversionreferentiel', 'form_standardisation', '1', '1', 'TEXT', 76, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('statutobservation', 'form_observation', '1', '1', 'SELECT', 77, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('statutsource', 'form_standardisation', '1', '1', 'SELECT', 78, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('SUBMISSION_ID', 'form_autres', '1', '1', 'NUMERIC', 79, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typedenombrement', 'form_observation', '1', '1', 'SELECT', 80, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeen', 'form_localisation', '1', '1', 'SELECT', 81, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeocommune', 'form_localisation', '1', '1', 'SELECT', 82, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeodepartement', 'form_localisation', '1', '1', 'SELECT', 83, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeoen', 'form_localisation', '1', '1', 'SELECT', 84, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeomaille', 'form_localisation', '1', '1', 'SELECT', 85, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeome', 'form_localisation', '1', '1', 'SELECT', 86, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeregroupement', 'form_regroupements', '1', '1', 'SELECT', 87, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateuridentite', 'form_standardisation', '1', '1', 'TEXT', 88, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateurmail', 'form_standardisation', '1', '1', 'TEXT', 89, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateurnomorganisme', 'form_standardisation', '1', '1', 'TEXT', 90, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionen', 'form_localisation', '1', '1', 'DATE', 91, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('versionme', 'form_localisation', '1', '1', 'SELECT', 92, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionrefhabitat', 'form_localisation', '1', '1', 'TEXT', 93, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionrefmaille', 'form_localisation', '1', '1', 'TEXT', 94, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versiontaxref', 'form_observation', '1', '1', 'TEXT', 95, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensimanuelle', 'form_standardisation', '1', '1', 'SELECT', 96, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensialerte', 'form_standardisation', '1', '1', 'SELECT', 97, '0', '0', NULL, NULL, NULL);


--
-- Data for Name: mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO mode VALUES ('PROVIDER_ID', '1', 1, 'organisme A', 'organisme A');

--
-- Data for Name: group_mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--




--
-- Data for Name: table_schema; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_schema VALUES ('RAW_DATA', 'RAW_DATA', 'Données sources', 'Contains raw data');
INSERT INTO table_schema VALUES ('METADATA', 'METADATA', 'Metadata', 'Contains the tables describing the data');
INSERT INTO table_schema VALUES ('WEBSITE', 'WEBSITE', 'Website', 'Contains the tables used to operate the web site');
INSERT INTO table_schema VALUES ('PUBLIC', 'PUBLIC', 'Public', 'Contains the default PostgreSQL tables and PostGIS functions');


--
-- Data for Name: model; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model VALUES ('model_1', 'Std occ taxon dee v1-2-1', 'à ne pas supprimer', 'RAW_DATA', true);

--
-- Data for Name: model_datasets; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_datasets VALUES ('model_1', 'dataset_1');
INSERT INTO model_datasets VALUES ('model_1', 'dataset_2');


--
-- Data for Name: table_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--
INSERT INTO table_format VALUES ('table_observation', 'model_1_observation', 'RAW_DATA', 'OGAM_ID_table_observation, PROVIDER_ID', 'observation', 'table_dee_v1-2-1_observation');


--
-- Data for Name: model_tables; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_tables VALUES ('model_1', 'table_observation');

--
-- Data for Name: process; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: range; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_field VALUES ('SUBMISSION_ID', 'table_observation', 'submission_id', '1', '0', '0', '0', 1, NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID', 'table_observation', 'provider_id', '0', '0', '0', '1', 2, NULL);
INSERT INTO table_field VALUES ('OGAM_ID_table_observation', 'table_observation', 'ogam_id_table_observation', '1', '0', '0', '1', 3, 'séquence');
INSERT INTO table_field VALUES ('codecommune', 'table_observation', 'codecommune', '0', '1', '1', '0', 4, NULL);
INSERT INTO table_field VALUES ('nomcommune', 'table_observation', 'nomcommune', '0', '1', '1', '0', 5, NULL);
INSERT INTO table_field VALUES ('anneerefcommune', 'table_observation', 'anneerefcommune', '0', '1', '1', '0', 6, NULL);
INSERT INTO table_field VALUES ('typeinfogeocommune', 'table_observation', 'typeinfogeocommune', '0', '1', '1', '0', 7, NULL);
INSERT INTO table_field VALUES ('denombrementmin', 'table_observation', 'denombrementmin', '0', '1', '1', '0', 8, NULL);
INSERT INTO table_field VALUES ('denombrementmax', 'table_observation', 'denombrementmax', '0', '1', '1', '0', 9, NULL);
INSERT INTO table_field VALUES ('objetdenombrement', 'table_observation', 'objetdenombrement', '0', '1', '1', '0', 10, NULL);
INSERT INTO table_field VALUES ('typedenombrement', 'table_observation', 'typedenombrement', '0', '1', '1', '0', 11, NULL);
INSERT INTO table_field VALUES ('codedepartement', 'table_observation', 'codedepartement', '0', '1', '1', '0', 12, NULL);
INSERT INTO table_field VALUES ('anneerefdepartement', 'table_observation', 'anneerefdepartement', '0', '1', '1', '0', 13, NULL);
INSERT INTO table_field VALUES ('typeinfogeodepartement', 'table_observation', 'typeinfogeodepartement', '0', '1', '1', '0', 14, NULL);
INSERT INTO table_field VALUES ('typeen', 'table_observation', 'typeen', '0', '1', '1', '0', 15, NULL);
INSERT INTO table_field VALUES ('codeen', 'table_observation', 'codeen', '0', '1', '1', '0', 16, NULL);
INSERT INTO table_field VALUES ('versionen', 'table_observation', 'versionen', '0', '1', '1', '0', 17, NULL);
INSERT INTO table_field VALUES ('typeinfogeoen', 'table_observation', 'typeinfogeoen', '0', '1', '1', '0', 18, NULL);
INSERT INTO table_field VALUES ('refhabitat', 'table_observation', 'refhabitat', '0', '1', '1', '0', 19, NULL);
INSERT INTO table_field VALUES ('codehabitat', 'table_observation', 'codehabitat', '0', '1', '1', '0', 20, NULL);
INSERT INTO table_field VALUES ('versionrefhabitat', 'table_observation', 'versionrefhabitat', '0', '1', '1', '0', 21, NULL);
INSERT INTO table_field VALUES ('codehabref', 'table_observation', 'codehabref', '0', '1', '1', '0', 22, NULL);
INSERT INTO table_field VALUES ('codemaille', 'table_observation', 'codemaille', '0', '1', '1', '0', 23, NULL);
INSERT INTO table_field VALUES ('versionrefmaille', 'table_observation', 'versionrefmaille', '0', '1', '1', '0', 24, NULL);
INSERT INTO table_field VALUES ('nomrefmaille', 'table_observation', 'nomrefmaille', '0', '1', '1', '0', 25, NULL);
INSERT INTO table_field VALUES ('typeinfogeomaille', 'table_observation', 'typeinfogeomaille', '0', '1', '1', '0', 26, NULL);
INSERT INTO table_field VALUES ('codeme', 'table_observation', 'codeme', '0', '1', '1', '0', 27, NULL);
INSERT INTO table_field VALUES ('versionme', 'table_observation', 'versionme', '0', '1', '1', '0', 28, NULL);
INSERT INTO table_field VALUES ('dateme', 'table_observation', 'dateme', '0', '1', '1', '0', 29, NULL);
INSERT INTO table_field VALUES ('typeinfogeome', 'table_observation', 'typeinfogeome', '0', '1', '1', '0', 30, NULL);
INSERT INTO table_field VALUES ('observateurnomorganisme', 'table_observation', 'observateurnomorganisme', '0', '1', '1', '0', 31, NULL);
INSERT INTO table_field VALUES ('observateuridentite', 'table_observation', 'observateuridentite', '0', '1', '1', '0', 32, NULL);
INSERT INTO table_field VALUES ('observateurmail', 'table_observation', 'observateurmail', '0', '1', '1', '0', 33, NULL);
INSERT INTO table_field VALUES ('determinateurnomorganisme', 'table_observation', 'determinateurnomorganisme', '0', '1', '1', '0', 34, NULL);
INSERT INTO table_field VALUES ('determinateuridentite', 'table_observation', 'determinateuridentite', '0', '1', '1', '0', 35, NULL);
INSERT INTO table_field VALUES ('determinateurmail', 'table_observation', 'determinateurmail', '0', '1', '1', '0', 36, NULL);
INSERT INTO table_field VALUES ('validateurnomorganisme', 'table_observation', 'validateurnomorganisme', '0', '1', '1', '0', 37, NULL);
INSERT INTO table_field VALUES ('validateuridentite', 'table_observation', 'validateuridentite', '0', '1', '1', '0', 38, NULL);
INSERT INTO table_field VALUES ('validateurmail', 'table_observation', 'validateurmail', '0', '1', '1', '0', 39, NULL);
INSERT INTO table_field VALUES ('identifiantorigine', 'table_observation', 'identifiantorigine', '0', '1', '1', '0', 40, NULL);
INSERT INTO table_field VALUES ('dspublique', 'table_observation', 'dspublique', '0', '1', '1', '1', 41, NULL);
INSERT INTO table_field VALUES ('diffusionniveauprecision', 'table_observation', 'diffusionniveauprecision', '0', '1', '1', '0', 42, NULL);
INSERT INTO table_field VALUES ('deefloutage', 'table_observation', 'deefloutage', '0', '1', '1', '0', 43, NULL);
INSERT INTO table_field VALUES ('sensible', 'table_observation', 'sensible', '0', '1', '1', '1', 44, NULL);
INSERT INTO table_field VALUES ('sensiniveau', 'table_observation', 'sensiniveau', '0', '1', '1', '1', 45, NULL);
INSERT INTO table_field VALUES ('sensidateattribution', 'table_observation', 'sensidateattribution', '0', '1', '1', '0', 46, NULL);
INSERT INTO table_field VALUES ('sensireferentiel', 'table_observation', 'sensireferentiel', '0', '1', '1', '0', 47, NULL);
INSERT INTO table_field VALUES ('sensiversionreferentiel', 'table_observation', 'sensiversionreferentiel', '0', '1', '1', '0', 48, NULL);
INSERT INTO table_field VALUES ('statutsource', 'table_observation', 'statutsource', '0', '1', '1', '1', 49, NULL);
INSERT INTO table_field VALUES ('jddcode', 'table_observation', 'jddcode', '0', '1', '1', '0', 50, NULL);
INSERT INTO table_field VALUES ('jddid', 'table_observation', 'jddid', '0', '1', '1', '0', 51, NULL);
INSERT INTO table_field VALUES ('jddsourceid', 'table_observation', 'jddsourceid', '0', '1', '1', '0', 52, NULL);
INSERT INTO table_field VALUES ('jddmetadonneedeeid', 'table_observation', 'jddmetadonneedeeid', '0', '1', '1', '1', 53, NULL);
INSERT INTO table_field VALUES ('organismegestionnairedonnee', 'table_observation', 'organismegestionnairedonnee', '0', '1', '1', '1', 54, NULL);
INSERT INTO table_field VALUES ('codeidcnpdispositif', 'table_observation', 'codeidcnpdispositif', '0', '1', '1', '0', 55, NULL);
INSERT INTO table_field VALUES ('deedatetransformation', 'table_observation', 'deedatetransformation', '0', '1', '1', '1', 56, NULL);
INSERT INTO table_field VALUES ('deedatedernieremodification', 'table_observation', 'deedatedernieremodification', '0', '1', '1', '1', 57, NULL);
INSERT INTO table_field VALUES ('referencebiblio', 'table_observation', 'referencebiblio', '0', '1', '1', '0', 58, NULL);
INSERT INTO table_field VALUES ('orgtransformation', 'table_observation', 'orgtransformation', '0', '1', '1', '1', 59, NULL);
INSERT INTO table_field VALUES ('identifiantpermanent', 'table_observation', 'identifiantpermanent', '0', '1', '1', '1', 60, NULL);
INSERT INTO table_field VALUES ('statutobservation', 'table_observation', 'statutobservation', '0', '1', '1', '1', 61, NULL);
INSERT INTO table_field VALUES ('nomcite', 'table_observation', 'nomcite', '0', '1', '1', '1', 62, NULL);
INSERT INTO table_field VALUES ('datedebut', 'table_observation', 'datedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('datefin', 'table_observation', 'datefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('heuredatedebut', 'table_observation', 'heuredatedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('heuredatefin', 'table_observation', 'heuredatefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('jourdatedebut', 'table_observation', 'jourdatedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('jourdatefin', 'table_observation', 'jourdatefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('altitudemin', 'table_observation', 'altitudemin', '0', '1', '1', '0', 65, NULL);
INSERT INTO table_field VALUES ('altitudemax', 'table_observation', 'altitudemax', '0', '1', '1', '0', 66, NULL);
INSERT INTO table_field VALUES ('profondeurmin', 'table_observation', 'profondeurmin', '0', '1', '1', '0', 67, NULL);
INSERT INTO table_field VALUES ('profondeurmax', 'table_observation', 'profondeurmax', '0', '1', '1', '0', 68, NULL);
INSERT INTO table_field VALUES ('cdnom', 'table_observation', 'cdnom', '0', '1', '1', '0', 69, NULL);
INSERT INTO table_field VALUES ('cdref', 'table_observation', 'cdref', '0', '1', '1', '0', 70, NULL);
INSERT INTO table_field VALUES ('versiontaxref', 'table_observation', 'versiontaxref', '0', '1', '1', '0', 71, NULL);
INSERT INTO table_field VALUES ('datedetermination', 'table_observation', 'datedetermination', '0', '1', '1', '0', 72, NULL);
INSERT INTO table_field VALUES ('organismestandard', 'table_observation', 'organismestandard', '0', '1', '1', '0', 73, NULL);
INSERT INTO table_field VALUES ('commentaire', 'table_observation', 'commentaire', '0', '1', '1', '0', 74, NULL);
INSERT INTO table_field VALUES ('obsdescription', 'table_observation', 'obsdescription', '0', '1', '1', '0', 75, NULL);
INSERT INTO table_field VALUES ('obsmethode', 'table_observation', 'obsmethode', '0', '1', '1', '0', 76, NULL);
INSERT INTO table_field VALUES ('occetatbiologique', 'table_observation', 'occetatbiologique', '0', '1', '1', '0', 77, NULL);
INSERT INTO table_field VALUES ('occstatutbiogeographique', 'table_observation', 'occstatutbiogeographique', '0', '1', '1', '0', 78, NULL);
INSERT INTO table_field VALUES ('occmethodedetermination', 'table_observation', 'occmethodedetermination', '0', '1', '1', '0', 79, NULL);
INSERT INTO table_field VALUES ('occnaturalite', 'table_observation', 'occnaturalite', '0', '1', '1', '0', 80, NULL);
INSERT INTO table_field VALUES ('occsexe', 'table_observation', 'occsexe', '0', '1', '1', '0', 81, NULL);
INSERT INTO table_field VALUES ('occstadedevie', 'table_observation', 'occstadedevie', '0', '1', '1', '0', 82, NULL);
INSERT INTO table_field VALUES ('occstatutbiologique', 'table_observation', 'occstatutbiologique', '0', '1', '1', '0', 83, NULL);
INSERT INTO table_field VALUES ('preuveexistante', 'table_observation', 'preuveexistante', '0', '1', '1', '0', 84, NULL);
INSERT INTO table_field VALUES ('preuvenonnumerique', 'table_observation', 'preuvenonnumerique', '0', '1', '1', '0', 85, NULL);
INSERT INTO table_field VALUES ('preuvenumerique', 'table_observation', 'preuvenumerique', '0', '1', '1', '0', 86, NULL);
INSERT INTO table_field VALUES ('obscontexte', 'table_observation', 'obscontexte', '0', '1', '1', '0', 87, NULL);
INSERT INTO table_field VALUES ('identifiantregroupementpermanent', 'table_observation', 'identifiantregroupementpermanent', '0', '1', '1', '0', 88, NULL);
INSERT INTO table_field VALUES ('methoderegroupement', 'table_observation', 'methoderegroupement', '0', '1', '1', '0', 89, NULL);
INSERT INTO table_field VALUES ('typeregroupement', 'table_observation', 'typeregroupement', '0', '1', '1', '0', 90, NULL);
INSERT INTO table_field VALUES ('altitudemoyenne', 'table_observation', 'altitudemoyenne', '0', '1', '1', '0', 91, NULL);
INSERT INTO table_field VALUES ('profondeurmoyenne', 'table_observation', 'profondeurmoyenne', '0', '1', '1', '0', 92, NULL);
INSERT INTO table_field VALUES ('geometrie', 'table_observation', 'geometrie', '1', '1', '1', '0', 93, NULL);
INSERT INTO table_field VALUES ('natureobjetgeo', 'table_observation', 'natureobjetgeo', '0', '1', '1', '0', 94, NULL);
INSERT INTO table_field VALUES ('precisiongeometrie', 'table_observation', 'precisiongeometrie', '0', '1', '1', '0', 95, NULL);
INSERT INTO table_field VALUES ('sensimanuelle', 'table_observation', 'sensimanuelle', '1', '1', '0', '1', 96, NULL);
INSERT INTO table_field VALUES ('sensialerte', 'table_observation', 'sensialerte', '1', '1', '0', '1', 97, NULL);

--
-- Data for Name: table_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_tree VALUES ('RAW_DATA', 'table_observation', '*', NULL, NULL);


--
-- Data for Name: translation; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO translation VALUES ('table_observation', 'PROVIDER_ID', 'FR', 'Organisme', 'L''organisme');
INSERT INTO translation VALUES ('table_observation', 'SUBMISSION_ID', 'FR', 'Identifiant de soumission', 'L''identifiant de soumission');
INSERT INTO translation VALUES ('table_observation', 'OGAM_ID_table_observation', 'FR', 'Observation', 'L''identifiant de l''observation');
INSERT INTO translation VALUES ('table_observation', 'PROVIDER_ID', 'EN', 'The identifier of the provider', 'The identifier of the provider');
INSERT INTO translation VALUES ('table_observation', 'SUBMISSION_ID', 'EN', 'Submission ID', 'The identifier of a submission');
INSERT INTO translation VALUES ('table_observation', 'OGAM_ID_table_observation', 'EN', 'Observation', 'The identifier of a observation');


-- Purge metadata_work schema 
SET search_path = metadata_work;

delete from translation;
delete from table_tree;

delete from dataset_fields;
delete from dataset_files;
delete from dataset_forms;
delete from model_tables;
delete from model_datasets;

delete from file_field;
delete from table_field;
delete from form_field;
delete from field_mapping;
delete from field;
delete from file_format;
delete from table_format;
delete from form_format;
delete from format;

delete from dynamode;
delete from group_mode;
delete from mode;
delete from range;

delete from data;

delete from unit;

delete from checks where check_id <= 1200;

delete from model;
delete from table_schema;
delete from dataset;

-- Data for Name: checks; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO checks VALUES (1000, 'COMPLIANCE', 'EMPTY_FILE_ERROR', 'Fichier vide.', 'Les fichiers ne doivent pas être vides.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1001, 'COMPLIANCE', 'WRONG_FIELD_NUMBER', 'Nombre de champs incorrect.', 'Le fichier doit contenir le bon nombre de champs, séparés par des points-virgules et aucun ne doit contenir de point-virgule.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1002, 'COMPLIANCE', 'INTEGRITY_CONSTRAINT', 'Contrainte d''intégrité non respectée.', 'La valeur de la clé étrangère n''existe pas dans la table mère.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1003, 'COMPLIANCE', 'UNEXPECTED_SQL_ERROR', 'Erreur SQL non répertoriée.', 'Erreur SQL non répertoriée, veuillez contacter l''administrateur.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1004, 'COMPLIANCE', 'DUPLICATE_ROW', 'Ligne dupliquée.', 'Ligne dupliquée. La donnée existe déjà.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1101, 'COMPLIANCE', 'MANDATORY_FIELD_MISSING', 'Champ obligatoire manquant.', 'Champ obligatoire manquant, veuillez indiquer une valeur.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1102, 'COMPLIANCE', 'INVALID_FORMAT', 'Format non respecté.', 'Le format du champ ne correspond pas au format attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1103, 'COMPLIANCE', 'INVALID_TYPE_FIELD', 'Type de champ erroné.', 'Le type du champ ne correspond pas au type attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1104, 'COMPLIANCE', 'INVALID_DATE_FIELD', 'Date erronée.', 'Le format de la date est erroné, veuillez respecter le format indiqué.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1105, 'COMPLIANCE', 'INVALID_CODE_FIELD', 'Code erroné.', 'Le code du champ ne correspond pas au code attendu.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1106, 'COMPLIANCE', 'INVALID_RANGE_FIELD', 'Valeur du champ hors limites.', 'La valeur du champ n''entre pas dans la plage attendue (min et max).', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1107, 'COMPLIANCE', 'STRING_TOO_LONG', 'Chaîne de caractères trop longue.', 'La valeur du champ comporte trop de caractères.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1108, 'COMPLIANCE', 'UNDEFINED_COLUMN', 'Colonne indéfinie.', 'Colonne indéfinie.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1109, 'COMPLIANCE', 'NO_MAPPING', 'Pas de mapping pour ce champ.', 'Le champ dans le fichier n''a pas de colonne de destination dans une table en base.', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1110, 'COMPLIANCE', 'TRIGGER_EXCEPTION', 'Valeur incorrecte.', 'La valeur donnée n''est pas reconnue et empêche l''exécution du code (remplissage automatique de champs).', NULL, 'ERROR', '2016-04-11 10:07:06.861496');
INSERT INTO checks VALUES (1, 'CONFORMITY    ', 'jddmetadonneedeeid', 'jddmetadonneedeeid', 'La métadonnée associée est inexistante.', 'SELECT raw_data.check_jddMetadonneeDEEId_exists(?submissionid?);', 'ERROR', '2016-04-11 10:07:06.861496');


--
-- Data for Name: checks_per_provider; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: unit; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO unit VALUES ('Integer', 'INTEGER', NULL, 'integer', NULL);
INSERT INTO unit VALUES ('Decimal', 'NUMERIC', NULL, 'float', NULL);
INSERT INTO unit VALUES ('CharacterString', 'STRING', NULL, 'text', NULL);
INSERT INTO unit VALUES ('Date', 'DATE', NULL, 'date', NULL);
INSERT INTO unit VALUES ('DateTime', 'DATE', NULL, 'date time', NULL);
INSERT INTO unit VALUES ('BOOLEAN', 'BOOLEAN', NULL, 'boolean', NULL);
INSERT INTO unit VALUES ('GEOM', 'GEOM', NULL, 'The geometrical position of an observation', 'The geometrical position of an observation');
INSERT INTO unit VALUES ('PROVIDER_ID', 'CODE', 'DYNAMIC', 'fournisseur de données', 'fournisseur de données');
INSERT INTO unit VALUES ('region', 'ARRAY', 'DYNAMIC', '[Liste] Région', 'Région');
INSERT INTO unit VALUES ('StatutSourceValue', 'CODE', 'DYNAMIC', 'Statut de la source', 'Statut de la source');
INSERT INTO unit VALUES ('DSPubliqueValue', 'CODE', 'DYNAMIC', 'DS de la DEE publique ou privée', 'DS de la DEE publique ou privée');
INSERT INTO unit VALUES ('StatutObservationValue', 'CODE', 'DYNAMIC', 'Statut de l''observation', 'Statut de l''observation');
INSERT INTO unit VALUES ('TaxRefValue', 'CODE', 'TAXREF', 'Code cd_nom du taxon', 'Code cd_nom du taxon');
INSERT INTO unit VALUES ('ObjetDenombrementValue', 'CODE', 'DYNAMIC', 'Objet du dénombrement', 'Objet du dénombrement');
INSERT INTO unit VALUES ('TypeDenombrementValue', 'CODE', 'DYNAMIC', 'Méthode de dénombrement', 'Méthode de dénombrement');
INSERT INTO unit VALUES ('CodeHabitatValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de l''habitat du taxon', 'Code de l''habitat du taxon');
INSERT INTO unit VALUES ('CodeRefHabitatValue', 'ARRAY', 'DYNAMIC', '[Liste] Référentiel identifiant l''habitat', 'Référentiel identifiant l''habitat');
INSERT INTO unit VALUES ('NatureObjetGeoValue', 'CODE', 'DYNAMIC', 'Nature de l’objet géographique ', 'Nature de l’objet géographique ');
INSERT INTO unit VALUES ('CodeMailleValue', 'ARRAY', 'DYNAMIC', '[Liste] Maille INPN 10*10 kms', 'Maille INPN 10*10 kms');
INSERT INTO unit VALUES ('CodeCommuneValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de la commune', 'Code de la commune');
INSERT INTO unit VALUES ('NomCommuneValue', 'ARRAY', 'DYNAMIC', '[Liste] Nom de la commune', 'Nom de la commune');
INSERT INTO unit VALUES ('CodeENValue', 'ARRAY', 'DYNAMIC', '[Liste] Code de l''espace naturel', 'Code de l''espace naturel');
INSERT INTO unit VALUES ('TypeENValue', 'ARRAY', 'DYNAMIC', '[Liste] Type d''espace naturel oude zonage', 'Type d''espace naturel oude zonage');
INSERT INTO unit VALUES ('CodeDepartementValue', 'ARRAY', 'DYNAMIC', '[Liste] Code INSEE du département', 'Code INSEE du département');
INSERT INTO unit VALUES ('CodeHabRefValue', 'ARRAY', 'DYNAMIC', '[Liste] Code HABREF de l''habitat', 'Code HABREF de l''habitat');
INSERT INTO unit VALUES ('IDCNPValue', 'CODE', 'DYNAMIC', 'Code dispositif de collecte', 'Code dispositif de collecte');
INSERT INTO unit VALUES ('TypeInfoGeoValue', 'CODE', 'DYNAMIC', 'Type d''information géographique', 'Type d''information géographique');
INSERT INTO unit VALUES ('VersionMasseDEauValue', 'CODE', 'DYNAMIC', 'Version du référentiel Masse d''Eau', 'Version du référentiel Masse d''Eau');
INSERT INTO unit VALUES ('NiveauPrecisionValue', 'CODE', 'DYNAMIC', 'Niveau maximal de diffusion', 'Niveau maximal de diffusion');
INSERT INTO unit VALUES ('DEEFloutageValue', 'CODE', 'DYNAMIC', 'Floutage transformation DEE', 'Floutage transformation DEE');
INSERT INTO unit VALUES ('SensibleValue', 'CODE', 'DYNAMIC', 'Observation sensible', 'Observation sensible');
INSERT INTO unit VALUES ('SensibiliteValue', 'CODE', 'DYNAMIC', 'Degré de sensibilité', 'Degré de sensibilité');
INSERT INTO unit VALUES ('TypeRegroupementValue', 'CODE', 'DYNAMIC', 'Type de regroupement', 'Type de regroupement');
INSERT INTO unit VALUES ('OccurrenceNaturalisteValue', 'CODE', 'DYNAMIC', 'Naturalité de l''occurrence', 'Naturalité de l''occurrence');
INSERT INTO unit VALUES ('OccurrenceSexeValue', 'CODE', 'DYNAMIC', 'Sexe', 'Sexe');
INSERT INTO unit VALUES ('OccurrenceStadeDeVieValue', 'CODE', 'DYNAMIC', 'Stade de développement', 'Stade de développement');
INSERT INTO unit VALUES ('OccurrenceStatutBiologiqueValue', 'CODE', 'DYNAMIC', 'Comportement', 'Comportement');
INSERT INTO unit VALUES ('PreuveExistanteValue', 'CODE', 'DYNAMIC', 'Preuve de l''existance', 'Preuve de l''existance');
INSERT INTO unit VALUES ('ObservationMethodeValue', 'CODE', 'DYNAMIC', 'Méthode d''observation', 'Méthode d''observation');
INSERT INTO unit VALUES ('OccurrenceEtatBiologiqueValue', 'CODE', 'DYNAMIC', 'Code de l''état biologique', 'Code de l''état biologique');
INSERT INTO unit VALUES ('OccurrenceStatutBiogeographiqueValue', 'CODE', 'DYNAMIC', 'Code de l''état biogéographique', 'Code de l''état biogéographique');
INSERT INTO unit VALUES ('SensiManuelleValue', 'CODE', 'DYNAMIC', 'Mode de calcul de la sensibilité', 'Mode de calcul de la sensibilité');
INSERT INTO unit VALUES ('SensiAlerteValue', 'CODE', 'DYNAMIC', 'Alerte calcul sensibilité', 'Alerte calcul sensibilité');

--
-- Data for Name: data; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO data VALUES ('PROVIDER_ID', 'PROVIDER_ID', 'Organisme utilisateur', 'Organisme de l''utilisateur authentifié', NULL);
INSERT INTO data VALUES ('SUBMISSION_ID', 'Integer', 'Identifiant de la soumission', 'Identifiant de la soumission', NULL);
INSERT INTO data VALUES ('OGAM_ID_table_observation', 'CharacterString', 'Clé primaire table observation', 'Clé primaire table observation', NULL);
INSERT INTO data VALUES ('codecommune', 'CodeCommuneValue', 'codeCommune', 'Code de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur. ', NULL);
INSERT INTO data VALUES ('nomcommune', 'NomCommuneValue', 'nomCommune', 'Libellé de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur.', NULL);
INSERT INTO data VALUES ('anneerefcommune', 'Date', 'anneeRefCommune', 'Année de production du référentiel INSEE, qui sert à déterminer quel est le référentiel en vigueur pour le code et le nom de la commune.', NULL);
INSERT INTO data VALUES ('typeinfogeocommune', 'TypeInfoGeoValue', 'typeInfoGeoCommune', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('denombrementmin', 'Integer', 'denombrementMin', 'Nombre minimum d''individus du taxon composant l''observation.', NULL);
INSERT INTO data VALUES ('denombrementmax', 'Integer', 'denombrementMax', 'Nombre maximum d''individus du taxon composant l''observation.', NULL);
INSERT INTO data VALUES ('objetdenombrement', 'ObjetDenombrementValue', 'objetDenombrement', 'Objet sur lequel porte le dénombrement.', NULL);
INSERT INTO data VALUES ('typedenombrement', 'TypeDenombrementValue', 'typeDenombrement', 'Méthode utilisée pour le dénombrement (Inspire).', NULL);
INSERT INTO data VALUES ('codedepartement', 'CodeDepartementValue', 'codeDepartement', 'Code INSEE en vigueur suivant l''année du référentiel INSEE des départements, auquel l''information est rattachée.', NULL);
INSERT INTO data VALUES ('anneerefdepartement', 'Date', 'anneeRefDepartement', 'Année du référentiel INSEE utilisé.', NULL);
INSERT INTO data VALUES ('typeinfogeodepartement', 'TypeInfoGeoValue', 'typeInfoGeoDepartement', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('typeen', 'TypeENValue', 'typeEN', 'Indique le type d’espace naturel protégé, ou de zonage (Natura 2000, Znieff1, Znieff2).', NULL);
INSERT INTO data VALUES ('codeen', 'CodeENValue', 'codeEN', 'Code de l’espace naturel sur lequel a été faite l’observation, en fonction du type d''espace naturel.', NULL);
INSERT INTO data VALUES ('versionen', 'Date', 'versionEN', 'Version du référentiel consulté respectant la norme ISO 8601, sous la forme YYYY-MM-dd (année-mois-jour), YYYY-MM (année-mois), ou YYYY (année).', NULL);
INSERT INTO data VALUES ('typeinfogeoen', 'TypeInfoGeoValue', 'typeInfoGeoEN', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('refhabitat', 'CodeRefHabitatValue', 'refHabitat', 'RefHabitat correspond au référentiel utilisé pour identifier l''habitat de l''observation. Il est codé selon les acronymes utilisés sur le site de l''INPN mettant à disposition en téléchargement les référentiels "habitats" et "typologies".', NULL);
INSERT INTO data VALUES ('codehabitat', 'CodeHabitatValue', 'codeHabitat', 'Code métier de l''habitat où le taxon de l''observation a été identifié. Le référentiel Habitat est indiqué dans le champ « RefHabitat ». Il peut être trouvé dans la colonne "LB_CODE" d''HABREF.', NULL);
INSERT INTO data VALUES ('versionrefhabitat', 'CharacterString', 'versionRefHabitat', 'Version du référentiel utilisé (suivant la norme ISO 8601, sous la forme YYYY-MM-dd, YYYY-MM, ou YYYY).', NULL);
INSERT INTO data VALUES ('codehabref', 'CodeHabRefValue', 'codeHabRef', 'Code HABREF de l''habitat où le taxon de l''observation a été identifié. Il peut être trouvé dans la colonne "CD_HAB" d''HabRef.', NULL);
INSERT INTO data VALUES ('codemaille', 'CodeMailleValue', 'codeMaille', 'Code de la cellule de la grille de référence nationale 10kmx10km dans laquelle se situe l’observation.', NULL);
INSERT INTO data VALUES ('versionrefmaille', 'CharacterString', 'versionRefMaille', 'Version du référentiel des mailles utilisé.', NULL);
INSERT INTO data VALUES ('nomrefmaille', 'CharacterString', 'nomRefMaille', 'Nom de la couche de maille utilisée : Concaténation des éléments des colonnes "couche" et "territoire" de la page http://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref.', NULL);
INSERT INTO data VALUES ('typeinfogeomaille', 'TypeInfoGeoValue', 'typeInfoGeoMaille', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('codeme', 'CharacterString', 'codeME', 'Code de la ou les masse(s) d''eau à la (aux)quelle(s) l''observation a été rattachée.', NULL);
INSERT INTO data VALUES ('versionme', 'VersionMasseDEauValue', 'versionME', 'Version du référentiel masse d''eau utilisé et prélevé sur le site du SANDRE, telle que décrite sur le site du SANDRE.', NULL);
INSERT INTO data VALUES ('dateme', 'Date', 'dateME', 'Date de consultation ou de prélèvement du référentiel sur le site du SANDRE.', NULL);
INSERT INTO data VALUES ('typeinfogeome', 'TypeInfoGeoValue', 'typeInfoGeoME', 'Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.', NULL);
INSERT INTO data VALUES ('geometrie', 'GEOM', 'geometrie', 'La géométrie de la localisationl (au format WKT)', NULL);
INSERT INTO data VALUES ('natureobjetgeo', 'NatureObjetGeoValue', 'natureObjetGeo', 'Nature de la localisation transmise ', NULL);
INSERT INTO data VALUES ('precisiongeometrie', 'Integer', 'precisionGeometrie', 'Estimation en mètres d’une zone tampon autour de l''objet géographique. Cette précision peut inclure la précision du moyen technique d’acquisition des coordonnées (GPS,…) et/ou du protocole naturaliste.', NULL);
INSERT INTO data VALUES ('observateurnomorganisme', 'CharacterString', 'observateurNomOrganisme', 'Organisme(s) de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('observateuridentite', 'CharacterString', 'observateurIdentite', 'Nom(s), prénom de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('observateurmail', 'CharacterString', 'observateurMail', 'Mail(s) de la ou des personnes ayant réalisé l''observation.', NULL);
INSERT INTO data VALUES ('determinateurnomorganisme', 'CharacterString', 'determinateurNomOrganisme', 'Organisme de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('determinateuridentite', 'CharacterString', 'determinateurIdentite', 'Prénom, nom de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('determinateurmail', 'CharacterString', 'determinateurMail', 'Mail de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.', NULL);
INSERT INTO data VALUES ('validateurnomorganisme', 'CharacterString', 'validateurNomOrganisme', 'Organisme de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('validateuridentite', 'CharacterString', 'validateurIdentite', 'Prénom, nom de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('validateurmail', 'CharacterString', 'validateurMail', 'Mail de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.', NULL);
INSERT INTO data VALUES ('identifiantorigine', 'CharacterString', 'identifiantOrigine', 'Identifiant unique de la Donnée Source de l’observation dans la base de données du producteur où est stockée et initialement gérée la Donnée Source. La DS est caractérisée par jddId et/ou jddCode,.', NULL);
INSERT INTO data VALUES ('dspublique', 'DSPubliqueValue', 'dSPublique', 'Indique explicitement si la DS de la DEE est publique ou privée. Définit uniquement les droits nécessaires et suffisants des DS pour produire une DEE. Ne doit être utilisé que pour indiquer si la DEE résultante est susceptible d’être floutée.', NULL);
INSERT INTO data VALUES ('obsmethode', 'ObservationMethodeValue', 'obsMethode', 'Indique de quelle manière on a pu constater la présence d''un sujet d''observation.', NULL);
INSERT INTO data VALUES ('diffusionniveauprecision', 'NiveauPrecisionValue', 'diffusionNiveauPrecision', 'Niveau maximal de précision de la diffusion souhaitée par le producteur vers le grand public. Ne concerne que les DEE non sensibles.', NULL);
INSERT INTO data VALUES ('deefloutage', 'DEEFloutageValue', 'dEEFloutage', 'Indique si un floutage a été effectué lors de la transformation en DEE. Cela ne concerne que des données d''origine privée.', NULL);
INSERT INTO data VALUES ('sensible', 'SensibleValue', 'sensible', 'Indique si l''observation est sensible d''après les principes du SINP. Va disparaître.', NULL);
INSERT INTO data VALUES ('sensiniveau', 'SensibiliteValue', 'sensiNiveau', 'Indique si l''observation ou le regroupement est sensible d''après les principes du SINP et à quel degré. La manière de déterminer la sensibilité est définie dans le guide technique des données sensibles disponible sur la plate-forme naturefrance.', NULL);
INSERT INTO data VALUES ('sensidateattribution', 'DateTime', 'sensiDateAttribution', 'Date à laquelle on a attribué un niveau de sensibilité à la donnée. C''est également la date à laquelle on a consulté le référentiel de sensibilité associé.', NULL);
INSERT INTO data VALUES ('sensireferentiel', 'CharacterString', 'sensiReferentiel', 'Référentiel de sensibilité consulté lors de l''attribution du niveau de sensibilité.', NULL);
INSERT INTO data VALUES ('sensiversionreferentiel', 'CharacterString', 'sensiVersionReferentiel', 'Version du référentiel consulté. Peut être une date si le référentiel n''a pas de numéro de version. Doit être rempli par "NON EXISTANTE" si un référentiel n''existait pas au moment de l''attribution de la sensibilité par un Organisme.', NULL);
INSERT INTO data VALUES ('statutsource', 'StatutSourceValue', 'statutSource', 'Indique si la DS de l’observation provient directement du terrain (via un document informatisé ou une base de données), d''une collection, de la littérature, ou n''est pas connu.', NULL);
INSERT INTO data VALUES ('jddcode', 'CharacterString', 'jddCode', 'Nom, acronyme, ou code de la collection du jeu de données dont provient la donnée source.', NULL);
INSERT INTO data VALUES ('jddid', 'CharacterString', 'jddId', 'Identifiant pour la collection ou le jeu de données source d''où provient l''enregistrement.', NULL);
INSERT INTO data VALUES ('jddsourceid', 'CharacterString', 'jddSourceId', 'Il peut arriver, pour un besoin d''inventaire, par exemple, qu''on réutilise une donnée en provenance d''un autre jeu de données DEE déjà existant au sein du SINP.', NULL);
INSERT INTO data VALUES ('jddmetadonneedeeid', 'CharacterString', 'jddMetadonneeDEEId', 'Identifiant permanent et unique de la fiche métadonnées du jeu de données auquel appartient la donnée.', NULL);
INSERT INTO data VALUES ('organismegestionnairedonnee', 'CharacterString', 'organismeGestionnaireDonnee', 'Nom de l’organisme qui détient la Donnée Source (DS) de la DEE et qui en a la responsabilité. Si plusieurs organismes sont nécessaires, les séparer par des virgules.', NULL);
INSERT INTO data VALUES ('codeidcnpdispositif', 'IDCNPValue', 'codeIDCNPDispositif', 'Code du dispositif de collecte dans le cadre duquel la donnée a été collectée.', NULL);
INSERT INTO data VALUES ('deedatetransformation', 'DateTime', 'dEEDateTransformation', 'Date de transformation de la donnée source (DSP ou DSR) en donnée élémentaire d''échange (DEE).', NULL);
INSERT INTO data VALUES ('deedatedernieremodification', 'DateTime', 'dEEDateDerniereModification', 'Date de dernière modification de la donnée élémentaire d''échange. Postérieure à la date de transformation en DEE, égale dans le cas de l''absence de modification.', NULL);
INSERT INTO data VALUES ('referencebiblio', 'CharacterString', 'referenceBiblio', 'Référence de la source de l’observation lorsque celle-ci est de type « Littérature », au format ISO690. La référence bibliographique doit concerner l''observation même et non uniquement le taxon ou le protocole.', NULL);
INSERT INTO data VALUES ('orgtransformation', 'CharacterString', 'orgTransformation', 'Nom de l''organisme ayant créé la DEE finale (plate-forme ou organisme mandaté par elle).', NULL);
INSERT INTO data VALUES ('identifiantpermanent', 'CharacterString', 'identifiantPermanent', 'Identifiant unique et pérenne de la Donnée Elémentaire d’Echange de l''observation dans le SINP attribué par la plateforme régionale ou thématique.', NULL);
INSERT INTO data VALUES ('statutobservation', 'StatutObservationValue', 'statutObservation', 'Indique si le taxon a été observé directement ou indirectement (indices de présence), ou non observé ', NULL);
INSERT INTO data VALUES ('nomcite', 'CharacterString', 'nomCite', 'Nom du taxon cité à l’origine par l’observateur. Celui-ci peut être le nom scientifique reprenant idéalement en plus du nom latin, l’auteur et la date. ', NULL);
INSERT INTO data VALUES ('datedebut', 'DateTime', 'dateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('datefin', 'DateTime', 'dateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('heuredatedebut', 'DateTime', 'heuredateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('heuredatefin', 'DateTime', 'heuredateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('jourdatedebut', 'DateTime', 'jourdateDebut', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('jourdatefin', 'DateTime', 'jourdateFin', 'Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.', NULL);
INSERT INTO data VALUES ('altitudemin', 'Decimal', 'altitudeMin', 'Altitude minimum de l’observation en mètres.', NULL);
INSERT INTO data VALUES ('altitudemax', 'Decimal', 'altitudeMax', 'Altitude maximum de l’observation en mètres.', NULL);
INSERT INTO data VALUES ('profondeurmin', 'Decimal', 'profondeurmin', 'Profondeur minimale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).', NULL);
INSERT INTO data VALUES ('profondeurmax', 'Decimal', 'profondeurmax', 'Profondeur maximale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).', NULL);
INSERT INTO data VALUES ('cdnom', 'TaxRefValue', 'cdNom', 'Code du taxon « cd_nom » de TaxRef référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.', NULL);
INSERT INTO data VALUES ('cdref', 'TaxRefValue', 'cdRef', 'Code du taxon « cd_ref » de TAXREF référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.', NULL);
INSERT INTO data VALUES ('versiontaxref', 'CharacterString', 'versionTAXREF', 'Version du référentiel TAXREF utilisée pour le cdNom et le cdRef.', NULL);
INSERT INTO data VALUES ('datedetermination', 'DateTime', 'dateDetermination', 'Date/heure de la dernière détermination du taxon de l’observation dans le système grégorien.', NULL);
INSERT INTO data VALUES ('organismestandard', 'CharacterString', 'organismeStandard', 'Nom(s) de(s) organisme(s) qui ont participés à la standardisation de la DS en DEE (codage, formatage, recherche des données obligatoires) ', NULL);
INSERT INTO data VALUES ('commentaire', 'CharacterString', 'commentaire', 'Champ libre pour informations complémentaires indicatives sur le sujet d''observation.', NULL);
INSERT INTO data VALUES ('nomattribut', 'CharacterString', 'nomAttribut', 'Libellé court et implicite de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('definitionattribut', 'CharacterString', 'definitionAttribut', 'Définition précise et complète de l''attribut additionnel.', NULL);
INSERT INTO data VALUES ('valeurattribut', 'CharacterString', 'valeurAttribut', 'Valeur qualitative ou quantitative de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('uniteattribut', 'CharacterString', 'uniteAttribut', 'Unité de mesure de l’attribut additionnel.', NULL);
INSERT INTO data VALUES ('thematiqueattribut', 'CharacterString', 'thematiqueAttribut', 'Thématique relative à l''attribut additionnel (mot-clé).', NULL);
INSERT INTO data VALUES ('typeattribut', 'CharacterString', 'typeAttribut', 'Indique si l''attribut additionnel est de type quantitatif ou qualitatif.', NULL);
INSERT INTO data VALUES ('obsdescription', 'CharacterString', 'obsDescription', 'Description libre de l''observation, aussi succincte et précise que possible.', NULL);
INSERT INTO data VALUES ('occetatbiologique', 'OccurrenceEtatBiologiqueValue', 'occEtatBiologique', 'Code de l''état biologique de l''organisme au moment de l''observation.', NULL);
INSERT INTO data VALUES ('occmethodedetermination', 'CharacterString', 'occMethodeDetermination', 'Description de la méthode utilisée pour déterminer le taxon lors de l''observation.', NULL);
INSERT INTO data VALUES ('occnaturalite', 'OccurrenceNaturalisteValue', 'occNaturalite', 'Naturalité de l''occurrence, conséquence de l''influence anthropique directe qui la caractérise. Elle peut être déterminée immédiatement par simple observation, y compris par une personne n''ayant pas de formation dans le domaine de la biologie considéré.', NULL);
INSERT INTO data VALUES ('occsexe', 'OccurrenceSexeValue', 'occSexe', 'Sexe du sujet de l''observation.', NULL);
INSERT INTO data VALUES ('occstadedevie', 'OccurrenceStadeDeVieValue', 'occStadeDeVie', 'Stade de développement du sujet de l''observation.', NULL);
INSERT INTO data VALUES ('occstatutbiologique', 'OccurrenceStatutBiologiqueValue', 'occStatutBiologique', 'Comportement général de l''individu sur le site d''observation.', NULL);
INSERT INTO data VALUES ('occstatutbiogeographique', 'OccurrenceStatutBiogeographiqueValue', 'occStatutBioGeographique', 'Couvre une notion de présence (présence/absence), et d''origine (indigénat ou introduction)', NULL);
INSERT INTO data VALUES ('preuveexistante', 'PreuveExistanteValue', 'preuveExistante', 'Indique si une preuve existe ou non. Par preuve on entend un objet physique ou numérique permettant de démontrer l''existence de l''occurrence et/ou d''en vérifier l''exactitude.', NULL);
INSERT INTO data VALUES ('preuvenonnumerique', 'CharacterString', 'preuveNonNumerique', 'Adresse ou nom de la personne ou de l''organisme qui permettrait de retrouver la preuve non numérique de L''observation.', NULL);
INSERT INTO data VALUES ('preuvenumerique', 'CharacterString', 'preuveNumerique', 'Adresse web à laquelle on pourra trouver la preuve numérique ou l''archive contenant toutes les preuves numériques (image(s), sonogramme(s), film(s), séquence(s) génétique(s)...).', NULL);
INSERT INTO data VALUES ('obscontexte', 'CharacterString', 'obsContexte', 'Description libre du contexte de l''observation, aussi succincte et précise que possible.', NULL);
INSERT INTO data VALUES ('identifiantregroupementpermanent', 'CharacterString', 'identifiantRegroupementPermanent', 'Identifiant permanent du regroupement, sous forme d''UUID.', NULL);
INSERT INTO data VALUES ('methoderegroupement', 'CharacterString', 'methodeRegroupement', 'Description de la méthode ayant présidé au regroupement, de façon aussi succincte que possible : champ libre.', NULL);
INSERT INTO data VALUES ('typeregroupement', 'TypeRegroupementValue', 'typeRegroupement', 'Indique quel est le type du regroupement suivant la liste typeRegroupementValue.', NULL);
INSERT INTO data VALUES ('altitudemoyenne', 'Decimal', 'altitudeMoyenne', 'Altitude moyenne considérée pour le regroupement.', NULL);
INSERT INTO data VALUES ('profondeurmoyenne', 'Decimal', 'profondeurMoyenne', 'Profondeur moyenne considérée pour le regroupement.', NULL);
INSERT INTO data VALUES ('region', 'region', 'Région', 'Région', NULL);
INSERT INTO data VALUES ('sensimanuelle', 'SensiManuelleValue', 'sensiManuelle', 'Indique si la sensibilité a été attribuée manuellement.', NULL);
INSERT INTO data VALUES ('sensialerte', 'SensiAlerteValue', 'sensiAlerte', 'Indique si la sensibilité est à attribuer manuellement.', NULL);



--
-- Data for Name: dataset; Type: TABLE DATA; Schema: metadata; Owner: admin
--


INSERT INTO dataset VALUES ('dataset_1', 'Std occ taxon dee v1-2-1', '1', 'std_occ_taxon_dee_v1-2-1', 'IMPORT');
INSERT INTO dataset VALUES ('dataset_2', 'Std occ taxon dee v1-2-1', '0', 'Dataset de visualisation pour le modèle ''Std occ taxon dee v1-2-1 ''', 'QUERY');


--
-- Data for Name: format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO format VALUES ('file_observation', 'FILE');
INSERT INTO format VALUES ('table_observation', 'TABLE');
INSERT INTO format VALUES ('form_observation', 'FORM');
INSERT INTO format VALUES ('form_localisation', 'FORM');
INSERT INTO format VALUES ('form_regroupements', 'FORM');
INSERT INTO format VALUES ('form_standardisation', 'FORM');
INSERT INTO format VALUES ('form_autres', 'FORM');



--
-- Data for Name: field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field VALUES ('OGAM_ID_table_observation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codecommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomcommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('anneerefcommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeocommune', 'file_observation', 'FILE');
INSERT INTO field VALUES ('denombrementmin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('denombrementmax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('objetdenombrement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typedenombrement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codedepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('anneerefdepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeodepartement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeoen', 'file_observation', 'FILE');
INSERT INTO field VALUES ('refhabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codehabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionrefhabitat', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codehabref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codemaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionrefmaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomrefmaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeomaille', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versionme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('dateme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeinfogeome', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('observateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('determinateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateurnomorganisme', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateuridentite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('validateurmail', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantorigine', 'file_observation', 'FILE');
INSERT INTO field VALUES ('dspublique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('diffusionniveauprecision', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deefloutage', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensible', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensiniveau', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensidateattribution', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensireferentiel', 'file_observation', 'FILE');
INSERT INTO field VALUES ('sensiversionreferentiel', 'file_observation', 'FILE');
INSERT INTO field VALUES ('statutsource', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddcode', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddsourceid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'file_observation', 'FILE');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'file_observation', 'FILE');
INSERT INTO field VALUES ('codeidcnpdispositif', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deedatetransformation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('deedatedernieremodification', 'file_observation', 'FILE');
INSERT INTO field VALUES ('referencebiblio', 'file_observation', 'FILE');
INSERT INTO field VALUES ('orgtransformation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantpermanent', 'file_observation', 'FILE');
INSERT INTO field VALUES ('statutobservation', 'file_observation', 'FILE');
INSERT INTO field VALUES ('nomcite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jourdatedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('jourdatefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('heuredatedebut', 'file_observation', 'FILE');
INSERT INTO field VALUES ('heuredatefin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmin', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmax', 'file_observation', 'FILE');
INSERT INTO field VALUES ('cdnom', 'file_observation', 'FILE');
INSERT INTO field VALUES ('cdref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('versiontaxref', 'file_observation', 'FILE');
INSERT INTO field VALUES ('datedetermination', 'file_observation', 'FILE');
INSERT INTO field VALUES ('organismestandard', 'file_observation', 'FILE');
INSERT INTO field VALUES ('commentaire', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obsdescription', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obsmethode', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occetatbiologique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occmethodedetermination', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occnaturalite', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occsexe', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstadedevie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstatutbiologique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('occstatutbiogeographique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuveexistante', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuvenonnumerique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('preuvenumerique', 'file_observation', 'FILE');
INSERT INTO field VALUES ('obscontexte', 'file_observation', 'FILE');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'file_observation', 'FILE');
INSERT INTO field VALUES ('methoderegroupement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('typeregroupement', 'file_observation', 'FILE');
INSERT INTO field VALUES ('altitudemoyenne', 'file_observation', 'FILE');
INSERT INTO field VALUES ('profondeurmoyenne', 'file_observation', 'FILE');
INSERT INTO field VALUES ('geometrie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('natureobjetgeo', 'file_observation', 'FILE');
INSERT INTO field VALUES ('precisiongeometrie', 'file_observation', 'FILE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_table_observation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codecommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomcommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('anneerefcommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeocommune', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('denombrementmin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('denombrementmax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('objetdenombrement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typedenombrement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codedepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('anneerefdepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeodepartement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeoen', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('refhabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codehabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionrefhabitat', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codehabref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codemaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionrefmaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomrefmaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeomaille', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versionme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('dateme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeinfogeome', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('observateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('determinateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateurnomorganisme', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateuridentite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('validateurmail', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantorigine', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('dspublique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('diffusionniveauprecision', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deefloutage', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensible', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensiniveau', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensidateattribution', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensireferentiel', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensiversionreferentiel', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('statutsource', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddcode', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddsourceid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('codeidcnpdispositif', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deedatetransformation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('deedatedernieremodification', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('referencebiblio', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('orgtransformation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantpermanent', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('statutobservation', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('nomcite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jourdatedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('jourdatefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('heuredatedebut', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('heuredatefin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmin', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmax', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('cdref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('versiontaxref', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('datedetermination', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('organismestandard', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('commentaire', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obsdescription', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obsmethode', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occetatbiologique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstatutbiogeographique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occmethodedetermination', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occnaturalite', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occsexe', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstadedevie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('occstatutbiologique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuveexistante', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuvenonnumerique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('preuvenumerique', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('obscontexte', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('methoderegroupement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('typeregroupement', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemoyenne', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('profondeurmoyenne', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('geometrie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('natureobjetgeo', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('precisiongeometrie', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensimanuelle', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('sensialerte', 'table_observation', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('altitudemin', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('altitudemoyenne', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('anneerefcommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('anneerefdepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('cdnom', 'form_observation', 'FORM');
INSERT INTO field VALUES ('cdref', 'form_observation', 'FORM');
INSERT INTO field VALUES ('codecommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codedepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codehabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codehabref', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeidcnpdispositif', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('codemaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('codeme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('commentaire', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('jourdatedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('jourdatefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('heuredatedebut', 'form_observation', 'FORM');
INSERT INTO field VALUES ('heuredatefin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('datedetermination', 'form_observation', 'FORM');
INSERT INTO field VALUES ('dateme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('deedatedernieremodification', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('deedatetransformation', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('deefloutage', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('denombrementmax', 'form_observation', 'FORM');
INSERT INTO field VALUES ('denombrementmin', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateuridentite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateurmail', 'form_observation', 'FORM');
INSERT INTO field VALUES ('determinateurnomorganisme', 'form_observation', 'FORM');
INSERT INTO field VALUES ('diffusionniveauprecision', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('dspublique', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('geometrie', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('identifiantorigine', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('identifiantpermanent', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('identifiantregroupementpermanent', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('jddcode', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddmetadonneedeeid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('jddsourceid', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('methoderegroupement', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('natureobjetgeo', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('nomcite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('nomcommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('nomrefmaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('objetdenombrement', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obscontexte', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obsdescription', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateuridentite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateurmail', 'form_observation', 'FORM');
INSERT INTO field VALUES ('observateurnomorganisme', 'form_observation', 'FORM');
INSERT INTO field VALUES ('obsmethode', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occetatbiologique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occmethodedetermination', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occnaturalite', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occsexe', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstadedevie', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstatutbiogeographique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('occstatutbiologique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_table_observation', 'form_autres', 'FORM');
INSERT INTO field VALUES ('organismegestionnairedonnee', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('organismestandard', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('orgtransformation', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('precisiongeometrie', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('preuveexistante', 'form_observation', 'FORM');
INSERT INTO field VALUES ('preuvenonnumerique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('preuvenumerique', 'form_observation', 'FORM');
INSERT INTO field VALUES ('profondeurmax', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('profondeurmin', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('profondeurmoyenne', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'form_autres', 'FORM');
INSERT INTO field VALUES ('referencebiblio', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('refhabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('sensible', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensidateattribution', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensiniveau', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensireferentiel', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensiversionreferentiel', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('statutobservation', 'form_observation', 'FORM');
INSERT INTO field VALUES ('statutsource', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('SUBMISSION_ID', 'form_autres', 'FORM');
INSERT INTO field VALUES ('typedenombrement', 'form_observation', 'FORM');
INSERT INTO field VALUES ('typeen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeocommune', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeodepartement', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeoen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeomaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeinfogeome', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('typeregroupement', 'form_regroupements', 'FORM');
INSERT INTO field VALUES ('validateuridentite', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('validateurmail', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('validateurnomorganisme', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('versionen', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionme', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionrefhabitat', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versionrefmaille', 'form_localisation', 'FORM');
INSERT INTO field VALUES ('versiontaxref', 'form_observation', 'FORM');
INSERT INTO field VALUES ('sensimanuelle', 'form_standardisation', 'FORM');
INSERT INTO field VALUES ('sensialerte', 'form_standardisation', 'FORM');
--
-- Data for Name: dataset_fields; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'SUBMISSION_ID');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'PROVIDER_ID');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'OGAM_ID_table_observation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codecommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomcommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'anneerefcommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeocommune');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'denombrementmin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'denombrementmax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'objetdenombrement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typedenombrement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codedepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'anneerefdepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeodepartement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeoen');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'refhabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codehabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionrefhabitat');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codehabref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codemaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomrefmaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeomaille');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versionme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'dateme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeinfogeome');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'observateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'determinateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateurnomorganisme');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateuridentite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'validateurmail');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantorigine');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'dspublique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'diffusionniveauprecision');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deefloutage');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensible');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensiniveau');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensidateattribution');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensireferentiel');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensiversionreferentiel');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'statutsource');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddcode');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddsourceid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jddmetadonneedeeid');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'organismegestionnairedonnee');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'codeidcnpdispositif');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deedatetransformation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'deedatedernieremodification');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'referencebiblio');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'orgtransformation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantpermanent');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'statutobservation');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'nomcite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jourdatedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'jourdatefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatedebut');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'heuredatefin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmin');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmax');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'cdnom');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'cdref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'versiontaxref');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'datedetermination');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'organismestandard');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'commentaire');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obsdescription');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obsmethode');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occetatbiologique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstatutbiogeographique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occmethodedetermination');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occnaturalite');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occsexe');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstadedevie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'occstatutbiologique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuveexistante');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuvenonnumerique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'preuvenumerique');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'obscontexte');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'identifiantregroupementpermanent');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'methoderegroupement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'typeregroupement');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'altitudemoyenne');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'profondeurmoyenne');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'geometrie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'natureobjetgeo');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'precisiongeometrie');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensimanuelle');
INSERT INTO dataset_fields VALUES ('dataset_2', 'RAW_DATA', 'table_observation', 'sensialerte');


--
-- Data for Name: file_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_format VALUES ('file_observation', 'CSV', 'file_observation', 0, 'dee_v1-2-1_observation', 'fichier_dee_v1-2-1_observation');


--
-- Data for Name: dataset_files; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_files VALUES ('dataset_1', 'file_observation');

--
-- Data for Name: form_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_format VALUES ('form_observation', 'Observation', 'Groupement des champs d''observation', 1, '1');
INSERT INTO form_format VALUES ('form_localisation', 'Localisation', 'Groupement des champs de localisation', 2, '1');
INSERT INTO form_format VALUES ('form_regroupements', 'Regroupements', 'Groupement des champs de regroupement', 3, '1');
INSERT INTO form_format VALUES ('form_standardisation', 'Standardisation', 'Groupement des champs de standardisation', 4, '1');
INSERT INTO form_format VALUES ('form_autres', 'Autres', 'Autres champs', 6, '1');


--
-- Data for Name: dataset_forms; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_forms VALUES ('dataset_2', 'form_observation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_localisation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_regroupements');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_standardisation');
INSERT INTO dataset_forms VALUES ('dataset_2', 'form_autres');

--
-- Data for Name: dynamode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dynamode VALUES ('CodeCommuneValue', 'SELECT code as code, code as label FROM referentiels.communes ORDER BY code');
INSERT INTO dynamode VALUES ('NomCommuneValue', 'SELECT nom as code, nom || '' ('' || code || '')'' as label FROM referentiels.communes ORDER BY nom');
INSERT INTO dynamode VALUES ('CodeDepartementValue', 'SELECT dp as code, nom_depart || '' ('' || dp || '')'' as label FROM referentiels.departements ORDER BY dp');
INSERT INTO dynamode VALUES ('region', 'SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.regions ORDER BY code');
INSERT INTO dynamode VALUES ('CodeMailleValue', 'SELECT code_10km as code, cd_sig || '' ('' || code_10km || '')'' as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeENValue', 'SELECT codeen as code, codeen || '' ('' || libelleen || '')'' as label FROM referentiels.codeenvalue ORDER BY codeEN');
INSERT INTO dynamode VALUES ('StatutSourceValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.StatutSourceValue ORDER BY code');
INSERT INTO dynamode VALUES ('DSPubliqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.DSPubliqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('StatutObservationValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.StatutObservationValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObjetDenombrementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.ObjetDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeDenombrementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabitatValue', 'SELECT lb_code as code, lb_code as label FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1 ');
INSERT INTO dynamode VALUES ('CodeRefHabitatValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.CodeRefHabitatValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NatureObjetGeoValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.NatureObjetGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeENValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeENValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeMasseEauValue', 'SELECT cdeumassedeau as code, cdeumassedeau || '' ('' || nommassedeau || '')'' as label FROM referentiels.CodeMasseEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabRefValue', 'SELECT cd_hab as code, cd_hab as label FROM referentiels.habref_20 ORDER BY code ');
INSERT INTO dynamode VALUES ('IDCNPValue', 'SELECT code as code, label as label FROM referentiels.IDCNPValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeInfoGeoValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeInfoGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('VersionMasseDEauValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.VersionMasseDEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NiveauPrecisionValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.NiveauPrecisionValue ORDER BY code ');
INSERT INTO dynamode VALUES ('DEEFloutageValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.DEEFloutageValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibleValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensibleValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibiliteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensibiliteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeRegroupementValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.TypeRegroupementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceNaturalisteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceNaturalisteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceSexeValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceSexeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStadeDeVieValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiologiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PreuveExistanteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.PreuveExistanteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObservationMethodeValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.ObservationMethodeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceEtatBiologiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiogeographiqueValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.OccurrenceStatutBiogeographiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PROVIDER_ID', 'SELECT id as code, label FROM website.providers ORDER BY label');
INSERT INTO dynamode VALUES ('SensiAlerteValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensiAlerteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensiManuelleValue', 'SELECT code as code, label || '' ('' || code || '')'' as label FROM referentiels.SensiManuelleValue ORDER BY code ');


--
-- Data for Name: field_mapping; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field_mapping VALUES ('OGAM_ID_table_observation', 'file_observation', 'OGAM_ID_table_observation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codecommune', 'file_observation', 'codecommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomcommune', 'file_observation', 'nomcommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('anneerefcommune', 'file_observation', 'anneerefcommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeocommune', 'file_observation', 'typeinfogeocommune', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('denombrementmin', 'file_observation', 'denombrementmin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('denombrementmax', 'file_observation', 'denombrementmax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('objetdenombrement', 'file_observation', 'objetdenombrement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typedenombrement', 'file_observation', 'typedenombrement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codedepartement', 'file_observation', 'codedepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('anneerefdepartement', 'file_observation', 'anneerefdepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement', 'file_observation', 'typeinfogeodepartement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeen', 'file_observation', 'typeen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeen', 'file_observation', 'codeen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionen', 'file_observation', 'versionen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeoen', 'file_observation', 'typeinfogeoen', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('refhabitat', 'file_observation', 'refhabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codehabitat', 'file_observation', 'codehabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionrefhabitat', 'file_observation', 'versionrefhabitat', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codehabref', 'file_observation', 'codehabref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codemaille', 'file_observation', 'codemaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionrefmaille', 'file_observation', 'versionrefmaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomrefmaille', 'file_observation', 'nomrefmaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeomaille', 'file_observation', 'typeinfogeomaille', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeme', 'file_observation', 'codeme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versionme', 'file_observation', 'versionme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('dateme', 'file_observation', 'dateme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeinfogeome', 'file_observation', 'typeinfogeome', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateurnomorganisme', 'file_observation', 'observateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateuridentite', 'file_observation', 'observateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('observateurmail', 'file_observation', 'observateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme', 'file_observation', 'determinateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateuridentite', 'file_observation', 'determinateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('determinateurmail', 'file_observation', 'determinateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateurnomorganisme', 'file_observation', 'validateurnomorganisme', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateuridentite', 'file_observation', 'validateuridentite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('validateurmail', 'file_observation', 'validateurmail', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantorigine', 'file_observation', 'identifiantorigine', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('dspublique', 'file_observation', 'dspublique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('diffusionniveauprecision', 'file_observation', 'diffusionniveauprecision', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deefloutage', 'file_observation', 'deefloutage', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensible', 'file_observation', 'sensible', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensiniveau', 'file_observation', 'sensiniveau', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensidateattribution', 'file_observation', 'sensidateattribution', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensireferentiel', 'file_observation', 'sensireferentiel', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('sensiversionreferentiel', 'file_observation', 'sensiversionreferentiel', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('statutsource', 'file_observation', 'statutsource', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddcode', 'file_observation', 'jddcode', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddid', 'file_observation', 'jddid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddsourceid', 'file_observation', 'jddsourceid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jddmetadonneedeeid', 'file_observation', 'jddmetadonneedeeid', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee', 'file_observation', 'organismegestionnairedonnee', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('codeidcnpdispositif', 'file_observation', 'codeidcnpdispositif', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deedatetransformation', 'file_observation', 'deedatetransformation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('deedatedernieremodification', 'file_observation', 'deedatedernieremodification', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('referencebiblio', 'file_observation', 'referencebiblio', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('orgtransformation', 'file_observation', 'orgtransformation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantpermanent', 'file_observation', 'identifiantpermanent', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('statutobservation', 'file_observation', 'statutobservation', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('nomcite', 'file_observation', 'nomcite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datedebut', 'file_observation', 'datedebut', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datefin', 'file_observation', 'datefin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('heuredatedebut', 'file_observation', 'heuredatedebut', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('heuredatefin', 'file_observation', 'heuredatefin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jourdatedebut', 'file_observation', 'jourdatedebut', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('jourdatefin', 'file_observation', 'jourdatefin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemin', 'file_observation', 'altitudemin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemax', 'file_observation', 'altitudemax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmin', 'file_observation', 'profondeurmin', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmax', 'file_observation', 'profondeurmax', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('cdnom', 'file_observation', 'cdnom', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('cdref', 'file_observation', 'cdref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('versiontaxref', 'file_observation', 'versiontaxref', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('datedetermination', 'file_observation', 'datedetermination', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('organismestandard', 'file_observation', 'organismestandard', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('commentaire', 'file_observation', 'commentaire', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obsdescription', 'file_observation', 'obsdescription', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obsmethode', 'file_observation', 'obsmethode', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occetatbiologique', 'file_observation', 'occetatbiologique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occmethodedetermination', 'file_observation', 'occmethodedetermination', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occnaturalite', 'file_observation', 'occnaturalite', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occsexe', 'file_observation', 'occsexe', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstadedevie', 'file_observation', 'occstadedevie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstatutbiologique', 'file_observation', 'occstatutbiologique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique', 'file_observation', 'occstatutbiogeographique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuveexistante', 'file_observation', 'preuveexistante', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuvenonnumerique', 'file_observation', 'preuvenonnumerique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('preuvenumerique', 'file_observation', 'preuvenumerique', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('obscontexte', 'file_observation', 'obscontexte', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent', 'file_observation', 'identifiantregroupementpermanent', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('methoderegroupement', 'file_observation', 'methoderegroupement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('typeregroupement', 'file_observation', 'typeregroupement', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemoyenne', 'file_observation', 'altitudemoyenne', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('profondeurmoyenne', 'file_observation', 'profondeurmoyenne', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('geometrie', 'file_observation', 'geometrie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('natureobjetgeo', 'file_observation', 'natureobjetgeo', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('precisiongeometrie', 'file_observation', 'precisiongeometrie', 'table_observation', 'FILE');
INSERT INTO field_mapping VALUES ('altitudemax', 'form_localisation', 'altitudemax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('altitudemin', 'form_localisation', 'altitudemin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('altitudemoyenne', 'form_localisation', 'altitudemoyenne', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('anneerefcommune', 'form_localisation', 'anneerefcommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('anneerefdepartement', 'form_localisation', 'anneerefdepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('cdnom', 'form_observation', 'cdnom', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('cdref', 'form_observation', 'cdref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codecommune', 'form_localisation', 'codecommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codedepartement', 'form_localisation', 'codedepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeen', 'form_localisation', 'codeen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codehabitat', 'form_localisation', 'codehabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codehabref', 'form_localisation', 'codehabref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeidcnpdispositif', 'form_standardisation', 'codeidcnpdispositif', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codemaille', 'form_localisation', 'codemaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('codeme', 'form_localisation', 'codeme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('commentaire', 'form_observation', 'commentaire', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datedebut', 'form_observation', 'datedebut', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datedetermination', 'form_observation', 'datedetermination', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('datefin', 'form_observation', 'datefin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('dateme', 'form_localisation', 'dateme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deedatedernieremodification', 'form_standardisation', 'deedatedernieremodification', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deedatetransformation', 'form_standardisation', 'deedatetransformation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('deefloutage', 'form_standardisation', 'deefloutage', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('denombrementmax', 'form_observation', 'denombrementmax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('denombrementmin', 'form_observation', 'denombrementmin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateuridentite', 'form_observation', 'determinateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateurmail', 'form_observation', 'determinateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('determinateurnomorganisme', 'form_observation', 'determinateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('diffusionniveauprecision', 'form_standardisation', 'diffusionniveauprecision', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('dspublique', 'form_standardisation', 'dspublique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('geometrie', 'form_localisation', 'geometrie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantorigine', 'form_standardisation', 'identifiantorigine', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantpermanent', 'form_standardisation', 'identifiantpermanent', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('identifiantregroupementpermanent', 'form_regroupements', 'identifiantregroupementpermanent', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddcode', 'form_standardisation', 'jddcode', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddid', 'form_standardisation', 'jddid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddmetadonneedeeid', 'form_standardisation', 'jddmetadonneedeeid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('jddsourceid', 'form_standardisation', 'jddsourceid', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('methoderegroupement', 'form_regroupements', 'methoderegroupement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('natureobjetgeo', 'form_localisation', 'natureobjetgeo', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomcite', 'form_observation', 'nomcite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomcommune', 'form_localisation', 'nomcommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('nomrefmaille', 'form_localisation', 'nomrefmaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('objetdenombrement', 'form_observation', 'objetdenombrement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obscontexte', 'form_observation', 'obscontexte', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obsdescription', 'form_observation', 'obsdescription', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateuridentite', 'form_observation', 'observateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateurmail', 'form_observation', 'observateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('observateurnomorganisme', 'form_observation', 'observateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('obsmethode', 'form_observation', 'obsmethode', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occetatbiologique', 'form_observation', 'occetatbiologique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occmethodedetermination', 'form_observation', 'occmethodedetermination', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occnaturalite', 'form_observation', 'occnaturalite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occsexe', 'form_observation', 'occsexe', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstadedevie', 'form_observation', 'occstadedevie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstatutbiogeographique', 'form_observation', 'occstatutbiogeographique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('occstatutbiologique', 'form_observation', 'occstatutbiologique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_table_observation', 'form_autres', 'OGAM_ID_table_observation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('organismegestionnairedonnee', 'form_standardisation', 'organismegestionnairedonnee', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('organismestandard', 'form_standardisation', 'organismestandard', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('orgtransformation', 'form_standardisation', 'orgtransformation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('precisiongeometrie', 'form_localisation', 'precisiongeometrie', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuveexistante', 'form_observation', 'preuveexistante', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuvenonnumerique', 'form_observation', 'preuvenonnumerique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('preuvenumerique', 'form_observation', 'preuvenumerique', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmax', 'form_localisation', 'profondeurmax', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmin', 'form_localisation', 'profondeurmin', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('profondeurmoyenne', 'form_localisation', 'profondeurmoyenne', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('PROVIDER_ID', 'form_autres', 'PROVIDER_ID', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('referencebiblio', 'form_standardisation', 'referencebiblio', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('refhabitat', 'form_localisation', 'refhabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensible', 'form_standardisation', 'sensible', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensidateattribution', 'form_standardisation', 'sensidateattribution', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensiniveau', 'form_standardisation', 'sensiniveau', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensireferentiel', 'form_standardisation', 'sensireferentiel', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensiversionreferentiel', 'form_standardisation', 'sensiversionreferentiel', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('statutobservation', 'form_observation', 'statutobservation', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('statutsource', 'form_standardisation', 'statutsource', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('SUBMISSION_ID', 'form_autres', 'SUBMISSION_ID', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typedenombrement', 'form_observation', 'typedenombrement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeen', 'form_localisation', 'typeen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeocommune', 'form_localisation', 'typeinfogeocommune', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeodepartement', 'form_localisation', 'typeinfogeodepartement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeoen', 'form_localisation', 'typeinfogeoen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeomaille', 'form_localisation', 'typeinfogeomaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeinfogeome', 'form_localisation', 'typeinfogeome', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('typeregroupement', 'form_regroupements', 'typeregroupement', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateuridentite', 'form_standardisation', 'validateuridentite', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateurmail', 'form_standardisation', 'validateurmail', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('validateurnomorganisme', 'form_standardisation', 'validateurnomorganisme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionen', 'form_localisation', 'versionen', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionme', 'form_localisation', 'versionme', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionrefhabitat', 'form_localisation', 'versionrefhabitat', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versionrefmaille', 'form_localisation', 'versionrefmaille', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('versiontaxref', 'form_observation', 'versiontaxref', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensimanuelle', 'form_standardisation', 'sensimanuelle', 'table_observation', 'FORM');
INSERT INTO field_mapping VALUES ('sensialerte', 'form_standardisation', 'sensialerte', 'table_observation', 'FORM');


--
-- Data for Name: file_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_field VALUES ('OGAM_ID_table_observation', 'file_observation', '1', NULL, 1);
INSERT INTO file_field VALUES ('codecommune', 'file_observation', '0', NULL, 2);
INSERT INTO file_field VALUES ('nomcommune', 'file_observation', '0', NULL, 3);
INSERT INTO file_field VALUES ('anneerefcommune', 'file_observation', '0', 'yyyy', 4);
INSERT INTO file_field VALUES ('typeinfogeocommune', 'file_observation', '0', NULL, 5);
INSERT INTO file_field VALUES ('denombrementmin', 'file_observation', '0', NULL, 6);
INSERT INTO file_field VALUES ('denombrementmax', 'file_observation', '0', NULL, 7);
INSERT INTO file_field VALUES ('objetdenombrement', 'file_observation', '0', NULL, 8);
INSERT INTO file_field VALUES ('typedenombrement', 'file_observation', '0', NULL, 9);
INSERT INTO file_field VALUES ('codedepartement', 'file_observation', '0', NULL, 10);
INSERT INTO file_field VALUES ('anneerefdepartement', 'file_observation', '0', 'yyyy', 11);
INSERT INTO file_field VALUES ('typeinfogeodepartement', 'file_observation', '0', NULL, 12);
INSERT INTO file_field VALUES ('typeen', 'file_observation', '0', NULL, 13);
INSERT INTO file_field VALUES ('codeen', 'file_observation', '0', NULL, 14);
INSERT INTO file_field VALUES ('versionen', 'file_observation', '0', NULL, 15);
INSERT INTO file_field VALUES ('typeinfogeoen', 'file_observation', '0', NULL, 16);
INSERT INTO file_field VALUES ('refhabitat', 'file_observation', '0', NULL, 17);
INSERT INTO file_field VALUES ('codehabitat', 'file_observation', '0', NULL, 18);
INSERT INTO file_field VALUES ('versionrefhabitat', 'file_observation', '0', NULL, 19);
INSERT INTO file_field VALUES ('codehabref', 'file_observation', '0', NULL, 20);
INSERT INTO file_field VALUES ('codemaille', 'file_observation', '0', NULL, 21);
INSERT INTO file_field VALUES ('versionrefmaille', 'file_observation', '0', NULL, 22);
INSERT INTO file_field VALUES ('nomrefmaille', 'file_observation', '0', NULL, 23);
INSERT INTO file_field VALUES ('typeinfogeomaille', 'file_observation', '0', NULL, 24);
INSERT INTO file_field VALUES ('codeme', 'file_observation', '0', NULL, 25);
INSERT INTO file_field VALUES ('versionme', 'file_observation', '0', NULL, 26);
INSERT INTO file_field VALUES ('dateme', 'file_observation', '0', 'yyyy-MM-dd', 27);
INSERT INTO file_field VALUES ('typeinfogeome', 'file_observation', '0', NULL, 28);
INSERT INTO file_field VALUES ('observateurnomorganisme', 'file_observation', '0', NULL, 29);
INSERT INTO file_field VALUES ('observateuridentite', 'file_observation', '0', NULL, 30);
INSERT INTO file_field VALUES ('observateurmail', 'file_observation', '0', NULL, 31);
INSERT INTO file_field VALUES ('determinateurnomorganisme', 'file_observation', '0', NULL, 32);
INSERT INTO file_field VALUES ('determinateuridentite', 'file_observation', '0', NULL, 33);
INSERT INTO file_field VALUES ('determinateurmail', 'file_observation', '0', NULL, 34);
INSERT INTO file_field VALUES ('validateurnomorganisme', 'file_observation', '0', NULL, 35);
INSERT INTO file_field VALUES ('validateuridentite', 'file_observation', '0', NULL, 36);
INSERT INTO file_field VALUES ('validateurmail', 'file_observation', '0', NULL, 37);
INSERT INTO file_field VALUES ('identifiantorigine', 'file_observation', '0', NULL, 38);
INSERT INTO file_field VALUES ('dspublique', 'file_observation', '1', NULL, 39);
INSERT INTO file_field VALUES ('diffusionniveauprecision', 'file_observation', '0', NULL, 40);
INSERT INTO file_field VALUES ('deefloutage', 'file_observation', '0', NULL, 41);
INSERT INTO file_field VALUES ('sensible', 'file_observation', '1', NULL, 42);
INSERT INTO file_field VALUES ('sensiniveau', 'file_observation', '1', NULL, 43);
INSERT INTO file_field VALUES ('sensidateattribution', 'file_observation', '0', 'yyyy-MM-dd''T''HH:mmZ', 44);
INSERT INTO file_field VALUES ('sensireferentiel', 'file_observation', '0', NULL, 45);
INSERT INTO file_field VALUES ('sensiversionreferentiel', 'file_observation', '0', NULL, 46);
INSERT INTO file_field VALUES ('statutsource', 'file_observation', '1', NULL, 47);
INSERT INTO file_field VALUES ('jddcode', 'file_observation', '0', NULL, 48);
INSERT INTO file_field VALUES ('jddid', 'file_observation', '0', NULL, 49);
INSERT INTO file_field VALUES ('jddsourceid', 'file_observation', '0', NULL, 50);
INSERT INTO file_field VALUES ('jddmetadonneedeeid', 'file_observation', '1', NULL, 51);
INSERT INTO file_field VALUES ('organismegestionnairedonnee', 'file_observation', '1', NULL, 52);
INSERT INTO file_field VALUES ('codeidcnpdispositif', 'file_observation', '0', NULL, 53);
INSERT INTO file_field VALUES ('deedatetransformation', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 54);
INSERT INTO file_field VALUES ('deedatedernieremodification', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 55);
INSERT INTO file_field VALUES ('referencebiblio', 'file_observation', '0', NULL, 56);
INSERT INTO file_field VALUES ('orgtransformation', 'file_observation', '0', NULL, 57);
INSERT INTO file_field VALUES ('identifiantpermanent', 'file_observation', '1', NULL, 58);
INSERT INTO file_field VALUES ('statutobservation', 'file_observation', '1', NULL, 59);
INSERT INTO file_field VALUES ('nomcite', 'file_observation', '1', NULL, 60);
INSERT INTO file_field VALUES ('datedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('datefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('jourdatedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('jourdatefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('heuredatedebut', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 61);
INSERT INTO file_field VALUES ('heuredatefin', 'file_observation', '1', 'yyyy-MM-dd''T''HH:mmZ', 62);
INSERT INTO file_field VALUES ('altitudemin', 'file_observation', '0', NULL, 63);
INSERT INTO file_field VALUES ('altitudemax', 'file_observation', '0', NULL, 64);
INSERT INTO file_field VALUES ('profondeurmin', 'file_observation', '0', NULL, 65);
INSERT INTO file_field VALUES ('profondeurmax', 'file_observation', '0', NULL, 66);
INSERT INTO file_field VALUES ('cdnom', 'file_observation', '0', NULL, 67);
INSERT INTO file_field VALUES ('cdref', 'file_observation', '0', NULL, 68);
INSERT INTO file_field VALUES ('versiontaxref', 'file_observation', '0', NULL, 69);
INSERT INTO file_field VALUES ('datedetermination', 'file_observation', '0', 'yyyy-MM-dd''T''HH:mmZ', 70);
INSERT INTO file_field VALUES ('organismestandard', 'file_observation', '0', NULL, 71);
INSERT INTO file_field VALUES ('commentaire', 'file_observation', '0', NULL, 72);
INSERT INTO file_field VALUES ('obsdescription', 'file_observation', '0', NULL, 73);
INSERT INTO file_field VALUES ('obsmethode', 'file_observation', '0', NULL, 74);
INSERT INTO file_field VALUES ('occetatbiologique', 'file_observation', '0', NULL, 75);
INSERT INTO file_field VALUES ('occmethodedetermination', 'file_observation', '0', NULL, 76);
INSERT INTO file_field VALUES ('occnaturalite', 'file_observation', '0', NULL, 77);
INSERT INTO file_field VALUES ('occsexe', 'file_observation', '0', NULL, 78);
INSERT INTO file_field VALUES ('occstadedevie', 'file_observation', '0', NULL, 79);
INSERT INTO file_field VALUES ('occstatutbiologique', 'file_observation', '0', NULL, 80);
INSERT INTO file_field VALUES ('occstatutbiogeographique', 'file_observation', '0', NULL, 81);
INSERT INTO file_field VALUES ('preuveexistante', 'file_observation', '0', NULL, 82);
INSERT INTO file_field VALUES ('preuvenonnumerique', 'file_observation', '0', NULL, 83);
INSERT INTO file_field VALUES ('preuvenumerique', 'file_observation', '0', NULL, 84);
INSERT INTO file_field VALUES ('obscontexte', 'file_observation', '0', NULL, 85);
INSERT INTO file_field VALUES ('identifiantregroupementpermanent', 'file_observation', '0', NULL, 86);
INSERT INTO file_field VALUES ('methoderegroupement', 'file_observation', '0', NULL, 87);
INSERT INTO file_field VALUES ('typeregroupement', 'file_observation', '0', NULL, 88);
INSERT INTO file_field VALUES ('altitudemoyenne', 'file_observation', '0', NULL, 89);
INSERT INTO file_field VALUES ('profondeurmoyenne', 'file_observation', '0', NULL, 90);
INSERT INTO file_field VALUES ('geometrie', 'file_observation', '0', NULL, 91);
INSERT INTO file_field VALUES ('natureobjetgeo', 'file_observation', '0', NULL, 92);
INSERT INTO file_field VALUES ('precisiongeometrie', 'file_observation', '0', NULL, 93);

--
-- Data for Name: form_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_field VALUES ('altitudemax', 'form_localisation', '1', '1', 'NUMERIC', 1, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('altitudemin', 'form_localisation', '1', '1', 'NUMERIC', 2, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('altitudemoyenne', 'form_localisation', '1', '1', 'NUMERIC', 3, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('anneerefcommune', 'form_localisation', '1', '1', 'DATE', 4, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('anneerefdepartement', 'form_localisation', '1', '1', 'DATE', 5, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('cdnom', 'form_observation', '1', '1', 'TAXREF', 6, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('cdref', 'form_observation', '1', '1', 'TAXREF', 7, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codecommune', 'form_localisation', '1', '1', 'SELECT', 8, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codedepartement', 'form_localisation', '1', '1', 'SELECT', 9, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeen', 'form_localisation', '1', '1', 'SELECT', 10, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codehabitat', 'form_localisation', '1', '1', 'SELECT', 11, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codehabref', 'form_localisation', '1', '1', 'SELECT', 12, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeidcnpdispositif', 'form_standardisation', '1', '1', 'SELECT', 13, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codemaille', 'form_localisation', '1', '1', 'SELECT', 14, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('codeme', 'form_localisation', '1', '1', 'TEXT', 15, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('commentaire', 'form_observation', '1', '1', 'TEXT', 16, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('datedebut', 'form_observation', '1', '1', 'DATE', 17, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('datedetermination', 'form_observation', '1', '1', 'DATE', 18, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('datefin', 'form_observation', '1', '1', 'DATE', 19, '0', '1', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('dateme', 'form_localisation', '1', '1', 'DATE', 20, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deedatedernieremodification', 'form_standardisation', '1', '1', 'DATE', 21, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deedatetransformation', 'form_standardisation', '1', '1', 'DATE', 22, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('deefloutage', 'form_standardisation', '1', '1', 'SELECT', 23, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('denombrementmax', 'form_observation', '1', '1', 'NUMERIC', 24, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('denombrementmin', 'form_observation', '1', '1', 'NUMERIC', 25, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateuridentite', 'form_observation', '1', '1', 'TEXT', 26, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateurmail', 'form_observation', '1', '1', 'TEXT', 27, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('determinateurnomorganisme', 'form_observation', '1', '1', 'TEXT', 28, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('diffusionniveauprecision', 'form_standardisation', '1', '1', 'SELECT', 29, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('dspublique', 'form_standardisation', '1', '1', 'SELECT', 30, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('geometrie', 'form_localisation', '1', '1', 'GEOM', 31, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantorigine', 'form_standardisation', '1', '1', 'TEXT', 32, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantpermanent', 'form_standardisation', '1', '1', 'TEXT', 33, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('identifiantregroupementpermanent', 'form_regroupements', '1', '1', 'TEXT', 34, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddcode', 'form_standardisation', '1', '1', 'TEXT', 35, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddid', 'form_standardisation', '1', '1', 'TEXT', 36, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddmetadonneedeeid', 'form_standardisation', '1', '1', 'TEXT', 37, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('jddsourceid', 'form_standardisation', '1', '1', 'TEXT', 38, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('methoderegroupement', 'form_regroupements', '1', '1', 'TEXT', 39, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('natureobjetgeo', 'form_localisation', '1', '1', 'SELECT', 40, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomcite', 'form_observation', '1', '1', 'TEXT', 41, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomcommune', 'form_localisation', '1', '1', 'SELECT', 42, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('nomrefmaille', 'form_localisation', '1', '1', 'TEXT', 43, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('objetdenombrement', 'form_observation', '1', '1', 'SELECT', 44, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obscontexte', 'form_observation', '1', '1', 'TEXT', 45, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obsdescription', 'form_observation', '1', '1', 'TEXT', 46, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateuridentite', 'form_observation', '1', '1', 'TEXT', 47, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateurmail', 'form_observation', '1', '1', 'TEXT', 48, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('observateurnomorganisme', 'form_observation', '1', '1', 'TEXT', 49, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('obsmethode', 'form_observation', '1', '1', 'SELECT', 50, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occetatbiologique', 'form_observation', '1', '1', 'SELECT', 51, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occmethodedetermination', 'form_observation', '1', '1', 'TEXT', 52, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occnaturalite', 'form_observation', '1', '1', 'SELECT', 53, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occsexe', 'form_observation', '1', '1', 'SELECT', 54, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstadedevie', 'form_observation', '1', '1', 'SELECT', 55, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstatutbiogeographique', 'form_observation', '1', '1', 'SELECT', 56, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('occstatutbiologique', 'form_observation', '1', '1', 'SELECT', 57, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('OGAM_ID_table_observation', 'form_autres', '1', '1', 'TEXT', 58, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('organismegestionnairedonnee', 'form_standardisation', '1', '1', 'TEXT', 59, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('organismestandard', 'form_standardisation', '1', '1', 'TEXT', 60, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('orgtransformation', 'form_standardisation', '1', '1', 'TEXT', 61, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('precisiongeometrie', 'form_localisation', '1', '1', 'NUMERIC', 62, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuveexistante', 'form_observation', '1', '1', 'SELECT', 63, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuvenonnumerique', 'form_observation', '1', '1', 'TEXT', 64, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('preuvenumerique', 'form_observation', '1', '1', 'TEXT', 65, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmax', 'form_localisation', '1', '1', 'NUMERIC', 66, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmin', 'form_localisation', '1', '1', 'NUMERIC', 67, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('profondeurmoyenne', 'form_localisation', '1', '1', 'NUMERIC', 68, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID', 'form_autres', '1', '1', 'SELECT', 69, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('referencebiblio', 'form_standardisation', '1', '1', 'TEXT', 70, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('refhabitat', 'form_localisation', '1', '1', 'SELECT', 71, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensible', 'form_standardisation', '1', '1', 'SELECT', 72, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensidateattribution', 'form_standardisation', '1', '1', 'DATE', 73, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('sensiniveau', 'form_standardisation', '1', '1', 'SELECT', 74, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensireferentiel', 'form_standardisation', '1', '1', 'TEXT', 75, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensiversionreferentiel', 'form_standardisation', '1', '1', 'TEXT', 76, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('statutobservation', 'form_observation', '1', '1', 'SELECT', 77, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('statutsource', 'form_standardisation', '1', '1', 'SELECT', 78, '0', '1', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('SUBMISSION_ID', 'form_autres', '1', '1', 'NUMERIC', 79, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typedenombrement', 'form_observation', '1', '1', 'SELECT', 80, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeen', 'form_localisation', '1', '1', 'SELECT', 81, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeocommune', 'form_localisation', '1', '1', 'SELECT', 82, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeodepartement', 'form_localisation', '1', '1', 'SELECT', 83, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeoen', 'form_localisation', '1', '1', 'SELECT', 84, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeomaille', 'form_localisation', '1', '1', 'SELECT', 85, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeinfogeome', 'form_localisation', '1', '1', 'SELECT', 86, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('typeregroupement', 'form_regroupements', '1', '1', 'SELECT', 87, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateuridentite', 'form_standardisation', '1', '1', 'TEXT', 88, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateurmail', 'form_standardisation', '1', '1', 'TEXT', 89, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('validateurnomorganisme', 'form_standardisation', '1', '1', 'TEXT', 90, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionen', 'form_localisation', '1', '1', 'DATE', 91, '0', '0', NULL, NULL, 'yyyy-MM-dd');
INSERT INTO form_field VALUES ('versionme', 'form_localisation', '1', '1', 'SELECT', 92, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionrefhabitat', 'form_localisation', '1', '1', 'TEXT', 93, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versionrefmaille', 'form_localisation', '1', '1', 'TEXT', 94, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('versiontaxref', 'form_observation', '1', '1', 'TEXT', 95, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensimanuelle', 'form_standardisation', '1', '1', 'SELECT', 96, '0', '0', NULL, NULL, NULL);
INSERT INTO form_field VALUES ('sensialerte', 'form_standardisation', '1', '1', 'SELECT', 97, '0', '0', NULL, NULL, NULL);


--
-- Data for Name: mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO mode VALUES ('PROVIDER_ID', '1', 1, 'organisme A', 'organisme A');

--
-- Data for Name: group_mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--





--
-- Data for Name: table_schema; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_schema VALUES ('RAW_DATA', 'RAW_DATA', 'Données sources', 'Contains raw data');
INSERT INTO table_schema VALUES ('METADATA', 'METADATA', 'Metadata', 'Contains the tables describing the data');
INSERT INTO table_schema VALUES ('WEBSITE', 'WEBSITE', 'Website', 'Contains the tables used to operate the web site');
INSERT INTO table_schema VALUES ('PUBLIC', 'PUBLIC', 'Public', 'Contains the default PostgreSQL tables and PostGIS functions');


--
-- Data for Name: model; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model VALUES ('model_1', 'Std occ taxon dee v1-2-1', 'à ne pas supprimer', 'RAW_DATA', true);

--
-- Data for Name: model_datasets; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_datasets VALUES ('model_1', 'dataset_1');
INSERT INTO model_datasets VALUES ('model_1', 'dataset_2');


--
-- Data for Name: table_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--
INSERT INTO table_format VALUES ('table_observation', 'model_1_observation', 'RAW_DATA', 'OGAM_ID_table_observation, PROVIDER_ID', 'observation', 'table_dee_v1-2-1_observation');


--
-- Data for Name: model_tables; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_tables VALUES ('model_1', 'table_observation');

--
-- Data for Name: process; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: range; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_field VALUES ('SUBMISSION_ID', 'table_observation', 'submission_id', '1', '0', '0', '0', 1, NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID', 'table_observation', 'provider_id', '0', '0', '0', '1', 2, NULL);
INSERT INTO table_field VALUES ('OGAM_ID_table_observation', 'table_observation', 'ogam_id_table_observation', '1', '0', '0', '1', 3, 'séquence');
INSERT INTO table_field VALUES ('codecommune', 'table_observation', 'codecommune', '0', '1', '1', '0', 4, NULL);
INSERT INTO table_field VALUES ('nomcommune', 'table_observation', 'nomcommune', '0', '1', '1', '0', 5, NULL);
INSERT INTO table_field VALUES ('anneerefcommune', 'table_observation', 'anneerefcommune', '0', '1', '1', '0', 6, NULL);
INSERT INTO table_field VALUES ('typeinfogeocommune', 'table_observation', 'typeinfogeocommune', '0', '1', '1', '0', 7, NULL);
INSERT INTO table_field VALUES ('denombrementmin', 'table_observation', 'denombrementmin', '0', '1', '1', '0', 8, NULL);
INSERT INTO table_field VALUES ('denombrementmax', 'table_observation', 'denombrementmax', '0', '1', '1', '0', 9, NULL);
INSERT INTO table_field VALUES ('objetdenombrement', 'table_observation', 'objetdenombrement', '0', '1', '1', '0', 10, NULL);
INSERT INTO table_field VALUES ('typedenombrement', 'table_observation', 'typedenombrement', '0', '1', '1', '0', 11, NULL);
INSERT INTO table_field VALUES ('codedepartement', 'table_observation', 'codedepartement', '0', '1', '1', '0', 12, NULL);
INSERT INTO table_field VALUES ('anneerefdepartement', 'table_observation', 'anneerefdepartement', '0', '1', '1', '0', 13, NULL);
INSERT INTO table_field VALUES ('typeinfogeodepartement', 'table_observation', 'typeinfogeodepartement', '0', '1', '1', '0', 14, NULL);
INSERT INTO table_field VALUES ('typeen', 'table_observation', 'typeen', '0', '1', '1', '0', 15, NULL);
INSERT INTO table_field VALUES ('codeen', 'table_observation', 'codeen', '0', '1', '1', '0', 16, NULL);
INSERT INTO table_field VALUES ('versionen', 'table_observation', 'versionen', '0', '1', '1', '0', 17, NULL);
INSERT INTO table_field VALUES ('typeinfogeoen', 'table_observation', 'typeinfogeoen', '0', '1', '1', '0', 18, NULL);
INSERT INTO table_field VALUES ('refhabitat', 'table_observation', 'refhabitat', '0', '1', '1', '0', 19, NULL);
INSERT INTO table_field VALUES ('codehabitat', 'table_observation', 'codehabitat', '0', '1', '1', '0', 20, NULL);
INSERT INTO table_field VALUES ('versionrefhabitat', 'table_observation', 'versionrefhabitat', '0', '1', '1', '0', 21, NULL);
INSERT INTO table_field VALUES ('codehabref', 'table_observation', 'codehabref', '0', '1', '1', '0', 22, NULL);
INSERT INTO table_field VALUES ('codemaille', 'table_observation', 'codemaille', '0', '1', '1', '0', 23, NULL);
INSERT INTO table_field VALUES ('versionrefmaille', 'table_observation', 'versionrefmaille', '0', '1', '1', '0', 24, NULL);
INSERT INTO table_field VALUES ('nomrefmaille', 'table_observation', 'nomrefmaille', '0', '1', '1', '0', 25, NULL);
INSERT INTO table_field VALUES ('typeinfogeomaille', 'table_observation', 'typeinfogeomaille', '0', '1', '1', '0', 26, NULL);
INSERT INTO table_field VALUES ('codeme', 'table_observation', 'codeme', '0', '1', '1', '0', 27, NULL);
INSERT INTO table_field VALUES ('versionme', 'table_observation', 'versionme', '0', '1', '1', '0', 28, NULL);
INSERT INTO table_field VALUES ('dateme', 'table_observation', 'dateme', '0', '1', '1', '0', 29, NULL);
INSERT INTO table_field VALUES ('typeinfogeome', 'table_observation', 'typeinfogeome', '0', '1', '1', '0', 30, NULL);
INSERT INTO table_field VALUES ('observateurnomorganisme', 'table_observation', 'observateurnomorganisme', '0', '1', '1', '0', 31, NULL);
INSERT INTO table_field VALUES ('observateuridentite', 'table_observation', 'observateuridentite', '0', '1', '1', '0', 32, NULL);
INSERT INTO table_field VALUES ('observateurmail', 'table_observation', 'observateurmail', '0', '1', '1', '0', 33, NULL);
INSERT INTO table_field VALUES ('determinateurnomorganisme', 'table_observation', 'determinateurnomorganisme', '0', '1', '1', '0', 34, NULL);
INSERT INTO table_field VALUES ('determinateuridentite', 'table_observation', 'determinateuridentite', '0', '1', '1', '0', 35, NULL);
INSERT INTO table_field VALUES ('determinateurmail', 'table_observation', 'determinateurmail', '0', '1', '1', '0', 36, NULL);
INSERT INTO table_field VALUES ('validateurnomorganisme', 'table_observation', 'validateurnomorganisme', '0', '1', '1', '0', 37, NULL);
INSERT INTO table_field VALUES ('validateuridentite', 'table_observation', 'validateuridentite', '0', '1', '1', '0', 38, NULL);
INSERT INTO table_field VALUES ('validateurmail', 'table_observation', 'validateurmail', '0', '1', '1', '0', 39, NULL);
INSERT INTO table_field VALUES ('identifiantorigine', 'table_observation', 'identifiantorigine', '0', '1', '1', '0', 40, NULL);
INSERT INTO table_field VALUES ('dspublique', 'table_observation', 'dspublique', '0', '1', '1', '1', 41, NULL);
INSERT INTO table_field VALUES ('diffusionniveauprecision', 'table_observation', 'diffusionniveauprecision', '0', '1', '1', '0', 42, NULL);
INSERT INTO table_field VALUES ('deefloutage', 'table_observation', 'deefloutage', '0', '1', '1', '0', 43, NULL);
INSERT INTO table_field VALUES ('sensible', 'table_observation', 'sensible', '0', '1', '1', '1', 44, NULL);
INSERT INTO table_field VALUES ('sensiniveau', 'table_observation', 'sensiniveau', '0', '1', '1', '1', 45, NULL);
INSERT INTO table_field VALUES ('sensidateattribution', 'table_observation', 'sensidateattribution', '0', '1', '1', '0', 46, NULL);
INSERT INTO table_field VALUES ('sensireferentiel', 'table_observation', 'sensireferentiel', '0', '1', '1', '0', 47, NULL);
INSERT INTO table_field VALUES ('sensiversionreferentiel', 'table_observation', 'sensiversionreferentiel', '0', '1', '1', '0', 48, NULL);
INSERT INTO table_field VALUES ('statutsource', 'table_observation', 'statutsource', '0', '1', '1', '1', 49, NULL);
INSERT INTO table_field VALUES ('jddcode', 'table_observation', 'jddcode', '0', '1', '1', '0', 50, NULL);
INSERT INTO table_field VALUES ('jddid', 'table_observation', 'jddid', '0', '1', '1', '0', 51, NULL);
INSERT INTO table_field VALUES ('jddsourceid', 'table_observation', 'jddsourceid', '0', '1', '1', '0', 52, NULL);
INSERT INTO table_field VALUES ('jddmetadonneedeeid', 'table_observation', 'jddmetadonneedeeid', '0', '1', '1', '1', 53, NULL);
INSERT INTO table_field VALUES ('organismegestionnairedonnee', 'table_observation', 'organismegestionnairedonnee', '0', '1', '1', '1', 54, NULL);
INSERT INTO table_field VALUES ('codeidcnpdispositif', 'table_observation', 'codeidcnpdispositif', '0', '1', '1', '0', 55, NULL);
INSERT INTO table_field VALUES ('deedatetransformation', 'table_observation', 'deedatetransformation', '0', '1', '1', '1', 56, NULL);
INSERT INTO table_field VALUES ('deedatedernieremodification', 'table_observation', 'deedatedernieremodification', '0', '1', '1', '1', 57, NULL);
INSERT INTO table_field VALUES ('referencebiblio', 'table_observation', 'referencebiblio', '0', '1', '1', '0', 58, NULL);
INSERT INTO table_field VALUES ('orgtransformation', 'table_observation', 'orgtransformation', '0', '1', '1', '1', 59, NULL);
INSERT INTO table_field VALUES ('identifiantpermanent', 'table_observation', 'identifiantpermanent', '0', '1', '1', '1', 60, NULL);
INSERT INTO table_field VALUES ('statutobservation', 'table_observation', 'statutobservation', '0', '1', '1', '1', 61, NULL);
INSERT INTO table_field VALUES ('nomcite', 'table_observation', 'nomcite', '0', '1', '1', '1', 62, NULL);
INSERT INTO table_field VALUES ('datedebut', 'table_observation', 'datedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('datefin', 'table_observation', 'datefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('heuredatedebut', 'table_observation', 'heuredatedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('heuredatefin', 'table_observation', 'heuredatefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('jourdatedebut', 'table_observation', 'jourdatedebut', '0', '1', '1', '1', 63, NULL);
INSERT INTO table_field VALUES ('jourdatefin', 'table_observation', 'jourdatefin', '0', '1', '1', '1', 64, NULL);
INSERT INTO table_field VALUES ('altitudemin', 'table_observation', 'altitudemin', '0', '1', '1', '0', 65, NULL);
INSERT INTO table_field VALUES ('altitudemax', 'table_observation', 'altitudemax', '0', '1', '1', '0', 66, NULL);
INSERT INTO table_field VALUES ('profondeurmin', 'table_observation', 'profondeurmin', '0', '1', '1', '0', 67, NULL);
INSERT INTO table_field VALUES ('profondeurmax', 'table_observation', 'profondeurmax', '0', '1', '1', '0', 68, NULL);
INSERT INTO table_field VALUES ('cdnom', 'table_observation', 'cdnom', '0', '1', '1', '0', 69, NULL);
INSERT INTO table_field VALUES ('cdref', 'table_observation', 'cdref', '0', '1', '1', '0', 70, NULL);
INSERT INTO table_field VALUES ('versiontaxref', 'table_observation', 'versiontaxref', '0', '1', '1', '0', 71, NULL);
INSERT INTO table_field VALUES ('datedetermination', 'table_observation', 'datedetermination', '0', '1', '1', '0', 72, NULL);
INSERT INTO table_field VALUES ('organismestandard', 'table_observation', 'organismestandard', '0', '1', '1', '0', 73, NULL);
INSERT INTO table_field VALUES ('commentaire', 'table_observation', 'commentaire', '0', '1', '1', '0', 74, NULL);
INSERT INTO table_field VALUES ('obsdescription', 'table_observation', 'obsdescription', '0', '1', '1', '0', 75, NULL);
INSERT INTO table_field VALUES ('obsmethode', 'table_observation', 'obsmethode', '0', '1', '1', '0', 76, NULL);
INSERT INTO table_field VALUES ('occetatbiologique', 'table_observation', 'occetatbiologique', '0', '1', '1', '0', 77, NULL);
INSERT INTO table_field VALUES ('occstatutbiogeographique', 'table_observation', 'occstatutbiogeographique', '0', '1', '1', '0', 78, NULL);
INSERT INTO table_field VALUES ('occmethodedetermination', 'table_observation', 'occmethodedetermination', '0', '1', '1', '0', 79, NULL);
INSERT INTO table_field VALUES ('occnaturalite', 'table_observation', 'occnaturalite', '0', '1', '1', '0', 80, NULL);
INSERT INTO table_field VALUES ('occsexe', 'table_observation', 'occsexe', '0', '1', '1', '0', 81, NULL);
INSERT INTO table_field VALUES ('occstadedevie', 'table_observation', 'occstadedevie', '0', '1', '1', '0', 82, NULL);
INSERT INTO table_field VALUES ('occstatutbiologique', 'table_observation', 'occstatutbiologique', '0', '1', '1', '0', 83, NULL);
INSERT INTO table_field VALUES ('preuveexistante', 'table_observation', 'preuveexistante', '0', '1', '1', '0', 84, NULL);
INSERT INTO table_field VALUES ('preuvenonnumerique', 'table_observation', 'preuvenonnumerique', '0', '1', '1', '0', 85, NULL);
INSERT INTO table_field VALUES ('preuvenumerique', 'table_observation', 'preuvenumerique', '0', '1', '1', '0', 86, NULL);
INSERT INTO table_field VALUES ('obscontexte', 'table_observation', 'obscontexte', '0', '1', '1', '0', 87, NULL);
INSERT INTO table_field VALUES ('identifiantregroupementpermanent', 'table_observation', 'identifiantregroupementpermanent', '0', '1', '1', '0', 88, NULL);
INSERT INTO table_field VALUES ('methoderegroupement', 'table_observation', 'methoderegroupement', '0', '1', '1', '0', 89, NULL);
INSERT INTO table_field VALUES ('typeregroupement', 'table_observation', 'typeregroupement', '0', '1', '1', '0', 90, NULL);
INSERT INTO table_field VALUES ('altitudemoyenne', 'table_observation', 'altitudemoyenne', '0', '1', '1', '0', 91, NULL);
INSERT INTO table_field VALUES ('profondeurmoyenne', 'table_observation', 'profondeurmoyenne', '0', '1', '1', '0', 92, NULL);
INSERT INTO table_field VALUES ('geometrie', 'table_observation', 'geometrie', '1', '1', '1', '0', 93, NULL);
INSERT INTO table_field VALUES ('natureobjetgeo', 'table_observation', 'natureobjetgeo', '0', '1', '1', '0', 94, NULL);
INSERT INTO table_field VALUES ('precisiongeometrie', 'table_observation', 'precisiongeometrie', '0', '1', '1', '0', 95, NULL);
INSERT INTO table_field VALUES ('sensimanuelle', 'table_observation', 'sensimanuelle', '1', '1', '0', '1', 96, NULL);
INSERT INTO table_field VALUES ('sensialerte', 'table_observation', 'sensialerte', '1', '1', '0', '1', 97, NULL);

--
-- Data for Name: table_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_tree VALUES ('RAW_DATA', 'table_observation', '*', NULL, NULL);


--
-- Data for Name: translation; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO translation VALUES ('table_observation', 'PROVIDER_ID', 'FR', 'Organisme', 'L''organisme');
INSERT INTO translation VALUES ('table_observation', 'SUBMISSION_ID', 'FR', 'Identifiant de soumission', 'L''identifiant de soumission');
INSERT INTO translation VALUES ('table_observation', 'OGAM_ID_table_observation', 'FR', 'Observation', 'L''identifiant de l''observation');
INSERT INTO translation VALUES ('table_observation', 'PROVIDER_ID', 'EN', 'The identifier of the provider', 'The identifier of the provider');
INSERT INTO translation VALUES ('table_observation', 'SUBMISSION_ID', 'EN', 'Submission ID', 'The identifier of a submission');
INSERT INTO translation VALUES ('table_observation', 'OGAM_ID_table_observation', 'EN', 'Observation', 'The identifier of a observation');