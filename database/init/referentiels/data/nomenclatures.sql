﻿SET search_path = referentiels, pg_catalog;

CREATE TABLE StatutSourceValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.StatutSourceValue OWNER TO postgres;

ALTER TABLE ONLY StatutSourceValue ADD CONSTRAINT StatutSourceValue_pkey PRIMARY KEY (code);

INSERT INTO StatutSourceValue VALUES ('Te','Terrain','L''observation provient directement d''une base de données ou d''un document issu de la prospection sur le terrain');
INSERT INTO StatutSourceValue VALUES ('Co','Collection','L''observation concerne une base de données de collection');
INSERT INTO StatutSourceValue VALUES ('Li','Littérature','L''observation a été extraite d''un article ou d''un ouvrage scientifique');
INSERT INTO StatutSourceValue VALUES ('NSP','Ne sait pas','La source est inconnue');





CREATE TABLE DSPubliqueValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.DSPubliqueValue OWNER TO postgres;

ALTER TABLE ONLY DSPubliqueValue ADD CONSTRAINT DSPubliqueValue_pkey PRIMARY KEY (code);

INSERT INTO DSPubliqueValue VALUES ('Pu','Publique','La donnée source est publique qu’elle soit produite en « régie » ou « acquise »');
INSERT INTO DSPubliqueValue VALUES ('Re','Publique Régie','La Donnée Source est publique et a été produite directement par un organisme ayant autorité publique avec ses moyens humains et techniques propres.');
INSERT INTO DSPubliqueValue VALUES ('Ac','Publique Acquise','La DS a été produite par un organisme privé ou une personne physique à titre personnel. Les droits patrimoniaux ont été acquis par un organisme ayant autorité publique. La DS est devenue publique.');
INSERT INTO DSPubliqueValue VALUES ('Pr','Privée','La DS a été produite par un organisme privé ou un individu à titre personnel. Aucun organisme ayant autorité publique n''a acquis les droits patrimoniaux, la DS reste la propriété du producteur. Floutage géographique de la DEE autorisé');
INSERT INTO DSPubliqueValue VALUES ('NSP','Ne sait pas','L’information indiquant si la Donnée Source est publique ou privée n’est pas connue.');







CREATE TABLE StatutObservationValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.StatutObservationValue OWNER TO postgres;

ALTER TABLE ONLY StatutObservationValue ADD CONSTRAINT StatutObservationValue_pkey PRIMARY KEY (code);

INSERT INTO StatutObservationValue VALUES ('Pr','Présent','Un ou plusieurs individus du taxon ont été effectivement observés et/ou des indices témoignant de la présence du taxon');
INSERT INTO StatutObservationValue VALUES ('No','Non observé','L''observateur n''a pas détecté un taxon particulier, recherché suivant le protocole adéquat à la localisation et à la date de l''observation. Le taxon peut être présent et non vu, temporairement absent, ou réellement absent.');








CREATE TABLE TypeDenombrementValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.TypeDenombrementValue OWNER TO postgres;

ALTER TABLE ONLY TypeDenombrementValue ADD CONSTRAINT TypeDenombrementValue_pkey PRIMARY KEY (code);

INSERT INTO TypeDenombrementValue VALUES ('Co','Compté','Dénombrement par énumération des individus');
INSERT INTO TypeDenombrementValue VALUES ('Es','Estimé','Dénombrement qualifié d''estimé lorsque le produit concerné n''a fait l''objet d''aucune action de détermination de cette valeur du paramètre par le biais d''une technique de mesure.');
INSERT INTO TypeDenombrementValue VALUES ('Ca','Calculé','Dénombrement par opération mathématique');
INSERT INTO TypeDenombrementValue VALUES ('NSP','Ne Sait Pas','La méthode de dénombrement n''est pas connue');






CREATE TABLE CodeRefHabitatValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.CodeRefHabitatValue OWNER TO postgres;

ALTER TABLE ONLY CodeRefHabitatValue ADD CONSTRAINT CodeRefHabitatValue_pkey PRIMARY KEY (code);

INSERT INTO CodeRefHabitatValue VALUES ('ANTMER','Habitats marins outre-mer et Antilles','');
INSERT INTO CodeRefHabitatValue VALUES ('BARC','Convention de Barcelone','');
INSERT INTO CodeRefHabitatValue VALUES ('BBMEDFR','Biocénoses benthiques de Méditerranée','');
INSERT INTO CodeRefHabitatValue VALUES ('BRYOSOCIO','Synopsis bryosociologique','');
INSERT INTO CodeRefHabitatValue VALUES ('CH','Cahier d''habitat ','');
INSERT INTO CodeRefHabitatValue VALUES ('CORINEBIOTOPE','CORINE Biotopes','');
INSERT INTO CodeRefHabitatValue VALUES ('EUNIS','EUNIS Habitas','');
INSERT INTO CodeRefHabitatValue VALUES ('GMRC','Géomorphologie des récifs coralliens ','');
INSERT INTO CodeRefHabitatValue VALUES ('GUYMER','Habitats marins du département d''outre-mer de Guyane ','');
INSERT INTO CodeRefHabitatValue VALUES ('HABREF','Référentiel d''habitats et de végétation','');
INSERT INTO CodeRefHabitatValue VALUES ('HABITATS_MARINS_ATLANTIQUE','Typologie des habitats marins benthiques de la Manche, de la Mer du Nord et de l''Atlantique','');
INSERT INTO CodeRefHabitatValue VALUES ('HABITATS_MARINS_DOM','Typologie des habitats marins benthiques de la Manche, de la Mer du Nord et de l''Atlantique','');
INSERT INTO CodeRefHabitatValue VALUES ('HABITATS_MARINS_MEDITERRANEE','Typologie des habitats marins benthiques de la Manche, de la Mer du Nord et de l''Atlantique','');
INSERT INTO CodeRefHabitatValue VALUES ('HIC','Liste hiérarchisée et descriptifs des habitats d''intérêt communautaire de la directive "Habitats"','');
INSERT INTO CodeRefHabitatValue VALUES ('OSPAR','Convention OSPAR ','');
INSERT INTO CodeRefHabitatValue VALUES ('PAL','Classification paléarctique','');
INSERT INTO CodeRefHabitatValue VALUES ('PALSPM','Habitats de St Pierre et Miquelon','');
INSERT INTO CodeRefHabitatValue VALUES ('PHYTO_CH','Unités phytosociologiques des cahiers d''habitats ','');
INSERT INTO CodeRefHabitatValue VALUES ('PVF','Prodrome des végétations de France ','');
INSERT INTO CodeRefHabitatValue VALUES ('PVF1','Prodrome des végétations de France ','');
INSERT INTO CodeRefHabitatValue VALUES ('PVF2','Prodrome des végétations de France ','');
INSERT INTO CodeRefHabitatValue VALUES ('REBENT	','Habitat benthique côtier (Bretagne)','');
INSERT INTO CodeRefHabitatValue	 VALUES ('REUMER','Habitats marins du département d''outre-mer de La Réunion','');
INSERT INTO CodeRefHabitatValue	 VALUES ('SYNSYSTEME_EUROPEEN','Classification phytosociologique européenne','');





