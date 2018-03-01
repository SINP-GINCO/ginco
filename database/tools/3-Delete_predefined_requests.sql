--
-- Suppression des requêtes prédéfinies.
-- C'était pratique à une époque où il y avait une contrainte de clef étrangère
-- entre les datasets et les requêtes. Cela obligeait à supprimer les requêtes
-- à chaque fois qu'on relivrait metadata.
--


set search_path = website;

DELETE FROM predefined_request_group_asso;
DELETE FROM predefined_request_group;
DELETE FROM predefined_request_criteria;
DELETE FROM predefined_request_result;
DELETE FROM predefined_request;
