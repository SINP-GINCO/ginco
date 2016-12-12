--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.8
-- Dumped by pg_dump version 9.4.8
-- Started on 2016-09-06 11:22:22 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = mapping, pg_catalog;

DELETE FROM results;
DELETE FROM requests;

--
-- TOC entry 4016 (class 0 OID 2475482)
-- Dependencies: 308
-- Data for Name: requests; Type: TABLE DATA; Schema: mapping; Owner: admin
--

INSERT INTO requests VALUES (1, '123456789', now());
INSERT INTO requests VALUES (100, '111', now());
INSERT INTO requests VALUES (101, '112', now());
INSERT INTO requests VALUES (200, '222', now());
INSERT INTO requests VALUES (300, '333', now());
INSERT INTO requests VALUES (400, '444', now());
INSERT INTO requests VALUES (500, '555', now());
INSERT INTO requests VALUES (712, '12tipk191sk98afm28hnn62pdv0f2q5t', now());

--
-- TOC entry 4017 (class 0 OID 2476472)
-- Dependencies: 390
-- Data for Name: results; Type: TABLE DATA; Schema: mapping; Owner: admin
--

INSERT INTO results VALUES (1, '1', '1', 'table_observation', 3);
INSERT INTO results VALUES (1, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '15', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '19', '1', 'table_observation', 2);
INSERT INTO results VALUES (1, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '7', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (1, '9', '1', 'table_observation', 0);

INSERT INTO results VALUES (712, '1', '1', 'table_observation', 1);
INSERT INTO results VALUES (712, '10', '1', 'table_observation', 1);
INSERT INTO results VALUES (712, '11', '1', 'table_observation', 1);
INSERT INTO results VALUES (712, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '15', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '19', '1', 'table_observation', 2);
INSERT INTO results VALUES (712, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '7', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (712, '9', '1', 'table_observation', 0);

-- Request results for user with all permissions
INSERT INTO results VALUES (100, '1', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '15', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '19', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '7', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (100, '9', '1', 'table_observation', 0);

-- Request results sort
INSERT INTO results VALUES (101, '1', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '15', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '19', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '7', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (101, '9', '1', 'table_observation', 0);

-- Request results for user with only private permission
INSERT INTO results VALUES (200, '1', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '15', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '19', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '7', '1', 'table_observation', 2);
INSERT INTO results VALUES (200, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (200, '9', '1', 'table_observation', 0);

-- Request results for user with only sensitive permission
INSERT INTO results VALUES (300, '1', '1', 'table_observation', 3);
INSERT INTO results VALUES (300, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '15', '1', 'table_observation', 1);
INSERT INTO results VALUES (300, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '19', '1', 'table_observation', 2);
INSERT INTO results VALUES (300, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '7', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (300, '9', '1', 'table_observation', 0);

-- Request results for user without permissions
INSERT INTO results VALUES (400, '1', '1', 'table_observation', 3);
INSERT INTO results VALUES (400, '10', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '11', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '12', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '13', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '14', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '15', '1', 'table_observation', 1);
INSERT INTO results VALUES (400, '16', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '17', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '18', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '19', '1', 'table_observation', 2);
INSERT INTO results VALUES (400, '2', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '20', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '3', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '4', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '5', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '6', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '7', '1', 'table_observation', 2);
INSERT INTO results VALUES (400, '8', '1', 'table_observation', 0);
INSERT INTO results VALUES (400, '9', '1', 'table_observation', 0);

-- Request results for visitors
INSERT INTO results VALUES (500, '1', '1', 'table_observation', 3);
INSERT INTO results VALUES (500, '10', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '11', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '12', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '13', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '14', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '15', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '16', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '17', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '18', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '19', '1', 'table_observation', 2);
INSERT INTO results VALUES (500, '2', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '20', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '3', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '4', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '5', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '6', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '7', '1', 'table_observation', 2);
INSERT INTO results VALUES (500, '8', '1', 'table_observation', 1);
INSERT INTO results VALUES (500, '9', '1', 'table_observation', 1);

SET search_path = raw_data, pg_catalog;

DROP TABLE IF EXISTS model_1_observation;

CREATE TABLE model_1_observation (
    jddid character varying(255),
    organismegestionnairedonnee character varying(255) NOT NULL,
    occstatutbiologique character varying(255),
    codehabref character varying(255)[],
    codehabitat character varying(255)[],
    sensimanuelle character varying(255),
    objetdenombrement character varying(255),
    commentaire text,
    obsmethode character varying(255),
    preuveexistante character varying(255),
    obscontexte character varying(255),
    typeen character varying(255)[],
    nomcite character varying(255) NOT NULL,
    typeinfogeoen character varying(255),
    jourdatefin date NOT NULL,
    occstadedevie character varying(255),
    jddmetadonneedeeid character varying(255) NOT NULL,
    codeme character varying(255),
    occmethodedetermination character varying(255),
    typeinfogeomaille character varying(255),
    cdnom character varying(255),
    methoderegroupement character varying(255),
    codecommunecalcule character varying(255)[],
    profondeurmin double precision,
    organismestandard character varying(255),
    submission_id bigint,
    jourdatedebut date NOT NULL,
    statutobservation character varying(255) NOT NULL,
    obsdescription character varying(255),
    preuvenumerique character varying(255),
    occnaturalite character varying(255),
    ogam_id_table_observation character varying(255) NOT NULL,
    typeinfogeocommune character varying(255),
    sensiversionreferentiel character varying(255),
    codedepartementcalcule character varying(255)[],
    sensiniveau character varying(255),
    cdref character varying(255),
    dspublique character varying(255) NOT NULL,
    altitudemax double precision,
    codemaille character varying(255)[],
    jddcode character varying(255),
    occstatutbiogeographique character varying(255),
    anneerefcommune date,
    determinateurmail character varying(255),
    validateurnomorganisme character varying(255),
    identifiantpermanent character varying(255) NOT NULL,
    deedatedernieremodification timestamp with time zone,
    versionrefmaille character varying(255),
    observateurnomorganisme character varying(255),
    versiontaxref character varying(255),
    referencebiblio character varying(255),
    identifiantregroupementpermanent character varying(255),
    sensialerte character varying(255),
    typeinfogeodepartement character varying(255),
    sensidateattribution timestamp with time zone,
    nomcommunecalcule character varying(255)[],
    validateuridentite character varying(255),
    diffusionniveauprecision character varying(255),
    heuredatedebut time without time zone NOT NULL,
    codecommune character varying(255)[],
    denombrementmax bigint,
    codedepartement character varying(255)[],
    observateuridentite character varying(255),
    deefloutage character varying(255),
    natureobjetgeo character varying(255),
    preuvenonnumerique character varying(255),
    orgtransformation character varying(255) NOT NULL,
    codeidcnpdispositif character varying(255),
    precisiongeometrie bigint,
    sensireferentiel character varying(255),
    versionme character varying(255),
    altitudemin double precision,
    sensible character varying(255),
    observateurmail character varying(255),
    occetatbiologique character varying(255),
    typeregroupement character varying(255),
    identifiantorigine character varying(255),
    versionrefhabitat character varying(255),
    validateurmail character varying(255),
    dateme date,
    denombrementmin bigint,
    anneerefdepartement date,
    profondeurmax double precision,
    versionen date,
    nomrefmaille character varying(255),
    datedetermination timestamp with time zone,
    determinateurnomorganisme character varying(255),
    heuredatefin time without time zone NOT NULL,
    statutsource character varying(255) NOT NULL,
    occsexe character varying(255),
    codemaillecalcule character varying(255)[],
    refhabitat character varying(255)[],
    nomcommune character varying(255)[],
    typeinfogeome character varying(255),
    profondeurmoyenne double precision,
    jddsourceid character varying(255),
    codeen character varying(255)[],
    determinateuridentite character varying(255),
    altitudemoyenne double precision,
    provider_id character varying(255) NOT NULL,
    typedenombrement character varying(255),
    geometrie public.geometry(Geometry,4326)
);


ALTER TABLE model_1_observation OWNER TO ogam;

DELETE FROM submission;

INSERT INTO submission VALUES ('27', 'CHECK', 'OK', '1', 'dataset_1', 'developpeur');

--
-- TOC entry 4018 (class 0 OID 2476568)
-- Dependencies: 391
-- Data for Name: model_1_observation; Type: TABLE DATA; Schema: raw_data; Owner: ogam
--

INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'Lynx 15 cdnom', NULL, '2014-10-02', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60615', '', '{88083}', NULL, '', 27, '2014-10-01', 'No', '', '', NULL, '1', NULL, 'version 0.', '{88}', '0', NULL, 'Pr', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'MNHN-SPN', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CB8-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'FCEN', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:05.785993+02', '{CERTILLEUX}', 'Solène ROB', '3', '10:08:00', '{97313}', NULL, '{""}', 'Pierre MICHEL', NULL, 'In', '', 'MNHN-SPN', NULL, 10, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_1', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E090N680}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0101000020E6100000548A66B35D001740CDE29BFDEB274840');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'Lynx 12 cdnom', NULL, '2014-10-02', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60612', '', '{97313}', NULL, '', 27, '2014-10-01', 'No', '', '', NULL, '2', NULL, 'version 0.', '{973}', '0', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'Inconnu, Inconnu', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CB9-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'TINTIN', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:05.908252+02', '{MONTSINERY-TONNEGRANDE}', 'Test TEST, Test2 TEST 2', NULL, '10:08:00', '{""}', NULL, '{""}', 'Rasta POPOULOS', NULL, 'In', '', 'MNHN-SPN', NULL, 1, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_2', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{W320N530}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0101000020E6100000406A1327F74B4AC09C6A2DCC426B1340');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'Lynx 12 cdref', NULL, '2003-08-05', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, NULL, '', '{97313}', NULL, '', 27, '2003-08-04', 'Pr', '', '', NULL, '4', NULL, 'version 0.', '{973}', '0', '60612', 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'RATS', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBB-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'MNHN-SPN', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.182476+02', '{MONTSINERY-TONNEGRANDE}', 'Ptit LUC', NULL, '10:08:00', '{97313}', NULL, '{""}', 'Solène ROB', NULL, 'NSP', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_4', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{W320N530,W330N530}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0102000020E610000002000000406A1327F74B4AC09C6A2DCC426B13402DB29DEFA73E4AC012876C205D7C1340');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'Lynx 15 cdref', NULL, '2009-02-16', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, NULL, '', '{97313,97304,97305}', NULL, '', 27, '2009-02-15', 'Pr', '', '', NULL, '3', NULL, 'version 0.', '{973}', '0', '60615', 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'Non renseign,', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBA-1645-E053-2614A8C0B77A', '2015-11-18 00:30:00+01', '', 'RG, AG', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.139682+02', '{MONTSINERY-TONNEGRANDE,KOUROU,MACOURIA}', 'Manu LARCENET', NULL, '10:08:00', '{""}', NULL, '{""}', 'Ide FIX, Ob‚ LIX', NULL, 'In', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_3', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{W320N530,W310N540,W320N540}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0104000020E6100000030000000101000000406A1327F74B4AC09C6A2DCC426B13400101000000AD4ECE50DC4F4AC0BC07E8BE9C99134001010000008A73D4D171494AC03DB5FAEAAAC01340');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'pas de cdnom ni cdref', NULL, '2010-04-11', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, NULL, '', '{97129,97111,97121,97106}', NULL, '', 27, '2010-04-10', 'Pr', '', '', NULL, '5', NULL, 'version 0.', '{971}', '0', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'TEST', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBC-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'Inconnu, Inconnu', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.218908+02', '{SAINTE-ROSE,DESHAIES,POINTE-NOIRE,BOUILLANTE}', 'Garga MEL', NULL, '10:08:00', '{97129,97111,97121,97106}', NULL, '{971}', 'Test TEST, Test2 TEST 2', NULL, 'NSP', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_5', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{W630N1770,W620N1780,W630N1780,W620N1790,W630N1790,W640N1790,W620N1800,W630N1800,W640N1800}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', '1', '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'canis lupus avec commentaire et statut non sensible', NULL, '1988-01-02', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60577', '', '{39586,39155,39359,39529,39084,39202,39267,39009}', NULL, '', 27, '1988-01-01', 'No', '', '', NULL, '7', NULL, 'version 0.', '{39}', '2', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'Black', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBE-1645-E053-2614A8C0B77A', '2016-08-29 16:29:06.305265+02', '', 'RATS', 'V8.0', '', '', '1', NULL, '2016-08-29 16:29:06.305265+02', '{ARESCHES,CLUCY,MONTMARLON,THESY,CERNANS,DOURNON,IVORY}', NULL, NULL, '10:08:00', '{94080}', NULL, '{""}', 'Ptit LUC', NULL, 'NSP', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '1', '', NULL, NULL, 'T82_1_7', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E092N664,E092N665,E091N664,E091N665}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0103000020E61000000100000005000000A1F831E6AE651740D578E926317847406688635DDCC6174072F90FE9B7774740C8073D9B55DF174092CB7F48BF6D47402C6519E25857174039454772F96F4740A1F831E6AE651740D578E92631784740');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', '3', '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'canis lupus avec commentaire et statut sensible', NULL, '2015-01-15', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60577', '', '{97304,97305,97313}', NULL, '', 27, '2015-01-14', 'Pr', '', '', NULL, '6', NULL, 'version 0.', '{973}', '0', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'BEGONIA', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBD-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'Non renseign,', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.26314+02', '{KOUROU,MACOURIA,MONTSINERY-TONNEGRANDE}', 'Pierre RICHARD', NULL, '10:08:00', '{""}', NULL, '{""}', 'Manu LARCENET', NULL, 'NSP', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_6', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{W320N530,W330N530,W310N540,W320N540}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0105000020E610000002000000010200000002000000406A1327F74B4AC09C6A2DCC426B13402DB29DEFA73E4AC012876C205D7C1340010200000002000000AD4ECE50DC4F4AC0BC07E8BE9C9913408A73D4D171494AC03DB5FAEAAAC01340');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'pas de departement', NULL, '2014-02-03', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60577', '', '{91538}', NULL, '', 27, '2014-02-02', 'No', '', '', NULL, '8', NULL, 'version 0.', '{91}', '0', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', 'CENAIPAS', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CBF-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'TEST', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.416588+02', '{SAINT-AUBIN}', 'Sinse MILIA', NULL, '10:08:00', '{""}', NULL, '{17}', 'Garga MEL', NULL, 'St', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_8', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E063N684}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0101000020E6100000B2A7019AEE3301400016CF301F5B4840');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'dur�e �coul�e', NULL, '2018-11-04', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '60577', '', '{94080,93048}', NULL, '', 27, '2018-11-03', 'No', '', '', NULL, '9', NULL, 'version 0.', '{93,94}', '0', NULL, 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', '', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC0-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'BEGONIA', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.453108+02', '{VINCENNES,MONTREUIL}', 'Paul HENRI', NULL, '10:08:00', '{""}', NULL, '{94}', 'Pierre RICHARD', NULL, 'St', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_9', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E065N686}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0102000020E610000002000000B80721205F620340ECA694D74A6C48402FF7C95180680340D5D00660036E4840');
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'a', NULL, '2013-07-22', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405844', '', '{""}', NULL, '', 27, '2013-07-21', 'Pr', '', '', NULL, '10', NULL, 'version 0.', '{17}', '0', '236034', 'Pu', NULL, '{E041N653,E041N652,E042N652}', 'BDMAP', NULL, NULL, '', 'Service des eaux fluviales', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC1-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'Black', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.479239+02', '{""}', 'Pierre QUIMOUSSE', NULL, '10:08:00', '{""}', NULL, '{17}', 'Bloody BEETROOTS', NULL, 'St', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_10', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E041N653,E041N652,E042N652}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'g', NULL, '2000-05-15', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', '1', '405850', '', '{17148,17089,17435,17460,17100,17313,17143,17314}', NULL, '', 27, '2000-05-14', 'No', '', '', NULL, '16', NULL, 'version 0.', '{17}', '0', '236034', 'NSP', NULL, '{E041N653,E041N652,E042N652}', 'MA_BASE', NULL, NULL, '', '', 'http://test-occtax-ginco.ign.fr/occtax/17865121-1810-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'VINCI', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.66112+02', '{ECURAT,"LA CHAPELLE-DES-POTS",TAILLANT,VARZAY,CHERAC,SAINT-BRIS-DES-BOIS,"LE DOUHET"}', 'Tatie DANIEL', NULL, '10:08:00', '{""}', NULL, '{""}', 'Léo NARD', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_3', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E041N653,E041N652,E042N652}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'b', NULL, '2008-05-23', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405847', '', '{94033,94052}', NULL, '', 27, '2008-05-22', 'Pr', '', '', NULL, '11', NULL, 'version 0.', '{94}', '0', '236034', 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', '', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC2-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'CENAIPAS', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.506859+02', '{FONTENAY-SOUS-BOIS,NOGENT-SUR-MARNE}', 'Sarah CROCHE', NULL, '10:08:00', '{94080}', NULL, '{""}', 'Sinse MILIA', NULL, 'In', '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_11', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E066N686}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0103000020E610000001000000060000007F130A1170C80340161747E5266C4840C93B873254C503405DE2C803916B4840C616821C94D003405DE2C803916B4840FBC9181F66CF0340E23C9CC0746C4840B7EBA52902BC03402E8F3523836C48407F130A1170C80340161747E5266C4840');
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'f', NULL, '2000-05-14', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405849', '', '{67444}', NULL, '', 27, '2000-05-13', 'Pr', '', '', NULL, '15', '1', 'version 0.', '{67}', '0', '236034', 'Pr', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'PLACO', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC5-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', '', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.622961+02', '{SCHERLENHEIM}', 'Merlin LEROY', NULL, '10:08:00', '{67444}', NULL, '{""}', 'Daniel GUICHARD', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_2', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E103N686}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'd', NULL, '2000-05-12', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405848', '', '{67407,67345,67180,67106,67194}', NULL, '', 27, '2000-05-11', 'Pr', '', '', NULL, '13', NULL, 'version 0.', '{67}', '0', '236034', 'Pu', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'VINCI', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC4-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'Service des eaux fluviales', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.57052+02', '{ROHRWILLER,OBERHOFFEN-SUR-MODER,HAGUENAU,DRUSENHEIM,HERRLISHEIM}', 'Léo NARD', NULL, '10:08:00', '{94080}', NULL, '{94}', 'Pierre QUIMOUSSE', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_13', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E105N686,E105N687,E106N686}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0106000020E61000000300000001030000000100000004000000265305A3927A1F4000917EFB3A704840DB8AFD65F7641F408FE4F21FD26F48400DE02D90A0781F4014AE47E17A6C4840265305A3927A1F4000917EFB3A7048400103000000010000000400000010E9B7AF03271F400BB5A679C769484077BE9F1A2F1D1F40E5D022DBF96648409A779CA223391F40E86A2BF69765484010E9B7AF03271F400BB5A679C7694840010300000001000000050000003D2CD49AE69D1F40ABCFD556EC5F484058CA32C4B1AE1F40C976BE9F1A5F4840E4839ECDAACF1F40F0A7C64B3761484088855AD3BCA31F404260E5D0226348403D2CD49AE69D1F40ABCFD556EC5F4840');
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'e', NULL, '2000-05-13', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405846', '', '{67444}', NULL, '', 27, '2000-05-12', 'Pr', '', '', NULL, '14', NULL, 'version 0.', '{67}', '0', '236034', 'Pu', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'Groupe détude des Amphibiens de la Loire', 'http://test-occtax-ginco.ign.fr/occtax/17865121-180F-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', '', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.592626+02', '{SCHERLENHEIM}', 'Jacques TATI', NULL, '10:08:00', '{67444}', NULL, '{17}', 'Sarah CROCHE', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_1', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E103N686}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('T82', 'ONEMA', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'c', NULL, '2000-05-11', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405845', '', '{67180}', NULL, '', 27, '2000-05-10', 'Pr', '', '', NULL, '12', NULL, 'version 0.', '{67}', '0', '236034', 'Pu', NULL, '{""}', 'BDMAP', NULL, NULL, '', '', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC3-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', '', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.536593+02', '{HAGUENAU}', 'Daniel GUICHARD', NULL, '10:08:00', '{""}', NULL, '{""}', 'Paul HENRI', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T82_1_12', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'Te', NULL, '{E105N686,E105N687}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0106000020E61000000200000001030000000100000004000000265305A3927A1F4000917EFB3A704840DB8AFD65F7641F408FE4F21FD26F48400DE02D90A0781F4014AE47E17A6C4840265305A3927A1F4000917EFB3A7048400103000000010000000400000010E9B7AF03271F400BB5A679C769484077BE9F1A2F1D1F40E5D022DBF96648409A779CA223391F40E86A2BF69765484010E9B7AF03271F400BB5A679C7694840');
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'i', NULL, '2000-05-17', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405852', '', '{95594,95682,95166,95258,95308,954460}', NULL, '', 27, '2000-05-16', 'Pr', '', '', NULL, '18', NULL, 'version 0.', '{95}', '0', '236034', 'NSP', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'TINTIN', 'http://test-occtax-ginco.ign.fr/occtax/17865121-1811-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'PLACO', 'V8.0', '', '', '0', '1', '2016-08-29 16:29:06.820977+02', '{SEUGY,VILLIERS-LE-SEC,CLERY-EN-VEXIN,FROUVILLE,HEROUVILLE,NESLES-LA-VALLEE,SAINT-OUEN-L''AUMONE}', 'Rasta POPOULOS', NULL, '10:08:00', '{""}', NULL, '{95}', 'Merlin LEROY', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_5', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E059N688,E059N689,E060N688,E060N689,E060N690}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'j', NULL, '2014-10-02', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405853', '', '{94080,94067}', NULL, '', 27, '2014-10-01', 'Pr', '', '', NULL, '20', NULL, 'version 0.', '{94}', '0', '236034', 'NSP', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'RG, AG', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC7-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', '', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.974413+02', '{VINCENNES,SAINT-MANDE}', 'Ide FIX, Ob‚ LIX', NULL, '10:08:00', '{94080,94067}', NULL, '{94}', 'Tatie DANIEL', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_6', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E065N685,E065N686,E066N686}', '{""}', '{Vincennes,Saint-Mandée}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'h', NULL, '2000-05-16', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405851', '', '{""}', NULL, '', 27, '2000-05-15', 'Pr', '', '', NULL, '17', NULL, 'version 0.', '{78}', '0', '236034', 'NSP', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'FCEN', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC6-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', 'Groupe détude des Amphibiens de la Loire', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.729999+02', '{""}', 'Pierre MICHEL', NULL, '10:08:00', '{""}', NULL, '{78}', 'Jacques TATI', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_4', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E059N685,E059N686,E059N687,E059N688,E058N687,E058N688,E059N683,E059N684,E060N682}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, NULL);
INSERT INTO model_1_observation VALUES ('jdd25_12_32', 'MNHN-SPN', NULL, '{""}', '{""}', '0', NULL, '', NULL, NULL, '', '{""}', 'j', NULL, '2000-05-18', NULL, 'https://test-occtax-ginco.ign.fr/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml', '', '', NULL, '405853', '', '{67261}', NULL, '', 27, '2000-05-17', 'Pr', '', '', NULL, '19', NULL, 'version 0.', '{67}', '3', '236034', 'Pr', NULL, '{""}', 'MA_BASE', NULL, NULL, '', 'RG, AG', 'http://test-occtax-ginco.ign.fr/occtax/1786511F-0CC7-1645-E053-2614A8C0B77A', '2015-11-18 00:00:00+01', '', '', 'V8.0', '', '', '0', NULL, '2016-08-29 16:29:06.946129+02', '{LAUTERBOURG}', 'Ide FIX, Ob‚ LIX', '2', '10:08:00', '{""}', NULL, '{77}', 'Tatie DANIEL', NULL, NULL, '', 'MNHN-SPN', NULL, NULL, 'Référentiel de test (désignation indiquée en dur dans la fonction sensitive_automatic()).', NULL, NULL, '0', '', NULL, NULL, 'T83_1_6', '', '', NULL, NULL, NULL, NULL, NULL, '', '2015-01-01 00:00:00+01', '', '11:02:00', 'NSP', NULL, '{E108N688}', '{""}', '{""}', NULL, NULL, '', '{""}', '', NULL, '1', NULL, '0101000020E6100000D9B11188D77520403255302AA97B4840');


ALTER TABLE ONLY model_1_observation
    ADD CONSTRAINT model_1_observation_pkey PRIMARY KEY (ogam_id_table_observation, provider_id);
    
