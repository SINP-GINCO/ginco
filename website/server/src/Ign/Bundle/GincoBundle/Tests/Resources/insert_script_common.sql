-- This script is the common script for unit testing.
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

INSERT INTO checks VALUES (1000,'COMPLIANCE','EMPTY_FILE_ERROR','Files cannot be empty','Files cannot be empty.',NULL,'ERROR');
INSERT INTO checks VALUES (1001,'COMPLIANCE','WRONG_FIELD_NUMBER','Incorrect number of fields','The number of fields in the line is incorrect, check if all the fields are present and if none contains the semicolon character.',NULL,'ERROR');
INSERT INTO checks VALUES (1002,'COMPLIANCE','INTEGRITY_CONSTRAINT','Integrity constraints not respected','Integrity constraints not respected, please check that the linked data exist (when inserting) or not (when deleting) .',NULL,'ERROR');
INSERT INTO checks VALUES (1003,'COMPLIANCE','UNEXPECTED_SQL_ERROR','Unexpected SQL error','Unexpected SQL error, please contact the administrator',NULL,'ERROR');
INSERT INTO checks VALUES (1004,'COMPLIANCE','DUPLICATE_ROW','Duplicate line','Duplicate line.',NULL,'ERROR');
INSERT INTO checks VALUES (1101,'COMPLIANCE','MANDATORY_FIELD_MISSING','Mandatory field','Mandatory field is missing, please enter a value.',NULL,'ERROR');
INSERT INTO checks VALUES (1102,'COMPLIANCE','INVALID_FORMAT','Format not respected','The field''s format does not respect the awaited format, please check the format.',NULL,'ERROR');
INSERT INTO checks VALUES (1103,'COMPLIANCE','INVALID_TYPE_FIELD','Invalid field type','The field''s type does not correspond to the awaited type, please check the relevance of the field.',NULL,'ERROR');
INSERT INTO checks VALUES (1104,'COMPLIANCE','INVALID_DATE_FIELD','Invalid date','The date format is not valid.',NULL,'ERROR');
INSERT INTO checks VALUES (1105,'COMPLIANCE','INVALID_CODE_FIELD','Invalid code','The field''s type does not correspond to the awaited code, please check the relevance of the field.',NULL,'ERROR');
INSERT INTO checks VALUES (1106,'COMPLIANCE','INVALID_RANGE_FIELD','Invalid range','The field''s type does not correspond to the awaited range values (min and max), please check the relevance of the field.',NULL,'ERROR');
INSERT INTO checks VALUES (1107,'COMPLIANCE','STRING_TOO_LONG','String too long','The data value is too long.',NULL,'ERROR');
INSERT INTO checks VALUES (1108,'COMPLIANCE','UNDEFINED_COLUMN','Undefined column','Undefined column',NULL,'ERROR');
INSERT INTO checks VALUES (1109,'COMPLIANCE','NO_MAPPING','No mapping for this field','The field in the csv file has no destination column','--','ERROR');


--
-- Data for Name: checks_per_provider; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: unit; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO unit VALUES ('Integer','INTEGER',NULL,'integer',NULL);
INSERT INTO unit VALUES ('Decimal','NUMERIC',NULL,'float',NULL);
INSERT INTO unit VALUES ('CharacterString','STRING',NULL,'text',NULL);
INSERT INTO unit VALUES ('IDString','STRING','ID','text',NULL);
INSERT INTO unit VALUES ('Date','DATE',NULL,'date',NULL);
INSERT INTO unit VALUES ('DateTime','DATE',NULL,'date time',NULL);
INSERT INTO unit VALUES ('BOOLEAN','BOOLEAN',NULL,'boolean',NULL);
INSERT INTO unit VALUES ('GEOM','GEOM',NULL,'The geometrical position of an abservation','The geometrical position of an abservation');
INSERT INTO unit VALUES ('PROVIDER_ID','CODE','MODE','fournisseur de données','fournisseur de données');
INSERT INTO unit VALUES ('REGIONS','ARRAY','DYNAMIC','Région','Région');
INSERT INTO unit VALUES ('StatutSourceValue','CODE','DYNAMIC','Statut de la source','Statut de la source');
INSERT INTO unit VALUES ('DSPubliqueValue','CODE','DYNAMIC','DS de la DEE publique ou privée','DS de la DEE publique ou privée');
INSERT INTO unit VALUES ('StatutObservationValue','CODE','DYNAMIC','Statut de l''observation','Statut de l''observation');
INSERT INTO unit VALUES ('TaxRefValue','CODE','TAXREF','Code cd_nom du taxon','Code cd_nom du taxon');
INSERT INTO unit VALUES ('ObjetDenombrementValue','CODE','DYNAMIC','Objet du dénombrement','Objet du dénombrement');
INSERT INTO unit VALUES ('TypeDenombrementValue','CODE','DYNAMIC','Méthode de dénombrement','Méthode de dénombrement');
INSERT INTO unit VALUES ('CodeHabitatValue','ARRAY','DYNAMIC','Code de l''habitat du taxon','Code de l''habitat du taxon');
INSERT INTO unit VALUES ('CodeRefHabitatValue','ARRAY','DYNAMIC','Référentiel identifiant l''habitat','Référentiel identifiant l''habitat');
INSERT INTO unit VALUES ('NatureObjetGeoValue','CODE','DYNAMIC','Nature de l’objet géographique ','Nature de l’objet géographique ');
INSERT INTO unit VALUES ('CodeMailleValue','ARRAY','DYNAMIC','Maille INPN 10*10 kms','Maille INPN 10*10 kms');
INSERT INTO unit VALUES ('CodeCommuneValue','ARRAY','DYNAMIC','Code de la commune','Code de la commune');
INSERT INTO unit VALUES ('NomCommuneValue','ARRAY','DYNAMIC','Nom de la commune','Nom de la commune');
INSERT INTO unit VALUES ('CodeENValue','ARRAY','DYNAMIC','Code de l''espace naturel','Code de l''espace naturel');
INSERT INTO unit VALUES ('TypeENValue','ARRAY','DYNAMIC','Type d''espace naturel oude zonage','Type d''espace naturel oude zonage');
INSERT INTO unit VALUES ('CodeMasseEauValue','ARRAY','DYNAMIC','Code de la masse d''eau','Code de la masse d''eau');
INSERT INTO unit VALUES ('CodeDepartementValue','ARRAY','DYNAMIC','Code INSEE du département','Code INSEE du département');
INSERT INTO unit VALUES ('CodeHabRefValue','ARRAY','DYNAMIC','Code HABREF de l''habitat','Code HABREF de l''habitat');
INSERT INTO unit VALUES ('OrganismeType','STRING',NULL,'OrganismeType','OrganismeType');
INSERT INTO unit VALUES ('HabitatType','STRING',NULL,'HabitatType','HabitatType');
INSERT INTO unit VALUES ('IDCNPValue','CODE','DYNAMIC','Code dispositif de collecte','Code dispositif de collecte');
INSERT INTO unit VALUES ('TypeInfoGeoValue','CODE','DYNAMIC','Type d''information géographique','Type d''information géographique');
INSERT INTO unit VALUES ('VersionMasseDEauValue','CODE','DYNAMIC','Version du référentiel Masse d''Eau','Version du référentiel Masse d''Eau');
INSERT INTO unit VALUES ('NiveauPrecisionValue','CODE','DYNAMIC','Niveau maximal de diffusion','Niveau maximal de diffusion');
INSERT INTO unit VALUES ('DiffusionFloutageValue','CODE','DYNAMIC','Floutage transformation DEE','Floutage transformation DEE');
INSERT INTO unit VALUES ('SensibleValue','CODE','DYNAMIC','Observation sensible','Observation sensible');
INSERT INTO unit VALUES ('SensibiliteValue','CODE','DYNAMIC','Degré de sensibilité','Degré de sensibilité');
INSERT INTO unit VALUES ('TypeRegroupementValue','CODE','DYNAMIC','Type de regroupement','Type de regroupement');
INSERT INTO unit VALUES ('DenombrementType','STRING',NULL,'DenombrementType','DenombrementType');
INSERT INTO unit VALUES ('PersonneType','STRING',NULL,'PersonneType','PersonneType');
INSERT INTO unit VALUES ('ObjetGeographiqueType','STRING',NULL,'ObjetGeographiqueType','ObjetGeographiqueType');
INSERT INTO unit VALUES ('OccurrenceNaturalisteValue','CODE','DYNAMIC','Naturalité de l''occurrence','Naturalité de l''occurrence');
INSERT INTO unit VALUES ('OccurrenceSexeValue','CODE','DYNAMIC','Sexe','Sexe');
INSERT INTO unit VALUES ('OccurrenceStadeDeVieValue','CODE','DYNAMIC','Stade de développement','Stade de développement');
INSERT INTO unit VALUES ('OccurrenceStatutBiologiqueValue','CODE','DYNAMIC','Comportement','Comportement');
INSERT INTO unit VALUES ('PreuveExistanteValue','CODE','DYNAMIC','Preuve de l''existance','Preuve de l''existance');
INSERT INTO unit VALUES ('ObservationMethodeValue','CODE','DYNAMIC','Méthode d''observation','Méthode d''observation');
INSERT INTO unit VALUES ('OccurrenceEtatBiologiqueValue','CODE','DYNAMIC','Code de l''état biologique','Code de l''état biologique');


