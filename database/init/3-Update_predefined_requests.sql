set search_path = website;

DELETE FROM predefined_request_group_asso;
DELETE FROM predefined_request_group;
DELETE FROM predefined_request_criteria;
DELETE FROM predefined_request_result;
DELETE FROM predefined_request;


-- Création d'un thème (groupe de requêtes)
INSERT INTO predefined_request_group(name, label, definition, position) VALUES ('dataset_2', 'Std occ taxon dee v1-2-1', 'Std occ taxon dee v1-2-1', 1);
INSERT INTO predefined_request_group(name, label, definition, position) VALUES ('public_requests', 'Recherches sauvegardées publiques', 'Recherches visibles par tous les utilisateurs.', 1);
INSERT INTO predefined_request_group(name, label, definition, position) VALUES ('private_requests', 'Recherches sauvegardées privées', 'Recherches visibles par moi uniquement.', 2);


-- Création d'une requête prédéfinie
INSERT INTO predefined_request (name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_group_request', 'RAW_DATA', 'dataset_2', 'critères les plus fréquents', null,  now(), null);

INSERT INTO predefined_request (name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_periode', 'RAW_DATA', 'dataset_2', 'par période d''observation', null,  now(), null);
INSERT INTO predefined_request (name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_biogeo', 'RAW_DATA', 'dataset_2', 'par statut bio-géographique', null,  now(), null);
INSERT INTO predefined_request (name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_producteur', 'RAW_DATA', 'dataset_2', 'par  organisme producteur de données', null,  now(), null);
INSERT INTO predefined_request (name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_localisation', 'RAW_DATA', 'dataset_2', 'par localisation', null,  now(), null);

INSERT INTO predefined_request (request_name, schema_code, dataset_id, label, definition, date, user_login) VALUES ('dataset_2_donnees_a_sensibiliser', 'RAW_DATA', 'dataset_2', 'données à sensibiliser', 'données requérant une intervention manuelle',  now(), null);


-- Configuration des requêtes prédéfinies
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_observation', 'cdnom', '183716', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_localisation', 'geometrie', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_localisation', 'nomcommune', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_localisation', 'codedepartement', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_localisation', 'codeen', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_observation', 'datedebut', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_observation', 'datefin', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_observation', 'occstatutbiogeographique', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_group_request', 'form_standardisation', 'organismegestionnairedonnee', '', NULL);
                                      
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_periode', 'form_observation', 'cdnom', '183716', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_periode', 'form_observation', 'datedebut', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_periode', 'form_observation', 'datefin', '', NULL);
                                      
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_biogeo', 'form_observation', 'cdnom', '183716', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_biogeo', 'form_observation', 'occstatutbiogeographique', '', NULL);
                                      
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_producteur', 'form_observation', 'cdnom', '183716', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_producteur', 'form_standardisation', 'organismegestionnairedonnee', '', NULL);
                                      
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_localisation', 'form_observation', 'cdnom', '183716', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_localisation', 'form_localisation', 'geometrie', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_localisation', 'form_localisation', 'nomcommune', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_localisation', 'form_localisation', 'codedepartement', '', NULL);
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_localisation', 'form_localisation', 'codeen', '', NULL);
                                      
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensialerte', '1', '1');
INSERT INTO predefined_request_criterion (request_name, format, data, value, fixed) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'jddid', '', NULL);


-- Configuration des champs apparaissant dans les résultats
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'datedebut');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'nomcite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'observateuridentite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'observateurnomorganisme');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_observation', 'statutobservation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'dspublique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'jddmetadonneedeeid');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'organismegestionnairedonnee');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'orgtransformation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_group_request', 'form_standardisation', 'statutsource');
                               
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'datedebut');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'nomcite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'observateuridentite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'observateurnomorganisme');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_observation', 'statutobservation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'dspublique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'jddmetadonneedeeid');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'organismegestionnairedonnee');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'orgtransformation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_periode', 'form_standardisation', 'statutsource');
                               
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'datedebut');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'nomcite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'observateuridentite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'observateurnomorganisme');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_observation', 'statutobservation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'dspublique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'jddmetadonneedeeid');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'organismegestionnairedonnee');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'orgtransformation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_biogeo', 'form_standardisation', 'statutsource');
                               
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'datedebut');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'nomcite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'observateuridentite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'observateurnomorganisme');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_observation', 'statutobservation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'dspublique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'jddmetadonneedeeid');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'organismegestionnairedonnee');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'orgtransformation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_producteur', 'form_standardisation', 'statutsource');
                               
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'datedebut');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'nomcite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'observateuridentite');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'observateurnomorganisme');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_observation', 'statutobservation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'dspublique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'jddmetadonneedeeid');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'organismegestionnairedonnee');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'orgtransformation');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_localisation', 'form_standardisation', 'statutsource');
                               
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_observation', 'cdnom');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_observation', 'cdref');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_localisation', 'codedepartement');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_observation', 'datefin');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'identifiantpermanent');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_observation', 'occstatutbiologique');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_autre', 'PROVIDER_ID');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensialerte');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensible');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensidateattribution');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensimanuelle');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensiniveau');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensireferentiel');
INSERT INTO predefined_request_column (request_name, format, data) VALUES ('dataset_2_donnees_a_sensibiliser', 'form_standardisation', 'sensiversionreferentiel');


-- Rattachement de la requête prédéfinies au thème
INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_group_request', 1);

INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_periode', 1);
INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_biogeo', 1);
INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_producteur', 1);
INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_localisation', 1);

INSERT INTO predefined_request_group_asso(group_name, request_name, position) VALUES ('dataset_2', 'dataset_2_donnees_a_sensibiliser', 1);


GRANT ALL ON SCHEMA "website" TO ogam;
GRANT ALL ON ALL TABLES IN schema website to ogam;