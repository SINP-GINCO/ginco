DROP SCHEMA geosource CASCADE;

CREATE SCHEMA geosource;

ALTER SCHEMA geosource OWNER TO admin;

SET search_path = geosource, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 338 (class 1259 OID 27559261)
-- Name: address; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    address character varying(255),
    city character varying(255),
    country character varying(255),
    state character varying(255),
    zip character varying(16)
);


ALTER TABLE geosource.address OWNER TO geosource;

--
-- TOC entry 339 (class 1259 OID 27559267)
-- Name: categories; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE geosource.categories OWNER TO geosource;

--
-- TOC entry 340 (class 1259 OID 27559270)
-- Name: categoriesdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE categoriesdes (
    iddes integer NOT NULL,
    label character varying(255) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.categoriesdes OWNER TO geosource;

--
-- TOC entry 341 (class 1259 OID 27559273)
-- Name: cswservercapabilitiesinfo; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE cswservercapabilitiesinfo (
    idfield integer NOT NULL,
    field character varying(32) NOT NULL,
    langid character varying(5) NOT NULL,
    label text
);


ALTER TABLE geosource.cswservercapabilitiesinfo OWNER TO geosource;

--
-- TOC entry 342 (class 1259 OID 27559279)
-- Name: customelementset; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE customelementset (
    xpathhashcode integer NOT NULL,
    xpath character varying(1000) NOT NULL
);


ALTER TABLE geosource.customelementset OWNER TO geosource;

--
-- TOC entry 343 (class 1259 OID 27559285)
-- Name: email; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE email (
    user_id integer NOT NULL,
    email character varying(255)
);


ALTER TABLE geosource.email OWNER TO geosource;

--
-- TOC entry 344 (class 1259 OID 27559288)
-- Name: groups; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    description character varying(255),
    email character varying(32),
    logo character varying(255),
    name character varying(32) NOT NULL,
    referrer integer,
    website character varying(255)
);


ALTER TABLE geosource.groups OWNER TO geosource;