--
-- Data for Name: data; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO data VALUES ('PROVIDER_ID','PROVIDER_ID','The identifier of the provider','The identifier of the provider',NULL);
INSERT INTO data VALUES ('SUBMISSION_ID','Integer','Submission ID','The identifier of a submission',NULL);
INSERT INTO data VALUES ('OGAM_ID_1_LOCALISATION','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('OGAM_ID_1_OBSERVATION','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('OGAM_ID','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('codecommune','CodeCommuneValue','Code INSEE de la commune','Code de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur. ',NULL);
INSERT INTO data VALUES ('nomCommune','NomCommuneValue','Nom de la commune','Libellé de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur.',NULL);
INSERT INTO data VALUES ('anneeRefCommune','Date','Année du référentiel commune','Année de production du référentiel INSEE, qui sert à déterminer quel est le référentiel en vigueur pour le code et le nom de la commune.',NULL);
INSERT INTO data VALUES ('typeInfoGeoCommune','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('denombrementMin','Integer','Nombre minimum d''individus','Nombre minimum d''individus du taxon composant l''observation.',NULL);
INSERT INTO data VALUES ('denombrementMax','Integer','Nombre maximum d''individus ','Nombre maximum d''individus du taxon composant l''observation.',NULL);
INSERT INTO data VALUES ('objetDenombrement','ObjetDenombrementValue','Objet du dénombrement','Objet sur lequel porte le dénombrement.',NULL);
INSERT INTO data VALUES ('typeDenombrement','TypeDenombrementValue','Méthode de dénombrement (Inspire) ','Méthode utilisée pour le dénombrement (Inspire).',NULL);
INSERT INTO data VALUES ('codeDepartement','CodeDepartementValue','Code INSEE du département','Code INSEE en vigueur suivant l''année du référentiel INSEE des départements, auquel l''information est rattachée.',NULL);
INSERT INTO data VALUES ('anneeRefDepartement','Date','Année du référentiel département','Année du référentiel INSEE utilisé.',NULL);
INSERT INTO data VALUES ('typeInfoGeoDepartement','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('typeEN','TypeENValue','Type d''espace naturel oude zonage','Indique le type d’espace naturel protégé, ou de zonage (Natura 2000, Znieff1, Znieff2).',NULL);
INSERT INTO data VALUES ('codeEN','CodeENValue','Code de l''espace naturel','Code de l’espace naturel sur lequel a été faite l’observation, en fonction du type d''espace naturel.',NULL);
INSERT INTO data VALUES ('versionEN','Date','Version du référentiel EN (date)','Version du référentiel consulté respectant la norme ISO 8601, sous la forme YYYY-MM-dd (année-mois-jour), YYYY-MM (année-mois), ou YYYY (année).',NULL);
INSERT INTO data VALUES ('typeInfoGeoEN','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('refHabitat','CodeRefHabitatValue','Référentiel identifiant l''habitat','RefHabitat correspond au référentiel utilisé pour identifier l''habitat de l''observation. Il est codé selon les acronymes utilisés sur le site de l''INPN mettant à disposition en téléchargement les référentiels "habitats" et "typologies".',NULL);
INSERT INTO data VALUES ('codeHabitat','CodeHabitatValue','Code de l''habitat ','Code métier de l''habitat où le taxon de l''observation a été identifié. Le référentiel Habitat est indiqué dans le champ « RefHabitat ». Il peut être trouvé dans la colonne "LB_CODE" d''HABREF.',NULL);
INSERT INTO data VALUES ('versionRefHabitat','CharacterString','Version du référentiel Habitat (date)','Version du référentiel utilisé (suivant la norme ISO 8601, sous la forme YYYY-MM-dd, YYYY-MM, ou YYYY).',NULL);
INSERT INTO data VALUES ('codeHabRef','CodeHabRefValue','Code HABREF de l''habitat','Code HABREF de l''habitat où le taxon de l''observation a été identifié. Il peut être trouvé dans la colonne "CD_HAB" d''HabRef.',NULL);
INSERT INTO data VALUES ('codeMaille','CodeMailleValue','Maille INPN 10*10 kms','Code de la cellule de la grille de référence nationale 10kmx10km dans laquelle se situe l’observation.',NULL);
INSERT INTO data VALUES ('versionRefMaille','CharacterString','Version du référentiel maille','Version du référentiel des mailles utilisé.',NULL);
INSERT INTO data VALUES ('nomRefMaille','CharacterString','Nom de la couche de maille','Nom de la couche de maille utilisée : Concaténation des éléments des colonnes "couche" et "territoire" de la page http://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref.',NULL);
INSERT INTO data VALUES ('typeInfoGeoMaille','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('codeME','CodeMasseEauValue','Code masse d''eau','Code de la ou les masse(s) d''eau à la (aux)quelle(s) l''observation a été rattachée.',NULL);
INSERT INTO data VALUES ('versionME','VersionMasseDEauValue','Version du référentiel Masse d''Eau','Version du référentiel masse d''eau utilisé et prélevé sur le site du SANDRE, telle que décrite sur le site du SANDRE.',NULL);
INSERT INTO data VALUES ('dateME','Date','Date du référentiel Masse d''Eau','Date de consultation ou de prélèvement du référentiel sur le site du SANDRE.',NULL);
INSERT INTO data VALUES ('typeInfoGeoMasseDEau','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('geometrie','GEOM','Géométrie','La géométrie de la localisation (au format WKT)',NULL);
INSERT INTO data VALUES ('natureObjetGeo','NatureObjetGeoValue','Nature de l’objet géographique ','Nature de la localisation transmise ',NULL);
INSERT INTO data VALUES ('precisionGeometrie','Integer','Précision de l''objet géographique (m)','Estimation en mètres d’une zone tampon autour de l''objet géographique. Cette précision peut inclure la précision du moyen technique d’acquisition des coordonnées (GPS,…) et/ou du protocole naturaliste.',NULL);
INSERT INTO data VALUES ('nomorganisme','CharacterString','Nom officiel de(s) l''organisme(s).','Nom officiel de l''organisme. Si plusieurs organismes sont nécessaires, les séparer par des virgules.',NULL);
INSERT INTO data VALUES ('identite','CharacterString','NOM Prénom (organisme)','NOM Prénom (organisme) de la personne ou des personnes concernées. Dans le cas de plusieurs personnes, on séparera les personnes par des virgules.',NULL);
INSERT INTO data VALUES ('mail','CharacterString','Mail de la personne référente','Mail de la personne référente, pour permettre de la contacter rapidement si nécessaire.',NULL);
INSERT INTO data VALUES ('identifiantOrigine','CharacterString','Identifiant de la donnée source','Identifiant unique de la Donnée Source de l’observation dans la base de données du producteur où est stockée et initialement gérée la Donnée Source. La DS est caractérisée par jddid et/ou jddcode,.',NULL);
INSERT INTO data VALUES ('dSPublique','DSPubliqueValue','DS de la DEE publique ou privée','Indique explicitement si la DS de la DEE est publique ou privée. Définit uniquement les droits nécessaires et suffisants des DS pour produire une DEE. Ne doit être utilisé que pour indiquer si la DEE résultante est susceptible d’être floutée.',NULL);
INSERT INTO data VALUES ('diffusionNiveauPrecision','NiveauPrecisionValue','Niveau maximal de diffusion','Niveau maximal de précision de la diffusion souhaitée par le producteur vers le grand public. Ne concerne que les DEE non sensibles.',NULL);
INSERT INTO data VALUES ('diffusionFloutage','DiffusionFloutageValue','Floutage transformation DEE','Indique si un floutage a été effectué lors de la transformation en DEE. Cela ne concerne que des données d''origine privée.',NULL);
INSERT INTO data VALUES ('sensible','SensibleValue','Observation sensible','Indique si l''observation est sensible d''après les principes du SINP. Va disparaître.',NULL);
INSERT INTO data VALUES ('sensiNiveau','SensibiliteValue','Degré de sensibilité','Indique si l''observation ou le regroupement est sensible d''après les principes du SINP et à quel degré. La manière de déterminer la sensibilité est définie dans le guide technique des données sensibles disponible sur la plate-forme naturefrance.',NULL);
INSERT INTO data VALUES ('sensiDateAttribution','DateTime','Date attribution sensibilité','Date à laquelle on a attribué un niveau de sensibilité à la donnée. C''est également la date à laquelle on a consulté le référentiel de sensibilité associé.',NULL);
INSERT INTO data VALUES ('sensiReferentiel','CharacterString','Référentiel de sensibilité','Référentiel de sensibilité consulté lors de l''attribution du niveau de sensibilité.',NULL);
INSERT INTO data VALUES ('sensiVersionReferentiel','CharacterString','Version du référentiel sensibilité','Version du référentiel consulté. Peut être une date si le référentiel n''a pas de numéro de version. Doit être rempli par "NON EXISTANTE" si un référentiel n''existait pas au moment de l''attribution de la sensibilité par un Organisme.',NULL);
INSERT INTO data VALUES ('statutSource','StatutSourceValue','Statut de la source','Indique si la DS de l’observation provient directement du terrain (via un document informatisé ou une base de données), d''une collection, de la littérature, ou n''est pas connu.',NULL);
INSERT INTO data VALUES ('jddcode','CharacterString','Code identifiant la provenance','Nom, acronyme, ou code de la collection du jeu de données dont provient la donnée source.',NULL);
INSERT INTO data VALUES ('jddid','CharacterString','Identifiant de la provenance','Identifiant pour la collection ou le jeu de données source d''où provient l''enregistrement.',NULL);
INSERT INTO data VALUES ('jddSourceId','CharacterString','Identifiant de la provenance source','Il peut arriver, pour un besoin d''inventaire, par exemple, qu''on réutilise une donnée en provenance d''un autre jeu de données DEE déjà existant au sein du SINP.',NULL);
INSERT INTO data VALUES ('jddMetadonneeDEEId','CharacterString','Identifiant métadonnée','Identifiant permanent et unique de la fiche métadonnées du jeu de données auquel appartient la donnée.',NULL);
INSERT INTO data VALUES ('organismeGestionnaireDonnee','OrganismeType','Organisme gestionnaire de la donnée','Nom de l’organisme qui détient la Donnée Source (DS) de la DEE et qui en a la responsabilité. Si plusieurs organismes sont nécessaires, les séparer par des virgules.',NULL);
INSERT INTO data VALUES ('codeIDCNPDispositif','IDCNPValue','Code dispositif de collecte','Code du dispositif de collecte dans le cadre duquel la donnée a été collectée.',NULL);
INSERT INTO data VALUES ('dEEDateDerniereModification','DateTime','Date modification DEE','Date de dernière modification de la donnée élémentaire d''échange. Postérieure à la date de transformation en DEE, égale dans le cas de l''absence de modification.',NULL);
INSERT INTO data VALUES ('referencebiblio','CharacterString','Référence bibliographique','Référence de la source de l’observation lorsque celle-ci est de type « Littérature », au format ISO690. La référence bibliographique doit concerner l''observation même et non uniquement le taxon ou le protocole.',NULL);
INSERT INTO data VALUES ('orgTransformation','OrganismeType','Organisme créateur de la DEE','Nom de l''organisme ayant créé la DEE finale (plate-forme ou organisme mandaté par elle).',NULL);
INSERT INTO data VALUES ('identifiantPermanent','CharacterString','Identifiant permanent DEE','Identifiant unique et pérenne de la Donnée Elémentaire d’Echange de l''observation dans le SINP attribué par la plateforme régionale ou thématique.',NULL);
INSERT INTO data VALUES ('statutObservation','StatutObservationValue','Statut de l''observation','Indique si le taxon a été observé directement ou indirectement (indices de présence), ou non observé ',NULL);
INSERT INTO data VALUES ('nomCite','CharacterString','Nom du taxon cité par l’observateur','Nom du taxon cité à l’origine par l’observateur. Celui-ci peut être le nom scientifique reprenant idéalement en plus du nom latin, l’auteur et la date. ',NULL);
INSERT INTO data VALUES ('objetGeo','ObjetGeographiqueType','Localisation précise','Localisation précise de l''observation. L''objet ne représente pas un territoire de rattachement (commune, maille etc) : il s''agit d''un géoréférencement précis.',NULL);
INSERT INTO data VALUES ('datedebut','DateTime','Date du jour de début d''observation','Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.',NULL);
INSERT INTO data VALUES ('datefin','DateTime','Date du jour de fin d''observation','Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.',NULL);
INSERT INTO data VALUES ('altitudemin','Decimal','Altitude minimum de l’observation','Altitude minimum de l’observation en mètres.',NULL);
INSERT INTO data VALUES ('altitudemax','Decimal','Altitude maximum de l’observation','Altitude maximum de l’observation en mètres.',NULL);
INSERT INTO data VALUES ('profondeurMin','Decimal','Profondeur minimum de l’observation ','Profondeur minimale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL);
INSERT INTO data VALUES ('profondeurMax','Decimal','Profondeur maximum de l’observation ','Profondeur maximale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL);
INSERT INTO data VALUES ('habitat','HabitatType','Habitat du taxon','Habitat dans lequel le taxon a été observé.',NULL);
INSERT INTO data VALUES ('denombrement','DenombrementType','Nombre d''éléments','Nombre d''élément (cf Objet denombrement) composant l''observation.',NULL);
INSERT INTO data VALUES ('observateur','PersonneType','Observateur','Nom(s), prénom, et organisme(s) de la ou des personnes ayant réalisé l''observation.',NULL);
INSERT INTO data VALUES ('cdnom','TaxRefValue','Code du taxon « cd_nom » de TaxRef','Code du taxon « cd_nom » de TaxRef référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL);
INSERT INTO data VALUES ('cdref','TaxRefValue','Code du taxon « cd_ref » de TaxRef','Code du taxon « cd_ref » de TAXREF référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL);
INSERT INTO data VALUES ('versionTAXREF','CharacterString','Version du référentiel TAXREF','Version du référentiel TAXREF utilisée pour le cdnom et le cdref.',NULL);
INSERT INTO data VALUES ('determinateur','PersonneType','Déterminateur','Prénom, nom et organisme de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.',NULL);
INSERT INTO data VALUES ('dateDetermination','DateTime','Date de la dernière détermination ','Date/heure de la dernière détermination du taxon de l’observation dans le système grégorien.',NULL);
INSERT INTO data VALUES ('validateur','PersonneType','Validateur','Prénom, nom et/ou organisme de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.',NULL);
INSERT INTO data VALUES ('ogrganismeStandard','OrganismeType','Organisme standardisateur','Nom(s) de(s) organisme(s) qui ont participés à la standardisation de la DS en DEE (codage, formatage, recherche des données obligatoires) ',NULL);
INSERT INTO data VALUES ('commentaire','CharacterString','commentaire','Champ libre pour informations complémentaires indicatives sur le sujet d''observation.',NULL);
INSERT INTO data VALUES ('nomAttribut','CharacterString','Nom de l''attribut','Libellé court et implicite de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('definitionAttribut','CharacterString','Définition de l''attribut','Définition précise et complète de l''attribut additionnel.',NULL);
INSERT INTO data VALUES ('valeurAttribut','CharacterString','Valeur de l''attribut','Valeur qualitative ou quantitative de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('uniteAttribut','CharacterString','Unité de l''attribut','Unité de mesure de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('thematiqueAttribut','CharacterString','Thématique de l’attribut','Thématique relative à l''attribut additionnel (mot-clé).',NULL);
INSERT INTO data VALUES ('typeAttribut','CharacterString','Type de l''attribut','Indique si l''attribut additionnel est de type quantitatif ou qualitatif.',NULL);
INSERT INTO data VALUES ('obsDescription','CharacterString','Description de l''observation','Description libre de l''observation, aussi succincte et précise que possible.',NULL);
INSERT INTO data VALUES ('obsMethode','ObservationMethodeValue','Méthode d''observation','Indique de quelle manière on a pu constater la présence d''un sujet d''observation.',NULL);
INSERT INTO data VALUES ('occEtatBiologique','OccurrenceEtatBiologiqueValue','Code de l''état biologique','Code de l''état biologique de l''organisme au moment de l''observation.',NULL);
INSERT INTO data VALUES ('occMethodeDetermination','CharacterString','Méthode de détermination','Description de la méthode utilisée pour déterminer le taxon lors de l''observation.',NULL);
INSERT INTO data VALUES ('occNaturaliste','OccurrenceNaturalisteValue','Naturalité de l''occurrence','Naturalité de l''occurrence, conséquence de l''influence anthropique directe qui la caractérise. Elle peut être déterminée immédiatement par simple observation, y compris par une personne n''ayant pas de formation dans le domaine de la biologie considéré.',NULL);
INSERT INTO data VALUES ('occSexe','OccurrenceSexeValue','Sexe','Sexe du sujet de l''observation.',NULL);
INSERT INTO data VALUES ('occStadeDeVie','OccurrenceStadeDeVieValue','Stade de développement','Stade de développement du sujet de l''observation.',NULL);
INSERT INTO data VALUES ('occStatutBiologique','OccurrenceStatutBiologiqueValue','Comportement','Comportement général de l''individu sur le site d''observation.',NULL);
INSERT INTO data VALUES ('preuveExistante','PreuveExistanteValue','Preuve de l''existance','Indique si une preuve existe ou non. Par preuve on entend un objet physique ou numérique permettant de démontrer l''existence de l''occurrence et/ou d''en vérifier l''exactitude.',NULL);
INSERT INTO data VALUES ('preuveNonNumerique','CharacterString','Nom détenteur','Adresse ou nom de la personne ou de l''organisme qui permettrait de retrouver la preuve non numérique de L''observation.',NULL);
INSERT INTO data VALUES ('preuveNumerique','CharacterString','Adresse preuve','Adresse web à laquelle on pourra trouver la preuve numérique ou l''archive contenant toutes les preuves numériques (image(s), sonogramme(s), film(s), séquence(s) génétique(s)...).',NULL);
INSERT INTO data VALUES ('obsContexte','CharacterString','Description du contexte','Description libre du contexte de l''observation, aussi succincte et précise que possible.',NULL);
INSERT INTO data VALUES ('identifiantRegroupementPermanent','CharacterString','UUID du regroupement','Identifiant permanent du regroupement, sous forme d''UUID.',NULL);
INSERT INTO data VALUES ('methodeRegroupement','CharacterString','Méthode de regroupement','Description de la méthode ayant présidé au regroupement, de façon aussi succincte que possible : champ libre.',NULL);
INSERT INTO data VALUES ('typeRegroupement','TypeRegroupementValue','Type de regroupement','Indique quel est le type du regroupement suivant la liste typeRegroupementValue.',NULL);
INSERT INTO data VALUES ('altitudeMoyenne','Decimal','Altitude moyenne regroupement','Altitude moyenne considérée pour le regroupement.',NULL);
INSERT INTO data VALUES ('profondeurMoyenne','Decimal','Profondeur moyenne regroupement','Profondeur moyenne considérée pour le regroupement.',NULL);
INSERT INTO data VALUES ('REGIONS','REGIONS','Région','Région',NULL);


--
-- Data for Name: dataset; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset VALUES ('std_occ_taxon_dee_v1-2','std_occ_taxon_dee_v1-2','0','std_occ_taxon_dee_v1-2','IMPORT');


--
-- Data for Name: format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO format VALUES ('observation_file', 'FILE');
INSERT INTO format VALUES ('localisation_file', 'FILE');
INSERT INTO format VALUES ('observation_data', 'TABLE');
INSERT INTO format VALUES ('localisation_data', 'TABLE');
INSERT INTO format VALUES ('observation_form', 'FORM');
INSERT INTO format VALUES ('localisation_form', 'FORM');



--
-- Data for Name: field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('geometrie', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_file', 'FILE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codecommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrementMin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrementMax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('objetDenombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeDenombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('refHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeHabRef', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionRefMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomRefMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dateME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomorganisme', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identite', 'observation_file', 'FILE');
INSERT INTO field VALUES ('mail', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dSPublique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_file', 'FILE');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensible', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiNiveau', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_file', 'FILE');
INSERT INTO field VALUES ('statutSource', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddcode', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddid', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddSourceId', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_file', 'FILE');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_file', 'FILE');
INSERT INTO field VALUES ('referencebiblio', 'observation_file', 'FILE');
INSERT INTO field VALUES ('orgTransformation', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_file', 'FILE');
INSERT INTO field VALUES ('statutObservation', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomCite', 'observation_file', 'FILE');
INSERT INTO field VALUES ('objetGeo', 'observation_file', 'FILE');
INSERT INTO field VALUES ('datedebut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('datefin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudemax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('habitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('observateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('cdnom', 'observation_file', 'FILE');
INSERT INTO field VALUES ('cdref', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionTAXREF', 'observation_file', 'FILE');
INSERT INTO field VALUES ('determinateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dateDetermination', 'observation_file', 'FILE');
INSERT INTO field VALUES ('validateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_file', 'FILE');
INSERT INTO field VALUES ('commentaire', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('definitionAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('valeurAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('uniteAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsDescription', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsMethode', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occNaturaliste', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occSexe', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveExistante', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveNumerique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsContexte', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_file', 'FILE');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeRegroupement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_file', 'FILE');
INSERT INTO field VALUES ('REGIONS', 'observation_file', 'FILE');
INSERT INTO field VALUES ('geometrie', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codecommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrementMin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrementMax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('objetDenombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeDenombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('refHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeHabRef', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionRefMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomRefMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dateME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomorganisme', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identite', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('mail', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dSPublique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensible', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiNiveau', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('statutSource', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddcode', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddid', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddSourceId', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('referencebiblio', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('orgTransformation', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('statutObservation', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomCite', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('objetGeo', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('datedebut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('datefin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudemin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('habitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('observateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdref', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionTAXREF', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('determinateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dateDetermination', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('validateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('commentaire', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('definitionAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('valeurAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('uniteAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsDescription', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsMethode', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occNaturaliste', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occSexe', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveExistante', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveNumerique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsContexte', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeRegroupement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('REGIONS', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('geometrie', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'observation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codecommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrementMin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrementMax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('objetDenombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeDenombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('refHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeHabRef', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionRefMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomRefMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dateME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomorganisme', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identite', 'observation_form', 'FORM');
INSERT INTO field VALUES ('mail', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dSPublique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_form', 'FORM');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensible', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiNiveau', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_form', 'FORM');
INSERT INTO field VALUES ('statutSource', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddcode', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddid', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddSourceId', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_form', 'FORM');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_form', 'FORM');
INSERT INTO field VALUES ('referencebiblio', 'observation_form', 'FORM');
INSERT INTO field VALUES ('orgTransformation', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_form', 'FORM');
INSERT INTO field VALUES ('statutObservation', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomCite', 'observation_form', 'FORM');
INSERT INTO field VALUES ('objetGeo', 'observation_form', 'FORM');
INSERT INTO field VALUES ('datedebut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('datefin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudemin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudemax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('habitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('observateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('cdref', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionTAXREF', 'observation_form', 'FORM');
INSERT INTO field VALUES ('determinateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dateDetermination', 'observation_form', 'FORM');
INSERT INTO field VALUES ('validateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_form', 'FORM');
INSERT INTO field VALUES ('commentaire', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('definitionAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('valeurAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('uniteAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsDescription', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsMethode', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occNaturaliste', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occSexe', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveExistante', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveNumerique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsContexte', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_form', 'FORM');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeRegroupement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_form', 'FORM');
INSERT INTO field VALUES ('REGIONS', 'observation_form', 'FORM');
--
-- Data for Name: dataset_fields; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','PROVIDER_ID');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','SUBMISSION_ID');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','geometrie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codecommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','anneeRefCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrementMin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrementMax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','objetDenombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeDenombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','anneeRefDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','refHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionRefHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeHabRef');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionRefMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomRefMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dateME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoMasseDEau');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','natureObjetGeo');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','precisionGeometrie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomorganisme');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identite');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','mail');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantOrigine');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dSPublique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','diffusionNiveauPrecision');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','diffusionFloutage');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensible');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiNiveau');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiDateAttribution');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiReferentiel');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiVersionReferentiel');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','statutSource');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddcode');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddid');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddSourceId');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddMetadonneeDEEId');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','organismeGestionnaireDonnee');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeIDCNPDispositif');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dEEDateDerniereModification');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','referencebiblio');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','orgTransformation');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantPermanent');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','statutObservation');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomCite');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','objetGeo');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','datedebut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','datefin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudemin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudemax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','habitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','observateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','cdnom');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','cdref');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionTAXREF');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','determinateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dateDetermination');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','validateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','ogrganismeStandard');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','commentaire');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','definitionAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','valeurAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','uniteAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','thematiqueAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsDescription');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsMethode');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occEtatBiologique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occMethodeDetermination');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occNaturaliste');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occSexe');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occStadeDeVie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occStatutBiologique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveExistante');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveNonNumerique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveNumerique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsContexte');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantRegroupementPermanent');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','methodeRegroupement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeRegroupement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudeMoyenne');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMoyenne');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','REGIONS');


--
-- Data for Name: file_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_format VALUES ('observation_file','CSV','observation_file',0,'fichier_dee_v1-2_observation','fichier_dee_v1-2_observation');
INSERT INTO file_format VALUES ('localisation_file','CSV','localisation_file',1,'fichier_dee_v1-2_localisation','fichier_dee_v1-2_localisation');


--
-- Data for Name: dataset_files; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_files VALUES ('std_occ_taxon_dee_v1-2','observation_file');
INSERT INTO dataset_files VALUES ('std_occ_taxon_dee_v1-2','localisation_file');

--
-- Data for Name: form_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_format VALUES ('observation_form','form_dee_v1-2_observation','form_dee_v1-2_observation',0,'1');
INSERT INTO form_format VALUES ('localisation_form','form_dee_v1-2_localisation','form_dee_v1-2_localisation',1,'1');


--
-- Data for Name: dataset_forms; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_forms VALUES ('std_occ_taxon_dee_v1-2','observation_form');
INSERT INTO dataset_forms VALUES ('std_occ_taxon_dee_v1-2','localisation_form');

--
-- Data for Name: dynamode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dynamode VALUES ('CodeCommuneValue','SELECT code as code, code as label FROM referentiels.communes ORDER BY code');
INSERT INTO dynamode VALUES ('NomCommuneValue','SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.communes ORDER BY nom');
INSERT INTO dynamode VALUES ('CodeDepartementValue','SELECT dp as code, nom_depart as label FROM referentiels.departements ORDER BY dp');
INSERT INTO dynamode VALUES ('REGIONS','SELECT code as code, nom as label FROM referentiels.regions ORDER BY code');
INSERT INTO dynamode VALUES ('CodeMailleValue','SELECT code10km as code, cd_sig as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeENValue','SELECT codeen as code, codeen as label FROM referentiels.codeenvalue ORDER BY codeEN');
INSERT INTO dynamode VALUES ('StatutSourceValue','SELECT code as code, label as label FROM referentiels.StatutSourceValue ORDER BY code');
INSERT INTO dynamode VALUES ('DSPubliqueValue','SELECT code as code, label as label FROM referentiels.DSPubliqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('StatutObservationValue','SELECT code as code, label as label FROM referentiels.StatutObservationValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObjetDenombrementValue','SELECT code as code, label as label FROM referentiels.ObjetDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeDenombrementValue','SELECT code as code, label as label FROM referentiels.TypeDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabitatValue','SELECT lb_code as code, lb_code as label FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1 ');
INSERT INTO dynamode VALUES ('CodeRefHabitatValue','SELECT code as code, label as label FROM referentiels.CodeRefHabitatValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NatureObjetGeoValue','SELECT code as code, label as label FROM referentiels.NatureObjetGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeENValue','SELECT code as code, label as label FROM referentiels.TypeENValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeMasseEauValue','SELECT cdmassedea as code, cdmassedea as label FROM referentiels.CodeMasseEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabRefValue','SELECT cd_hab as code, cd_hab as label FROM referentiels.habref_20 ORDER BY code ');
INSERT INTO dynamode VALUES ('IDCNPValue','SELECT code as code, label as label FROM referentiels.IDCNPValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeInfoGeoValue','SELECT code as code, label as label FROM referentiels.TypeInfoGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('VersionMasseDEauValue','SELECT code as code, label as label FROM referentiels.VersionMasseDEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NiveauPrecisionValue','SELECT code as code, label as label FROM referentiels.NiveauPrecisionValue ORDER BY code ');
INSERT INTO dynamode VALUES ('DiffusionFloutageValue','SELECT code as code, label as label FROM referentiels.DiffusionFloutageValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibleValue','SELECT code as code, label as label FROM referentiels.SensibleValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibiliteValue','SELECT code as code, label as label FROM referentiels.SensibiliteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeRegroupementValue','SELECT code as code, label as label FROM referentiels.TypeRegroupementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceNaturalisteValue','SELECT code as code, label as label FROM referentiels.OccurrenceNaturalisteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceSexeValue','SELECT code as code, label as label FROM referentiels.OccurrenceSexeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStadeDeVieValue','SELECT code as code, label as label FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiologiqueValue','SELECT code as code, label as label FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PreuveExistanteValue','SELECT code as code, label as label FROM referentiels.PreuveExistanteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObservationMethodeValue','SELECT code as code, label as label FROM referentiels.ObservationMethodeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceEtatBiologiqueValue','SELECT code as code, label as label FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code ');


--
-- Data for Name: field_mapping; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field_mapping VALUES ('PROVIDER_ID','localisation_form','PROVIDER_ID','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','localisation_form','OGAM_ID_1_LOCALISATION','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('geometrie','localisation_form','geometrie','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('PROVIDER_ID','observation_form','PROVIDER_ID','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_OBSERVATION','observation_form','OGAM_ID_1_OBSERVATION','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','observation_form','OGAM_ID_1_LOCALISATION','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codecommune','observation_form','codecommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomCommune','observation_form','nomCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('anneeRefCommune','observation_form','anneeRefCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoCommune','observation_form','typeInfoGeoCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrementMin','observation_form','denombrementMin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrementMax','observation_form','denombrementMax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('objetDenombrement','observation_form','objetDenombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeDenombrement','observation_form','typeDenombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeDepartement','observation_form','codeDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('anneeRefDepartement','observation_form','anneeRefDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoDepartement','observation_form','typeInfoGeoDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeEN','observation_form','typeEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeEN','observation_form','codeEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionEN','observation_form','versionEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoEN','observation_form','typeInfoGeoEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('refHabitat','observation_form','refHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeHabitat','observation_form','codeHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionRefHabitat','observation_form','versionRefHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeHabRef','observation_form','codeHabRef','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeMaille','observation_form','codeMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionRefMaille','observation_form','versionRefMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomRefMaille','observation_form','nomRefMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoMaille','observation_form','typeInfoGeoMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeME','observation_form','codeME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionME','observation_form','versionME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dateME','observation_form','dateME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoMasseDEau','observation_form','typeInfoGeoMasseDEau','observation_data','FORM');
INSERT INTO field_mapping VALUES ('natureObjetGeo','localisation_form','natureObjetGeo','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('precisionGeometrie','localisation_form','precisionGeometrie','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('nomorganisme','observation_form','nomorganisme','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identite','observation_form','identite','observation_data','FORM');
INSERT INTO field_mapping VALUES ('mail','observation_form','mail','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantOrigine','observation_form','identifiantOrigine','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dSPublique','observation_form','dSPublique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('diffusionNiveauPrecision','observation_form','diffusionNiveauPrecision','observation_data','FORM');
INSERT INTO field_mapping VALUES ('diffusionFloutage','observation_form','diffusionFloutage','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensible','observation_form','sensible','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiNiveau','observation_form','sensiNiveau','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiDateAttribution','observation_form','sensiDateAttribution','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiReferentiel','observation_form','sensiReferentiel','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiVersionReferentiel','observation_form','sensiVersionReferentiel','observation_data','FORM');
INSERT INTO field_mapping VALUES ('statutSource','observation_form','statutSource','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddcode','observation_form','jddcode','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddid','observation_form','jddid','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddSourceId','observation_form','jddSourceId','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddMetadonneeDEEId','observation_form','jddMetadonneeDEEId','observation_data','FORM');
INSERT INTO field_mapping VALUES ('organismeGestionnaireDonnee','observation_form','organismeGestionnaireDonnee','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeIDCNPDispositif','observation_form','codeIDCNPDispositif','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dEEDateDerniereModification','observation_form','dEEDateDerniereModification','observation_data','FORM');
INSERT INTO field_mapping VALUES ('referencebiblio','observation_form','referencebiblio','observation_data','FORM');
INSERT INTO field_mapping VALUES ('orgTransformation','observation_form','orgTransformation','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantPermanent','observation_form','identifiantPermanent','observation_data','FORM');
INSERT INTO field_mapping VALUES ('statutObservation','observation_form','statutObservation','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomCite','observation_form','nomCite','observation_data','FORM');
INSERT INTO field_mapping VALUES ('objetGeo','observation_form','objetGeo','observation_data','FORM');
INSERT INTO field_mapping VALUES ('datedebut','observation_form','datedebut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('datefin','observation_form','datefin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudemin','observation_form','altitudemin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudemax','observation_form','altitudemax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMin','observation_form','profondeurMin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMax','observation_form','profondeurMax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('habitat','observation_form','habitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrement','observation_form','denombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('observateur','observation_form','observateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('cdnom','observation_form','cdnom','observation_data','FORM');
INSERT INTO field_mapping VALUES ('cdref','observation_form','cdref','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionTAXREF','observation_form','versionTAXREF','observation_data','FORM');
INSERT INTO field_mapping VALUES ('determinateur','observation_form','determinateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dateDetermination','observation_form','dateDetermination','observation_data','FORM');
INSERT INTO field_mapping VALUES ('validateur','observation_form','validateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('ogrganismeStandard','observation_form','ogrganismeStandard','observation_data','FORM');
INSERT INTO field_mapping VALUES ('commentaire','observation_form','commentaire','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomAttribut','observation_form','nomAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('definitionAttribut','observation_form','definitionAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('valeurAttribut','observation_form','valeurAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('uniteAttribut','observation_form','uniteAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('thematiqueAttribut','observation_form','thematiqueAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeAttribut','observation_form','typeAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsDescription','observation_form','obsDescription','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsMethode','observation_form','obsMethode','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occEtatBiologique','observation_form','occEtatBiologique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occMethodeDetermination','observation_form','occMethodeDetermination','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occNaturaliste','observation_form','occNaturaliste','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occSexe','observation_form','occSexe','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occStadeDeVie','observation_form','occStadeDeVie','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occStatutBiologique','observation_form','occStatutBiologique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveExistante','observation_form','preuveExistante','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveNonNumerique','observation_form','preuveNonNumerique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveNumerique','observation_form','preuveNumerique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsContexte','observation_form','obsContexte','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantRegroupementPermanent','observation_form','identifiantRegroupementPermanent','observation_data','FORM');
INSERT INTO field_mapping VALUES ('methodeRegroupement','observation_form','methodeRegroupement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeRegroupement','observation_form','typeRegroupement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudeMoyenne','observation_form','altitudeMoyenne','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMoyenne','observation_form','profondeurMoyenne','observation_data','FORM');
INSERT INTO field_mapping VALUES ('REGIONS','observation_form','REGIONS','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','localisation_file','OGAM_ID_1_LOCALISATION','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('geometrie','localisation_file','geometrie','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_OBSERVATION','observation_file','OGAM_ID_1_OBSERVATION','observation_data','FILE');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','observation_file','OGAM_ID_1_LOCALISATION','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codecommune','observation_file','codecommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomCommune','observation_file','nomCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('anneeRefCommune','observation_file','anneeRefCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoCommune','observation_file','typeInfoGeoCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrementMin','observation_file','denombrementMin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrementMax','observation_file','denombrementMax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('objetDenombrement','observation_file','objetDenombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeDenombrement','observation_file','typeDenombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeDepartement','observation_file','codeDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('anneeRefDepartement','observation_file','anneeRefDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoDepartement','observation_file','typeInfoGeoDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeEN','observation_file','typeEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeEN','observation_file','codeEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionEN','observation_file','versionEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoEN','observation_file','typeInfoGeoEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('refHabitat','observation_file','refHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeHabitat','observation_file','codeHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionRefHabitat','observation_file','versionRefHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeHabRef','observation_file','codeHabRef','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeMaille','observation_file','codeMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionRefMaille','observation_file','versionRefMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomRefMaille','observation_file','nomRefMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoMaille','observation_file','typeInfoGeoMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeME','observation_file','codeME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionME','observation_file','versionME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dateME','observation_file','dateME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoMasseDEau','observation_file','typeInfoGeoMasseDEau','observation_data','FILE');
INSERT INTO field_mapping VALUES ('natureObjetGeo','localisation_file','natureObjetGeo','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('precisionGeometrie','localisation_file','precisionGeometrie','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('nomorganisme','observation_file','nomorganisme','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identite','observation_file','identite','observation_data','FILE');
INSERT INTO field_mapping VALUES ('mail','observation_file','mail','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantOrigine','observation_file','identifiantOrigine','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dSPublique','observation_file','dSPublique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('diffusionNiveauPrecision','observation_file','diffusionNiveauPrecision','observation_data','FILE');
INSERT INTO field_mapping VALUES ('diffusionFloutage','observation_file','diffusionFloutage','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensible','observation_file','sensible','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiNiveau','observation_file','sensiNiveau','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiDateAttribution','observation_file','sensiDateAttribution','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiReferentiel','observation_file','sensiReferentiel','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiVersionReferentiel','observation_file','sensiVersionReferentiel','observation_data','FILE');
INSERT INTO field_mapping VALUES ('statutSource','observation_file','statutSource','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddcode','observation_file','jddcode','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddid','observation_file','jddid','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddSourceId','observation_file','jddSourceId','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddMetadonneeDEEId','observation_file','jddMetadonneeDEEId','observation_data','FILE');
INSERT INTO field_mapping VALUES ('organismeGestionnaireDonnee','observation_file','organismeGestionnaireDonnee','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeIDCNPDispositif','observation_file','codeIDCNPDispositif','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dEEDateDerniereModification','observation_file','dEEDateDerniereModification','observation_data','FILE');
INSERT INTO field_mapping VALUES ('referencebiblio','observation_file','referencebiblio','observation_data','FILE');
INSERT INTO field_mapping VALUES ('orgTransformation','observation_file','orgTransformation','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantPermanent','observation_file','identifiantPermanent','observation_data','FILE');
INSERT INTO field_mapping VALUES ('statutObservation','observation_file','statutObservation','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomCite','observation_file','nomCite','observation_data','FILE');
INSERT INTO field_mapping VALUES ('objetGeo','observation_file','objetGeo','observation_data','FILE');
INSERT INTO field_mapping VALUES ('datedebut','observation_file','datedebut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('datefin','observation_file','datefin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudemin','observation_file','altitudemin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudemax','observation_file','altitudemax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMin','observation_file','profondeurMin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMax','observation_file','profondeurMax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('habitat','observation_file','habitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrement','observation_file','denombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('observateur','observation_file','observateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('cdnom','observation_file','cdnom','observation_data','FILE');
INSERT INTO field_mapping VALUES ('cdref','observation_file','cdref','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionTAXREF','observation_file','versionTAXREF','observation_data','FILE');
INSERT INTO field_mapping VALUES ('determinateur','observation_file','determinateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dateDetermination','observation_file','dateDetermination','observation_data','FILE');
INSERT INTO field_mapping VALUES ('validateur','observation_file','validateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('ogrganismeStandard','observation_file','ogrganismeStandard','observation_data','FILE');
INSERT INTO field_mapping VALUES ('commentaire','observation_file','commentaire','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomAttribut','observation_file','nomAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('definitionAttribut','observation_file','definitionAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('valeurAttribut','observation_file','valeurAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('uniteAttribut','observation_file','uniteAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('thematiqueAttribut','observation_file','thematiqueAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeAttribut','observation_file','typeAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsDescription','observation_file','obsDescription','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsMethode','observation_file','obsMethode','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occEtatBiologique','observation_file','occEtatBiologique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occMethodeDetermination','observation_file','occMethodeDetermination','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occNaturaliste','observation_file','occNaturaliste','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occSexe','observation_file','occSexe','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occStadeDeVie','observation_file','occStadeDeVie','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occStatutBiologique','observation_file','occStatutBiologique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveExistante','observation_file','preuveExistante','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveNonNumerique','observation_file','preuveNonNumerique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveNumerique','observation_file','preuveNumerique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsContexte','observation_file','obsContexte','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantRegroupementPermanent','observation_file','identifiantRegroupementPermanent','observation_data','FILE');
INSERT INTO field_mapping VALUES ('methodeRegroupement','observation_file','methodeRegroupement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeRegroupement','observation_file','typeRegroupement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudeMoyenne','observation_file','altitudeMoyenne','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMoyenne','observation_file','profondeurMoyenne','observation_data','FILE');
INSERT INTO field_mapping VALUES ('REGIONS','observation_file','REGIONS','observation_data','FILE');


--
-- Data for Name: file_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_file', '1', NULL, '1');
INSERT INTO file_field VALUES ('geometrie', 'localisation_file', '0', NULL, '2');
INSERT INTO file_field VALUES ('natureObjetGeo', 'localisation_file', '0', NULL, '3');
INSERT INTO file_field VALUES ('precisionGeometrie', 'localisation_file', '0', NULL, '4');
INSERT INTO file_field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_file', '1', NULL, '1');
INSERT INTO file_field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_file', '1', NULL, '2');
INSERT INTO file_field VALUES ('codecommune', 'observation_file', '0', NULL, '3');
INSERT INTO file_field VALUES ('nomCommune', 'observation_file', '0', NULL, '4');
INSERT INTO file_field VALUES ('anneeRefCommune', 'observation_file', '0', 'yyyy', '5');
INSERT INTO file_field VALUES ('typeInfoGeoCommune', 'observation_file', '0', NULL, '6');
INSERT INTO file_field VALUES ('denombrementMin', 'observation_file', '0', NULL, '7');
INSERT INTO file_field VALUES ('denombrementMax', 'observation_file', '0', NULL, '8');
INSERT INTO file_field VALUES ('objetDenombrement', 'observation_file', '0', NULL, '9');
INSERT INTO file_field VALUES ('typeDenombrement', 'observation_file', '0', NULL, '10');
INSERT INTO file_field VALUES ('codeDepartement', 'observation_file', '0', NULL, '11');
INSERT INTO file_field VALUES ('anneeRefDepartement', 'observation_file', '0', 'yyyy', '12');
INSERT INTO file_field VALUES ('typeInfoGeoDepartement', 'observation_file', '0', NULL, '13');
INSERT INTO file_field VALUES ('typeEN', 'observation_file', '0', NULL, '14');
INSERT INTO file_field VALUES ('codeEN', 'observation_file', '0', NULL, '15');
INSERT INTO file_field VALUES ('versionEN', 'observation_file', '0', NULL, '16');
INSERT INTO file_field VALUES ('typeInfoGeoEN', 'observation_file', '0', NULL, '17');
INSERT INTO file_field VALUES ('refHabitat', 'observation_file', '0', NULL, '18');
INSERT INTO file_field VALUES ('codeHabitat', 'observation_file', '0', NULL, '19');
INSERT INTO file_field VALUES ('versionRefHabitat', 'observation_file', '0', NULL, '20');
INSERT INTO file_field VALUES ('codeHabRef', 'observation_file', '0', NULL, '21');
INSERT INTO file_field VALUES ('codeMaille', 'observation_file', '0', NULL, '22');
INSERT INTO file_field VALUES ('versionRefMaille', 'observation_file', '0', NULL, '23');
INSERT INTO file_field VALUES ('nomRefMaille', 'observation_file', '0', NULL, '24');
INSERT INTO file_field VALUES ('typeInfoGeoMaille', 'observation_file', '0', NULL, '25');
INSERT INTO file_field VALUES ('codeME', 'observation_file', '0', NULL, '26');
INSERT INTO file_field VALUES ('versionME', 'observation_file', '0', NULL, '27');
INSERT INTO file_field VALUES ('dateME', 'observation_file', '0', 'yyyy-MM-dd', '28');
INSERT INTO file_field VALUES ('typeInfoGeoMasseDEau', 'observation_file', '0', NULL, '29');
INSERT INTO file_field VALUES ('nomorganisme', 'observation_file', '0', NULL, '30');
INSERT INTO file_field VALUES ('identite', 'observation_file', '0', NULL, '31');
INSERT INTO file_field VALUES ('mail', 'observation_file', '0', NULL, '32');
INSERT INTO file_field VALUES ('identifiantOrigine', 'observation_file', '0', NULL, '33');
INSERT INTO file_field VALUES ('dSPublique', 'observation_file', '1', NULL, '34');
INSERT INTO file_field VALUES ('diffusionNiveauPrecision', 'observation_file', '0', NULL, '35');
INSERT INTO file_field VALUES ('diffusionFloutage', 'observation_file', '0', NULL, '36');
INSERT INTO file_field VALUES ('sensible', 'observation_file', '1', NULL, '37');
INSERT INTO file_field VALUES ('sensiNiveau', 'observation_file', '1', NULL, '38');
INSERT INTO file_field VALUES ('sensiDateAttribution', 'observation_file', '0', 'yyyy-MM-dd''T''HH:mmZ', '39');
INSERT INTO file_field VALUES ('sensiReferentiel', 'observation_file', '0', NULL, '40');
INSERT INTO file_field VALUES ('sensiVersionReferentiel', 'observation_file', '0', NULL, '41');
INSERT INTO file_field VALUES ('statutSource', 'observation_file', '1', NULL, '42');
INSERT INTO file_field VALUES ('jddcode', 'observation_file', '0', NULL, '43');
INSERT INTO file_field VALUES ('jddid', 'observation_file', '0', NULL, '44');
INSERT INTO file_field VALUES ('jddSourceId', 'observation_file', '0', NULL, '45');
INSERT INTO file_field VALUES ('jddMetadonneeDEEId', 'observation_file', '1', NULL, '46');
INSERT INTO file_field VALUES ('organismeGestionnaireDonnee', 'observation_file', '1', NULL, '47');
INSERT INTO file_field VALUES ('codeIDCNPDispositif', 'observation_file', '0', NULL, '48');
INSERT INTO file_field VALUES ('dEEDateDerniereModification', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '50');
INSERT INTO file_field VALUES ('referencebiblio', 'observation_file', '1', NULL, '51');
INSERT INTO file_field VALUES ('orgTransformation', 'observation_file', '0', NULL, '52');
INSERT INTO file_field VALUES ('identifiantPermanent', 'observation_file', '1', NULL, '53');
INSERT INTO file_field VALUES ('statutObservation', 'observation_file', '1', NULL, '54');
INSERT INTO file_field VALUES ('nomCite', 'observation_file', '1', NULL, '55');
INSERT INTO file_field VALUES ('objetGeo', 'observation_file', '0', NULL, '56');
INSERT INTO file_field VALUES ('datedebut', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '57');
INSERT INTO file_field VALUES ('datefin', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '58');
INSERT INTO file_field VALUES ('altitudemin', 'observation_file', '0', NULL, '59');
INSERT INTO file_field VALUES ('altitudemax', 'observation_file', '0', NULL, '60');
INSERT INTO file_field VALUES ('profondeurMin', 'observation_file', '0', NULL, '61');
INSERT INTO file_field VALUES ('profondeurMax', 'observation_file', '0', NULL, '62');
INSERT INTO file_field VALUES ('habitat', 'observation_file', '0', NULL, '63');
INSERT INTO file_field VALUES ('denombrement', 'observation_file', '0', NULL, '64');
INSERT INTO file_field VALUES ('observateur', 'observation_file', '1', NULL, '65');
INSERT INTO file_field VALUES ('cdnom', 'observation_file', '0', NULL, '66');
INSERT INTO file_field VALUES ('cdref', 'observation_file', '0', NULL, '67');
INSERT INTO file_field VALUES ('versionTAXREF', 'observation_file', '0', NULL, '68');
INSERT INTO file_field VALUES ('determinateur', 'observation_file', '0', NULL, '69');
INSERT INTO file_field VALUES ('dateDetermination', 'observation_file', '0', 'yyyy-MM-dd''T''HH:mmZ', '70');
INSERT INTO file_field VALUES ('validateur', 'observation_file', '0', NULL, '71');
INSERT INTO file_field VALUES ('ogrganismeStandard', 'observation_file', '0', NULL, '72');
INSERT INTO file_field VALUES ('commentaire', 'observation_file', '0', NULL, '73');
INSERT INTO file_field VALUES ('nomAttribut', 'observation_file', '0', NULL, '74');
INSERT INTO file_field VALUES ('definitionAttribut', 'observation_file', '0', NULL, '75');
INSERT INTO file_field VALUES ('valeurAttribut', 'observation_file', '0', NULL, '76');
INSERT INTO file_field VALUES ('uniteAttribut', 'observation_file', '0', NULL, '77');
INSERT INTO file_field VALUES ('thematiqueAttribut', 'observation_file', '0', NULL, '78');
INSERT INTO file_field VALUES ('typeAttribut', 'observation_file', '0', NULL, '79');
INSERT INTO file_field VALUES ('obsDescription', 'observation_file', '0', NULL, '80');
INSERT INTO file_field VALUES ('obsMethode', 'observation_file', '0', NULL, '81');
INSERT INTO file_field VALUES ('occEtatBiologique', 'observation_file', '0', NULL, '82');
INSERT INTO file_field VALUES ('occMethodeDetermination', 'observation_file', '0', NULL, '83');
INSERT INTO file_field VALUES ('occNaturaliste', 'observation_file', '0', NULL, '84');
INSERT INTO file_field VALUES ('occSexe', 'observation_file', '0', NULL, '85');
INSERT INTO file_field VALUES ('occStadeDeVie', 'observation_file', '0', NULL, '86');
INSERT INTO file_field VALUES ('occStatutBiologique', 'observation_file', '0', NULL, '87');
INSERT INTO file_field VALUES ('preuveExistante', 'observation_file', '0', NULL, '88');
INSERT INTO file_field VALUES ('preuveNonNumerique', 'observation_file', '0', NULL, '89');
INSERT INTO file_field VALUES ('preuveNumerique', 'observation_file', '0', NULL, '90');
INSERT INTO file_field VALUES ('obsContexte', 'observation_file', '0', NULL, '91');
INSERT INTO file_field VALUES ('identifiantRegroupementPermanent', 'observation_file', '0', NULL, '92');
INSERT INTO file_field VALUES ('methodeRegroupement', 'observation_file', '0', NULL, '93');
INSERT INTO file_field VALUES ('typeRegroupement', 'observation_file', '0', NULL, '94');
INSERT INTO file_field VALUES ('altitudeMoyenne', 'observation_file', '0', NULL, '95');
INSERT INTO file_field VALUES ('profondeurMoyenne', 'observation_file', '0', NULL, '96');
INSERT INTO file_field VALUES ('REGIONS', 'observation_file', '0', NULL, '97');

--
-- Data for Name: form_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_field VALUES ('geometrie','localisation_form','1','1','SELECT',1,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('natureObjetGeo','localisation_form','1','1','SELECT',2,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('precisionGeometrie','localisation_form','1','1','NUMERIC',3,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID','localisation_form','0','0','SELECT',4,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_LOCALISATION','localisation_form','0','0','NUMERIC',5,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID','observation_form','0','0','SELECT',1,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_OBSERVATION','observation_form','0','0','NUMERIC',2,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_LOCALISATION','observation_form','0','0','NUMERIC',5,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codecommune','observation_form','1','1','SELECT',3,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomCommune','observation_form','1','1','SELECT',4,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneeRefCommune','observation_form','1','1','DATE',5,'0','0',NULL,NULL,'yyyy');
INSERT INTO form_field VALUES ('typeInfoGeoCommune','observation_form','1','1','SELECT',6,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementMin','observation_form','1','1','NUMERIC',7,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementMax','observation_form','1','1','NUMERIC',8,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('objetDenombrement','observation_form','1','1','SELECT',9,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeDenombrement','observation_form','1','1','SELECT',10,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeDepartement','observation_form','1','1','SELECT',11,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneeRefDepartement','observation_form','1','1','DATE',12,'0','0',NULL,NULL,'yyyy');
INSERT INTO form_field VALUES ('typeInfoGeoDepartement','observation_form','1','1','SELECT',13,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeEN','observation_form','1','1','SELECT',14,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeEN','observation_form','1','1','SELECT',15,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionEN','observation_form','1','1','DATE',16,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeInfoGeoEN','observation_form','1','1','SELECT',17,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('refHabitat','observation_form','1','1','SELECT',18,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeHabitat','observation_form','1','1','SELECT',19,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionRefHabitat','observation_form','1','1','SELECT',20,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeHabRef','observation_form','1','1','SELECT',21,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeMaille','observation_form','1','1','SELECT',22,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionRefMaille','observation_form','1','1','TEXT',23,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomRefMaille','observation_form','1','1','TEXT',24,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeInfoGeoMaille','observation_form','1','1','SELECT',25,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeME','observation_form','1','1','SELECT',26,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionME','observation_form','1','1','SELECT',27,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dateME','observation_form','1','1','DATE',28,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('typeInfoGeoMasseDEau','observation_form','1','1','SELECT',29,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomorganisme','observation_form','1','1','TEXT',30,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identite','observation_form','1','1','TEXT',31,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('mail','observation_form','1','1','TEXT',32,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantOrigine','observation_form','1','1','TEXT',33,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dSPublique','observation_form','1','1','SELECT',34,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('diffusionNiveauPrecision','observation_form','1','1','SELECT',35,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('diffusionFloutage','observation_form','1','1','SELECT',36,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensible','observation_form','1','1','SELECT',37,'0','0','0',NULL,NULL);
INSERT INTO form_field VALUES ('sensiNiveau','observation_form','1','1','SELECT',38,'0','0','0',NULL,NULL);
INSERT INTO form_field VALUES ('sensiDateAttribution','observation_form','1','1','DATE',39,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('sensiReferentiel','observation_form','1','1','TEXT',40,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensiVersionReferentiel','observation_form','1','1','TEXT',41,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutSource','observation_form','1','1','SELECT',42,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddcode','observation_form','1','1','TEXT',43,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddid','observation_form','1','1','TEXT',44,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddSourceId','observation_form','1','1','TEXT',45,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddMetadonneeDEEId','observation_form','1','1','TEXT',46,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('organismeGestionnaireDonnee','observation_form','1','1','SELECT',47,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeIDCNPDispositif','observation_form','1','1','SELECT',48,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dEEDateDerniereModification','observation_form','1','1','DATE',50,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('referencebiblio','observation_form','1','1','TEXT',51,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('orgTransformation','observation_form','1','1','TEXT',52,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantPermanent','observation_form','1','1','TEXT',53,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutObservation','observation_form','1','1','SELECT',54,'1','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomCite','observation_form','1','1','TEXT',55,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('objetGeo','observation_form','1','1','TEXT',56,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('datedebut','observation_form','1','1','DATE',57,'1','1',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('datefin','observation_form','1','1','DATE',58,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('altitudemin','observation_form','1','1','NUMERIC',59,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudemax','observation_form','1','1','NUMERIC',60,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMin','observation_form','1','1','NUMERIC',61,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMax','observation_form','1','1','NUMERIC',62,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('habitat','observation_form','1','1','TEXT',63,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrement','observation_form','1','1','TEXT',64,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('observateur','observation_form','1','1','TEXT',65,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdnom','observation_form','1','1','TAXREF',66,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdref','observation_form','1','1','TAXREF',67,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionTAXREF','observation_form','1','1','TEXT',68,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('determinateur','observation_form','1','1','TEXT',69,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dateDetermination','observation_form','1','1','DATE',70,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('validateur','observation_form','1','1','TEXT',71,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('ogrganismeStandard','observation_form','1','1','TEXT',72,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('commentaire','observation_form','1','1','TEXT',73,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomAttribut','observation_form','1','1','TEXT',74,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('definitionAttribut','observation_form','1','1','TEXT',75,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('valeurAttribut','observation_form','1','1','TEXT',76,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('uniteAttribut','observation_form','1','1','TEXT',77,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('thematiqueAttribut','observation_form','1','1','TEXT',78,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeAttribut','observation_form','1','1','TEXT',79,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsDescription','observation_form','1','1','TEXT',80,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsMethode','observation_form','1','1','SELECT',81,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occEtatBiologique','observation_form','1','1','SELECT',82,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occMethodeDetermination','observation_form','1','1','TEXT',83,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occNaturaliste','observation_form','1','1','SELECT',84,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occSexe','observation_form','1','1','SELECT',85,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occStadeDeVie','observation_form','1','1','SELECT',86,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occStatutBiologique','observation_form','1','1','SELECT',87,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveExistante','observation_form','1','1','SELECT',88,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveNonNumerique','observation_form','1','1','TEXT',89,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveNumerique','observation_form','1','1','TEXT',90,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsContexte','observation_form','1','1','TEXT',91,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantRegroupementPermanent','observation_form','1','1','TEXT',92,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('methodeRegroupement','observation_form','1','1','TEXT',93,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeRegroupement','observation_form','1','1','SELECT',94,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudeMoyenne','observation_form','1','1','NUMERIC',95,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMoyenne','observation_form','1','1','NUMERIC',96,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('REGIONS','observation_form','1','1','SELECT',97,'0','0',NULL,NULL,NULL);


--
-- Data for Name: mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO mode VALUES ('PROVIDER_ID','1',1,'admin','admin');

--
-- Data for Name: group_mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: mode_taxref; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: mode_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_schema; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('RAW_DATA', 'RAW_DATA', 'Données sources', 'Contains raw data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('HARMONIZED_DATA', 'HARMONIZED_DATA', 'Données élémentaires d''échange', 'Contains harmonized data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('METADATA', 'METADATA', 'Metadata', 'Contains the tables describing the data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('WEBSITE', 'WEBSITE', 'Website', 'Contains the tables used to operate the web site');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('PUBLIC', 'PUBLIC', 'Public', 'Contains the default PostgreSQL tables and PostGIS functions');


--
-- Data for Name: model; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model VALUES ('1','std_occ_taxon_dee_v1-2','à ne pas supprimer','RAW_DATA');

--
-- Data for Name: model_datasets; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_datasets VALUES ('1','std_occ_taxon_dee_v1-2');


--
-- Data for Name: table_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_format VALUES ('observation_data','_1_observation','RAW_DATA','OGAM_ID_1_OBSERVATION, PROVIDER_ID, SUBMISSION_ID','table_dee_v1-2_observation','table_dee_v1-2_observation');
INSERT INTO table_format VALUES ('localisation_data','_1_localisation','RAW_DATA','OGAM_ID_1_LOCALISATION, PROVIDER_ID, SUBMISSION_ID','table_dee_v1-2_localisation','table_dee_v1-2_localisation');


--
-- Data for Name: model_tables; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_tables VALUES ('1','observation_data');
INSERT INTO model_tables VALUES ('1','localisation_data');

--
-- Data for Name: process; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: range; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_field VALUES ('geometrie','localisation_data','geometrie','1','1','1','0',1,NULL);
INSERT INTO table_field VALUES ('natureObjetGeo','localisation_data','natureObjetGeo','0','1','1','0',2,NULL);
INSERT INTO table_field VALUES ('precisionGeometrie','localisation_data','precisionGeometrie','0','1','1','0',3,NULL);
INSERT INTO table_field VALUES ('SUBMISSION_ID','localisation_data','SUBMISSION_ID','1','0','0','1',4,NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID','localisation_data','PROVIDER_ID','1','0','0','1',5,NULL);
INSERT INTO table_field VALUES ('OGAM_ID_1_LOCALISATION','localisation_data','OGAM_ID_1_LOCALISATION','1','0','0','1',6,'séquence');
INSERT INTO table_field VALUES ('SUBMISSION_ID','observation_data','SUBMISSION_ID','1','0','0','1',1,NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID','observation_data','PROVIDER_ID','1','0','0','1',2,NULL);
INSERT INTO table_field VALUES ('OGAM_ID_1_OBSERVATION','observation_data','OGAM_ID_1_OBSERVATION','1','0','0','1',3,'séquence');
INSERT INTO table_field VALUES ('OGAM_ID_1_LOCALISATION','observation_data','OGAM_ID_1_LOCALISATION','0','0','0','1',4,'séquence');
INSERT INTO table_field VALUES ('codecommune','observation_data','codecommune','0','1','1','0',5,NULL);
INSERT INTO table_field VALUES ('nomCommune','observation_data','nomCommune','0','1','1','0',6,NULL);
INSERT INTO table_field VALUES ('anneeRefCommune','observation_data','anneeRefCommune','0','1','1','0',7,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoCommune','observation_data','typeInfoGeoCommune','0','1','1','0',8,NULL);
INSERT INTO table_field VALUES ('denombrementMin','observation_data','denombrementMin','0','1','1','0',9,NULL);
INSERT INTO table_field VALUES ('denombrementMax','observation_data','denombrementMax','0','1','1','0',10,NULL);
INSERT INTO table_field VALUES ('objetDenombrement','observation_data','objetDenombrement','0','1','1','0',11,NULL);
INSERT INTO table_field VALUES ('typeDenombrement','observation_data','typeDenombrement','0','1','1','0',12,NULL);
INSERT INTO table_field VALUES ('codeDepartement','observation_data','codeDepartement','0','1','1','0',13,NULL);
INSERT INTO table_field VALUES ('anneeRefDepartement','observation_data','anneeRefDepartement','0','1','1','0',14,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoDepartement','observation_data','typeInfoGeoDepartement','0','1','1','0',15,NULL);
INSERT INTO table_field VALUES ('typeEN','observation_data','typeEN','0','1','1','0',16,NULL);
INSERT INTO table_field VALUES ('codeEN','observation_data','codeEN','0','1','1','0',17,NULL);
INSERT INTO table_field VALUES ('versionEN','observation_data','versionEN','0','1','1','0',18,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoEN','observation_data','typeInfoGeoEN','0','1','1','0',19,NULL);
INSERT INTO table_field VALUES ('refHabitat','observation_data','refHabitat','0','1','1','0',20,NULL);
INSERT INTO table_field VALUES ('codeHabitat','observation_data','codeHabitat','0','1','1','0',21,NULL);
INSERT INTO table_field VALUES ('versionRefHabitat','observation_data','versionRefHabitat','0','1','1','0',22,NULL);
INSERT INTO table_field VALUES ('codeHabRef','observation_data','codeHabRef','0','1','1','0',23,NULL);
INSERT INTO table_field VALUES ('codeMaille','observation_data','codeMaille','0','1','1','0',24,NULL);
INSERT INTO table_field VALUES ('versionRefMaille','observation_data','versionRefMaille','0','1','1','0',25,NULL);
INSERT INTO table_field VALUES ('nomRefMaille','observation_data','nomRefMaille','0','1','1','0',26,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoMaille','observation_data','typeInfoGeoMaille','0','1','1','0',27,NULL);
INSERT INTO table_field VALUES ('codeME','observation_data','codeME','0','1','1','0',28,NULL);
INSERT INTO table_field VALUES ('versionME','observation_data','versionME','0','1','1','0',29,NULL);
INSERT INTO table_field VALUES ('dateME','observation_data','dateME','0','1','1','0',30,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoMasseDEau','observation_data','typeInfoGeoMasseDEau','0','1','1','0',31,NULL);
INSERT INTO table_field VALUES ('nomorganisme','observation_data','nomorganisme','0','1','1','0',32,NULL);
INSERT INTO table_field VALUES ('identite','observation_data','identite','0','1','1','0',33,NULL);
INSERT INTO table_field VALUES ('mail','observation_data','mail','0','1','1','0',34,NULL);
INSERT INTO table_field VALUES ('identifiantOrigine','observation_data','identifiantOrigine','0','1','1','0',35,NULL);
INSERT INTO table_field VALUES ('dSPublique','observation_data','dSPublique','0','1','1','1',36,NULL);
INSERT INTO table_field VALUES ('diffusionNiveauPrecision','observation_data','diffusionNiveauPrecision','0','1','1','0',37,NULL);
INSERT INTO table_field VALUES ('diffusionFloutage','observation_data','diffusionFloutage','0','1','1','0',38,NULL);
INSERT INTO table_field VALUES ('sensible','observation_data','sensible','0','1','1','1',39,NULL);
INSERT INTO table_field VALUES ('sensiNiveau','observation_data','sensiNiveau','0','1','1','1',40,NULL);
INSERT INTO table_field VALUES ('sensiDateAttribution','observation_data','sensiDateAttribution','0','1','1','0',41,NULL);
INSERT INTO table_field VALUES ('sensiReferentiel','observation_data','sensiReferentiel','0','1','1','0',42,NULL);
INSERT INTO table_field VALUES ('sensiVersionReferentiel','observation_data','sensiVersionReferentiel','0','1','1','0',43,NULL);
INSERT INTO table_field VALUES ('statutSource','observation_data','statutSource','0','1','1','1',44,NULL);
INSERT INTO table_field VALUES ('jddcode','observation_data','jddcode','0','1','1','0',45,NULL);
INSERT INTO table_field VALUES ('jddid','observation_data','jddid','0','1','1','0',46,NULL);
INSERT INTO table_field VALUES ('jddSourceId','observation_data','jddSourceId','0','1','1','0',47,NULL);
INSERT INTO table_field VALUES ('jddMetadonneeDEEId','observation_data','jddMetadonneeDEEId','0','1','1','1',48,NULL);
INSERT INTO table_field VALUES ('organismeGestionnaireDonnee','observation_data','organismeGestionnaireDonnee','0','1','1','1',49,NULL);
INSERT INTO table_field VALUES ('codeIDCNPDispositif','observation_data','codeIDCNPDispositif','0','1','1','0',50,NULL);
INSERT INTO table_field VALUES ('dEEDateDerniereModification','observation_data','dEEDateDerniereModification','0','1','1','1',52,NULL);
INSERT INTO table_field VALUES ('referencebiblio','observation_data','referencebiblio','0','1','1','0',53,NULL);
INSERT INTO table_field VALUES ('orgTransformation','observation_data','orgTransformation','0','1','1','1',54,NULL);
INSERT INTO table_field VALUES ('identifiantPermanent','observation_data','identifiantPermanent','0','1','1','1',55,NULL);
INSERT INTO table_field VALUES ('statutObservation','observation_data','statutObservation','0','1','1','1',56,NULL);
INSERT INTO table_field VALUES ('nomCite','observation_data','nomCite','0','1','1','1',57,NULL);
INSERT INTO table_field VALUES ('objetGeo','observation_data','objetGeo','0','1','1','0',58,NULL);
INSERT INTO table_field VALUES ('datedebut','observation_data','datedebut','0','1','1','1',59,NULL);
INSERT INTO table_field VALUES ('datefin','observation_data','datefin','0','1','1','1',60,NULL);
INSERT INTO table_field VALUES ('altitudemin','observation_data','altitudemin','0','1','1','0',61,NULL);
INSERT INTO table_field VALUES ('altitudemax','observation_data','altitudemax','0','1','1','0',62,NULL);
INSERT INTO table_field VALUES ('profondeurMin','observation_data','profondeurMin','0','1','1','0',63,NULL);
INSERT INTO table_field VALUES ('profondeurMax','observation_data','profondeurMax','0','1','1','0',64,NULL);
INSERT INTO table_field VALUES ('habitat','observation_data','habitat','0','1','1','0',65,NULL);
INSERT INTO table_field VALUES ('denombrement','observation_data','denombrement','0','1','1','0',66,NULL);
INSERT INTO table_field VALUES ('observateur','observation_data','observateur','0','1','1','1',67,NULL);
INSERT INTO table_field VALUES ('cdnom','observation_data','cdnom','0','1','1','0',68,NULL);
INSERT INTO table_field VALUES ('cdref','observation_data','cdref','0','1','1','0',69,NULL);
INSERT INTO table_field VALUES ('versionTAXREF','observation_data','versionTAXREF','0','1','1','0',70,NULL);
INSERT INTO table_field VALUES ('determinateur','observation_data','determinateur','0','1','1','0',71,NULL);
INSERT INTO table_field VALUES ('dateDetermination','observation_data','dateDetermination','0','1','1','0',72,NULL);
INSERT INTO table_field VALUES ('validateur','observation_data','validateur','0','1','1','0',73,NULL);
INSERT INTO table_field VALUES ('ogrganismeStandard','observation_data','ogrganismeStandard','0','1','1','0',74,NULL);
INSERT INTO table_field VALUES ('commentaire','observation_data','commentaire','0','1','1','0',75,NULL);
INSERT INTO table_field VALUES ('nomAttribut','observation_data','nomAttribut','0','1','1','0',76,NULL);
INSERT INTO table_field VALUES ('definitionAttribut','observation_data','definitionAttribut','0','1','1','0',77,NULL);
INSERT INTO table_field VALUES ('valeurAttribut','observation_data','valeurAttribut','0','1','1','0',78,NULL);
INSERT INTO table_field VALUES ('uniteAttribut','observation_data','uniteAttribut','0','1','1','0',79,NULL);
INSERT INTO table_field VALUES ('thematiqueAttribut','observation_data','thematiqueAttribut','0','1','1','0',80,NULL);
INSERT INTO table_field VALUES ('typeAttribut','observation_data','typeAttribut','0','1','1','0',81,NULL);
INSERT INTO table_field VALUES ('obsDescription','observation_data','obsDescription','0','1','1','0',82,NULL);
INSERT INTO table_field VALUES ('obsMethode','observation_data','obsMethode','0','1','1','0',83,NULL);
INSERT INTO table_field VALUES ('occEtatBiologique','observation_data','occEtatBiologique','0','1','1','0',84,NULL);
INSERT INTO table_field VALUES ('occMethodeDetermination','observation_data','occMethodeDetermination','0','1','1','0',85,NULL);
INSERT INTO table_field VALUES ('occNaturaliste','observation_data','occNaturaliste','0','1','1','0',86,NULL);
INSERT INTO table_field VALUES ('occSexe','observation_data','occSexe','0','1','1','0',87,NULL);
INSERT INTO table_field VALUES ('occStadeDeVie','observation_data','occStadeDeVie','0','1','1','0',88,NULL);
INSERT INTO table_field VALUES ('occStatutBiologique','observation_data','occStatutBiologique','0','1','1','0',89,NULL);
INSERT INTO table_field VALUES ('preuveExistante','observation_data','preuveExistante','0','1','1','0',90,NULL);
INSERT INTO table_field VALUES ('preuveNonNumerique','observation_data','preuveNonNumerique','0','1','1','0',91,NULL);
INSERT INTO table_field VALUES ('preuveNumerique','observation_data','preuveNumerique','0','1','1','0',92,NULL);
INSERT INTO table_field VALUES ('obsContexte','observation_data','obsContexte','0','1','1','0',93,NULL);
INSERT INTO table_field VALUES ('identifiantRegroupementPermanent','observation_data','identifiantRegroupementPermanent','0','1','1','0',94,NULL);
INSERT INTO table_field VALUES ('methodeRegroupement','observation_data','methodeRegroupement','0','1','1','0',95,NULL);
INSERT INTO table_field VALUES ('typeRegroupement','observation_data','typeRegroupement','0','1','1','0',96,NULL);
INSERT INTO table_field VALUES ('altitudeMoyenne','observation_data','altitudeMoyenne','0','1','1','0',97,NULL);
INSERT INTO table_field VALUES ('profondeurMoyenne','observation_data','profondeurMoyenne','0','1','1','0',98,NULL);
INSERT INTO table_field VALUES ('REGIONS','observation_data','REGIONS','0','1','1','0',99,NULL);

--
-- Data for Name: table_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_tree VALUES ('RAW_DATA','observation_data','localisation_data','OGAM_ID_1_LOCALISATION, PROVIDER_ID, SUBMISSION_ID',NULL);
INSERT INTO table_tree VALUES ('RAW_DATA','localisation_data','*',NULL,NULL);


--
-- Data for Name: translation; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO translation VALUES ('observation_data','PROVIDER_ID','FR','Fournisseur de données','L''identifiant du fournisseur de données');
INSERT INTO translation VALUES ('observation_data','SUBMISSION_ID','FR','Identifiant de soumission','L''identifiant de soumission');
INSERT INTO translation VALUES ('observation_data','OGAM_ID_1_OBSERVATION','FR','Observation','L''identifiant de l''observation');
INSERT INTO translation VALUES ('observation_data','PROVIDER_ID','EN','The identifier of the provider','The identifier of the provider');
INSERT INTO translation VALUES ('observation_data','SUBMISSION_ID','EN','Submission ID','The identifier of a submission');
INSERT INTO translation VALUES ('observation_data','OGAM_ID_1_OBSERVATION','EN','Observation','The identifier of a observation');
INSERT INTO translation VALUES ('localisation_data','PROVIDER_ID','FR','Fournisseur de données','L''identifiant du fournisseur de données');
INSERT INTO translation VALUES ('localisation_data','SUBMISSION_ID','FR','Identifiant de soumission','L''identifiant de soumission');
INSERT INTO translation VALUES ('localisation_data','OGAM_ID_1_LOCALISATION','FR','Observation','L''identifiant de l''observation');
INSERT INTO translation VALUES ('localisation_data','geometrie','FR','Géométrie','La géométrie');
INSERT INTO translation VALUES ('localisation_data','PROVIDER_ID','EN','The identifier of the provider','The identifier of the provider');
INSERT INTO translation VALUES ('localisation_data','SUBMISSION_ID','EN','Submission ID','The identifier of a submission');
INSERT INTO translation VALUES ('localisation_data','OGAM_ID_1_LOCALISATION','EN','Observation','The identifier of a observation');
INSERT INTO translation VALUES ('localisation_data','geometrie','EN','Polygon','The geometrical criteria intersected with the plot location');


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

INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1000, 'COMPLIANCE', 'EMPTY_FILE_ERROR', 'Files cannot be empty', 'Files cannot be empty.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1001, 'COMPLIANCE', 'WRONG_FIELD_NUMBER', 'Incorrect number of fields', 'The number of fields in the line is incorrect, check if all the fields are present and if none contains the semicolon character.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1002, 'COMPLIANCE', 'INTEGRITY_CONSTRAINT', 'Integrity constraints not respected', 'Integrity constraints not respected, please check that the linked data exist (when inserting) or not (when deleting) .', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1003, 'COMPLIANCE', 'UNEXPECTED_SQL_ERROR', 'Unexpected SQL error', 'Unexpected SQL error, please contact the administrator', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1004, 'COMPLIANCE', 'DUPLICATE_ROW', 'Duplicate line', 'Duplicate line.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1101, 'COMPLIANCE', 'MANDATORY_FIELD_MISSING', 'Mandatory field', 'Mandatory field is missing, please enter a value.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1102, 'COMPLIANCE', 'INVALID_FORMAT', 'Format not respected', 'The field''s format does not respect the awaited format, please check the format.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1103, 'COMPLIANCE', 'INVALID_TYPE_FIELD', 'Invalid field type', 'The field''s type does not correspond to the awaited type, please check the relevance of the field.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1104, 'COMPLIANCE', 'INVALID_DATE_FIELD', 'Invalid date', 'The date format is not valid.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1105, 'COMPLIANCE', 'INVALID_CODE_FIELD', 'Invalid code', 'The field''s type does not correspond to the awaited code, please check the relevance of the field.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1106, 'COMPLIANCE', 'INVALID_RANGE_FIELD', 'Invalid range', 'The field''s type does not correspond to the awaited range values (min and max), please check the relevance of the field.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1107, 'COMPLIANCE', 'STRING_TOO_LONG', 'String too long', 'The data value is too long.', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1108, 'COMPLIANCE', 'UNDEFINED_COLUMN', 'Undefined column', 'Undefined column', NULL, 'ERROR', '2015-08-04 10:41:41.386777');
INSERT INTO checks (check_id, step, name, label, description, statement, importance, _creationdt) VALUES (1109, 'COMPLIANCE', 'NO_MAPPING', 'No mapping for this field', 'The field in the csv file has no destination column', '--', 'ERROR', '2015-08-04 10:41:41.386777');


--
-- Data for Name: checks_per_provider; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: unit; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO unit VALUES ('Integer','INTEGER',NULL,'integer',NULL);
INSERT INTO unit VALUES ('Decimal','NUMERIC',NULL,'float',NULL);
INSERT INTO unit VALUES ('CharacterString','STRING',NULL,'text',NULL);
INSERT INTO unit VALUES ('IDString','STRING','ID','text',NULL);
INSERT INTO unit VALUES ('Date','DATE',NULL,'date',NULL);
INSERT INTO unit VALUES ('DateTime','DATE',NULL,'date time',NULL);
INSERT INTO unit VALUES ('BOOLEAN','BOOLEAN',NULL,'boolean',NULL);
INSERT INTO unit VALUES ('GEOM','GEOM',NULL,'The geometrical position of an abservation','The geometrical position of an abservation');
INSERT INTO unit VALUES ('PROVIDER_ID','CODE','MODE','fournisseur de données','fournisseur de données');
INSERT INTO unit VALUES ('REGIONS','ARRAY','DYNAMIC','Région','Région');
INSERT INTO unit VALUES ('StatutSourceValue','CODE','DYNAMIC','Statut de la source','Statut de la source');
INSERT INTO unit VALUES ('DSPubliqueValue','CODE','DYNAMIC','DS de la DEE publique ou privée','DS de la DEE publique ou privée');
INSERT INTO unit VALUES ('StatutObservationValue','CODE','DYNAMIC','Statut de l''observation','Statut de l''observation');
INSERT INTO unit VALUES ('TaxRefValue','CODE','TAXREF','Code cd_nom du taxon','Code cd_nom du taxon');
INSERT INTO unit VALUES ('ObjetDenombrementValue','CODE','DYNAMIC','Objet du dénombrement','Objet du dénombrement');
INSERT INTO unit VALUES ('TypeDenombrementValue','CODE','DYNAMIC','Méthode de dénombrement','Méthode de dénombrement');
INSERT INTO unit VALUES ('CodeHabitatValue','ARRAY','DYNAMIC','Code de l''habitat du taxon','Code de l''habitat du taxon');
INSERT INTO unit VALUES ('CodeRefHabitatValue','ARRAY','DYNAMIC','Référentiel identifiant l''habitat','Référentiel identifiant l''habitat');
INSERT INTO unit VALUES ('NatureObjetGeoValue','CODE','DYNAMIC','Nature de l’objet géographique ','Nature de l’objet géographique ');
INSERT INTO unit VALUES ('CodeMailleValue','ARRAY','DYNAMIC','Maille INPN 10*10 kms','Maille INPN 10*10 kms');
INSERT INTO unit VALUES ('CodeCommuneValue','ARRAY','DYNAMIC','Code de la commune','Code de la commune');
INSERT INTO unit VALUES ('NomCommuneValue','ARRAY','DYNAMIC','Nom de la commune','Nom de la commune');
INSERT INTO unit VALUES ('CodeENValue','ARRAY','DYNAMIC','Code de l''espace naturel','Code de l''espace naturel');
INSERT INTO unit VALUES ('TypeENValue','ARRAY','DYNAMIC','Type d''espace naturel oude zonage','Type d''espace naturel oude zonage');
INSERT INTO unit VALUES ('CodeMasseEauValue','ARRAY','DYNAMIC','Code de la masse d''eau','Code de la masse d''eau');
INSERT INTO unit VALUES ('CodeDepartementValue','ARRAY','DYNAMIC','Code INSEE du département','Code INSEE du département');
INSERT INTO unit VALUES ('CodeHabRefValue','ARRAY','DYNAMIC','Code HABREF de l''habitat','Code HABREF de l''habitat');
INSERT INTO unit VALUES ('OrganismeType','STRING',NULL,'OrganismeType','OrganismeType');
INSERT INTO unit VALUES ('HabitatType','STRING',NULL,'HabitatType','HabitatType');
INSERT INTO unit VALUES ('IDCNPValue','CODE','DYNAMIC','Code dispositif de collecte','Code dispositif de collecte');
INSERT INTO unit VALUES ('TypeInfoGeoValue','CODE','DYNAMIC','Type d''information géographique','Type d''information géographique');
INSERT INTO unit VALUES ('VersionMasseDEauValue','CODE','DYNAMIC','Version du référentiel Masse d''Eau','Version du référentiel Masse d''Eau');
INSERT INTO unit VALUES ('NiveauPrecisionValue','CODE','DYNAMIC','Niveau maximal de diffusion','Niveau maximal de diffusion');
INSERT INTO unit VALUES ('DiffusionFloutageValue','CODE','DYNAMIC','Floutage transformation DEE','Floutage transformation DEE');
INSERT INTO unit VALUES ('SensibleValue','CODE','DYNAMIC','Observation sensible','Observation sensible');
INSERT INTO unit VALUES ('SensibiliteValue','CODE','DYNAMIC','Degré de sensibilité','Degré de sensibilité');
INSERT INTO unit VALUES ('TypeRegroupementValue','CODE','DYNAMIC','Type de regroupement','Type de regroupement');
INSERT INTO unit VALUES ('DenombrementType','STRING',NULL,'DenombrementType','DenombrementType');
INSERT INTO unit VALUES ('PersonneType','STRING',NULL,'PersonneType','PersonneType');
INSERT INTO unit VALUES ('ObjetGeographiqueType','STRING',NULL,'ObjetGeographiqueType','ObjetGeographiqueType');
INSERT INTO unit VALUES ('OccurrenceNaturalisteValue','CODE','DYNAMIC','Naturalité de l''occurrence','Naturalité de l''occurrence');
INSERT INTO unit VALUES ('OccurrenceSexeValue','CODE','DYNAMIC','Sexe','Sexe');
INSERT INTO unit VALUES ('OccurrenceStadeDeVieValue','CODE','DYNAMIC','Stade de développement','Stade de développement');
INSERT INTO unit VALUES ('OccurrenceStatutBiologiqueValue','CODE','DYNAMIC','Comportement','Comportement');
INSERT INTO unit VALUES ('PreuveExistanteValue','CODE','DYNAMIC','Preuve de l''existance','Preuve de l''existance');
INSERT INTO unit VALUES ('ObservationMethodeValue','CODE','DYNAMIC','Méthode d''observation','Méthode d''observation');
INSERT INTO unit VALUES ('OccurrenceEtatBiologiqueValue','CODE','DYNAMIC','Code de l''état biologique','Code de l''état biologique');


--
-- Data for Name: data; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO data VALUES ('PROVIDER_ID','PROVIDER_ID','The identifier of the provider','The identifier of the provider',NULL);
INSERT INTO data VALUES ('SUBMISSION_ID','Integer','Submission ID','The identifier of a submission',NULL);
INSERT INTO data VALUES ('OGAM_ID_1_LOCALISATION','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('OGAM_ID_1_OBSERVATION','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('OGAM_ID','Integer','Clé primaire','Clé primaire',NULL);
INSERT INTO data VALUES ('codecommune','CodeCommuneValue','Code INSEE de la commune','Code de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur. ',NULL);
INSERT INTO data VALUES ('nomCommune','NomCommuneValue','Nom de la commune','Libellé de la/les commune(s) où a été effectuée l’observation suivant le référentiel INSEE en vigueur.',NULL);
INSERT INTO data VALUES ('anneeRefCommune','Date','Année du référentiel commune','Année de production du référentiel INSEE, qui sert à déterminer quel est le référentiel en vigueur pour le code et le nom de la commune.',NULL);
INSERT INTO data VALUES ('typeInfoGeoCommune','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('denombrementMin','Integer','Nombre minimum d''individus','Nombre minimum d''individus du taxon composant l''observation.',NULL);
INSERT INTO data VALUES ('denombrementMax','Integer','Nombre maximum d''individus ','Nombre maximum d''individus du taxon composant l''observation.',NULL);
INSERT INTO data VALUES ('objetDenombrement','ObjetDenombrementValue','Objet du dénombrement','Objet sur lequel porte le dénombrement.',NULL);
INSERT INTO data VALUES ('typeDenombrement','TypeDenombrementValue','Méthode de dénombrement (Inspire) ','Méthode utilisée pour le dénombrement (Inspire).',NULL);
INSERT INTO data VALUES ('codeDepartement','CodeDepartementValue','Code INSEE du département','Code INSEE en vigueur suivant l''année du référentiel INSEE des départements, auquel l''information est rattachée.',NULL);
INSERT INTO data VALUES ('anneeRefDepartement','Date','Année du référentiel département','Année du référentiel INSEE utilisé.',NULL);
INSERT INTO data VALUES ('typeInfoGeoDepartement','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('typeEN','TypeENValue','Type d''espace naturel oude zonage','Indique le type d’espace naturel protégé, ou de zonage (Natura 2000, Znieff1, Znieff2).',NULL);
INSERT INTO data VALUES ('codeEN','CodeENValue','Code de l''espace naturel','Code de l’espace naturel sur lequel a été faite l’observation, en fonction du type d''espace naturel.',NULL);
INSERT INTO data VALUES ('versionEN','Date','Version du référentiel EN (date)','Version du référentiel consulté respectant la norme ISO 8601, sous la forme YYYY-MM-dd (année-mois-jour), YYYY-MM (année-mois), ou YYYY (année).',NULL);
INSERT INTO data VALUES ('typeInfoGeoEN','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('refHabitat','CodeRefHabitatValue','Référentiel identifiant l''habitat','RefHabitat correspond au référentiel utilisé pour identifier l''habitat de l''observation. Il est codé selon les acronymes utilisés sur le site de l''INPN mettant à disposition en téléchargement les référentiels "habitats" et "typologies".',NULL);
INSERT INTO data VALUES ('codeHabitat','CodeHabitatValue','Code de l''habitat ','Code métier de l''habitat où le taxon de l''observation a été identifié. Le référentiel Habitat est indiqué dans le champ « RefHabitat ». Il peut être trouvé dans la colonne "LB_CODE" d''HABREF.',NULL);
INSERT INTO data VALUES ('versionRefHabitat','CharacterString','Version du référentiel Habitat (date)','Version du référentiel utilisé (suivant la norme ISO 8601, sous la forme YYYY-MM-dd, YYYY-MM, ou YYYY).',NULL);
INSERT INTO data VALUES ('codeHabRef','CodeHabRefValue','Code HABREF de l''habitat','Code HABREF de l''habitat où le taxon de l''observation a été identifié. Il peut être trouvé dans la colonne "CD_HAB" d''HabRef.',NULL);
INSERT INTO data VALUES ('codeMaille','CodeMailleValue','Maille INPN 10*10 kms','Code de la cellule de la grille de référence nationale 10kmx10km dans laquelle se situe l’observation.',NULL);
INSERT INTO data VALUES ('versionRefMaille','CharacterString','Version du référentiel maille','Version du référentiel des mailles utilisé.',NULL);
INSERT INTO data VALUES ('nomRefMaille','CharacterString','Nom de la couche de maille','Nom de la couche de maille utilisée : Concaténation des éléments des colonnes "couche" et "territoire" de la page http://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref.',NULL);
INSERT INTO data VALUES ('typeInfoGeoMaille','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('codeME','CodeMasseEauValue','Code masse d''eau','Code de la ou les masse(s) d''eau à la (aux)quelle(s) l''observation a été rattachée.',NULL);
INSERT INTO data VALUES ('versionME','VersionMasseDEauValue','Version du référentiel Masse d''Eau','Version du référentiel masse d''eau utilisé et prélevé sur le site du SANDRE, telle que décrite sur le site du SANDRE.',NULL);
INSERT INTO data VALUES ('dateME','Date','Date du référentiel Masse d''Eau','Date de consultation ou de prélèvement du référentiel sur le site du SANDRE.',NULL);
INSERT INTO data VALUES ('typeInfoGeoMasseDEau','TypeInfoGeoValue','Type d''information géographique','Indique le type d''information géographique suivant la nomenclature TypeInfoGeoValue.',NULL);
INSERT INTO data VALUES ('geometrie','GEOM','Géométrie','La géométrie de la localisation (au format WKT)',NULL);
INSERT INTO data VALUES ('natureObjetGeo','NatureObjetGeoValue','Nature de l’objet géographique ','Nature de la localisation transmise ',NULL);
INSERT INTO data VALUES ('precisionGeometrie','Integer','Précision de l''objet géographique (m)','Estimation en mètres d’une zone tampon autour de l''objet géographique. Cette précision peut inclure la précision du moyen technique d’acquisition des coordonnées (GPS,…) et/ou du protocole naturaliste.',NULL);
INSERT INTO data VALUES ('nomorganisme','CharacterString','Nom officiel de(s) l''organisme(s).','Nom officiel de l''organisme. Si plusieurs organismes sont nécessaires, les séparer par des virgules.',NULL);
INSERT INTO data VALUES ('identite','CharacterString','NOM Prénom (organisme)','NOM Prénom (organisme) de la personne ou des personnes concernées. Dans le cas de plusieurs personnes, on séparera les personnes par des virgules.',NULL);
INSERT INTO data VALUES ('mail','CharacterString','Mail de la personne référente','Mail de la personne référente, pour permettre de la contacter rapidement si nécessaire.',NULL);
INSERT INTO data VALUES ('identifiantOrigine','CharacterString','Identifiant de la donnée source','Identifiant unique de la Donnée Source de l’observation dans la base de données du producteur où est stockée et initialement gérée la Donnée Source. La DS est caractérisée par jddid et/ou jddcode,.',NULL);
INSERT INTO data VALUES ('dSPublique','DSPubliqueValue','DS de la DEE publique ou privée','Indique explicitement si la DS de la DEE est publique ou privée. Définit uniquement les droits nécessaires et suffisants des DS pour produire une DEE. Ne doit être utilisé que pour indiquer si la DEE résultante est susceptible d’être floutée.',NULL);
INSERT INTO data VALUES ('diffusionNiveauPrecision','NiveauPrecisionValue','Niveau maximal de diffusion','Niveau maximal de précision de la diffusion souhaitée par le producteur vers le grand public. Ne concerne que les DEE non sensibles.',NULL);
INSERT INTO data VALUES ('diffusionFloutage','DiffusionFloutageValue','Floutage transformation DEE','Indique si un floutage a été effectué lors de la transformation en DEE. Cela ne concerne que des données d''origine privée.',NULL);
INSERT INTO data VALUES ('sensible','SensibleValue','Observation sensible','Indique si l''observation est sensible d''après les principes du SINP. Va disparaître.',NULL);
INSERT INTO data VALUES ('sensiNiveau','SensibiliteValue','Degré de sensibilité','Indique si l''observation ou le regroupement est sensible d''après les principes du SINP et à quel degré. La manière de déterminer la sensibilité est définie dans le guide technique des données sensibles disponible sur la plate-forme naturefrance.',NULL);
INSERT INTO data VALUES ('sensiDateAttribution','DateTime','Date attribution sensibilité','Date à laquelle on a attribué un niveau de sensibilité à la donnée. C''est également la date à laquelle on a consulté le référentiel de sensibilité associé.',NULL);
INSERT INTO data VALUES ('sensiReferentiel','CharacterString','Référentiel de sensibilité','Référentiel de sensibilité consulté lors de l''attribution du niveau de sensibilité.',NULL);
INSERT INTO data VALUES ('sensiVersionReferentiel','CharacterString','Version du référentiel sensibilité','Version du référentiel consulté. Peut être une date si le référentiel n''a pas de numéro de version. Doit être rempli par "NON EXISTANTE" si un référentiel n''existait pas au moment de l''attribution de la sensibilité par un Organisme.',NULL);
INSERT INTO data VALUES ('statutSource','StatutSourceValue','Statut de la source','Indique si la DS de l’observation provient directement du terrain (via un document informatisé ou une base de données), d''une collection, de la littérature, ou n''est pas connu.',NULL);
INSERT INTO data VALUES ('jddcode','CharacterString','Code identifiant la provenance','Nom, acronyme, ou code de la collection du jeu de données dont provient la donnée source.',NULL);
INSERT INTO data VALUES ('jddid','CharacterString','Identifiant de la provenance','Identifiant pour la collection ou le jeu de données source d''où provient l''enregistrement.',NULL);
INSERT INTO data VALUES ('jddSourceId','CharacterString','Identifiant de la provenance source','Il peut arriver, pour un besoin d''inventaire, par exemple, qu''on réutilise une donnée en provenance d''un autre jeu de données DEE déjà existant au sein du SINP.',NULL);
INSERT INTO data VALUES ('jddMetadonneeDEEId','CharacterString','Identifiant métadonnée','Identifiant permanent et unique de la fiche métadonnées du jeu de données auquel appartient la donnée.',NULL);
INSERT INTO data VALUES ('organismeGestionnaireDonnee','OrganismeType','Organisme gestionnaire de la donnée','Nom de l’organisme qui détient la Donnée Source (DS) de la DEE et qui en a la responsabilité. Si plusieurs organismes sont nécessaires, les séparer par des virgules.',NULL);
INSERT INTO data VALUES ('codeIDCNPDispositif','IDCNPValue','Code dispositif de collecte','Code du dispositif de collecte dans le cadre duquel la donnée a été collectée.',NULL);
INSERT INTO data VALUES ('dEEDateDerniereModification','DateTime','Date modification DEE','Date de dernière modification de la donnée élémentaire d''échange. Postérieure à la date de transformation en DEE, égale dans le cas de l''absence de modification.',NULL);
INSERT INTO data VALUES ('referencebiblio','CharacterString','Référence bibliographique','Référence de la source de l’observation lorsque celle-ci est de type « Littérature », au format ISO690. La référence bibliographique doit concerner l''observation même et non uniquement le taxon ou le protocole.',NULL);
INSERT INTO data VALUES ('orgTransformation','OrganismeType','Organisme créateur de la DEE','Nom de l''organisme ayant créé la DEE finale (plate-forme ou organisme mandaté par elle).',NULL);
INSERT INTO data VALUES ('identifiantPermanent','CharacterString','Identifiant permanent DEE','Identifiant unique et pérenne de la Donnée Elémentaire d’Echange de l''observation dans le SINP attribué par la plateforme régionale ou thématique.',NULL);
INSERT INTO data VALUES ('statutObservation','StatutObservationValue','Statut de l''observation','Indique si le taxon a été observé directement ou indirectement (indices de présence), ou non observé ',NULL);
INSERT INTO data VALUES ('nomCite','CharacterString','Nom du taxon cité par l’observateur','Nom du taxon cité à l’origine par l’observateur. Celui-ci peut être le nom scientifique reprenant idéalement en plus du nom latin, l’auteur et la date. ',NULL);
INSERT INTO data VALUES ('objetGeo','ObjetGeographiqueType','Localisation précise','Localisation précise de l''observation. L''objet ne représente pas un territoire de rattachement (commune, maille etc) : il s''agit d''un géoréférencement précis.',NULL);
INSERT INTO data VALUES ('datedebut','DateTime','Date du jour de début d''observation','Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision, cet attribut représente la date la plus ancienne de la période d’imprécision.',NULL);
INSERT INTO data VALUES ('datefin','DateTime','Date du jour de fin d''observation','Date du jour, heure et minute dans le système local de l’observation dans le système grégorien. En cas d’imprécision sur la date, cet attribut représente la date la plus récente de la période d’imprécision.',NULL);
INSERT INTO data VALUES ('altitudemin','Decimal','Altitude minimum de l’observation','Altitude minimum de l’observation en mètres.',NULL);
INSERT INTO data VALUES ('altitudemax','Decimal','Altitude maximum de l’observation','Altitude maximum de l’observation en mètres.',NULL);
INSERT INTO data VALUES ('profondeurMin','Decimal','Profondeur minimum de l’observation ','Profondeur minimale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL);
INSERT INTO data VALUES ('profondeurMax','Decimal','Profondeur maximum de l’observation ','Profondeur maximale de l’observation en mètres selon le référentiel des profondeurs indiqué dans les métadonnées (système de référence spatiale verticale).',NULL);
INSERT INTO data VALUES ('habitat','HabitatType','Habitat du taxon','Habitat dans lequel le taxon a été observé.',NULL);
INSERT INTO data VALUES ('denombrement','DenombrementType','Nombre d''éléments','Nombre d''élément (cf Objet denombrement) composant l''observation.',NULL);
INSERT INTO data VALUES ('observateur','PersonneType','Observateur','Nom(s), prénom, et organisme(s) de la ou des personnes ayant réalisé l''observation.',NULL);
INSERT INTO data VALUES ('cdnom','TaxRefValue','Code du taxon « cd_nom » de TaxRef','Code du taxon « cd_nom » de TaxRef référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL);
INSERT INTO data VALUES ('cdref','TaxRefValue','Code du taxon « cd_ref » de TaxRef','Code du taxon « cd_ref » de TAXREF référençant au niveau national le taxon. Le niveau ou rang taxinomique de la DEE doit être celui de la DS.',NULL);
INSERT INTO data VALUES ('versionTAXREF','CharacterString','Version du référentiel TAXREF','Version du référentiel TAXREF utilisée pour le cdnom et le cdref.',NULL);
INSERT INTO data VALUES ('determinateur','PersonneType','Déterminateur','Prénom, nom et organisme de la ou les personnes ayant réalisé la détermination taxonomique de l’observation.',NULL);
INSERT INTO data VALUES ('dateDetermination','DateTime','Date de la dernière détermination ','Date/heure de la dernière détermination du taxon de l’observation dans le système grégorien.',NULL);
INSERT INTO data VALUES ('validateur','PersonneType','Validateur','Prénom, nom et/ou organisme de la personne ayant réalisée la validation scientifique de l’observation pour le Producteur.',NULL);
INSERT INTO data VALUES ('ogrganismeStandard','OrganismeType','Organisme standardisateur','Nom(s) de(s) organisme(s) qui ont participés à la standardisation de la DS en DEE (codage, formatage, recherche des données obligatoires) ',NULL);
INSERT INTO data VALUES ('commentaire','CharacterString','commentaire','Champ libre pour informations complémentaires indicatives sur le sujet d''observation.',NULL);
INSERT INTO data VALUES ('nomAttribut','CharacterString','Nom de l''attribut','Libellé court et implicite de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('definitionAttribut','CharacterString','Définition de l''attribut','Définition précise et complète de l''attribut additionnel.',NULL);
INSERT INTO data VALUES ('valeurAttribut','CharacterString','Valeur de l''attribut','Valeur qualitative ou quantitative de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('uniteAttribut','CharacterString','Unité de l''attribut','Unité de mesure de l’attribut additionnel.',NULL);
INSERT INTO data VALUES ('thematiqueAttribut','CharacterString','Thématique de l’attribut','Thématique relative à l''attribut additionnel (mot-clé).',NULL);
INSERT INTO data VALUES ('typeAttribut','CharacterString','Type de l''attribut','Indique si l''attribut additionnel est de type quantitatif ou qualitatif.',NULL);
INSERT INTO data VALUES ('obsDescription','CharacterString','Description de l''observation','Description libre de l''observation, aussi succincte et précise que possible.',NULL);
INSERT INTO data VALUES ('obsMethode','ObservationMethodeValue','Méthode d''observation','Indique de quelle manière on a pu constater la présence d''un sujet d''observation.',NULL);
INSERT INTO data VALUES ('occEtatBiologique','OccurrenceEtatBiologiqueValue','Code de l''état biologique','Code de l''état biologique de l''organisme au moment de l''observation.',NULL);
INSERT INTO data VALUES ('occMethodeDetermination','CharacterString','Méthode de détermination','Description de la méthode utilisée pour déterminer le taxon lors de l''observation.',NULL);
INSERT INTO data VALUES ('occNaturaliste','OccurrenceNaturalisteValue','Naturalité de l''occurrence','Naturalité de l''occurrence, conséquence de l''influence anthropique directe qui la caractérise. Elle peut être déterminée immédiatement par simple observation, y compris par une personne n''ayant pas de formation dans le domaine de la biologie considéré.',NULL);
INSERT INTO data VALUES ('occSexe','OccurrenceSexeValue','Sexe','Sexe du sujet de l''observation.',NULL);
INSERT INTO data VALUES ('occStadeDeVie','OccurrenceStadeDeVieValue','Stade de développement','Stade de développement du sujet de l''observation.',NULL);
INSERT INTO data VALUES ('occStatutBiologique','OccurrenceStatutBiologiqueValue','Comportement','Comportement général de l''individu sur le site d''observation.',NULL);
INSERT INTO data VALUES ('preuveExistante','PreuveExistanteValue','Preuve de l''existance','Indique si une preuve existe ou non. Par preuve on entend un objet physique ou numérique permettant de démontrer l''existence de l''occurrence et/ou d''en vérifier l''exactitude.',NULL);
INSERT INTO data VALUES ('preuveNonNumerique','CharacterString','Nom détenteur','Adresse ou nom de la personne ou de l''organisme qui permettrait de retrouver la preuve non numérique de L''observation.',NULL);
INSERT INTO data VALUES ('preuveNumerique','CharacterString','Adresse preuve','Adresse web à laquelle on pourra trouver la preuve numérique ou l''archive contenant toutes les preuves numériques (image(s), sonogramme(s), film(s), séquence(s) génétique(s)...).',NULL);
INSERT INTO data VALUES ('obsContexte','CharacterString','Description du contexte','Description libre du contexte de l''observation, aussi succincte et précise que possible.',NULL);
INSERT INTO data VALUES ('identifiantRegroupementPermanent','CharacterString','UUID du regroupement','Identifiant permanent du regroupement, sous forme d''UUID.',NULL);
INSERT INTO data VALUES ('methodeRegroupement','CharacterString','Méthode de regroupement','Description de la méthode ayant présidé au regroupement, de façon aussi succincte que possible : champ libre.',NULL);
INSERT INTO data VALUES ('typeRegroupement','TypeRegroupementValue','Type de regroupement','Indique quel est le type du regroupement suivant la liste typeRegroupementValue.',NULL);
INSERT INTO data VALUES ('altitudeMoyenne','Decimal','Altitude moyenne regroupement','Altitude moyenne considérée pour le regroupement.',NULL);
INSERT INTO data VALUES ('profondeurMoyenne','Decimal','Profondeur moyenne regroupement','Profondeur moyenne considérée pour le regroupement.',NULL);
INSERT INTO data VALUES ('REGIONS','REGIONS','Région','Région',NULL);


--
-- Data for Name: dataset; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset VALUES ('std_occ_taxon_dee_v1-2','std_occ_taxon_dee_v1-2','0','std_occ_taxon_dee_v1-2','IMPORT');

--
-- Data for Name: format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO format VALUES ('observation_file', 'FILE');
INSERT INTO format VALUES ('localisation_file', 'FILE');
INSERT INTO format VALUES ('observation_data', 'TABLE');
INSERT INTO format VALUES ('localisation_data', 'TABLE');
INSERT INTO format VALUES ('observation_form', 'FORM');
INSERT INTO format VALUES ('localisation_form', 'FORM');


--
-- Data for Name: field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('geometrie', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_file', 'FILE');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_file', 'FILE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codecommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrementMin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrementMax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('objetDenombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeDenombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_file', 'FILE');
INSERT INTO field VALUES ('refHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeHabRef', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionRefMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomRefMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dateME', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomorganisme', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identite', 'observation_file', 'FILE');
INSERT INTO field VALUES ('mail', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dSPublique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_file', 'FILE');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensible', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiNiveau', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_file', 'FILE');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_file', 'FILE');
INSERT INTO field VALUES ('statutSource', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddcode', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddid', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddSourceId', 'observation_file', 'FILE');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_file', 'FILE');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_file', 'FILE');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_file', 'FILE');
INSERT INTO field VALUES ('referencebiblio', 'observation_file', 'FILE');
INSERT INTO field VALUES ('orgTransformation', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_file', 'FILE');
INSERT INTO field VALUES ('statutObservation', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomCite', 'observation_file', 'FILE');
INSERT INTO field VALUES ('objetGeo', 'observation_file', 'FILE');
INSERT INTO field VALUES ('datedebut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('datefin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudemin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudemax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMin', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMax', 'observation_file', 'FILE');
INSERT INTO field VALUES ('habitat', 'observation_file', 'FILE');
INSERT INTO field VALUES ('denombrement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('observateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('cdnom', 'observation_file', 'FILE');
INSERT INTO field VALUES ('cdref', 'observation_file', 'FILE');
INSERT INTO field VALUES ('versionTAXREF', 'observation_file', 'FILE');
INSERT INTO field VALUES ('determinateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('dateDetermination', 'observation_file', 'FILE');
INSERT INTO field VALUES ('validateur', 'observation_file', 'FILE');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_file', 'FILE');
INSERT INTO field VALUES ('commentaire', 'observation_file', 'FILE');
INSERT INTO field VALUES ('nomAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('definitionAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('valeurAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('uniteAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeAttribut', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsDescription', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsMethode', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occNaturaliste', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occSexe', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_file', 'FILE');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveExistante', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('preuveNumerique', 'observation_file', 'FILE');
INSERT INTO field VALUES ('obsContexte', 'observation_file', 'FILE');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_file', 'FILE');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('typeRegroupement', 'observation_file', 'FILE');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_file', 'FILE');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_file', 'FILE');
INSERT INTO field VALUES ('REGIONS', 'observation_file', 'FILE');
INSERT INTO field VALUES ('geometrie', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_data', 'TABLE');
INSERT INTO field VALUES ('SUBMISSION_ID', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('PROVIDER_ID', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codecommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrementMin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrementMax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('objetDenombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeDenombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('refHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeHabRef', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionRefMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomRefMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dateME', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomorganisme', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identite', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('mail', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dSPublique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensible', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiNiveau', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('statutSource', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddcode', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddid', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddSourceId', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('referencebiblio', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('orgTransformation', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('statutObservation', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomCite', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('objetGeo', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('datedebut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('datefin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudemin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudemax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMin', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMax', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('habitat', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('denombrement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('observateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdnom', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('cdref', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('versionTAXREF', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('determinateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('dateDetermination', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('validateur', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('commentaire', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('nomAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('definitionAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('valeurAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('uniteAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeAttribut', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsDescription', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsMethode', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occNaturaliste', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occSexe', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveExistante', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('preuveNumerique', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('obsContexte', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('typeRegroupement', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('REGIONS', 'observation_data', 'TABLE');
INSERT INTO field VALUES ('geometrie', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('natureObjetGeo', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('precisionGeometrie', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_form', 'FORM');
INSERT INTO field VALUES ('PROVIDER_ID', 'observation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_form', 'FORM');
INSERT INTO field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codecommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('anneeRefCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoCommune', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrementMin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrementMax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('objetDenombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeDenombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('anneeRefDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoDepartement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoEN', 'observation_form', 'FORM');
INSERT INTO field VALUES ('refHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionRefHabitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeHabRef', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionRefMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomRefMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoMaille', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dateME', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeInfoGeoMasseDEau', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomorganisme', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identite', 'observation_form', 'FORM');
INSERT INTO field VALUES ('mail', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantOrigine', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dSPublique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('diffusionNiveauPrecision', 'observation_form', 'FORM');
INSERT INTO field VALUES ('diffusionFloutage', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensible', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiNiveau', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiDateAttribution', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiReferentiel', 'observation_form', 'FORM');
INSERT INTO field VALUES ('sensiVersionReferentiel', 'observation_form', 'FORM');
INSERT INTO field VALUES ('statutSource', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddcode', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddid', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddSourceId', 'observation_form', 'FORM');
INSERT INTO field VALUES ('jddMetadonneeDEEId', 'observation_form', 'FORM');
INSERT INTO field VALUES ('organismeGestionnaireDonnee', 'observation_form', 'FORM');
INSERT INTO field VALUES ('codeIDCNPDispositif', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dEEDateDerniereModification', 'observation_form', 'FORM');
INSERT INTO field VALUES ('referencebiblio', 'observation_form', 'FORM');
INSERT INTO field VALUES ('orgTransformation', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantPermanent', 'observation_form', 'FORM');
INSERT INTO field VALUES ('statutObservation', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomCite', 'observation_form', 'FORM');
INSERT INTO field VALUES ('objetGeo', 'observation_form', 'FORM');
INSERT INTO field VALUES ('datedebut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('datefin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudemin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudemax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMin', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMax', 'observation_form', 'FORM');
INSERT INTO field VALUES ('habitat', 'observation_form', 'FORM');
INSERT INTO field VALUES ('denombrement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('observateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('cdref', 'observation_form', 'FORM');
INSERT INTO field VALUES ('versionTAXREF', 'observation_form', 'FORM');
INSERT INTO field VALUES ('determinateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('dateDetermination', 'observation_form', 'FORM');
INSERT INTO field VALUES ('validateur', 'observation_form', 'FORM');
INSERT INTO field VALUES ('ogrganismeStandard', 'observation_form', 'FORM');
INSERT INTO field VALUES ('commentaire', 'observation_form', 'FORM');
INSERT INTO field VALUES ('nomAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('definitionAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('valeurAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('uniteAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('thematiqueAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeAttribut', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsDescription', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsMethode', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occEtatBiologique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occMethodeDetermination', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occNaturaliste', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occSexe', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occStadeDeVie', 'observation_form', 'FORM');
INSERT INTO field VALUES ('occStatutBiologique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveExistante', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveNonNumerique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('preuveNumerique', 'observation_form', 'FORM');
INSERT INTO field VALUES ('obsContexte', 'observation_form', 'FORM');
INSERT INTO field VALUES ('identifiantRegroupementPermanent', 'observation_form', 'FORM');
INSERT INTO field VALUES ('methodeRegroupement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('typeRegroupement', 'observation_form', 'FORM');
INSERT INTO field VALUES ('altitudeMoyenne', 'observation_form', 'FORM');
INSERT INTO field VALUES ('profondeurMoyenne', 'observation_form', 'FORM');
INSERT INTO field VALUES ('REGIONS', 'observation_form', 'FORM');


--
-- Data for Name: dataset_fields; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','PROVIDER_ID');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','SUBMISSION_ID');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','geometrie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codecommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','anneeRefCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoCommune');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrementMin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrementMax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','objetDenombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeDenombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','anneeRefDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoDepartement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoEN');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','refHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionRefHabitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeHabRef');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionRefMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomRefMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoMaille');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dateME');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeInfoGeoMasseDEau');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','natureObjetGeo');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','localisation_data','precisionGeometrie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomorganisme');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identite');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','mail');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantOrigine');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dSPublique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','diffusionNiveauPrecision');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','diffusionFloutage');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensible');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiNiveau');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiDateAttribution');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiReferentiel');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','sensiVersionReferentiel');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','statutSource');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddcode');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddid');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddSourceId');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','jddMetadonneeDEEId');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','organismeGestionnaireDonnee');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','codeIDCNPDispositif');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dEEDateDerniereModification');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','referencebiblio');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','orgTransformation');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantPermanent');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','statutObservation');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomCite');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','objetGeo');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','datedebut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','datefin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudemin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudemax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMin');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMax');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','habitat');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','denombrement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','observateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','cdnom');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','cdref');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','versionTAXREF');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','determinateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','dateDetermination');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','validateur');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','ogrganismeStandard');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','commentaire');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','nomAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','definitionAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','valeurAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','uniteAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','thematiqueAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeAttribut');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsDescription');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsMethode');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occEtatBiologique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occMethodeDetermination');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occNaturaliste');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occSexe');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occStadeDeVie');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','occStatutBiologique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveExistante');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveNonNumerique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','preuveNumerique');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','obsContexte');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','identifiantRegroupementPermanent');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','methodeRegroupement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','typeRegroupement');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','altitudeMoyenne');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','profondeurMoyenne');
INSERT INTO dataset_fields VALUES ('std_occ_taxon_dee_v1-2','RAW_DATA','observation_data','REGIONS');


--
-- Data for Name: file_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_format VALUES ('observation_file','CSV','observation_file',0,'fichier_dee_v1-2_observation','fichier_dee_v1-2_observation');
INSERT INTO file_format VALUES ('localisation_file','CSV','localisation_file',1,'fichier_dee_v1-2_localisation','fichier_dee_v1-2_localisation');


--
-- Data for Name: dataset_files; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_files VALUES ('std_occ_taxon_dee_v1-2','observation_file');
INSERT INTO dataset_files VALUES ('std_occ_taxon_dee_v1-2','localisation_file');

--
-- Data for Name: form_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_format VALUES ('observation_form','form_dee_v1-2_observation','form_dee_v1-2_observation',0,'1');
INSERT INTO form_format VALUES ('localisation_form','form_dee_v1-2_localisation','form_dee_v1-2_localisation',1,'1');


--
-- Data for Name: dataset_forms; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dataset_forms VALUES ('std_occ_taxon_dee_v1-2','observation_form');
INSERT INTO dataset_forms VALUES ('std_occ_taxon_dee_v1-2','localisation_form');


--
-- Data for Name: dynamode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO dynamode VALUES ('CodeCommuneValue','SELECT code as code, code as label FROM referentiels.communes ORDER BY code');
INSERT INTO dynamode VALUES ('NomCommuneValue','SELECT code as code, nom || '' ('' || code || '')'' as label FROM referentiels.communes ORDER BY nom');
INSERT INTO dynamode VALUES ('CodeDepartementValue','SELECT dp as code, nom_depart as label FROM referentiels.departements ORDER BY dp');
INSERT INTO dynamode VALUES ('REGIONS','SELECT code as code, nom as label FROM referentiels.regions ORDER BY code');
INSERT INTO dynamode VALUES ('CodeMailleValue','SELECT code10km as code, cd_sig as label FROM referentiels.codemaillevalue ORDER BY cd_sig');
INSERT INTO dynamode VALUES ('CodeENValue','SELECT codeen as code, codeen as label FROM referentiels.codeenvalue ORDER BY codeEN');
INSERT INTO dynamode VALUES ('StatutSourceValue','SELECT code as code, label as label FROM referentiels.StatutSourceValue ORDER BY code');
INSERT INTO dynamode VALUES ('DSPubliqueValue','SELECT code as code, label as label FROM referentiels.DSPubliqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('StatutObservationValue','SELECT code as code, label as label FROM referentiels.StatutObservationValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObjetDenombrementValue','SELECT code as code, label as label FROM referentiels.ObjetDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeDenombrementValue','SELECT code as code, label as label FROM referentiels.TypeDenombrementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabitatValue','SELECT lb_code as code, lb_code as label FROM referentiels.habref_20 GROUP BY lb_code having count(lb_code)>1 ');
INSERT INTO dynamode VALUES ('CodeRefHabitatValue','SELECT code as code, label as label FROM referentiels.CodeRefHabitatValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NatureObjetGeoValue','SELECT code as code, label as label FROM referentiels.NatureObjetGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeENValue','SELECT code as code, label as label FROM referentiels.TypeENValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeMasseEauValue','SELECT cdmassedea as code, cdmassedea as label FROM referentiels.CodeMasseEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('CodeHabRefValue','SELECT cd_hab as code, cd_hab as label FROM referentiels.habref_20 ORDER BY code ');
INSERT INTO dynamode VALUES ('IDCNPValue','SELECT code as code, label as label FROM referentiels.IDCNPValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeInfoGeoValue','SELECT code as code, label as label FROM referentiels.TypeInfoGeoValue ORDER BY code ');
INSERT INTO dynamode VALUES ('VersionMasseDEauValue','SELECT code as code, label as label FROM referentiels.VersionMasseDEauValue ORDER BY code ');
INSERT INTO dynamode VALUES ('NiveauPrecisionValue','SELECT code as code, label as label FROM referentiels.NiveauPrecisionValue ORDER BY code ');
INSERT INTO dynamode VALUES ('DiffusionFloutageValue','SELECT code as code, label as label FROM referentiels.DiffusionFloutageValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibleValue','SELECT code as code, label as label FROM referentiels.SensibleValue ORDER BY code ');
INSERT INTO dynamode VALUES ('SensibiliteValue','SELECT code as code, label as label FROM referentiels.SensibiliteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('TypeRegroupementValue','SELECT code as code, label as label FROM referentiels.TypeRegroupementValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceNaturalisteValue','SELECT code as code, label as label FROM referentiels.OccurrenceNaturalisteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceSexeValue','SELECT code as code, label as label FROM referentiels.OccurrenceSexeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStadeDeVieValue','SELECT code as code, label as label FROM referentiels.OccurrenceStadeDeVieValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceStatutBiologiqueValue','SELECT code as code, label as label FROM referentiels.OccurrenceStatutBiologiqueValue ORDER BY code ');
INSERT INTO dynamode VALUES ('PreuveExistanteValue','SELECT code as code, label as label FROM referentiels.PreuveExistanteValue ORDER BY code ');
INSERT INTO dynamode VALUES ('ObservationMethodeValue','SELECT code as code, label as label FROM referentiels.ObservationMethodeValue ORDER BY code ');
INSERT INTO dynamode VALUES ('OccurrenceEtatBiologiqueValue','SELECT code as code, label as label FROM referentiels.OccurrenceEtatBiologiqueValue ORDER BY code ');


--
-- Data for Name: field_mapping; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO field_mapping VALUES ('PROVIDER_ID','localisation_form','PROVIDER_ID','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','localisation_form','OGAM_ID_1_LOCALISATION','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('geometrie','localisation_form','geometrie','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('PROVIDER_ID','observation_form','PROVIDER_ID','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_OBSERVATION','observation_form','OGAM_ID_1_OBSERVATION','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','observation_form','OGAM_ID_1_LOCALISATION','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codecommune','observation_form','codecommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomCommune','observation_form','nomCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('anneeRefCommune','observation_form','anneeRefCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoCommune','observation_form','typeInfoGeoCommune','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrementMin','observation_form','denombrementMin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrementMax','observation_form','denombrementMax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('objetDenombrement','observation_form','objetDenombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeDenombrement','observation_form','typeDenombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeDepartement','observation_form','codeDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('anneeRefDepartement','observation_form','anneeRefDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoDepartement','observation_form','typeInfoGeoDepartement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeEN','observation_form','typeEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeEN','observation_form','codeEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionEN','observation_form','versionEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoEN','observation_form','typeInfoGeoEN','observation_data','FORM');
INSERT INTO field_mapping VALUES ('refHabitat','observation_form','refHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeHabitat','observation_form','codeHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionRefHabitat','observation_form','versionRefHabitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeHabRef','observation_form','codeHabRef','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeMaille','observation_form','codeMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionRefMaille','observation_form','versionRefMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomRefMaille','observation_form','nomRefMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoMaille','observation_form','typeInfoGeoMaille','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeME','observation_form','codeME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionME','observation_form','versionME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dateME','observation_form','dateME','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeInfoGeoMasseDEau','observation_form','typeInfoGeoMasseDEau','observation_data','FORM');
INSERT INTO field_mapping VALUES ('natureObjetGeo','localisation_form','natureObjetGeo','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('precisionGeometrie','localisation_form','precisionGeometrie','localisation_data','FORM');
INSERT INTO field_mapping VALUES ('nomorganisme','observation_form','nomorganisme','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identite','observation_form','identite','observation_data','FORM');
INSERT INTO field_mapping VALUES ('mail','observation_form','mail','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantOrigine','observation_form','identifiantOrigine','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dSPublique','observation_form','dSPublique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('diffusionNiveauPrecision','observation_form','diffusionNiveauPrecision','observation_data','FORM');
INSERT INTO field_mapping VALUES ('diffusionFloutage','observation_form','diffusionFloutage','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensible','observation_form','sensible','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiNiveau','observation_form','sensiNiveau','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiDateAttribution','observation_form','sensiDateAttribution','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiReferentiel','observation_form','sensiReferentiel','observation_data','FORM');
INSERT INTO field_mapping VALUES ('sensiVersionReferentiel','observation_form','sensiVersionReferentiel','observation_data','FORM');
INSERT INTO field_mapping VALUES ('statutSource','observation_form','statutSource','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddcode','observation_form','jddcode','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddid','observation_form','jddid','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddSourceId','observation_form','jddSourceId','observation_data','FORM');
INSERT INTO field_mapping VALUES ('jddMetadonneeDEEId','observation_form','jddMetadonneeDEEId','observation_data','FORM');
INSERT INTO field_mapping VALUES ('organismeGestionnaireDonnee','observation_form','organismeGestionnaireDonnee','observation_data','FORM');
INSERT INTO field_mapping VALUES ('codeIDCNPDispositif','observation_form','codeIDCNPDispositif','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dEEDateDerniereModification','observation_form','dEEDateDerniereModification','observation_data','FORM');
INSERT INTO field_mapping VALUES ('referencebiblio','observation_form','referencebiblio','observation_data','FORM');
INSERT INTO field_mapping VALUES ('orgTransformation','observation_form','orgTransformation','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantPermanent','observation_form','identifiantPermanent','observation_data','FORM');
INSERT INTO field_mapping VALUES ('statutObservation','observation_form','statutObservation','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomCite','observation_form','nomCite','observation_data','FORM');
INSERT INTO field_mapping VALUES ('objetGeo','observation_form','objetGeo','observation_data','FORM');
INSERT INTO field_mapping VALUES ('datedebut','observation_form','datedebut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('datefin','observation_form','datefin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudemin','observation_form','altitudemin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudemax','observation_form','altitudemax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMin','observation_form','profondeurMin','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMax','observation_form','profondeurMax','observation_data','FORM');
INSERT INTO field_mapping VALUES ('habitat','observation_form','habitat','observation_data','FORM');
INSERT INTO field_mapping VALUES ('denombrement','observation_form','denombrement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('observateur','observation_form','observateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('cdnom','observation_form','cdnom','observation_data','FORM');
INSERT INTO field_mapping VALUES ('cdref','observation_form','cdref','observation_data','FORM');
INSERT INTO field_mapping VALUES ('versionTAXREF','observation_form','versionTAXREF','observation_data','FORM');
INSERT INTO field_mapping VALUES ('determinateur','observation_form','determinateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('dateDetermination','observation_form','dateDetermination','observation_data','FORM');
INSERT INTO field_mapping VALUES ('validateur','observation_form','validateur','observation_data','FORM');
INSERT INTO field_mapping VALUES ('ogrganismeStandard','observation_form','ogrganismeStandard','observation_data','FORM');
INSERT INTO field_mapping VALUES ('commentaire','observation_form','commentaire','observation_data','FORM');
INSERT INTO field_mapping VALUES ('nomAttribut','observation_form','nomAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('definitionAttribut','observation_form','definitionAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('valeurAttribut','observation_form','valeurAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('uniteAttribut','observation_form','uniteAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('thematiqueAttribut','observation_form','thematiqueAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeAttribut','observation_form','typeAttribut','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsDescription','observation_form','obsDescription','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsMethode','observation_form','obsMethode','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occEtatBiologique','observation_form','occEtatBiologique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occMethodeDetermination','observation_form','occMethodeDetermination','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occNaturaliste','observation_form','occNaturaliste','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occSexe','observation_form','occSexe','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occStadeDeVie','observation_form','occStadeDeVie','observation_data','FORM');
INSERT INTO field_mapping VALUES ('occStatutBiologique','observation_form','occStatutBiologique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveExistante','observation_form','preuveExistante','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveNonNumerique','observation_form','preuveNonNumerique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('preuveNumerique','observation_form','preuveNumerique','observation_data','FORM');
INSERT INTO field_mapping VALUES ('obsContexte','observation_form','obsContexte','observation_data','FORM');
INSERT INTO field_mapping VALUES ('identifiantRegroupementPermanent','observation_form','identifiantRegroupementPermanent','observation_data','FORM');
INSERT INTO field_mapping VALUES ('methodeRegroupement','observation_form','methodeRegroupement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('typeRegroupement','observation_form','typeRegroupement','observation_data','FORM');
INSERT INTO field_mapping VALUES ('altitudeMoyenne','observation_form','altitudeMoyenne','observation_data','FORM');
INSERT INTO field_mapping VALUES ('profondeurMoyenne','observation_form','profondeurMoyenne','observation_data','FORM');
INSERT INTO field_mapping VALUES ('REGIONS','observation_form','REGIONS','observation_data','FORM');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','localisation_file','OGAM_ID_1_LOCALISATION','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('geometrie','localisation_file','geometrie','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_OBSERVATION','observation_file','OGAM_ID_1_OBSERVATION','observation_data','FILE');
INSERT INTO field_mapping VALUES ('OGAM_ID_1_LOCALISATION','observation_file','OGAM_ID_1_LOCALISATION','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codecommune','observation_file','codecommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomCommune','observation_file','nomCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('anneeRefCommune','observation_file','anneeRefCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoCommune','observation_file','typeInfoGeoCommune','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrementMin','observation_file','denombrementMin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrementMax','observation_file','denombrementMax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('objetDenombrement','observation_file','objetDenombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeDenombrement','observation_file','typeDenombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeDepartement','observation_file','codeDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('anneeRefDepartement','observation_file','anneeRefDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoDepartement','observation_file','typeInfoGeoDepartement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeEN','observation_file','typeEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeEN','observation_file','codeEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionEN','observation_file','versionEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoEN','observation_file','typeInfoGeoEN','observation_data','FILE');
INSERT INTO field_mapping VALUES ('refHabitat','observation_file','refHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeHabitat','observation_file','codeHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionRefHabitat','observation_file','versionRefHabitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeHabRef','observation_file','codeHabRef','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeMaille','observation_file','codeMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionRefMaille','observation_file','versionRefMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomRefMaille','observation_file','nomRefMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoMaille','observation_file','typeInfoGeoMaille','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeME','observation_file','codeME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionME','observation_file','versionME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dateME','observation_file','dateME','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeInfoGeoMasseDEau','observation_file','typeInfoGeoMasseDEau','observation_data','FILE');
INSERT INTO field_mapping VALUES ('natureObjetGeo','localisation_file','natureObjetGeo','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('precisionGeometrie','localisation_file','precisionGeometrie','localisation_data','FILE');
INSERT INTO field_mapping VALUES ('nomorganisme','observation_file','nomorganisme','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identite','observation_file','identite','observation_data','FILE');
INSERT INTO field_mapping VALUES ('mail','observation_file','mail','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantOrigine','observation_file','identifiantOrigine','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dSPublique','observation_file','dSPublique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('diffusionNiveauPrecision','observation_file','diffusionNiveauPrecision','observation_data','FILE');
INSERT INTO field_mapping VALUES ('diffusionFloutage','observation_file','diffusionFloutage','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensible','observation_file','sensible','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiNiveau','observation_file','sensiNiveau','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiDateAttribution','observation_file','sensiDateAttribution','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiReferentiel','observation_file','sensiReferentiel','observation_data','FILE');
INSERT INTO field_mapping VALUES ('sensiVersionReferentiel','observation_file','sensiVersionReferentiel','observation_data','FILE');
INSERT INTO field_mapping VALUES ('statutSource','observation_file','statutSource','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddcode','observation_file','jddcode','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddid','observation_file','jddid','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddSourceId','observation_file','jddSourceId','observation_data','FILE');
INSERT INTO field_mapping VALUES ('jddMetadonneeDEEId','observation_file','jddMetadonneeDEEId','observation_data','FILE');
INSERT INTO field_mapping VALUES ('organismeGestionnaireDonnee','observation_file','organismeGestionnaireDonnee','observation_data','FILE');
INSERT INTO field_mapping VALUES ('codeIDCNPDispositif','observation_file','codeIDCNPDispositif','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dEEDateDerniereModification','observation_file','dEEDateDerniereModification','observation_data','FILE');
INSERT INTO field_mapping VALUES ('referencebiblio','observation_file','referencebiblio','observation_data','FILE');
INSERT INTO field_mapping VALUES ('orgTransformation','observation_file','orgTransformation','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantPermanent','observation_file','identifiantPermanent','observation_data','FILE');
INSERT INTO field_mapping VALUES ('statutObservation','observation_file','statutObservation','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomCite','observation_file','nomCite','observation_data','FILE');
INSERT INTO field_mapping VALUES ('objetGeo','observation_file','objetGeo','observation_data','FILE');
INSERT INTO field_mapping VALUES ('datedebut','observation_file','datedebut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('datefin','observation_file','datefin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudemin','observation_file','altitudemin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudemax','observation_file','altitudemax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMin','observation_file','profondeurMin','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMax','observation_file','profondeurMax','observation_data','FILE');
INSERT INTO field_mapping VALUES ('habitat','observation_file','habitat','observation_data','FILE');
INSERT INTO field_mapping VALUES ('denombrement','observation_file','denombrement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('observateur','observation_file','observateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('cdnom','observation_file','cdnom','observation_data','FILE');
INSERT INTO field_mapping VALUES ('cdref','observation_file','cdref','observation_data','FILE');
INSERT INTO field_mapping VALUES ('versionTAXREF','observation_file','versionTAXREF','observation_data','FILE');
INSERT INTO field_mapping VALUES ('determinateur','observation_file','determinateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('dateDetermination','observation_file','dateDetermination','observation_data','FILE');
INSERT INTO field_mapping VALUES ('validateur','observation_file','validateur','observation_data','FILE');
INSERT INTO field_mapping VALUES ('ogrganismeStandard','observation_file','ogrganismeStandard','observation_data','FILE');
INSERT INTO field_mapping VALUES ('commentaire','observation_file','commentaire','observation_data','FILE');
INSERT INTO field_mapping VALUES ('nomAttribut','observation_file','nomAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('definitionAttribut','observation_file','definitionAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('valeurAttribut','observation_file','valeurAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('uniteAttribut','observation_file','uniteAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('thematiqueAttribut','observation_file','thematiqueAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeAttribut','observation_file','typeAttribut','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsDescription','observation_file','obsDescription','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsMethode','observation_file','obsMethode','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occEtatBiologique','observation_file','occEtatBiologique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occMethodeDetermination','observation_file','occMethodeDetermination','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occNaturaliste','observation_file','occNaturaliste','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occSexe','observation_file','occSexe','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occStadeDeVie','observation_file','occStadeDeVie','observation_data','FILE');
INSERT INTO field_mapping VALUES ('occStatutBiologique','observation_file','occStatutBiologique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveExistante','observation_file','preuveExistante','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveNonNumerique','observation_file','preuveNonNumerique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('preuveNumerique','observation_file','preuveNumerique','observation_data','FILE');
INSERT INTO field_mapping VALUES ('obsContexte','observation_file','obsContexte','observation_data','FILE');
INSERT INTO field_mapping VALUES ('identifiantRegroupementPermanent','observation_file','identifiantRegroupementPermanent','observation_data','FILE');
INSERT INTO field_mapping VALUES ('methodeRegroupement','observation_file','methodeRegroupement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('typeRegroupement','observation_file','typeRegroupement','observation_data','FILE');
INSERT INTO field_mapping VALUES ('altitudeMoyenne','observation_file','altitudeMoyenne','observation_data','FILE');
INSERT INTO field_mapping VALUES ('profondeurMoyenne','observation_file','profondeurMoyenne','observation_data','FILE');
INSERT INTO field_mapping VALUES ('REGIONS','observation_file','REGIONS','observation_data','FILE');


--
-- Data for Name: file_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO file_field VALUES ('OGAM_ID_1_LOCALISATION', 'localisation_file', '1', NULL, '1');
INSERT INTO file_field VALUES ('geometrie', 'localisation_file', '0', NULL, '2');
INSERT INTO file_field VALUES ('natureObjetGeo', 'localisation_file', '0', NULL, '3');
INSERT INTO file_field VALUES ('precisionGeometrie', 'localisation_file', '0', NULL, '4');
INSERT INTO file_field VALUES ('OGAM_ID_1_OBSERVATION', 'observation_file', '1', NULL, '1');
INSERT INTO file_field VALUES ('OGAM_ID_1_LOCALISATION', 'observation_file', '1', NULL, '2');
INSERT INTO file_field VALUES ('codecommune', 'observation_file', '0', NULL, '3');
INSERT INTO file_field VALUES ('nomCommune', 'observation_file', '0', NULL, '4');
INSERT INTO file_field VALUES ('anneeRefCommune', 'observation_file', '0', 'yyyy', '5');
INSERT INTO file_field VALUES ('typeInfoGeoCommune', 'observation_file', '0', NULL, '6');
INSERT INTO file_field VALUES ('denombrementMin', 'observation_file', '0', NULL, '7');
INSERT INTO file_field VALUES ('denombrementMax', 'observation_file', '0', NULL, '8');
INSERT INTO file_field VALUES ('objetDenombrement', 'observation_file', '0', NULL, '9');
INSERT INTO file_field VALUES ('typeDenombrement', 'observation_file', '0', NULL, '10');
INSERT INTO file_field VALUES ('codeDepartement', 'observation_file', '0', NULL, '11');
INSERT INTO file_field VALUES ('anneeRefDepartement', 'observation_file', '0', 'yyyy', '12');
INSERT INTO file_field VALUES ('typeInfoGeoDepartement', 'observation_file', '0', NULL, '13');
INSERT INTO file_field VALUES ('typeEN', 'observation_file', '0', NULL, '14');
INSERT INTO file_field VALUES ('codeEN', 'observation_file', '0', NULL, '15');
INSERT INTO file_field VALUES ('versionEN', 'observation_file', '0', NULL, '16');
INSERT INTO file_field VALUES ('typeInfoGeoEN', 'observation_file', '0', NULL, '17');
INSERT INTO file_field VALUES ('refHabitat', 'observation_file', '0', NULL, '18');
INSERT INTO file_field VALUES ('codeHabitat', 'observation_file', '0', NULL, '19');
INSERT INTO file_field VALUES ('versionRefHabitat', 'observation_file', '0', NULL, '20');
INSERT INTO file_field VALUES ('codeHabRef', 'observation_file', '0', NULL, '21');
INSERT INTO file_field VALUES ('codeMaille', 'observation_file', '0', NULL, '22');
INSERT INTO file_field VALUES ('versionRefMaille', 'observation_file', '0', NULL, '23');
INSERT INTO file_field VALUES ('nomRefMaille', 'observation_file', '0', NULL, '24');
INSERT INTO file_field VALUES ('typeInfoGeoMaille', 'observation_file', '0', NULL, '25');
INSERT INTO file_field VALUES ('codeME', 'observation_file', '0', NULL, '26');
INSERT INTO file_field VALUES ('versionME', 'observation_file', '0', NULL, '27');
INSERT INTO file_field VALUES ('dateME', 'observation_file', '0', 'yyyy-MM-dd', '28');
INSERT INTO file_field VALUES ('typeInfoGeoMasseDEau', 'observation_file', '0', NULL, '29');
INSERT INTO file_field VALUES ('nomorganisme', 'observation_file', '0', NULL, '30');
INSERT INTO file_field VALUES ('identite', 'observation_file', '0', NULL, '31');
INSERT INTO file_field VALUES ('mail', 'observation_file', '0', NULL, '32');
INSERT INTO file_field VALUES ('identifiantOrigine', 'observation_file', '0', NULL, '33');
INSERT INTO file_field VALUES ('dSPublique', 'observation_file', '1', NULL, '34');
INSERT INTO file_field VALUES ('diffusionNiveauPrecision', 'observation_file', '0', NULL, '35');
INSERT INTO file_field VALUES ('diffusionFloutage', 'observation_file', '0', NULL, '36');
INSERT INTO file_field VALUES ('sensible', 'observation_file', '1', NULL, '37');
INSERT INTO file_field VALUES ('sensiNiveau', 'observation_file', '1', NULL, '38');
INSERT INTO file_field VALUES ('sensiDateAttribution', 'observation_file', '0', 'yyyy-MM-dd''T''HH:mmZ', '39');
INSERT INTO file_field VALUES ('sensiReferentiel', 'observation_file', '0', NULL, '40');
INSERT INTO file_field VALUES ('sensiVersionReferentiel', 'observation_file', '0', NULL, '41');
INSERT INTO file_field VALUES ('statutSource', 'observation_file', '1', NULL, '42');
INSERT INTO file_field VALUES ('jddcode', 'observation_file', '0', NULL, '43');
INSERT INTO file_field VALUES ('jddid', 'observation_file', '0', NULL, '44');
INSERT INTO file_field VALUES ('jddSourceId', 'observation_file', '0', NULL, '45');
INSERT INTO file_field VALUES ('jddMetadonneeDEEId', 'observation_file', '1', NULL, '46');
INSERT INTO file_field VALUES ('organismeGestionnaireDonnee', 'observation_file', '1', NULL, '47');
INSERT INTO file_field VALUES ('codeIDCNPDispositif', 'observation_file', '0', NULL, '48');
INSERT INTO file_field VALUES ('dEEDateDerniereModification', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '50');
INSERT INTO file_field VALUES ('referencebiblio', 'observation_file', '1', NULL, '51');
INSERT INTO file_field VALUES ('orgTransformation', 'observation_file', '0', NULL, '52');
INSERT INTO file_field VALUES ('identifiantPermanent', 'observation_file', '1', NULL, '53');
INSERT INTO file_field VALUES ('statutObservation', 'observation_file', '1', NULL, '54');
INSERT INTO file_field VALUES ('nomCite', 'observation_file', '1', NULL, '55');
INSERT INTO file_field VALUES ('objetGeo', 'observation_file', '0', NULL, '56');
INSERT INTO file_field VALUES ('datedebut', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '57');
INSERT INTO file_field VALUES ('datefin', 'observation_file', '1', 'yyyy-MM-dd''T''HH:mmZ', '58');
INSERT INTO file_field VALUES ('altitudemin', 'observation_file', '0', NULL, '59');
INSERT INTO file_field VALUES ('altitudemax', 'observation_file', '0', NULL, '60');
INSERT INTO file_field VALUES ('profondeurMin', 'observation_file', '0', NULL, '61');
INSERT INTO file_field VALUES ('profondeurMax', 'observation_file', '0', NULL, '62');
INSERT INTO file_field VALUES ('habitat', 'observation_file', '0', NULL, '63');
INSERT INTO file_field VALUES ('denombrement', 'observation_file', '0', NULL, '64');
INSERT INTO file_field VALUES ('observateur', 'observation_file', '1', NULL, '65');
INSERT INTO file_field VALUES ('cdnom', 'observation_file', '0', NULL, '66');
INSERT INTO file_field VALUES ('cdref', 'observation_file', '0', NULL, '67');
INSERT INTO file_field VALUES ('versionTAXREF', 'observation_file', '0', NULL, '68');
INSERT INTO file_field VALUES ('determinateur', 'observation_file', '0', NULL, '69');
INSERT INTO file_field VALUES ('dateDetermination', 'observation_file', '0', 'yyyy-MM-dd''T''HH:mmZ', '70');
INSERT INTO file_field VALUES ('validateur', 'observation_file', '0', NULL, '71');
INSERT INTO file_field VALUES ('ogrganismeStandard', 'observation_file', '0', NULL, '72');
INSERT INTO file_field VALUES ('commentaire', 'observation_file', '0', NULL, '73');
INSERT INTO file_field VALUES ('nomAttribut', 'observation_file', '0', NULL, '74');
INSERT INTO file_field VALUES ('definitionAttribut', 'observation_file', '0', NULL, '75');
INSERT INTO file_field VALUES ('valeurAttribut', 'observation_file', '0', NULL, '76');
INSERT INTO file_field VALUES ('uniteAttribut', 'observation_file', '0', NULL, '77');
INSERT INTO file_field VALUES ('thematiqueAttribut', 'observation_file', '0', NULL, '78');
INSERT INTO file_field VALUES ('typeAttribut', 'observation_file', '0', NULL, '79');
INSERT INTO file_field VALUES ('obsDescription', 'observation_file', '0', NULL, '80');
INSERT INTO file_field VALUES ('obsMethode', 'observation_file', '0', NULL, '81');
INSERT INTO file_field VALUES ('occEtatBiologique', 'observation_file', '0', NULL, '82');
INSERT INTO file_field VALUES ('occMethodeDetermination', 'observation_file', '0', NULL, '83');
INSERT INTO file_field VALUES ('occNaturaliste', 'observation_file', '0', NULL, '84');
INSERT INTO file_field VALUES ('occSexe', 'observation_file', '0', NULL, '85');
INSERT INTO file_field VALUES ('occStadeDeVie', 'observation_file', '0', NULL, '86');
INSERT INTO file_field VALUES ('occStatutBiologique', 'observation_file', '0', NULL, '87');
INSERT INTO file_field VALUES ('preuveExistante', 'observation_file', '0', NULL, '88');
INSERT INTO file_field VALUES ('preuveNonNumerique', 'observation_file', '0', NULL, '89');
INSERT INTO file_field VALUES ('preuveNumerique', 'observation_file', '0', NULL, '90');
INSERT INTO file_field VALUES ('obsContexte', 'observation_file', '0', NULL, '91');
INSERT INTO file_field VALUES ('identifiantRegroupementPermanent', 'observation_file', '0', NULL, '92');
INSERT INTO file_field VALUES ('methodeRegroupement', 'observation_file', '0', NULL, '93');
INSERT INTO file_field VALUES ('typeRegroupement', 'observation_file', '0', NULL, '94');
INSERT INTO file_field VALUES ('altitudeMoyenne', 'observation_file', '0', NULL, '95');
INSERT INTO file_field VALUES ('profondeurMoyenne', 'observation_file', '0', NULL, '96');
INSERT INTO file_field VALUES ('REGIONS', 'observation_file', '0', NULL, '97');


--
-- Data for Name: form_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO form_field VALUES ('geometrie','localisation_form','1','1','SELECT',1,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('natureObjetGeo','localisation_form','1','1','SELECT',2,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('precisionGeometrie','localisation_form','1','1','NUMERIC',3,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID','localisation_form','0','0','SELECT',4,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_LOCALISATION','localisation_form','0','0','NUMERIC',5,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('PROVIDER_ID','observation_form','0','0','SELECT',1,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_OBSERVATION','observation_form','0','0','NUMERIC',2,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('OGAM_ID_1_LOCALISATION','observation_form','0','0','NUMERIC',5,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codecommune','observation_form','1','1','SELECT',3,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomCommune','observation_form','1','1','SELECT',4,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneeRefCommune','observation_form','1','1','DATE',5,'0','0',NULL,NULL,'yyyy');
INSERT INTO form_field VALUES ('typeInfoGeoCommune','observation_form','1','1','SELECT',6,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementMin','observation_form','1','1','NUMERIC',7,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrementMax','observation_form','1','1','NUMERIC',8,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('objetDenombrement','observation_form','1','1','SELECT',9,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeDenombrement','observation_form','1','1','SELECT',10,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeDepartement','observation_form','1','1','SELECT',11,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('anneeRefDepartement','observation_form','1','1','DATE',12,'0','0',NULL,NULL,'yyyy');
INSERT INTO form_field VALUES ('typeInfoGeoDepartement','observation_form','1','1','SELECT',13,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeEN','observation_form','1','1','SELECT',14,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeEN','observation_form','1','1','SELECT',15,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionEN','observation_form','1','1','DATE',16,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeInfoGeoEN','observation_form','1','1','SELECT',17,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('refHabitat','observation_form','1','1','SELECT',18,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeHabitat','observation_form','1','1','SELECT',19,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionRefHabitat','observation_form','1','1','SELECT',20,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeHabRef','observation_form','1','1','SELECT',21,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeMaille','observation_form','1','1','SELECT',22,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionRefMaille','observation_form','1','1','TEXT',23,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomRefMaille','observation_form','1','1','TEXT',24,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeInfoGeoMaille','observation_form','1','1','SELECT',25,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeME','observation_form','1','1','SELECT',26,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionME','observation_form','1','1','SELECT',27,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dateME','observation_form','1','1','DATE',28,'0','0',NULL,NULL,'yyyy-MM-dd');
INSERT INTO form_field VALUES ('typeInfoGeoMasseDEau','observation_form','1','1','SELECT',29,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomorganisme','observation_form','1','1','TEXT',30,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identite','observation_form','1','1','TEXT',31,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('mail','observation_form','1','1','TEXT',32,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantOrigine','observation_form','1','1','TEXT',33,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dSPublique','observation_form','1','1','SELECT',34,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('diffusionNiveauPrecision','observation_form','1','1','SELECT',35,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('diffusionFloutage','observation_form','1','1','SELECT',36,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensible','observation_form','1','1','SELECT',37,'0','0','0',NULL,NULL);
INSERT INTO form_field VALUES ('sensiNiveau','observation_form','1','1','SELECT',38,'0','0','0',NULL,NULL);
INSERT INTO form_field VALUES ('sensiDateAttribution','observation_form','1','1','DATE',39,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('sensiReferentiel','observation_form','1','1','TEXT',40,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('sensiVersionReferentiel','observation_form','1','1','TEXT',41,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutSource','observation_form','1','1','SELECT',42,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddcode','observation_form','1','1','TEXT',43,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddid','observation_form','1','1','TEXT',44,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddSourceId','observation_form','1','1','TEXT',45,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('jddMetadonneeDEEId','observation_form','1','1','TEXT',46,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('organismeGestionnaireDonnee','observation_form','1','1','SELECT',47,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('codeIDCNPDispositif','observation_form','1','1','SELECT',48,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dEEDateDerniereModification','observation_form','1','1','DATE',50,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('referencebiblio','observation_form','1','1','TEXT',51,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('orgTransformation','observation_form','1','1','TEXT',52,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantPermanent','observation_form','1','1','TEXT',53,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('statutObservation','observation_form','1','1','SELECT',54,'1','1',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomCite','observation_form','1','1','TEXT',55,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('objetGeo','observation_form','1','1','TEXT',56,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('datedebut','observation_form','1','1','DATE',57,'1','1',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('datefin','observation_form','1','1','DATE',58,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('altitudemin','observation_form','1','1','NUMERIC',59,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudemax','observation_form','1','1','NUMERIC',60,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMin','observation_form','1','1','NUMERIC',61,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMax','observation_form','1','1','NUMERIC',62,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('habitat','observation_form','1','1','TEXT',63,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('denombrement','observation_form','1','1','TEXT',64,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('observateur','observation_form','1','1','TEXT',65,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdnom','observation_form','1','1','TAXREF',66,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('cdref','observation_form','1','1','TAXREF',67,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('versionTAXREF','observation_form','1','1','TEXT',68,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('determinateur','observation_form','1','1','TEXT',69,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('dateDetermination','observation_form','1','1','DATE',70,'0','0',NULL,NULL,'yyyy-MM-dd''T''HH:mmZ');
INSERT INTO form_field VALUES ('validateur','observation_form','1','1','TEXT',71,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('ogrganismeStandard','observation_form','1','1','TEXT',72,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('commentaire','observation_form','1','1','TEXT',73,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('nomAttribut','observation_form','1','1','TEXT',74,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('definitionAttribut','observation_form','1','1','TEXT',75,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('valeurAttribut','observation_form','1','1','TEXT',76,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('uniteAttribut','observation_form','1','1','TEXT',77,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('thematiqueAttribut','observation_form','1','1','TEXT',78,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeAttribut','observation_form','1','1','TEXT',79,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsDescription','observation_form','1','1','TEXT',80,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsMethode','observation_form','1','1','SELECT',81,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occEtatBiologique','observation_form','1','1','SELECT',82,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occMethodeDetermination','observation_form','1','1','TEXT',83,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occNaturaliste','observation_form','1','1','SELECT',84,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occSexe','observation_form','1','1','SELECT',85,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occStadeDeVie','observation_form','1','1','SELECT',86,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('occStatutBiologique','observation_form','1','1','SELECT',87,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveExistante','observation_form','1','1','SELECT',88,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveNonNumerique','observation_form','1','1','TEXT',89,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('preuveNumerique','observation_form','1','1','TEXT',90,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('obsContexte','observation_form','1','1','TEXT',91,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('identifiantRegroupementPermanent','observation_form','1','1','TEXT',92,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('methodeRegroupement','observation_form','1','1','TEXT',93,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('typeRegroupement','observation_form','1','1','SELECT',94,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('altitudeMoyenne','observation_form','1','1','NUMERIC',95,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('profondeurMoyenne','observation_form','1','1','NUMERIC',96,'0','0',NULL,NULL,NULL);
INSERT INTO form_field VALUES ('REGIONS','observation_form','1','1','SELECT',97,'0','0',NULL,NULL,NULL);


--
-- Data for Name: mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO mode VALUES ('PROVIDER_ID','1',1,'admin','admin');

--
-- Data for Name: group_mode; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: mode_taxref; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: mode_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_schema; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('RAW_DATA', 'RAW_DATA', 'Données sources', 'Contains raw data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('HARMONIZED_DATA', 'HARMONIZED_DATA', 'Données élémentaires d''échange', 'Contains harmonized data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('METADATA', 'METADATA', 'Metadata', 'Contains the tables describing the data');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('WEBSITE', 'WEBSITE', 'Website', 'Contains the tables used to operate the web site');
INSERT INTO table_schema (schema_code, schema_name, label, description) VALUES ('PUBLIC', 'PUBLIC', 'Public', 'Contains the default PostgreSQL tables and PostGIS functions');


--
-- Data for Name: model; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model VALUES ('1','std_occ_taxon_dee_v1-2','à ne pas supprimer','RAW_DATA');

--
-- Data for Name: model_datasets; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_datasets VALUES ('1','std_occ_taxon_dee_v1-2');


--
-- Data for Name: table_format; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_format VALUES ('observation_data','_1_observation','RAW_DATA','OGAM_ID_1_OBSERVATION, PROVIDER_ID, SUBMISSION_ID','table_dee_v1-2_observation','table_dee_v1-2_observation');
INSERT INTO table_format VALUES ('localisation_data','_1_localisation','RAW_DATA','OGAM_ID_1_LOCALISATION, PROVIDER_ID, SUBMISSION_ID','table_dee_v1-2_localisation','table_dee_v1-2_localisation');


--
-- Data for Name: model_tables; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO model_tables VALUES ('1','observation_data');
INSERT INTO model_tables VALUES ('1','localisation_data');


--
-- Data for Name: process; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: range; Type: TABLE DATA; Schema: metadata; Owner: admin
--



--
-- Data for Name: table_field; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_field VALUES ('geometrie','localisation_data','geometrie','1','1','1','0',1,NULL);
INSERT INTO table_field VALUES ('natureObjetGeo','localisation_data','natureObjetGeo','0','1','1','0',2,NULL);
INSERT INTO table_field VALUES ('precisionGeometrie','localisation_data','precisionGeometrie','0','1','1','0',3,NULL);
INSERT INTO table_field VALUES ('SUBMISSION_ID','localisation_data','SUBMISSION_ID','1','0','0','1',4,NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID','localisation_data','PROVIDER_ID','1','0','0','1',5,NULL);
INSERT INTO table_field VALUES ('OGAM_ID_1_LOCALISATION','localisation_data','OGAM_ID_1_LOCALISATION','1','0','0','1',6,'séquence');
INSERT INTO table_field VALUES ('SUBMISSION_ID','observation_data','SUBMISSION_ID','1','0','0','1',1,NULL);
INSERT INTO table_field VALUES ('PROVIDER_ID','observation_data','PROVIDER_ID','1','0','0','1',2,NULL);
INSERT INTO table_field VALUES ('OGAM_ID_1_OBSERVATION','observation_data','OGAM_ID_1_OBSERVATION','1','0','0','1',3,'séquence');
INSERT INTO table_field VALUES ('OGAM_ID_1_LOCALISATION','observation_data','OGAM_ID_1_LOCALISATION','0','0','0','1',4,'séquence');
INSERT INTO table_field VALUES ('codecommune','observation_data','codecommune','0','1','1','0',5,NULL);
INSERT INTO table_field VALUES ('nomCommune','observation_data','nomCommune','0','1','1','0',6,NULL);
INSERT INTO table_field VALUES ('anneeRefCommune','observation_data','anneeRefCommune','0','1','1','0',7,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoCommune','observation_data','typeInfoGeoCommune','0','1','1','0',8,NULL);
INSERT INTO table_field VALUES ('denombrementMin','observation_data','denombrementMin','0','1','1','0',9,NULL);
INSERT INTO table_field VALUES ('denombrementMax','observation_data','denombrementMax','0','1','1','0',10,NULL);
INSERT INTO table_field VALUES ('objetDenombrement','observation_data','objetDenombrement','0','1','1','0',11,NULL);
INSERT INTO table_field VALUES ('typeDenombrement','observation_data','typeDenombrement','0','1','1','0',12,NULL);
INSERT INTO table_field VALUES ('codeDepartement','observation_data','codeDepartement','0','1','1','0',13,NULL);
INSERT INTO table_field VALUES ('anneeRefDepartement','observation_data','anneeRefDepartement','0','1','1','0',14,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoDepartement','observation_data','typeInfoGeoDepartement','0','1','1','0',15,NULL);
INSERT INTO table_field VALUES ('typeEN','observation_data','typeEN','0','1','1','0',16,NULL);
INSERT INTO table_field VALUES ('codeEN','observation_data','codeEN','0','1','1','0',17,NULL);
INSERT INTO table_field VALUES ('versionEN','observation_data','versionEN','0','1','1','0',18,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoEN','observation_data','typeInfoGeoEN','0','1','1','0',19,NULL);
INSERT INTO table_field VALUES ('refHabitat','observation_data','refHabitat','0','1','1','0',20,NULL);
INSERT INTO table_field VALUES ('codeHabitat','observation_data','codeHabitat','0','1','1','0',21,NULL);
INSERT INTO table_field VALUES ('versionRefHabitat','observation_data','versionRefHabitat','0','1','1','0',22,NULL);
INSERT INTO table_field VALUES ('codeHabRef','observation_data','codeHabRef','0','1','1','0',23,NULL);
INSERT INTO table_field VALUES ('codeMaille','observation_data','codeMaille','0','1','1','0',24,NULL);
INSERT INTO table_field VALUES ('versionRefMaille','observation_data','versionRefMaille','0','1','1','0',25,NULL);
INSERT INTO table_field VALUES ('nomRefMaille','observation_data','nomRefMaille','0','1','1','0',26,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoMaille','observation_data','typeInfoGeoMaille','0','1','1','0',27,NULL);
INSERT INTO table_field VALUES ('codeME','observation_data','codeME','0','1','1','0',28,NULL);
INSERT INTO table_field VALUES ('versionME','observation_data','versionME','0','1','1','0',29,NULL);
INSERT INTO table_field VALUES ('dateME','observation_data','dateME','0','1','1','0',30,NULL);
INSERT INTO table_field VALUES ('typeInfoGeoMasseDEau','observation_data','typeInfoGeoMasseDEau','0','1','1','0',31,NULL);
INSERT INTO table_field VALUES ('nomorganisme','observation_data','nomorganisme','0','1','1','0',32,NULL);
INSERT INTO table_field VALUES ('identite','observation_data','identite','0','1','1','0',33,NULL);
INSERT INTO table_field VALUES ('mail','observation_data','mail','0','1','1','0',34,NULL);
INSERT INTO table_field VALUES ('identifiantOrigine','observation_data','identifiantOrigine','0','1','1','0',35,NULL);
INSERT INTO table_field VALUES ('dSPublique','observation_data','dSPublique','0','1','1','1',36,NULL);
INSERT INTO table_field VALUES ('diffusionNiveauPrecision','observation_data','diffusionNiveauPrecision','0','1','1','0',37,NULL);
INSERT INTO table_field VALUES ('diffusionFloutage','observation_data','diffusionFloutage','0','1','1','0',38,NULL);
INSERT INTO table_field VALUES ('sensible','observation_data','sensible','0','1','1','1',39,NULL);
INSERT INTO table_field VALUES ('sensiNiveau','observation_data','sensiNiveau','0','1','1','1',40,NULL);
INSERT INTO table_field VALUES ('sensiDateAttribution','observation_data','sensiDateAttribution','0','1','1','0',41,NULL);
INSERT INTO table_field VALUES ('sensiReferentiel','observation_data','sensiReferentiel','0','1','1','0',42,NULL);
INSERT INTO table_field VALUES ('sensiVersionReferentiel','observation_data','sensiVersionReferentiel','0','1','1','0',43,NULL);
INSERT INTO table_field VALUES ('statutSource','observation_data','statutSource','0','1','1','1',44,NULL);
INSERT INTO table_field VALUES ('jddcode','observation_data','jddcode','0','1','1','0',45,NULL);
INSERT INTO table_field VALUES ('jddid','observation_data','jddid','0','1','1','0',46,NULL);
INSERT INTO table_field VALUES ('jddSourceId','observation_data','jddSourceId','0','1','1','0',47,NULL);
INSERT INTO table_field VALUES ('jddMetadonneeDEEId','observation_data','jddMetadonneeDEEId','0','1','1','1',48,NULL);
INSERT INTO table_field VALUES ('organismeGestionnaireDonnee','observation_data','organismeGestionnaireDonnee','0','1','1','1',49,NULL);
INSERT INTO table_field VALUES ('codeIDCNPDispositif','observation_data','codeIDCNPDispositif','0','1','1','0',50,NULL);
INSERT INTO table_field VALUES ('dEEDateDerniereModification','observation_data','dEEDateDerniereModification','0','1','1','1',52,NULL);
INSERT INTO table_field VALUES ('referencebiblio','observation_data','referencebiblio','0','1','1','0',53,NULL);
INSERT INTO table_field VALUES ('orgTransformation','observation_data','orgTransformation','0','1','1','1',54,NULL);
INSERT INTO table_field VALUES ('identifiantPermanent','observation_data','identifiantPermanent','0','1','1','1',55,NULL);
INSERT INTO table_field VALUES ('statutObservation','observation_data','statutObservation','0','1','1','1',56,NULL);
INSERT INTO table_field VALUES ('nomCite','observation_data','nomCite','0','1','1','1',57,NULL);
INSERT INTO table_field VALUES ('objetGeo','observation_data','objetGeo','0','1','1','0',58,NULL);
INSERT INTO table_field VALUES ('datedebut','observation_data','datedebut','0','1','1','1',59,NULL);
INSERT INTO table_field VALUES ('datefin','observation_data','datefin','0','1','1','1',60,NULL);
INSERT INTO table_field VALUES ('altitudemin','observation_data','altitudemin','0','1','1','0',61,NULL);
INSERT INTO table_field VALUES ('altitudemax','observation_data','altitudemax','0','1','1','0',62,NULL);
INSERT INTO table_field VALUES ('profondeurMin','observation_data','profondeurMin','0','1','1','0',63,NULL);
INSERT INTO table_field VALUES ('profondeurMax','observation_data','profondeurMax','0','1','1','0',64,NULL);
INSERT INTO table_field VALUES ('habitat','observation_data','habitat','0','1','1','0',65,NULL);
INSERT INTO table_field VALUES ('denombrement','observation_data','denombrement','0','1','1','0',66,NULL);
INSERT INTO table_field VALUES ('observateur','observation_data','observateur','0','1','1','1',67,NULL);
INSERT INTO table_field VALUES ('cdnom','observation_data','cdnom','0','1','1','0',68,NULL);
INSERT INTO table_field VALUES ('cdref','observation_data','cdref','0','1','1','0',69,NULL);
INSERT INTO table_field VALUES ('versionTAXREF','observation_data','versionTAXREF','0','1','1','0',70,NULL);
INSERT INTO table_field VALUES ('determinateur','observation_data','determinateur','0','1','1','0',71,NULL);
INSERT INTO table_field VALUES ('dateDetermination','observation_data','dateDetermination','0','1','1','0',72,NULL);
INSERT INTO table_field VALUES ('validateur','observation_data','validateur','0','1','1','0',73,NULL);
INSERT INTO table_field VALUES ('ogrganismeStandard','observation_data','ogrganismeStandard','0','1','1','0',74,NULL);
INSERT INTO table_field VALUES ('commentaire','observation_data','commentaire','0','1','1','0',75,NULL);
INSERT INTO table_field VALUES ('nomAttribut','observation_data','nomAttribut','0','1','1','0',76,NULL);
INSERT INTO table_field VALUES ('definitionAttribut','observation_data','definitionAttribut','0','1','1','0',77,NULL);
INSERT INTO table_field VALUES ('valeurAttribut','observation_data','valeurAttribut','0','1','1','0',78,NULL);
INSERT INTO table_field VALUES ('uniteAttribut','observation_data','uniteAttribut','0','1','1','0',79,NULL);
INSERT INTO table_field VALUES ('thematiqueAttribut','observation_data','thematiqueAttribut','0','1','1','0',80,NULL);
INSERT INTO table_field VALUES ('typeAttribut','observation_data','typeAttribut','0','1','1','0',81,NULL);
INSERT INTO table_field VALUES ('obsDescription','observation_data','obsDescription','0','1','1','0',82,NULL);
INSERT INTO table_field VALUES ('obsMethode','observation_data','obsMethode','0','1','1','0',83,NULL);
INSERT INTO table_field VALUES ('occEtatBiologique','observation_data','occEtatBiologique','0','1','1','0',84,NULL);
INSERT INTO table_field VALUES ('occMethodeDetermination','observation_data','occMethodeDetermination','0','1','1','0',85,NULL);
INSERT INTO table_field VALUES ('occNaturaliste','observation_data','occNaturaliste','0','1','1','0',86,NULL);
INSERT INTO table_field VALUES ('occSexe','observation_data','occSexe','0','1','1','0',87,NULL);
INSERT INTO table_field VALUES ('occStadeDeVie','observation_data','occStadeDeVie','0','1','1','0',88,NULL);
INSERT INTO table_field VALUES ('occStatutBiologique','observation_data','occStatutBiologique','0','1','1','0',89,NULL);
INSERT INTO table_field VALUES ('preuveExistante','observation_data','preuveExistante','0','1','1','0',90,NULL);
INSERT INTO table_field VALUES ('preuveNonNumerique','observation_data','preuveNonNumerique','0','1','1','0',91,NULL);
INSERT INTO table_field VALUES ('preuveNumerique','observation_data','preuveNumerique','0','1','1','0',92,NULL);
INSERT INTO table_field VALUES ('obsContexte','observation_data','obsContexte','0','1','1','0',93,NULL);
INSERT INTO table_field VALUES ('identifiantRegroupementPermanent','observation_data','identifiantRegroupementPermanent','0','1','1','0',94,NULL);
INSERT INTO table_field VALUES ('methodeRegroupement','observation_data','methodeRegroupement','0','1','1','0',95,NULL);
INSERT INTO table_field VALUES ('typeRegroupement','observation_data','typeRegroupement','0','1','1','0',96,NULL);
INSERT INTO table_field VALUES ('altitudeMoyenne','observation_data','altitudeMoyenne','0','1','1','0',97,NULL);
INSERT INTO table_field VALUES ('profondeurMoyenne','observation_data','profondeurMoyenne','0','1','1','0',98,NULL);
INSERT INTO table_field VALUES ('REGIONS','observation_data','REGIONS','0','1','1','0',99,NULL);

--
-- Data for Name: table_tree; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO table_tree VALUES ('RAW_DATA','observation_data','localisation_data','OGAM_ID_1_LOCALISATION, PROVIDER_ID, SUBMISSION_ID',NULL);
INSERT INTO table_tree VALUES ('RAW_DATA','localisation_data','*',NULL,NULL);


--
-- Data for Name: translation; Type: TABLE DATA; Schema: metadata; Owner: admin
--

INSERT INTO translation VALUES ('observation_data','PROVIDER_ID','FR','Fournisseur de données','L''identifiant du fournisseur de données');
INSERT INTO translation VALUES ('observation_data','SUBMISSION_ID','FR','Identifiant de soumission','L''identifiant de soumission');
INSERT INTO translation VALUES ('observation_data','OGAM_ID_1_OBSERVATION','FR','Observation','L''identifiant de l''observation');
INSERT INTO translation VALUES ('observation_data','PROVIDER_ID','EN','The identifier of the provider','The identifier of the provider');
INSERT INTO translation VALUES ('observation_data','SUBMISSION_ID','EN','Submission ID','The identifier of a submission');
INSERT INTO translation VALUES ('observation_data','OGAM_ID_1_OBSERVATION','EN','Observation','The identifier of a observation');
INSERT INTO translation VALUES ('localisation_data','PROVIDER_ID','FR','Fournisseur de données','L''identifiant du fournisseur de données');
INSERT INTO translation VALUES ('localisation_data','SUBMISSION_ID','FR','Identifiant de soumission','L''identifiant de soumission');
INSERT INTO translation VALUES ('localisation_data','OGAM_ID_1_LOCALISATION','FR','Observation','L''identifiant de l''observation');
INSERT INTO translation VALUES ('localisation_data','geometrie','FR','Géométrie','La géométrie');
INSERT INTO translation VALUES ('localisation_data','PROVIDER_ID','EN','The identifier of the provider','The identifier of the provider');
INSERT INTO translation VALUES ('localisation_data','SUBMISSION_ID','EN','Submission ID','The identifier of a submission');
INSERT INTO translation VALUES ('localisation_data','OGAM_ID_1_LOCALISATION','EN','Observation','The identifier of a observation');
INSERT INTO translation VALUES ('localisation_data','geometrie','EN','Polygon','The geometrical criteria intersected with the plot location');