CREATE TABLE NatureObjetGeoValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.NatureObjetGeoValue OWNER TO postgres;

ALTER TABLE ONLY NatureObjetGeoValue ADD CONSTRAINT NatureObjetGeoValue_pkey PRIMARY KEY (code);

INSERT INTO NatureObjetGeoValue VALUES ('St','Stationnel : Le taxon observé est présent sur l’ensemble de l’objet géographique','');
INSERT INTO NatureObjetGeoValue VALUES ('In','Inventoriel : Le taxon observé est présent quelque part dans l’objet géographique ','');
INSERT INTO NatureObjetGeoValue VALUES ('NSP','Ne Sait Pas : L’information est inconnue','');


CREATE TABLE NiveauPrecisionValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.NiveauPrecisionValue OWNER TO postgres;

ALTER TABLE ONLY NiveauPrecisionValue ADD CONSTRAINT NiveauPrecisionValue_pkey PRIMARY KEY (code);

INSERT INTO NiveauPrecisionValue VALUES ('0','Diffusion standard : à la maille, à la ZNIEFF, à la commune, à l’espace protégé (statut par défaut) ','');
INSERT INTO NiveauPrecisionValue VALUES ('1','Diffusion floutée de la DEE par rattachement à la commune ','');
INSERT INTO NiveauPrecisionValue VALUES ('2','Diffusion floutée par rattachement à la maille 10 x 10 km ','');
INSERT INTO NiveauPrecisionValue VALUES ('3','Diffusion floutée par rattachement au département ','');
INSERT INTO NiveauPrecisionValue VALUES ('4','Aucune diffusion (cas exceptionnel), correspond à une donnée de sensibilité 4 ','');
INSERT INTO NiveauPrecisionValue VALUES ('5','Diffusion telle quelle : si une donnée précise existe, elle doit être diffusée telle quelle ','');



CREATE TABLE ObjetDenombrementValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.ObjetDenombrementValue OWNER TO postgres;

ALTER TABLE ONLY ObjetDenombrementValue ADD CONSTRAINT TObjetDenombrementValue_pkey PRIMARY KEY (code);


INSERT INTO ObjetDenombrementValue VALUES ('COL','Nombre de colonies observées','');
INSERT INTO ObjetDenombrementValue VALUES ('CPL','Nombre de couples observé ','');
INSERT INTO ObjetDenombrementValue VALUES ('HAM','Nombre de hampes florales observées ','');
INSERT INTO ObjetDenombrementValue VALUES ('IND','Nombre d''individus observés ','');
INSERT INTO ObjetDenombrementValue VALUES ('NID','Nombre de nids observés ','');
INSERT INTO ObjetDenombrementValue VALUES ('NSP','La méthode de dénombrement n''est pas connue ','');
INSERT INTO ObjetDenombrementValue VALUES ('PON','Nombre de pontes observées','');
INSERT INTO ObjetDenombrementValue VALUES ('SURF','Zone aréale occupée par le taxon, en mètres carrés','');
INSERT INTO ObjetDenombrementValue VALUES ('TIGE','Nombre de tiges observées ','');
INSERT INTO ObjetDenombrementValue VALUES ('TOUF','Nombre de touffes observées ','');





CREATE TABLE ObservationMethodeValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.ObservationMethodeValue OWNER TO postgres;

ALTER TABLE ONLY ObservationMethodeValue ADD CONSTRAINT ObservationMethodeValue_pkey PRIMARY KEY (code);

INSERT INTO ObservationMethodeValue VALUES ('0','Vu','Observation directe d''un individu vivant.');
INSERT INTO ObservationMethodeValue VALUES ('1','Entendu','Observation acoustique d''un individu vivant.');
INSERT INTO ObservationMethodeValue VALUES ('2','Coquilles d''oeuf','Observation indirecte via coquilles d''oeuf.');
INSERT INTO ObservationMethodeValue VALUES ('3','Ultrasons','Observation acoustique indirecte d''un individu vivant avec matériel spécifique permettant de transduire des ultrasons en sons perceptibles par un humain.');
INSERT INTO ObservationMethodeValue VALUES ('4','Empreintes','Observation indirecte via empreintes ');
INSERT INTO ObservationMethodeValue VALUES ('5','Exuvie','Observation indirecte : une exuvie.');
INSERT INTO ObservationMethodeValue VALUES ('6','Fèces/Guano/Epreintes','Observation indirecte par les excréments ');
INSERT INTO ObservationMethodeValue VALUES ('7','Mues','Observation indirecte par des plumes, poils, phanères, peau, bois... issus d''une mue.');
INSERT INTO ObservationMethodeValue VALUES ('8','Nid/Gite','Observation indirecte par présence d''un nid ou d''un gîte non occupé au moment de l''observation.');
INSERT INTO ObservationMethodeValue VALUES ('9','Pelote de réjection','Identifie l''espèce ayant produit la pelote de réjection. ');
INSERT INTO ObservationMethodeValue VALUES ('10','Restes dans pelote de réjection','Identifie l''espèce à laquelle appartiennent les os retrouvés dans la pelote de réjection.');
INSERT INTO ObservationMethodeValue VALUES ('11','Poils/Plumes/Phanères','Observation indirecte de l''espèce par ses poils, plumes ou phanères, non nécessairement issus d''une mue. ');
INSERT INTO ObservationMethodeValue VALUES ('12','Reste de repas','Observation indirecte par le biais de restes de l''alimentation de l''individu ');
INSERT INTO ObservationMethodeValue VALUES ('13','Spore','Identification d''un individu ou groupe d''individus d''un taxon par l''observation de spores, corpuscules unicellulaires ou pluricellulaires pouvant donner naissance sans fécondation à un nouvel individu. Chez les végétaux, corpuscules reproducteurs donnant des prothalles rudimentaires mâles et femelles (correspondant respectivement aux grains de pollen et au sac embryonnaire), dont les produits sont les gamètes.');
INSERT INTO ObservationMethodeValue VALUES ('14','Pollen','Observation indirecte d''un individu ou groupe d''individus d''un taxon par l''observation de pollen, poussière très fine produite dans les loges des anthères et dont chaque grain microscopique est un utricule ou petit sac membraneux contenant le fluide fécondant (d''apr. Bouillet 1859).');
INSERT INTO ObservationMethodeValue VALUES ('15','Oosphère','Observation indirecte. Cellule sexuelle femelle chez les végétaux qui, après sa fécondation, devient l''oeuf. ');
INSERT INTO ObservationMethodeValue VALUES ('16','Ovule','Observation indirecte. Organe contenant le gamète femelle. Macrosporange des spermaphytes. ');
INSERT INTO ObservationMethodeValue VALUES ('17','Fleur','Identification d''un individu ou groupe d''individus d''un taxon par l''observation de fleurs. La fleur correspond à un ensemble de feuilles modifiées, en enveloppe florale et en organe sexuel, disposées sur un réceptacle. Un pédoncule la relie à la tige. (ex : chaton). ');
INSERT INTO ObservationMethodeValue VALUES ('18','Feuille','Identification d''un individu ou groupe d''individus d''un taxon par l''observation de feuilles. Organe aérien très important dans la nutrition de la plante, lieu de la photosynthèse qui aboutit à des composés organiques (sucres, protéines) formant la sève.');
INSERT INTO ObservationMethodeValue VALUES ('19','ADN environnemental','Séquence ADN trouvée dans un prélèvement environnemental (eau ou sol)');
INSERT INTO ObservationMethodeValue VALUES ('20','Autre','Pour tout cas qui ne rentrerait pas dans la présente liste. Le nombre d''apparitions permettra de faire évoluer la nomenclature.');
INSERT INTO ObservationMethodeValue VALUES ('21','Inconnu','Inconnu : La méthode n''est pas mentionnée dans les documents de l''observateur (bibliographie par exemple). ');
INSERT INTO ObservationMethodeValue VALUES ('22','Mine','Galerie forée dans l''épaisseur d''une feuille, entre l''épiderme supérieur et l''épiderme inférieur par des larves.');
INSERT INTO ObservationMethodeValue VALUES ('23','Galerie/Terrier','Galerie forée dans le bois, les racines ou les tiges, par des larves (Lépidoptères, Coléoptères, Diptères) ou creusée dans la terre (micro-mammifères, mammifères... ).');
INSERT INTO ObservationMethodeValue VALUES ('24','Oothèque','Membrane-coque qui protège la ponte de certains insectes et certains mollusques.');
INSERT INTO ObservationMethodeValue VALUES ('25','Vu et entendu','Vu et entendu : l''occurrence a à la fois été vue et entendue.');



CREATE TABLE OccurrenceEtatBiologiqueValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceEtatBiologiqueValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceEtatBiologiqueValue ADD CONSTRAINT OccurrenceEtatBiologiqueValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceEtatBiologiqueValue VALUES ('0','NSP','Inconnu (peut être utilisé pour les virus ou les végétaux fanés par exemple).');
INSERT INTO OccurrenceEtatBiologiqueValue VALUES ('1','Non renseigné','L''information n''a pas été renseignée.');
INSERT INTO OccurrenceEtatBiologiqueValue VALUES ('2','Observé vivant','L''individu a été observé vivant. ');
INSERT INTO OccurrenceEtatBiologiqueValue VALUES ('3','Trouvé mort','L''individu a été trouvé mort : Cadavre entier ou crâne par exemple. La mort est antérieure au processus d''observation. ');



CREATE TABLE OccurrenceNaturalisteValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceNaturalisteValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceNaturalisteValue ADD CONSTRAINT OccurrenceNaturalisteValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceNaturalisteValue VALUES ('0','Inconnu','Inconnu : la naturalité du sujet est inconnue');
INSERT INTO OccurrenceNaturalisteValue VALUES ('1','Sauvage','Sauvage : Qualifie un animal ou végétal à l''état sauvage, individu autochtone, se retrouvant dans son aire de répartition naturelle et dont les individus sont le résultat d''une reproduction naturelle, sans intervention humaine.');
INSERT INTO OccurrenceNaturalisteValue VALUES ('2','Cultivé/élevé','Cultivé/élevé : Qualifie un individu d''une population allochtone introduite volontairement dans des espaces non naturels dédiés à la culture, ou à l''élevage.');
INSERT INTO OccurrenceNaturalisteValue VALUES ('3','Planté','Planté : Qualifie un végétal d''une population allochtone introduite ponctuellement et volontairement dans un espace naturel/semi naturel.');
INSERT INTO OccurrenceNaturalisteValue VALUES ('4','Féral','Féral : Qualifie un animal élevé retourné à l''état sauvage, individu d''une population allochtone.');
INSERT INTO OccurrenceNaturalisteValue VALUES ('5','Subspontané','Subspontané : Qualifie un végétal d''une population allochtone, introduite volontairement, qui persiste plus ou moins longtemps dans sa station d’origine et qui a une dynamique propre peu étendue et limitée aux alentours de son implantation initiale. "Echappée des jardins".');




CREATE TABLE OccurrenceSexeValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceSexeValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceSexeValue ADD CONSTRAINT OccurrenceSexeValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceSexeValue VALUES ('0','Inconnu','Inconnu : Il n''y a pas d''information disponible pour cet individu. ');
INSERT INTO OccurrenceSexeValue VALUES ('1','Indéterminé','Indéterminé : Le sexe de l''individu n''a pu être déterminé');
INSERT INTO OccurrenceSexeValue VALUES ('2','Femelle','Féminin : L''individu est de sexe féminin.');
INSERT INTO OccurrenceSexeValue VALUES ('3','Mâle','Masuclin : L''individu est de sexe masculin.');
INSERT INTO OccurrenceSexeValue VALUES ('4','Hermaphrodite','Hermaphrodite : L''individu est hermaphrodite.');
INSERT INTO OccurrenceSexeValue VALUES ('5','Mixte','Mixte : Sert lorsque l''on décrit plusieurs individus.');
INSERT INTO OccurrenceSexeValue VALUES ('6','Non renseigné : l''information n''a pas été renseignée dans le document à l''origine de la donnée.');




CREATE TABLE OccurrenceStadeDeVieValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceStadeDeVieValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceStadeDeVieValue ADD CONSTRAINT OccurrenceStadeDeVieValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceStadeDeVieValue VALUES ('0','Inconnu','Le stade de vie de l''individu n''est pas connu. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('1','Indéterminé','Le stade de vie de l''individu n''a pu être déterminé (observation insuffisante pour la détermination).');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('2','Adulte','L''individu est au stade adulte.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('3','Juvénile','L''individu n''a pas encore atteint le stade adulte. C''est un individu jeune.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('4','Immature','Individu n''ayant pas atteint sa maturité sexuelle. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('5','Sub-adulte','Individu ayant presque atteint la taille adulte mais qui n''est pas considéré en tant que tel par ses congénères. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('6','Larve','Individu dans l''état où il est en sortant de l''oeuf, état dans lequel il passe un temps plus ou moins long avant métamorphose. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('7','Chenille','Larve éruciforme des lépidoptères ou papillons.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('8','Têtard','Larve de batracien.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('9','Oeuf','L''individu se trouve dans un oeuf, ou au sein d''un regroupement d''oeufs (ponte)');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('10','Mue','L''individu est en cours de mue (pour les reptiles : renouvellement de la peau, pour les oiseaux/mammifères : renouvellement du plumage/pelage, pour les cervidés : chute des bois).');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('11','Exuviation','L''individu est en cours d''exuviation : l''exuvie est une enveloppe (cuticule chitineuse ou peau) que le corps de l''animal a quittée lors de la mue ou de la métamorphose. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('12','Chrysalide','Nymphe des lépidoptères ou papillons.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('13','Nymphe','Stade de développement intermédiaire, entre larve et imago, pendant lequel l''individu ne se nourrit pas. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('14','Pupe','Nymphe des diptères. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('15','Imago','Stade final d''un individu dont le développement se déroule en plusieurs phases (en général, oeuf, larve, imago). ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('16','Sub-imago','Stade de développement chez certains insectes : insecte mobile, incomplet et sexuellement immature, bien qu''évoquant assez fortement la forme définitive de l''adulte, l''imago.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('17','Alevin','L''individu, un poisson, est à un stade juvénile');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('18','Germination','L''individu est en cours de germination.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('19','Fané','L''individu est altéré dans ses couleurs et sa fraîcheur, par rapport à un individu normal. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('20','Graine','La graine est la structure qui contient et protège l''embryon végétal.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('21','Thalle, protothalle','Un thalle est un appareil végétatif ne possédant ni feuilles, ni tiges, ni racines, produit par certains organismes non mobiles. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('22','Tubercule','Un tubercule est un organe de réserve, généralement souterrain, assurant la survie des plantes pendant la saison d''hiver ou en période de sécheresse, et souvent leur multiplication par voie végétative.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('23','Bulbe','Un bulbe est une pousse souterraine verticale disposant de feuilles modifiées utilisées comme organe de stockage de nourriture par une plante à dormance.');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('24','Rhizome','Le rhizome est une tige souterraine et parfois subaquatique remplie de réserves alimentaires chez certaines plantes vivaces. ');
INSERT INTO OccurrenceStadeDeVieValue VALUES ('25','Emergent','L''individu est au stade émergent : sortie de l''oeuf. ');




CREATE TABLE OccurrenceStatutBiogeographiqueValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceStatutBiogeographiqueValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceStatutBiogeographiqueValue ADD CONSTRAINT OccurrenceStatutBiogeographiqueValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('0','Inconnu / Cryptogène','Individu dont le taxon a une aire d’origine inconnue qui fait qu''on ne peut donc pas dire s’il est indigène ou introduit.');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('1','Non renseigné','Individu pour lequel l''information n''a pas été renseignée. ');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('2','Présent (indigène ou indéterminé)','Individu d''un taxon présent au sens large dans la zone géographique considérée, c''est-à-dire taxon indigène ou taxon dont on ne sait pas s’il appartient à l''une des autres catégories. Le défaut de connaissance profite donc à l’indigénat.');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('3','Introduit','Taxon introduit (établi ou possiblement établi) au niveau local. Par introduit on entend : taxon dont la présence locale est due à une intervention humaine, intentionnelle ou non, ou taxon qui est arrivé dans la zone sans intervention humaine mais à partir d’une zone dans laquelle il est introduit.');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('4','Introduit envahissant','Individu d''un taxon introduit localement, qui produit des descendants fertiles souvent en grand nombre, et qui a le potentiel pour s''étendre de façon exponentielle sur une grande aire, augmentant ainsi rapidement son aire de répartition.');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('5','Introduit non établi (dont domestique)','Individu dont le taxon est introduit, qui se reproduit occasionnellement hors de son aire de culture ou captivité, mais qui ne peut se maintenir à l''état sauvage. ');
INSERT INTO OccurrenceStatutBiogeographiqueValue VALUES ('6','Occasionnel','Individu dont le taxon est occasionnel, non nicheur, accidentel ou exceptionnel dans la zone géographique considérée (par exemple migrateur de passage), qui est locale. ');




CREATE TABLE OccurrenceStatutBiologiqueValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.OccurrenceStatutBiologiqueValue OWNER TO postgres;

ALTER TABLE ONLY OccurrenceStatutBiologiqueValue ADD CONSTRAINT OccurrenceStatutBiologiqueValue_pkey PRIMARY KEY (code);

INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('0','Inconnu','Inconnu : Le statut biologique de l''individu n''est pas connu.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('1','Non renseigné','Non renseigné : Le statut biologique de l''individu n''a pas été renseigné.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('2','Non déterminable','Non déterminé : Le statut biologique de l''individu n''a pas pu être déterminé.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('3','Reproduction','Reproduction : Le sujet d''observation en est au stade de reproduction (nicheur, gravide, carpophore, floraison, fructification…) ');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('4','Hibernation','Hibrenation : L’hibernation est un état d’hypothermie régulée, durant plusieurs jours ou semaines qui permet aux animaux de conserver leur énergie pendant l’hiver.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('5','Estivation','Estivation : L''estivation est un phénomène analogue à celui de l''hibernation, au cours duquel les animaux tombent en léthargie. L''estivation se produit durant les périodes les plus chaudes et les plus sèches de l''été.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('6','Halte migratoire','Halte migratoire : Indique que l''individu procède à une halte au cours de sa migration, et a été découvert sur sa zone de halte. ');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('7','Swarming','Swarming : Indique que l''individu a un comportement de swarming : il se regroupe avec d''autres individus de taille similaire, sur une zone spécifique, ou en mouvement.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('8','Chasse / alimentation','Chasse / alimentation : Indique que l''individu est sur une zone qui lui permet de chasser ou de s''alimenter. ');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('9','Pas de reproduction / Végétatif','Pas de reproduction : Indique que l''individu n''a pas un comportement reproducteur. Chez les végétaux : absence de fleurs, de fruits…');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('10','Passage en vol','Passage en vol : Indique que l''individu est de passage et en vol.');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('11','Erratique','Erratique : Individu d''une ou de populations d''un taxon qui ne se trouve, actuellement, que de manière occasionnelle dans les limites d’une région. Il a été retenu comme seuil, une absence de 80% d''un laps de temps donné (année, saisons...).');
INSERT INTO OccurrenceStatutBiologiqueValue VALUES ('12','Sédentaire','Sédentaire : Individu demeurant à un seul emplacement, ou restant toute l''année dans sa région d''origine, même s''il effectue des déplacements locaux.');




CREATE TABLE PreuveExistanteValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.PreuveExistanteValue OWNER TO postgres;

ALTER TABLE ONLY PreuveExistanteValue ADD CONSTRAINT PreuveExistanteValue_pkey PRIMARY KEY (code);

INSERT INTO PreuveExistanteValue VALUES ('0','NSP','Indique que la personne ayant fourni la donnée ignore s''il existe une preuve');
INSERT INTO PreuveExistanteValue VALUES ('1','Oui','Indique qu''une preuve existe ou a existé pour la détermination, qu''elle soit répertoriée ou non.');
INSERT INTO PreuveExistanteValue VALUES ('2','Non','Indique l''absence de preuve.');
INSERT INTO PreuveExistanteValue VALUES ('3','NonAcquise','NonAcquise : La donnée de départ mentionne une preuve, ou non, mais n''est pas suffisamment standardisée pour qu''il soit possible de récupérer des informations. L''information n''est donc pas acquise lors du transfert.');



CREATE TABLE SensibiliteValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.SensibiliteValue OWNER TO postgres;

ALTER TABLE ONLY SensibiliteValue ADD CONSTRAINT SensibiliteValue_pkey PRIMARY KEY (code);

INSERT INTO SensibiliteValue VALUES ('0','Non sensible','Précision maximale telle que saisie (non sensible). Statut par défaut.');
INSERT INTO SensibiliteValue VALUES ('1','Département, maille, espace, commune, ZNIEFF','Département, maille, espace, commune, ZNIEFF ');
INSERT INTO SensibiliteValue VALUES ('2','Département et maille 10 x 10 km','Département et maille 10 x 10 km ');
INSERT INTO SensibiliteValue VALUES ('3','Département seulement','Département seulement ');
INSERT INTO SensibiliteValue VALUES ('4','Aucune diffusion (cas exceptionnel)','Aucune diffusion (cas exceptionnel)');



CREATE TABLE SensibleValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.SensibleValue OWNER TO postgres;

ALTER TABLE ONLY SensibleValue ADD CONSTRAINT SensibleValue_pkey PRIMARY KEY (code);

INSERT INTO SensibleValue VALUES ('1','OUI','Indique que la donnée est sensible. ');
INSERT INTO SensibleValue VALUES ('0','NON','Indique que la donnée n''est pas sensible (par défaut, équivalent au niveau "0" des niveaux de sensibilité). ');


CREATE TABLE SensiAlerteValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.SensiAlerteValue OWNER TO postgres;

ALTER TABLE ONLY SensiAlerteValue ADD CONSTRAINT SensiAlerteValue_pkey PRIMARY KEY (code);

INSERT INTO SensiAlerteValue VALUES ('1','OUI','Indique que la sensibilité de la donnée doit être attribuée manuellement. ');
INSERT INTO SensiAlerteValue VALUES ('0','NON','Indique que la sensibilité de la donnée a été attribuée, automatiquement ou manuellement. ');


CREATE TABLE SensiManuelleValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.SensiManuelleValue OWNER TO postgres;

ALTER TABLE ONLY SensiManuelleValue ADD CONSTRAINT SensiManuelleValue_pkey PRIMARY KEY (code);

INSERT INTO SensiManuelleValue VALUES ('1','OUI','Indique que la sensibilité de la donnée a été attribuée manuellement. ');
INSERT INTO SensiManuelleValue VALUES ('0','NON','Indique que la sensibilité de la donnée a été attribuée automatiquement. ');



CREATE TABLE TypeAttributValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.TypeAttributValue OWNER TO postgres;

ALTER TABLE ONLY TypeAttributValue ADD CONSTRAINT TypeAttributValue_pkey PRIMARY KEY (code);

INSERT INTO TypeAttributValue VALUES ('QTA','Quantitatif','Le paramètre est de type quantitatif : il peut être mesuré par une valeur numérique.');
INSERT INTO TypeAttributValue VALUES ('QUAL','Qualitatif','Le paramètre est de type qualitatif : Il décrit une qualité qui ne peut être définie par une quantité numérique.');



CREATE TABLE TypeInfoGeoValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.TypeInfoGeoValue OWNER TO postgres;

ALTER TABLE ONLY TypeInfoGeoValue ADD CONSTRAINT TypeInfoGeoValue_pkey PRIMARY KEY (code);

INSERT INTO TypeInfoGeoValue VALUES ('1','Géoréférencement','Géoréférencement de l''objet géographique. L''objet géographique est celui sur lequel on a effectué l''observation.');
INSERT INTO TypeInfoGeoValue VALUES ('2','Rattachement','Rattachement à l''objet géographique : l''objet géographique n''est pas la géoréférence d''origine, ou a été déduit d''informations autres.');



CREATE TABLE TypeRegroupementValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.TypeRegroupementValue OWNER TO postgres;

ALTER TABLE ONLY TypeRegroupementValue ADD CONSTRAINT TypeRegroupementValue_pkey PRIMARY KEY (code);

INSERT INTO TypeRegroupementValue VALUES ('AUTR','Autre','La valeur n''est pas contenue dans la présente liste. Elle doit être complétée par d''autres informations.');
INSERT INTO TypeRegroupementValue VALUES ('CAMP','Campagne','Campagne de prélèvement');
INSERT INTO TypeRegroupementValue VALUES ('INVSTA','Inventaire stationnel','Inventaire stationnel ');
INSERT INTO TypeRegroupementValue VALUES ('LIEN','Lien entre observations','Lien : Indique un lien fort entre 2 observations.');
INSERT INTO TypeRegroupementValue VALUES ('NSP','Inconnu','Ne sait pas : l''information n''est pas connue.');
INSERT INTO TypeRegroupementValue VALUES ('OBS','Observations','Observations ');
INSERT INTO TypeRegroupementValue VALUES ('OP','Opération','Opération ');
INSERT INTO TypeRegroupementValue VALUES ('PASS','Passage','Passage');
INSERT INTO TypeRegroupementValue VALUES ('POINT','Point','Point de prélèvement ou point d''observation.');
INSERT INTO TypeRegroupementValue VALUES ('REL','Relevé','Relevé');
INSERT INTO TypeRegroupementValue VALUES ('STRAT','Strate','Strate ');


CREATE TABLE VersionMasseDEauValue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.VersionMasseDEauValue OWNER TO postgres;

ALTER TABLE ONLY VersionMasseDEauValue ADD CONSTRAINT VersionMasseDEauValue_pkey PRIMARY KEY (code);

INSERT INTO VersionMasseDEauValue VALUES ('1','Rap2010','Version issue du rapportage 2010 pour l''Europe ');
INSERT INTO VersionMasseDEauValue VALUES ('2','Int2013','Version intermédiaire de 2013');
INSERT INTO VersionMasseDEauValue VALUES ('3','Rap2016','Version issue du rapportage 2016 pour l''Europe ');



CREATE TABLE deefloutagevalue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.DEEFloutageValue OWNER TO postgres;

ALTER TABLE ONLY DEEFloutageValue ADD CONSTRAINT DEEFloutageValue_pkey PRIMARY KEY (code);

INSERT INTO DEEFloutageValue VALUES ('OUI','OUI','Indique qu''un floutage a eu lieu.');
INSERT INTO DEEFloutageValue VALUES ('NON','NON','Indique qu''aucun floutage a eu lieu.');



CREATE TABLE idcnpvalue (
    code character varying(32),
    label character varying(128),
    definition character varying(510)
);

ALTER TABLE referentiels.IDCNPValue OWNER TO postgres;

ALTER TABLE ONLY IDCNPValue ADD CONSTRAINT IDCNPValue_pkey PRIMARY KEY (code);

INSERT INTO IDCNPValue VALUES ('Nan','Pas de référentiel','Pas de référentiel');



CREATE TABLE referentiels.taxostatutvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT taxostatutvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.taxostatutvalue OWNER TO postgres;

INSERT INTO referentiels.taxostatutvalue(code, label, definition) VALUES
    ('0', 'Diffusé', 'Diffusé'),
    ('1', 'Gel', 'Gel')
;


CREATE TABLE referentiels.taxomodifvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT taxomodifvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.taxomodifvalue OWNER TO postgres;

INSERT INTO referentiels.taxomodifvalue(code, label, definition) VALUES
    ('0', 'Modification TAXREF', 'Modification TAXREF'),
    ('1', 'Gel TAXREF', 'Gel TAXREF'),
    ('2', 'Suppression TAXREF', 'Suppression TAXREF'),
    ('3', 'Splittage TAXREF', 'Splittage TAXREF')	
;



CREATE TABLE referentiels.taxoalertevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT taxoalertvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.taxoalertevalue OWNER TO postgres;

INSERT INTO referentiels.taxoalertevalue(code, label, definition) VALUES
	('0', 'Oui', 'Taxon en alerte suite à la migration de TAXREF'),
	('1', 'Non', 'Taxon sans alerte suite à la migration de TAXREF')
;



CREATE TABLE referentiels.complexehabitatvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT complexehabitatvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.complexehabitatvalue OWNER TO postgres ;

INSERT INTO referentiels.complexehabitatvalue (code, label, definition) VALUES
    ('1', 'Mosaïque spatiale', 'Mosaïque spatiale'),
    ('2', 'Mosaïque temporelle', 'Mosaïque temporelle'),
    ('3', 'Complexe d''habitats', 'Complexe d''habitats')
;


CREATE TABLE referentiels.expositionvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT expositionvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.expositionvalue OWNER TO postgres ;

INSERT INTO referentiels.expositionvalue (code, label, definition) VALUES 
    ('E', 'Est : 78,75° - 101,25°', 'Est : 78,75° - 101,25°'),
    ('ENE', 'Est-Nord-Est : 56.25° - 78.75°', 'Est-Nord-Est : 56.25° - 78.75°'),
    ('ESE', 'Est-Sud-Est : 101.25° - 123.75°', 'Est-Sud-Est : 101.25° - 123.75°'),
    ('N', 'Nord : 348.75° - 11.25°', 'Nord : 348.75° - 11.25°'),
    ('NE', 'Nord-Est : 33.75° - 56.25°', 'Nord-Est : 33.75° - 56.25°'),
    ('NNE', 'Nord-Nord-Est : 11.25° - 33.75°', 'Nord-Nord-Est : 11.25° - 33.75°'),
    ('NNO', 'Nord-Nord-Ouest : 326.25° - 348.75°', 'Nord-Nord-Ouest : 326.25° - 348.75°'),
    ('NO', 'Nord-Ouest : 303.75° - 326.25 °', 'Nord-Ouest : 303.75° - 326.25 °'),
    ('O', 'Ouest : 258.75° - 281.25°', 'Ouest : 258.75° - 281.25°'),
    ('ONO', 'Ouest-Nord-Ouest : 281.25° - 303.75°', 'Ouest-Nord-Ouest : 281.25° - 303.75°'),
    ('OSO', 'Ouest-Sud-Ouest : 236.25° - 258.75°', 'Ouest-Sud-Ouest : 236.25° - 258.75°'),
    ('S', 'Sud : 168.75° - 191.25°', 'Sud : 168.75° - 191.25°'),
    ('SE', 'Sud-Est : 123.75°- 146.25°', 'Sud-Est : 123.75°- 146.25°'),
    ('SO', 'Sud-Ouest : 213.75° - 236.25°', 'Sud-Ouest : 213.75° - 236.25°'),
    ('SSE', 'Sud-Sud-Est : 146.25° - 168.75°', 'Sud-Sud-Est : 146.25° - 168.75°'),
    ('SSO', 'Sud-Sud-Ouest : 191.25° - 213.75°', 'Sud-Sud-Ouest : 191.25° - 213.75°')
;

CREATE TABLE referentiels.methodecalculsurfacevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT methodecalculsurfacevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.methodecalculsurfacevalue OWNER TO postgres ;

INSERT INTO referentiels.methodecalculsurfacevalue (code, label, definition) VALUES
    ('es', 'Estimée : la surface est estimée par l''opérateur.', 'Estimée : la surface est estimée par l''opérateur.'),
    ('lin', 'Calculée à partir de la largeur du linéaire', 'Calculée à partir de la largeur du linéaire'), 
    ('sig', 'La surface est calculée directement par usage d''un logiciel SIG.', 'La surface est calculée directement par usage d''un logiciel SIG.'),
    ('nsp', 'Ne sait pas : la méthode de calcul est inconnue.', 'Ne sait pas : la méthode de calcul est inconnue.')
;


CREATE TABLE referentiels.typesolvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT typesolvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.typesolvalue OWNER TO postgres ;

INSERT INTO referentiels.typesolvalue (code, label, definition) VALUES 
    ('1', 'Anthroposol', 'Anthroposol'),
    ('2', 'Lithosol', 'Lithosol'),
    ('3', 'Régosol', 'Régosol'),
    ('4', 'Cryosol', 'Cryosol'),
    ('5', 'Rédoxisol', 'Rédoxisol'),
    ('6', 'Réductisol', 'Réductisol'),
    ('7', 'Histosol', 'Histosol'),
    ('8', 'Colluviosol', 'Colluviosol'),
    ('9', 'Peyrosol', 'Peyrosol'),
    ('10', 'Arénosol', 'Arénosol'),
    ('11', 'Vertisol', 'Vertisol'),
    ('12', 'Leptimectisol', 'Leptimectisol'),
    ('13', 'Pélosol', 'Pélosol'),
    ('14', 'Nitosol', 'Nitosol'),
    ('15', 'Andosol', 'Andosol'),
    ('16', 'Gyposol', 'Gyposol'),
    ('17', 'Salisol', 'Salisol'),
    ('18', 'Sodisol', 'Sodisol'),
    ('19', 'Organosol', 'Organosol'),
    ('20', 'Rankosol', 'Rankosol'),
    ('21', 'Veracrisol', 'Veracrisol'),
    ('22', 'Chernosol', 'Chernosol'),
    ('23', 'Phaerosol', 'Phaerosol'),
    ('24', 'Podzosol', 'Podzosol'),
    ('25', 'Fersialsol', 'Fersialsol'),
    ('26', 'Brunisol', 'Brunisol'),
    ('27', 'Alocrisol', 'Alocrisol'),
    ('28', 'Luvisol', 'Luvisol'),
    ('29', 'Planosol', 'Planosol'),
    ('30', 'Pélosol', 'Pélosol'),
    ('31', 'Basisol', 'Basisol')
;


CREATE TABLE referentiels.geologievalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT geologievalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.geologievalue OWNER TO postgres ;

INSERT INTO referentiels.geologievalue (code, label, definition) VALUES
    ('1','Alluvions','Alluvions'),
    ('10','Andésite','Andésite'),
    ('100','Roche magmatique','Roche magmatique'),
    ('101','Roche métamorphique','Roche métamorphique'),
    ('102','Roche plutonique','Roche plutonique'),
    ('103','Roche sédimentaire','Roche sédimentaire'),
    ('104','Roche ultrabasique','Roche ultrabasique'),
    ('105','Roche volcanique','Roche volcanique'),
    ('106','Sables','Sables'),
    ('107','Sables argileux','Sables argileux'),
    ('108','Sables fins','Sables fins'),
    ('109','Sables grossiers','Sables grossiers'),
    ('11','Anhydrite','Anhydrite'),
    ('110','Sables moyens','Sables moyens'),
    ('111','Sancyte','Sancyte'),
    ('112','Schistes','Schistes'),
    ('113','Schistes bitumeux','Schistes bitumeux'),
    ('114','Schistes bleus','Schistes bleus'),
    ('115','Schistes cristallins','Schistes cristallins'),
    ('116','Schistes verts','Schistes verts'),
    ('117','Serpentinite','Serpentinite'),
    ('118','Silt','Silt'),
    ('119','Syénite','Syénite'),
    ('12','Ardoise','Ardoise'),
    ('120','Syénite néphélinique','Syénite néphélinique'),
    ('121','Sylvinite (Potasse)','Sylvinite (Potasse)'),
    ('122','Tahitite','Tahitite'),
    ('123','Tonalite','Tonalite'),
    ('124','Tourbe','Tourbe'),
    ('125','Trachy-andésite','Trachy-andésite'),
    ('126','Trachy-basalte','Trachy-basalte'),
    ('127','Trachyte','Trachyte'),
    ('128','Tufs et travertin','Tufs et travertin'),
    ('129','Turbidite','Turbidite'),
    ('13','Arènes (granitiques ou gneissiques)','Arènes (granitiques ou gneissiques)'),
    ('130','Vases consolidées','Vases consolidées'),
    ('131','Vaugnerite','Vaugnerite'),
    ('132','Vogesite','Vogesite'),
    ('133','Vosgesite','Vosgesite'),
    ('134','Werhlite','Werhlite'),
    ('14','Argiles','Argiles'),
    ('15','Argiles sableuses','Argiles sableuses'),
    ('16','Ariegite','Ariegite'),
    ('17','Arkoses','Arkoses'),
    ('18','Avezacite','Avezacite'),
    ('19','Basalte','Basalte'),
    ('2','Alluvions caillouteuses (galets, graviers, sables)','Alluvions caillouteuses (galets, graviers, sables)'),
    ('20','Blavierite','Blavierite'),
    ('21','Blocs','Blocs'),
    ('22','Calcaires','Calcaires'),
    ('23','Calcaires dolomitiques','Calcaires dolomitiques'),
    ('24','Calcaires marneux','Calcaires marneux'),
    ('25','Calcschistes','Calcschistes'),
    ('26','Cantalite','Cantalite'),
    ('27','Conglomérat (brèches ou poudingues)','Conglomérat (brèches ou poudingues)'),
    ('28','Conglomérats compacts','Conglomérats compacts'),
    ('29','Cornéenne','Cornéenne'),
    ('3','Alluvions graveleuses (graviers, sables)','Alluvions graveleuses (graviers, sables)'),
    ('30','Corsite','Corsite'),
    ('31','Craie','Craie'),
    ('32','Craie marneuse','Craie marneuse'),
    ('33','Dacite','Dacite'),
    ('34','Diorite','Diorite'),
    ('35','Dolomies','Dolomies'),
    ('36','Domite','Domite'),
    ('37','Doreite','Doreite'),
    ('38','Dunite','Dunite'),
    ('39','Eclogite','Eclogite'),
    ('4','Altérites','Altérites'),
    ('40','Esterellite','Esterellite'),
    ('41','Evisite','Evisite'),
    ('42','Falun (sable coquillier)','Falun (sable coquillier)'),
    ('43','Florinite','Florinite'),
    ('44','Flysh argileux','Flysh argileux'),
    ('45','Flysh calcaire','Flysh calcaire'),
    ('46','Fraidonite','Fraidonite'),
    ('47','Gabbro','Gabbro'),
    ('48','Gaize','Gaize'),
    ('49','Galets (et cailloux)','Galets (et cailloux)'),
    ('5','Alternance gréso-calcaire','Alternance gréso-calcaire'),
    ('50','Gelé','Gelé'),
    ('51','Gneiss','Gneiss'),
    ('52','Granite','Granite'),
    ('53','Granitoide','Granitoide'),
    ('54','Granodiorite','Granodiorite'),
    ('55','Granulite','Granulite'),
    ('56','Graviers','Graviers'),
    ('57','Grès','Grès'),
    ('58','Gypse','Gypse'),
    ('59','Halite (Sel Gemme)','Halite (Sel Gemme)'),
    ('6','Alternance gréso-schisteuse','Alternance gréso-schisteuse'),
    ('60','Harzburgite','Harzburgite'),
    ('61','Hauynite, hauynitite','Hauynite, hauynitite'),
    ('62','Houille','Houille'),
    ('63','Jaspes (phtanites)','Jaspes (phtanites)'),
    ('64','Kersantite','Kersantite'),
    ('65','Lapillis (ou pouzzolane)','Lapillis (ou pouzzolane)'),
    ('66','Latite','Latite'),
    ('67','Lherzite','Lherzite'),
    ('68','Lherzolite','Lherzolite'),
    ('69','Lignite','Lignite'),
    ('7','Alternance marno-calcaire','Alternance marno-calcaire'),
    ('70','Limburgite','Limburgite'),
    ('71','Limon argileux','Limon argileux'),
    ('72','Limons','Limons'),
    ('73','Lindinosite','Lindinosite'),
    ('74','Lithologie inconnue','Lithologie inconnue'),
    ('75','Loess','Loess'),
    ('76','Luscladite','Luscladite'),
    ('77','Marbres et/ou cipolins','Marbres et/ou cipolins'),
    ('78','Mareugite','Mareugite'),
    ('79','Marnes','Marnes'),
    ('8','Alternance sablo-argileuse','Alternance sablo-argileuse'),
    ('80','Miagite','Miagite'),
    ('81','Micaschiste','Micaschiste'),
    ('82','Migmatites','Migmatites'),
    ('83','Molasse','Molasse'),
    ('84','Monzonite','Monzonite'),
    ('85','Moraines','Moraines'),
    ('86','Mylonite','Mylonite'),
    ('87','Napoleonite','Napoleonite'),
    ('88','Oceanite','Oceanite'),
    ('89','Ordanchite','Ordanchite'),
    ('9','Amphibolite','Amphibolite'),
    ('90','Ouenite','Ouenite'),
    ('91','Pegmatite','Pegmatite'),
    ('92','Peleite, peléeite','Peleite, peléeite'),
    ('93','Pélite','Pélite'),
    ('94','Péridotite','Péridotite'),
    ('95','Phonolite','Phonolite'),
    ('96','Pyromeride','Pyromeride'),
    ('97','Quartzites (métaquartzites)','Quartzites (métaquartzites)'),
    ('98','Quartzites (orthoquartzites)','Quartzites (orthoquartzites)'),
    ('99','Rhyolite','Rhyolite')
;



CREATE TABLE referentiels.aciditevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT aciditevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.aciditevalue OWNER TO postgres ;

INSERT INTO referentiels.aciditevalue (code, label, definition) VALUES 
    ('1', 'Acide', 'Acide'),
    ('2', 'Neutre', 'Neutre'),
    ('3', 'Basique', 'Basique')
;


CREATE TABLE referentiels.typedeterminationvalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT typedeterminationvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.typedeterminationvalue OWNER TO postgres ;

INSERT INTO referentiels.typedeterminationvalue (code, label, definition) VALUES
    ('0', 'Inconnu', 'Inconnu'),
    ('1', 'Attribué terrain', 'Attribué terrain'),
    ('2', 'Expertise a posteriori', 'Expertise a posteriori'),
    ('3', 'Correspondance typologique', 'Correspondance typologique')
;


CREATE TABLE referentiels.techniquecollectevalue(
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT techniquecollectevalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.techniquecollectevalue OWNER TO postgres ;

INSERT INTO referentiels.techniquecollectevalue (code, label, definition) VALUES
    ('0', 'Ne sait pas', 'Ne sait pas'),
    ('1', 'In situ : observation directe, sur le terrain', 'In situ : observation directe, sur le terrain'),
    ('2', 'Télédétection (satellite, LIDAR...)', 'Télédétection (satellite, LIDAR...)'),
    ('2.1', 'Lidar', 'Lidar'),
    ('2.2', 'Radar', 'Radar'),
    ('2.3', 'Imagerie numérique aéroportée', 'Imagerie numérique aéroportée'),
    ('2.4', 'Imagerie satellitaire', 'Imagerie satellitaire'),
    ('3', 'Techniques acoustiques', 'Techniques acoustiques'),
    ('3.1', 'Sonar à balayage latéral', 'Sonar à balayage latéral'),
    ('3.2', 'Sondeur multifaisceaux', 'Sondeur multifaisceaux'),
    ('3.3', 'Sonar à interféromètre', 'Sonar à interféromètre'),
    ('3.4', 'Système acoustique de classification automatique des natures de fonds', 'Système acoustique de classification automatique des natures de fonds'),
    ('3.5', 'Imagerie sismique', 'Imagerie sismique'),
    ('3.6', 'Sondeur de sédiments', 'Sondeur de sédiments'),
    ('3.7', 'Sondeur monofaisceau', 'Sondeur monofaisceau'),
    ('4', 'Modélisation', 'Modélisation'),
    ('5', 'Observation à distance (jumelles par exemple)', 'Observation à distance (jumelles par exemple)'),
    ('6', 'Observation directe marine (observation en plongée)', 'Observation directe marine (observation en plongée)'),
    ('7', 'Extrapolation', 'Extrapolation'),
    ('8', 'Techniques de prélèvements in situ', 'Techniques de prélèvements in situ'),
    ('8.1', 'Plongées', 'Plongées'),
    ('8.2', 'Mesures géotechniques', 'Mesures géotechniques'),
    ('8.3', 'Prélèvement à la benne', 'Prélèvement à la benne'),
    ('8.4', 'Prélèvement au chalut ou à la drague', 'Prélèvement au chalut ou à la drague'),
    ('8.4.1', 'Prélèvement au chalut', 'Prélèvement au chalut'),
    ('8.4.2', 'Prélèvement à la drague', 'Prélèvement à la drague'),
    ('8.5', 'Carottage', 'Carottage'),
    ('9', 'Vidéo et photographies', 'Vidéo et photographies'),
    ('9.1', 'Imagerie des profils sédimentaires', 'Imagerie des profils sédimentaires'),
    ('9.2', 'Caméra tractée ou téléguidée', 'Caméra tractée ou téléguidée'),
    ('9.3', 'Observation marine photographique (observation photographique en plongée)', 'Observation marine photographique (observation photographique en plongée)'),
    ('9.4', 'Observation photographique aérienne, prise de vue aérienne, suivie d''une photointerprétation', 'Observation photographique aérienne, prise de vue aérienne, suivie d''une photointerprétation'),
    ('9.5', 'Observation photographique terrestre suivie d''une photointerprétation.', 'Observation photographique terrestre suivie d''une photointerprétation.'),
    ('10', 'Autre, préciser.', 'Autre, préciser.')
;


CREATE TABLE referentiels.abondancehabitatvalue (
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT abondancehabitatvalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.abondancehabitatvalue OWNER TO postgres ;

INSERT INTO referentiels.abondancehabitatvalue (code, label, definition) VALUES
    ('1', 'Recouvrement très faible', 'Recouvrement très faible'),
    ('2', 'Habitat recouvrant environ 1/20 à 1/4 de la surface (5 à 25 %)', 'Habitat recouvrant environ 1/20 à 1/4 de la surface (5 à 25 %)'),
    ('3', 'Habitat recouvrant environ 1/4 à 1/2 de la surface (25 à 50 %)', 'Habitat recouvrant environ 1/4 à 1/2 de la surface (25 à 50 %)'),
    ('4', 'Habitat recouvrant environ 1/2 à 3/4 de la surface (50 à 75 %)', 'Habitat recouvrant environ 1/2 à 3/4 de la surface (50 à 75 %)'),
    ('5', 'Habitat recouvrant plus des 3/4 de la surface (>75 %)', 'Habitat recouvrant plus des 3/4 de la surface (>75 %)')
;


CREATE TABLE referentiels.niveausensivalue (
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT niveausensivalue_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.niveausensivalue OWNER TO postgres ;

INSERT INTO referentiels.niveausensivalue (code, label, definition) VALUES
    ('0', 'Pas de sensibilité particulière', 'Pas de sensibilité particulière'),
    ('2', 'Sensible', 'Sensible')
;




CREATE TABLE referentiels.habitatinteretcommunautairevalue (
    code varchar(32) NOT NULL,
    label varchar(128) NULL,
    definition varchar(510) NULL,
    CONSTRAINT habitatinteretcommunautaire_pkey PRIMARY KEY (code)
);

ALTER TABLE referentiels.habitatinteretcommunautairevalue OWNER TO postgres ;

INSERT INTO referentiels.habitatinteretcommunautairevalue (code, label, definition) VALUES
    ('1', 'Oui', 'L''habitat est d''intérêt communautaire'),
    ('2', 'Non', 'L''habitat n''est pas d''intérêt communautaire'),
    ('3', 'Oui, prioritaire', 'L''habitat est d''intérêt communautaire prioritaire')
;






REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM PUBLIC;
REVOKE ALL ON ALL TABLES IN SCHEMA referentiels FROM postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA  referentiels TO ogam;