--
-- TOC entry 345 (class 1259 OID 27559294)
-- Name: groupsdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE groupsdes (
    iddes integer NOT NULL,
    label character varying(96) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.groupsdes OWNER TO geosource;

--
-- TOC entry 346 (class 1259 OID 27559297)
-- Name: harvesterdata; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE harvesterdata (
    harvesteruuid character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE geosource.harvesterdata OWNER TO geosource;

--
-- TOC entry 347 (class 1259 OID 27559303)
-- Name: harvestersettings; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE harvestersettings (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    value text,
    parentid integer
);


ALTER TABLE geosource.harvestersettings OWNER TO geosource;

--
-- TOC entry 348 (class 1259 OID 27559309)
-- Name: harvesthistory; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE harvesthistory (
    id integer NOT NULL,
    deleted character(1) NOT NULL,
    elapsedtime integer,
    harvestdate character varying(30),
    harvestername character varying(255),
    harvestertype character varying(255),
    harvesteruuid character varying(255),
    info text,
    params text
);


ALTER TABLE geosource.harvesthistory OWNER TO geosource;

--
-- TOC entry 350 (class 1259 OID 27559317)
-- Name: inspireatomfeed; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE inspireatomfeed (
    id integer NOT NULL,
    atom text,
    atomdatasetid character varying(255),
    atomdatasetns character varying(255),
    atomurl character varying(255),
    authoremail character varying(255),
    authorname character varying(255),
    lang character varying(3),
    metadataid integer NOT NULL,
    rights character varying(255),
    subtitle character varying(255),
    title character varying(255)
);


ALTER TABLE geosource.inspireatomfeed OWNER TO geosource;

--
-- TOC entry 351 (class 1259 OID 27559323)
-- Name: inspireatomfeed_entrylist; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE inspireatomfeed_entrylist (
    inspireatomfeed_id integer NOT NULL,
    crs character varying(255),
    id integer NOT NULL,
    lang character varying(3),
    title character varying(255),
    type character varying(255),
    url character varying(255)
);


ALTER TABLE geosource.inspireatomfeed_entrylist OWNER TO geosource;

--
-- TOC entry 352 (class 1259 OID 27559329)
-- Name: isolanguages; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE isolanguages (
    id integer NOT NULL,
    code character varying(3) NOT NULL,
    shortcode character varying(2)
);


ALTER TABLE geosource.isolanguages OWNER TO geosource;

--
-- TOC entry 353 (class 1259 OID 27559332)
-- Name: isolanguagesdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE isolanguagesdes (
    iddes integer NOT NULL,
    label character varying(255) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.isolanguagesdes OWNER TO geosource;

--
-- TOC entry 354 (class 1259 OID 27559335)
-- Name: languages; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE languages (
    id character varying(5) NOT NULL,
    isdefault character(1),
    isinspire character(1),
    name character varying(255) NOT NULL
);


ALTER TABLE geosource.languages OWNER TO geosource;

--
-- TOC entry 355 (class 1259 OID 27559338)
-- Name: mapservers; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE mapservers (
    id integer NOT NULL,
    configurl character varying(255) NOT NULL,
    description character varying(255),
    name character varying(32) NOT NULL,
    namespace character varying(255),
    namespaceprefix character varying(255),
    password character varying(128),
    stylerurl character varying(255),
    username character varying(128),
    wcsurl character varying(255),
    wfsurl character varying(255),
    wmsurl character varying(255)
);


ALTER TABLE geosource.mapservers OWNER TO geosource;

--
-- TOC entry 356 (class 1259 OID 27559344)
-- Name: metadata; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadata (
    id integer NOT NULL,
    data text NOT NULL,
    changedate character varying(30) NOT NULL,
    createdate character varying(30) NOT NULL,
    displayorder integer,
    doctype character varying(255),
    extra character varying(255),
    popularity integer NOT NULL,
    rating integer NOT NULL,
    root character varying(255),
    schemaid character varying(32) NOT NULL,
    title character varying(255),
    istemplate character(1) NOT NULL,
    isharvested character(1) NOT NULL,
    harvesturi character varying(512),
    harvestuuid character varying(255),
    groupowner integer,
    owner integer NOT NULL,
    source character varying(255) NOT NULL,
    uuid character varying(255) NOT NULL
);


ALTER TABLE geosource.metadata OWNER TO geosource;

--
-- TOC entry 357 (class 1259 OID 27559350)
-- Name: metadatacateg; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatacateg (
    metadataid integer NOT NULL,
    categoryid integer NOT NULL
);


ALTER TABLE geosource.metadatacateg OWNER TO geosource;

--
-- TOC entry 358 (class 1259 OID 27559353)
-- Name: metadatafiledownloads; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatafiledownloads (
    id integer NOT NULL,
    downloaddate character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    fileuploadid integer NOT NULL,
    metadataid integer NOT NULL,
    requestercomments character varying(255),
    requestermail character varying(255),
    requestername character varying(255),
    requesterorg character varying(255),
    username character varying(255)
);


ALTER TABLE geosource.metadatafiledownloads OWNER TO geosource;

--
-- TOC entry 359 (class 1259 OID 27559359)
-- Name: metadatafileuploads; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatafileuploads (
    id integer NOT NULL,
    deleteddate character varying(255),
    filename character varying(255) NOT NULL,
    filesize double precision NOT NULL,
    metadataid integer NOT NULL,
    uploaddate character varying(255) NOT NULL,
    username character varying(255) NOT NULL
);


ALTER TABLE geosource.metadatafileuploads OWNER TO geosource;

--
-- TOC entry 360 (class 1259 OID 27559365)
-- Name: metadatanotifications; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatanotifications (
    metadataid integer NOT NULL,
    notifierid integer NOT NULL,
    action integer NOT NULL,
    errormsg text,
    metadatauuid character varying(255) NOT NULL,
    notified character(1) NOT NULL
);


ALTER TABLE geosource.metadatanotifications OWNER TO geosource;

--
-- TOC entry 361 (class 1259 OID 27559371)
-- Name: metadatanotifiers; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatanotifiers (
    id integer NOT NULL,
    enabled character(1) NOT NULL,
    name character varying(32) NOT NULL,
    password character varying(255),
    url character varying(255) NOT NULL,
    username character varying(32)
);


ALTER TABLE geosource.metadatanotifiers OWNER TO geosource;

--
-- TOC entry 362 (class 1259 OID 27559377)
-- Name: metadatarating; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatarating (
    ipaddress character varying(45) NOT NULL,
    metadataid integer NOT NULL,
    rating integer NOT NULL
);


ALTER TABLE geosource.metadatarating OWNER TO geosource;

--
-- TOC entry 363 (class 1259 OID 27559380)
-- Name: metadatastatus; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE metadatastatus (
    changedate character varying(30) NOT NULL,
    metadataid integer NOT NULL,
    statusid integer NOT NULL,
    userid integer NOT NULL,
    changemessage character varying(2048) NOT NULL
);


ALTER TABLE geosource.metadatastatus OWNER TO geosource;

--
-- TOC entry 364 (class 1259 OID 27559386)
-- Name: operationallowed; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE operationallowed (
    groupid integer NOT NULL,
    metadataid integer NOT NULL,
    operationid integer NOT NULL
);


ALTER TABLE geosource.operationallowed OWNER TO geosource;

--
-- TOC entry 365 (class 1259 OID 27559389)
-- Name: operations; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE operations (
    id integer NOT NULL,
    name character varying(32) NOT NULL
);


ALTER TABLE geosource.operations OWNER TO geosource;

--
-- TOC entry 366 (class 1259 OID 27559392)
-- Name: operationsdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE operationsdes (
    iddes integer NOT NULL,
    label character varying(255) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.operationsdes OWNER TO geosource;

--
-- TOC entry 368 (class 1259 OID 27559401)
-- Name: relations; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE relations (
    id integer NOT NULL,
    relatedid integer NOT NULL
);


ALTER TABLE geosource.relations OWNER TO geosource;

--
-- TOC entry 370 (class 1259 OID 27559410)
-- Name: schematron; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE schematron (
    id integer NOT NULL,
    displaypriority integer NOT NULL,
    filename character varying(255) NOT NULL,
    schemaname character varying(255) NOT NULL
);


ALTER TABLE geosource.schematron OWNER TO geosource;

--
-- TOC entry 371 (class 1259 OID 27559416)
-- Name: schematroncriteria; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE schematroncriteria (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    uitype character varying(255),
    uivalue character varying(255),
    value character varying(255) NOT NULL,
    group_name character varying(255) NOT NULL,
    group_schematronid integer NOT NULL
);


ALTER TABLE geosource.schematroncriteria OWNER TO geosource;

--
-- TOC entry 372 (class 1259 OID 27559422)
-- Name: schematroncriteriagroup; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE schematroncriteriagroup (
    name character varying(255) NOT NULL,
    schematronid integer NOT NULL,
    requirement character varying(255) NOT NULL
);


ALTER TABLE geosource.schematroncriteriagroup OWNER TO geosource;

--
-- TOC entry 373 (class 1259 OID 27559428)
-- Name: schematrondes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE schematrondes (
    iddes integer NOT NULL,
    label character varying(96) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.schematrondes OWNER TO geosource;

--
-- TOC entry 374 (class 1259 OID 27559431)
-- Name: serviceparameters; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE serviceparameters (
    id integer NOT NULL,
    name character varying(255),
    occur character(1),
    value character varying(255),
    service integer
);


ALTER TABLE geosource.serviceparameters OWNER TO geosource;

--
-- TOC entry 375 (class 1259 OID 27559437)
-- Name: services; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE services (
    id integer NOT NULL,
    class character varying(1024) NOT NULL,
    description character varying(1024),
    explicitquery character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE geosource.services OWNER TO geosource;

--
-- TOC entry 376 (class 1259 OID 27559443)
-- Name: settings; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE settings (
    name character varying(255) NOT NULL,
    datatype integer,
    internal character(1) DEFAULT 'y'::bpchar NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    value text
);


ALTER TABLE geosource.settings OWNER TO geosource;

--
-- TOC entry 377 (class 1259 OID 27559451)
-- Name: sources; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE sources (
    uuid character varying(255) NOT NULL,
    islocal character(1) NOT NULL,
    name character varying(255)
);


ALTER TABLE geosource.sources OWNER TO geosource;

--
-- TOC entry 378 (class 1259 OID 27559457)
-- Name: sourcesdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE sourcesdes (
    iddes character varying(255) NOT NULL,
    label character varying(96) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.sourcesdes OWNER TO geosource;

--
-- TOC entry 379 (class 1259 OID 27559460)
-- Name: statusvalues; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE statusvalues (
    id integer NOT NULL,
    displayorder integer,
    name character varying(255) NOT NULL,
    reserved character(1) NOT NULL
);


ALTER TABLE geosource.statusvalues OWNER TO geosource;

--
-- TOC entry 380 (class 1259 OID 27559463)
-- Name: statusvaluesdes; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE statusvaluesdes (
    iddes integer NOT NULL,
    label character varying(255) NOT NULL,
    langid character varying(5) NOT NULL
);


ALTER TABLE geosource.statusvaluesdes OWNER TO geosource;

--
-- TOC entry 381 (class 1259 OID 27559466)
-- Name: thesaurus; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE thesaurus (
    id character varying(255) NOT NULL,
    activated character(1) NOT NULL
);


ALTER TABLE geosource.thesaurus OWNER TO geosource;

--
-- TOC entry 382 (class 1259 OID 27559469)
-- Name: useraddress; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE useraddress (
    userid integer NOT NULL,
    addressid integer NOT NULL
);


ALTER TABLE geosource.useraddress OWNER TO geosource;

--
-- TOC entry 383 (class 1259 OID 27559472)
-- Name: usergroups; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE usergroups (
    groupid integer NOT NULL,
    profile integer NOT NULL,
    userid integer NOT NULL
);


ALTER TABLE geosource.usergroups OWNER TO geosource;

--
-- TOC entry 384 (class 1259 OID 27559475)
-- Name: users; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    kind character varying(16),
    lastlogindate character varying(255),
    name character varying(255),
    organisation character varying(255),
    profile integer NOT NULL,
    authtype character varying(32),
    nodeid character varying(255),
    password character varying(120) NOT NULL,
    security character varying(128),
    surname character varying(255),
    username character varying(255) NOT NULL
);


ALTER TABLE geosource.users OWNER TO geosource;

--
-- TOC entry 385 (class 1259 OID 27559481)
-- Name: validation; Type: TABLE; Schema: geosource; Owner: geosource; Tablespace: 
--

CREATE TABLE validation (
    metadataid integer NOT NULL,
    valtype character varying(40) NOT NULL,
    failed integer,
    tested integer,
    required boolean,
    status integer NOT NULL,
    valdate character varying(30)
);


ALTER TABLE geosource.validation OWNER TO geosource;

--
-- TOC entry 4068 (class 0 OID 27559261)
-- Dependencies: 338
-- Data for Name: address; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO address VALUES (1, '', '', '', '', '');


--
-- TOC entry 4069 (class 0 OID 27559267)
-- Dependencies: 339
-- Data for Name: categories; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO categories VALUES (1, 'maps');
INSERT INTO categories VALUES (2, 'datasets');
INSERT INTO categories VALUES (3, 'interactiveResources');
INSERT INTO categories VALUES (4, 'applications');
INSERT INTO categories VALUES (5, 'caseStudies');
INSERT INTO categories VALUES (6, 'proceedings');
INSERT INTO categories VALUES (7, 'photo');
INSERT INTO categories VALUES (8, 'audioVideo');
INSERT INTO categories VALUES (9, 'directories');
INSERT INTO categories VALUES (10, 'otherResources');
INSERT INTO categories VALUES (11, 'z3950Servers');
INSERT INTO categories VALUES (12, 'registers');
INSERT INTO categories VALUES (13, 'physicalSamples');


--
-- TOC entry 4070 (class 0 OID 27559270)
-- Dependencies: 340
-- Data for Name: categoriesdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO categoriesdes VALUES (1, 'Maps & graphics', 'eng');
INSERT INTO categoriesdes VALUES (2, 'Datasets', 'eng');
INSERT INTO categoriesdes VALUES (3, 'Interactive resources', 'eng');
INSERT INTO categoriesdes VALUES (4, 'Applications', 'eng');
INSERT INTO categoriesdes VALUES (5, 'Case studies, best practices', 'eng');
INSERT INTO categoriesdes VALUES (6, 'Conference proceedings', 'eng');
INSERT INTO categoriesdes VALUES (7, 'Photo', 'eng');
INSERT INTO categoriesdes VALUES (8, 'Audio/Video', 'eng');
INSERT INTO categoriesdes VALUES (9, 'Directories', 'eng');
INSERT INTO categoriesdes VALUES (10, 'Other information resources', 'eng');
INSERT INTO categoriesdes VALUES (11, 'Z3950 Servers', 'eng');
INSERT INTO categoriesdes VALUES (12, 'Registers', 'eng');
INSERT INTO categoriesdes VALUES (13, 'Physical Samples', 'eng');
INSERT INTO categoriesdes VALUES (2, 'Jeux de données', 'fre');
INSERT INTO categoriesdes VALUES (1, 'Cartes & graphiques', 'fre');
INSERT INTO categoriesdes VALUES (7, 'Photographies', 'fre');
INSERT INTO categoriesdes VALUES (10, 'Autres ressources', 'fre');
INSERT INTO categoriesdes VALUES (5, 'Etude de cas, meilleures pratiques', 'fre');
INSERT INTO categoriesdes VALUES (8, 'Vidéo/Audio', 'fre');
INSERT INTO categoriesdes VALUES (9, 'Répertoires', 'fre');
INSERT INTO categoriesdes VALUES (4, 'Applications', 'fre');
INSERT INTO categoriesdes VALUES (3, 'Ressources interactives', 'fre');
INSERT INTO categoriesdes VALUES (6, 'Conférences', 'fre');
INSERT INTO categoriesdes VALUES (11, 'Serveurs Z3950', 'fre');
INSERT INTO categoriesdes VALUES (12, 'Annuaires', 'fre');
INSERT INTO categoriesdes VALUES (13, 'Echantillons physiques', 'fre');


--
-- TOC entry 4071 (class 0 OID 27559273)
-- Dependencies: 341
-- Data for Name: cswservercapabilitiesinfo; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO cswservercapabilitiesinfo VALUES (1, 'title', 'eng', '');
INSERT INTO cswservercapabilitiesinfo VALUES (2, 'abstract', 'eng', '');
INSERT INTO cswservercapabilitiesinfo VALUES (3, 'fees', 'eng', '');
INSERT INTO cswservercapabilitiesinfo VALUES (4, 'accessConstraints', 'eng', '');
INSERT INTO cswservercapabilitiesinfo VALUES (21, 'title', 'fre', '');
INSERT INTO cswservercapabilitiesinfo VALUES (22, 'abstract', 'fre', '');
INSERT INTO cswservercapabilitiesinfo VALUES (23, 'fees', 'fre', '');
INSERT INTO cswservercapabilitiesinfo VALUES (24, 'accessConstraints', 'fre', '');


--
-- TOC entry 4072 (class 0 OID 27559279)
-- Dependencies: 342
-- Data for Name: customelementset; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4073 (class 0 OID 27559285)
-- Dependencies: 343
-- Data for Name: email; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO email VALUES (1, 'dev@dev');


--
-- TOC entry 4074 (class 0 OID 27559288)
-- Dependencies: 344
-- Data for Name: groups; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO groups VALUES (-1, 'self-registered users', NULL, NULL, 'GUEST', NULL, NULL);
INSERT INTO groups VALUES (1, NULL, NULL, NULL, 'all', NULL, NULL);
INSERT INTO groups VALUES (2, NULL, NULL, NULL, 'default', NULL, NULL);


--
-- TOC entry 4075 (class 0 OID 27559294)
-- Dependencies: 345
-- Data for Name: groupsdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO groupsdes VALUES (-1, 'Guest', 'eng');
INSERT INTO groupsdes VALUES (1, 'All', 'eng');
INSERT INTO groupsdes VALUES (2, 'Default group', 'eng');
INSERT INTO groupsdes VALUES (-1, 'Invité', 'fre');
INSERT INTO groupsdes VALUES (1, 'Public', 'fre');
INSERT INTO groupsdes VALUES (2, 'Groupe par défaut', 'fre');


--
-- TOC entry 4076 (class 0 OID 27559297)
-- Dependencies: 346
-- Data for Name: harvesterdata; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4077 (class 0 OID 27559303)
-- Dependencies: 347
-- Data for Name: harvestersettings; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO harvestersettings VALUES (1, 'harvesting', NULL, NULL);


--
-- TOC entry 4078 (class 0 OID 27559309)
-- Dependencies: 348
-- Data for Name: harvesthistory; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4079 (class 0 OID 27559317)
-- Dependencies: 350
-- Data for Name: inspireatomfeed; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4080 (class 0 OID 27559323)
-- Dependencies: 351
-- Data for Name: inspireatomfeed_entrylist; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4081 (class 0 OID 27559329)
-- Dependencies: 352
-- Data for Name: isolanguages; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO isolanguages VALUES (1, 'aar', 'aa');
INSERT INTO isolanguages VALUES (2, 'abk', 'ab');
INSERT INTO isolanguages VALUES (3, 'ace', NULL);
INSERT INTO isolanguages VALUES (4, 'ach', NULL);
INSERT INTO isolanguages VALUES (5, 'ada', NULL);
INSERT INTO isolanguages VALUES (6, 'ady', NULL);
INSERT INTO isolanguages VALUES (7, 'afa', NULL);
INSERT INTO isolanguages VALUES (8, 'afh', NULL);
INSERT INTO isolanguages VALUES (9, 'afr', 'af');
INSERT INTO isolanguages VALUES (10, 'ain', NULL);
INSERT INTO isolanguages VALUES (11, 'aka', 'ak');
INSERT INTO isolanguages VALUES (12, 'akk', NULL);
INSERT INTO isolanguages VALUES (13, 'alb', 'sq');
INSERT INTO isolanguages VALUES (14, 'ale', NULL);
INSERT INTO isolanguages VALUES (15, 'alg', NULL);
INSERT INTO isolanguages VALUES (16, 'alt', NULL);
INSERT INTO isolanguages VALUES (17, 'amh', 'am');
INSERT INTO isolanguages VALUES (18, 'ang', NULL);
INSERT INTO isolanguages VALUES (19, 'anp', NULL);
INSERT INTO isolanguages VALUES (20, 'apa', NULL);
INSERT INTO isolanguages VALUES (21, 'ara', 'ar');
INSERT INTO isolanguages VALUES (22, 'arc', NULL);
INSERT INTO isolanguages VALUES (23, 'arg', 'an');
INSERT INTO isolanguages VALUES (24, 'arm', 'hy');
INSERT INTO isolanguages VALUES (25, 'arn', NULL);
INSERT INTO isolanguages VALUES (26, 'arp', NULL);
INSERT INTO isolanguages VALUES (27, 'art', NULL);
INSERT INTO isolanguages VALUES (28, 'arw', NULL);
INSERT INTO isolanguages VALUES (29, 'asm', 'as');
INSERT INTO isolanguages VALUES (30, 'ast', NULL);
INSERT INTO isolanguages VALUES (31, 'ath', NULL);
INSERT INTO isolanguages VALUES (32, 'aus', NULL);
INSERT INTO isolanguages VALUES (33, 'ava', 'av');
INSERT INTO isolanguages VALUES (34, 'ave', 'ae');
INSERT INTO isolanguages VALUES (35, 'awa', NULL);
INSERT INTO isolanguages VALUES (36, 'aym', 'ay');
INSERT INTO isolanguages VALUES (37, 'aze', 'az');
INSERT INTO isolanguages VALUES (38, 'bad', NULL);
INSERT INTO isolanguages VALUES (39, 'bai', NULL);
INSERT INTO isolanguages VALUES (40, 'bak', 'ba');
INSERT INTO isolanguages VALUES (41, 'bal', NULL);
INSERT INTO isolanguages VALUES (42, 'bam', 'bm');
INSERT INTO isolanguages VALUES (43, 'ban', NULL);
INSERT INTO isolanguages VALUES (44, 'baq', 'eu');
INSERT INTO isolanguages VALUES (45, 'bas', NULL);
INSERT INTO isolanguages VALUES (46, 'bat', NULL);
INSERT INTO isolanguages VALUES (47, 'bej', NULL);
INSERT INTO isolanguages VALUES (48, 'bel', 'be');
INSERT INTO isolanguages VALUES (49, 'bem', NULL);
INSERT INTO isolanguages VALUES (50, 'ben', 'bn');
INSERT INTO isolanguages VALUES (51, 'ber', NULL);
INSERT INTO isolanguages VALUES (52, 'bho', NULL);
INSERT INTO isolanguages VALUES (53, 'bih', 'bh');
INSERT INTO isolanguages VALUES (54, 'bik', NULL);
INSERT INTO isolanguages VALUES (55, 'bin', NULL);
INSERT INTO isolanguages VALUES (56, 'bis', 'bi');
INSERT INTO isolanguages VALUES (57, 'bla', NULL);
INSERT INTO isolanguages VALUES (58, 'bnt', NULL);
INSERT INTO isolanguages VALUES (59, 'bos', 'bs');
INSERT INTO isolanguages VALUES (60, 'bra', NULL);
INSERT INTO isolanguages VALUES (61, 'bre', 'br');
INSERT INTO isolanguages VALUES (62, 'btk', NULL);
INSERT INTO isolanguages VALUES (63, 'bua', NULL);
INSERT INTO isolanguages VALUES (64, 'bug', NULL);
INSERT INTO isolanguages VALUES (65, 'bul', 'bg');
INSERT INTO isolanguages VALUES (66, 'bur', 'my');
INSERT INTO isolanguages VALUES (67, 'byn', NULL);
INSERT INTO isolanguages VALUES (68, 'cad', NULL);
INSERT INTO isolanguages VALUES (69, 'cai', NULL);
INSERT INTO isolanguages VALUES (70, 'car', NULL);
INSERT INTO isolanguages VALUES (71, 'cat', 'ca');
INSERT INTO isolanguages VALUES (72, 'cau', NULL);
INSERT INTO isolanguages VALUES (73, 'ceb', NULL);
INSERT INTO isolanguages VALUES (74, 'cel', NULL);
INSERT INTO isolanguages VALUES (75, 'cha', 'ch');
INSERT INTO isolanguages VALUES (76, 'chb', NULL);
INSERT INTO isolanguages VALUES (77, 'che', 'ce');
INSERT INTO isolanguages VALUES (78, 'chg', NULL);
INSERT INTO isolanguages VALUES (79, 'chi', 'zh');
INSERT INTO isolanguages VALUES (80, 'chk', NULL);
INSERT INTO isolanguages VALUES (81, 'chm', NULL);
INSERT INTO isolanguages VALUES (82, 'chn', NULL);
INSERT INTO isolanguages VALUES (83, 'cho', NULL);
INSERT INTO isolanguages VALUES (84, 'chp', NULL);
INSERT INTO isolanguages VALUES (85, 'chr', NULL);
INSERT INTO isolanguages VALUES (86, 'chu', 'cu');
INSERT INTO isolanguages VALUES (87, 'chv', 'cv');
INSERT INTO isolanguages VALUES (88, 'chy', NULL);
INSERT INTO isolanguages VALUES (89, 'cmc', NULL);
INSERT INTO isolanguages VALUES (90, 'cop', NULL);
INSERT INTO isolanguages VALUES (91, 'cor', 'kw');
INSERT INTO isolanguages VALUES (92, 'cos', 'co');
INSERT INTO isolanguages VALUES (93, 'cpe', NULL);
INSERT INTO isolanguages VALUES (94, 'cpf', NULL);
INSERT INTO isolanguages VALUES (95, 'cpp', NULL);
INSERT INTO isolanguages VALUES (96, 'cre', 'cr');
INSERT INTO isolanguages VALUES (97, 'crh', NULL);
INSERT INTO isolanguages VALUES (98, 'crp', NULL);
INSERT INTO isolanguages VALUES (99, 'csb', NULL);
INSERT INTO isolanguages VALUES (100, 'cus', NULL);
INSERT INTO isolanguages VALUES (101, 'cze', 'cs');
INSERT INTO isolanguages VALUES (102, 'dak', NULL);
INSERT INTO isolanguages VALUES (103, 'dan', 'da');
INSERT INTO isolanguages VALUES (104, 'dar', NULL);
INSERT INTO isolanguages VALUES (105, 'day', NULL);
INSERT INTO isolanguages VALUES (106, 'del', NULL);
INSERT INTO isolanguages VALUES (107, 'den', NULL);
INSERT INTO isolanguages VALUES (108, 'dgr', NULL);
INSERT INTO isolanguages VALUES (109, 'din', NULL);
INSERT INTO isolanguages VALUES (110, 'div', 'dv');
INSERT INTO isolanguages VALUES (111, 'doi', NULL);
INSERT INTO isolanguages VALUES (112, 'dra', NULL);
INSERT INTO isolanguages VALUES (113, 'dsb', NULL);
INSERT INTO isolanguages VALUES (114, 'dua', NULL);
INSERT INTO isolanguages VALUES (115, 'dum', NULL);
INSERT INTO isolanguages VALUES (116, 'dut', 'nl');
INSERT INTO isolanguages VALUES (117, 'dyu', NULL);
INSERT INTO isolanguages VALUES (118, 'dzo', 'dz');
INSERT INTO isolanguages VALUES (119, 'efi', NULL);
INSERT INTO isolanguages VALUES (120, 'egy', NULL);
INSERT INTO isolanguages VALUES (121, 'eka', NULL);
INSERT INTO isolanguages VALUES (122, 'elx', NULL);
INSERT INTO isolanguages VALUES (123, 'eng', 'en');
INSERT INTO isolanguages VALUES (124, 'enm', NULL);
INSERT INTO isolanguages VALUES (125, 'epo', 'eo');
INSERT INTO isolanguages VALUES (126, 'est', 'et');
INSERT INTO isolanguages VALUES (127, 'ewe', 'ee');
INSERT INTO isolanguages VALUES (128, 'ewo', NULL);
INSERT INTO isolanguages VALUES (129, 'fan', NULL);
INSERT INTO isolanguages VALUES (130, 'fao', 'fo');
INSERT INTO isolanguages VALUES (131, 'fat', NULL);
INSERT INTO isolanguages VALUES (132, 'fij', 'fj');
INSERT INTO isolanguages VALUES (133, 'fil', NULL);
INSERT INTO isolanguages VALUES (134, 'fin', 'fi');
INSERT INTO isolanguages VALUES (135, 'fiu', NULL);
INSERT INTO isolanguages VALUES (136, 'fon', NULL);
INSERT INTO isolanguages VALUES (137, 'fre', 'fr');
INSERT INTO isolanguages VALUES (138, 'frm', NULL);
INSERT INTO isolanguages VALUES (139, 'fro', NULL);
INSERT INTO isolanguages VALUES (140, 'frr', NULL);
INSERT INTO isolanguages VALUES (141, 'frs', NULL);
INSERT INTO isolanguages VALUES (142, 'fry', 'fy');
INSERT INTO isolanguages VALUES (143, 'ful', 'ff');
INSERT INTO isolanguages VALUES (144, 'fur', NULL);
INSERT INTO isolanguages VALUES (145, 'gaa', NULL);
INSERT INTO isolanguages VALUES (146, 'gay', NULL);
INSERT INTO isolanguages VALUES (147, 'gba', NULL);
INSERT INTO isolanguages VALUES (148, 'gem', NULL);
INSERT INTO isolanguages VALUES (149, 'geo', 'ka');
INSERT INTO isolanguages VALUES (150, 'ger', 'de');
INSERT INTO isolanguages VALUES (151, 'gez', NULL);
INSERT INTO isolanguages VALUES (152, 'gil', NULL);
INSERT INTO isolanguages VALUES (153, 'gla', 'gd');
INSERT INTO isolanguages VALUES (154, 'gle', 'ga');
INSERT INTO isolanguages VALUES (155, 'glg', 'gl');
INSERT INTO isolanguages VALUES (156, 'glv', 'gv');
INSERT INTO isolanguages VALUES (157, 'gmh', NULL);
INSERT INTO isolanguages VALUES (158, 'goh', NULL);
INSERT INTO isolanguages VALUES (159, 'gon', NULL);
INSERT INTO isolanguages VALUES (160, 'gor', NULL);
INSERT INTO isolanguages VALUES (161, 'got', NULL);
INSERT INTO isolanguages VALUES (162, 'grb', NULL);
INSERT INTO isolanguages VALUES (163, 'grc', NULL);
INSERT INTO isolanguages VALUES (164, 'gre', 'el');
INSERT INTO isolanguages VALUES (165, 'grn', 'gn');
INSERT INTO isolanguages VALUES (166, 'gsw', NULL);
INSERT INTO isolanguages VALUES (167, 'guj', 'gu');
INSERT INTO isolanguages VALUES (168, 'gwi', NULL);
INSERT INTO isolanguages VALUES (169, 'hai', NULL);
INSERT INTO isolanguages VALUES (170, 'hat', 'ht');
INSERT INTO isolanguages VALUES (171, 'hau', 'ha');
INSERT INTO isolanguages VALUES (172, 'haw', NULL);
INSERT INTO isolanguages VALUES (173, 'heb', 'he');
INSERT INTO isolanguages VALUES (174, 'her', 'hz');
INSERT INTO isolanguages VALUES (175, 'hil', NULL);
INSERT INTO isolanguages VALUES (176, 'him', NULL);
INSERT INTO isolanguages VALUES (177, 'hin', 'hi');
INSERT INTO isolanguages VALUES (178, 'hit', NULL);
INSERT INTO isolanguages VALUES (179, 'hmn', NULL);
INSERT INTO isolanguages VALUES (180, 'hmo', 'ho');
INSERT INTO isolanguages VALUES (181, 'hsb', NULL);
INSERT INTO isolanguages VALUES (182, 'hun', 'hu');
INSERT INTO isolanguages VALUES (183, 'hup', NULL);
INSERT INTO isolanguages VALUES (184, 'iba', NULL);
INSERT INTO isolanguages VALUES (185, 'ibo', 'ig');
INSERT INTO isolanguages VALUES (186, 'ice', 'is');
INSERT INTO isolanguages VALUES (187, 'ido', 'io');
INSERT INTO isolanguages VALUES (188, 'iii', 'ii');
INSERT INTO isolanguages VALUES (189, 'ijo', NULL);
INSERT INTO isolanguages VALUES (190, 'iku', 'iu');
INSERT INTO isolanguages VALUES (191, 'ile', 'ie');
INSERT INTO isolanguages VALUES (192, 'ilo', NULL);
INSERT INTO isolanguages VALUES (193, 'ina', 'ia');
INSERT INTO isolanguages VALUES (194, 'inc', NULL);
INSERT INTO isolanguages VALUES (195, 'ind', 'id');
INSERT INTO isolanguages VALUES (196, 'ine', NULL);
INSERT INTO isolanguages VALUES (197, 'inh', NULL);
INSERT INTO isolanguages VALUES (198, 'ipk', 'ik');
INSERT INTO isolanguages VALUES (199, 'ira', NULL);
INSERT INTO isolanguages VALUES (200, 'iro', NULL);
INSERT INTO isolanguages VALUES (201, 'ita', 'it');
INSERT INTO isolanguages VALUES (202, 'jav', 'jv');
INSERT INTO isolanguages VALUES (203, 'jbo', NULL);
INSERT INTO isolanguages VALUES (204, 'jpn', 'ja');
INSERT INTO isolanguages VALUES (205, 'jpr', NULL);
INSERT INTO isolanguages VALUES (206, 'jrb', NULL);
INSERT INTO isolanguages VALUES (207, 'kaa', NULL);
INSERT INTO isolanguages VALUES (208, 'kab', NULL);
INSERT INTO isolanguages VALUES (209, 'kac', NULL);
INSERT INTO isolanguages VALUES (210, 'kal', 'kl');
INSERT INTO isolanguages VALUES (211, 'kam', NULL);
INSERT INTO isolanguages VALUES (212, 'kan', 'kn');
INSERT INTO isolanguages VALUES (213, 'kar', NULL);
INSERT INTO isolanguages VALUES (214, 'kas', 'ks');
INSERT INTO isolanguages VALUES (215, 'kau', 'kr');
INSERT INTO isolanguages VALUES (216, 'kaw', NULL);
INSERT INTO isolanguages VALUES (217, 'kaz', 'kk');
INSERT INTO isolanguages VALUES (218, 'kbd', NULL);
INSERT INTO isolanguages VALUES (219, 'kha', NULL);
INSERT INTO isolanguages VALUES (220, 'khi', NULL);
INSERT INTO isolanguages VALUES (221, 'khm', 'km');
INSERT INTO isolanguages VALUES (222, 'kho', NULL);
INSERT INTO isolanguages VALUES (223, 'kik', 'ki');
INSERT INTO isolanguages VALUES (224, 'kin', 'rw');
INSERT INTO isolanguages VALUES (225, 'kir', 'ky');
INSERT INTO isolanguages VALUES (226, 'kmb', NULL);
INSERT INTO isolanguages VALUES (227, 'kok', NULL);
INSERT INTO isolanguages VALUES (228, 'kom', 'kv');
INSERT INTO isolanguages VALUES (229, 'kon', 'kg');
INSERT INTO isolanguages VALUES (230, 'kor', 'ko');
INSERT INTO isolanguages VALUES (231, 'kos', NULL);
INSERT INTO isolanguages VALUES (232, 'kpe', NULL);
INSERT INTO isolanguages VALUES (233, 'krc', NULL);
INSERT INTO isolanguages VALUES (234, 'krl', NULL);
INSERT INTO isolanguages VALUES (235, 'kro', NULL);
INSERT INTO isolanguages VALUES (236, 'kru', NULL);
INSERT INTO isolanguages VALUES (237, 'kua', 'kj');
INSERT INTO isolanguages VALUES (238, 'kum', NULL);
INSERT INTO isolanguages VALUES (239, 'kur', 'ku');
INSERT INTO isolanguages VALUES (240, 'kut', NULL);
INSERT INTO isolanguages VALUES (241, 'lad', NULL);
INSERT INTO isolanguages VALUES (242, 'lah', NULL);
INSERT INTO isolanguages VALUES (243, 'lam', NULL);
INSERT INTO isolanguages VALUES (244, 'lao', 'lo');
INSERT INTO isolanguages VALUES (245, 'lat', 'la');
INSERT INTO isolanguages VALUES (246, 'lav', 'lv');
INSERT INTO isolanguages VALUES (247, 'lez', NULL);
INSERT INTO isolanguages VALUES (248, 'lim', 'li');
INSERT INTO isolanguages VALUES (249, 'lin', 'ln');
INSERT INTO isolanguages VALUES (250, 'lit', 'lt');
INSERT INTO isolanguages VALUES (251, 'lol', NULL);
INSERT INTO isolanguages VALUES (252, 'loz', NULL);
INSERT INTO isolanguages VALUES (253, 'ltz', 'lb');
INSERT INTO isolanguages VALUES (254, 'lua', NULL);
INSERT INTO isolanguages VALUES (255, 'lub', 'lu');
INSERT INTO isolanguages VALUES (256, 'lug', 'lg');
INSERT INTO isolanguages VALUES (257, 'lui', NULL);
INSERT INTO isolanguages VALUES (258, 'lun', NULL);
INSERT INTO isolanguages VALUES (259, 'luo', NULL);
INSERT INTO isolanguages VALUES (260, 'lus', NULL);
INSERT INTO isolanguages VALUES (261, 'mac', 'mk');
INSERT INTO isolanguages VALUES (262, 'mad', NULL);
INSERT INTO isolanguages VALUES (263, 'mag', NULL);
INSERT INTO isolanguages VALUES (264, 'mah', 'mh');
INSERT INTO isolanguages VALUES (265, 'mai', NULL);
INSERT INTO isolanguages VALUES (266, 'mak', NULL);
INSERT INTO isolanguages VALUES (267, 'mal', 'ml');
INSERT INTO isolanguages VALUES (268, 'man', NULL);
INSERT INTO isolanguages VALUES (269, 'mao', 'mi');
INSERT INTO isolanguages VALUES (270, 'map', NULL);
INSERT INTO isolanguages VALUES (271, 'mar', 'mr');
INSERT INTO isolanguages VALUES (272, 'mas', NULL);
INSERT INTO isolanguages VALUES (273, 'may', 'ms');
INSERT INTO isolanguages VALUES (274, 'mdf', NULL);
INSERT INTO isolanguages VALUES (275, 'mdr', NULL);
INSERT INTO isolanguages VALUES (276, 'men', NULL);
INSERT INTO isolanguages VALUES (277, 'mga', NULL);
INSERT INTO isolanguages VALUES (278, 'mic', NULL);
INSERT INTO isolanguages VALUES (279, 'min', NULL);
INSERT INTO isolanguages VALUES (280, 'mis', NULL);
INSERT INTO isolanguages VALUES (281, 'mkh', NULL);
INSERT INTO isolanguages VALUES (282, 'mlg', 'mg');
INSERT INTO isolanguages VALUES (283, 'mlt', 'mt');
INSERT INTO isolanguages VALUES (284, 'mnc', NULL);
INSERT INTO isolanguages VALUES (285, 'mni', NULL);
INSERT INTO isolanguages VALUES (286, 'mno', NULL);
INSERT INTO isolanguages VALUES (287, 'moh', NULL);
INSERT INTO isolanguages VALUES (288, 'mol', 'ml');
INSERT INTO isolanguages VALUES (289, 'mon', 'mn');
INSERT INTO isolanguages VALUES (290, 'mos', NULL);
INSERT INTO isolanguages VALUES (291, 'mul', NULL);
INSERT INTO isolanguages VALUES (292, 'mun', NULL);
INSERT INTO isolanguages VALUES (293, 'mus', NULL);
INSERT INTO isolanguages VALUES (294, 'mwl', NULL);
INSERT INTO isolanguages VALUES (295, 'mwr', NULL);
INSERT INTO isolanguages VALUES (296, 'myn', NULL);
INSERT INTO isolanguages VALUES (297, 'myv', NULL);
INSERT INTO isolanguages VALUES (298, 'nah', NULL);
INSERT INTO isolanguages VALUES (299, 'nai', NULL);
INSERT INTO isolanguages VALUES (300, 'nap', NULL);
INSERT INTO isolanguages VALUES (301, 'nau', 'na');
INSERT INTO isolanguages VALUES (302, 'nav', 'nv');
INSERT INTO isolanguages VALUES (303, 'nbl', 'nr');
INSERT INTO isolanguages VALUES (304, 'nde', 'nd');
INSERT INTO isolanguages VALUES (305, 'ndo', 'ng');
INSERT INTO isolanguages VALUES (306, 'nds', NULL);
INSERT INTO isolanguages VALUES (307, 'nep', 'ne');
INSERT INTO isolanguages VALUES (308, 'new', NULL);
INSERT INTO isolanguages VALUES (309, 'nia', NULL);
INSERT INTO isolanguages VALUES (310, 'nic', NULL);
INSERT INTO isolanguages VALUES (311, 'niu', NULL);
INSERT INTO isolanguages VALUES (312, 'nno', 'nn');
INSERT INTO isolanguages VALUES (313, 'nob', 'nb');
INSERT INTO isolanguages VALUES (314, 'nog', NULL);
INSERT INTO isolanguages VALUES (315, 'non', NULL);
INSERT INTO isolanguages VALUES (316, 'nor', 'no');
INSERT INTO isolanguages VALUES (317, 'nso', NULL);
INSERT INTO isolanguages VALUES (318, 'nub', NULL);
INSERT INTO isolanguages VALUES (319, 'nwc', NULL);
INSERT INTO isolanguages VALUES (320, 'nya', 'ny');
INSERT INTO isolanguages VALUES (321, 'nym', NULL);
INSERT INTO isolanguages VALUES (322, 'nyn', NULL);
INSERT INTO isolanguages VALUES (323, 'nyo', NULL);
INSERT INTO isolanguages VALUES (324, 'nzi', NULL);
INSERT INTO isolanguages VALUES (325, 'oci', 'oc');
INSERT INTO isolanguages VALUES (326, 'oji', 'oj');
INSERT INTO isolanguages VALUES (327, 'ori', 'or');
INSERT INTO isolanguages VALUES (328, 'orm', 'om');
INSERT INTO isolanguages VALUES (329, 'osa', NULL);
INSERT INTO isolanguages VALUES (330, 'oss', 'os');
INSERT INTO isolanguages VALUES (331, 'ota', NULL);
INSERT INTO isolanguages VALUES (332, 'oto', NULL);
INSERT INTO isolanguages VALUES (333, 'paa', NULL);
INSERT INTO isolanguages VALUES (334, 'pag', NULL);
INSERT INTO isolanguages VALUES (335, 'pal', NULL);
INSERT INTO isolanguages VALUES (336, 'pam', NULL);
INSERT INTO isolanguages VALUES (337, 'pan', 'pa');
INSERT INTO isolanguages VALUES (338, 'pap', NULL);
INSERT INTO isolanguages VALUES (339, 'pau', NULL);
INSERT INTO isolanguages VALUES (340, 'peo', NULL);
INSERT INTO isolanguages VALUES (341, 'per', 'fa');
INSERT INTO isolanguages VALUES (342, 'phi', NULL);
INSERT INTO isolanguages VALUES (343, 'phn', NULL);
INSERT INTO isolanguages VALUES (344, 'pli', 'pi');
INSERT INTO isolanguages VALUES (345, 'pol', 'pl');
INSERT INTO isolanguages VALUES (346, 'pon', NULL);
INSERT INTO isolanguages VALUES (347, 'por', 'pt');
INSERT INTO isolanguages VALUES (348, 'pra', NULL);
INSERT INTO isolanguages VALUES (349, 'pro', NULL);
INSERT INTO isolanguages VALUES (350, 'pus', 'ps');
INSERT INTO isolanguages VALUES (351, 'qaa', NULL);
INSERT INTO isolanguages VALUES (352, 'que', 'qu');
INSERT INTO isolanguages VALUES (353, 'raj', NULL);
INSERT INTO isolanguages VALUES (354, 'rap', NULL);
INSERT INTO isolanguages VALUES (355, 'rar', NULL);
INSERT INTO isolanguages VALUES (356, 'roa', NULL);
INSERT INTO isolanguages VALUES (357, 'roh', 'rm');
INSERT INTO isolanguages VALUES (358, 'rom', NULL);
INSERT INTO isolanguages VALUES (359, 'rum', 'ro');
INSERT INTO isolanguages VALUES (360, 'run', 'rn');
INSERT INTO isolanguages VALUES (361, 'rup', NULL);
INSERT INTO isolanguages VALUES (362, 'rus', 'ru');
INSERT INTO isolanguages VALUES (363, 'sad', NULL);
INSERT INTO isolanguages VALUES (364, 'sag', 'sg');
INSERT INTO isolanguages VALUES (365, 'sah', NULL);
INSERT INTO isolanguages VALUES (366, 'sai', NULL);
INSERT INTO isolanguages VALUES (367, 'sal', NULL);
INSERT INTO isolanguages VALUES (368, 'sam', NULL);
INSERT INTO isolanguages VALUES (369, 'san', 'sa');
INSERT INTO isolanguages VALUES (370, 'sas', NULL);
INSERT INTO isolanguages VALUES (371, 'sat', NULL);
INSERT INTO isolanguages VALUES (372, 'srp', 'sr');
INSERT INTO isolanguages VALUES (373, 'scn', NULL);
INSERT INTO isolanguages VALUES (374, 'sco', NULL);
INSERT INTO isolanguages VALUES (375, 'hrv', 'hr');
INSERT INTO isolanguages VALUES (376, 'sel', NULL);
INSERT INTO isolanguages VALUES (377, 'sem', NULL);
INSERT INTO isolanguages VALUES (378, 'sga', NULL);
INSERT INTO isolanguages VALUES (379, 'sgn', NULL);
INSERT INTO isolanguages VALUES (380, 'shn', NULL);
INSERT INTO isolanguages VALUES (381, 'sid', NULL);
INSERT INTO isolanguages VALUES (382, 'sin', 'si');
INSERT INTO isolanguages VALUES (383, 'sio', NULL);
INSERT INTO isolanguages VALUES (384, 'sit', NULL);
INSERT INTO isolanguages VALUES (385, 'sla', NULL);
INSERT INTO isolanguages VALUES (386, 'slo', 'sk');
INSERT INTO isolanguages VALUES (387, 'slv', 'sl');
INSERT INTO isolanguages VALUES (388, 'sma', NULL);
INSERT INTO isolanguages VALUES (389, 'sme', 'se');
INSERT INTO isolanguages VALUES (390, 'smi', NULL);
INSERT INTO isolanguages VALUES (391, 'smj', NULL);
INSERT INTO isolanguages VALUES (392, 'smn', NULL);
INSERT INTO isolanguages VALUES (393, 'smo', 'sm');
INSERT INTO isolanguages VALUES (394, 'sms', NULL);
INSERT INTO isolanguages VALUES (395, 'sna', 'sn');
INSERT INTO isolanguages VALUES (396, 'snd', 'sd');
INSERT INTO isolanguages VALUES (397, 'snk', NULL);
INSERT INTO isolanguages VALUES (398, 'sog', NULL);
INSERT INTO isolanguages VALUES (399, 'som', 'so');
INSERT INTO isolanguages VALUES (400, 'son', NULL);
INSERT INTO isolanguages VALUES (401, 'sot', 'st');
INSERT INTO isolanguages VALUES (402, 'spa', 'es');
INSERT INTO isolanguages VALUES (403, 'srd', 'sc');
INSERT INTO isolanguages VALUES (404, 'srn', NULL);
INSERT INTO isolanguages VALUES (405, 'srr', NULL);
INSERT INTO isolanguages VALUES (406, 'ssa', NULL);
INSERT INTO isolanguages VALUES (407, 'ssw', 'ss');
INSERT INTO isolanguages VALUES (408, 'suk', NULL);
INSERT INTO isolanguages VALUES (409, 'sun', 'su');
INSERT INTO isolanguages VALUES (410, 'sus', NULL);
INSERT INTO isolanguages VALUES (411, 'sux', NULL);
INSERT INTO isolanguages VALUES (412, 'swa', 'sw');
INSERT INTO isolanguages VALUES (413, 'swe', 'sv');
INSERT INTO isolanguages VALUES (414, 'syr', NULL);
INSERT INTO isolanguages VALUES (415, 'tah', 'ty');
INSERT INTO isolanguages VALUES (416, 'tai', NULL);
INSERT INTO isolanguages VALUES (417, 'tam', 'ta');
INSERT INTO isolanguages VALUES (418, 'tat', 'tt');
INSERT INTO isolanguages VALUES (419, 'tel', 'te');
INSERT INTO isolanguages VALUES (420, 'tem', NULL);
INSERT INTO isolanguages VALUES (421, 'ter', NULL);
INSERT INTO isolanguages VALUES (422, 'tet', NULL);
INSERT INTO isolanguages VALUES (423, 'tgk', 'tg');
INSERT INTO isolanguages VALUES (424, 'tgl', 'tl');
INSERT INTO isolanguages VALUES (425, 'tha', 'th');
INSERT INTO isolanguages VALUES (426, 'tib', 'bo');
INSERT INTO isolanguages VALUES (427, 'tig', NULL);
INSERT INTO isolanguages VALUES (428, 'tir', 'ti');
INSERT INTO isolanguages VALUES (429, 'tiv', NULL);
INSERT INTO isolanguages VALUES (430, 'tkl', NULL);
INSERT INTO isolanguages VALUES (431, 'tlh', NULL);
INSERT INTO isolanguages VALUES (432, 'tli', NULL);
INSERT INTO isolanguages VALUES (433, 'tmh', NULL);
INSERT INTO isolanguages VALUES (434, 'tog', NULL);
INSERT INTO isolanguages VALUES (435, 'ton', 'to');
INSERT INTO isolanguages VALUES (436, 'tpi', NULL);
INSERT INTO isolanguages VALUES (437, 'tsi', NULL);
INSERT INTO isolanguages VALUES (438, 'tsn', 'tn');
INSERT INTO isolanguages VALUES (439, 'tso', 'ts');
INSERT INTO isolanguages VALUES (440, 'tuk', 'tk');
INSERT INTO isolanguages VALUES (441, 'tum', NULL);
INSERT INTO isolanguages VALUES (442, 'tup', NULL);
INSERT INTO isolanguages VALUES (443, 'tur', 'tr');
INSERT INTO isolanguages VALUES (444, 'tut', NULL);
INSERT INTO isolanguages VALUES (445, 'tvl', NULL);
INSERT INTO isolanguages VALUES (446, 'twi', 'tw');
INSERT INTO isolanguages VALUES (447, 'tyv', NULL);
INSERT INTO isolanguages VALUES (448, 'udm', NULL);
INSERT INTO isolanguages VALUES (449, 'uga', NULL);
INSERT INTO isolanguages VALUES (450, 'uig', 'ug');
INSERT INTO isolanguages VALUES (451, 'ukr', 'uk');
INSERT INTO isolanguages VALUES (452, 'umb', NULL);
INSERT INTO isolanguages VALUES (453, 'und', NULL);
INSERT INTO isolanguages VALUES (454, 'urd', 'ur');
INSERT INTO isolanguages VALUES (455, 'uzb', 'uz');
INSERT INTO isolanguages VALUES (456, 'vai', NULL);
INSERT INTO isolanguages VALUES (457, 'ven', 've');
INSERT INTO isolanguages VALUES (458, 'vie', 'vi');
INSERT INTO isolanguages VALUES (459, 'vol', 'vo');
INSERT INTO isolanguages VALUES (460, 'vot', NULL);
INSERT INTO isolanguages VALUES (461, 'wak', NULL);
INSERT INTO isolanguages VALUES (462, 'wal', NULL);
INSERT INTO isolanguages VALUES (463, 'war', NULL);
INSERT INTO isolanguages VALUES (464, 'was', NULL);
INSERT INTO isolanguages VALUES (465, 'wel', 'cy');
INSERT INTO isolanguages VALUES (466, 'wen', NULL);
INSERT INTO isolanguages VALUES (467, 'wln', 'wa');
INSERT INTO isolanguages VALUES (468, 'wol', 'wo');
INSERT INTO isolanguages VALUES (469, 'xal', NULL);
INSERT INTO isolanguages VALUES (470, 'xho', 'xh');
INSERT INTO isolanguages VALUES (471, 'yao', NULL);
INSERT INTO isolanguages VALUES (472, 'yap', NULL);
INSERT INTO isolanguages VALUES (473, 'yid', 'yi');
INSERT INTO isolanguages VALUES (474, 'yor', 'yo');
INSERT INTO isolanguages VALUES (475, 'ypk', NULL);
INSERT INTO isolanguages VALUES (476, 'zap', NULL);
INSERT INTO isolanguages VALUES (477, 'zen', NULL);
INSERT INTO isolanguages VALUES (478, 'zha', 'za');
INSERT INTO isolanguages VALUES (479, 'znd', NULL);
INSERT INTO isolanguages VALUES (480, 'zul', 'zu');
INSERT INTO isolanguages VALUES (481, 'zun', NULL);
INSERT INTO isolanguages VALUES (482, 'zxx', NULL);
INSERT INTO isolanguages VALUES (483, 'nqo', NULL);
INSERT INTO isolanguages VALUES (484, 'zza', NULL);


--
-- TOC entry 4082 (class 0 OID 27559332)
-- Dependencies: 353
-- Data for Name: isolanguagesdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO isolanguagesdes VALUES (1, 'Afar', 'eng');
INSERT INTO isolanguagesdes VALUES (2, 'Abkhazian', 'eng');
INSERT INTO isolanguagesdes VALUES (3, 'Achinese', 'eng');
INSERT INTO isolanguagesdes VALUES (4, 'Acoli', 'eng');
INSERT INTO isolanguagesdes VALUES (5, 'Adangme', 'eng');
INSERT INTO isolanguagesdes VALUES (6, 'Adyghe; Adygei', 'eng');
INSERT INTO isolanguagesdes VALUES (7, 'Afro-Asiatic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (8, 'Afrihili', 'eng');
INSERT INTO isolanguagesdes VALUES (9, 'Afrikaans', 'eng');
INSERT INTO isolanguagesdes VALUES (10, 'Ainu', 'eng');
INSERT INTO isolanguagesdes VALUES (11, 'Akan', 'eng');
INSERT INTO isolanguagesdes VALUES (12, 'Akkadian', 'eng');
INSERT INTO isolanguagesdes VALUES (13, 'Albanian', 'eng');
INSERT INTO isolanguagesdes VALUES (14, 'Aleut', 'eng');
INSERT INTO isolanguagesdes VALUES (15, 'Algonquian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (16, 'Southern Altai', 'eng');
INSERT INTO isolanguagesdes VALUES (17, 'Amharic', 'eng');
INSERT INTO isolanguagesdes VALUES (18, 'English, Old (ca.450-1100)', 'eng');
INSERT INTO isolanguagesdes VALUES (19, 'Angika', 'eng');
INSERT INTO isolanguagesdes VALUES (20, 'Apache languages', 'eng');
INSERT INTO isolanguagesdes VALUES (21, 'Arabic', 'eng');
INSERT INTO isolanguagesdes VALUES (22, 'Aramaic', 'eng');
INSERT INTO isolanguagesdes VALUES (23, 'Aragonese', 'eng');
INSERT INTO isolanguagesdes VALUES (24, 'Armenian', 'eng');
INSERT INTO isolanguagesdes VALUES (25, 'Mapudungun; Mapuche', 'eng');
INSERT INTO isolanguagesdes VALUES (26, 'Arapaho', 'eng');
INSERT INTO isolanguagesdes VALUES (27, 'Artificial (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (28, 'Arawak', 'eng');
INSERT INTO isolanguagesdes VALUES (29, 'Assamese', 'eng');
INSERT INTO isolanguagesdes VALUES (30, 'Asturian; Bable', 'eng');
INSERT INTO isolanguagesdes VALUES (31, 'Athapascan languages', 'eng');
INSERT INTO isolanguagesdes VALUES (32, 'Australian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (33, 'Avaric', 'eng');
INSERT INTO isolanguagesdes VALUES (34, 'Avestan', 'eng');
INSERT INTO isolanguagesdes VALUES (35, 'Awadhi', 'eng');
INSERT INTO isolanguagesdes VALUES (36, 'Aymara', 'eng');
INSERT INTO isolanguagesdes VALUES (37, 'Azerbaijani', 'eng');
INSERT INTO isolanguagesdes VALUES (38, 'Banda languages', 'eng');
INSERT INTO isolanguagesdes VALUES (39, 'Bamileke languages', 'eng');
INSERT INTO isolanguagesdes VALUES (40, 'Bashkir', 'eng');
INSERT INTO isolanguagesdes VALUES (41, 'Baluchi', 'eng');
INSERT INTO isolanguagesdes VALUES (42, 'Bambara', 'eng');
INSERT INTO isolanguagesdes VALUES (43, 'Balinese', 'eng');
INSERT INTO isolanguagesdes VALUES (44, 'Basque', 'eng');
INSERT INTO isolanguagesdes VALUES (45, 'Basa', 'eng');
INSERT INTO isolanguagesdes VALUES (46, 'Baltic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (47, 'Beja', 'eng');
INSERT INTO isolanguagesdes VALUES (48, 'Belarusian', 'eng');
INSERT INTO isolanguagesdes VALUES (49, 'Bemba', 'eng');
INSERT INTO isolanguagesdes VALUES (50, 'Bengali', 'eng');
INSERT INTO isolanguagesdes VALUES (51, 'Berber (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (52, 'Bhojpuri', 'eng');
INSERT INTO isolanguagesdes VALUES (53, 'Bihari', 'eng');
INSERT INTO isolanguagesdes VALUES (54, 'Bikol', 'eng');
INSERT INTO isolanguagesdes VALUES (55, 'Bini; Edo', 'eng');
INSERT INTO isolanguagesdes VALUES (56, 'Bislama', 'eng');
INSERT INTO isolanguagesdes VALUES (57, 'Siksika', 'eng');
INSERT INTO isolanguagesdes VALUES (58, 'Bantu (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (59, 'Bosnian', 'eng');
INSERT INTO isolanguagesdes VALUES (60, 'Braj', 'eng');
INSERT INTO isolanguagesdes VALUES (61, 'Breton', 'eng');
INSERT INTO isolanguagesdes VALUES (62, 'Batak languages', 'eng');
INSERT INTO isolanguagesdes VALUES (63, 'Buriat', 'eng');
INSERT INTO isolanguagesdes VALUES (64, 'Buginese', 'eng');
INSERT INTO isolanguagesdes VALUES (65, 'Bulgarian', 'eng');
INSERT INTO isolanguagesdes VALUES (66, 'Burmese', 'eng');
INSERT INTO isolanguagesdes VALUES (67, 'Blin; Bilin', 'eng');
INSERT INTO isolanguagesdes VALUES (68, 'Caddo', 'eng');
INSERT INTO isolanguagesdes VALUES (69, 'Central American Indian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (70, 'Galibi Carib', 'eng');
INSERT INTO isolanguagesdes VALUES (71, 'Catalan; Valencian', 'eng');
INSERT INTO isolanguagesdes VALUES (72, 'Caucasian (Other)on liturgique; vieux bulgare', 'eng');
INSERT INTO isolanguagesdes VALUES (73, 'Cebuano', 'eng');
INSERT INTO isolanguagesdes VALUES (74, 'Celtic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (75, 'Chamorro', 'eng');
INSERT INTO isolanguagesdes VALUES (76, 'Chibcha', 'eng');
INSERT INTO isolanguagesdes VALUES (77, 'Chechen', 'eng');
INSERT INTO isolanguagesdes VALUES (78, 'Chagataier)', 'eng');
INSERT INTO isolanguagesdes VALUES (79, 'Chinese(Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (80, 'Chuukese', 'eng');
INSERT INTO isolanguagesdes VALUES (81, 'Mari', 'eng');
INSERT INTO isolanguagesdes VALUES (82, 'Chinook jargon', 'eng');
INSERT INTO isolanguagesdes VALUES (83, 'Choctaw', 'eng');
INSERT INTO isolanguagesdes VALUES (84, 'Chipewyan', 'eng');
INSERT INTO isolanguagesdes VALUES (85, 'Cherokee', 'eng');
INSERT INTO isolanguagesdes VALUES (86, 'Church Slavic; Old Slavonic; Church Sl', 'eng');
INSERT INTO isolanguagesdes VALUES (87, 'Chuvash', 'eng');
INSERT INTO isolanguagesdes VALUES (88, 'Cheyenne', 'eng');
INSERT INTO isolanguagesdes VALUES (89, 'Chamic languages', 'eng');
INSERT INTO isolanguagesdes VALUES (90, 'Coptic', 'eng');
INSERT INTO isolanguagesdes VALUES (91, 'Cornish', 'eng');
INSERT INTO isolanguagesdes VALUES (92, 'Corsican', 'eng');
INSERT INTO isolanguagesdes VALUES (93, 'Creoles and pidgins, English based (Ot', 'eng');
INSERT INTO isolanguagesdes VALUES (94, 'Creoles and pidgins, French-based (Oth', 'eng');
INSERT INTO isolanguagesdes VALUES (95, 'Creoles and pidgins, Portuguese-based ', 'eng');
INSERT INTO isolanguagesdes VALUES (96, 'Cree', 'eng');
INSERT INTO isolanguagesdes VALUES (97, 'Crimean Tatar; Crimean Turkish', 'eng');
INSERT INTO isolanguagesdes VALUES (98, 'Creoles and pidgins (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (99, 'Kashubian', 'eng');
INSERT INTO isolanguagesdes VALUES (100, 'Cushitic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (101, 'Czech', 'eng');
INSERT INTO isolanguagesdes VALUES (102, 'Dakota', 'eng');
INSERT INTO isolanguagesdes VALUES (103, 'Danish', 'eng');
INSERT INTO isolanguagesdes VALUES (104, 'Dargwa', 'eng');
INSERT INTO isolanguagesdes VALUES (105, 'Land Dayak languages', 'eng');
INSERT INTO isolanguagesdes VALUES (106, 'Delaware', 'eng');
INSERT INTO isolanguagesdes VALUES (107, 'Slave (Athapascan)', 'eng');
INSERT INTO isolanguagesdes VALUES (108, 'Dogrib', 'eng');
INSERT INTO isolanguagesdes VALUES (109, 'Dinka', 'eng');
INSERT INTO isolanguagesdes VALUES (110, 'Divehi; Dhivehi; Maldivian', 'eng');
INSERT INTO isolanguagesdes VALUES (111, 'Dogri', 'eng');
INSERT INTO isolanguagesdes VALUES (112, 'Dravidian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (113, 'Lower Sorbian', 'eng');
INSERT INTO isolanguagesdes VALUES (114, 'Duala', 'eng');
INSERT INTO isolanguagesdes VALUES (115, 'Dutch, Middle (ca.1050-1350)', 'eng');
INSERT INTO isolanguagesdes VALUES (116, 'Dutch; Flemish', 'eng');
INSERT INTO isolanguagesdes VALUES (117, 'Dyula', 'eng');
INSERT INTO isolanguagesdes VALUES (118, 'Dzongkha', 'eng');
INSERT INTO isolanguagesdes VALUES (119, 'Efik', 'eng');
INSERT INTO isolanguagesdes VALUES (120, 'Egyptian (Ancient)', 'eng');
INSERT INTO isolanguagesdes VALUES (121, 'Ekajuk', 'eng');
INSERT INTO isolanguagesdes VALUES (122, 'Elamite', 'eng');
INSERT INTO isolanguagesdes VALUES (123, 'English', 'eng');
INSERT INTO isolanguagesdes VALUES (124, 'English, Middle (1100-1500)', 'eng');
INSERT INTO isolanguagesdes VALUES (125, 'Esperanto', 'eng');
INSERT INTO isolanguagesdes VALUES (126, 'Estonian', 'eng');
INSERT INTO isolanguagesdes VALUES (127, 'Ewe', 'eng');
INSERT INTO isolanguagesdes VALUES (128, 'Ewondo', 'eng');
INSERT INTO isolanguagesdes VALUES (129, 'Fang', 'eng');
INSERT INTO isolanguagesdes VALUES (130, 'Faroese', 'eng');
INSERT INTO isolanguagesdes VALUES (131, 'Fanti', 'eng');
INSERT INTO isolanguagesdes VALUES (132, 'Fijian', 'eng');
INSERT INTO isolanguagesdes VALUES (133, 'Filipino; Pilipino', 'eng');
INSERT INTO isolanguagesdes VALUES (134, 'Finnish', 'eng');
INSERT INTO isolanguagesdes VALUES (135, 'Finno-Ugrian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (136, 'Fon', 'eng');
INSERT INTO isolanguagesdes VALUES (137, 'French', 'eng');
INSERT INTO isolanguagesdes VALUES (138, 'French, Middle (ca.1400-1600)', 'eng');
INSERT INTO isolanguagesdes VALUES (139, 'French, Old (842-ca.1400)', 'eng');
INSERT INTO isolanguagesdes VALUES (140, 'Northern Frisian', 'eng');
INSERT INTO isolanguagesdes VALUES (141, 'Eastern Frisian', 'eng');
INSERT INTO isolanguagesdes VALUES (142, 'Western Frisian', 'eng');
INSERT INTO isolanguagesdes VALUES (143, 'Fulah', 'eng');
INSERT INTO isolanguagesdes VALUES (144, 'Friulian', 'eng');
INSERT INTO isolanguagesdes VALUES (145, 'Ga', 'eng');
INSERT INTO isolanguagesdes VALUES (146, 'Gayo', 'eng');
INSERT INTO isolanguagesdes VALUES (147, 'Gbaya', 'eng');
INSERT INTO isolanguagesdes VALUES (148, 'Germanic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (149, 'Georgian', 'eng');
INSERT INTO isolanguagesdes VALUES (150, 'German', 'eng');
INSERT INTO isolanguagesdes VALUES (151, 'Geez', 'eng');
INSERT INTO isolanguagesdes VALUES (152, 'Gilbertese', 'eng');
INSERT INTO isolanguagesdes VALUES (153, 'Gaelic; Scottish Gaelic', 'eng');
INSERT INTO isolanguagesdes VALUES (154, 'Irish', 'eng');
INSERT INTO isolanguagesdes VALUES (155, 'Galician', 'eng');
INSERT INTO isolanguagesdes VALUES (156, 'Manx', 'eng');
INSERT INTO isolanguagesdes VALUES (157, 'German, Middle High (ca.1050-1500)', 'eng');
INSERT INTO isolanguagesdes VALUES (158, 'German, Old High (ca.750-1050)', 'eng');
INSERT INTO isolanguagesdes VALUES (159, 'Gondi', 'eng');
INSERT INTO isolanguagesdes VALUES (160, 'Gorontalo', 'eng');
INSERT INTO isolanguagesdes VALUES (161, 'Gothicanguage Association)', 'eng');
INSERT INTO isolanguagesdes VALUES (162, 'Grebo', 'eng');
INSERT INTO isolanguagesdes VALUES (163, 'Greek, Ancient (to 1453)', 'eng');
INSERT INTO isolanguagesdes VALUES (164, 'Greek, Modern (1453-)', 'eng');
INSERT INTO isolanguagesdes VALUES (165, 'Guarani', 'eng');
INSERT INTO isolanguagesdes VALUES (166, 'Swiss German; Alemannic', 'eng');
INSERT INTO isolanguagesdes VALUES (167, 'Gujarati', 'eng');
INSERT INTO isolanguagesdes VALUES (168, 'Gwich''in', 'eng');
INSERT INTO isolanguagesdes VALUES (169, 'Haida', 'eng');
INSERT INTO isolanguagesdes VALUES (170, 'Haitian; Haitian Creole', 'eng');
INSERT INTO isolanguagesdes VALUES (171, 'Hausa', 'eng');
INSERT INTO isolanguagesdes VALUES (172, 'Hawaiian', 'eng');
INSERT INTO isolanguagesdes VALUES (173, 'Hebrew', 'eng');
INSERT INTO isolanguagesdes VALUES (174, 'Herero', 'eng');
INSERT INTO isolanguagesdes VALUES (175, 'Hiligaynon', 'eng');
INSERT INTO isolanguagesdes VALUES (176, 'Himachali', 'eng');
INSERT INTO isolanguagesdes VALUES (177, 'Hindi', 'eng');
INSERT INTO isolanguagesdes VALUES (178, 'Hittite', 'eng');
INSERT INTO isolanguagesdes VALUES (179, 'Hmong', 'eng');
INSERT INTO isolanguagesdes VALUES (180, 'Hiri Motu', 'eng');
INSERT INTO isolanguagesdes VALUES (181, 'Upper Sorbian', 'eng');
INSERT INTO isolanguagesdes VALUES (182, 'Hungarian', 'eng');
INSERT INTO isolanguagesdes VALUES (183, 'Hupa', 'eng');
INSERT INTO isolanguagesdes VALUES (184, 'Iban', 'eng');
INSERT INTO isolanguagesdes VALUES (185, 'Igbo', 'eng');
INSERT INTO isolanguagesdes VALUES (186, 'Icelandic', 'eng');
INSERT INTO isolanguagesdes VALUES (187, 'Ido', 'eng');
INSERT INTO isolanguagesdes VALUES (188, 'Sichuan Yi', 'eng');
INSERT INTO isolanguagesdes VALUES (189, 'Ijo languages', 'eng');
INSERT INTO isolanguagesdes VALUES (190, 'Inuktitut', 'eng');
INSERT INTO isolanguagesdes VALUES (191, 'Interlingue', 'eng');
INSERT INTO isolanguagesdes VALUES (192, 'Iloko', 'eng');
INSERT INTO isolanguagesdes VALUES (193, 'Interlingua (International Auxiliary L', 'eng');
INSERT INTO isolanguagesdes VALUES (194, 'Indic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (195, 'Indonesian', 'eng');
INSERT INTO isolanguagesdes VALUES (196, 'Indo-European (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (197, 'Ingush', 'eng');
INSERT INTO isolanguagesdes VALUES (198, 'Inupiaq', 'eng');
INSERT INTO isolanguagesdes VALUES (199, 'Iranian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (200, 'Iroquoian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (201, 'Italian', 'eng');
INSERT INTO isolanguagesdes VALUES (202, 'Javanese', 'eng');
INSERT INTO isolanguagesdes VALUES (203, 'Lojban', 'eng');
INSERT INTO isolanguagesdes VALUES (204, 'Japanese', 'eng');
INSERT INTO isolanguagesdes VALUES (205, 'Judeo-Persian', 'eng');
INSERT INTO isolanguagesdes VALUES (206, 'Judeo-Arabic', 'eng');
INSERT INTO isolanguagesdes VALUES (207, 'Kara-Kalpak', 'eng');
INSERT INTO isolanguagesdes VALUES (208, 'Kabyle', 'eng');
INSERT INTO isolanguagesdes VALUES (209, 'Kachin; Jingpho', 'eng');
INSERT INTO isolanguagesdes VALUES (210, 'Kalaallisut; Greenlandic', 'eng');
INSERT INTO isolanguagesdes VALUES (211, 'Kamba', 'eng');
INSERT INTO isolanguagesdes VALUES (212, 'Kannada', 'eng');
INSERT INTO isolanguagesdes VALUES (213, 'Karen languages', 'eng');
INSERT INTO isolanguagesdes VALUES (214, 'Kashmiri', 'eng');
INSERT INTO isolanguagesdes VALUES (215, 'Kanuri', 'eng');
INSERT INTO isolanguagesdes VALUES (216, 'Kawi', 'eng');
INSERT INTO isolanguagesdes VALUES (217, 'Kazakh', 'eng');
INSERT INTO isolanguagesdes VALUES (218, 'Kabardian', 'eng');
INSERT INTO isolanguagesdes VALUES (219, 'Khasi', 'eng');
INSERT INTO isolanguagesdes VALUES (220, 'Khoisan (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (221, 'Central Khmer', 'eng');
INSERT INTO isolanguagesdes VALUES (222, 'Khotanese', 'eng');
INSERT INTO isolanguagesdes VALUES (223, 'Kikuyu; Gikuyu', 'eng');
INSERT INTO isolanguagesdes VALUES (224, 'Kinyarwanda', 'eng');
INSERT INTO isolanguagesdes VALUES (225, 'Kirghiz; Kyrgyz', 'eng');
INSERT INTO isolanguagesdes VALUES (226, 'Kimbundu', 'eng');
INSERT INTO isolanguagesdes VALUES (227, 'Konkani', 'eng');
INSERT INTO isolanguagesdes VALUES (228, 'Komi', 'eng');
INSERT INTO isolanguagesdes VALUES (229, 'Kongo', 'eng');
INSERT INTO isolanguagesdes VALUES (230, 'Korean', 'eng');
INSERT INTO isolanguagesdes VALUES (231, 'Kosraean', 'eng');
INSERT INTO isolanguagesdes VALUES (232, 'Kpelle', 'eng');
INSERT INTO isolanguagesdes VALUES (233, 'Karachay-Balkar', 'eng');
INSERT INTO isolanguagesdes VALUES (234, 'Karelian', 'eng');
INSERT INTO isolanguagesdes VALUES (235, 'Kru languages', 'eng');
INSERT INTO isolanguagesdes VALUES (236, 'Kurukh', 'eng');
INSERT INTO isolanguagesdes VALUES (237, 'Kuanyama; Kwanyama', 'eng');
INSERT INTO isolanguagesdes VALUES (238, 'Kumyk', 'eng');
INSERT INTO isolanguagesdes VALUES (239, 'Kurdish', 'eng');
INSERT INTO isolanguagesdes VALUES (240, 'Kutenai', 'eng');
INSERT INTO isolanguagesdes VALUES (241, 'Ladino', 'eng');
INSERT INTO isolanguagesdes VALUES (242, 'Lahnda', 'eng');
INSERT INTO isolanguagesdes VALUES (243, 'Lamba', 'eng');
INSERT INTO isolanguagesdes VALUES (244, 'Lao', 'eng');
INSERT INTO isolanguagesdes VALUES (245, 'Latin', 'eng');
INSERT INTO isolanguagesdes VALUES (246, 'Latvian', 'eng');
INSERT INTO isolanguagesdes VALUES (247, 'Lezghian', 'eng');
INSERT INTO isolanguagesdes VALUES (248, 'Limburgan; Limburger; Limburgish', 'eng');
INSERT INTO isolanguagesdes VALUES (249, 'Lingala', 'eng');
INSERT INTO isolanguagesdes VALUES (250, 'Lithuanian', 'eng');
INSERT INTO isolanguagesdes VALUES (251, 'Mongo', 'eng');
INSERT INTO isolanguagesdes VALUES (252, 'Lozi', 'eng');
INSERT INTO isolanguagesdes VALUES (253, 'Luxembourgish; Letzeburgesch', 'eng');
INSERT INTO isolanguagesdes VALUES (254, 'Luba-Lulua', 'eng');
INSERT INTO isolanguagesdes VALUES (255, 'Luba-Katangaxon, Low', 'eng');
INSERT INTO isolanguagesdes VALUES (256, 'Ganda', 'eng');
INSERT INTO isolanguagesdes VALUES (257, 'Luiseno', 'eng');
INSERT INTO isolanguagesdes VALUES (258, 'Lunda', 'eng');
INSERT INTO isolanguagesdes VALUES (259, 'Luo (Kenya and Tanzania)', 'eng');
INSERT INTO isolanguagesdes VALUES (260, 'Lushai', 'eng');
INSERT INTO isolanguagesdes VALUES (261, 'Macedonian00E5l', 'eng');
INSERT INTO isolanguagesdes VALUES (262, 'Madurese', 'eng');
INSERT INTO isolanguagesdes VALUES (263, 'Magahi', 'eng');
INSERT INTO isolanguagesdes VALUES (264, 'Marshallese', 'eng');
INSERT INTO isolanguagesdes VALUES (265, 'Maithili', 'eng');
INSERT INTO isolanguagesdes VALUES (266, 'Makasarl Nepal Bhasa', 'eng');
INSERT INTO isolanguagesdes VALUES (267, 'Malayalam', 'eng');
INSERT INTO isolanguagesdes VALUES (268, 'Mandingo', 'eng');
INSERT INTO isolanguagesdes VALUES (269, 'Maori', 'eng');
INSERT INTO isolanguagesdes VALUES (270, 'Austronesian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (271, 'Marathi', 'eng');
INSERT INTO isolanguagesdes VALUES (272, 'Masai', 'eng');
INSERT INTO isolanguagesdes VALUES (273, 'Malay', 'eng');
INSERT INTO isolanguagesdes VALUES (274, 'Moksha', 'eng');
INSERT INTO isolanguagesdes VALUES (275, 'Mandar', 'eng');
INSERT INTO isolanguagesdes VALUES (276, 'Mende', 'eng');
INSERT INTO isolanguagesdes VALUES (277, 'Irish, Middle (900-1200)', 'eng');
INSERT INTO isolanguagesdes VALUES (278, 'Mi''kmaq; Micmac', 'eng');
INSERT INTO isolanguagesdes VALUES (279, 'Minangkabau', 'eng');
INSERT INTO isolanguagesdes VALUES (280, 'Miscellaneous languages', 'eng');
INSERT INTO isolanguagesdes VALUES (281, 'Mon-Khmer (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (282, 'Malagasy', 'eng');
INSERT INTO isolanguagesdes VALUES (283, 'Maltese', 'eng');
INSERT INTO isolanguagesdes VALUES (284, 'Manchu', 'eng');
INSERT INTO isolanguagesdes VALUES (285, 'Manipuri', 'eng');
INSERT INTO isolanguagesdes VALUES (286, 'Manobo languages', 'eng');
INSERT INTO isolanguagesdes VALUES (287, 'Mohawk', 'eng');
INSERT INTO isolanguagesdes VALUES (288, 'Moldavian', 'eng');
INSERT INTO isolanguagesdes VALUES (289, 'Mongolian', 'eng');
INSERT INTO isolanguagesdes VALUES (290, 'Mossi', 'eng');
INSERT INTO isolanguagesdes VALUES (291, 'Multiple languages', 'eng');
INSERT INTO isolanguagesdes VALUES (292, 'Munda languages', 'eng');
INSERT INTO isolanguagesdes VALUES (293, 'Creek', 'eng');
INSERT INTO isolanguagesdes VALUES (294, 'Mirandese', 'eng');
INSERT INTO isolanguagesdes VALUES (295, 'Marwari', 'eng');
INSERT INTO isolanguagesdes VALUES (296, 'Mayan languages', 'eng');
INSERT INTO isolanguagesdes VALUES (297, 'Erzya', 'eng');
INSERT INTO isolanguagesdes VALUES (298, 'Nahuatl languages', 'eng');
INSERT INTO isolanguagesdes VALUES (299, 'North American Indian', 'eng');
INSERT INTO isolanguagesdes VALUES (300, 'Neapolitan', 'eng');
INSERT INTO isolanguagesdes VALUES (301, 'Nauru', 'eng');
INSERT INTO isolanguagesdes VALUES (302, 'Navajo; Navaho', 'eng');
INSERT INTO isolanguagesdes VALUES (303, 'Ndebele, South; South Ndebele', 'eng');
INSERT INTO isolanguagesdes VALUES (304, 'Ndebele, North; North Ndebele', 'eng');
INSERT INTO isolanguagesdes VALUES (305, 'Ndonga', 'eng');
INSERT INTO isolanguagesdes VALUES (306, 'Low German; Low Saxon; German, Low; Sa', 'eng');
INSERT INTO isolanguagesdes VALUES (307, 'Nepali', 'eng');
INSERT INTO isolanguagesdes VALUES (308, 'Nepal Bhasa; Newari', 'eng');
INSERT INTO isolanguagesdes VALUES (309, 'Nias', 'eng');
INSERT INTO isolanguagesdes VALUES (310, 'Niger-Kordofanian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (311, 'Niuean', 'eng');
INSERT INTO isolanguagesdes VALUES (312, 'Norwegian Nynorsk; Nynorsk, Norwegian', 'eng');
INSERT INTO isolanguagesdes VALUES (313, 'Bokmål, Norwegian; Norwegian Bokmål', 'eng');
INSERT INTO isolanguagesdes VALUES (314, 'Nogai', 'eng');
INSERT INTO isolanguagesdes VALUES (315, 'Norse, Old', 'eng');
INSERT INTO isolanguagesdes VALUES (316, 'Norwegian', 'eng');
INSERT INTO isolanguagesdes VALUES (317, 'Pedi; Sepedi; Northern Sotho', 'eng');
INSERT INTO isolanguagesdes VALUES (318, 'Nubian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (319, 'Classical Newari; Old Newari; Classica', 'eng');
INSERT INTO isolanguagesdes VALUES (320, 'Chichewa; Chewa; Nyanja', 'eng');
INSERT INTO isolanguagesdes VALUES (321, 'Nyamwezi', 'eng');
INSERT INTO isolanguagesdes VALUES (322, 'Nyankole', 'eng');
INSERT INTO isolanguagesdes VALUES (323, 'Nyoro', 'eng');
INSERT INTO isolanguagesdes VALUES (324, 'Nzima', 'eng');
INSERT INTO isolanguagesdes VALUES (325, 'Occitan (post 1500); Provençal', 'eng');
INSERT INTO isolanguagesdes VALUES (326, 'Ojibwa', 'eng');
INSERT INTO isolanguagesdes VALUES (327, 'Oriya', 'eng');
INSERT INTO isolanguagesdes VALUES (328, 'Oromo', 'eng');
INSERT INTO isolanguagesdes VALUES (329, 'Osage', 'eng');
INSERT INTO isolanguagesdes VALUES (330, 'Ossetian; Ossetic', 'eng');
INSERT INTO isolanguagesdes VALUES (331, 'Turkish, Ottoman (1500-1928)', 'eng');
INSERT INTO isolanguagesdes VALUES (332, 'Otomian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (333, 'Papuan (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (334, 'Pangasinan', 'eng');
INSERT INTO isolanguagesdes VALUES (335, 'Pahlavi', 'eng');
INSERT INTO isolanguagesdes VALUES (336, 'Pampanga', 'eng');
INSERT INTO isolanguagesdes VALUES (337, 'Panjabi; Punjabi', 'eng');
INSERT INTO isolanguagesdes VALUES (338, 'Papiamento', 'eng');
INSERT INTO isolanguagesdes VALUES (339, 'Palauan', 'eng');
INSERT INTO isolanguagesdes VALUES (340, 'Persian, Old (ca.600-400 B.C.)', 'eng');
INSERT INTO isolanguagesdes VALUES (341, 'Persian', 'eng');
INSERT INTO isolanguagesdes VALUES (342, 'Philippine (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (343, 'Phoenician', 'eng');
INSERT INTO isolanguagesdes VALUES (344, 'Pali', 'eng');
INSERT INTO isolanguagesdes VALUES (345, 'Polish', 'eng');
INSERT INTO isolanguagesdes VALUES (346, 'Pohnpeian', 'eng');
INSERT INTO isolanguagesdes VALUES (347, 'Portuguese', 'eng');
INSERT INTO isolanguagesdes VALUES (348, 'Prakrit languages', 'eng');
INSERT INTO isolanguagesdes VALUES (349, 'Provençal, Old (to 1500)', 'eng');
INSERT INTO isolanguagesdes VALUES (350, 'Pushto', 'eng');
INSERT INTO isolanguagesdes VALUES (351, 'Reserved for local use', 'eng');
INSERT INTO isolanguagesdes VALUES (352, 'Quechua', 'eng');
INSERT INTO isolanguagesdes VALUES (353, 'Rajasthani', 'eng');
INSERT INTO isolanguagesdes VALUES (354, 'Rapanui', 'eng');
INSERT INTO isolanguagesdes VALUES (355, 'Rarotongan; Cook Islands Maori', 'eng');
INSERT INTO isolanguagesdes VALUES (356, 'Romance (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (357, 'Romansh', 'eng');
INSERT INTO isolanguagesdes VALUES (358, 'Romany', 'eng');
INSERT INTO isolanguagesdes VALUES (359, 'Romanian', 'eng');
INSERT INTO isolanguagesdes VALUES (360, 'Rundi', 'eng');
INSERT INTO isolanguagesdes VALUES (361, 'Aromanian; Arumanian; Macedo-Romanian', 'eng');
INSERT INTO isolanguagesdes VALUES (362, 'Russian', 'eng');
INSERT INTO isolanguagesdes VALUES (363, 'Sandawe', 'eng');
INSERT INTO isolanguagesdes VALUES (364, 'Sango', 'eng');
INSERT INTO isolanguagesdes VALUES (365, 'Yakut', 'eng');
INSERT INTO isolanguagesdes VALUES (366, 'South American Indian (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (367, 'Salishan languages', 'eng');
INSERT INTO isolanguagesdes VALUES (368, 'Samaritan Aramaic', 'eng');
INSERT INTO isolanguagesdes VALUES (369, 'Sanskrit', 'eng');
INSERT INTO isolanguagesdes VALUES (370, 'Sasak', 'eng');
INSERT INTO isolanguagesdes VALUES (371, 'Santali', 'eng');
INSERT INTO isolanguagesdes VALUES (372, 'Serbian', 'eng');
INSERT INTO isolanguagesdes VALUES (373, 'Sicilian', 'eng');
INSERT INTO isolanguagesdes VALUES (374, 'Scots', 'eng');
INSERT INTO isolanguagesdes VALUES (375, 'Croatian', 'eng');
INSERT INTO isolanguagesdes VALUES (376, 'Selkup', 'eng');
INSERT INTO isolanguagesdes VALUES (377, 'Semitic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (378, 'Irish, Old (to 900)', 'eng');
INSERT INTO isolanguagesdes VALUES (379, 'Sign Languages', 'eng');
INSERT INTO isolanguagesdes VALUES (380, 'Shan', 'eng');
INSERT INTO isolanguagesdes VALUES (381, 'Sidamo', 'eng');
INSERT INTO isolanguagesdes VALUES (382, 'Sinhala; Sinhalese', 'eng');
INSERT INTO isolanguagesdes VALUES (383, 'Siouan languages', 'eng');
INSERT INTO isolanguagesdes VALUES (384, 'Sino-Tibetan (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (385, 'Slavic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (386, 'Slovak', 'eng');
INSERT INTO isolanguagesdes VALUES (387, 'Slovenian', 'eng');
INSERT INTO isolanguagesdes VALUES (388, 'Southern Sami', 'eng');
INSERT INTO isolanguagesdes VALUES (389, 'Northern Sami', 'eng');
INSERT INTO isolanguagesdes VALUES (390, 'Sami languages (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (391, 'Lule Sami', 'eng');
INSERT INTO isolanguagesdes VALUES (392, 'Inari Sami', 'eng');
INSERT INTO isolanguagesdes VALUES (393, 'Samoan', 'eng');
INSERT INTO isolanguagesdes VALUES (394, 'Skolt Sami', 'eng');
INSERT INTO isolanguagesdes VALUES (395, 'Shona', 'eng');
INSERT INTO isolanguagesdes VALUES (396, 'Sindhi', 'eng');
INSERT INTO isolanguagesdes VALUES (397, 'Soninke', 'eng');
INSERT INTO isolanguagesdes VALUES (398, 'Sogdian', 'eng');
INSERT INTO isolanguagesdes VALUES (399, 'Somali', 'eng');
INSERT INTO isolanguagesdes VALUES (400, 'Songhai languages', 'eng');
INSERT INTO isolanguagesdes VALUES (401, 'Sotho, Southern', 'eng');
INSERT INTO isolanguagesdes VALUES (402, 'Spanish; Castilian', 'eng');
INSERT INTO isolanguagesdes VALUES (403, 'Sardinian; Zazaki', 'eng');
INSERT INTO isolanguagesdes VALUES (404, 'Sranan Tongo', 'eng');
INSERT INTO isolanguagesdes VALUES (405, 'Serer', 'eng');
INSERT INTO isolanguagesdes VALUES (406, 'Nilo-Saharan (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (407, 'Swati', 'eng');
INSERT INTO isolanguagesdes VALUES (408, 'Sukuma', 'eng');
INSERT INTO isolanguagesdes VALUES (409, 'Sundanese', 'eng');
INSERT INTO isolanguagesdes VALUES (410, 'Susu', 'eng');
INSERT INTO isolanguagesdes VALUES (411, 'Sumerian', 'eng');
INSERT INTO isolanguagesdes VALUES (412, 'Swahili', 'eng');
INSERT INTO isolanguagesdes VALUES (413, 'Swedish', 'eng');
INSERT INTO isolanguagesdes VALUES (414, 'Syriac', 'eng');
INSERT INTO isolanguagesdes VALUES (415, 'Tahitian', 'eng');
INSERT INTO isolanguagesdes VALUES (416, 'Tai (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (417, 'Tamil', 'eng');
INSERT INTO isolanguagesdes VALUES (418, 'Tatar', 'eng');
INSERT INTO isolanguagesdes VALUES (419, 'Telugu', 'eng');
INSERT INTO isolanguagesdes VALUES (420, 'Timnendere)', 'eng');
INSERT INTO isolanguagesdes VALUES (421, 'Tereno', 'eng');
INSERT INTO isolanguagesdes VALUES (422, 'Tetum', 'eng');
INSERT INTO isolanguagesdes VALUES (423, 'Tajik', 'eng');
INSERT INTO isolanguagesdes VALUES (424, 'Tagalog', 'eng');
INSERT INTO isolanguagesdes VALUES (425, 'Thai', 'eng');
INSERT INTO isolanguagesdes VALUES (426, 'Tibetan', 'eng');
INSERT INTO isolanguagesdes VALUES (427, 'Tigre', 'eng');
INSERT INTO isolanguagesdes VALUES (428, 'Tigrinya', 'eng');
INSERT INTO isolanguagesdes VALUES (429, 'Tiv', 'eng');
INSERT INTO isolanguagesdes VALUES (430, 'Tokelau', 'eng');
INSERT INTO isolanguagesdes VALUES (431, 'Klingon; tlhIngan-Hol', 'eng');
INSERT INTO isolanguagesdes VALUES (432, 'Tlingit', 'eng');
INSERT INTO isolanguagesdes VALUES (433, 'Tamashek', 'eng');
INSERT INTO isolanguagesdes VALUES (434, 'Tonga (Nyasa)', 'eng');
INSERT INTO isolanguagesdes VALUES (435, 'Tonga (Tonga Islands)', 'eng');
INSERT INTO isolanguagesdes VALUES (436, 'Tok Pisin', 'eng');
INSERT INTO isolanguagesdes VALUES (437, 'Tsimshian', 'eng');
INSERT INTO isolanguagesdes VALUES (438, 'Tswana', 'eng');
INSERT INTO isolanguagesdes VALUES (439, 'Tsonga', 'eng');
INSERT INTO isolanguagesdes VALUES (440, 'Turkmen', 'eng');
INSERT INTO isolanguagesdes VALUES (441, 'Tumbuka', 'eng');
INSERT INTO isolanguagesdes VALUES (442, 'Tupi languages', 'eng');
INSERT INTO isolanguagesdes VALUES (443, 'Turkish', 'eng');
INSERT INTO isolanguagesdes VALUES (444, 'Altaic (Other)', 'eng');
INSERT INTO isolanguagesdes VALUES (445, 'Tuvalu', 'eng');
INSERT INTO isolanguagesdes VALUES (446, 'Twi', 'eng');
INSERT INTO isolanguagesdes VALUES (447, 'Tuvinian', 'eng');
INSERT INTO isolanguagesdes VALUES (448, 'Udmurt', 'eng');
INSERT INTO isolanguagesdes VALUES (449, 'Ugaritic', 'eng');
INSERT INTO isolanguagesdes VALUES (450, 'Uighur; Uyghur', 'eng');
INSERT INTO isolanguagesdes VALUES (451, 'Ukrainian', 'eng');
INSERT INTO isolanguagesdes VALUES (452, 'Umbundu', 'eng');
INSERT INTO isolanguagesdes VALUES (453, 'Undetermined', 'eng');
INSERT INTO isolanguagesdes VALUES (454, 'Urdu', 'eng');
INSERT INTO isolanguagesdes VALUES (455, 'Uzbek', 'eng');
INSERT INTO isolanguagesdes VALUES (456, 'Vai', 'eng');
INSERT INTO isolanguagesdes VALUES (457, 'Venda', 'eng');
INSERT INTO isolanguagesdes VALUES (458, 'Vietnamese', 'eng');
INSERT INTO isolanguagesdes VALUES (459, 'Volapük', 'eng');
INSERT INTO isolanguagesdes VALUES (460, 'Votic', 'eng');
INSERT INTO isolanguagesdes VALUES (461, 'Wakashan languages', 'eng');
INSERT INTO isolanguagesdes VALUES (462, 'Walamo', 'eng');
INSERT INTO isolanguagesdes VALUES (463, 'Waray', 'eng');
INSERT INTO isolanguagesdes VALUES (464, 'Washo', 'eng');
INSERT INTO isolanguagesdes VALUES (465, 'Welsh', 'eng');
INSERT INTO isolanguagesdes VALUES (466, 'Sorbian languages', 'eng');
INSERT INTO isolanguagesdes VALUES (467, 'Walloon', 'eng');
INSERT INTO isolanguagesdes VALUES (468, 'Wolof', 'eng');
INSERT INTO isolanguagesdes VALUES (469, 'Kalmyk; Oirat', 'eng');
INSERT INTO isolanguagesdes VALUES (470, 'Xhosa', 'eng');
INSERT INTO isolanguagesdes VALUES (471, 'Yao', 'eng');
INSERT INTO isolanguagesdes VALUES (472, 'Yapese', 'eng');
INSERT INTO isolanguagesdes VALUES (473, 'Yiddish', 'eng');
INSERT INTO isolanguagesdes VALUES (474, 'Yoruba', 'eng');
INSERT INTO isolanguagesdes VALUES (475, 'Yupik languages', 'eng');
INSERT INTO isolanguagesdes VALUES (476, 'Zapotec', 'eng');
INSERT INTO isolanguagesdes VALUES (477, 'Zenaga', 'eng');
INSERT INTO isolanguagesdes VALUES (478, 'Zhuang; Chuang', 'eng');
INSERT INTO isolanguagesdes VALUES (479, 'Zande languages', 'eng');
INSERT INTO isolanguagesdes VALUES (480, 'Zulu', 'eng');
INSERT INTO isolanguagesdes VALUES (481, 'Zuni', 'eng');
INSERT INTO isolanguagesdes VALUES (482, 'No linguistic content', 'eng');
INSERT INTO isolanguagesdes VALUES (483, 'N''Ko', 'eng');
INSERT INTO isolanguagesdes VALUES (484, 'Zaza; Dimili; Dimli; Kirdki; Kirmanjki', 'eng');
INSERT INTO isolanguagesdes VALUES (1, 'Afar', 'fre');
INSERT INTO isolanguagesdes VALUES (2, 'Abkhaze', 'fre');
INSERT INTO isolanguagesdes VALUES (3, 'Aceh', 'fre');
INSERT INTO isolanguagesdes VALUES (4, 'Acoli', 'fre');
INSERT INTO isolanguagesdes VALUES (5, 'Adangme', 'fre');
INSERT INTO isolanguagesdes VALUES (6, 'Adyghé', 'fre');
INSERT INTO isolanguagesdes VALUES (7, 'Afro-asiatiques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (8, 'Afrihili', 'fre');
INSERT INTO isolanguagesdes VALUES (9, 'Afrikaans', 'fre');
INSERT INTO isolanguagesdes VALUES (10, 'Aïnou', 'fre');
INSERT INTO isolanguagesdes VALUES (11, 'Akan', 'fre');
INSERT INTO isolanguagesdes VALUES (12, 'Akkadien', 'fre');
INSERT INTO isolanguagesdes VALUES (13, 'Albanais', 'fre');
INSERT INTO isolanguagesdes VALUES (14, 'Aléoute', 'fre');
INSERT INTO isolanguagesdes VALUES (15, 'Algonquines, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (16, 'Altai du Sud', 'fre');
INSERT INTO isolanguagesdes VALUES (17, 'Amharique', 'fre');
INSERT INTO isolanguagesdes VALUES (18, 'Anglo-saxon (ca.450-1100)', 'fre');
INSERT INTO isolanguagesdes VALUES (19, 'Angika', 'fre');
INSERT INTO isolanguagesdes VALUES (20, 'Apache', 'fre');
INSERT INTO isolanguagesdes VALUES (21, 'Arabe', 'fre');
INSERT INTO isolanguagesdes VALUES (22, 'Araméen', 'fre');
INSERT INTO isolanguagesdes VALUES (23, 'Aragonais', 'fre');
INSERT INTO isolanguagesdes VALUES (24, 'Arménien', 'fre');
INSERT INTO isolanguagesdes VALUES (25, 'Mapudungun; mapuche; mapuce', 'fre');
INSERT INTO isolanguagesdes VALUES (26, 'Arapaho', 'fre');
INSERT INTO isolanguagesdes VALUES (27, 'Artificielles, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (28, 'Arawak', 'fre');
INSERT INTO isolanguagesdes VALUES (29, 'Assamais', 'fre');
INSERT INTO isolanguagesdes VALUES (30, 'Asturien; bable', 'fre');
INSERT INTO isolanguagesdes VALUES (31, 'Athapascanes, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (32, 'Australiennes, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (33, 'Avar', 'fre');
INSERT INTO isolanguagesdes VALUES (34, 'Avestique', 'fre');
INSERT INTO isolanguagesdes VALUES (35, 'Awadhi', 'fre');
INSERT INTO isolanguagesdes VALUES (36, 'Aymara', 'fre');
INSERT INTO isolanguagesdes VALUES (37, 'Azéri', 'fre');
INSERT INTO isolanguagesdes VALUES (38, 'Banda, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (39, 'Bamilékés, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (40, 'Bachkir', 'fre');
INSERT INTO isolanguagesdes VALUES (41, 'Baloutchi', 'fre');
INSERT INTO isolanguagesdes VALUES (42, 'Bambara', 'fre');
INSERT INTO isolanguagesdes VALUES (43, 'Balinais', 'fre');
INSERT INTO isolanguagesdes VALUES (44, 'Basque', 'fre');
INSERT INTO isolanguagesdes VALUES (45, 'Basa', 'fre');
INSERT INTO isolanguagesdes VALUES (46, 'Baltiques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (47, 'Bedja', 'fre');
INSERT INTO isolanguagesdes VALUES (48, 'Biélorusse', 'fre');
INSERT INTO isolanguagesdes VALUES (49, 'Bemba', 'fre');
INSERT INTO isolanguagesdes VALUES (50, 'Bengali', 'fre');
INSERT INTO isolanguagesdes VALUES (51, 'Berbères, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (52, 'Bhojpuri', 'fre');
INSERT INTO isolanguagesdes VALUES (53, 'Bihari', 'fre');
INSERT INTO isolanguagesdes VALUES (54, 'Bikol', 'fre');
INSERT INTO isolanguagesdes VALUES (55, 'Bini; edo', 'fre');
INSERT INTO isolanguagesdes VALUES (56, 'Bichlamar', 'fre');
INSERT INTO isolanguagesdes VALUES (57, 'Blackfoot', 'fre');
INSERT INTO isolanguagesdes VALUES (58, 'Bantoues, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (59, 'Bosniaque', 'fre');
INSERT INTO isolanguagesdes VALUES (60, 'Braj', 'fre');
INSERT INTO isolanguagesdes VALUES (61, 'Breton', 'fre');
INSERT INTO isolanguagesdes VALUES (62, 'Batak, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (63, 'Bouriate', 'fre');
INSERT INTO isolanguagesdes VALUES (64, 'Bugi', 'fre');
INSERT INTO isolanguagesdes VALUES (65, 'Bulgare', 'fre');
INSERT INTO isolanguagesdes VALUES (66, 'Birman', 'fre');
INSERT INTO isolanguagesdes VALUES (67, 'Blin; bilen', 'fre');
INSERT INTO isolanguagesdes VALUES (68, 'Caddo', 'fre');
INSERT INTO isolanguagesdes VALUES (69, 'Indiennes d''Amérique centrale, aut', 'fre');
INSERT INTO isolanguagesdes VALUES (70, 'Karib; galibi; carib', 'fre');
INSERT INTO isolanguagesdes VALUES (71, 'Catalan; valencienavonic; Old Bulgarian; Old Church Slavonic', 'fre');
INSERT INTO isolanguagesdes VALUES (72, 'Caucasiennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (73, 'Cebuano', 'fre');
INSERT INTO isolanguagesdes VALUES (74, 'Celtiques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (75, 'Chamorro', 'fre');
INSERT INTO isolanguagesdes VALUES (76, 'Chibcha', 'fre');
INSERT INTO isolanguagesdes VALUES (77, 'Tchétchèneher)', 'fre');
INSERT INTO isolanguagesdes VALUES (78, 'Djaghataïer)', 'fre');
INSERT INTO isolanguagesdes VALUES (79, 'Chinois(Other)', 'fre');
INSERT INTO isolanguagesdes VALUES (80, 'Chuuk', 'fre');
INSERT INTO isolanguagesdes VALUES (81, 'Mari', 'fre');
INSERT INTO isolanguagesdes VALUES (82, 'Chinook, jargon', 'fre');
INSERT INTO isolanguagesdes VALUES (83, 'Choctaw', 'fre');
INSERT INTO isolanguagesdes VALUES (84, 'Chipewyan', 'fre');
INSERT INTO isolanguagesdes VALUES (85, 'Cherokee', 'fre');
INSERT INTO isolanguagesdes VALUES (86, 'Slavon d''église; vieux slave; slav', 'fre');
INSERT INTO isolanguagesdes VALUES (87, 'Tchouvache', 'fre');
INSERT INTO isolanguagesdes VALUES (88, 'Cheyenne', 'fre');
INSERT INTO isolanguagesdes VALUES (89, 'Chames, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (90, 'Copte', 'fre');
INSERT INTO isolanguagesdes VALUES (91, 'Cornique', 'fre');
INSERT INTO isolanguagesdes VALUES (92, 'Corse', 'fre');
INSERT INTO isolanguagesdes VALUES (93, 'Créoles et pidgins anglais, autres', 'fre');
INSERT INTO isolanguagesdes VALUES (94, 'Créoles et pidgins français, a', 'fre');
INSERT INTO isolanguagesdes VALUES (95, 'Créoles et pidgins portugais, autr', 'fre');
INSERT INTO isolanguagesdes VALUES (96, 'Cree', 'fre');
INSERT INTO isolanguagesdes VALUES (97, 'Tatar de Crimé', 'fre');
INSERT INTO isolanguagesdes VALUES (98, 'Créoles et pidgins divers', 'fre');
INSERT INTO isolanguagesdes VALUES (99, 'Kachoube', 'fre');
INSERT INTO isolanguagesdes VALUES (100, 'Couchitiques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (101, 'Tchèque', 'fre');
INSERT INTO isolanguagesdes VALUES (102, 'Dakota', 'fre');
INSERT INTO isolanguagesdes VALUES (103, 'Danois', 'fre');
INSERT INTO isolanguagesdes VALUES (104, 'Dargwa', 'fre');
INSERT INTO isolanguagesdes VALUES (105, 'Dayak, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (106, 'Delaware', 'fre');
INSERT INTO isolanguagesdes VALUES (107, 'Esclave (athapascan)', 'fre');
INSERT INTO isolanguagesdes VALUES (108, 'Dogrib', 'fre');
INSERT INTO isolanguagesdes VALUES (109, 'Dinka', 'fre');
INSERT INTO isolanguagesdes VALUES (110, 'Maldivien', 'fre');
INSERT INTO isolanguagesdes VALUES (111, 'Dogri', 'fre');
INSERT INTO isolanguagesdes VALUES (112, 'Dravidiennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (113, 'Bas-sorabe', 'fre');
INSERT INTO isolanguagesdes VALUES (114, 'Douala', 'fre');
INSERT INTO isolanguagesdes VALUES (115, 'Néerlandais moyen (ca. 1050-1350)', 'fre');
INSERT INTO isolanguagesdes VALUES (116, 'Néerlandais; flamand', 'fre');
INSERT INTO isolanguagesdes VALUES (117, 'Dioula', 'fre');
INSERT INTO isolanguagesdes VALUES (118, 'Dzongkha', 'fre');
INSERT INTO isolanguagesdes VALUES (119, 'Efik', 'fre');
INSERT INTO isolanguagesdes VALUES (120, 'Égyptien', 'fre');
INSERT INTO isolanguagesdes VALUES (121, 'Ekajuk', 'fre');
INSERT INTO isolanguagesdes VALUES (122, 'Élamite', 'fre');
INSERT INTO isolanguagesdes VALUES (123, 'Anglais', 'fre');
INSERT INTO isolanguagesdes VALUES (124, 'Anglais moyen (1100-1500)', 'fre');
INSERT INTO isolanguagesdes VALUES (125, 'Espéranto', 'fre');
INSERT INTO isolanguagesdes VALUES (126, 'Estonien', 'fre');
INSERT INTO isolanguagesdes VALUES (127, 'Éwé', 'fre');
INSERT INTO isolanguagesdes VALUES (128, 'Éwondo', 'fre');
INSERT INTO isolanguagesdes VALUES (129, 'Fang', 'fre');
INSERT INTO isolanguagesdes VALUES (130, 'Féroïen', 'fre');
INSERT INTO isolanguagesdes VALUES (131, 'Fanti', 'fre');
INSERT INTO isolanguagesdes VALUES (132, 'Fidjien', 'fre');
INSERT INTO isolanguagesdes VALUES (133, 'Filipino; pilipino', 'fre');
INSERT INTO isolanguagesdes VALUES (134, 'Finnois', 'fre');
INSERT INTO isolanguagesdes VALUES (135, 'Finno-ougriennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (136, 'Fon', 'fre');
INSERT INTO isolanguagesdes VALUES (137, 'Français', 'fre');
INSERT INTO isolanguagesdes VALUES (138, 'Français moyen (1400-1600)', 'fre');
INSERT INTO isolanguagesdes VALUES (139, 'Français ancien (842-ca.1400)', 'fre');
INSERT INTO isolanguagesdes VALUES (140, 'Frison septentrional', 'fre');
INSERT INTO isolanguagesdes VALUES (141, 'Frison oriental', 'fre');
INSERT INTO isolanguagesdes VALUES (142, 'Frison occidental', 'fre');
INSERT INTO isolanguagesdes VALUES (143, 'Peul', 'fre');
INSERT INTO isolanguagesdes VALUES (144, 'Frioulan', 'fre');
INSERT INTO isolanguagesdes VALUES (145, 'Ga', 'fre');
INSERT INTO isolanguagesdes VALUES (146, 'Gayo', 'fre');
INSERT INTO isolanguagesdes VALUES (147, 'Gbaya', 'fre');
INSERT INTO isolanguagesdes VALUES (148, 'Germaniques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (149, 'Géorgien', 'fre');
INSERT INTO isolanguagesdes VALUES (150, 'Allemand', 'fre');
INSERT INTO isolanguagesdes VALUES (151, 'Guèze', 'fre');
INSERT INTO isolanguagesdes VALUES (152, 'Kiribati', 'fre');
INSERT INTO isolanguagesdes VALUES (153, 'Gaélique; gaélique écossai', 'fre');
INSERT INTO isolanguagesdes VALUES (154, 'Irlandais', 'fre');
INSERT INTO isolanguagesdes VALUES (155, 'Galicien', 'fre');
INSERT INTO isolanguagesdes VALUES (156, 'Manx; mannois', 'fre');
INSERT INTO isolanguagesdes VALUES (157, 'Allemand, moyen haut (ca. 1050-1500)', 'fre');
INSERT INTO isolanguagesdes VALUES (158, 'Allemand, vieux haut (ca. 750-1050)', 'fre');
INSERT INTO isolanguagesdes VALUES (159, 'Gond', 'fre');
INSERT INTO isolanguagesdes VALUES (160, 'Gorontalo', 'fre');
INSERT INTO isolanguagesdes VALUES (161, 'Gothique', 'fre');
INSERT INTO isolanguagesdes VALUES (162, 'Grebo', 'fre');
INSERT INTO isolanguagesdes VALUES (163, 'Grec ancien (jusqu''à 1453)', 'fre');
INSERT INTO isolanguagesdes VALUES (164, 'Grec moderne (après 1453)', 'fre');
INSERT INTO isolanguagesdes VALUES (165, 'Guarani', 'fre');
INSERT INTO isolanguagesdes VALUES (166, 'Alémanique', 'fre');
INSERT INTO isolanguagesdes VALUES (167, 'Goudjrati', 'fre');
INSERT INTO isolanguagesdes VALUES (168, 'Gwich''in', 'fre');
INSERT INTO isolanguagesdes VALUES (169, 'Haida', 'fre');
INSERT INTO isolanguagesdes VALUES (170, 'Haïtien; créole haïtien', 'fre');
INSERT INTO isolanguagesdes VALUES (171, 'Haoussa', 'fre');
INSERT INTO isolanguagesdes VALUES (172, 'Hawaïen', 'fre');
INSERT INTO isolanguagesdes VALUES (173, 'Hébreu', 'fre');
INSERT INTO isolanguagesdes VALUES (174, 'Herero', 'fre');
INSERT INTO isolanguagesdes VALUES (175, 'Hiligaynon', 'fre');
INSERT INTO isolanguagesdes VALUES (176, 'Himachali', 'fre');
INSERT INTO isolanguagesdes VALUES (177, 'Hindi', 'fre');
INSERT INTO isolanguagesdes VALUES (178, 'Hittite', 'fre');
INSERT INTO isolanguagesdes VALUES (179, 'Hmong', 'fre');
INSERT INTO isolanguagesdes VALUES (180, 'Hiri motu', 'fre');
INSERT INTO isolanguagesdes VALUES (181, 'Haut-sorabe', 'fre');
INSERT INTO isolanguagesdes VALUES (182, 'Hongrois', 'fre');
INSERT INTO isolanguagesdes VALUES (183, 'Hupa', 'fre');
INSERT INTO isolanguagesdes VALUES (184, 'Iban', 'fre');
INSERT INTO isolanguagesdes VALUES (185, 'Igbo', 'fre');
INSERT INTO isolanguagesdes VALUES (186, 'Islandais', 'fre');
INSERT INTO isolanguagesdes VALUES (187, 'Ido', 'fre');
INSERT INTO isolanguagesdes VALUES (188, 'Yi de Sichuan', 'fre');
INSERT INTO isolanguagesdes VALUES (189, 'Ijo, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (190, 'Inuktitut', 'fre');
INSERT INTO isolanguagesdes VALUES (191, 'Interlingue', 'fre');
INSERT INTO isolanguagesdes VALUES (192, 'Ilocano', 'fre');
INSERT INTO isolanguagesdes VALUES (193, 'Interlingua (langue auxiliaire interna', 'fre');
INSERT INTO isolanguagesdes VALUES (194, 'Indo-aryennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (195, 'Indonésien', 'fre');
INSERT INTO isolanguagesdes VALUES (196, 'Indo-européennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (197, 'Ingouche', 'fre');
INSERT INTO isolanguagesdes VALUES (198, 'Inupiaq', 'fre');
INSERT INTO isolanguagesdes VALUES (199, 'Iraniennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (200, 'Iroquoises, langues (famille)', 'fre');
INSERT INTO isolanguagesdes VALUES (201, 'Italien', 'fre');
INSERT INTO isolanguagesdes VALUES (202, 'Javanais', 'fre');
INSERT INTO isolanguagesdes VALUES (203, 'Lojban', 'fre');
INSERT INTO isolanguagesdes VALUES (204, 'Japonais', 'fre');
INSERT INTO isolanguagesdes VALUES (205, 'Judéo-persan', 'fre');
INSERT INTO isolanguagesdes VALUES (206, 'Judéo-arabe', 'fre');
INSERT INTO isolanguagesdes VALUES (207, 'Karakalpak', 'fre');
INSERT INTO isolanguagesdes VALUES (208, 'Kabyle', 'fre');
INSERT INTO isolanguagesdes VALUES (209, 'Kachin; jingpho', 'fre');
INSERT INTO isolanguagesdes VALUES (210, 'Groenlandais', 'fre');
INSERT INTO isolanguagesdes VALUES (211, 'Kamba', 'fre');
INSERT INTO isolanguagesdes VALUES (212, 'Kannada', 'fre');
INSERT INTO isolanguagesdes VALUES (213, 'Karen, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (214, 'Kashmiri', 'fre');
INSERT INTO isolanguagesdes VALUES (215, 'Kanouri', 'fre');
INSERT INTO isolanguagesdes VALUES (216, 'Kawi', 'fre');
INSERT INTO isolanguagesdes VALUES (217, 'Kazakh', 'fre');
INSERT INTO isolanguagesdes VALUES (218, 'Kabardien', 'fre');
INSERT INTO isolanguagesdes VALUES (219, 'Khasi', 'fre');
INSERT INTO isolanguagesdes VALUES (220, 'Khoisan, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (221, 'Khmer central', 'fre');
INSERT INTO isolanguagesdes VALUES (222, 'Khotanais', 'fre');
INSERT INTO isolanguagesdes VALUES (223, 'Kikuyu', 'fre');
INSERT INTO isolanguagesdes VALUES (224, 'Rwanda', 'fre');
INSERT INTO isolanguagesdes VALUES (225, 'Kirghizes', 'fre');
INSERT INTO isolanguagesdes VALUES (226, 'Kimbundu', 'fre');
INSERT INTO isolanguagesdes VALUES (227, 'Konkani', 'fre');
INSERT INTO isolanguagesdes VALUES (228, 'Kom', 'fre');
INSERT INTO isolanguagesdes VALUES (229, 'Kongo', 'fre');
INSERT INTO isolanguagesdes VALUES (230, 'Coréen', 'fre');
INSERT INTO isolanguagesdes VALUES (231, 'Kosrae', 'fre');
INSERT INTO isolanguagesdes VALUES (232, 'Kpellé', 'fre');
INSERT INTO isolanguagesdes VALUES (233, 'Karatchai balkar', 'fre');
INSERT INTO isolanguagesdes VALUES (234, 'Carélien', 'fre');
INSERT INTO isolanguagesdes VALUES (235, 'Krou, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (236, 'Kurukh', 'fre');
INSERT INTO isolanguagesdes VALUES (237, 'Kuanyama; kwanyama', 'fre');
INSERT INTO isolanguagesdes VALUES (238, 'Koumyk', 'fre');
INSERT INTO isolanguagesdes VALUES (239, 'Kurde', 'fre');
INSERT INTO isolanguagesdes VALUES (240, 'Kutenai', 'fre');
INSERT INTO isolanguagesdes VALUES (241, 'Judéo-espagnol', 'fre');
INSERT INTO isolanguagesdes VALUES (242, 'Lahnda', 'fre');
INSERT INTO isolanguagesdes VALUES (243, 'Lamba', 'fre');
INSERT INTO isolanguagesdes VALUES (244, 'Lao', 'fre');
INSERT INTO isolanguagesdes VALUES (245, 'Latin', 'fre');
INSERT INTO isolanguagesdes VALUES (246, 'Letton', 'fre');
INSERT INTO isolanguagesdes VALUES (247, 'Lezghien', 'fre');
INSERT INTO isolanguagesdes VALUES (248, 'Limbourgeois', 'fre');
INSERT INTO isolanguagesdes VALUES (249, 'Lingala', 'fre');
INSERT INTO isolanguagesdes VALUES (250, 'Lituanien', 'fre');
INSERT INTO isolanguagesdes VALUES (251, 'Mongo', 'fre');
INSERT INTO isolanguagesdes VALUES (252, 'Lozi', 'fre');
INSERT INTO isolanguagesdes VALUES (253, 'Luxembourgeois', 'fre');
INSERT INTO isolanguagesdes VALUES (254, 'Luba-lulua', 'fre');
INSERT INTO isolanguagesdes VALUES (255, 'Luba-katanga; saxon, bas', 'fre');
INSERT INTO isolanguagesdes VALUES (256, 'Ganda', 'fre');
INSERT INTO isolanguagesdes VALUES (257, 'Luiseno', 'fre');
INSERT INTO isolanguagesdes VALUES (258, 'Lunda', 'fre');
INSERT INTO isolanguagesdes VALUES (259, 'Luo (Kenya et Tanzanie)', 'fre');
INSERT INTO isolanguagesdes VALUES (260, 'Lushai0E9gien', 'fre');
INSERT INTO isolanguagesdes VALUES (261, 'Macédonien', 'fre');
INSERT INTO isolanguagesdes VALUES (262, 'Madourais', 'fre');
INSERT INTO isolanguagesdes VALUES (263, 'Magahi', 'fre');
INSERT INTO isolanguagesdes VALUES (264, 'Marshall', 'fre');
INSERT INTO isolanguagesdes VALUES (265, 'Maithili', 'fre');
INSERT INTO isolanguagesdes VALUES (266, 'Makassar', 'fre');
INSERT INTO isolanguagesdes VALUES (267, 'Malayalam', 'fre');
INSERT INTO isolanguagesdes VALUES (268, 'Mandingue', 'fre');
INSERT INTO isolanguagesdes VALUES (269, 'Maori', 'fre');
INSERT INTO isolanguagesdes VALUES (270, 'Malayo-polynésiennes, autres langu', 'fre');
INSERT INTO isolanguagesdes VALUES (271, 'Marathe', 'fre');
INSERT INTO isolanguagesdes VALUES (272, 'Massaï', 'fre');
INSERT INTO isolanguagesdes VALUES (273, 'Malais', 'fre');
INSERT INTO isolanguagesdes VALUES (274, 'Moksa', 'fre');
INSERT INTO isolanguagesdes VALUES (275, 'Mandar', 'fre');
INSERT INTO isolanguagesdes VALUES (276, 'Mendé', 'fre');
INSERT INTO isolanguagesdes VALUES (277, 'Irlandais moyen (900-1200)', 'fre');
INSERT INTO isolanguagesdes VALUES (278, 'Mi''kmaq; micmac', 'fre');
INSERT INTO isolanguagesdes VALUES (279, 'Minangkabau', 'fre');
INSERT INTO isolanguagesdes VALUES (280, 'Diverses, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (281, 'Môn-khmer, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (282, 'Malgache', 'fre');
INSERT INTO isolanguagesdes VALUES (283, 'Maltais', 'fre');
INSERT INTO isolanguagesdes VALUES (284, 'Mandchou', 'fre');
INSERT INTO isolanguagesdes VALUES (285, 'Manipuri', 'fre');
INSERT INTO isolanguagesdes VALUES (286, 'Manobo, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (287, 'Mohawk', 'fre');
INSERT INTO isolanguagesdes VALUES (288, 'Moldave', 'fre');
INSERT INTO isolanguagesdes VALUES (289, 'Mongol', 'fre');
INSERT INTO isolanguagesdes VALUES (290, 'Moré', 'fre');
INSERT INTO isolanguagesdes VALUES (291, 'Multilingue', 'fre');
INSERT INTO isolanguagesdes VALUES (292, 'Mounda, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (293, 'Muskogee', 'fre');
INSERT INTO isolanguagesdes VALUES (294, 'Mirandais', 'fre');
INSERT INTO isolanguagesdes VALUES (295, 'Marvari', 'fre');
INSERT INTO isolanguagesdes VALUES (296, 'Maya, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (297, 'Erza', 'fre');
INSERT INTO isolanguagesdes VALUES (298, 'Nahuatl, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (299, 'Indiennes d''Amérique du Nord, autr', 'fre');
INSERT INTO isolanguagesdes VALUES (300, 'Napolitain', 'fre');
INSERT INTO isolanguagesdes VALUES (301, 'Nauruan', 'fre');
INSERT INTO isolanguagesdes VALUES (302, 'Navaho', 'fre');
INSERT INTO isolanguagesdes VALUES (303, 'Ndébélé du Sud', 'fre');
INSERT INTO isolanguagesdes VALUES (304, 'Ndébélé du Nord', 'fre');
INSERT INTO isolanguagesdes VALUES (305, 'Ndongas langues', 'fre');
INSERT INTO isolanguagesdes VALUES (306, 'Bas allemand; bas saxon; allemand, bas', 'fre');
INSERT INTO isolanguagesdes VALUES (307, 'Népalais', 'fre');
INSERT INTO isolanguagesdes VALUES (308, 'Nepal bhasa; newari', 'fre');
INSERT INTO isolanguagesdes VALUES (309, 'Nias', 'fre');
INSERT INTO isolanguagesdes VALUES (310, 'Nigéro-congolaises, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (311, 'Niué', 'fre');
INSERT INTO isolanguagesdes VALUES (312, 'Norvégien nynorsk; nynorsk, norvégien', 'fre');
INSERT INTO isolanguagesdes VALUES (313, 'Norvégien bokmål', 'fre');
INSERT INTO isolanguagesdes VALUES (314, 'Nogaï; nogay', 'fre');
INSERT INTO isolanguagesdes VALUES (315, 'Norrois, vieux', 'fre');
INSERT INTO isolanguagesdes VALUES (316, 'Norvégien', 'fre');
INSERT INTO isolanguagesdes VALUES (317, 'Pedi; sepedi; sotho du Nord', 'fre');
INSERT INTO isolanguagesdes VALUES (318, 'Nubiennes, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (319, 'Newari classique', 'fre');
INSERT INTO isolanguagesdes VALUES (320, 'Chichewa; chewa; nyanja', 'fre');
INSERT INTO isolanguagesdes VALUES (321, 'Nyamwezi', 'fre');
INSERT INTO isolanguagesdes VALUES (322, 'Nyankolé', 'fre');
INSERT INTO isolanguagesdes VALUES (323, 'Nyoro', 'fre');
INSERT INTO isolanguagesdes VALUES (324, 'Nzema', 'fre');
INSERT INTO isolanguagesdes VALUES (325, 'Occitan (après 1500); provença', 'fre');
INSERT INTO isolanguagesdes VALUES (326, 'Ojibwa', 'fre');
INSERT INTO isolanguagesdes VALUES (327, 'Oriya', 'fre');
INSERT INTO isolanguagesdes VALUES (328, 'Galla', 'fre');
INSERT INTO isolanguagesdes VALUES (329, 'Osage', 'fre');
INSERT INTO isolanguagesdes VALUES (330, 'Ossète', 'fre');
INSERT INTO isolanguagesdes VALUES (331, 'Turc ottoman (1500-1928)', 'fre');
INSERT INTO isolanguagesdes VALUES (332, 'Otomangue, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (333, 'Papoues, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (334, 'Pangasinan', 'fre');
INSERT INTO isolanguagesdes VALUES (335, 'Pahlavi', 'fre');
INSERT INTO isolanguagesdes VALUES (336, 'Pampangan', 'fre');
INSERT INTO isolanguagesdes VALUES (337, 'Pendjabi', 'fre');
INSERT INTO isolanguagesdes VALUES (338, 'Papiamento', 'fre');
INSERT INTO isolanguagesdes VALUES (339, 'Palau', 'fre');
INSERT INTO isolanguagesdes VALUES (340, 'Perse, vieux (ca. 600-400 av. J.-C.)', 'fre');
INSERT INTO isolanguagesdes VALUES (341, 'Persan', 'fre');
INSERT INTO isolanguagesdes VALUES (342, 'Philippines, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (343, 'Phénicien', 'fre');
INSERT INTO isolanguagesdes VALUES (344, 'Pali', 'fre');
INSERT INTO isolanguagesdes VALUES (345, 'Polonais', 'fre');
INSERT INTO isolanguagesdes VALUES (346, 'Pohnpei', 'fre');
INSERT INTO isolanguagesdes VALUES (347, 'Portugais', 'fre');
INSERT INTO isolanguagesdes VALUES (348, 'Prâkrit', 'fre');
INSERT INTO isolanguagesdes VALUES (349, 'Provençal ancien (jusqu''à 1500', 'fre');
INSERT INTO isolanguagesdes VALUES (350, 'Pachto', 'fre');
INSERT INTO isolanguagesdes VALUES (351, 'Réservée à l''usage local', 'fre');
INSERT INTO isolanguagesdes VALUES (352, 'Quechua', 'fre');
INSERT INTO isolanguagesdes VALUES (353, 'Rajasthani', 'fre');
INSERT INTO isolanguagesdes VALUES (354, 'Rapanui', 'fre');
INSERT INTO isolanguagesdes VALUES (355, 'Rarotonga; maori des îles Cook', 'fre');
INSERT INTO isolanguagesdes VALUES (356, 'Romanes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (357, 'Romanche', 'fre');
INSERT INTO isolanguagesdes VALUES (358, 'Tsigane', 'fre');
INSERT INTO isolanguagesdes VALUES (359, 'Roumain', 'fre');
INSERT INTO isolanguagesdes VALUES (360, 'Rundi', 'fre');
INSERT INTO isolanguagesdes VALUES (361, 'Aroumain; macédo-roumain', 'fre');
INSERT INTO isolanguagesdes VALUES (362, 'Russe', 'fre');
INSERT INTO isolanguagesdes VALUES (363, 'Sandawe', 'fre');
INSERT INTO isolanguagesdes VALUES (364, 'Sango', 'fre');
INSERT INTO isolanguagesdes VALUES (365, 'Iakoute', 'fre');
INSERT INTO isolanguagesdes VALUES (366, 'Indiennes d''Amérique du Sud, autre', 'fre');
INSERT INTO isolanguagesdes VALUES (367, 'Salish, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (368, 'Samaritain', 'fre');
INSERT INTO isolanguagesdes VALUES (369, 'Sanskrit', 'fre');
INSERT INTO isolanguagesdes VALUES (370, 'Sasak', 'fre');
INSERT INTO isolanguagesdes VALUES (371, 'Santal', 'fre');
INSERT INTO isolanguagesdes VALUES (372, 'Serbe', 'fre');
INSERT INTO isolanguagesdes VALUES (373, 'Sicilien', 'fre');
INSERT INTO isolanguagesdes VALUES (374, 'Écossais', 'fre');
INSERT INTO isolanguagesdes VALUES (375, 'Croate', 'fre');
INSERT INTO isolanguagesdes VALUES (376, 'Selkoupe', 'fre');
INSERT INTO isolanguagesdes VALUES (377, 'Sémitiques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (378, 'Irlandais ancien (jusqu''à 900)', 'fre');
INSERT INTO isolanguagesdes VALUES (379, 'Langues des signes', 'fre');
INSERT INTO isolanguagesdes VALUES (380, 'Chan', 'fre');
INSERT INTO isolanguagesdes VALUES (381, 'Sidamo', 'fre');
INSERT INTO isolanguagesdes VALUES (382, 'Singhalais', 'fre');
INSERT INTO isolanguagesdes VALUES (383, 'Sioux, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (384, 'Sino-tibétaines, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (385, 'Slaves, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (386, 'Slovaque', 'fre');
INSERT INTO isolanguagesdes VALUES (387, 'Slovène', 'fre');
INSERT INTO isolanguagesdes VALUES (388, 'Sami du Sud', 'fre');
INSERT INTO isolanguagesdes VALUES (389, 'Sami du Nord', 'fre');
INSERT INTO isolanguagesdes VALUES (390, 'Sami, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (391, 'Sami de Lule', 'fre');
INSERT INTO isolanguagesdes VALUES (392, 'Sami d''Inari', 'fre');
INSERT INTO isolanguagesdes VALUES (393, 'Samoan', 'fre');
INSERT INTO isolanguagesdes VALUES (394, 'Sami skolt', 'fre');
INSERT INTO isolanguagesdes VALUES (395, 'Shona', 'fre');
INSERT INTO isolanguagesdes VALUES (396, 'Sindhi', 'fre');
INSERT INTO isolanguagesdes VALUES (397, 'Soninké', 'fre');
INSERT INTO isolanguagesdes VALUES (398, 'Sogdien', 'fre');
INSERT INTO isolanguagesdes VALUES (399, 'Somali', 'fre');
INSERT INTO isolanguagesdes VALUES (400, 'Songhai, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (401, 'Sotho du Sud', 'fre');
INSERT INTO isolanguagesdes VALUES (402, 'Espagnol; castillan', 'fre');
INSERT INTO isolanguagesdes VALUES (403, 'Sarde; Zazaki', 'fre');
INSERT INTO isolanguagesdes VALUES (404, 'Sranan tongo', 'fre');
INSERT INTO isolanguagesdes VALUES (405, 'Sérère', 'fre');
INSERT INTO isolanguagesdes VALUES (406, 'Nilo-sahariennes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (407, 'Swati', 'fre');
INSERT INTO isolanguagesdes VALUES (408, 'Sukuma', 'fre');
INSERT INTO isolanguagesdes VALUES (409, 'Soundanais', 'fre');
INSERT INTO isolanguagesdes VALUES (410, 'Soussou', 'fre');
INSERT INTO isolanguagesdes VALUES (411, 'Sumérien', 'fre');
INSERT INTO isolanguagesdes VALUES (412, 'Swahili', 'fre');
INSERT INTO isolanguagesdes VALUES (413, 'Suédois', 'fre');
INSERT INTO isolanguagesdes VALUES (414, 'Syriaque', 'fre');
INSERT INTO isolanguagesdes VALUES (415, 'Tahitien', 'fre');
INSERT INTO isolanguagesdes VALUES (416, 'Thaïes, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (417, 'Tamoul', 'fre');
INSERT INTO isolanguagesdes VALUES (418, 'Tatar', 'fre');
INSERT INTO isolanguagesdes VALUES (419, 'Télougou', 'fre');
INSERT INTO isolanguagesdes VALUES (420, 'Temne', 'fre');
INSERT INTO isolanguagesdes VALUES (421, 'Tereno', 'fre');
INSERT INTO isolanguagesdes VALUES (422, 'Tetum', 'fre');
INSERT INTO isolanguagesdes VALUES (423, 'Tadjik', 'fre');
INSERT INTO isolanguagesdes VALUES (424, 'Tagalog', 'fre');
INSERT INTO isolanguagesdes VALUES (425, 'Thaï', 'fre');
INSERT INTO isolanguagesdes VALUES (426, 'Tibétain', 'fre');
INSERT INTO isolanguagesdes VALUES (427, 'Tigré', 'fre');
INSERT INTO isolanguagesdes VALUES (428, 'Tigrigna', 'fre');
INSERT INTO isolanguagesdes VALUES (429, 'Tiv', 'fre');
INSERT INTO isolanguagesdes VALUES (430, 'Tokelau', 'fre');
INSERT INTO isolanguagesdes VALUES (431, 'Klingon', 'fre');
INSERT INTO isolanguagesdes VALUES (432, 'Tlingit', 'fre');
INSERT INTO isolanguagesdes VALUES (433, 'Tamacheq', 'fre');
INSERT INTO isolanguagesdes VALUES (434, 'Tonga (Nyasa)', 'fre');
INSERT INTO isolanguagesdes VALUES (435, 'Tongan (Îles Tonga)', 'fre');
INSERT INTO isolanguagesdes VALUES (436, 'Tok pisin', 'fre');
INSERT INTO isolanguagesdes VALUES (437, 'Tsimshian', 'fre');
INSERT INTO isolanguagesdes VALUES (438, 'Tswana', 'fre');
INSERT INTO isolanguagesdes VALUES (439, 'Tsonga', 'fre');
INSERT INTO isolanguagesdes VALUES (440, 'Turkmène', 'fre');
INSERT INTO isolanguagesdes VALUES (441, 'Tumbuka', 'fre');
INSERT INTO isolanguagesdes VALUES (442, 'Tupi, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (443, 'Turc', 'fre');
INSERT INTO isolanguagesdes VALUES (444, 'Altaïques, autres langues', 'fre');
INSERT INTO isolanguagesdes VALUES (445, 'Tuvalu', 'fre');
INSERT INTO isolanguagesdes VALUES (446, 'Twi', 'fre');
INSERT INTO isolanguagesdes VALUES (447, 'Touva', 'fre');
INSERT INTO isolanguagesdes VALUES (448, 'Oudmourte', 'fre');
INSERT INTO isolanguagesdes VALUES (449, 'Ougaritique', 'fre');
INSERT INTO isolanguagesdes VALUES (450, 'Ouïgour', 'fre');
INSERT INTO isolanguagesdes VALUES (451, 'Ukrainien', 'fre');
INSERT INTO isolanguagesdes VALUES (452, 'Umbundu', 'fre');
INSERT INTO isolanguagesdes VALUES (453, 'Indéterminée', 'fre');
INSERT INTO isolanguagesdes VALUES (454, 'Ourdou', 'fre');
INSERT INTO isolanguagesdes VALUES (455, 'Ouszbek', 'fre');
INSERT INTO isolanguagesdes VALUES (456, 'Vaï', 'fre');
INSERT INTO isolanguagesdes VALUES (457, 'Venda', 'fre');
INSERT INTO isolanguagesdes VALUES (458, 'Vietnamien', 'fre');
INSERT INTO isolanguagesdes VALUES (459, 'Volapük', 'fre');
INSERT INTO isolanguagesdes VALUES (460, 'Vote', 'fre');
INSERT INTO isolanguagesdes VALUES (461, 'Wakashennes, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (462, 'Walamo', 'fre');
INSERT INTO isolanguagesdes VALUES (463, 'Waray', 'fre');
INSERT INTO isolanguagesdes VALUES (464, 'Washo', 'fre');
INSERT INTO isolanguagesdes VALUES (465, 'Gallois', 'fre');
INSERT INTO isolanguagesdes VALUES (466, 'Sorabes, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (467, 'Wallon', 'fre');
INSERT INTO isolanguagesdes VALUES (468, 'Wolof', 'fre');
INSERT INTO isolanguagesdes VALUES (469, 'Kalmouk; oïrat', 'fre');
INSERT INTO isolanguagesdes VALUES (470, 'Xhosa', 'fre');
INSERT INTO isolanguagesdes VALUES (471, 'Yao', 'fre');
INSERT INTO isolanguagesdes VALUES (472, 'Yapois', 'fre');
INSERT INTO isolanguagesdes VALUES (473, 'Yiddish', 'fre');
INSERT INTO isolanguagesdes VALUES (474, 'Yoruba', 'fre');
INSERT INTO isolanguagesdes VALUES (475, 'Yupik, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (476, 'Zapotèque', 'fre');
INSERT INTO isolanguagesdes VALUES (477, 'Zenaga', 'fre');
INSERT INTO isolanguagesdes VALUES (478, 'Zhuang; chuang', 'fre');
INSERT INTO isolanguagesdes VALUES (479, 'Zandé, langues', 'fre');
INSERT INTO isolanguagesdes VALUES (480, 'Zoulou', 'fre');
INSERT INTO isolanguagesdes VALUES (481, 'Zuni', 'fre');
INSERT INTO isolanguagesdes VALUES (482, 'Pas de contenu linguistique', 'fre');
INSERT INTO isolanguagesdes VALUES (483, 'N''ko', 'fre');
INSERT INTO isolanguagesdes VALUES (484, 'Zaza; dimili; dimli; kirdki; kirmanjki', 'fre');


--
-- TOC entry 4083 (class 0 OID 27559335)
-- Dependencies: 354
-- Data for Name: languages; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO languages VALUES ('eng', 'y', 'y', 'English');
INSERT INTO languages VALUES ('fre', 'n', 'y', 'français');


--
-- TOC entry 4084 (class 0 OID 27559338)
-- Dependencies: 355
-- Data for Name: mapservers; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4085 (class 0 OID 27559344)
-- Dependencies: 356
-- Data for Name: metadata; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO metadata VALUES (941, '<gmd:CI_ResponsibleParty xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gml="http://www.opengis.net/gml">
  <gmd:individualName>
    <gco:CharacterString>Nom</gco:CharacterString>
  </gmd:individualName>
  <gmd:organisationName>
    <gco:CharacterString>Organisation</gco:CharacterString>
  </gmd:organisationName>
  <gmd:positionName>
    <gco:CharacterString>Fonction</gco:CharacterString>
  </gmd:positionName>
  <gmd:contactInfo>
    <gmd:CI_Contact>
      <gmd:address>
        <gmd:CI_Address>
          <gmd:electronicMailAddress>
            <gco:CharacterString>Email</gco:CharacterString>
          </gmd:electronicMailAddress>
        </gmd:CI_Address>
      </gmd:address>
    </gmd:CI_Contact>
  </gmd:contactInfo>
  <gmd:role>
    <gmd:CI_RoleCode codeList="./resources/codeList.xml#CI_RoleCode" codeListValue="pointOfContact" />
  </gmd:role>
</gmd:CI_ResponsibleParty>', '2016-04-06T17:57:47', '2016-04-06T17:57:47', 0, NULL, NULL, 0, 0, 'gmd:CI_ResponsibleParty', 'iso19139', NULL, 's', 'n', NULL, NULL, 1, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', '90ac7f60-29d7-4079-ac31-0b7bbb9fc872');
INSERT INTO metadata VALUES (937, '<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gml="http://www.opengis.net/gml" xmlns:geonet="http://www.fao.org/geonetwork">
  <gmd:fileIdentifier>
    <gco:CharacterString>c034cd24-3eb4-4530-b3ed-0e250d476bba</gco:CharacterString>
  </gmd:fileIdentifier>
  <gmd:language>
    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
  </gmd:language>
  <gmd:characterSet>
    <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" />
  </gmd:characterSet>
  <gmd:hierarchyLevel>
    <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
  </gmd:hierarchyLevel>
  <gmd:hierarchyLevelName>
    <gco:CharacterString>Série de données</gco:CharacterString>
  </gmd:hierarchyLevelName>
  <gmd:contact>
    <gmd:CI_ResponsibleParty>
      <gmd:organisationName>
        <gco:CharacterString>-- Nom du point de contact des métadonnées --</gco:CharacterString>
      </gmd:organisationName>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:electronicMailAddress>
                <gco:CharacterString>-- Adresse email --</gco:CharacterString>
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact" />
      </gmd:role>
    </gmd:CI_ResponsibleParty>
  </gmd:contact>
  <gmd:dateStamp>
    <gco:DateTime>2013-03-27T16:07:26</gco:DateTime>
  </gmd:dateStamp>
  <gmd:metadataStandardName>
    <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
  </gmd:metadataStandardName>
  <gmd:metadataStandardVersion>
    <gco:CharacterString>1.0</gco:CharacterString>
  </gmd:metadataStandardVersion>
  <gmd:identificationInfo>
    <gmd:MD_DataIdentification>
      <gmd:citation>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>Modèle pour la saisie d''une métadonnée de dispositif de collecte</gco:CharacterString>
          </gmd:title>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>2011-01-01</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="creation" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
        </gmd:CI_Citation>
      </gmd:citation>
      <gmd:abstract>
        <gco:CharacterString>-- Court résumé explicatif du contenu de la ressource --</gco:CharacterString>
      </gmd:abstract>
      <gmd:pointOfContact>
        <gmd:CI_ResponsibleParty>
          <gmd:organisationName>
            <gco:CharacterString>-- Nom de l''organisation responsable de la série de données --</gco:CharacterString>
          </gmd:organisationName>
          <gmd:contactInfo>
            <gmd:CI_Contact>
              <gmd:address>
                <gmd:CI_Address>
                  <gmd:electronicMailAddress>
                    <gco:CharacterString>-- Adresse email --</gco:CharacterString>
                  </gmd:electronicMailAddress>
                </gmd:CI_Address>
              </gmd:address>
            </gmd:CI_Contact>
          </gmd:contactInfo>
          <gmd:role>
            <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="owner" />
          </gmd:role>
        </gmd:CI_ResponsibleParty>
      </gmd:pointOfContact>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2008-06-01</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xlink:href="http://localhost:8080/geosource/srv/fre/thesaurus.download?ref=external.theme.inspire-theme">geonetwork.thesaurus.external.theme.inspire-theme</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:keyword>
            <gco:CharacterString>-- Mots-clé complémentaire (facultatif) --</gco:CharacterString>
          </gmd:keyword>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:resourceConstraints>
        <gmd:MD_LegalConstraints>
          <gmd:accessConstraints>
            <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions" />
          </gmd:accessConstraints>
          <gmd:otherConstraints>
            <gco:CharacterString>-- Restrictions d''accès public au sens INSPIRE (dans ce cas, la valeur ''Autres restrictions'' doit obligatoirement être sélectionnée dans les contraintes d''accès) --</gco:CharacterString>
          </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:resourceConstraints>
        <gmd:MD_Constraints>
          <gmd:useLimitation>
            <gco:CharacterString>-- Conditions applicables à l''accès et à l''utilisation de la série de données --</gco:CharacterString>
          </gmd:useLimitation>
        </gmd:MD_Constraints>
      </gmd:resourceConstraints>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:distance>
            <gco:Distance uom="m" />
          </gmd:distance>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:equivalentScale>
            <gmd:MD_RepresentativeFraction>
              <gmd:denominator>
                <gco:Integer />
              </gmd:denominator>
            </gmd:MD_RepresentativeFraction>
          </gmd:equivalentScale>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:language>
        <gco:CharacterString>fre</gco:CharacterString>
      </gmd:language>
      <gmd:topicCategory>
        <gmd:MD_TopicCategoryCode>environment</gmd:MD_TopicCategoryCode>
      </gmd:topicCategory>
      <gmd:extent>
        <gmd:EX_Extent>
          <gmd:geographicElement>
            <gmd:EX_GeographicBoundingBox>
              <gmd:westBoundLongitude>
                <gco:Decimal>-5.79028</gco:Decimal>
              </gmd:westBoundLongitude>
              <gmd:eastBoundLongitude>
                <gco:Decimal>9.56222</gco:Decimal>
              </gmd:eastBoundLongitude>
              <gmd:southBoundLatitude>
                <gco:Decimal>41.3649</gco:Decimal>
              </gmd:southBoundLatitude>
              <gmd:northBoundLatitude>
                <gco:Decimal>51.0911</gco:Decimal>
              </gmd:northBoundLatitude>
            </gmd:EX_GeographicBoundingBox>
          </gmd:geographicElement>
          <gmd:temporalElement xmlns:gn="http://www.fao.org/geonetwork">
            <gmd:EX_TemporalExtent>
              <gmd:extent>
                <gml:TimePeriod gml:id="">
                  <gml:beginPosition />
                </gml:TimePeriod>
              </gmd:extent>
            </gmd:EX_TemporalExtent>
          </gmd:temporalElement>
        </gmd:EX_Extent>
      </gmd:extent>
    </gmd:MD_DataIdentification>
  </gmd:identificationInfo>
  <gmd:distributionInfo>
    <gmd:MD_Distribution>
      <gmd:distributionFormat>
        <gmd:MD_Format>
          <gmd:name>
            <gco:CharacterString>-- Description du ou des concepts en language machine spécifiant la représentation des objets de données dans un enregistrement, un fichier, un message, un dispositif de stockage ou un canal de transmission --</gco:CharacterString>
          </gmd:name>
          <gmd:version>
            <gco:CharacterString>-- Version de l''encodage --</gco:CharacterString>
          </gmd:version>
        </gmd:MD_Format>
      </gmd:distributionFormat>
      <gmd:transferOptions>
        <gmd:MD_DigitalTransferOptions>
          <gmd:onLine>
            <gmd:CI_OnlineResource>
              <gmd:linkage>
                <gmd:URL>-- Lien vers la ressource décrite elle-même, et/ou vers des informations complémentaires la concernant --</gmd:URL>
              </gmd:linkage>
            </gmd:CI_OnlineResource>
          </gmd:onLine>
        </gmd:MD_DigitalTransferOptions>
      </gmd:transferOptions>
    </gmd:MD_Distribution>
  </gmd:distributionInfo>
  <gmd:dataQualityInfo>
    <gmd:DQ_DataQuality>
      <gmd:scope>
        <gmd:DQ_Scope>
          <gmd:level>
            <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
          </gmd:level>
        </gmd:DQ_Scope>
      </gmd:scope>
      <gmd:report>
        <gmd:DQ_DomainConsistency>
          <gmd:result>
            <gmd:DQ_ConformanceResult>
              <gmd:specification>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>-- Référence des règles de mise en oeuvre adoptées en vertu de l’article 7, paragraphe 1, de la directive 2007/2/CE ou des autres spécifications auxquelles la ressource est conforme --</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2000-01-01</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                </gmd:CI_Citation>
              </gmd:specification>
              <gmd:explanation>
                <gco:CharacterString>-- Information complémentaire sur la conformité (non INSPIRE) --</gco:CharacterString>
              </gmd:explanation>
              undefined
            </gmd:DQ_ConformanceResult>
          </gmd:result>
        </gmd:DQ_DomainConsistency>
      </gmd:report>
      <gmd:lineage>
        <gmd:LI_Lineage>
          <gmd:statement>
            <gco:CharacterString>-- Historique du traitement et/ou de la qualité générale de la série de
données géographiques --</gco:CharacterString>
          </gmd:statement>
        </gmd:LI_Lineage>
      </gmd:lineage>
    </gmd:DQ_DataQuality>
  </gmd:dataQualityInfo>
</gmd:MD_Metadata>', '2016-04-25T15:00:08', '2016-04-06T17:57:46', 0, NULL, NULL, 0, 0, 'gmd:MD_Metadata', 'iso19139', NULL, 'y', 'n', NULL, NULL, 1, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', 'a7796114-fef4-4df9-93bf-35032e31a487');
INSERT INTO metadata VALUES (936, '<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gml="http://www.opengis.net/gml" xmlns:geonet="http://www.fao.org/geonetwork">
  <gmd:fileIdentifier>
    <gco:CharacterString>c034cd24-3eb4-4530-b3ed-0e250d476bba</gco:CharacterString>
  </gmd:fileIdentifier>
  <gmd:language>
    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
  </gmd:language>
  <gmd:characterSet>
    <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" />
  </gmd:characterSet>
  <gmd:hierarchyLevel>
    <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
  </gmd:hierarchyLevel>
  <gmd:hierarchyLevelName>
    <gco:CharacterString>Série de données</gco:CharacterString>
  </gmd:hierarchyLevelName>
  <gmd:contact>
    <gmd:CI_ResponsibleParty>
      <gmd:organisationName>
        <gco:CharacterString>-- Nom du point de contact des métadonnées --</gco:CharacterString>
      </gmd:organisationName>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:electronicMailAddress>
                <gco:CharacterString>-- Adresse email --</gco:CharacterString>
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact" />
      </gmd:role>
    </gmd:CI_ResponsibleParty>
  </gmd:contact>
  <gmd:dateStamp>
    <gco:DateTime>2013-03-27T16:07:26</gco:DateTime>
  </gmd:dateStamp>
  <gmd:metadataStandardName>
    <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
  </gmd:metadataStandardName>
  <gmd:metadataStandardVersion>
    <gco:CharacterString>1.0</gco:CharacterString>
  </gmd:metadataStandardVersion>
  <gmd:identificationInfo>
    <gmd:MD_DataIdentification>
      <gmd:citation>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>Modèle pour la saisie d''une métadonnée de jeu de données</gco:CharacterString>
          </gmd:title>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>2011-01-01</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="creation" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
        </gmd:CI_Citation>
      </gmd:citation>
      <gmd:abstract>
        <gco:CharacterString>-- Court résumé explicatif du contenu de la ressource --</gco:CharacterString>
      </gmd:abstract>
      <gmd:pointOfContact>
        <gmd:CI_ResponsibleParty>
          <gmd:organisationName>
            <gco:CharacterString>-- Nom de l''organisation responsable de la série de données --</gco:CharacterString>
          </gmd:organisationName>
          <gmd:contactInfo>
            <gmd:CI_Contact>
              <gmd:address>
                <gmd:CI_Address>
                  <gmd:electronicMailAddress>
                    <gco:CharacterString>-- Adresse email --</gco:CharacterString>
                  </gmd:electronicMailAddress>
                </gmd:CI_Address>
              </gmd:address>
            </gmd:CI_Contact>
          </gmd:contactInfo>
          <gmd:role>
            <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="owner" />
          </gmd:role>
        </gmd:CI_ResponsibleParty>
      </gmd:pointOfContact>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2008-06-01</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xlink:href="http://localhost:8080/geosource/srv/fre/thesaurus.download?ref=external.theme.inspire-theme">geonetwork.thesaurus.external.theme.inspire-theme</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:keyword>
            <gco:CharacterString>-- Mots-clé complémentaire (facultatif) --</gco:CharacterString>
          </gmd:keyword>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:resourceConstraints>
        <gmd:MD_LegalConstraints>
          <gmd:accessConstraints>
            <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions" />
          </gmd:accessConstraints>
          <gmd:otherConstraints>
            <gco:CharacterString>-- Restrictions d''accès public au sens INSPIRE (dans ce cas, la valeur ''Autres restrictions'' doit obligatoirement être sélectionnée dans les contraintes d''accès) --</gco:CharacterString>
          </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:resourceConstraints>
        <gmd:MD_Constraints>
          <gmd:useLimitation>
            <gco:CharacterString>-- Conditions applicables à l''accès et à l''utilisation de la série de données --</gco:CharacterString>
          </gmd:useLimitation>
        </gmd:MD_Constraints>
      </gmd:resourceConstraints>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:distance>
            <gco:Distance uom="m" />
          </gmd:distance>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:equivalentScale>
            <gmd:MD_RepresentativeFraction>
              <gmd:denominator>
                <gco:Integer />
              </gmd:denominator>
            </gmd:MD_RepresentativeFraction>
          </gmd:equivalentScale>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:language>
        <gco:CharacterString>fre</gco:CharacterString>
      </gmd:language>
      <gmd:topicCategory>
        <gmd:MD_TopicCategoryCode>environment</gmd:MD_TopicCategoryCode>
      </gmd:topicCategory>
      <gmd:extent>
        <gmd:EX_Extent>
          <gmd:geographicElement>
            <gmd:EX_GeographicBoundingBox>
              <gmd:westBoundLongitude>
                <gco:Decimal>-5.79028</gco:Decimal>
              </gmd:westBoundLongitude>
              <gmd:eastBoundLongitude>
                <gco:Decimal>9.56222</gco:Decimal>
              </gmd:eastBoundLongitude>
              <gmd:southBoundLatitude>
                <gco:Decimal>41.3649</gco:Decimal>
              </gmd:southBoundLatitude>
              <gmd:northBoundLatitude>
                <gco:Decimal>51.0911</gco:Decimal>
              </gmd:northBoundLatitude>
            </gmd:EX_GeographicBoundingBox>
          </gmd:geographicElement>
          <gmd:temporalElement xmlns:gn="http://www.fao.org/geonetwork">
            <gmd:EX_TemporalExtent>
              <gmd:extent>
                <gml:TimePeriod gml:id="">
                  <gml:beginPosition />
                </gml:TimePeriod>
              </gmd:extent>
            </gmd:EX_TemporalExtent>
          </gmd:temporalElement>
        </gmd:EX_Extent>
      </gmd:extent>
    </gmd:MD_DataIdentification>
  </gmd:identificationInfo>
  <gmd:distributionInfo>
    <gmd:MD_Distribution>
      <gmd:distributionFormat>
        <gmd:MD_Format>
          <gmd:name>
            <gco:CharacterString>-- Description du ou des concepts en language machine spécifiant la représentation des objets de données dans un enregistrement, un fichier, un message, un dispositif de stockage ou un canal de transmission --</gco:CharacterString>
          </gmd:name>
          <gmd:version>
            <gco:CharacterString>-- Version de l''encodage --</gco:CharacterString>
          </gmd:version>
        </gmd:MD_Format>
      </gmd:distributionFormat>
      <gmd:transferOptions>
        <gmd:MD_DigitalTransferOptions>
          <gmd:onLine>
            <gmd:CI_OnlineResource>
              <gmd:linkage>
                <gmd:URL>-- Lien vers la ressource décrite elle-même, et/ou vers des informations complémentaires la concernant --</gmd:URL>
              </gmd:linkage>
            </gmd:CI_OnlineResource>
          </gmd:onLine>
        </gmd:MD_DigitalTransferOptions>
      </gmd:transferOptions>
    </gmd:MD_Distribution>
  </gmd:distributionInfo>
  <gmd:dataQualityInfo>
    <gmd:DQ_DataQuality>
      <gmd:scope>
        <gmd:DQ_Scope>
          <gmd:level>
            <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
          </gmd:level>
        </gmd:DQ_Scope>
      </gmd:scope>
      <gmd:report>
        <gmd:DQ_DomainConsistency>
          <gmd:result>
            <gmd:DQ_ConformanceResult>
              <gmd:specification>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>-- Référence des règles de mise en oeuvre adoptées en vertu de l’article 7, paragraphe 1, de la directive 2007/2/CE ou des autres spécifications auxquelles la ressource est conforme --</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2000-01-01</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                </gmd:CI_Citation>
              </gmd:specification>
              <gmd:explanation>
                <gco:CharacterString>-- Information complémentaire sur la conformité (non INSPIRE) --</gco:CharacterString>
              </gmd:explanation>
              undefined
            </gmd:DQ_ConformanceResult>
          </gmd:result>
        </gmd:DQ_DomainConsistency>
      </gmd:report>
      <gmd:lineage>
        <gmd:LI_Lineage>
          <gmd:statement>
            <gco:CharacterString>-- Historique du traitement et/ou de la qualité générale de la série de
données géographiques --</gco:CharacterString>
          </gmd:statement>
        </gmd:LI_Lineage>
      </gmd:lineage>
    </gmd:DQ_DataQuality>
  </gmd:dataQualityInfo>
</gmd:MD_Metadata>', '2016-04-25T15:00:20', '2016-04-06T17:57:46', 0, NULL, NULL, 0, 0, 'gmd:MD_Metadata', 'iso19139', NULL, 'y', 'n', NULL, NULL, 1, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', 'a7796114-fef4-4df9-93bf-35032e31a486');
INSERT INTO metadata VALUES (1367, '<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gml="http://www.opengis.net/gml" xmlns:geonet="http://www.fao.org/geonetwork">
  <gmd:fileIdentifier>
    <gco:CharacterString>c034cd24-3eb4-4530-b3ed-0e250d476bba</gco:CharacterString>
  </gmd:fileIdentifier>
  <gmd:language>
    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
  </gmd:language>
  <gmd:characterSet>
    <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" />
  </gmd:characterSet>
  <gmd:hierarchyLevel>
    <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
  </gmd:hierarchyLevel>
  <gmd:hierarchyLevelName>
    <gco:CharacterString>Série de données</gco:CharacterString>
  </gmd:hierarchyLevelName>
  <gmd:contact>
    <gmd:CI_ResponsibleParty>
      <gmd:organisationName>
        <gco:CharacterString>-- Nom du point de contact des métadonnées --</gco:CharacterString>
      </gmd:organisationName>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:electronicMailAddress>
                <gco:CharacterString>-- Adresse email --</gco:CharacterString>
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact" />
      </gmd:role>
    </gmd:CI_ResponsibleParty>
  </gmd:contact>
  <gmd:dateStamp>
    <gco:DateTime>2016-04-07T18:08:20</gco:DateTime>
  </gmd:dateStamp>
  <gmd:metadataStandardName>
    <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
  </gmd:metadataStandardName>
  <gmd:metadataStandardVersion>
    <gco:CharacterString>1.0</gco:CharacterString>
  </gmd:metadataStandardVersion>
  <gmd:identificationInfo>
    <gmd:MD_DataIdentification>
      <gmd:citation>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>métadonnée pour les jdd tests</gco:CharacterString>
          </gmd:title>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>2011-01-01</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="creation" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
          <gmd:identifier>
            <gmd:MD_Identifier>
              <gmd:code>
                <gco:CharacterString>http://localhost:8080/geosource/metadata/srv/c034cd24-3eb4-4530-b3ed-0e250d476bba.xml</gco:CharacterString>
              </gmd:code>
            </gmd:MD_Identifier>
          </gmd:identifier>
        </gmd:CI_Citation>
      </gmd:citation>
      <gmd:abstract>
        <gco:CharacterString>-- Court résumé explicatif du contenu de la ressource --</gco:CharacterString>
      </gmd:abstract>
      <gmd:pointOfContact>
        <gmd:CI_ResponsibleParty>
          <gmd:organisationName>
            <gco:CharacterString>-- Nom de l''organisation responsable de la série de données --</gco:CharacterString>
          </gmd:organisationName>
          <gmd:contactInfo>
            <gmd:CI_Contact>
              <gmd:address>
                <gmd:CI_Address>
                  <gmd:electronicMailAddress>
                    <gco:CharacterString>-- Adresse email --</gco:CharacterString>
                  </gmd:electronicMailAddress>
                </gmd:CI_Address>
              </gmd:address>
            </gmd:CI_Contact>
          </gmd:contactInfo>
          <gmd:role>
            <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="owner" />
          </gmd:role>
        </gmd:CI_ResponsibleParty>
      </gmd:pointOfContact>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2008-06-01</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xlink:href="http://localhost:8080/geosource/srv/fre/thesaurus.download?ref=external.theme.inspire-theme">geonetwork.thesaurus.external.theme.inspire-theme</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:keyword>
            <gco:CharacterString>-- Mots-clé complémentaire (facultatif) --</gco:CharacterString>
          </gmd:keyword>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:resourceConstraints>
        <gmd:MD_LegalConstraints>
          <gmd:accessConstraints>
            <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions" />
          </gmd:accessConstraints>
          <gmd:otherConstraints>
            <gco:CharacterString>-- Restrictions d''accès public au sens INSPIRE (dans ce cas, la valeur ''Autres restrictions'' doit obligatoirement être sélectionnée dans les contraintes d''accès) --</gco:CharacterString>
          </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:resourceConstraints>
        <gmd:MD_Constraints>
          <gmd:useLimitation>
            <gco:CharacterString>-- Conditions applicables à l''accès et à l''utilisation de la série de données --</gco:CharacterString>
          </gmd:useLimitation>
        </gmd:MD_Constraints>
      </gmd:resourceConstraints>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:distance>
            <gco:Distance uom="m" />
          </gmd:distance>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:equivalentScale>
            <gmd:MD_RepresentativeFraction>
              <gmd:denominator>
                <gco:Integer />
              </gmd:denominator>
            </gmd:MD_RepresentativeFraction>
          </gmd:equivalentScale>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:language>
        <gco:CharacterString>fre</gco:CharacterString>
      </gmd:language>
      <gmd:topicCategory>
        <gmd:MD_TopicCategoryCode>environment</gmd:MD_TopicCategoryCode>
      </gmd:topicCategory>
      <gmd:extent>
        <gmd:EX_Extent>
          <gmd:geographicElement>
            <gmd:EX_GeographicBoundingBox>
              <gmd:westBoundLongitude>
                <gco:Decimal>-5.79028</gco:Decimal>
              </gmd:westBoundLongitude>
              <gmd:eastBoundLongitude>
                <gco:Decimal>9.56222</gco:Decimal>
              </gmd:eastBoundLongitude>
              <gmd:southBoundLatitude>
                <gco:Decimal>41.3649</gco:Decimal>
              </gmd:southBoundLatitude>
              <gmd:northBoundLatitude>
                <gco:Decimal>51.0911</gco:Decimal>
              </gmd:northBoundLatitude>
            </gmd:EX_GeographicBoundingBox>
          </gmd:geographicElement>
          <gmd:temporalElement xmlns:gn="http://www.fao.org/geonetwork">
            <gmd:EX_TemporalExtent>
              <gmd:extent>
                <gml:TimePeriod gml:id="d1788e351a1052958">
                  <gml:beginPosition />
                </gml:TimePeriod>
              </gmd:extent>
            </gmd:EX_TemporalExtent>
          </gmd:temporalElement>
        </gmd:EX_Extent>
      </gmd:extent>
    </gmd:MD_DataIdentification>
  </gmd:identificationInfo>
  <gmd:distributionInfo>
    <gmd:MD_Distribution>
      <gmd:distributionFormat>
        <gmd:MD_Format>
          <gmd:name>
            <gco:CharacterString>-- Description du ou des concepts en language machine spécifiant la représentation des objets de données dans un enregistrement, un fichier, un message, un dispositif de stockage ou un canal de transmission --</gco:CharacterString>
          </gmd:name>
          <gmd:version>
            <gco:CharacterString>-- Version de l''encodage --</gco:CharacterString>
          </gmd:version>
        </gmd:MD_Format>
      </gmd:distributionFormat>
      <gmd:transferOptions>
        <gmd:MD_DigitalTransferOptions>
          <gmd:onLine>
            <gmd:CI_OnlineResource>
              <gmd:linkage>
                <gmd:URL>-- Lien vers la ressource décrite elle-même, et/ou vers des informations complémentaires la concernant --</gmd:URL>
              </gmd:linkage>
            </gmd:CI_OnlineResource>
          </gmd:onLine>
        </gmd:MD_DigitalTransferOptions>
      </gmd:transferOptions>
    </gmd:MD_Distribution>
  </gmd:distributionInfo>
  <gmd:dataQualityInfo>
    <gmd:DQ_DataQuality>
      <gmd:scope>
        <gmd:DQ_Scope>
          <gmd:level>
            <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
          </gmd:level>
        </gmd:DQ_Scope>
      </gmd:scope>
      <gmd:report>
        <gmd:DQ_DomainConsistency>
          <gmd:result>
            <gmd:DQ_ConformanceResult>
              <gmd:specification>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>-- Référence des règles de mise en oeuvre adoptées en vertu de l’article 7, paragraphe 1, de la directive 2007/2/CE ou des autres spécifications auxquelles la ressource est conforme --</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2000-01-01</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                </gmd:CI_Citation>
              </gmd:specification>
              <gmd:explanation>
                <gco:CharacterString>-- Information complémentaire sur la conformité (non INSPIRE) --</gco:CharacterString>
              </gmd:explanation>
            </gmd:DQ_ConformanceResult>
          </gmd:result>
        </gmd:DQ_DomainConsistency>
      </gmd:report>
      <gmd:lineage>
        <gmd:LI_Lineage>
          <gmd:statement>
            <gco:CharacterString>-- Historique du traitement et/ou de la qualité générale de la série de
données géographiques --</gco:CharacterString>
          </gmd:statement>
        </gmd:LI_Lineage>
      </gmd:lineage>
    </gmd:DQ_DataQuality>
  </gmd:dataQualityInfo>
</gmd:MD_Metadata>', '2016-04-07T18:08:20', '2016-04-07T18:05:26', 0, NULL, NULL, 1, 0, NULL, 'iso19139', NULL, 'n', 'n', NULL, NULL, 2, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', 'c034cd24-3eb4-4530-b3ed-0e250d476bba');
INSERT INTO metadata VALUES (29533, '<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:geonet="http://www.fao.org/geonetwork">
  <gmd:fileIdentifier>
    <gco:CharacterString>461ec9d0-60e6-4872-b4e5-e517645120be</gco:CharacterString>
  </gmd:fileIdentifier>
  <gmd:language>
    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
  </gmd:language>
  <gmd:characterSet>
    <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" />
  </gmd:characterSet>
  <gmd:hierarchyLevel>
    <gmd:MD_ScopeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" codeListValue="dispositifDeCollecte" />
  </gmd:hierarchyLevel>
  <gmd:contact>
    <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
      <gmd:individualName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:individualName>
      <gmd:organisationName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:organisationName>
      <gmd:positionName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:positionName>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:phone>
            <gmd:CI_Telephone>
              <gmd:voice gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:voice>
              <gmd:facsimile gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:facsimile>
            </gmd:CI_Telephone>
          </gmd:phone>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:deliveryPoint gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:deliveryPoint>
              <gmd:city gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:city>
              <gmd:administrativeArea gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:administrativeArea>
              <gmd:postalCode gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:postalCode>
              <gmd:country gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:country>
              <gmd:electronicMailAddress gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeListValue="pointOfContact" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" />
      </gmd:role>
    </sinp:CI_ResponsibleParty>
  </gmd:contact>
  <gmd:dateStamp>
    <gco:DateTime>2015-11-27T17:42:46</gco:DateTime>
  </gmd:dateStamp>
  <gmd:metadataStandardName>
    <gco:CharacterString>ISO 19115:2003/19139 - Profil SINP</gco:CharacterString>
  </gmd:metadataStandardName>
  <gmd:metadataStandardVersion>
    <gco:CharacterString>1.0</gco:CharacterString>
  </gmd:metadataStandardVersion>
  <gmd:identificationInfo>
    <sinp:DispositifIdentification gco:isoType="gmd:MD_DataIdentification">
      <gmd:citation>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>Modèle de saisir pour un dispositif de collecte</gco:CharacterString>
          </gmd:title>
          <gmd:alternateTitle>
            <gco:CharacterString>Nom usuel</gco:CharacterString>
          </gmd:alternateTitle>
          <gmd:identifier>
            <gmd:MD_Identifier>
              <gmd:code>
                <gco:CharacterString>Identifiant</gco:CharacterString>
              </gmd:code>
            </gmd:MD_Identifier>
          </gmd:identifier>
        </gmd:CI_Citation>
      </gmd:citation>
      <gmd:abstract>
        <gco:CharacterString>Résumé</gco:CharacterString>
      </gmd:abstract>
      <gmd:purpose>
        <gco:CharacterString>Objectifs scientifiques</gco:CharacterString>
      </gmd:purpose>
      <gmd:status>
        <gmd:MD_ProgressCode codeListValue="onGoing" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ProgressCode" />
      </gmd:status>
      <gmd:pointOfContact>
        <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
          <gmd:individualName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:individualName>
          <gmd:organisationName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:organisationName>
          <gmd:positionName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:positionName>
          <gmd:contactInfo>
            <gmd:CI_Contact>
              <gmd:phone>
                <gmd:CI_Telephone>
                  <gmd:voice gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:voice>
                  <gmd:facsimile gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:facsimile>
                </gmd:CI_Telephone>
              </gmd:phone>
              <gmd:address>
                <gmd:CI_Address>
                  <gmd:deliveryPoint gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:deliveryPoint>
                  <gmd:city gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:city>
                  <gmd:administrativeArea gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:administrativeArea>
                  <gmd:postalCode gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:postalCode>
                  <gmd:country gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:country>
                  <gmd:electronicMailAddress gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:electronicMailAddress>
                </gmd:CI_Address>
              </gmd:address>
            </gmd:CI_Contact>
          </gmd:contactInfo>
          <gmd:role>
            <gmd:CI_RoleCode codeListValue="originator" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" />
          </gmd:role>
        </sinp:CI_ResponsibleParty>
      </gmd:pointOfContact>
      <gmd:resourceMaintenance>
        <gmd:MD_MaintenanceInformation>
          <gmd:maintenanceAndUpdateFrequency>
            <gmd:MD_MaintenanceFrequencyCode codeListValue="asNeeded" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode" />
          </gmd:maintenanceAndUpdateFrequency>
          <gmd:maintenanceNote>
            <gco:CharacterString />
          </gmd:maintenanceNote>
        </gmd:MD_MaintenanceInformation>
      </gmd:resourceMaintenance>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Volet SINP</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-volet">geonetwork.thesaurus.external.theme.sinp-volet</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Type de dispositif</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-de-dispositif">geonetwork.thesaurus.external.theme.sinp-type-de-dispositif</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Niveau territorial</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-niveau-territorial">geonetwork.thesaurus.external.theme.sinp-niveau-territorial</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="" codeListValue="place" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Cible géographique</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.place.sinp-cible-geographique">geonetwork.thesaurus.external.place.sinp-cible-geographique</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Type d''espace concerné</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-espace">geonetwork.thesaurus.external.theme.sinp-type-espace</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:keyword>
            <gco:CharacterString>Autres mots clés</gco:CharacterString>
          </gmd:keyword>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme" />
          </gmd:type>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Type de financement</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-de-financement">geonetwork.thesaurus.external.theme.sinp-type-de-financement</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Plan d''échantillonnage</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-plan-d-echantillonnage">geonetwork.thesaurus.external.theme.sinp-plan-d-echantillonnage</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels Milieux</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-milieux">geonetwork.thesaurus.external.theme.sinp-referentiels-milieux</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels taxonomiques</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-taxonomiques">geonetwork.thesaurus.external.theme.sinp-referentiels-taxonomiques</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels Cartographiques</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-cartographiques">geonetwork.thesaurus.external.theme.sinp-referentiels-cartographiques</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:aggregationInfo>
        <gmd:MD_AggregateInformation>
          <gmd:aggregateDataSetName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Titre de l’ouvrage ou de l’article.</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:edition>
                <gco:CharacterString>Volume et numéro éventuel de la revue / périodique.</gco:CharacterString>
              </gmd:edition>
              <gmd:editionDate>
                <gco:Date>2016</gco:Date>
              </gmd:editionDate>
              <gmd:citedResponsibleParty>
                <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
                  <gmd:individualName>
                    <gco:CharacterString>Nom de l’auteur ou noms des co-auteurs</gco:CharacterString>
                  </gmd:individualName>
                  <gmd:contactInfo>
                    <gmd:CI_Contact>
                      <gmd:address>
                        <gmd:CI_Address />
                      </gmd:address>
                    </gmd:CI_Contact>
                  </gmd:contactInfo>
                  <gmd:role>
                    <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="author" />
                  </gmd:role>
                  <sinp:scopeDescription>
                    <sinp:ResponsiblePartyScopeCode codeList="" codeListValue="" />
                  </sinp:scopeDescription>
                </sinp:CI_ResponsibleParty>
              </gmd:citedResponsibleParty>
              <gmd:series>
                <gmd:CI_Series>
                  <gmd:name>
                    <gco:CharacterString>Uniquement s’il s’agit d’un article.</gco:CharacterString>
                  </gmd:name>
                  <gmd:issueIdentification>
                    <gco:CharacterString>A renseigner si la publication est récurrente (annuelle, mensuelle, hebdomadaire, etc.)</gco:CharacterString>
                  </gmd:issueIdentification>
                  <gmd:page>
                    <gco:CharacterString>Nombre de pages de l’ouvrage ou pages de la publication dans la revue / périodique.</gco:CharacterString>
                  </gmd:page>
                </gmd:CI_Series>
              </gmd:series>
            </gmd:CI_Citation>
          </gmd:aggregateDataSetName>
          <gmd:associationType>
            <gmd:DS_AssociationTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#DS_AssociationTypeCode" codeListValue="publication" />
          </gmd:associationType>
        </gmd:MD_AggregateInformation>
      </gmd:aggregationInfo>
      <gmd:language>
        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
      </gmd:language>
      <gmd:topicCategory>
        <gmd:MD_TopicCategoryCode>environment</gmd:MD_TopicCategoryCode>
      </gmd:topicCategory>
      <gmd:extent>
        <gmd:EX_Extent>
          <gmd:description>
            <gco:CharacterString>Emprise réelle et effective du territoire couvert</gco:CharacterString>
          </gmd:description>
          <gmd:temporalElement>
            <gmd:EX_TemporalExtent>
              <gmd:extent>
                <gml:TimePeriod gml:id="d16032e284a1052958">
                  <gml:beginPosition />
                  <gml:endPosition />
                </gml:TimePeriod>
              </gmd:extent>
            </gmd:EX_TemporalExtent>
          </gmd:temporalElement>
        </gmd:EX_Extent>
      </gmd:extent>
      <gmd:supplementalInformation gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:supplementalInformation>
    </sinp:DispositifIdentification>
  </gmd:identificationInfo>
  <gmd:dataQualityInfo>
    <gmd:DQ_DataQuality>
      <gmd:scope>
        <gmd:DQ_Scope>
          <gmd:level>
            <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
          </gmd:level>
        </gmd:DQ_Scope>
      </gmd:scope>
      <gmd:lineage>
        <gmd:LI_Lineage>
          <gmd:statement gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:statement>
          <gmd:processStep>
            <gmd:LI_ProcessStep>
              <gmd:description>
                <gco:CharacterString>Historique</gco:CharacterString>
              </gmd:description>
              <gmd:dateTime>
                <gco:Date />
              </gmd:dateTime>
            </gmd:LI_ProcessStep>
          </gmd:processStep>
        </gmd:LI_Lineage>
      </gmd:lineage>
    </gmd:DQ_DataQuality>
  </gmd:dataQualityInfo>
</gmd:MD_Metadata>', '2016-05-17T15:40:44', '2016-05-17T15:40:44', 0, NULL, NULL, 0, 0, 'gmd:MD_Metadata', 'iso19139.sinp', NULL, 'y', 'n', NULL, NULL, 1, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', '35f3a373-97d0-4e69-a066-97299266eebc');
INSERT INTO metadata VALUES (29534, '<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:geonet="http://www.fao.org/geonetwork">
  <gmd:fileIdentifier>
    <gco:CharacterString>bb48988d-0f24-42fc-b677-170fa3ef23e2</gco:CharacterString>
  </gmd:fileIdentifier>
  <gmd:language>
    <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
  </gmd:language>
  <gmd:characterSet>
    <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" />
  </gmd:characterSet>
  <gmd:hierarchyLevel>
    <gmd:MD_ScopeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" codeListValue="dataset" />
  </gmd:hierarchyLevel>
  <gmd:contact>
    <sinp:CI_ResponsibleParty uuid="ad19a63a-d86a-41ac-8c86-318ac45baa65" gco:isoType="gmd:CI_ResponsibleParty">
      <gmd:individualName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:individualName>
      <gmd:organisationName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:organisationName>
      <gmd:positionName gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:positionName>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:phone>
            <gmd:CI_Telephone>
              <gmd:voice gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:voice>
              <gmd:facsimile gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:facsimile>
            </gmd:CI_Telephone>
          </gmd:phone>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:deliveryPoint gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:deliveryPoint>
              <gmd:city gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:city>
              <gmd:administrativeArea gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:administrativeArea>
              <gmd:postalCode gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:postalCode>
              <gmd:country gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:country>
              <gmd:electronicMailAddress gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeListValue="pointOfContact" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" />
      </gmd:role>
    </sinp:CI_ResponsibleParty>
  </gmd:contact>
  <gmd:dateStamp>
    <gco:DateTime>2016-02-22T09:50:47</gco:DateTime>
  </gmd:dateStamp>
  <gmd:metadataStandardName>
    <gco:CharacterString>ISO 19115:2003/19139 - Profil SINP</gco:CharacterString>
  </gmd:metadataStandardName>
  <gmd:metadataStandardVersion>
    <gco:CharacterString>1.0</gco:CharacterString>
  </gmd:metadataStandardVersion>
  <gmd:referenceSystemInfo>
    <gmd:MD_ReferenceSystem>
      <gmd:referenceSystemIdentifier>
        <gmd:RS_Identifier>
          <gmd:code>
            <gco:CharacterString>WGS 84 (EPSG:4326)</gco:CharacterString>
          </gmd:code>
          <gmd:codeSpace>
            <gco:CharacterString>EPSG</gco:CharacterString>
          </gmd:codeSpace>
          <gmd:version>
            <gco:CharacterString>7.9</gco:CharacterString>
          </gmd:version>
        </gmd:RS_Identifier>
      </gmd:referenceSystemIdentifier>
    </gmd:MD_ReferenceSystem>
  </gmd:referenceSystemInfo>
  <gmd:identificationInfo>
    <gmd:MD_DataIdentification>
      <gmd:citation>
        <gmd:CI_Citation>
          <gmd:title>
            <gco:CharacterString>Modèle de saisir pour un jeu de données</gco:CharacterString>
          </gmd:title>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>0NaN-NaN-NaN</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeListValue="creation" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>0NaN-NaN-NaN</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
          <gmd:date>
            <gmd:CI_Date>
              <gmd:date>
                <gco:Date>0NaN-NaN-NaN</gco:Date>
              </gmd:date>
              <gmd:dateType>
                <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="revision" />
              </gmd:dateType>
            </gmd:CI_Date>
          </gmd:date>
          <gmd:identifier>
            <gmd:MD_Identifier>
              <gmd:code>
                <gco:CharacterString>Identifiant</gco:CharacterString>
              </gmd:code>
            </gmd:MD_Identifier>
          </gmd:identifier>
        </gmd:CI_Citation>
      </gmd:citation>
      <gmd:abstract>
        <gco:CharacterString>Résumé</gco:CharacterString>
      </gmd:abstract>
      <gmd:purpose>
        <gco:CharacterString>Objectifs scientifiques</gco:CharacterString>
      </gmd:purpose>
      <gmd:status>
        <gmd:MD_ProgressCode codeListValue="onGoing" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ProgressCode" />
      </gmd:status>
      <gmd:pointOfContact>
        <sinp:CI_ResponsibleParty uuid="efc2e1ba-5abc-4a79-a642-ff3c4b700e04" gco:isoType="gmd:CI_ResponsibleParty">
          <gmd:individualName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:individualName>
          <gmd:organisationName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:organisationName>
          <gmd:positionName gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:positionName>
          <gmd:contactInfo>
            <gmd:CI_Contact>
              <gmd:phone>
                <gmd:CI_Telephone>
                  <gmd:voice gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:voice>
                  <gmd:facsimile gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:facsimile>
                </gmd:CI_Telephone>
              </gmd:phone>
              <gmd:address>
                <gmd:CI_Address>
                  <gmd:deliveryPoint gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:deliveryPoint>
                  <gmd:city gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:city>
                  <gmd:administrativeArea gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:administrativeArea>
                  <gmd:postalCode gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:postalCode>
                  <gmd:country gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:country>
                  <gmd:electronicMailAddress gco:nilReason="missing">
                    <gco:CharacterString />
                  </gmd:electronicMailAddress>
                </gmd:CI_Address>
              </gmd:address>
            </gmd:CI_Contact>
          </gmd:contactInfo>
          <gmd:role>
            <gmd:CI_RoleCode codeListValue="originator" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" />
          </gmd:role>
          <sinp:altIndividualName gco:nilReason="missing">
            <gco:CharacterString />
          </sinp:altIndividualName>
          <sinp:responsiblePartyStatus>
            <sinp:ResponsiblePartyStatusCode codeList="" codeListValue="" />
          </sinp:responsiblePartyStatus>
          <sinp:extentDescription gco:nilReason="missing">
            <gco:CharacterString />
          </sinp:extentDescription>
          <sinp:scopeDescription>
            <sinp:ResponsiblePartyScopeCode codeList="" codeListValue="Mer" />
          </sinp:scopeDescription>
          <sinp:history>
            <gmd:LI_ProcessStep>
              <gmd:description gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:description>
              <gmd:dateTime>
                <gco:Date />
              </gmd:dateTime>
            </gmd:LI_ProcessStep>
          </sinp:history>
          <sinp:description gco:nilReason="missing">
            <gco:CharacterString />
          </sinp:description>
          <sinp:relatedResponsibleParty gco:nilReason="missing">
            <gco:CharacterString />
          </sinp:relatedResponsibleParty>
        </sinp:CI_ResponsibleParty>
      </gmd:pointOfContact>
      <gmd:resourceMaintenance>
        <gmd:MD_MaintenanceInformation>
          <gmd:maintenanceAndUpdateFrequency>
            <gmd:MD_MaintenanceFrequencyCode codeListValue="asNeeded" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode" />
          </gmd:maintenanceAndUpdateFrequency>
        </gmd:MD_MaintenanceInformation>
      </gmd:resourceMaintenance>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Thématique SINP</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-thematique">geonetwork.thesaurus.external.theme.sinp-thematique</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2008-06-01</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.inspire-theme">geonetwork.thesaurus.external.theme.inspire-theme</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Type de financement</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-de-financement">geonetwork.thesaurus.external.theme.sinp-type-de-financement</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:keyword>
            <gco:CharacterString>Mots clés</gco:CharacterString>
          </gmd:keyword>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme" />
          </gmd:type>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels taxonomiques</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-taxonomiques">geonetwork.thesaurus.external.theme.sinp-referentiels-taxonomiques</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels Cartographiques</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-cartographiques">geonetwork.thesaurus.external.theme.sinp-referentiels-cartographiques</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels Milieux</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-milieux">geonetwork.thesaurus.external.theme.sinp-referentiels-milieux</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Mode de stockage</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-stockage">geonetwork.thesaurus.external.theme.sinp-stockage</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Mode de diffusion</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-diffusion">geonetwork.thesaurus.external.theme.sinp-diffusion</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Méthode de recueil</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-methode-de-recueil">geonetwork.thesaurus.external.theme.sinp-methode-de-recueil</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Habitats</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-habref">geonetwork.thesaurus.external.theme.sinp-habref</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:descriptiveKeywords>
        <gmd:MD_Keywords>
          <gmd:type>
            <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
          </gmd:type>
          <gmd:thesaurusName>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Référentiels taxonomiques</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>2015-11-27</gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx" xlink:href="http://apps.titellus.net/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-taxonomiques">geonetwork.thesaurus.external.theme.sinp-referentiels-taxonomiques</gmx:Anchor>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:thesaurusName>
        </gmd:MD_Keywords>
      </gmd:descriptiveKeywords>
      <gmd:resourceConstraints>
        <gmd:MD_LegalConstraints>
          <gmd:accessConstraints>
            <gmd:MD_RestrictionCode codeListValue="copyright" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode" />
          </gmd:accessConstraints>
          <gmd:useConstraints>
            <gmd:MD_RestrictionCode codeListValue="otherRestictions" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode" />
          </gmd:useConstraints>
          <gmd:otherConstraints gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
      </gmd:resourceConstraints>
      <gmd:spatialResolution>
        <gmd:MD_Resolution>
          <gmd:equivalentScale>
            <gmd:MD_RepresentativeFraction>
              <gmd:denominator>
                <gco:Integer />
              </gmd:denominator>
            </gmd:MD_RepresentativeFraction>
          </gmd:equivalentScale>
        </gmd:MD_Resolution>
      </gmd:spatialResolution>
      <gmd:language>
        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
      </gmd:language>
      <gmd:characterSet>
        <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode" codeListValue="utf8" />
      </gmd:characterSet>
      <gmd:topicCategory>
        <gmd:MD_TopicCategoryCode>environment</gmd:MD_TopicCategoryCode>
      </gmd:topicCategory>
      <gmd:extent>
        <gmd:EX_Extent>
          <gmd:description>
            <gco:CharacterString>Emprise réelle et effective du territoire couvert</gco:CharacterString>
          </gmd:description>
          <gmd:geographicElement>
            <gmd:EX_GeographicBoundingBox>
              <gmd:westBoundLongitude>
                <gco:Decimal>3</gco:Decimal>
              </gmd:westBoundLongitude>
              <gmd:eastBoundLongitude>
                <gco:Decimal>3</gco:Decimal>
              </gmd:eastBoundLongitude>
              <gmd:southBoundLatitude>
                <gco:Decimal>47</gco:Decimal>
              </gmd:southBoundLatitude>
              <gmd:northBoundLatitude>
                <gco:Decimal>47</gco:Decimal>
              </gmd:northBoundLatitude>
            </gmd:EX_GeographicBoundingBox>
          </gmd:geographicElement>
          <gmd:temporalElement>
            <gmd:EX_TemporalExtent>
              <gmd:extent>
                <gml:TimePeriod gml:id="d16032e284a1052958">
                  <gml:beginPosition frame="#ISO-8601" />
                  <gml:endPosition />
                </gml:TimePeriod>
              </gmd:extent>
            </gmd:EX_TemporalExtent>
          </gmd:temporalElement>
        </gmd:EX_Extent>
      </gmd:extent>
      <gmd:supplementalInformation gco:nilReason="missing">
        <gco:CharacterString />
      </gmd:supplementalInformation>
    </gmd:MD_DataIdentification>
  </gmd:identificationInfo>
  <gmd:distributionInfo>
    <gmd:MD_Distribution>
      <gmd:distributionFormat>
        <gmd:MD_Format>
          <gmd:name>
            <gco:CharacterString>GML</gco:CharacterString>
          </gmd:name>
          <gmd:version>
            <gco:CharacterString>3.2.1</gco:CharacterString>
          </gmd:version>
        </gmd:MD_Format>
      </gmd:distributionFormat>
      <gmd:distributor>
        <gmd:MD_Distributor>
          <gmd:distributorContact>
            <sinp:CI_ResponsibleParty uuid="bae1b90e-b8c4-4774-9c87-cac333542ca1" gco:isoType="gmd:CI_ResponsibleParty">
              <gmd:organisationName gco:nilReason="missing">
                <gco:CharacterString />
              </gmd:organisationName>
              <gmd:contactInfo>
                <gmd:CI_Contact>
                  <gmd:address>
                    <gmd:CI_Address>
                      <gmd:electronicMailAddress gco:nilReason="missing">
                        <gco:CharacterString />
                      </gmd:electronicMailAddress>
                    </gmd:CI_Address>
                  </gmd:address>
                </gmd:CI_Contact>
              </gmd:contactInfo>
              <gmd:role>
                <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode" codeListValue="distributor" />
              </gmd:role>
            </sinp:CI_ResponsibleParty>
          </gmd:distributorContact>
          <gmd:distributorTransferOptions>
            <sinp:MD_DigitalTransferOptions gco:isoType="gmd:MD_DigitalTransferOptions">
              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL>URL d’accès aux données</gmd:URL>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                  </gmd:protocol>
                </gmd:CI_OnlineResource>
              </gmd:onLine>
              <sinp:database>
                <sinp:Database>
                  <sinp:name>
                    <gco:CharacterString>Nom de la base de données</gco:CharacterString>
                  </sinp:name>
                  <sinp:url>
                    <gco:CharacterString>Adresse de la base de données</gco:CharacterString>
                  </sinp:url>
                  <sinp:startYear>
                    <gco:Date>2015</gco:Date>
                  </sinp:startYear>
                </sinp:Database>
              </sinp:database>
            </sinp:MD_DigitalTransferOptions>
          </gmd:distributorTransferOptions>
        </gmd:MD_Distributor>
      </gmd:distributor>
    </gmd:MD_Distribution>
  </gmd:distributionInfo>
  <gmd:dataQualityInfo>
    <gmd:DQ_DataQuality>
      <gmd:scope>
        <gmd:DQ_Scope>
          <gmd:level>
            <gmd:MD_ScopeCode codeListValue="dataset" codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode" />
          </gmd:level>
        </gmd:DQ_Scope>
      </gmd:scope>
      <gmd:report>
        <gmd:DQ_DomainConsistency>
          <gmd:evaluationMethodType>
            <gmd:DQ_EvaluationMethodTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#DQ_EvaluationMethodTypeCode" codeListValue="directInternal" />
          </gmd:evaluationMethodType>
          <gmd:evaluationMethodDescription gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:evaluationMethodDescription>
          <gmd:evaluationProcedure>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Méthode de validation</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date />
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gco:CharacterString>URL du protocol ?</gco:CharacterString>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
            </gmd:CI_Citation>
          </gmd:evaluationProcedure>
        </gmd:DQ_DomainConsistency>
      </gmd:report>
      <gmd:report>
        <gmd:DQ_TopologicalConsistency>
          <gmd:evaluationProcedure>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>Cohérence topologique</gco:CharacterString>
              </gmd:title>
              <gmd:date>
                <gmd:CI_Date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="" />
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>
            </gmd:CI_Citation>
          </gmd:evaluationProcedure>
          <gmd:result>
            <gmd:DQ_QuantitativeResult>
              <gmd:valueType>
                <gco:RecordType>Pourcentage</gco:RecordType>
              </gmd:valueType>
              <gmd:value>
                <gco:Record />
              </gmd:value>
            </gmd:DQ_QuantitativeResult>
          </gmd:result>
        </gmd:DQ_TopologicalConsistency>
      </gmd:report>
      <gmd:lineage>
        <gmd:LI_Lineage>
          <gmd:statement gco:nilReason="missing">
            <gco:CharacterString />
          </gmd:statement>
          <gmd:processStep>
            <gmd:LI_ProcessStep>
              <gmd:description>
                <gco:CharacterString>Date de transformation des données sources</gco:CharacterString>
              </gmd:description>
              <gmd:dateTime>
                <gco:Date />
              </gmd:dateTime>
            </gmd:LI_ProcessStep>
          </gmd:processStep>
        </gmd:LI_Lineage>
      </gmd:lineage>
    </gmd:DQ_DataQuality>
  </gmd:dataQualityInfo>
</gmd:MD_Metadata>', '2016-05-17T15:40:44', '2016-05-17T15:40:44', 0, NULL, NULL, 0, 0, 'gmd:MD_Metadata', 'iso19139.sinp', NULL, 'y', 'n', NULL, NULL, 1, 1, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54', '551bcb1b-9b81-4ce7-8cab-529cdfeee1bb');


--
-- TOC entry 4086 (class 0 OID 27559350)
-- Dependencies: 357
-- Data for Name: metadatacateg; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4087 (class 0 OID 27559353)
-- Dependencies: 358
-- Data for Name: metadatafiledownloads; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4088 (class 0 OID 27559359)
-- Dependencies: 359
-- Data for Name: metadatafileuploads; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4089 (class 0 OID 27559365)
-- Dependencies: 360
-- Data for Name: metadatanotifications; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4090 (class 0 OID 27559371)
-- Dependencies: 361
-- Data for Name: metadatanotifiers; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4091 (class 0 OID 27559377)
-- Dependencies: 362
-- Data for Name: metadatarating; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4092 (class 0 OID 27559380)
-- Dependencies: 363
-- Data for Name: metadatastatus; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4093 (class 0 OID 27559386)
-- Dependencies: 364
-- Data for Name: operationallowed; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO operationallowed VALUES (1, 936, 0);
INSERT INTO operationallowed VALUES (1, 936, 3);
INSERT INTO operationallowed VALUES (1, 941, 0);
INSERT INTO operationallowed VALUES (1, 941, 3);
INSERT INTO operationallowed VALUES (1, 937, 0);
INSERT INTO operationallowed VALUES (1, 937, 3);
INSERT INTO operationallowed VALUES (2, 1367, 0);
INSERT INTO operationallowed VALUES (2, 1367, 3);
INSERT INTO operationallowed VALUES (1, 1367, 1);
INSERT INTO operationallowed VALUES (1, 1367, 0);
INSERT INTO operationallowed VALUES (1, 1367, 5);
INSERT INTO operationallowed VALUES (1, 1367, 6);
INSERT INTO operationallowed VALUES (1, 1367, 3);
INSERT INTO operationallowed VALUES (0, 1367, 1);
INSERT INTO operationallowed VALUES (0, 1367, 0);
INSERT INTO operationallowed VALUES (0, 1367, 5);
INSERT INTO operationallowed VALUES (0, 1367, 6);
INSERT INTO operationallowed VALUES (0, 1367, 3);
INSERT INTO operationallowed VALUES (1, 29533, 0);
INSERT INTO operationallowed VALUES (1, 29533, 3);
INSERT INTO operationallowed VALUES (1, 29534, 0);
INSERT INTO operationallowed VALUES (1, 29534, 3);


--
-- TOC entry 4094 (class 0 OID 27559389)
-- Dependencies: 365
-- Data for Name: operations; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO operations VALUES (0, 'view');
INSERT INTO operations VALUES (1, 'download');
INSERT INTO operations VALUES (2, 'editing');
INSERT INTO operations VALUES (3, 'notify');
INSERT INTO operations VALUES (5, 'dynamic');
INSERT INTO operations VALUES (6, 'featured');


--
-- TOC entry 4095 (class 0 OID 27559392)
-- Dependencies: 366
-- Data for Name: operationsdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO operationsdes VALUES (0, 'Publish', 'eng');
INSERT INTO operationsdes VALUES (1, 'Download', 'eng');
INSERT INTO operationsdes VALUES (2, 'Editing', 'eng');
INSERT INTO operationsdes VALUES (3, 'Notify', 'eng');
INSERT INTO operationsdes VALUES (5, 'Interactive Map', 'eng');
INSERT INTO operationsdes VALUES (6, 'Featured', 'eng');
INSERT INTO operationsdes VALUES (0, 'Publier', 'fre');
INSERT INTO operationsdes VALUES (1, 'Télécharger', 'fre');
INSERT INTO operationsdes VALUES (2, 'Editer', 'fre');
INSERT INTO operationsdes VALUES (3, 'Notifier', 'fre');
INSERT INTO operationsdes VALUES (5, 'Carte interactive', 'fre');
INSERT INTO operationsdes VALUES (6, 'Epingler', 'fre');


--
-- TOC entry 4096 (class 0 OID 27559401)
-- Dependencies: 368
-- Data for Name: relations; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4097 (class 0 OID 27559410)
-- Dependencies: 370
-- Data for Name: schematron; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO schematron VALUES (100, 1, 'schematron-rules-iso.xsl', 'iso19139');
INSERT INTO schematron VALUES (102, 2, 'schematron-rules-inspire.xsl', 'iso19139');
INSERT INTO schematron VALUES (104, 3, 'schematron-rules-geonetwork.xsl', 'iso19139');
INSERT INTO schematron VALUES (106, 4, 'schematron-rules-inspire.disabled.xsl', 'iso19139');
INSERT INTO schematron VALUES (108, 1, 'schematron-rules-iso.xsl', 'iso19139.fra');
INSERT INTO schematron VALUES (110, 2, 'schematron-rules-inspire.xsl', 'iso19139.fra');
INSERT INTO schematron VALUES (112, 3, 'schematron-rules-geonetwork.xsl', 'iso19139.fra');
INSERT INTO schematron VALUES (21943, 1, 'schematron-rules-iso.xsl', 'iso19139.sinp');
INSERT INTO schematron VALUES (21945, 2, 'schematron-rules-geonetwork.xsl', 'iso19139.sinp');
INSERT INTO schematron VALUES (30438, 2, 'schematron-rules-inspire.xsl', 'iso19139.sinp');


--
-- TOC entry 4098 (class 0 OID 27559416)
-- Dependencies: 371
-- Data for Name: schematroncriteria; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO schematroncriteria VALUES (101, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 100);
INSERT INTO schematroncriteria VALUES (103, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 102);
INSERT INTO schematroncriteria VALUES (105, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 104);
INSERT INTO schematroncriteria VALUES (107, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 106);
INSERT INTO schematroncriteria VALUES (109, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 108);
INSERT INTO schematroncriteria VALUES (111, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 110);
INSERT INTO schematroncriteria VALUES (113, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 112);
INSERT INTO schematroncriteria VALUES (21944, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 21943);
INSERT INTO schematroncriteria VALUES (21946, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 21945);
INSERT INTO schematroncriteria VALUES (30439, 'ALWAYS_ACCEPT', NULL, NULL, '_ignored_', '*Generated*', 30438);


--
-- TOC entry 4099 (class 0 OID 27559422)
-- Dependencies: 372
-- Data for Name: schematroncriteriagroup; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 100, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 102, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 104, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 106, 'DISABLED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 108, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 110, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 112, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 21943, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 21945, 'REQUIRED');
INSERT INTO schematroncriteriagroup VALUES ('*Generated*', 30438, 'REQUIRED');


--
-- TOC entry 4100 (class 0 OID 27559428)
-- Dependencies: 373
-- Data for Name: schematrondes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO schematrondes VALUES (100, 'schematron-rules-iso', 'eng');
INSERT INTO schematrondes VALUES (102, 'schematron-rules-inspire', 'eng');
INSERT INTO schematrondes VALUES (104, 'schematron-rules-geonetwork', 'eng');
INSERT INTO schematrondes VALUES (106, 'schematron-rules-inspire', 'eng');
INSERT INTO schematrondes VALUES (108, 'schematron-rules-iso', 'eng');
INSERT INTO schematrondes VALUES (110, 'schematron-rules-inspire', 'eng');
INSERT INTO schematrondes VALUES (112, 'schematron-rules-geonetwork', 'eng');
INSERT INTO schematrondes VALUES (21943, 'schematron-rules-iso', 'eng');
INSERT INTO schematrondes VALUES (21945, 'schematron-rules-geonetwork', 'eng');
INSERT INTO schematrondes VALUES (30438, 'schematron-rules-inspire', 'eng');


--
-- TOC entry 4101 (class 0 OID 27559431)
-- Dependencies: 374
-- Data for Name: serviceparameters; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4102 (class 0 OID 27559437)
-- Dependencies: 375
-- Data for Name: services; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4103 (class 0 OID 27559443)
-- Dependencies: 376
-- Data for Name: settings; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO settings VALUES ('system/site/name', 0, 'n', 110, 'Mon GéoSource');
INSERT INTO settings VALUES ('system/site/organization', 0, 'n', 130, 'Mon organisation');
INSERT INTO settings VALUES ('system/platform/version', 0, 'n', 150, '3.0.1');
INSERT INTO settings VALUES ('system/platform/subVersion', 0, 'n', 160, '0');
INSERT INTO settings VALUES ('system/server/host', 0, 'n', 210, 'localhost');
INSERT INTO settings VALUES ('system/server/protocol', 0, 'n', 220, 'http');
INSERT INTO settings VALUES ('system/server/port', 1, 'n', 230, '8080');
INSERT INTO settings VALUES ('system/server/securePort', 1, 'y', 240, '8443');
INSERT INTO settings VALUES ('system/server/log', 0, 'y', 250, 'log4j.xml');
INSERT INTO settings VALUES ('system/intranet/network', 0, 'y', 310, '127.0.0.1');
INSERT INTO settings VALUES ('system/intranet/netmask', 0, 'y', 320, '255.0.0.0');
INSERT INTO settings VALUES ('system/z3950/enable', 2, 'y', 410, 'true');
INSERT INTO settings VALUES ('system/z3950/port', 1, 'y', 420, '2100');
INSERT INTO settings VALUES ('system/proxy/use', 2, 'y', 510, 'false');
INSERT INTO settings VALUES ('system/feedback/email', 0, 'y', 610, 'root@localhost');
INSERT INTO settings VALUES ('system/feedback/mailServer/host', 0, 'y', 630, '');
INSERT INTO settings VALUES ('system/feedback/mailServer/port', 1, 'y', 640, '25');
INSERT INTO settings VALUES ('system/feedback/mailServer/username', 0, 'y', 642, '');
INSERT INTO settings VALUES ('system/feedback/mailServer/password', 0, 'y', 643, '');
INSERT INTO settings VALUES ('system/feedback/mailServer/ssl', 2, 'y', 641, 'false');
INSERT INTO settings VALUES ('system/removedMetadata/dir', 0, 'y', 710, 'WEB-INF/data/removed');
INSERT INTO settings VALUES ('system/selectionmanager/maxrecords', 1, 'y', 910, '1000');
INSERT INTO settings VALUES ('system/csw/enable', 2, 'y', 1210, 'true');
INSERT INTO settings VALUES ('system/csw/metadataPublic', 2, 'y', 1310, 'false');
INSERT INTO settings VALUES ('system/csw/transactionUpdateCreateXPath', 2, 'y', 1320, 'true');
INSERT INTO settings VALUES ('system/shib/use', 2, 'y', 1710, 'false');
INSERT INTO settings VALUES ('system/shib/path', 0, 'y', 1720, '/geonetwork/srv/en/shib.user.login');
INSERT INTO settings VALUES ('system/shib/username', 0, 'y', 1740, 'REMOTE_USER');
INSERT INTO settings VALUES ('system/shib/surname', 0, 'y', 1750, 'Shib-Person-surname');
INSERT INTO settings VALUES ('system/shib/firstname', 0, 'y', 1760, 'Shib-InetOrgPerson-givenName');
INSERT INTO settings VALUES ('system/shib/profile', 0, 'y', 1770, 'Shib-EP-Entitlement');
INSERT INTO settings VALUES ('system/userSelfRegistration/enable', 2, 'n', 1910, 'false');
INSERT INTO settings VALUES ('system/userFeedback/enable', 2, 'n', 1911, 'true');
INSERT INTO settings VALUES ('system/clickablehyperlinks/enable', 2, 'y', 2010, 'true');
INSERT INTO settings VALUES ('system/localrating/enable', 2, 'y', 2110, 'false');
INSERT INTO settings VALUES ('system/downloadservice/leave', 0, 'y', 2210, 'false');
INSERT INTO settings VALUES ('system/downloadservice/simple', 0, 'y', 2220, 'true');
INSERT INTO settings VALUES ('system/downloadservice/withdisclaimer', 0, 'y', 2230, 'false');
INSERT INTO settings VALUES ('system/xlinkResolver/enable', 2, 'n', 2310, 'true');
INSERT INTO settings VALUES ('system/xlinkResolver/localXlinkEnable', 2, 'n', 2311, 'true');
INSERT INTO settings VALUES ('system/hidewithheldelements/enableLogging', 2, 'y', 2320, 'false');
INSERT INTO settings VALUES ('system/autofixing/enable', 2, 'y', 2410, 'true');
INSERT INTO settings VALUES ('system/searchStats/enable', 2, 'n', 2510, 'true');
INSERT INTO settings VALUES ('system/indexoptimizer/enable', 2, 'y', 6010, 'true');
INSERT INTO settings VALUES ('system/indexoptimizer/at/hour', 1, 'y', 6030, '0');
INSERT INTO settings VALUES ('system/indexoptimizer/at/min', 1, 'y', 6040, '0');
INSERT INTO settings VALUES ('system/indexoptimizer/at/sec', 1, 'y', 6050, '0');
INSERT INTO settings VALUES ('system/indexoptimizer/interval/day', 1, 'y', 6070, '0');
INSERT INTO settings VALUES ('system/indexoptimizer/interval/hour', 1, 'y', 6080, '24');
INSERT INTO settings VALUES ('system/indexoptimizer/interval/min', 1, 'y', 6090, '0');
INSERT INTO settings VALUES ('system/oai/mdmode', 0, 'y', 7010, '1');
INSERT INTO settings VALUES ('system/oai/tokentimeout', 1, 'y', 7020, '3600');
INSERT INTO settings VALUES ('system/oai/cachesize', 1, 'y', 7030, '60');
INSERT INTO settings VALUES ('system/inspire/enable', 2, 'y', 7210, 'true');
INSERT INTO settings VALUES ('system/inspire/enableSearchPanel', 2, 'n', 7220, 'false');
INSERT INTO settings VALUES ('system/inspire/atom', 0, 'y', 7230, 'disabled');
INSERT INTO settings VALUES ('system/inspire/atomSchedule', 0, 'y', 7240, '0 0 0/24 ? * *');
INSERT INTO settings VALUES ('system/inspire/atomProtocol', 0, 'y', 7250, 'INSPIRE-ATOM');
INSERT INTO settings VALUES ('system/harvester/enableEditing', 2, 'n', 9010, 'false');
INSERT INTO settings VALUES ('system/harvesting/mail/template', 0, 'y', 9021, '');
INSERT INTO settings VALUES ('system/harvesting/mail/templateError', 0, 'y', 9022, 'There was an error on the harvesting: $$errorMsg$$');
INSERT INTO settings VALUES ('system/harvesting/mail/templateWarning', 0, 'y', 9023, '');
INSERT INTO settings VALUES ('system/harvesting/mail/subject', 0, 'y', 9024, '[$$harvesterType$$] $$harvesterName$$ finished harvesting');
INSERT INTO settings VALUES ('system/harvesting/mail/enabled', 2, 'y', 9025, 'false');
INSERT INTO settings VALUES ('system/harvesting/mail/level1', 2, 'y', 9026, 'false');
INSERT INTO settings VALUES ('system/harvesting/mail/level2', 2, 'y', 9027, 'false');
INSERT INTO settings VALUES ('system/harvesting/mail/level3', 2, 'y', 9028, 'false');
INSERT INTO settings VALUES ('system/metadata/prefergrouplogo', 2, 'y', 9111, 'true');
INSERT INTO settings VALUES ('system/metadata/enableSimpleView', 2, 'y', 9110, 'true');
INSERT INTO settings VALUES ('system/metadata/enableIsoView', 2, 'y', 9120, 'false');
INSERT INTO settings VALUES ('system/metadata/enableInspireView', 2, 'y', 9130, 'true');
INSERT INTO settings VALUES ('system/metadata/enableXmlView', 2, 'y', 9140, 'true');
INSERT INTO settings VALUES ('system/metadata/defaultView', 0, 'n', 9150, 'simple');
INSERT INTO settings VALUES ('system/metadata/allThesaurus', 2, 'n', 9160, 'false');
INSERT INTO settings VALUES ('system/metadataprivs/usergrouponly', 2, 'n', 9180, 'false');
INSERT INTO settings VALUES ('system/threadedindexing/maxthreads', 1, 'y', 9210, '1');
INSERT INTO settings VALUES ('system/autodetect/enable', 2, 'y', 9510, 'true');
INSERT INTO settings VALUES ('system/requestedLanguage/only', 0, 'y', 9530, 'prefer_locale');
INSERT INTO settings VALUES ('system/requestedLanguage/sorted', 2, 'y', 9540, 'false');
INSERT INTO settings VALUES ('system/requestedLanguage/ignorechars', 0, 'y', 9590, '');
INSERT INTO settings VALUES ('system/requestedLanguage/preferUiLanguage', 2, 'y', 9595, 'true');
INSERT INTO settings VALUES ('region/getmap/background', 0, 'n', 9590, 'osm');
INSERT INTO settings VALUES ('region/getmap/width', 0, 'n', 9590, '500');
INSERT INTO settings VALUES ('region/getmap/summaryWidth', 0, 'n', 9590, '500');
INSERT INTO settings VALUES ('region/getmap/mapproj', 0, 'n', 9590, 'EPSG:3857');
INSERT INTO settings VALUES ('system/site/siteId', 0, 'n', 120, '149b8531-d182-4db0-b7a4-bf5c8d5a6e54');
INSERT INTO settings VALUES ('system/harvesting/mail/recipient', 0, 'y', 9020, '');
INSERT INTO settings VALUES ('system/csw/contactId', 0, 'y', 1220, '');
INSERT INTO settings VALUES ('map/proj4js', 0, 'n', 9591, '[{"code":"EPSG:2154","value":"+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"}]');
INSERT INTO settings VALUES ('metadata/resourceIdentifierPrefix', 0, 'n', 10001, 'https://@http.host.name@.ign.fr/geosource/metadata/srv/{{uuid}}.xml');
INSERT INTO settings VALUES ('map/isMapViewerEnabled', 2, 'n', 9592, 'false');
INSERT INTO settings VALUES ('map/is3DModeAllowed', 2, 'n', 9593, 'false');
INSERT INTO settings VALUES ('map/isSaveMapInCatalogAllowed', 2, 'n', 9594, 'true');
INSERT INTO settings VALUES ('system/ui/defaultView', 0, 'n', 10100, 'default');
INSERT INTO settings VALUES ('system/site/svnUuid', 0, 'y', 170, '15de23c6-9926-472c-b3cf-2d67a6c4b176');
INSERT INTO settings VALUES ('system/indexoptimizer/interval', 0, 'y', 6060, '');
INSERT INTO settings VALUES ('system/proxy/host', 0, 'y', 520, '');
INSERT INTO settings VALUES ('metadata/editor/schemaConfig', 0, 'n', 10000, '{"iso19110":{"defaultTab":"default","displayToolTip":false,"related":{"display":true,"readonly":true,"categories":["dataset"]},"validation":{"display":true}},"iso19139":{"defaultTab":"inspire","displayToolTip":false,"related":{"display":true,"categories":[]},"suggestion":{"display":true},"validation":{"display":true}},"dublin-core":{"defaultTab":"default","related":{"display":true,"readonly":false,"categories":["parent","onlinesrc"]}},"iso19139.sinp":{
  "defaultTab":"identificationInfo", 
  "displayToolTip":true,
  "related":{"display":true,"categories":[]},
  "suggestion":{"display":true},
  "validation":{"display":true}
  }}');
INSERT INTO settings VALUES ('system/proxy/port', 1, 'y', 530, '');
INSERT INTO settings VALUES ('system/proxy/username', 0, 'y', 540, '');
INSERT INTO settings VALUES ('system/proxy/ignorehostlist', 0, 'y', 560, '');
INSERT INTO settings VALUES ('map/config', 0, 'n', 9590, '{"viewerMap":"../../map/config-viewer.xml","listOfServices":{"wms":[],"wmts":[]},"useOSM":true,"context":"","layer":{"url":"http://www2.demis.nl/mapserver/wms.asp?","layers":"Countries","version":"1.1.1"},"projection":"EPSG:3857","projectionList":[{"code":"EPSG:4326","label":"WGS84 (EPSG:4326)"},{"code":"EPSG:3857","label":"Google mercator (EPSG:3857)"}]}');
INSERT INTO settings VALUES ('system/proxy/password', 0, 'y', 550, '');


--
-- TOC entry 4104 (class 0 OID 27559451)
-- Dependencies: 377
-- Data for Name: sources; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4105 (class 0 OID 27559457)
-- Dependencies: 378
-- Data for Name: sourcesdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4106 (class 0 OID 27559460)
-- Dependencies: 379
-- Data for Name: statusvalues; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO statusvalues VALUES (0, 0, 'unknown', 'y');
INSERT INTO statusvalues VALUES (1, 1, 'draft', 'y');
INSERT INTO statusvalues VALUES (2, 3, 'approved', 'y');
INSERT INTO statusvalues VALUES (3, 5, 'retired', 'y');
INSERT INTO statusvalues VALUES (4, 2, 'submitted', 'y');
INSERT INTO statusvalues VALUES (5, 4, 'rejected', 'y');


--
-- TOC entry 4107 (class 0 OID 27559463)
-- Dependencies: 380
-- Data for Name: statusvaluesdes; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO statusvaluesdes VALUES (0, 'Unknown', 'eng');
INSERT INTO statusvaluesdes VALUES (1, 'Draft', 'eng');
INSERT INTO statusvaluesdes VALUES (2, 'Approved', 'eng');
INSERT INTO statusvaluesdes VALUES (3, 'Retired', 'eng');
INSERT INTO statusvaluesdes VALUES (4, 'Submitted', 'eng');
INSERT INTO statusvaluesdes VALUES (5, 'Rejected', 'eng');
INSERT INTO statusvaluesdes VALUES (0, 'Inconnu', 'fre');
INSERT INTO statusvaluesdes VALUES (1, 'Brouillon', 'fre');
INSERT INTO statusvaluesdes VALUES (2, 'Validé', 'fre');
INSERT INTO statusvaluesdes VALUES (3, 'Retiré', 'fre');
INSERT INTO statusvaluesdes VALUES (4, 'A valider', 'fre');
INSERT INTO statusvaluesdes VALUES (5, 'Rejeté', 'fre');


--
-- TOC entry 4108 (class 0 OID 27559466)
-- Dependencies: 381
-- Data for Name: thesaurus; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4109 (class 0 OID 27559469)
-- Dependencies: 382
-- Data for Name: useraddress; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO useraddress VALUES (1, 1);


--
-- TOC entry 4110 (class 0 OID 27559472)
-- Dependencies: 383
-- Data for Name: usergroups; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 4111 (class 0 OID 27559475)
-- Dependencies: 384
-- Data for Name: users; Type: TABLE DATA; Schema: geosource; Owner: geosource
--

INSERT INTO users VALUES (1, '', '2016-05-17T17:30:03', 'developpeur', '', 0, '', 'srv', '82424de03aa0d6de4fd934fe9b0b527f82c00411e08d762f5ee0321a09a75796db3ba992675aa3b9', '', 'developpeur', 'developpeur');


--
-- TOC entry 4112 (class 0 OID 27559481)
-- Dependencies: 385
-- Data for Name: validation; Type: TABLE DATA; Schema: geosource; Owner: geosource
--



--
-- TOC entry 3838 (class 2606 OID 27559487)
-- Name: address_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 3840 (class 2606 OID 27559489)
-- Name: categories_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 3842 (class 2606 OID 27559491)
-- Name: categoriesdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY categoriesdes
    ADD CONSTRAINT categoriesdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3844 (class 2606 OID 27559493)
-- Name: cswservercapabilitiesinfo_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY cswservercapabilitiesinfo
    ADD CONSTRAINT cswservercapabilitiesinfo_pkey PRIMARY KEY (idfield);


--
-- TOC entry 3846 (class 2606 OID 27559495)
-- Name: customelementset_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY customelementset
    ADD CONSTRAINT customelementset_pkey PRIMARY KEY (xpathhashcode);


--
-- TOC entry 3848 (class 2606 OID 27559497)
-- Name: groups_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3850 (class 2606 OID 27559499)
-- Name: groupsdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY groupsdes
    ADD CONSTRAINT groupsdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3852 (class 2606 OID 27559501)
-- Name: harvesterdata_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY harvesterdata
    ADD CONSTRAINT harvesterdata_pkey PRIMARY KEY (harvesteruuid, key);


--
-- TOC entry 3854 (class 2606 OID 27559503)
-- Name: harvestersettings_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY harvestersettings
    ADD CONSTRAINT harvestersettings_pkey PRIMARY KEY (id);


--
-- TOC entry 3856 (class 2606 OID 27559505)
-- Name: harvesthistory_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY harvesthistory
    ADD CONSTRAINT harvesthistory_pkey PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 27559507)
-- Name: inspireatomfeed_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY inspireatomfeed
    ADD CONSTRAINT inspireatomfeed_pkey PRIMARY KEY (id);


--
-- TOC entry 3860 (class 2606 OID 27559509)
-- Name: isolanguages_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY isolanguages
    ADD CONSTRAINT isolanguages_pkey PRIMARY KEY (id);


--
-- TOC entry 3862 (class 2606 OID 27559511)
-- Name: isolanguagesdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY isolanguagesdes
    ADD CONSTRAINT isolanguagesdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3864 (class 2606 OID 27559513)
-- Name: languages_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- TOC entry 3866 (class 2606 OID 27559515)
-- Name: mapservers_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY mapservers
    ADD CONSTRAINT mapservers_pkey PRIMARY KEY (id);


--
-- TOC entry 3868 (class 2606 OID 27559517)
-- Name: metadata_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadata
    ADD CONSTRAINT metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 3872 (class 2606 OID 27559519)
-- Name: metadatacateg_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatacateg
    ADD CONSTRAINT metadatacateg_pkey PRIMARY KEY (metadataid, categoryid);


--
-- TOC entry 3874 (class 2606 OID 27559521)
-- Name: metadatafiledownloads_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatafiledownloads
    ADD CONSTRAINT metadatafiledownloads_pkey PRIMARY KEY (id);


--
-- TOC entry 3876 (class 2606 OID 27559523)
-- Name: metadatafileuploads_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatafileuploads
    ADD CONSTRAINT metadatafileuploads_pkey PRIMARY KEY (id);


--
-- TOC entry 3878 (class 2606 OID 27559525)
-- Name: metadatanotifications_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatanotifications
    ADD CONSTRAINT metadatanotifications_pkey PRIMARY KEY (metadataid, notifierid);


--
-- TOC entry 3880 (class 2606 OID 27559527)
-- Name: metadatanotifiers_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatanotifiers
    ADD CONSTRAINT metadatanotifiers_pkey PRIMARY KEY (id);


--
-- TOC entry 3882 (class 2606 OID 27559529)
-- Name: metadatarating_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatarating
    ADD CONSTRAINT metadatarating_pkey PRIMARY KEY (ipaddress, metadataid);


--
-- TOC entry 3884 (class 2606 OID 27559531)
-- Name: metadatastatus_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadatastatus
    ADD CONSTRAINT metadatastatus_pkey PRIMARY KEY (changedate, metadataid, statusid, userid);


--
-- TOC entry 3886 (class 2606 OID 27559533)
-- Name: operationallowed_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY operationallowed
    ADD CONSTRAINT operationallowed_pkey PRIMARY KEY (groupid, metadataid, operationid);


--
-- TOC entry 3888 (class 2606 OID 27559535)
-- Name: operations_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY operations
    ADD CONSTRAINT operations_pkey PRIMARY KEY (id);


--
-- TOC entry 3890 (class 2606 OID 27559537)
-- Name: operationsdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY operationsdes
    ADD CONSTRAINT operationsdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3892 (class 2606 OID 27559541)
-- Name: relations_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id, relatedid);


--
-- TOC entry 3894 (class 2606 OID 27559545)
-- Name: schematron_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY schematron
    ADD CONSTRAINT schematron_pkey PRIMARY KEY (id);


--
-- TOC entry 3898 (class 2606 OID 27559547)
-- Name: schematroncriteria_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY schematroncriteria
    ADD CONSTRAINT schematroncriteria_pkey PRIMARY KEY (id);


--
-- TOC entry 3900 (class 2606 OID 27559549)
-- Name: schematroncriteriagroup_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY schematroncriteriagroup
    ADD CONSTRAINT schematroncriteriagroup_pkey PRIMARY KEY (name, schematronid);


--
-- TOC entry 3902 (class 2606 OID 27559551)
-- Name: schematrondes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY schematrondes
    ADD CONSTRAINT schematrondes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3904 (class 2606 OID 27559553)
-- Name: serviceparameters_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY serviceparameters
    ADD CONSTRAINT serviceparameters_pkey PRIMARY KEY (id);


--
-- TOC entry 3906 (class 2606 OID 27559555)
-- Name: services_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- TOC entry 3910 (class 2606 OID 27559557)
-- Name: settings_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (name);


--
-- TOC entry 3912 (class 2606 OID 27559559)
-- Name: sources_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (uuid);


--
-- TOC entry 3914 (class 2606 OID 27559561)
-- Name: sourcesdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY sourcesdes
    ADD CONSTRAINT sourcesdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3916 (class 2606 OID 27559563)
-- Name: statusvalues_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY statusvalues
    ADD CONSTRAINT statusvalues_pkey PRIMARY KEY (id);


--
-- TOC entry 3918 (class 2606 OID 27559565)
-- Name: statusvaluesdes_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY statusvaluesdes
    ADD CONSTRAINT statusvaluesdes_pkey PRIMARY KEY (iddes, langid);


--
-- TOC entry 3920 (class 2606 OID 27559567)
-- Name: thesaurus_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY thesaurus
    ADD CONSTRAINT thesaurus_pkey PRIMARY KEY (id);


--
-- TOC entry 3928 (class 2606 OID 27559569)
-- Name: uk_23y4gd49ajvbqgl3psjsvhff6; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT uk_23y4gd49ajvbqgl3psjsvhff6 UNIQUE (username);


--
-- TOC entry 3922 (class 2606 OID 27559571)
-- Name: uk_8te6nqcuovmv45ej1oej73hg3; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY useraddress
    ADD CONSTRAINT uk_8te6nqcuovmv45ej1oej73hg3 UNIQUE (addressid);


--
-- TOC entry 3870 (class 2606 OID 27559573)
-- Name: uk_e9w46i6v429h02tmynm3eefiy; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY metadata
    ADD CONSTRAINT uk_e9w46i6v429h02tmynm3eefiy UNIQUE (uuid);


--
-- TOC entry 3908 (class 2606 OID 27559575)
-- Name: uk_j180x109do4umtn4ppnmepoyf; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY services
    ADD CONSTRAINT uk_j180x109do4umtn4ppnmepoyf UNIQUE (name);


--
-- TOC entry 3896 (class 2606 OID 27559577)
-- Name: uk_k7c29i3x0x6p5hbvb0qsdmuek; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY schematron
    ADD CONSTRAINT uk_k7c29i3x0x6p5hbvb0qsdmuek UNIQUE (schemaname, filename);


--
-- TOC entry 3924 (class 2606 OID 27559579)
-- Name: useraddress_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY useraddress
    ADD CONSTRAINT useraddress_pkey PRIMARY KEY (userid, addressid);


--
-- TOC entry 3926 (class 2606 OID 27559581)
-- Name: usergroups_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (groupid, profile, userid);


--
-- TOC entry 3930 (class 2606 OID 27559583)
-- Name: users_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3932 (class 2606 OID 27559585)
-- Name: validation_pkey; Type: CONSTRAINT; Schema: geosource; Owner: geosource; Tablespace: 
--

ALTER TABLE ONLY validation
    ADD CONSTRAINT validation_pkey PRIMARY KEY (metadataid, valtype);


--
-- TOC entry 3952 (class 2606 OID 27559586)
-- Name: fk_1x9ybprsvnlrawsk1a7nwgpq6; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY usergroups
    ADD CONSTRAINT fk_1x9ybprsvnlrawsk1a7nwgpq6 FOREIGN KEY (userid) REFERENCES users(id);


--
-- TOC entry 3949 (class 2606 OID 27559591)
-- Name: fk_2vkxyjsd2d3tdwn38p5yjhb71; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY statusvaluesdes
    ADD CONSTRAINT fk_2vkxyjsd2d3tdwn38p5yjhb71 FOREIGN KEY (iddes) REFERENCES statusvalues(id);


--
-- TOC entry 3935 (class 2606 OID 27559596)
-- Name: fk_4p4fkvpk92euh0l1hrphqmhgp; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY groupsdes
    ADD CONSTRAINT fk_4p4fkvpk92euh0l1hrphqmhgp FOREIGN KEY (iddes) REFERENCES groups(id);


--
-- TOC entry 3939 (class 2606 OID 27559601)
-- Name: fk_691tu1a51wae9905g6gtyjopt; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY metadatacateg
    ADD CONSTRAINT fk_691tu1a51wae9905g6gtyjopt FOREIGN KEY (metadataid) REFERENCES metadata(id);


--
-- TOC entry 3933 (class 2606 OID 27559606)
-- Name: fk_69p88c8991letuoq16jddi307; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY categoriesdes
    ADD CONSTRAINT fk_69p88c8991letuoq16jddi307 FOREIGN KEY (iddes) REFERENCES categories(id);


--
-- TOC entry 3950 (class 2606 OID 27559616)
-- Name: fk_8te6nqcuovmv45ej1oej73hg3; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY useraddress
    ADD CONSTRAINT fk_8te6nqcuovmv45ej1oej73hg3 FOREIGN KEY (addressid) REFERENCES address(id);


--
-- TOC entry 3945 (class 2606 OID 27559621)
-- Name: fk_atfj71dq82he6n77lqofjxui6; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY schematroncriteriagroup
    ADD CONSTRAINT fk_atfj71dq82he6n77lqofjxui6 FOREIGN KEY (schematronid) REFERENCES schematron(id);


--
-- TOC entry 3942 (class 2606 OID 27559626)
-- Name: fk_b6th8n92l16998imlr7oqytaf; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY metadatastatus
    ADD CONSTRAINT fk_b6th8n92l16998imlr7oqytaf FOREIGN KEY (statusid) REFERENCES statusvalues(id);


--
-- TOC entry 3948 (class 2606 OID 27559631)
-- Name: fk_c3jxktm4qwai73lddsm5fiecb; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY sourcesdes
    ADD CONSTRAINT fk_c3jxktm4qwai73lddsm5fiecb FOREIGN KEY (iddes) REFERENCES sources(uuid);


--
-- TOC entry 3944 (class 2606 OID 27559636)
-- Name: fk_dh2vjs226vjp2anrvj3nuvt8x; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY schematroncriteria
    ADD CONSTRAINT fk_dh2vjs226vjp2anrvj3nuvt8x FOREIGN KEY (group_name, group_schematronid) REFERENCES schematroncriteriagroup(name, schematronid);


--
-- TOC entry 3938 (class 2606 OID 27559641)
-- Name: fk_emeavjsu8j7v000m8iyu0skgo; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY isolanguagesdes
    ADD CONSTRAINT fk_emeavjsu8j7v000m8iyu0skgo FOREIGN KEY (iddes) REFERENCES isolanguages(id);


--
-- TOC entry 3940 (class 2606 OID 27559646)
-- Name: fk_eq06r8xcyiiibgyl6q3r1ojk4; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY metadatacateg
    ADD CONSTRAINT fk_eq06r8xcyiiibgyl6q3r1ojk4 FOREIGN KEY (categoryid) REFERENCES categories(id);


--
-- TOC entry 3937 (class 2606 OID 27559651)
-- Name: fk_eyt177hveh5vlxyxq6wpl3vqi; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY inspireatomfeed_entrylist
    ADD CONSTRAINT fk_eyt177hveh5vlxyxq6wpl3vqi FOREIGN KEY (inspireatomfeed_id) REFERENCES inspireatomfeed(id);


--
-- TOC entry 3951 (class 2606 OID 27559656)
-- Name: fk_f8ecen6kghqbp0tkqc4cdr6q1; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY useraddress
    ADD CONSTRAINT fk_f8ecen6kghqbp0tkqc4cdr6q1 FOREIGN KEY (userid) REFERENCES users(id);


--
-- TOC entry 3936 (class 2606 OID 27559661)
-- Name: fk_hu0aqcu6xr59088fibd1vhnqi; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY harvestersettings
    ADD CONSTRAINT fk_hu0aqcu6xr59088fibd1vhnqi FOREIGN KEY (parentid) REFERENCES harvestersettings(id);


--
-- TOC entry 3941 (class 2606 OID 27559666)
-- Name: fk_jbkvo3w3g4twk2bo1b8jn0sw8; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY metadatanotifications
    ADD CONSTRAINT fk_jbkvo3w3g4twk2bo1b8jn0sw8 FOREIGN KEY (notifierid) REFERENCES metadatanotifiers(id);


--
-- TOC entry 3953 (class 2606 OID 27559671)
-- Name: fk_py108k658ig7v8luqf88sgrtu; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY usergroups
    ADD CONSTRAINT fk_py108k658ig7v8luqf88sgrtu FOREIGN KEY (groupid) REFERENCES groups(id);


--
-- TOC entry 3946 (class 2606 OID 27559676)
-- Name: fk_sh1xwulyb1jeoc6puqpiuc5d2; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY schematrondes
    ADD CONSTRAINT fk_sh1xwulyb1jeoc6puqpiuc5d2 FOREIGN KEY (iddes) REFERENCES schematron(id);


--
-- TOC entry 3943 (class 2606 OID 27559681)
-- Name: fk_si4h3s9vk085jarb8xbfw1uv; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY operationsdes
    ADD CONSTRAINT fk_si4h3s9vk085jarb8xbfw1uv FOREIGN KEY (iddes) REFERENCES operations(id);


--
-- TOC entry 3947 (class 2606 OID 27559686)
-- Name: fk_t32t4xtdqmjhl8xmjpe95e474; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY serviceparameters
    ADD CONSTRAINT fk_t32t4xtdqmjhl8xmjpe95e474 FOREIGN KEY (service) REFERENCES services(id);


--
-- TOC entry 3934 (class 2606 OID 27559691)
-- Name: fk_tlb3l7e2xg65r3nkoahbqlmii; Type: FK CONSTRAINT; Schema: geosource; Owner: geosource
--

ALTER TABLE ONLY email
    ADD CONSTRAINT fk_tlb3l7e2xg65r3nkoahbqlmii FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 4117 (class 0 OID 0)
-- Dependencies: 356
-- Name: metadata; Type: ACL; Schema: geosource; Owner: geosource
--

REVOKE ALL ON SCHEMA geosource FROM PUBLIC;
REVOKE ALL ON SCHEMA geosource FROM ogam;
GRANT ALL ON SCHEMA geosource TO ogam;
GRANT ALL ON SCHEMA geosource TO geosource;
grant all on all sequences in schema geosource to geosource;
grant all on all sequences in schema geosource to ogam;
GRANT SELECT ON table geosource.metadata TO ogam;


-- Completed on 2016-05-17 17:55:18 CEST

--
-- PostgreSQL database dump complete
--


