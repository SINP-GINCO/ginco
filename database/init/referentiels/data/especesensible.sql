--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.8
-- Dumped by pg_dump version 9.4.8
-- Started on 2016-07-20 09:31:28 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = referentiels, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 290 (class 1259 OID 116776)
-- Name: especesensible; Type: TABLE; Schema: referentiels; Owner: admin; Tablespace: 
--

CREATE TABLE especesensible (
    cd_dept character varying,
    id integer NOT NULL,
    cd_nom character varying(500),
    duree integer,
    codage integer,
    autre character varying(500),
    cd_sl integer,
    cd_occ_statut_biologique integer,
    nom_cite character varying(225)
);


ALTER TABLE especesensible OWNER TO admin;

--
-- TOC entry 289 (class 1259 OID 116774)
-- Name: especesensible_id_seq; Type: SEQUENCE; Schema: referentiels; Owner: admin
--

CREATE SEQUENCE especesensible_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE especesensible_id_seq OWNER TO admin;

--
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 289
-- Name: especesensible_id_seq; Type: SEQUENCE OWNED BY; Schema: referentiels; Owner: admin
--

ALTER SEQUENCE especesensible_id_seq OWNED BY especesensible.id;


--
-- TOC entry 3908 (class 2604 OID 116779)
-- Name: id; Type: DEFAULT; Schema: referentiels; Owner: admin
--

ALTER TABLE ONLY especesensible ALTER COLUMN id SET DEFAULT nextval('especesensible_id_seq'::regclass);


--
-- TOC entry 4028 (class 0 OID 116776)
-- Dependencies: 290
-- Data for Name: especesensible; Type: TABLE DATA; Schema: referentiels; Owner: admin
--

COPY especesensible (cd_dept, id, cd_nom, duree, codage, autre, cd_sl, cd_occ_statut_biologique, nom_cite) FROM stdin;
78	13633	240	20	1	\N	9	\N	Pelobates fuscus
92	13634	240	20	1	\N	9	\N	Pelobates fuscus
94	13635	240	20	1	\N	9	\N	Pelobates fuscus
95	13636	240	20	1	\N	9	\N	Pelobates fuscus
8	13637	240	20	1	\N	9	\N	Pelobates fuscus
10	13638	240	20	1	\N	9	\N	Pelobates fuscus
51	13639	240	20	1	\N	9	\N	Pelobates fuscus
2	13640	240	20	1	\N	9	\N	Pelobates fuscus
60	13641	240	20	1	\N	9	\N	Pelobates fuscus
27	13642	240	20	1	\N	9	\N	Pelobates fuscus
18	13643	240	20	1	\N	9	\N	Pelobates fuscus
36	13644	240	20	1	\N	9	\N	Pelobates fuscus
41	13645	240	20	1	\N	9	\N	Pelobates fuscus
45	13646	240	20	1	\N	9	\N	Pelobates fuscus
61	13647	240	20	1	\N	9	\N	Pelobates fuscus
21	13648	240	20	1	\N	9	\N	Pelobates fuscus
58	13649	240	20	1	\N	9	\N	Pelobates fuscus
89	13650	240	20	1	\N	9	\N	Pelobates fuscus
59	13651	240	20	1	\N	9	\N	Pelobates fuscus
54	13652	240	20	1	\N	9	\N	Pelobates fuscus
55	13653	240	20	1	\N	9	\N	Pelobates fuscus
57	13654	240	20	1	\N	9	\N	Pelobates fuscus
88	13655	240	20	1	\N	9	\N	Pelobates fuscus
25	13656	240	20	1	\N	9	\N	Pelobates fuscus
39	13657	240	20	1	\N	9	\N	Pelobates fuscus
70	13658	240	20	1	\N	9	\N	Pelobates fuscus
53	13659	240	20	1	\N	9	\N	Pelobates fuscus
56	13660	240	20	1	\N	9	\N	Pelobates fuscus
79	13661	240	20	1	\N	9	\N	Pelobates fuscus
86	13662	240	20	1	\N	9	\N	Pelobates fuscus
24	13663	240	20	1	\N	9	\N	Pelobates fuscus
40	13664	240	20	1	\N	9	\N	Pelobates fuscus
47	13665	240	20	1	\N	9	\N	Pelobates fuscus
64	13666	240	20	1	\N	9	\N	Pelobates fuscus
9	13667	240	20	1	\N	9	\N	Pelobates fuscus
12	13668	240	20	1	\N	9	\N	Pelobates fuscus
32	13669	240	20	1	\N	9	\N	Pelobates fuscus
65	13670	240	20	1	\N	9	\N	Pelobates fuscus
81	13671	240	20	1	\N	9	\N	Pelobates fuscus
82	13672	240	20	1	\N	9	\N	Pelobates fuscus
1	13673	240	20	1	\N	9	\N	Pelobates fuscus
26	13674	240	20	1	\N	9	\N	Pelobates fuscus
42	13675	240	20	1	\N	9	\N	Pelobates fuscus
73	13676	240	20	1	\N	9	\N	Pelobates fuscus
74	13677	240	20	1	\N	9	\N	Pelobates fuscus
3	13678	240	20	1	\N	9	\N	Pelobates fuscus
43	13679	240	20	1	\N	9	\N	Pelobates fuscus
11	13680	240	20	1	\N	9	\N	Pelobates fuscus
66	13681	240	20	1	\N	9	\N	Pelobates fuscus
4	13682	240	20	1	\N	9	\N	Pelobates fuscus
5	13683	240	20	1	\N	9	\N	Pelobates fuscus
6	13684	240	20	1	\N	9	\N	Pelobates fuscus
2B	13685	240	20	1	\N	9	\N	Pelobates fuscus
75	13686	240	20	1	\N	9	\N	Pelobates fuscus
77	13687	240	20	1	\N	9	\N	Pelobates fuscus
91	13688	240	20	1	\N	9	\N	Pelobates fuscus
93	13689	240	20	1	\N	9	\N	Pelobates fuscus
52	13690	240	20	1	\N	9	\N	Pelobates fuscus
80	13691	240	20	1	\N	9	\N	Pelobates fuscus
76	13692	240	20	1	\N	9	\N	Pelobates fuscus
28	13693	240	20	1	\N	9	\N	Pelobates fuscus
37	13694	240	20	1	\N	9	\N	Pelobates fuscus
14	13695	240	20	1	\N	9	\N	Pelobates fuscus
50	13696	240	20	1	\N	9	\N	Pelobates fuscus
71	13697	240	20	1	\N	9	\N	Pelobates fuscus
62	13698	240	20	1	\N	9	\N	Pelobates fuscus
67	13699	240	20	1	\N	9	\N	Pelobates fuscus
68	13700	240	20	1	\N	9	\N	Pelobates fuscus
90	13701	240	20	1	\N	9	\N	Pelobates fuscus
44	13702	240	20	1	\N	9	\N	Pelobates fuscus
49	13703	240	20	1	\N	9	\N	Pelobates fuscus
72	13704	240	20	1	\N	9	\N	Pelobates fuscus
85	13705	240	20	1	\N	9	\N	Pelobates fuscus
22	13706	240	20	1	\N	9	\N	Pelobates fuscus
29	13707	240	20	1	\N	9	\N	Pelobates fuscus
35	13708	240	20	1	\N	9	\N	Pelobates fuscus
16	13709	240	20	1	\N	9	\N	Pelobates fuscus
17	13710	240	20	1	\N	9	\N	Pelobates fuscus
33	13711	240	20	1	\N	9	\N	Pelobates fuscus
31	13712	240	20	1	\N	9	\N	Pelobates fuscus
46	13713	240	20	1	\N	9	\N	Pelobates fuscus
19	13714	240	20	1	\N	9	\N	Pelobates fuscus
23	13715	240	20	1	\N	9	\N	Pelobates fuscus
87	13716	240	20	1	\N	9	\N	Pelobates fuscus
7	13717	240	20	1	\N	9	\N	Pelobates fuscus
38	13718	240	20	1	\N	9	\N	Pelobates fuscus
69	13719	240	20	1	\N	9	\N	Pelobates fuscus
15	13720	240	20	1	\N	9	\N	Pelobates fuscus
63	13721	240	20	1	\N	9	\N	Pelobates fuscus
30	13722	240	20	1	\N	9	\N	Pelobates fuscus
34	13723	240	20	1	\N	9	\N	Pelobates fuscus
48	13724	240	20	1	\N	9	\N	Pelobates fuscus
13	13725	240	20	1	\N	9	\N	Pelobates fuscus
83	13726	240	20	1	\N	9	\N	Pelobates fuscus
84	13727	240	20	1	\N	9	\N	Pelobates fuscus
2A	13728	240	20	1	\N	9	\N	Pelobates fuscus
78	13729	18437	20	2	\N	9	\N	Austropotamobius pallipes
92	13730	18437	20	2	\N	9	\N	Austropotamobius pallipes
94	13731	18437	20	2	\N	9	\N	Austropotamobius pallipes
95	13732	18437	20	2	\N	9	\N	Austropotamobius pallipes
8	13733	18437	20	2	\N	9	\N	Austropotamobius pallipes
10	13734	18437	20	2	\N	9	\N	Austropotamobius pallipes
51	13735	18437	20	2	\N	9	\N	Austropotamobius pallipes
2	13736	18437	20	2	\N	9	\N	Austropotamobius pallipes
60	13737	18437	20	2	\N	9	\N	Austropotamobius pallipes
27	13738	18437	20	2	\N	9	\N	Austropotamobius pallipes
18	13739	18437	20	2	\N	9	\N	Austropotamobius pallipes
36	13740	18437	20	2	\N	9	\N	Austropotamobius pallipes
41	13741	18437	20	2	\N	9	\N	Austropotamobius pallipes
45	13742	18437	20	2	\N	9	\N	Austropotamobius pallipes
61	13743	18437	20	2	\N	9	\N	Austropotamobius pallipes
21	13744	18437	20	2	\N	9	\N	Austropotamobius pallipes
58	13745	18437	20	2	\N	9	\N	Austropotamobius pallipes
89	13746	18437	20	2	\N	9	\N	Austropotamobius pallipes
59	13747	18437	20	2	\N	9	\N	Austropotamobius pallipes
54	13748	18437	20	2	\N	9	\N	Austropotamobius pallipes
55	13749	18437	20	2	\N	9	\N	Austropotamobius pallipes
57	13750	18437	20	2	\N	9	\N	Austropotamobius pallipes
88	13751	18437	20	2	\N	9	\N	Austropotamobius pallipes
25	13752	18437	20	2	\N	9	\N	Austropotamobius pallipes
39	13753	18437	20	2	\N	9	\N	Austropotamobius pallipes
70	13754	18437	20	2	\N	9	\N	Austropotamobius pallipes
53	13755	18437	20	2	\N	9	\N	Austropotamobius pallipes
56	13756	18437	20	2	\N	9	\N	Austropotamobius pallipes
79	13757	18437	20	2	\N	9	\N	Austropotamobius pallipes
86	13758	18437	20	2	\N	9	\N	Austropotamobius pallipes
24	13759	18437	20	2	\N	9	\N	Austropotamobius pallipes
40	13760	18437	20	2	\N	9	\N	Austropotamobius pallipes
47	13761	18437	20	2	\N	9	\N	Austropotamobius pallipes
64	13762	18437	20	2	\N	9	\N	Austropotamobius pallipes
9	13763	18437	20	2	\N	9	\N	Austropotamobius pallipes
12	13764	18437	20	2	\N	9	\N	Austropotamobius pallipes
32	13765	18437	20	2	\N	9	\N	Austropotamobius pallipes
65	13766	18437	20	2	\N	9	\N	Austropotamobius pallipes
81	13767	18437	20	2	\N	9	\N	Austropotamobius pallipes
82	13768	18437	20	2	\N	9	\N	Austropotamobius pallipes
1	13769	18437	20	2	\N	9	\N	Austropotamobius pallipes
26	13770	18437	20	2	\N	9	\N	Austropotamobius pallipes
42	13771	18437	20	2	\N	9	\N	Austropotamobius pallipes
73	13772	18437	20	2	\N	9	\N	Austropotamobius pallipes
74	13773	18437	20	2	\N	9	\N	Austropotamobius pallipes
3	13774	18437	20	2	\N	9	\N	Austropotamobius pallipes
43	13775	18437	20	2	\N	9	\N	Austropotamobius pallipes
11	13776	18437	20	2	\N	9	\N	Austropotamobius pallipes
66	13777	18437	20	2	\N	9	\N	Austropotamobius pallipes
4	13778	18437	20	2	\N	9	\N	Austropotamobius pallipes
5	13779	18437	20	2	\N	9	\N	Austropotamobius pallipes
6	13780	18437	20	2	\N	9	\N	Austropotamobius pallipes
2B	13781	18437	20	2	\N	9	\N	Austropotamobius pallipes
75	13782	18437	20	2	\N	9	\N	Austropotamobius pallipes
77	13783	18437	20	2	\N	9	\N	Austropotamobius pallipes
91	13784	18437	20	2	\N	9	\N	Austropotamobius pallipes
93	13785	18437	20	2	\N	9	\N	Austropotamobius pallipes
52	13786	18437	20	2	\N	9	\N	Austropotamobius pallipes
80	13787	18437	20	2	\N	9	\N	Austropotamobius pallipes
76	13788	18437	20	2	\N	9	\N	Austropotamobius pallipes
28	13789	18437	20	2	\N	9	\N	Austropotamobius pallipes
37	13790	18437	20	2	\N	9	\N	Austropotamobius pallipes
14	13791	18437	20	2	\N	9	\N	Austropotamobius pallipes
50	13792	18437	20	2	\N	9	\N	Austropotamobius pallipes
71	13793	18437	20	2	\N	9	\N	Austropotamobius pallipes
62	13794	18437	20	2	\N	9	\N	Austropotamobius pallipes
67	13795	18437	20	2	\N	9	\N	Austropotamobius pallipes
68	13796	18437	20	2	\N	9	\N	Austropotamobius pallipes
90	13797	18437	20	2	\N	9	\N	Austropotamobius pallipes
44	13798	18437	20	2	\N	9	\N	Austropotamobius pallipes
49	13799	18437	20	2	\N	9	\N	Austropotamobius pallipes
72	13800	18437	20	2	\N	9	\N	Austropotamobius pallipes
85	13801	18437	20	2	\N	9	\N	Austropotamobius pallipes
22	13802	18437	20	2	\N	9	\N	Austropotamobius pallipes
29	13803	18437	20	2	\N	9	\N	Austropotamobius pallipes
35	13804	18437	20	2	\N	9	\N	Austropotamobius pallipes
16	13805	18437	20	2	\N	9	\N	Austropotamobius pallipes
17	13806	18437	20	2	\N	9	\N	Austropotamobius pallipes
33	13807	18437	20	2	\N	9	\N	Austropotamobius pallipes
31	13808	18437	20	2	\N	9	\N	Austropotamobius pallipes
46	13809	18437	20	2	\N	9	\N	Austropotamobius pallipes
19	13810	18437	20	2	\N	9	\N	Austropotamobius pallipes
23	13811	18437	20	2	\N	9	\N	Austropotamobius pallipes
87	13812	18437	20	2	\N	9	\N	Austropotamobius pallipes
7	13813	18437	20	2	\N	9	\N	Austropotamobius pallipes
38	13814	18437	20	2	\N	9	\N	Austropotamobius pallipes
69	13815	18437	20	2	\N	9	\N	Austropotamobius pallipes
15	13816	18437	20	2	\N	9	\N	Austropotamobius pallipes
63	13817	18437	20	2	\N	9	\N	Austropotamobius pallipes
30	13818	18437	20	2	\N	9	\N	Austropotamobius pallipes
34	13819	18437	20	2	\N	9	\N	Austropotamobius pallipes
48	13820	18437	20	2	\N	9	\N	Austropotamobius pallipes
13	13821	18437	20	2	\N	9	\N	Austropotamobius pallipes
83	13822	18437	20	2	\N	9	\N	Austropotamobius pallipes
84	13823	18437	20	2	\N	9	\N	Austropotamobius pallipes
2A	13824	18437	20	2	\N	9	\N	Austropotamobius pallipes
78	13825	53631	20	2	\N	9	\N	Coenonympha tullia
92	13826	53631	20	2	\N	9	\N	Coenonympha tullia
94	13827	53631	20	2	\N	9	\N	Coenonympha tullia
95	13828	53631	20	2	\N	9	\N	Coenonympha tullia
8	13829	53631	20	2	\N	9	\N	Coenonympha tullia
10	13830	53631	20	2	\N	9	\N	Coenonympha tullia
51	13831	53631	20	2	\N	9	\N	Coenonympha tullia
2	13832	53631	20	2	\N	9	\N	Coenonympha tullia
60	13833	53631	20	2	\N	9	\N	Coenonympha tullia
27	13834	53631	20	2	\N	9	\N	Coenonympha tullia
18	13835	53631	20	2	\N	9	\N	Coenonympha tullia
36	13836	53631	20	2	\N	9	\N	Coenonympha tullia
41	13837	53631	20	2	\N	9	\N	Coenonympha tullia
45	13838	53631	20	2	\N	9	\N	Coenonympha tullia
61	13839	53631	20	2	\N	9	\N	Coenonympha tullia
21	13840	53631	20	2	\N	9	\N	Coenonympha tullia
58	13841	53631	20	2	\N	9	\N	Coenonympha tullia
89	13842	53631	20	2	\N	9	\N	Coenonympha tullia
59	13843	53631	20	2	\N	9	\N	Coenonympha tullia
54	13844	53631	20	2	\N	9	\N	Coenonympha tullia
55	13845	53631	20	2	\N	9	\N	Coenonympha tullia
57	13846	53631	20	2	\N	9	\N	Coenonympha tullia
88	13847	53631	20	2	\N	9	\N	Coenonympha tullia
25	13848	53631	20	2	\N	9	\N	Coenonympha tullia
39	13849	53631	20	2	\N	9	\N	Coenonympha tullia
70	13850	53631	20	2	\N	9	\N	Coenonympha tullia
53	13851	53631	20	2	\N	9	\N	Coenonympha tullia
56	13852	53631	20	2	\N	9	\N	Coenonympha tullia
79	13853	53631	20	2	\N	9	\N	Coenonympha tullia
86	13854	53631	20	2	\N	9	\N	Coenonympha tullia
24	13855	53631	20	2	\N	9	\N	Coenonympha tullia
40	13856	53631	20	2	\N	9	\N	Coenonympha tullia
47	13857	53631	20	2	\N	9	\N	Coenonympha tullia
64	13858	53631	20	2	\N	9	\N	Coenonympha tullia
9	13859	53631	20	2	\N	9	\N	Coenonympha tullia
12	13860	53631	20	2	\N	9	\N	Coenonympha tullia
32	13861	53631	20	2	\N	9	\N	Coenonympha tullia
65	13862	53631	20	2	\N	9	\N	Coenonympha tullia
81	13863	53631	20	2	\N	9	\N	Coenonympha tullia
82	13864	53631	20	2	\N	9	\N	Coenonympha tullia
1	13865	53631	20	2	\N	9	\N	Coenonympha tullia
26	13866	53631	20	2	\N	9	\N	Coenonympha tullia
42	13867	53631	20	2	\N	9	\N	Coenonympha tullia
73	13868	53631	20	2	\N	9	\N	Coenonympha tullia
74	13869	53631	20	2	\N	9	\N	Coenonympha tullia
3	13870	53631	20	2	\N	9	\N	Coenonympha tullia
43	13871	53631	20	2	\N	9	\N	Coenonympha tullia
11	13872	53631	20	2	\N	9	\N	Coenonympha tullia
66	13873	53631	20	2	\N	9	\N	Coenonympha tullia
4	13874	53631	20	2	\N	9	\N	Coenonympha tullia
5	13875	53631	20	2	\N	9	\N	Coenonympha tullia
6	13876	53631	20	2	\N	9	\N	Coenonympha tullia
2B	13877	53631	20	2	\N	9	\N	Coenonympha tullia
75	13878	53631	20	2	\N	9	\N	Coenonympha tullia
77	13879	53631	20	2	\N	9	\N	Coenonympha tullia
91	13880	53631	20	2	\N	9	\N	Coenonympha tullia
93	13881	53631	20	2	\N	9	\N	Coenonympha tullia
52	13882	53631	20	2	\N	9	\N	Coenonympha tullia
80	13883	53631	20	2	\N	9	\N	Coenonympha tullia
76	13884	53631	20	2	\N	9	\N	Coenonympha tullia
28	13885	53631	20	2	\N	9	\N	Coenonympha tullia
37	13886	53631	20	2	\N	9	\N	Coenonympha tullia
14	13887	53631	20	2	\N	9	\N	Coenonympha tullia
50	13888	53631	20	2	\N	9	\N	Coenonympha tullia
71	13889	53631	20	2	\N	9	\N	Coenonympha tullia
62	13890	53631	20	2	\N	9	\N	Coenonympha tullia
67	13891	53631	20	2	\N	9	\N	Coenonympha tullia
68	13892	53631	20	2	\N	9	\N	Coenonympha tullia
90	13893	53631	20	2	\N	9	\N	Coenonympha tullia
44	13894	53631	20	2	\N	9	\N	Coenonympha tullia
49	13895	53631	20	2	\N	9	\N	Coenonympha tullia
72	13896	53631	20	2	\N	9	\N	Coenonympha tullia
85	13897	53631	20	2	\N	9	\N	Coenonympha tullia
22	13898	53631	20	2	\N	9	\N	Coenonympha tullia
29	13899	53631	20	2	\N	9	\N	Coenonympha tullia
35	13900	53631	20	2	\N	9	\N	Coenonympha tullia
16	13901	53631	20	2	\N	9	\N	Coenonympha tullia
17	13902	53631	20	2	\N	9	\N	Coenonympha tullia
33	13903	53631	20	2	\N	9	\N	Coenonympha tullia
31	13904	53631	20	2	\N	9	\N	Coenonympha tullia
46	13905	53631	20	2	\N	9	\N	Coenonympha tullia
19	13906	53631	20	2	\N	9	\N	Coenonympha tullia
23	13907	53631	20	2	\N	9	\N	Coenonympha tullia
87	13908	53631	20	2	\N	9	\N	Coenonympha tullia
7	13909	53631	20	2	\N	9	\N	Coenonympha tullia
38	13910	53631	20	2	\N	9	\N	Coenonympha tullia
69	13911	53631	20	2	\N	9	\N	Coenonympha tullia
15	13912	53631	20	2	\N	9	\N	Coenonympha tullia
63	13913	53631	20	2	\N	9	\N	Coenonympha tullia
30	13914	53631	20	2	\N	9	\N	Coenonympha tullia
34	13915	53631	20	2	\N	9	\N	Coenonympha tullia
48	13916	53631	20	2	\N	9	\N	Coenonympha tullia
13	13917	53631	20	2	\N	9	\N	Coenonympha tullia
83	13918	53631	20	2	\N	9	\N	Coenonympha tullia
84	13919	53631	20	2	\N	9	\N	Coenonympha tullia
2A	13920	53631	20	2	\N	9	\N	Coenonympha tullia
78	13921	53651	20	2	\N	9	\N	Coenonympha hero
92	13922	53651	20	2	\N	9	\N	Coenonympha hero
94	13923	53651	20	2	\N	9	\N	Coenonympha hero
95	13924	53651	20	2	\N	9	\N	Coenonympha hero
8	13925	53651	20	2	\N	9	\N	Coenonympha hero
10	13926	53651	20	2	\N	9	\N	Coenonympha hero
51	13927	53651	20	2	\N	9	\N	Coenonympha hero
2	13928	53651	20	2	\N	9	\N	Coenonympha hero
60	13929	53651	20	2	\N	9	\N	Coenonympha hero
27	13930	53651	20	2	\N	9	\N	Coenonympha hero
18	13931	53651	20	2	\N	9	\N	Coenonympha hero
36	13932	53651	20	2	\N	9	\N	Coenonympha hero
41	13933	53651	20	2	\N	9	\N	Coenonympha hero
45	13934	53651	20	2	\N	9	\N	Coenonympha hero
61	13935	53651	20	2	\N	9	\N	Coenonympha hero
21	13936	53651	20	2	\N	9	\N	Coenonympha hero
58	13937	53651	20	2	\N	9	\N	Coenonympha hero
89	13938	53651	20	2	\N	9	\N	Coenonympha hero
59	13939	53651	20	2	\N	9	\N	Coenonympha hero
54	13940	53651	20	2	\N	9	\N	Coenonympha hero
55	13941	53651	20	2	\N	9	\N	Coenonympha hero
57	13942	53651	20	2	\N	9	\N	Coenonympha hero
88	13943	53651	20	2	\N	9	\N	Coenonympha hero
25	13944	53651	20	2	\N	9	\N	Coenonympha hero
39	13945	53651	20	2	\N	9	\N	Coenonympha hero
70	13946	53651	20	2	\N	9	\N	Coenonympha hero
53	13947	53651	20	2	\N	9	\N	Coenonympha hero
56	13948	53651	20	2	\N	9	\N	Coenonympha hero
79	13949	53651	20	2	\N	9	\N	Coenonympha hero
86	13950	53651	20	2	\N	9	\N	Coenonympha hero
24	13951	53651	20	2	\N	9	\N	Coenonympha hero
40	13952	53651	20	2	\N	9	\N	Coenonympha hero
47	13953	53651	20	2	\N	9	\N	Coenonympha hero
64	13954	53651	20	2	\N	9	\N	Coenonympha hero
9	13955	53651	20	2	\N	9	\N	Coenonympha hero
12	13956	53651	20	2	\N	9	\N	Coenonympha hero
32	13957	53651	20	2	\N	9	\N	Coenonympha hero
65	13958	53651	20	2	\N	9	\N	Coenonympha hero
81	13959	53651	20	2	\N	9	\N	Coenonympha hero
82	13960	53651	20	2	\N	9	\N	Coenonympha hero
1	13961	53651	20	2	\N	9	\N	Coenonympha hero
26	13962	53651	20	2	\N	9	\N	Coenonympha hero
42	13963	53651	20	2	\N	9	\N	Coenonympha hero
73	13964	53651	20	2	\N	9	\N	Coenonympha hero
74	13965	53651	20	2	\N	9	\N	Coenonympha hero
3	13966	53651	20	2	\N	9	\N	Coenonympha hero
43	13967	53651	20	2	\N	9	\N	Coenonympha hero
11	13968	53651	20	2	\N	9	\N	Coenonympha hero
66	13969	53651	20	2	\N	9	\N	Coenonympha hero
4	13970	53651	20	2	\N	9	\N	Coenonympha hero
5	13971	53651	20	2	\N	9	\N	Coenonympha hero
6	13972	53651	20	2	\N	9	\N	Coenonympha hero
2B	13973	53651	20	2	\N	9	\N	Coenonympha hero
75	13974	53651	20	2	\N	9	\N	Coenonympha hero
77	13975	53651	20	2	\N	9	\N	Coenonympha hero
91	13976	53651	20	2	\N	9	\N	Coenonympha hero
93	13977	53651	20	2	\N	9	\N	Coenonympha hero
52	13978	53651	20	2	\N	9	\N	Coenonympha hero
80	13979	53651	20	2	\N	9	\N	Coenonympha hero
76	13980	53651	20	2	\N	9	\N	Coenonympha hero
28	13981	53651	20	2	\N	9	\N	Coenonympha hero
37	13982	53651	20	2	\N	9	\N	Coenonympha hero
14	13983	53651	20	2	\N	9	\N	Coenonympha hero
50	13984	53651	20	2	\N	9	\N	Coenonympha hero
71	13985	53651	20	2	\N	9	\N	Coenonympha hero
62	13986	53651	20	2	\N	9	\N	Coenonympha hero
67	13987	53651	20	2	\N	9	\N	Coenonympha hero
68	13988	53651	20	2	\N	9	\N	Coenonympha hero
90	13989	53651	20	2	\N	9	\N	Coenonympha hero
44	13990	53651	20	2	\N	9	\N	Coenonympha hero
49	13991	53651	20	2	\N	9	\N	Coenonympha hero
72	13992	53651	20	2	\N	9	\N	Coenonympha hero
85	13993	53651	20	2	\N	9	\N	Coenonympha hero
22	13994	53651	20	2	\N	9	\N	Coenonympha hero
29	13995	53651	20	2	\N	9	\N	Coenonympha hero
35	13996	53651	20	2	\N	9	\N	Coenonympha hero
16	13997	53651	20	2	\N	9	\N	Coenonympha hero
17	13998	53651	20	2	\N	9	\N	Coenonympha hero
33	13999	53651	20	2	\N	9	\N	Coenonympha hero
31	14000	53651	20	2	\N	9	\N	Coenonympha hero
46	14001	53651	20	2	\N	9	\N	Coenonympha hero
19	14002	53651	20	2	\N	9	\N	Coenonympha hero
23	14003	53651	20	2	\N	9	\N	Coenonympha hero
87	14004	53651	20	2	\N	9	\N	Coenonympha hero
7	14005	53651	20	2	\N	9	\N	Coenonympha hero
38	14006	53651	20	2	\N	9	\N	Coenonympha hero
69	14007	53651	20	2	\N	9	\N	Coenonympha hero
15	14008	53651	20	2	\N	9	\N	Coenonympha hero
63	14009	53651	20	2	\N	9	\N	Coenonympha hero
30	14010	53651	20	2	\N	9	\N	Coenonympha hero
34	14011	53651	20	2	\N	9	\N	Coenonympha hero
48	14012	53651	20	2	\N	9	\N	Coenonympha hero
13	14013	53651	20	2	\N	9	\N	Coenonympha hero
83	14014	53651	20	2	\N	9	\N	Coenonympha hero
84	14015	53651	20	2	\N	9	\N	Coenonympha hero
2A	14016	53651	20	2	\N	9	\N	Coenonympha hero
78	14017	53856	20	1	\N	9	\N	Euphydryas maturna
92	14018	53856	20	1	\N	9	\N	Euphydryas maturna
94	14019	53856	20	1	\N	9	\N	Euphydryas maturna
95	14020	53856	20	1	\N	9	\N	Euphydryas maturna
8	14021	53856	20	1	\N	9	\N	Euphydryas maturna
10	14022	53856	20	1	\N	9	\N	Euphydryas maturna
51	14023	53856	20	1	\N	9	\N	Euphydryas maturna
2	14024	53856	20	1	\N	9	\N	Euphydryas maturna
60	14025	53856	20	1	\N	9	\N	Euphydryas maturna
27	14026	53856	20	1	\N	9	\N	Euphydryas maturna
18	14027	53856	20	1	\N	9	\N	Euphydryas maturna
36	14028	53856	20	1	\N	9	\N	Euphydryas maturna
41	14029	53856	20	1	\N	9	\N	Euphydryas maturna
45	14030	53856	20	1	\N	9	\N	Euphydryas maturna
61	14031	53856	20	1	\N	9	\N	Euphydryas maturna
21	14032	53856	20	1	\N	9	\N	Euphydryas maturna
58	14033	53856	20	1	\N	9	\N	Euphydryas maturna
89	14034	53856	20	1	\N	9	\N	Euphydryas maturna
59	14035	53856	20	1	\N	9	\N	Euphydryas maturna
54	14036	53856	20	1	\N	9	\N	Euphydryas maturna
55	14037	53856	20	1	\N	9	\N	Euphydryas maturna
57	14038	53856	20	1	\N	9	\N	Euphydryas maturna
88	14039	53856	20	1	\N	9	\N	Euphydryas maturna
25	14040	53856	20	1	\N	9	\N	Euphydryas maturna
39	14041	53856	20	1	\N	9	\N	Euphydryas maturna
70	14042	53856	20	1	\N	9	\N	Euphydryas maturna
53	14043	53856	20	1	\N	9	\N	Euphydryas maturna
56	14044	53856	20	1	\N	9	\N	Euphydryas maturna
79	14045	53856	20	1	\N	9	\N	Euphydryas maturna
86	14046	53856	20	1	\N	9	\N	Euphydryas maturna
24	14047	53856	20	1	\N	9	\N	Euphydryas maturna
40	14048	53856	20	1	\N	9	\N	Euphydryas maturna
47	14049	53856	20	1	\N	9	\N	Euphydryas maturna
64	14050	53856	20	1	\N	9	\N	Euphydryas maturna
9	14051	53856	20	1	\N	9	\N	Euphydryas maturna
12	14052	53856	20	1	\N	9	\N	Euphydryas maturna
32	14053	53856	20	1	\N	9	\N	Euphydryas maturna
65	14054	53856	20	1	\N	9	\N	Euphydryas maturna
81	14055	53856	20	1	\N	9	\N	Euphydryas maturna
82	14056	53856	20	1	\N	9	\N	Euphydryas maturna
1	14057	53856	20	1	\N	9	\N	Euphydryas maturna
26	14058	53856	20	1	\N	9	\N	Euphydryas maturna
42	14059	53856	20	1	\N	9	\N	Euphydryas maturna
73	14060	53856	20	1	\N	9	\N	Euphydryas maturna
74	14061	53856	20	1	\N	9	\N	Euphydryas maturna
3	14062	53856	20	1	\N	9	\N	Euphydryas maturna
43	14063	53856	20	1	\N	9	\N	Euphydryas maturna
11	14064	53856	20	1	\N	9	\N	Euphydryas maturna
66	14065	53856	20	1	\N	9	\N	Euphydryas maturna
4	14066	53856	20	1	\N	9	\N	Euphydryas maturna
5	14067	53856	20	1	\N	9	\N	Euphydryas maturna
6	14068	53856	20	1	\N	9	\N	Euphydryas maturna
2B	14069	53856	20	1	\N	9	\N	Euphydryas maturna
75	14070	53856	20	1	\N	9	\N	Euphydryas maturna
77	14071	53856	20	1	\N	9	\N	Euphydryas maturna
91	14072	53856	20	1	\N	9	\N	Euphydryas maturna
93	14073	53856	20	1	\N	9	\N	Euphydryas maturna
52	14074	53856	20	1	\N	9	\N	Euphydryas maturna
80	14075	53856	20	1	\N	9	\N	Euphydryas maturna
76	14076	53856	20	1	\N	9	\N	Euphydryas maturna
28	14077	53856	20	1	\N	9	\N	Euphydryas maturna
37	14078	53856	20	1	\N	9	\N	Euphydryas maturna
14	14079	53856	20	1	\N	9	\N	Euphydryas maturna
50	14080	53856	20	1	\N	9	\N	Euphydryas maturna
71	14081	53856	20	1	\N	9	\N	Euphydryas maturna
62	14082	53856	20	1	\N	9	\N	Euphydryas maturna
67	14083	53856	20	1	\N	9	\N	Euphydryas maturna
68	14084	53856	20	1	\N	9	\N	Euphydryas maturna
90	14085	53856	20	1	\N	9	\N	Euphydryas maturna
44	14086	53856	20	1	\N	9	\N	Euphydryas maturna
49	14087	53856	20	1	\N	9	\N	Euphydryas maturna
72	14088	53856	20	1	\N	9	\N	Euphydryas maturna
85	14089	53856	20	1	\N	9	\N	Euphydryas maturna
22	14090	53856	20	1	\N	9	\N	Euphydryas maturna
29	14091	53856	20	1	\N	9	\N	Euphydryas maturna
35	14092	53856	20	1	\N	9	\N	Euphydryas maturna
16	14093	53856	20	1	\N	9	\N	Euphydryas maturna
17	14094	53856	20	1	\N	9	\N	Euphydryas maturna
33	14095	53856	20	1	\N	9	\N	Euphydryas maturna
31	14096	53856	20	1	\N	9	\N	Euphydryas maturna
46	14097	53856	20	1	\N	9	\N	Euphydryas maturna
19	14098	53856	20	1	\N	9	\N	Euphydryas maturna
23	14099	53856	20	1	\N	9	\N	Euphydryas maturna
87	14100	53856	20	1	\N	9	\N	Euphydryas maturna
7	14101	53856	20	1	\N	9	\N	Euphydryas maturna
38	14102	53856	20	1	\N	9	\N	Euphydryas maturna
69	14103	53856	20	1	\N	9	\N	Euphydryas maturna
15	14104	53856	20	1	\N	9	\N	Euphydryas maturna
63	14105	53856	20	1	\N	9	\N	Euphydryas maturna
30	14106	53856	20	1	\N	9	\N	Euphydryas maturna
34	14107	53856	20	1	\N	9	\N	Euphydryas maturna
48	14108	53856	20	1	\N	9	\N	Euphydryas maturna
13	14109	53856	20	1	\N	9	\N	Euphydryas maturna
83	14110	53856	20	1	\N	9	\N	Euphydryas maturna
84	14111	53856	20	1	\N	9	\N	Euphydryas maturna
2A	14112	53856	20	1	\N	9	\N	Euphydryas maturna
78	14113	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
92	14114	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
94	14115	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
95	14116	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
8	14117	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
10	14118	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
51	14119	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
2	14120	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
60	14121	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
27	14122	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
18	14123	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
36	14124	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
41	14125	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
45	14126	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
61	14127	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
21	14128	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
58	14129	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
89	14130	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
59	14131	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
54	14132	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
55	14133	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
57	14134	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
88	14135	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
25	14136	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
39	14137	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
70	14138	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
53	14139	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
56	14140	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
79	14141	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
86	14142	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
24	14143	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
40	14144	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
47	14145	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
64	14146	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
9	14147	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
12	14148	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
32	14149	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
65	14150	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
81	14151	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
82	14152	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
1	14153	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
26	14154	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
42	14155	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
73	14156	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
74	14157	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
3	14158	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
43	14159	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
11	14160	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
66	14161	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
4	14162	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
5	14163	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
6	14164	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
2B	14165	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
75	14166	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
77	14167	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
91	14168	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
93	14169	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
52	14170	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
80	14171	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
76	14172	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
28	14173	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
37	14174	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
14	14175	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
50	14176	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
71	14177	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
62	14178	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
67	14179	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
68	14180	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
90	14181	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
44	14182	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
49	14183	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
72	14184	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
85	14185	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
22	14186	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
29	14187	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
35	14188	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
16	14189	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
17	14190	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
33	14191	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
31	14192	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
46	14193	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
19	14194	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
23	14195	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
87	14196	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
7	14197	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
38	14198	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
69	14199	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
15	14200	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
63	14201	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
30	14202	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
34	14203	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
48	14204	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
13	14205	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
83	14206	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
84	14207	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
2A	14208	60577	1	2	uniquement l'emplacement des terriers	9	3	Canis lupus
78	14209	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
92	14210	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
94	14211	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
95	14212	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
8	14213	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
10	14214	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
51	14215	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
2	14216	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
60	14217	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
27	14218	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
18	14219	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
36	14220	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
41	14221	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
45	14222	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
61	14223	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
21	14224	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
58	14225	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
89	14226	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
59	14227	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
54	14228	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
55	14229	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
57	14230	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
88	14231	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
25	14232	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
39	14233	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
70	14234	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
53	14235	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
56	14236	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
79	14237	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
86	14238	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
24	14239	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
40	14240	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
47	14241	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
64	14242	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
9	14243	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
12	14244	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
32	14245	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
65	14246	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
81	14247	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
82	14248	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
1	14249	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
26	14250	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
42	14251	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
73	14252	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
74	14253	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
3	14254	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
43	14255	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
11	14256	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
66	14257	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
4	14258	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
5	14259	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
6	14260	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
2B	14261	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
75	14262	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
77	14263	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
91	14264	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
93	14265	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
52	14266	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
80	14267	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
76	14268	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
28	14269	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
37	14270	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
14	14271	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
50	14272	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
71	14273	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
62	14274	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
67	14275	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
68	14276	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
90	14277	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
44	14278	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
49	14279	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
72	14280	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
85	14281	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
22	14282	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
29	14283	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
35	14284	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
16	14285	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
17	14286	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
33	14287	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
31	14288	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
46	14289	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
19	14290	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
23	14291	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
87	14292	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
7	14293	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
38	14294	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
69	14295	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
15	14296	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
63	14297	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
30	14298	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
34	14299	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
48	14300	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
13	14301	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
83	14302	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
84	14303	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
2A	14304	60612	1	2	uniquement l'emplacement gîte de mise bas	9	3	Lynx lynx
78	14305	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
92	14306	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
94	14307	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
95	14308	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
8	14309	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
10	14310	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
51	14311	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
2	14312	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
60	14313	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
27	14314	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
18	14315	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
36	14316	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
41	14317	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
45	14318	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
61	14319	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
21	14320	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
58	14321	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
89	14322	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
59	14323	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
54	14324	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
55	14325	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
57	14326	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
88	14327	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
25	14328	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
39	14329	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
70	14330	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
53	14331	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
56	14332	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
79	14333	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
86	14334	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
24	14335	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
40	14336	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
47	14337	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
64	14338	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
9	14339	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
12	14340	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
32	14341	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
65	14342	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
81	14343	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
82	14344	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
1	14345	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
26	14346	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
42	14347	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
73	14348	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
74	14349	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
3	14350	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
43	14351	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
11	14352	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
66	14353	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
4	14354	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
5	14355	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
6	14356	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
2B	14357	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
75	14358	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
77	14359	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
91	14360	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
93	14361	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
52	14362	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
80	14363	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
76	14364	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
28	14365	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
37	14366	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
14	14367	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
50	14368	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
71	14369	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
62	14370	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
67	14371	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
68	14372	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
90	14373	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
44	14374	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
49	14375	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
72	14376	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
85	14377	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
22	14378	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
29	14379	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
35	14380	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
16	14381	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
17	14382	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
33	14383	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
31	14384	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
46	14385	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
19	14386	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
23	14387	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
87	14388	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
7	14389	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
38	14390	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
69	14391	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
15	14392	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
63	14393	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
30	14394	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
34	14395	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
48	14396	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
13	14397	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
83	14398	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
84	14399	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
2A	14400	60826	1	2	uniquement l'emplacement des tanières	9	3	Ursus arctos
78	14401	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
92	14402	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
94	14403	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
95	14404	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
8	14405	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
10	14406	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
51	14407	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
2	14408	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
60	14409	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
27	14410	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
18	14411	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
36	14412	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
41	14413	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
45	14414	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
61	14415	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
21	14416	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
58	14417	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
89	14418	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
59	14419	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
54	14420	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
55	14421	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
57	14422	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
88	14423	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
25	14424	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
39	14425	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
70	14426	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
53	14427	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
56	14428	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
79	14429	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
86	14430	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
24	14431	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
40	14432	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
47	14433	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
64	14434	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
9	14435	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
12	14436	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
32	14437	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
15	18136	699127	\N	1	\N	9	\N	Salamandra lanzai
65	14438	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
81	14439	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
82	14440	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
1	14441	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
26	14442	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
42	14443	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
73	14444	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
74	14445	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
3	14446	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
43	14447	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
11	14448	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
66	14449	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
4	14450	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
5	14451	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
6	14452	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
2B	14453	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
75	14454	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
77	14455	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
91	14456	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
93	14457	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
52	14458	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
80	14459	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
76	14460	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
28	14461	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
37	14462	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
14	14463	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
50	14464	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
71	14465	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
62	14466	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
67	14467	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
68	14468	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
90	14469	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
44	14470	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
49	14471	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
72	14472	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
85	14473	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
22	14474	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
29	14475	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
35	14476	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
16	14477	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
17	14478	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
33	14479	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
31	14480	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
46	14481	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
19	14482	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
23	14483	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
87	14484	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
7	14485	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
38	14486	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
69	14487	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
15	14488	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
63	14489	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
30	14490	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
34	14491	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
48	14492	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
13	14493	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
83	14494	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
84	14495	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
2A	14496	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus ferrumequinum
78	14497	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
92	14498	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
94	14499	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
95	14500	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
8	14501	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
10	14502	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
51	14503	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
2	14504	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
60	14505	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
27	14506	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
18	14507	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
36	14508	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
41	14509	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
45	14510	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
61	14511	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
21	14512	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
58	14513	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
89	14514	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
59	14515	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
54	14516	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
55	14517	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
57	14518	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
88	14519	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
25	14520	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
39	14521	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
70	14522	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
53	14523	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
56	14524	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
79	14525	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
86	14526	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
24	14527	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
40	14528	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
47	14529	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
64	14530	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
9	14531	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
12	14532	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
32	14533	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
65	14534	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
81	14535	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
82	14536	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
1	14537	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
26	14538	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
42	14539	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
73	14540	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
74	14541	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
3	14542	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
43	14543	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
11	14544	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
66	14545	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
4	14546	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
5	14547	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
6	14548	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
2B	14549	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
75	14550	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
77	14551	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
91	14552	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
93	14553	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
52	14554	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
80	14555	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
76	14556	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
28	14557	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
37	14558	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
14	14559	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
50	14560	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
71	14561	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
62	14562	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
67	14563	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
68	14564	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
90	14565	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
44	14566	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
49	14567	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
72	14568	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
85	14569	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
22	14570	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
29	14571	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
35	14572	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
16	14573	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
17	14574	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
33	14575	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
31	14576	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
46	14577	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
19	14578	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
23	14579	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
87	14580	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
7	14581	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
38	14582	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
69	14583	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
15	14584	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
63	14585	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
30	14586	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
34	14587	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
48	14588	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
13	14589	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
83	14590	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
84	14591	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
2A	14592	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus ferrumequinum
78	14593	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
92	14594	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
94	14595	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
95	14596	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
8	14597	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
10	14598	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
51	14599	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
2	14600	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
60	14601	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
27	14602	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
18	14603	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
36	14604	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
41	14605	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
45	14606	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
61	14607	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
21	14608	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
58	14609	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
89	14610	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
59	14611	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
54	14612	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
55	14613	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
57	14614	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
88	14615	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
25	14616	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
39	14617	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
70	14618	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
53	14619	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
56	14620	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
79	14621	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
86	14622	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
24	14623	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
40	14624	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
47	14625	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
64	14626	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
9	14627	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
12	14628	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
32	14629	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
65	14630	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
81	14631	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
82	14632	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
1	14633	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
26	14634	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
42	14635	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
73	14636	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
74	14637	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
3	14638	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
43	14639	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
11	14640	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
66	14641	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
4	14642	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
5	14643	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
6	14644	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
2B	14645	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
75	14646	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
77	14647	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
91	14648	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
93	14649	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
52	14650	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
80	14651	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
76	14652	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
28	14653	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
37	14654	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
14	14655	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
50	14656	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
71	14657	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
62	14658	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
67	14659	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
68	14660	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
90	14661	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
44	14662	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
49	14663	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
72	14664	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
85	14665	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
22	14666	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
29	14667	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
35	14668	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
16	14669	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
17	14670	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
33	14671	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
31	14672	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
46	14673	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
19	14674	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
23	14675	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
87	14676	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
7	14677	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
38	14678	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
69	14679	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
15	14680	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
63	14681	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
30	14682	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
34	14683	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
48	14684	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
13	14685	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
83	14686	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
84	14687	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
2A	14688	60295	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus ferrumequinum
78	14689	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
92	14690	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
94	14691	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
95	14692	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
8	14693	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
10	14694	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
51	14695	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
2	14696	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
60	14697	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
27	14698	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
18	14699	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
36	14700	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
41	14701	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
45	14702	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
61	14703	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
21	14704	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
58	14705	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
89	14706	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
59	14707	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
54	14708	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
55	14709	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
57	14710	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
88	14711	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
25	14712	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
39	14713	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
70	14714	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
53	14715	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
56	14716	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
79	14717	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
86	14718	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
24	14719	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
40	14720	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
47	14721	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
64	14722	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
9	14723	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
12	14724	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
32	14725	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
65	14726	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
81	14727	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
82	14728	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
1	14729	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
26	14730	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
42	14731	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
73	14732	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
74	14733	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
3	14734	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
43	14735	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
11	14736	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
66	14737	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
4	14738	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
5	14739	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
6	14740	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
2B	14741	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
75	14742	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
77	14743	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
91	14744	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
93	14745	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
52	14746	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
80	14747	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
76	14748	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
28	14749	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
37	14750	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
14	14751	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
50	14752	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
71	14753	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
62	14754	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
67	14755	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
68	14756	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
90	14757	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
44	14758	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
49	14759	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
72	14760	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
85	14761	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
22	14762	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
29	14763	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
35	14764	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
16	14765	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
17	14766	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
33	14767	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
31	14768	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
46	14769	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
19	14770	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
23	14771	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
87	14772	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
7	14773	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
38	14774	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
69	14775	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
15	14776	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
63	14777	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
30	14778	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
34	14779	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
48	14780	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
13	14781	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
83	14782	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
84	14783	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
2A	14784	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus hipposideros
78	14785	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
92	14786	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
94	14787	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
95	14788	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
8	14789	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
10	14790	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
51	14791	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
2	14792	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
60	14793	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
27	14794	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
18	14795	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
36	14796	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
41	14797	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
45	14798	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
61	14799	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
21	14800	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
58	14801	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
89	14802	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
59	14803	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
54	14804	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
55	14805	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
57	14806	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
88	14807	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
25	14808	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
39	14809	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
70	14810	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
53	14811	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
56	14812	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
79	14813	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
86	14814	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
24	14815	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
40	14816	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
47	14817	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
64	14818	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
9	14819	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
12	14820	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
32	14821	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
65	14822	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
81	14823	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
82	14824	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
1	14825	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
26	14826	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
42	14827	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
73	14828	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
74	14829	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
3	14830	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
43	14831	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
11	14832	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
66	14833	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
4	14834	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
5	14835	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
6	14836	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
2B	14837	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
75	14838	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
77	14839	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
91	14840	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
93	14841	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
52	14842	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
80	14843	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
76	14844	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
28	14845	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
37	14846	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
14	14847	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
50	14848	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
71	14849	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
62	14850	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
67	14851	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
68	14852	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
90	14853	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
44	14854	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
49	14855	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
72	14856	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
85	14857	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
22	14858	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
29	14859	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
35	14860	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
16	14861	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
17	14862	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
33	14863	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
31	14864	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
46	14865	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
19	14866	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
23	14867	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
87	14868	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
7	14869	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
38	14870	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
69	14871	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
15	14872	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
63	14873	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
30	14874	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
34	14875	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
48	14876	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
13	14877	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
83	14878	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
84	14879	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
2A	14880	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus hipposideros
8	14881	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
45	14882	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
61	14883	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
58	14884	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
55	14885	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
86	14886	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
47	14887	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
9	14888	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
26	14889	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
73	14890	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
4	14891	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
2B	14892	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
75	14893	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
93	14894	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
28	14895	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
50	14896	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
71	14897	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
72	14898	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
17	14899	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
87	14900	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
7	14901	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
48	14902	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
13	14903	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
78	14904	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
94	14905	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
95	14906	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
18	14907	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
21	14908	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
89	14909	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
59	14910	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
88	14911	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
12	14912	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
81	14913	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
82	14914	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
1	14915	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
11	14916	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
66	14917	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
77	14918	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
76	14919	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
67	14920	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
44	14921	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
49	14922	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
22	14923	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
29	14924	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
16	14925	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
33	14926	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
31	14927	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
19	14928	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
69	14929	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
63	14930	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
83	14931	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
92	14932	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
10	14933	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
51	14934	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
2	14935	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
36	14936	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
54	14937	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
25	14938	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
39	14939	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
56	14940	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
32	14941	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
42	14942	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
74	14943	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
3	14944	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
43	14945	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
5	14946	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
91	14947	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
52	14948	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
80	14949	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
37	14950	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
14	14951	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
90	14952	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
85	14953	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
46	14954	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
38	14955	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
15	14956	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
84	14957	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
60	14958	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
27	14959	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
41	14960	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
57	14961	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
70	14962	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
53	14963	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
79	14964	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
24	14965	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
40	14966	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
64	14967	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
65	14968	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
6	14969	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
62	14970	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
68	14971	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
35	14972	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
23	14973	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
30	14974	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
34	14975	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
2A	14976	60313	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus hipposideros
8	14977	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
45	14978	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
61	14979	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
58	14980	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
55	14981	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
86	14982	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
47	14983	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
9	14984	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
26	14985	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
73	14986	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
4	14987	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
2B	14988	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
75	14989	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
93	14990	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
28	14991	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
50	14992	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
71	14993	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
72	14994	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
17	14995	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
87	14996	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
7	14997	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
48	14998	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
13	14999	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
78	15000	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
94	15001	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
95	15002	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
18	15003	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
21	15004	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
89	15005	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
59	15006	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
88	15007	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
12	15008	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
81	15009	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
82	15010	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
1	15011	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
11	15012	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
66	15013	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
77	15014	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
76	15015	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
67	15016	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
44	15017	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
49	15018	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
22	15019	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
29	15020	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
16	15021	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
33	15022	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
31	15023	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
19	15024	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
69	15025	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
63	15026	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
83	15027	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
92	15028	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
10	15029	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
51	15030	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
2	15031	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
36	15032	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
54	15033	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
25	15034	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
39	15035	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
56	15036	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
32	15037	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
42	15038	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
74	15039	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
3	15040	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
43	15041	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
5	15042	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
91	15043	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
52	15044	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
80	15045	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
37	15046	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
14	15047	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
90	15048	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
85	15049	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
46	15050	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
38	15051	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
15	15052	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
84	15053	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
60	15054	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
27	15055	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
41	15056	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
57	15057	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
70	15058	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
53	15059	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
79	15060	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
24	15061	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
40	15062	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
64	15063	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
65	15064	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
6	15065	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
62	15066	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
68	15067	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
35	15068	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
23	15069	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
30	15070	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
34	15071	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
2A	15072	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus euryale
8	15073	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
45	15074	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
61	15075	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
58	15076	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
55	15077	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
86	15078	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
47	15079	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
9	15080	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
26	15081	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
73	15082	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
4	15083	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
2B	15084	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
75	15085	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
93	15086	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
28	15087	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
50	15088	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
71	15089	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
72	15090	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
17	15091	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
87	15092	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
7	15093	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
48	15094	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
13	15095	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
78	15096	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
94	15097	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
95	15098	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
18	15099	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
21	15100	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
89	15101	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
59	15102	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
88	15103	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
12	15104	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
81	15105	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
82	15106	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
1	15107	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
11	15108	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
66	15109	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
77	15110	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
76	15111	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
67	15112	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
44	15113	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
49	15114	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
22	15115	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
29	15116	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
16	15117	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
33	15118	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
31	15119	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
19	15120	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
69	15121	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
63	15122	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
83	15123	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
92	15124	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
10	15125	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
51	15126	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
2	15127	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
36	15128	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
54	15129	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
25	15130	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
39	15131	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
56	15132	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
32	15133	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
42	15134	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
74	15135	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
3	15136	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
43	15137	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
5	15138	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
91	15139	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
52	15140	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
80	15141	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
37	15142	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
14	15143	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
90	15144	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
85	15145	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
46	15146	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
38	15147	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
15	15148	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
84	15149	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
60	15150	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
27	15151	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
41	15152	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
57	15153	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
70	15154	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
53	15155	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
79	15156	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
24	15157	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
40	15158	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
64	15159	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
65	15160	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
6	15161	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
62	15162	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
68	15163	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
35	15164	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
23	15165	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
30	15166	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
34	15167	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
2A	15168	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus euryale
78	15169	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
92	15170	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
94	15171	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
95	15172	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
8	15173	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
10	15174	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
51	15175	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
2	15176	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
60	15177	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
27	15178	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
18	15179	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
36	15180	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
41	15181	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
45	15182	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
61	15183	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
21	15184	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
58	15185	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
89	15186	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
59	15187	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
54	15188	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
55	15189	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
57	15190	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
88	15191	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
25	15192	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
39	15193	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
70	15194	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
53	15195	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
56	15196	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
79	15197	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
86	15198	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
24	15199	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
40	15200	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
47	15201	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
64	15202	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
9	15203	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
12	15204	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
32	15205	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
65	15206	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
81	15207	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
82	15208	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
1	15209	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
26	15210	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
42	15211	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
73	15212	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
74	15213	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
3	15214	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
43	15215	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
11	15216	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
66	15217	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
4	15218	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
5	15219	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
6	15220	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
2B	15221	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
75	15222	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
77	15223	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
91	15224	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
93	15225	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
52	15226	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
80	15227	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
76	15228	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
28	15229	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
37	15230	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
14	15231	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
50	15232	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
71	15233	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
62	15234	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
67	15235	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
68	15236	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
90	15237	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
44	15238	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
49	15239	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
72	15240	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
85	15241	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
22	15242	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
29	15243	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
35	15244	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
16	15245	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
17	15246	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
33	15247	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
31	15248	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
46	15249	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
19	15250	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
23	15251	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
87	15252	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
7	15253	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
38	15254	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
69	15255	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
15	15256	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
63	15257	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
30	15258	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
34	15259	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
48	15260	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
13	15261	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
83	15262	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
84	15263	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
2A	15264	60330	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus euryale
78	15265	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
92	15266	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
94	15267	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
95	15268	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
8	15269	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
10	15270	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
51	15271	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
2	15272	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
60	15273	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
27	15274	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
18	15275	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
36	15276	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
41	15277	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
45	15278	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
61	15279	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
21	15280	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
58	15281	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
89	15282	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
59	15283	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
54	15284	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
55	15285	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
57	15286	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
88	15287	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
25	15288	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
39	15289	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
70	15290	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
53	15291	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
56	15292	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
79	15293	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
86	15294	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
24	15295	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
40	15296	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
47	15297	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
64	15298	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
9	15299	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
12	15300	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
32	15301	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
65	15302	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
81	15303	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
82	15304	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
1	15305	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
26	15306	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
42	15307	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
73	15308	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
74	15309	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
3	15310	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
43	15311	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
11	15312	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
66	15313	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
4	15314	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
5	15315	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
6	15316	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
2B	15317	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
75	15318	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
77	15319	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
91	15320	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
93	15321	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
52	15322	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
80	15323	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
76	15324	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
28	15325	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
37	15326	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
14	15327	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
50	15328	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
71	15329	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
62	15330	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
67	15331	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
68	15332	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
90	15333	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
44	15334	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
49	15335	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
72	15336	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
85	15337	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
22	15338	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
29	15339	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
35	15340	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
16	15341	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
17	15342	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
33	15343	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
31	15344	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
46	15345	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
19	15346	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
23	15347	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
87	15348	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
7	15349	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
38	15350	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
69	15351	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
15	15352	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
63	15353	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
30	15354	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
34	15355	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
48	15356	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
13	15357	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
83	15358	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
84	15359	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
2A	15360	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Rhinolophus mehelyi
78	15361	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
92	15362	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
94	15363	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
95	15364	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
8	15365	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
10	15366	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
51	15367	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
2	15368	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
60	15369	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
27	15370	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
18	15371	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
36	15372	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
41	15373	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
45	15374	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
61	15375	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
21	15376	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
58	15377	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
89	15378	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
59	15379	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
54	15380	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
55	15381	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
57	15382	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
88	15383	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
25	15384	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
39	15385	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
70	15386	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
53	15387	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
56	15388	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
79	15389	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
86	15390	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
24	15391	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
40	15392	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
47	15393	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
64	15394	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
9	15395	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
12	15396	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
32	15397	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
65	15398	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
81	15399	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
82	15400	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
1	15401	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
26	15402	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
42	15403	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
73	15404	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
74	15405	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
3	15406	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
43	15407	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
11	15408	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
66	15409	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
4	15410	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
5	15411	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
6	15412	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
2B	15413	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
75	15414	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
77	15415	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
91	15416	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
93	15417	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
52	15418	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
80	15419	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
76	15420	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
28	15421	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
37	15422	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
14	15423	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
50	15424	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
71	15425	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
62	15426	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
67	15427	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
68	15428	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
90	15429	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
44	15430	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
49	15431	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
72	15432	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
85	15433	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
22	15434	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
29	15435	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
35	15436	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
16	15437	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
17	15438	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
33	15439	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
31	15440	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
46	15441	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
19	15442	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
23	15443	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
87	15444	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
7	15445	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
38	15446	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
69	15447	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
15	15448	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
63	15449	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
30	15450	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
34	15451	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
48	15452	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
13	15453	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
83	15454	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
84	15455	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
2A	15456	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Rhinolophus mehelyi
78	15457	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
92	15458	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
94	15459	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
95	15460	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
8	15461	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
10	15462	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
51	15463	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
2	15464	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
60	15465	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
27	15466	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
18	15467	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
36	15468	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
41	15469	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
45	15470	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
61	15471	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
21	15472	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
58	15473	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
89	15474	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
59	15475	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
54	15476	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
55	15477	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
57	15478	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
88	15479	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
25	15480	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
39	15481	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
70	15482	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
53	15483	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
56	15484	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
79	15485	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
86	15486	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
24	15487	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
40	15488	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
47	15489	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
64	15490	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
9	15491	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
12	15492	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
32	15493	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
65	15494	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
81	15495	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
82	15496	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
1	15497	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
26	15498	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
42	15499	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
73	15500	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
74	15501	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
3	15502	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
43	15503	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
11	15504	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
66	15505	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
4	15506	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
5	15507	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
6	15508	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
2B	15509	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
75	15510	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
77	15511	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
91	15512	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
93	15513	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
52	15514	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
80	15515	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
76	15516	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
28	15517	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
37	15518	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
14	15519	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
50	15520	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
71	15521	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
62	15522	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
67	15523	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
68	15524	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
90	15525	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
44	15526	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
49	15527	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
72	15528	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
85	15529	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
22	15530	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
29	15531	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
35	15532	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
16	15533	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
17	15534	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
33	15535	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
31	15536	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
46	15537	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
19	15538	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
23	15539	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
87	15540	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
7	15541	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
38	15542	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
69	15543	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
15	15544	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
63	15545	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
30	15546	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
34	15547	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
48	15548	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
13	15549	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
83	15550	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
84	15551	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
2A	15552	60337	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Rhinolophus mehelyi
78	15553	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
92	15554	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
94	15555	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
95	15556	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
8	15557	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
10	15558	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
51	15559	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
2	15560	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
60	15561	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
27	15562	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
18	15563	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
36	15564	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
41	15565	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
45	15566	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
61	15567	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
21	15568	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
58	15569	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
89	15570	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
59	15571	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
54	15572	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
55	15573	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
57	15574	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
88	15575	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
25	15576	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
39	15577	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
70	15578	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
53	15579	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
56	15580	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
79	15581	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
86	15582	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
24	15583	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
40	15584	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
47	15585	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
64	15586	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
63	18137	699127	\N	1	\N	9	\N	Salamandra lanzai
9	15587	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
12	15588	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
32	15589	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
65	15590	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
81	15591	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
82	15592	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
1	15593	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
26	15594	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
42	15595	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
73	15596	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
74	15597	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
3	15598	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
43	15599	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
11	15600	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
66	15601	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
4	15602	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
5	15603	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
6	15604	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
2B	15605	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
75	15606	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
77	15607	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
91	15608	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
93	15609	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
52	15610	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
80	15611	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
76	15612	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
28	15613	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
37	15614	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
14	15615	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
50	15616	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
71	15617	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
62	15618	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
67	15619	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
68	15620	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
90	15621	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
44	15622	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
49	15623	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
72	15624	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
85	15625	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
22	15626	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
29	15627	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
35	15628	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
16	15629	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
17	15630	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
33	15631	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
31	15632	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
46	15633	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
19	15634	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
23	15635	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
87	15636	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
7	15637	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
38	15638	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
69	15639	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
15	15640	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
63	15641	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
30	15642	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
34	15643	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
48	15644	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
13	15645	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
83	15646	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
84	15647	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
2A	15648	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Barbastella barbastellus
78	15649	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
92	15650	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
94	15651	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
95	15652	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
8	15653	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
10	15654	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
51	15655	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
2	15656	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
60	15657	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
27	15658	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
18	15659	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
36	15660	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
41	15661	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
45	15662	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
61	15663	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
21	15664	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
58	15665	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
89	15666	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
59	15667	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
54	15668	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
55	15669	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
57	15670	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
88	15671	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
25	15672	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
39	15673	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
70	15674	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
53	15675	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
56	15676	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
79	15677	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
86	15678	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
24	15679	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
40	15680	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
47	15681	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
64	15682	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
9	15683	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
12	15684	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
32	15685	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
65	15686	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
81	15687	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
82	15688	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
1	15689	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
26	15690	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
42	15691	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
73	15692	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
74	15693	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
3	15694	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
43	15695	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
11	15696	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
66	15697	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
4	15698	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
5	15699	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
6	15700	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
2B	15701	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
75	15702	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
77	15703	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
91	15704	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
93	15705	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
52	15706	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
80	15707	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
76	15708	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
28	15709	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
37	15710	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
14	15711	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
50	15712	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
71	15713	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
62	15714	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
67	15715	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
68	15716	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
90	15717	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
44	15718	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
49	15719	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
72	15720	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
85	15721	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
22	15722	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
29	15723	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
35	15724	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
16	15725	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
17	15726	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
33	15727	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
31	15728	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
46	15729	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
19	15730	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
23	15731	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
87	15732	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
7	15733	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
38	15734	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
69	15735	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
15	15736	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
63	15737	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
30	15738	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
34	15739	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
48	15740	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
13	15741	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
83	15742	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
84	15743	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
2A	15744	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Barbastella barbastellus
78	15745	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
92	15746	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
94	15747	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
95	15748	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
8	15749	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
10	15750	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
51	15751	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
2	15752	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
60	15753	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
27	15754	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
18	15755	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
36	15756	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
41	15757	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
45	15758	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
61	15759	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
21	15760	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
58	15761	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
89	15762	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
59	15763	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
54	15764	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
55	15765	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
57	15766	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
88	15767	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
25	15768	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
39	15769	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
70	15770	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
53	15771	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
56	15772	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
79	15773	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
86	15774	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
24	15775	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
40	15776	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
47	15777	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
64	15778	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
9	15779	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
12	15780	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
32	15781	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
65	15782	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
81	15783	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
82	15784	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
1	15785	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
26	15786	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
42	15787	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
73	15788	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
74	15789	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
3	15790	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
43	15791	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
11	15792	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
66	15793	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
4	15794	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
5	15795	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
6	15796	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
2B	15797	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
75	15798	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
77	15799	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
91	15800	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
93	15801	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
52	15802	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
80	15803	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
76	15804	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
28	15805	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
37	15806	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
14	15807	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
50	15808	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
71	15809	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
62	15810	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
67	15811	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
68	15812	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
90	15813	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
44	15814	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
49	15815	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
72	15816	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
85	15817	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
22	15818	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
29	15819	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
35	15820	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
16	15821	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
17	15822	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
33	15823	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
31	15824	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
46	15825	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
19	15826	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
23	15827	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
87	15828	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
7	15829	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
38	15830	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
69	15831	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
15	15832	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
63	15833	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
30	15834	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
34	15835	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
48	15836	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
13	15837	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
83	15838	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
84	15839	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
2A	15840	60345	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Barbastella barbastellus
8	15841	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
45	15842	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
61	15843	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
58	15844	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
55	15845	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
86	15846	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
47	15847	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
9	15848	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
26	15849	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
73	15850	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
4	15851	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
2B	15852	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
75	15853	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
93	15854	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
28	15855	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
50	15856	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
71	15857	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
72	15858	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
17	15859	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
87	15860	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
7	15861	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
48	15862	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
13	15863	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
78	15864	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
94	15865	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
95	15866	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
18	15867	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
21	15868	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
89	15869	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
59	15870	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
88	15871	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
12	15872	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
81	15873	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
82	15874	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
1	15875	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
11	15876	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
66	15877	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
77	15878	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
76	15879	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
67	15880	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
44	15881	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
49	15882	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
22	15883	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
29	15884	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
16	15885	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
33	15886	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
31	15887	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
19	15888	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
69	15889	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
63	15890	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
83	15891	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
92	15892	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
10	15893	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
51	15894	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
2	15895	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
36	15896	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
54	15897	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
25	15898	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
39	15899	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
56	15900	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
32	15901	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
42	15902	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
74	15903	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
3	15904	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
43	15905	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
5	15906	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
91	15907	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
52	15908	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
80	15909	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
37	15910	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
14	15911	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
90	15912	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
85	15913	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
46	15914	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
38	15915	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
15	15916	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
84	15917	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
60	15918	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
27	15919	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
41	15920	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
57	15921	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
70	15922	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
53	15923	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
79	15924	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
24	15925	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
40	15926	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
64	15927	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
65	15928	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
6	15929	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
62	15930	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
68	15931	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
35	15932	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
23	15933	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
30	15934	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
34	15935	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
2A	15936	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis mystacinus
8	15937	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
45	15938	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
61	15939	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
58	15940	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
55	15941	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
86	15942	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
47	15943	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
9	15944	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
26	15945	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
73	15946	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
4	15947	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
2B	15948	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
75	15949	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
93	15950	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
28	15951	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
50	15952	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
71	15953	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
72	15954	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
17	15955	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
87	15956	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
7	15957	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
48	15958	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
13	15959	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
78	15960	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
94	15961	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
95	15962	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
18	15963	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
21	15964	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
89	15965	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
59	15966	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
88	15967	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
12	15968	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
81	15969	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
82	15970	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
1	15971	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
11	15972	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
66	15973	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
77	15974	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
76	15975	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
67	15976	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
44	15977	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
49	15978	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
22	15979	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
29	15980	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
16	15981	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
33	15982	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
31	15983	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
19	15984	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
69	15985	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
63	15986	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
83	15987	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
92	15988	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
10	15989	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
51	15990	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
2	15991	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
36	15992	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
54	15993	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
25	15994	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
39	15995	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
56	15996	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
32	15997	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
42	15998	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
74	15999	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
3	16000	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
43	16001	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
5	16002	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
91	16003	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
52	16004	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
80	16005	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
37	16006	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
14	16007	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
90	16008	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
85	16009	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
46	16010	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
38	16011	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
15	16012	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
84	16013	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
60	16014	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
27	16015	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
41	16016	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
57	16017	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
70	16018	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
53	16019	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
79	16020	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
24	16021	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
40	16022	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
64	16023	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
65	16024	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
6	16025	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
62	16026	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
68	16027	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
35	16028	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
23	16029	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
30	16030	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
34	16031	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
2A	16032	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis mystacinus
8	16033	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
45	16034	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
61	16035	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
58	16036	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
55	16037	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
86	16038	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
47	16039	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
9	16040	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
26	16041	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
73	16042	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
4	16043	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
2B	16044	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
75	16045	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
93	16046	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
28	16047	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
50	16048	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
71	16049	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
72	16050	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
17	16051	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
87	16052	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
7	16053	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
48	16054	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
13	16055	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
78	16056	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
94	16057	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
95	16058	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
18	16059	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
21	16060	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
89	16061	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
59	16062	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
88	16063	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
12	16064	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
81	16065	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
82	16066	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
1	16067	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
11	16068	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
66	16069	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
77	16070	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
76	16071	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
67	16072	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
44	16073	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
49	16074	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
22	16075	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
29	16076	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
16	16077	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
33	16078	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
31	16079	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
19	16080	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
69	16081	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
63	16082	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
83	16083	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
92	16084	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
10	16085	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
51	16086	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
2	16087	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
36	16088	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
54	16089	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
25	16090	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
39	16091	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
56	16092	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
32	16093	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
42	16094	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
74	16095	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
3	16096	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
43	16097	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
5	16098	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
91	16099	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
52	16100	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
80	16101	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
37	16102	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
14	16103	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
90	16104	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
85	16105	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
46	16106	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
38	16107	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
15	16108	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
84	16109	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
60	16110	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
27	16111	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
41	16112	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
57	16113	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
70	16114	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
53	16115	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
79	16116	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
24	16117	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
40	16118	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
64	16119	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
65	16120	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
6	16121	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
62	16122	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
68	16123	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
35	16124	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
23	16125	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
30	16126	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
34	16127	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
2A	16128	60383	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis mystacinus
8	16129	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
45	16130	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
61	16131	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
58	16132	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
55	16133	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
86	16134	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
47	16135	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
9	16136	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
26	16137	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
73	16138	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
4	16139	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
2B	16140	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
75	16141	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
93	16142	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
28	16143	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
50	16144	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
71	16145	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
72	16146	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
17	16147	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
87	16148	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
7	16149	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
48	16150	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
13	16151	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
78	16152	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
94	16153	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
95	16154	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
18	16155	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
21	16156	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
89	16157	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
59	16158	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
88	16159	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
12	16160	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
81	16161	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
82	16162	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
1	16163	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
11	16164	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
66	16165	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
77	16166	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
76	16167	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
67	16168	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
44	16169	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
49	16170	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
22	16171	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
29	16172	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
16	16173	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
33	16174	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
31	16175	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
19	16176	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
69	16177	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
63	16178	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
83	16179	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
92	16180	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
10	16181	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
51	16182	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
2	16183	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
36	16184	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
54	16185	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
25	16186	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
39	16187	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
56	16188	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
32	16189	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
42	16190	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
74	16191	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
3	16192	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
43	16193	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
5	16194	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
91	16195	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
52	16196	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
80	16197	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
37	16198	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
14	16199	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
90	16200	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
85	16201	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
46	16202	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
38	16203	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
15	16204	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
84	16205	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
60	16206	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
27	16207	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
41	16208	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
57	16209	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
70	16210	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
53	16211	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
79	16212	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
24	16213	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
40	16214	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
64	16215	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
65	16216	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
6	16217	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
62	16218	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
68	16219	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
35	16220	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
23	16221	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
30	16222	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
34	16223	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
2A	16224	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis emarginatus
78	16225	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
92	16226	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
94	16227	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
95	16228	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
8	16229	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
10	16230	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
51	16231	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
2	16232	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
60	16233	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
27	16234	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
18	16235	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
36	16236	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
41	16237	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
45	16238	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
61	16239	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
21	16240	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
58	16241	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
89	16242	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
59	16243	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
54	16244	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
55	16245	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
57	16246	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
88	16247	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
25	16248	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
39	16249	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
70	16250	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
53	16251	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
56	16252	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
79	16253	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
86	16254	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
24	16255	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
40	16256	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
47	16257	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
64	16258	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
9	16259	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
12	16260	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
32	16261	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
65	16262	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
81	16263	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
82	16264	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
1	16265	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
26	16266	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
42	16267	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
73	16268	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
74	16269	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
3	16270	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
43	16271	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
11	16272	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
66	16273	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
4	16274	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
5	16275	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
6	16276	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
2B	16277	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
75	16278	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
77	16279	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
91	16280	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
93	16281	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
52	16282	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
80	16283	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
76	16284	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
28	16285	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
37	16286	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
14	16287	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
50	16288	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
71	16289	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
62	16290	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
67	16291	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
68	16292	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
90	16293	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
44	16294	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
49	16295	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
72	16296	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
85	16297	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
22	16298	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
29	16299	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
35	16300	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
16	16301	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
17	16302	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
33	16303	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
31	16304	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
46	16305	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
19	16306	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
23	16307	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
87	16308	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
7	16309	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
38	16310	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
69	16311	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
15	16312	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
63	16313	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
30	16314	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
34	16315	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
48	16316	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
13	16317	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
83	16318	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
84	16319	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
2A	16320	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis emarginatus
78	16321	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
92	16322	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
94	16323	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
95	16324	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
8	16325	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
10	16326	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
51	16327	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
2	16328	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
60	16329	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
27	16330	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
18	16331	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
36	16332	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
41	16333	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
45	16334	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
61	16335	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
21	16336	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
58	16337	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
89	16338	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
59	16339	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
54	16340	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
55	16341	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
57	16342	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
88	16343	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
25	16344	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
39	16345	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
70	16346	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
53	16347	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
56	16348	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
79	16349	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
86	16350	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
24	16351	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
40	16352	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
47	16353	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
64	16354	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
9	16355	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
12	16356	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
32	16357	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
65	16358	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
81	16359	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
82	16360	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
1	16361	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
26	16362	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
42	16363	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
73	16364	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
74	16365	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
3	16366	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
43	16367	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
11	16368	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
66	16369	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
4	16370	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
5	16371	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
6	16372	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
2B	16373	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
75	16374	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
77	16375	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
91	16376	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
93	16377	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
52	16378	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
80	16379	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
76	16380	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
28	16381	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
37	16382	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
14	16383	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
50	16384	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
71	16385	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
62	16386	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
67	16387	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
68	16388	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
90	16389	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
44	16390	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
49	16391	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
72	16392	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
85	16393	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
22	16394	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
29	16395	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
35	16396	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
16	16397	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
17	16398	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
33	16399	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
31	16400	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
46	16401	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
19	16402	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
23	16403	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
87	16404	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
7	16405	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
38	16406	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
69	16407	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
15	16408	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
63	16409	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
30	16410	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
34	16411	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
48	16412	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
13	16413	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
83	16414	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
84	16415	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
2A	16416	60400	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis emarginatus
78	16417	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
92	16418	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
94	16419	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
95	16420	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
8	16421	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
10	16422	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
51	16423	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
2	16424	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
60	16425	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
27	16426	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
18	16427	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
36	16428	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
41	16429	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
45	16430	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
61	16431	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
21	16432	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
58	16433	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
89	16434	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
59	16435	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
54	16436	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
55	16437	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
57	16438	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
88	16439	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
25	16440	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
39	16441	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
70	16442	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
53	16443	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
56	16444	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
79	16445	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
86	16446	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
24	16447	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
40	16448	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
47	16449	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
64	16450	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
9	16451	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
12	16452	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
32	16453	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
65	16454	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
81	16455	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
82	16456	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
1	16457	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
26	16458	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
42	16459	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
73	16460	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
74	16461	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
3	16462	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
43	16463	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
11	16464	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
66	16465	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
4	16466	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
5	16467	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
6	16468	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
2B	16469	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
75	16470	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
77	16471	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
91	16472	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
93	16473	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
52	16474	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
80	16475	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
76	16476	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
28	16477	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
37	16478	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
14	16479	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
50	16480	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
71	16481	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
62	16482	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
67	16483	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
68	16484	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
90	16485	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
44	16486	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
49	16487	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
72	16488	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
85	16489	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
22	16490	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
29	16491	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
35	16492	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
16	16493	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
17	16494	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
33	16495	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
31	16496	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
46	16497	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
19	16498	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
23	16499	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
87	16500	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
7	16501	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
38	16502	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
69	16503	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
15	16504	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
63	16505	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
30	16506	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
34	16507	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
48	16508	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
13	16509	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
83	16510	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
84	16511	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
2A	16512	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis nattereri
78	16513	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
92	16514	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
94	16515	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
95	16516	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
8	16517	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
10	16518	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
51	16519	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
2	16520	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
60	16521	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
27	16522	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
18	16523	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
36	16524	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
41	16525	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
45	16526	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
61	16527	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
21	16528	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
58	16529	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
89	16530	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
59	16531	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
54	16532	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
55	16533	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
57	16534	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
88	16535	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
25	16536	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
39	16537	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
70	16538	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
53	16539	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
56	16540	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
79	16541	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
86	16542	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
24	16543	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
40	16544	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
47	16545	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
64	16546	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
9	16547	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
12	16548	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
32	16549	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
65	16550	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
81	16551	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
82	16552	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
1	16553	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
26	16554	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
42	16555	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
73	16556	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
74	16557	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
3	16558	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
43	16559	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
11	16560	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
66	16561	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
4	16562	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
5	16563	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
6	16564	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
2B	16565	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
75	16566	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
77	16567	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
91	16568	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
93	16569	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
52	16570	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
80	16571	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
76	16572	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
28	16573	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
37	16574	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
14	16575	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
50	16576	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
71	16577	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
62	16578	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
67	16579	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
68	16580	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
90	16581	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
44	16582	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
49	16583	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
72	16584	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
85	16585	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
22	16586	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
29	16587	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
35	16588	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
16	16589	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
17	16590	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
33	16591	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
31	16592	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
46	16593	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
19	16594	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
23	16595	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
87	16596	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
7	16597	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
38	16598	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
69	16599	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
15	16600	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
63	16601	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
30	16602	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
34	16603	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
48	16604	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
13	16605	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
83	16606	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
84	16607	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
2A	16608	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis nattereri
8	16609	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
45	16610	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
61	16611	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
58	16612	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
55	16613	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
86	16614	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
47	16615	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
9	16616	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
26	16617	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
73	16618	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
4	16619	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
2B	16620	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
75	16621	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
93	16622	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
28	16623	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
50	16624	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
71	16625	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
72	16626	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
17	16627	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
87	16628	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
7	16629	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
48	16630	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
13	16631	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
78	16632	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
94	16633	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
95	16634	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
18	16635	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
21	16636	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
89	16637	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
59	16638	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
88	16639	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
12	16640	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
81	16641	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
82	16642	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
1	16643	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
11	16644	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
66	16645	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
77	16646	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
76	16647	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
67	16648	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
44	16649	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
49	16650	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
22	16651	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
29	16652	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
16	16653	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
33	16654	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
31	16655	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
19	16656	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
69	16657	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
63	16658	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
83	16659	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
92	16660	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
10	16661	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
51	16662	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
2	16663	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
36	16664	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
54	16665	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
25	16666	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
39	16667	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
56	16668	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
32	16669	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
42	16670	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
74	16671	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
3	16672	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
43	16673	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
5	16674	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
91	16675	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
52	16676	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
80	16677	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
37	16678	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
14	16679	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
90	16680	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
85	16681	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
46	16682	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
38	16683	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
15	16684	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
84	16685	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
60	16686	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
27	16687	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
41	16688	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
57	16689	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
70	16690	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
53	16691	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
79	16692	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
24	16693	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
40	16694	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
64	16695	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
65	16696	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
6	16697	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
62	16698	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
68	16699	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
35	16700	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
23	16701	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
30	16702	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
34	16703	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
2A	16704	60408	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis nattereri
8	16705	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
45	16706	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
61	16707	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
58	16708	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
55	16709	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
86	16710	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
47	16711	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
9	16712	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
26	16713	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
73	16714	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
4	16715	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
2B	16716	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
75	16717	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
93	16718	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
28	16719	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
50	16720	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
71	16721	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
72	16722	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
17	16723	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
87	16724	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
7	16725	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
48	16726	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
13	16727	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
78	16728	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
94	16729	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
95	16730	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
18	16731	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
21	16732	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
89	16733	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
59	16734	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
88	16735	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
12	16736	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
81	16737	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
82	16738	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
1	16739	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
11	16740	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
66	16741	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
77	16742	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
76	16743	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
67	16744	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
44	16745	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
49	16746	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
22	16747	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
29	16748	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
16	16749	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
33	16750	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
31	16751	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
19	16752	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
69	16753	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
63	16754	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
83	16755	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
92	16756	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
10	16757	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
51	16758	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
2	16759	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
36	16760	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
54	16761	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
25	16762	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
39	16763	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
56	16764	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
32	16765	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
42	16766	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
74	16767	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
3	16768	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
43	16769	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
5	16770	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
91	16771	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
52	16772	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
80	16773	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
37	16774	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
14	16775	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
90	16776	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
85	16777	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
46	16778	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
38	16779	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
15	16780	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
84	16781	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
60	16782	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
27	16783	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
41	16784	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
57	16785	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
70	16786	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
53	16787	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
79	16788	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
24	16789	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
40	16790	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
64	16791	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
65	16792	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
6	16793	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
62	16794	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
68	16795	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
35	16796	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
23	16797	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
30	16798	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
34	16799	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
2A	16800	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis escalerai
8	16801	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
45	16802	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
61	16803	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
58	16804	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
55	16805	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
86	16806	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
47	16807	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
9	16808	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
26	16809	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
73	16810	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
4	16811	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
2B	16812	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
75	16813	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
93	16814	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
28	16815	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
50	16816	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
71	16817	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
72	16818	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
17	16819	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
87	16820	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
7	16821	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
48	16822	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
13	16823	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
78	16824	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
94	16825	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
95	16826	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
18	16827	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
21	16828	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
89	16829	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
59	16830	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
88	16831	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
12	16832	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
81	16833	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
82	16834	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
1	16835	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
11	16836	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
66	16837	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
77	16838	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
76	16839	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
67	16840	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
44	16841	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
49	16842	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
22	16843	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
29	16844	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
16	16845	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
33	16846	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
31	16847	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
19	16848	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
69	16849	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
63	16850	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
83	16851	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
92	16852	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
10	16853	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
51	16854	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
2	16855	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
36	16856	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
54	16857	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
25	16858	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
39	16859	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
56	16860	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
32	16861	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
42	16862	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
74	16863	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
3	16864	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
43	16865	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
5	16866	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
91	16867	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
52	16868	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
80	16869	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
37	16870	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
14	16871	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
90	16872	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
85	16873	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
46	16874	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
38	16875	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
15	16876	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
84	16877	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
60	16878	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
27	16879	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
41	16880	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
57	16881	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
70	16882	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
53	16883	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
79	16884	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
24	16885	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
40	16886	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
64	16887	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
65	16888	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
6	16889	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
62	16890	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
68	16891	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
35	16892	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
23	16893	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
30	16894	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
34	16895	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
2A	16896	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis escalerai
78	16897	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
92	16898	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
94	16899	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
95	16900	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
8	16901	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
10	16902	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
51	16903	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
2	16904	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
60	16905	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
27	16906	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
18	16907	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
36	16908	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
41	16909	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
45	16910	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
61	16911	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
21	16912	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
58	16913	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
89	16914	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
59	16915	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
54	16916	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
55	16917	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
57	16918	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
88	16919	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
25	16920	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
39	16921	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
70	16922	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
53	16923	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
56	16924	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
79	16925	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
86	16926	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
24	16927	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
40	16928	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
47	16929	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
64	16930	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
9	16931	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
12	16932	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
32	16933	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
65	16934	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
81	16935	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
82	16936	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
1	16937	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
26	16938	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
42	16939	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
73	16940	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
74	16941	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
3	16942	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
43	16943	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
11	16944	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
66	16945	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
4	16946	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
5	16947	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
6	16948	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
2B	16949	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
75	16950	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
77	16951	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
91	16952	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
93	16953	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
52	16954	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
80	16955	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
76	16956	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
28	16957	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
37	16958	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
14	16959	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
50	16960	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
71	16961	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
62	16962	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
67	16963	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
68	16964	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
90	16965	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
44	16966	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
49	16967	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
72	16968	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
85	16969	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
22	16970	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
29	16971	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
35	16972	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
16	16973	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
17	16974	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
33	16975	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
31	16976	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
46	16977	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
19	16978	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
23	16979	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
87	16980	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
7	16981	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
38	16982	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
69	16983	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
15	16984	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
63	16985	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
30	16986	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
34	16987	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
48	16988	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
13	16989	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
83	16990	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
84	16991	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
2A	16992	60411	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis escalerai
78	16993	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
92	16994	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
94	16995	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
95	16996	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
8	16997	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
10	16998	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
51	16999	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
2	17000	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
60	17001	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
27	17002	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
18	17003	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
36	17004	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
41	17005	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
45	17006	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
61	17007	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
21	17008	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
58	17009	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
89	17010	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
59	17011	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
54	17012	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
55	17013	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
57	17014	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
88	17015	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
25	17016	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
39	17017	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
70	17018	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
53	17019	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
56	17020	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
79	17021	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
86	17022	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
24	17023	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
40	17024	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
47	17025	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
64	17026	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
9	17027	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
12	17028	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
32	17029	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
65	17030	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
81	17031	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
82	17032	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
1	17033	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
26	17034	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
42	17035	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
73	17036	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
74	17037	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
3	17038	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
43	17039	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
11	17040	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
66	17041	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
4	17042	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
5	17043	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
6	17044	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
2B	17045	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
75	17046	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
77	17047	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
91	17048	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
93	17049	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
52	17050	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
80	17051	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
76	17052	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
28	17053	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
37	17054	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
14	17055	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
50	17056	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
71	17057	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
62	17058	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
67	17059	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
68	17060	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
90	17061	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
44	17062	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
49	17063	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
72	17064	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
85	17065	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
22	17066	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
29	17067	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
35	17068	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
16	17069	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
17	17070	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
33	17071	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
31	17072	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
46	17073	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
19	17074	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
23	17075	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
87	17076	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
7	17077	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
38	17078	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
69	17079	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
15	17080	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
63	17081	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
30	17082	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
34	17083	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
30	18138	699127	\N	1	\N	9	\N	Salamandra lanzai
48	17084	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
13	17085	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
83	17086	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
84	17087	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
2A	17088	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis myotis
8	17089	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
45	17090	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
61	17091	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
58	17092	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
55	17093	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
86	17094	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
47	17095	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
9	17096	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
26	17097	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
73	17098	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
4	17099	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
2B	17100	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
75	17101	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
93	17102	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
28	17103	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
50	17104	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
71	17105	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
72	17106	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
17	17107	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
87	17108	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
7	17109	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
48	17110	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
13	17111	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
78	17112	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
94	17113	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
95	17114	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
18	17115	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
21	17116	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
89	17117	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
59	17118	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
88	17119	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
12	17120	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
81	17121	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
82	17122	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
1	17123	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
11	17124	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
66	17125	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
77	17126	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
76	17127	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
67	17128	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
44	17129	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
49	17130	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
22	17131	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
29	17132	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
34	18139	699127	\N	1	\N	9	\N	Salamandra lanzai
16	17133	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
33	17134	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
31	17135	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
19	17136	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
69	17137	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
63	17138	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
83	17139	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
92	17140	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
10	17141	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
51	17142	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
2	17143	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
36	17144	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
54	17145	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
25	17146	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
39	17147	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
56	17148	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
32	17149	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
42	17150	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
74	17151	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
3	17152	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
43	17153	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
5	17154	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
91	17155	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
52	17156	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
80	17157	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
37	17158	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
14	17159	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
90	17160	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
85	17161	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
46	17162	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
38	17163	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
15	17164	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
84	17165	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
60	17166	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
27	17167	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
41	17168	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
57	17169	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
70	17170	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
53	17171	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
79	17172	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
24	17173	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
40	17174	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
64	17175	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
65	17176	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
6	17177	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
62	17178	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
68	17179	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
35	17180	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
23	17181	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
48	18140	699127	\N	1	\N	9	\N	Salamandra lanzai
30	17182	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
34	17183	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
2A	17184	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis myotis
8	17185	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
45	17186	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
61	17187	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
58	17188	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
55	17189	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
86	17190	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
47	17191	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
9	17192	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
26	17193	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
73	17194	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
4	17195	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
2B	17196	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
75	17197	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
93	17198	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
28	17199	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
50	17200	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
71	17201	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
72	17202	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
17	17203	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
87	17204	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
7	17205	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
48	17206	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
13	17207	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
78	17208	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
94	17209	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
95	17210	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
18	17211	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
21	17212	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
89	17213	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
59	17214	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
88	17215	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
12	17216	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
81	17217	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
82	17218	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
1	17219	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
11	17220	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
66	17221	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
77	17222	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
76	17223	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
67	17224	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
44	17225	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
49	17226	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
22	17227	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
29	17228	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
16	17229	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
33	17230	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
13	18141	699127	\N	1	\N	9	\N	Salamandra lanzai
31	17231	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
19	17232	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
69	17233	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
63	17234	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
83	17235	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
92	17236	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
10	17237	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
51	17238	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
2	17239	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
36	17240	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
54	17241	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
25	17242	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
39	17243	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
56	17244	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
32	17245	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
42	17246	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
74	17247	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
3	17248	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
43	17249	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
5	17250	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
91	17251	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
52	17252	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
80	17253	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
37	17254	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
14	17255	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
90	17256	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
85	17257	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
46	17258	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
38	17259	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
15	17260	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
84	17261	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
60	17262	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
27	17263	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
41	17264	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
57	17265	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
70	17266	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
53	17267	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
79	17268	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
24	17269	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
40	17270	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
64	17271	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
65	17272	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
6	17273	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
62	17274	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
68	17275	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
35	17276	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
23	17277	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
30	17278	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
34	17279	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
83	18142	699127	\N	1	\N	9	\N	Salamandra lanzai
2A	17280	60418	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis myotis
8	17281	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
45	17282	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
61	17283	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
58	17284	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
55	17285	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
86	17286	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
47	17287	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
9	17288	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
26	17289	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
73	17290	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
4	17291	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
2B	17292	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
75	17293	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
93	17294	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
28	17295	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
50	17296	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
71	17297	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
72	17298	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
17	17299	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
87	17300	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
7	17301	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
48	17302	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
13	17303	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
78	17304	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
94	17305	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
95	17306	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
18	17307	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
21	17308	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
89	17309	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
59	17310	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
88	17311	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
12	17312	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
81	17313	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
82	17314	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
1	17315	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
11	17316	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
66	17317	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
77	17318	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
76	17319	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
67	17320	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
44	17321	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
49	17322	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
22	17323	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
29	17324	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
16	17325	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
33	17326	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
31	17327	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
19	17328	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
84	18143	699127	\N	1	\N	9	\N	Salamandra lanzai
69	17329	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
63	17330	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
83	17331	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
92	17332	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
10	17333	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
51	17334	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
2	17335	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
36	17336	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
54	17337	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
25	17338	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
39	17339	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
56	17340	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
32	17341	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
42	17342	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
74	17343	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
3	17344	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
43	17345	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
5	17346	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
91	17347	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
52	17348	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
80	17349	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
37	17350	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
14	17351	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
90	17352	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
85	17353	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
46	17354	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
38	17355	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
15	17356	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
84	17357	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
60	17358	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
27	17359	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
41	17360	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
57	17361	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
70	17362	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
53	17363	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
79	17364	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
24	17365	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
40	17366	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
64	17367	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
65	17368	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
6	17369	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
62	17370	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
68	17371	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
35	17372	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
23	17373	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
30	17374	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
34	17375	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
2A	17376	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis blythii
78	17377	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
2A	18144	699127	\N	1	\N	9	\N	Salamandra lanzai
92	17378	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
94	17379	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
95	17380	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
8	17381	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
10	17382	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
51	17383	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
2	17384	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
60	17385	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
27	17386	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
18	17387	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
36	17388	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
41	17389	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
45	17390	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
61	17391	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
21	17392	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
58	17393	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
89	17394	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
59	17395	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
54	17396	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
55	17397	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
57	17398	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
88	17399	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
25	17400	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
39	17401	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
70	17402	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
53	17403	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
56	17404	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
79	17405	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
86	17406	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
24	17407	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
40	17408	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
47	17409	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
64	17410	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
9	17411	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
12	17412	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
32	17413	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
65	17414	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
81	17415	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
82	17416	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
1	17417	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
26	17418	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
42	17419	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
73	17420	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
74	17421	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
3	17422	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
43	17423	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
11	17424	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
66	17425	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
4	17426	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
78	18145	701819	\N	1	\N	9	\N	Salamandra atra
5	17427	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
6	17428	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
2B	17429	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
75	17430	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
77	17431	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
91	17432	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
93	17433	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
52	17434	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
80	17435	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
76	17436	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
28	17437	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
37	17438	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
14	17439	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
50	17440	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
71	17441	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
62	17442	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
67	17443	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
68	17444	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
90	17445	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
44	17446	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
49	17447	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
72	17448	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
85	17449	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
22	17450	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
29	17451	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
35	17452	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
16	17453	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
17	17454	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
33	17455	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
31	17456	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
46	17457	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
19	17458	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
23	17459	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
87	17460	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
7	17461	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
38	17462	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
69	17463	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
15	17464	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
63	17465	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
30	17466	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
34	17467	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
48	17468	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
13	17469	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
83	17470	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
84	17471	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
2A	17472	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis blythii
78	17473	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
92	17474	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
94	17475	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
92	18146	701819	\N	1	\N	9	\N	Salamandra atra
95	17476	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
8	17477	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
10	17478	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
51	17479	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
2	17480	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
60	17481	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
27	17482	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
18	17483	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
36	17484	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
41	17485	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
45	17486	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
61	17487	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
21	17488	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
58	17489	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
89	17490	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
59	17491	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
54	17492	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
55	17493	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
57	17494	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
88	17495	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
25	17496	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
39	17497	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
70	17498	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
53	17499	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
56	17500	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
79	17501	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
86	17502	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
24	17503	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
40	17504	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
47	17505	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
64	17506	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
9	17507	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
12	17508	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
32	17509	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
65	17510	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
81	17511	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
82	17512	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
1	17513	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
26	17514	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
42	17515	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
73	17516	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
74	17517	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
3	17518	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
43	17519	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
11	17520	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
66	17521	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
4	17522	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
5	17523	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
6	17524	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
94	18147	701819	\N	1	\N	9	\N	Salamandra atra
2B	17525	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
75	17526	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
77	17527	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
91	17528	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
93	17529	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
52	17530	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
80	17531	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
76	17532	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
28	17533	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
37	17534	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
14	17535	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
50	17536	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
71	17537	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
62	17538	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
67	17539	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
68	17540	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
90	17541	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
44	17542	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
49	17543	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
72	17544	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
85	17545	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
22	17546	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
29	17547	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
35	17548	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
16	17549	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
17	17550	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
33	17551	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
31	17552	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
46	17553	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
19	17554	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
23	17555	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
87	17556	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
7	17557	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
38	17558	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
69	17559	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
15	17560	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
63	17561	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
30	17562	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
34	17563	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
48	17564	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
13	17565	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
83	17566	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
84	17567	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
2A	17568	60427	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis blythii
78	17569	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
92	17570	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
94	17571	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
95	17572	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
8	17573	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
10	17574	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
51	17575	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
2	17576	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
60	17577	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
27	17578	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
18	17579	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
36	17580	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
41	17581	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
45	17582	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
61	17583	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
21	17584	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
58	17585	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
89	17586	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
59	17587	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
54	17588	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
55	17589	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
57	17590	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
88	17591	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
25	17592	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
39	17593	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
70	17594	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
53	17595	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
56	17596	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
79	17597	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
86	17598	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
24	17599	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
40	17600	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
47	17601	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
64	17602	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
9	17603	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
12	17604	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
32	17605	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
65	17606	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
81	17607	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
82	17608	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
1	17609	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
26	17610	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
42	17611	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
73	17612	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
74	17613	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
3	17614	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
43	17615	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
11	17616	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
66	17617	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
4	17618	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
5	17619	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
6	17620	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
2B	17621	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
75	17622	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
77	17623	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
91	17624	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
93	17625	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
52	17626	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
80	17627	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
76	17628	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
28	17629	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
37	17630	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
14	17631	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
50	17632	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
71	17633	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
62	17634	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
67	17635	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
68	17636	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
90	17637	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
44	17638	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
49	17639	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
72	17640	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
85	17641	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
22	17642	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
29	17643	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
35	17644	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
16	17645	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
17	17646	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
33	17647	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
31	17648	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
46	17649	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
19	17650	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
23	17651	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
87	17652	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
7	17653	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
38	17654	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
69	17655	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
15	17656	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
63	17657	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
30	17658	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
34	17659	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
48	17660	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
13	17661	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
83	17662	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
84	17663	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
2A	17664	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis capaccinii
78	17665	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
92	17666	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
94	17667	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
95	17668	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
8	17669	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
10	17670	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
51	17671	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
2	17672	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
60	17673	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
27	17674	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
18	17675	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
36	17676	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
41	17677	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
45	17678	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
61	17679	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
21	17680	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
58	17681	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
89	17682	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
59	17683	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
54	17684	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
55	17685	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
57	17686	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
88	17687	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
25	17688	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
39	17689	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
70	17690	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
53	17691	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
56	17692	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
79	17693	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
86	17694	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
24	17695	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
40	17696	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
47	17697	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
64	17698	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
9	17699	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
12	17700	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
32	17701	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
65	17702	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
81	17703	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
82	17704	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
1	17705	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
26	17706	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
42	17707	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
73	17708	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
74	17709	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
3	17710	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
43	17711	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
11	17712	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
66	17713	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
4	17714	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
5	17715	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
6	17716	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
2B	17717	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
75	17718	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
77	17719	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
91	17720	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
93	17721	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
52	17722	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
80	17723	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
76	17724	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
28	17725	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
37	17726	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
14	17727	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
50	17728	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
71	17729	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
62	17730	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
67	17731	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
68	17732	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
90	17733	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
44	17734	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
49	17735	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
72	17736	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
85	17737	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
22	17738	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
29	17739	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
35	17740	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
16	17741	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
17	17742	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
33	17743	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
31	17744	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
46	17745	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
19	17746	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
23	17747	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
87	17748	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
7	17749	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
38	17750	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
69	17751	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
15	17752	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
63	17753	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
30	17754	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
34	17755	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
48	17756	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
13	17757	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
83	17758	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
84	17759	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
2A	17760	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis capaccinii
78	17761	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
92	17762	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
94	17763	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
95	17764	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
8	17765	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
10	17766	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
51	17767	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
2	17768	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
60	17769	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
27	17770	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
18	17771	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
36	17772	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
41	17773	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
45	17774	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
61	17775	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
21	17776	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
58	17777	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
89	17778	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
59	17779	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
54	17780	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
55	17781	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
57	17782	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
88	17783	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
25	17784	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
39	17785	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
70	17786	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
53	17787	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
56	17788	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
79	17789	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
86	17790	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
24	17791	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
40	17792	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
47	17793	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
64	17794	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
9	17795	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
12	17796	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
32	17797	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
65	17798	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
81	17799	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
82	17800	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
1	17801	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
26	17802	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
42	17803	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
73	17804	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
74	17805	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
3	17806	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
43	17807	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
11	17808	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
66	17809	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
4	17810	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
5	17811	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
6	17812	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
2B	17813	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
75	17814	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
77	17815	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
91	17816	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
93	17817	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
52	17818	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
80	17819	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
76	17820	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
28	17821	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
37	17822	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
14	17823	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
50	17824	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
71	17825	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
62	17826	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
67	17827	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
68	17828	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
90	17829	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
44	17830	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
49	17831	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
72	17832	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
85	17833	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
22	17834	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
29	17835	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
35	17836	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
16	17837	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
17	17838	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
33	17839	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
31	17840	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
46	17841	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
19	17842	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
23	17843	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
87	17844	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
7	17845	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
38	17846	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
69	17847	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
15	17848	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
63	17849	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
30	17850	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
34	17851	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
48	17852	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
13	17853	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
83	17854	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
84	17855	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
2A	17856	60439	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis capaccinii
78	17857	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
92	17858	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
94	17859	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
95	17860	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
8	17861	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
10	17862	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
51	17863	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
2	17864	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
60	17865	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
27	17866	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
18	17867	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
36	17868	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
41	17869	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
45	17870	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
61	17871	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
21	17872	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
58	17873	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
89	17874	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
59	17875	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
54	17876	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
55	17877	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
57	17878	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
88	17879	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
25	17880	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
39	17881	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
70	17882	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
53	17883	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
56	17884	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
79	17885	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
86	17886	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
24	17887	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
40	17888	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
47	17889	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
64	17890	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
9	17891	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
12	17892	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
32	17893	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
65	17894	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
81	17895	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
82	17896	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
1	17897	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
26	17898	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
42	17899	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
73	17900	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
74	17901	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
3	17902	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
43	17903	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
11	17904	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
66	17905	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
4	17906	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
5	17907	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
6	17908	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
2B	17909	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
75	17910	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
77	17911	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
91	17912	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
93	17913	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
52	17914	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
80	17915	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
76	17916	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
28	17917	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
37	17918	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
14	17919	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
50	17920	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
71	17921	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
62	17922	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
67	17923	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
68	17924	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
90	17925	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
44	17926	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
49	17927	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
72	17928	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
85	17929	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
22	17930	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
29	17931	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
35	17932	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
16	17933	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
17	17934	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
33	17935	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
31	17936	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
46	17937	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
19	17938	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
23	17939	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
87	17940	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
7	17941	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
38	17942	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
69	17943	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
15	17944	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
63	17945	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
30	17946	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
34	17947	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
48	17948	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
13	17949	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
83	17950	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
84	17951	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
2A	17952	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis dasycneme
78	17953	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
92	17954	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
94	17955	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
95	17956	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
8	17957	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
10	17958	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
51	17959	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
2	17960	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
60	17961	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
27	17962	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
18	17963	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
36	17964	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
41	17965	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
45	17966	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
61	17967	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
21	17968	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
58	17969	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
89	17970	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
59	17971	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
54	17972	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
55	17973	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
57	17974	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
88	17975	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
25	17976	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
39	17977	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
70	17978	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
53	17979	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
56	17980	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
79	17981	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
86	17982	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
24	17983	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
40	17984	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
47	17985	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
64	17986	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
9	17987	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
12	17988	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
32	17989	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
65	17990	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
81	17991	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
82	17992	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
1	17993	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
26	17994	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
42	17995	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
73	17996	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
74	17997	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
3	17998	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
43	17999	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
11	18000	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
66	18001	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
4	18002	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
5	18003	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
6	18004	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
2B	18005	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
75	18006	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
77	18007	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
91	18008	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
93	18009	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
52	18010	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
80	18011	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
76	18012	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
28	18013	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
37	18014	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
14	18015	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
50	18016	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
71	18017	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
62	18018	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
67	18019	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
68	18020	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
90	18021	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
44	18022	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
49	18023	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
72	18024	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
85	18025	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
22	18026	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
29	18027	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
35	18028	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
16	18029	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
17	18030	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
33	18031	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
31	18032	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
46	18033	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
19	18034	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
23	18035	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
87	18036	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
7	18037	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
38	18038	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
69	18039	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
15	18040	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
63	18041	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
30	18042	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
34	18043	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
48	18044	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
13	18045	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
83	18046	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
84	18047	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
2A	18048	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis dasycneme
78	18049	699127	\N	1	\N	9	\N	Salamandra lanzai
92	18050	699127	\N	1	\N	9	\N	Salamandra lanzai
94	18051	699127	\N	1	\N	9	\N	Salamandra lanzai
95	18052	699127	\N	1	\N	9	\N	Salamandra lanzai
8	18053	699127	\N	1	\N	9	\N	Salamandra lanzai
10	18054	699127	\N	1	\N	9	\N	Salamandra lanzai
51	18055	699127	\N	1	\N	9	\N	Salamandra lanzai
2	18056	699127	\N	1	\N	9	\N	Salamandra lanzai
60	18057	699127	\N	1	\N	9	\N	Salamandra lanzai
27	18058	699127	\N	1	\N	9	\N	Salamandra lanzai
18	18059	699127	\N	1	\N	9	\N	Salamandra lanzai
36	18060	699127	\N	1	\N	9	\N	Salamandra lanzai
41	18061	699127	\N	1	\N	9	\N	Salamandra lanzai
45	18062	699127	\N	1	\N	9	\N	Salamandra lanzai
61	18063	699127	\N	1	\N	9	\N	Salamandra lanzai
21	18064	699127	\N	1	\N	9	\N	Salamandra lanzai
58	18065	699127	\N	1	\N	9	\N	Salamandra lanzai
89	18066	699127	\N	1	\N	9	\N	Salamandra lanzai
59	18067	699127	\N	1	\N	9	\N	Salamandra lanzai
54	18068	699127	\N	1	\N	9	\N	Salamandra lanzai
55	18069	699127	\N	1	\N	9	\N	Salamandra lanzai
57	18070	699127	\N	1	\N	9	\N	Salamandra lanzai
88	18071	699127	\N	1	\N	9	\N	Salamandra lanzai
25	18072	699127	\N	1	\N	9	\N	Salamandra lanzai
39	18073	699127	\N	1	\N	9	\N	Salamandra lanzai
70	18074	699127	\N	1	\N	9	\N	Salamandra lanzai
53	18075	699127	\N	1	\N	9	\N	Salamandra lanzai
56	18076	699127	\N	1	\N	9	\N	Salamandra lanzai
79	18077	699127	\N	1	\N	9	\N	Salamandra lanzai
86	18078	699127	\N	1	\N	9	\N	Salamandra lanzai
24	18079	699127	\N	1	\N	9	\N	Salamandra lanzai
40	18080	699127	\N	1	\N	9	\N	Salamandra lanzai
47	18081	699127	\N	1	\N	9	\N	Salamandra lanzai
64	18082	699127	\N	1	\N	9	\N	Salamandra lanzai
9	18083	699127	\N	1	\N	9	\N	Salamandra lanzai
12	18084	699127	\N	1	\N	9	\N	Salamandra lanzai
32	18085	699127	\N	1	\N	9	\N	Salamandra lanzai
65	18086	699127	\N	1	\N	9	\N	Salamandra lanzai
81	18087	699127	\N	1	\N	9	\N	Salamandra lanzai
82	18088	699127	\N	1	\N	9	\N	Salamandra lanzai
1	18089	699127	\N	1	\N	9	\N	Salamandra lanzai
26	18090	699127	\N	1	\N	9	\N	Salamandra lanzai
42	18091	699127	\N	1	\N	9	\N	Salamandra lanzai
73	18092	699127	\N	1	\N	9	\N	Salamandra lanzai
74	18093	699127	\N	1	\N	9	\N	Salamandra lanzai
3	18094	699127	\N	1	\N	9	\N	Salamandra lanzai
43	18095	699127	\N	1	\N	9	\N	Salamandra lanzai
11	18096	699127	\N	1	\N	9	\N	Salamandra lanzai
66	18097	699127	\N	1	\N	9	\N	Salamandra lanzai
4	18098	699127	\N	1	\N	9	\N	Salamandra lanzai
5	18099	699127	\N	1	\N	9	\N	Salamandra lanzai
6	18100	699127	\N	1	\N	9	\N	Salamandra lanzai
2B	18101	699127	\N	1	\N	9	\N	Salamandra lanzai
75	18102	699127	\N	1	\N	9	\N	Salamandra lanzai
77	18103	699127	\N	1	\N	9	\N	Salamandra lanzai
91	18104	699127	\N	1	\N	9	\N	Salamandra lanzai
93	18105	699127	\N	1	\N	9	\N	Salamandra lanzai
52	18106	699127	\N	1	\N	9	\N	Salamandra lanzai
80	18107	699127	\N	1	\N	9	\N	Salamandra lanzai
76	18108	699127	\N	1	\N	9	\N	Salamandra lanzai
28	18109	699127	\N	1	\N	9	\N	Salamandra lanzai
37	18110	699127	\N	1	\N	9	\N	Salamandra lanzai
14	18111	699127	\N	1	\N	9	\N	Salamandra lanzai
50	18112	699127	\N	1	\N	9	\N	Salamandra lanzai
71	18113	699127	\N	1	\N	9	\N	Salamandra lanzai
62	18114	699127	\N	1	\N	9	\N	Salamandra lanzai
67	18115	699127	\N	1	\N	9	\N	Salamandra lanzai
68	18116	699127	\N	1	\N	9	\N	Salamandra lanzai
90	18117	699127	\N	1	\N	9	\N	Salamandra lanzai
44	18118	699127	\N	1	\N	9	\N	Salamandra lanzai
49	18119	699127	\N	1	\N	9	\N	Salamandra lanzai
72	18120	699127	\N	1	\N	9	\N	Salamandra lanzai
85	18121	699127	\N	1	\N	9	\N	Salamandra lanzai
22	18122	699127	\N	1	\N	9	\N	Salamandra lanzai
29	18123	699127	\N	1	\N	9	\N	Salamandra lanzai
35	18124	699127	\N	1	\N	9	\N	Salamandra lanzai
16	18125	699127	\N	1	\N	9	\N	Salamandra lanzai
17	18126	699127	\N	1	\N	9	\N	Salamandra lanzai
33	18127	699127	\N	1	\N	9	\N	Salamandra lanzai
31	18128	699127	\N	1	\N	9	\N	Salamandra lanzai
46	18129	699127	\N	1	\N	9	\N	Salamandra lanzai
19	18130	699127	\N	1	\N	9	\N	Salamandra lanzai
23	18131	699127	\N	1	\N	9	\N	Salamandra lanzai
87	18132	699127	\N	1	\N	9	\N	Salamandra lanzai
7	18133	699127	\N	1	\N	9	\N	Salamandra lanzai
38	18134	699127	\N	1	\N	9	\N	Salamandra lanzai
69	18135	699127	\N	1	\N	9	\N	Salamandra lanzai
95	18148	701819	\N	1	\N	9	\N	Salamandra atra
8	18149	701819	\N	1	\N	9	\N	Salamandra atra
10	18150	701819	\N	1	\N	9	\N	Salamandra atra
51	18151	701819	\N	1	\N	9	\N	Salamandra atra
2	18152	701819	\N	1	\N	9	\N	Salamandra atra
60	18153	701819	\N	1	\N	9	\N	Salamandra atra
27	18154	701819	\N	1	\N	9	\N	Salamandra atra
18	18155	701819	\N	1	\N	9	\N	Salamandra atra
36	18156	701819	\N	1	\N	9	\N	Salamandra atra
41	18157	701819	\N	1	\N	9	\N	Salamandra atra
45	18158	701819	\N	1	\N	9	\N	Salamandra atra
61	18159	701819	\N	1	\N	9	\N	Salamandra atra
21	18160	701819	\N	1	\N	9	\N	Salamandra atra
58	18161	701819	\N	1	\N	9	\N	Salamandra atra
89	18162	701819	\N	1	\N	9	\N	Salamandra atra
59	18163	701819	\N	1	\N	9	\N	Salamandra atra
54	18164	701819	\N	1	\N	9	\N	Salamandra atra
55	18165	701819	\N	1	\N	9	\N	Salamandra atra
57	18166	701819	\N	1	\N	9	\N	Salamandra atra
88	18167	701819	\N	1	\N	9	\N	Salamandra atra
25	18168	701819	\N	1	\N	9	\N	Salamandra atra
39	18169	701819	\N	1	\N	9	\N	Salamandra atra
70	18170	701819	\N	1	\N	9	\N	Salamandra atra
53	18171	701819	\N	1	\N	9	\N	Salamandra atra
56	18172	701819	\N	1	\N	9	\N	Salamandra atra
79	18173	701819	\N	1	\N	9	\N	Salamandra atra
86	18174	701819	\N	1	\N	9	\N	Salamandra atra
24	18175	701819	\N	1	\N	9	\N	Salamandra atra
40	18176	701819	\N	1	\N	9	\N	Salamandra atra
47	18177	701819	\N	1	\N	9	\N	Salamandra atra
64	18178	701819	\N	1	\N	9	\N	Salamandra atra
9	18179	701819	\N	1	\N	9	\N	Salamandra atra
12	18180	701819	\N	1	\N	9	\N	Salamandra atra
32	18181	701819	\N	1	\N	9	\N	Salamandra atra
65	18182	701819	\N	1	\N	9	\N	Salamandra atra
81	18183	701819	\N	1	\N	9	\N	Salamandra atra
82	18184	701819	\N	1	\N	9	\N	Salamandra atra
1	18185	701819	\N	1	\N	9	\N	Salamandra atra
26	18186	701819	\N	1	\N	9	\N	Salamandra atra
42	18187	701819	\N	1	\N	9	\N	Salamandra atra
73	18188	701819	\N	1	\N	9	\N	Salamandra atra
74	18189	701819	\N	1	\N	9	\N	Salamandra atra
3	18190	701819	\N	1	\N	9	\N	Salamandra atra
43	18191	701819	\N	1	\N	9	\N	Salamandra atra
11	18192	701819	\N	1	\N	9	\N	Salamandra atra
66	18193	701819	\N	1	\N	9	\N	Salamandra atra
4	18194	701819	\N	1	\N	9	\N	Salamandra atra
5	18195	701819	\N	1	\N	9	\N	Salamandra atra
6	18196	701819	\N	1	\N	9	\N	Salamandra atra
2B	18197	701819	\N	1	\N	9	\N	Salamandra atra
75	18198	701819	\N	1	\N	9	\N	Salamandra atra
77	18199	701819	\N	1	\N	9	\N	Salamandra atra
91	18200	701819	\N	1	\N	9	\N	Salamandra atra
93	18201	701819	\N	1	\N	9	\N	Salamandra atra
52	18202	701819	\N	1	\N	9	\N	Salamandra atra
80	18203	701819	\N	1	\N	9	\N	Salamandra atra
76	18204	701819	\N	1	\N	9	\N	Salamandra atra
28	18205	701819	\N	1	\N	9	\N	Salamandra atra
37	18206	701819	\N	1	\N	9	\N	Salamandra atra
14	18207	701819	\N	1	\N	9	\N	Salamandra atra
50	18208	701819	\N	1	\N	9	\N	Salamandra atra
71	18209	701819	\N	1	\N	9	\N	Salamandra atra
62	18210	701819	\N	1	\N	9	\N	Salamandra atra
67	18211	701819	\N	1	\N	9	\N	Salamandra atra
68	18212	701819	\N	1	\N	9	\N	Salamandra atra
90	18213	701819	\N	1	\N	9	\N	Salamandra atra
44	18214	701819	\N	1	\N	9	\N	Salamandra atra
49	18215	701819	\N	1	\N	9	\N	Salamandra atra
72	18216	701819	\N	1	\N	9	\N	Salamandra atra
85	18217	701819	\N	1	\N	9	\N	Salamandra atra
22	18218	701819	\N	1	\N	9	\N	Salamandra atra
29	18219	701819	\N	1	\N	9	\N	Salamandra atra
35	18220	701819	\N	1	\N	9	\N	Salamandra atra
16	18221	701819	\N	1	\N	9	\N	Salamandra atra
17	18222	701819	\N	1	\N	9	\N	Salamandra atra
33	18223	701819	\N	1	\N	9	\N	Salamandra atra
31	18224	701819	\N	1	\N	9	\N	Salamandra atra
46	18225	701819	\N	1	\N	9	\N	Salamandra atra
19	18226	701819	\N	1	\N	9	\N	Salamandra atra
23	18227	701819	\N	1	\N	9	\N	Salamandra atra
87	18228	701819	\N	1	\N	9	\N	Salamandra atra
7	18229	701819	\N	1	\N	9	\N	Salamandra atra
38	18230	701819	\N	1	\N	9	\N	Salamandra atra
69	18231	701819	\N	1	\N	9	\N	Salamandra atra
15	18232	701819	\N	1	\N	9	\N	Salamandra atra
63	18233	701819	\N	1	\N	9	\N	Salamandra atra
30	18234	701819	\N	1	\N	9	\N	Salamandra atra
34	18235	701819	\N	1	\N	9	\N	Salamandra atra
48	18236	701819	\N	1	\N	9	\N	Salamandra atra
13	18237	701819	\N	1	\N	9	\N	Salamandra atra
83	18238	701819	\N	1	\N	9	\N	Salamandra atra
84	18239	701819	\N	1	\N	9	\N	Salamandra atra
2A	18240	701819	\N	1	\N	9	\N	Salamandra atra
78	18241	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
92	18242	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
94	18243	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
95	18244	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
8	18245	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
10	18246	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
51	18247	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
2	18248	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
60	18249	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
27	18250	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
18	18251	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
36	18252	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
41	18253	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
45	18254	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
61	18255	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
21	18256	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
58	18257	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
89	18258	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
59	18259	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
54	18260	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
55	18261	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
57	18262	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
88	18263	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
25	18264	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
39	18265	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
70	18266	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
53	18267	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
56	18268	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
79	18269	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
86	18270	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
24	18271	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
40	18272	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
47	18273	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
64	18274	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
9	18275	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
12	18276	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
32	18277	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
65	18278	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
81	18279	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
82	18280	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
1	18281	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
26	18282	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
42	18283	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
73	18284	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
74	18285	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
3	18286	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
43	18287	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
11	18288	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
66	18289	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
4	18290	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
5	18291	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
6	18292	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
2B	18293	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
75	18294	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
77	18295	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
91	18296	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
93	18297	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
52	18298	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
80	18299	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
76	18300	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
28	18301	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
37	18302	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
14	18303	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
50	18304	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
71	18305	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
62	18306	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
67	18307	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
68	18308	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
90	18309	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
44	18310	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
49	18311	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
72	18312	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
85	18313	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
22	18314	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
29	18315	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
35	18316	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
16	18317	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
17	18318	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
33	18319	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
31	18320	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
46	18321	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
19	18322	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
23	18323	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
87	18324	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
7	18325	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
38	18326	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
69	18327	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
15	18328	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
63	18329	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
30	18330	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
34	18331	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
48	18332	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
13	18333	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
83	18334	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
84	18335	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
2A	18336	60447	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis dasycneme
78	18337	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
92	18338	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
94	18339	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
95	18340	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
8	18341	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
10	18342	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
51	18343	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
2	18344	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
60	18345	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
27	18346	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
18	18347	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
36	18348	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
41	18349	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
45	18350	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
61	18351	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
21	18352	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
58	18353	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
89	18354	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
59	18355	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
54	18356	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
55	18357	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
57	18358	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
88	18359	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
25	18360	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
39	18361	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
70	18362	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
53	18363	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
56	18364	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
79	18365	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
86	18366	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
24	18367	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
40	18368	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
47	18369	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
64	18370	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
9	18371	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
12	18372	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
32	18373	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
65	18374	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
81	18375	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
82	18376	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
1	18377	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
26	18378	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
42	18379	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
73	18380	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
74	18381	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
3	18382	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
43	18383	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
11	18384	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
66	18385	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
4	18386	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
5	18387	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
6	18388	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
2B	18389	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
75	18390	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
77	18391	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
91	18392	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
93	18393	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
52	18394	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
80	18395	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
76	18396	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
28	18397	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
37	18398	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
14	18399	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
50	18400	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
71	18401	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
62	18402	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
67	18403	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
68	18404	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
90	18405	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
44	18406	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
49	18407	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
72	18408	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
85	18409	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
22	18410	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
29	18411	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
35	18412	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
16	18413	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
17	18414	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
33	18415	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
31	18416	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
46	18417	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
19	18418	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
23	18419	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
87	18420	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
7	18421	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
38	18422	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
69	18423	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
15	18424	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
63	18425	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
30	18426	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
34	18427	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
48	18428	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
13	18429	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
83	18430	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
84	18431	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
2A	18432	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus auritus
78	18433	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
92	18434	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
56	19708	64435	20	2	\N	9	\N	Margaritifera margaritifera
94	18435	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
95	18436	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
8	18437	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
10	18438	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
51	18439	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
2	18440	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
60	18441	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
27	18442	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
18	18443	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
36	18444	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
41	18445	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
45	18446	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
61	18447	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
21	18448	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
58	18449	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
89	18450	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
59	18451	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
54	18452	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
55	18453	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
57	18454	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
88	18455	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
25	18456	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
39	18457	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
70	18458	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
53	18459	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
56	18460	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
79	18461	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
86	18462	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
24	18463	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
40	18464	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
47	18465	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
64	18466	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
9	18467	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
12	18468	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
32	18469	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
65	18470	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
81	18471	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
82	18472	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
1	18473	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
26	18474	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
42	18475	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
73	18476	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
74	18477	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
3	18478	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
43	18479	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
11	18480	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
66	18481	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
4	18482	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
5	18483	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
79	19709	64435	20	2	\N	9	\N	Margaritifera margaritifera
6	18484	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
2B	18485	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
75	18486	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
77	18487	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
91	18488	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
93	18489	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
52	18490	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
80	18491	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
76	18492	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
28	18493	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
37	18494	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
14	18495	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
50	18496	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
71	18497	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
62	18498	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
67	18499	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
68	18500	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
90	18501	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
44	18502	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
49	18503	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
72	18504	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
85	18505	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
22	18506	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
29	18507	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
35	18508	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
16	18509	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
17	18510	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
33	18511	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
31	18512	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
46	18513	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
19	18514	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
23	18515	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
87	18516	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
7	18517	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
38	18518	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
69	18519	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
15	18520	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
63	18521	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
30	18522	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
34	18523	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
48	18524	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
13	18525	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
83	18526	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
84	18527	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
2A	18528	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis brandtii
78	18529	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
92	18530	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
94	18531	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
95	18532	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
86	19710	64435	20	2	\N	9	\N	Margaritifera margaritifera
8	18533	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
10	18534	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
51	18535	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
2	18536	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
60	18537	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
27	18538	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
18	18539	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
36	18540	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
41	18541	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
45	18542	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
61	18543	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
21	18544	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
58	18545	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
89	18546	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
59	18547	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
54	18548	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
55	18549	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
57	18550	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
88	18551	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
25	18552	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
39	18553	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
70	18554	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
53	18555	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
56	18556	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
79	18557	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
86	18558	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
24	18559	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
40	18560	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
47	18561	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
64	18562	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
9	18563	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
12	18564	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
32	18565	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
65	18566	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
81	18567	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
82	18568	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
1	18569	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
26	18570	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
42	18571	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
73	18572	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
74	18573	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
3	18574	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
43	18575	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
11	18576	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
66	18577	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
4	18578	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
5	18579	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
6	18580	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
2B	18581	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
75	18582	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
77	18583	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
91	18584	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
93	18585	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
52	18586	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
80	18587	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
76	18588	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
28	18589	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
37	18590	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
14	18591	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
50	18592	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
71	18593	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
62	18594	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
67	18595	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
68	18596	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
90	18597	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
44	18598	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
49	18599	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
72	18600	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
85	18601	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
22	18602	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
29	18603	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
35	18604	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
16	18605	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
17	18606	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
33	18607	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
31	18608	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
46	18609	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
19	18610	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
23	18611	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
87	18612	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
7	18613	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
38	18614	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
69	18615	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
15	18616	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
63	18617	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
30	18618	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
34	18619	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
48	18620	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
13	18621	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
83	18622	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
84	18623	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
2A	18624	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis bechsteinii
78	18625	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
92	18626	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
94	18627	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
95	18628	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
8	18629	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
10	18630	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
51	18631	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
2	18632	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
60	18633	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
27	18634	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
18	18635	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
36	18636	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
41	18637	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
45	18638	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
61	18639	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
21	18640	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
58	18641	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
89	18642	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
59	18643	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
54	18644	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
55	18645	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
57	18646	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
88	18647	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
25	18648	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
39	18649	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
70	18650	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
53	18651	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
56	18652	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
79	18653	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
86	18654	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
24	18655	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
40	18656	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
47	18657	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
64	18658	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
9	18659	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
12	18660	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
32	18661	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
65	18662	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
81	18663	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
82	18664	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
1	18665	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
26	18666	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
42	18667	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
73	18668	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
74	18669	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
3	18670	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
43	18671	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
11	18672	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
66	18673	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
4	18674	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
5	18675	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
6	18676	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
2B	18677	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
75	18678	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
77	18679	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
91	18680	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
93	18681	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
52	18682	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
80	18683	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
76	18684	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
28	18685	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
37	18686	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
14	18687	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
50	18688	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
71	18689	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
62	18690	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
67	18691	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
68	18692	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
90	18693	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
44	18694	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
49	18695	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
72	18696	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
85	18697	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
22	18698	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
29	18699	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
35	18700	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
16	18701	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
17	18702	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
33	18703	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
31	18704	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
46	18705	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
19	18706	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
23	18707	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
87	18708	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
7	18709	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
38	18710	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
69	18711	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
15	18712	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
63	18713	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
30	18714	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
34	18715	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
48	18716	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
13	18717	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
83	18718	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
84	18719	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
2A	18720	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis bechsteinii
78	18721	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
92	18722	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
94	18723	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
95	18724	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
8	18725	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
10	18726	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
51	18727	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
2	18728	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
60	18729	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
27	18730	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
18	18731	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
36	18732	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
41	18733	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
45	18734	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
61	18735	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
21	18736	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
58	18737	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
89	18738	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
59	18739	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
54	18740	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
55	18741	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
57	18742	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
88	18743	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
25	18744	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
39	18745	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
70	18746	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
53	18747	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
56	18748	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
79	18749	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
86	18750	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
24	18751	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
40	18752	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
47	18753	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
64	18754	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
9	18755	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
12	18756	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
32	18757	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
65	18758	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
81	18759	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
82	18760	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
1	18761	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
26	18762	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
42	18763	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
73	18764	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
74	18765	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
3	18766	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
43	18767	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
11	18768	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
66	18769	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
4	18770	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
5	18771	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
6	18772	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
2B	18773	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
75	18774	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
77	18775	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
91	18776	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
93	18777	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
52	18778	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
80	18779	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
76	18780	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
28	18781	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
37	18782	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
14	18783	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
50	18784	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
71	18785	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
62	18786	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
67	18787	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
68	18788	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
90	18789	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
44	18790	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
49	18791	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
72	18792	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
85	18793	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
22	18794	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
29	18795	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
35	18796	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
16	18797	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
17	18798	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
33	18799	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
31	18800	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
46	18801	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
19	18802	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
23	18803	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
87	18804	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
7	18805	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
38	18806	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
69	18807	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
15	18808	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
63	18809	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
30	18810	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
34	18811	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
48	18812	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
13	18813	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
83	18814	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
84	18815	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
2A	18816	79301	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis bechsteinii
8	18817	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
45	18818	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
61	18819	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
58	18820	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
55	18821	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
86	18822	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
47	18823	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
9	18824	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
26	18825	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
73	18826	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
4	18827	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
2B	18828	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
75	18829	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
93	18830	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
28	18831	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
50	18832	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
71	18833	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
72	18834	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
17	18835	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
87	18836	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
7	18837	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
48	18838	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
13	18839	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
78	18840	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
94	18841	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
95	18842	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
18	18843	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
21	18844	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
89	18845	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
59	18846	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
88	18847	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
12	18848	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
81	18849	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
82	18850	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
1	18851	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
11	18852	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
66	18853	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
77	18854	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
76	18855	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
67	18856	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
44	18857	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
49	18858	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
22	18859	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
29	18860	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
16	18861	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
33	18862	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
31	18863	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
19	18864	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
69	18865	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
63	18866	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
83	18867	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
92	18868	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
10	18869	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
51	18870	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
2	18871	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
36	18872	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
54	18873	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
25	18874	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
39	18875	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
56	18876	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
32	18877	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
42	18878	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
74	18879	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
3	18880	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
43	18881	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
5	18882	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
91	18883	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
52	18884	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
80	18885	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
37	18886	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
14	18887	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
90	18888	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
85	18889	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
46	18890	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
38	18891	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
15	18892	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
84	18893	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
60	18894	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
27	18895	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
41	18896	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
57	18897	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
70	18898	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
53	18899	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
79	18900	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
24	18901	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
40	18902	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
64	18903	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
65	18904	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
6	18905	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
62	18906	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
68	18907	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
35	18908	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
23	18909	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
30	18910	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
34	18911	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
2A	18912	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Miniopterus schreibersii
8	18913	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
45	18914	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
61	18915	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
58	18916	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
55	18917	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
86	18918	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
47	18919	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
9	18920	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
26	18921	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
73	18922	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
4	18923	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
2B	18924	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
75	18925	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
93	18926	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
28	18927	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
50	18928	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
71	18929	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
72	18930	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
17	18931	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
87	18932	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
7	18933	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
48	18934	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
13	18935	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
78	18936	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
94	18937	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
95	18938	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
18	18939	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
21	18940	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
89	18941	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
59	18942	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
88	18943	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
12	18944	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
81	18945	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
82	18946	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
1	18947	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
11	18948	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
66	18949	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
77	18950	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
76	18951	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
67	18952	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
44	18953	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
49	18954	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
22	18955	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
29	18956	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
16	18957	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
33	18958	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
31	18959	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
19	18960	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
69	18961	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
63	18962	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
83	18963	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
92	18964	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
10	18965	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
51	18966	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
2	18967	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
36	18968	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
54	18969	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
25	18970	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
39	18971	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
56	18972	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
32	18973	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
42	18974	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
74	18975	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
3	18976	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
43	18977	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
5	18978	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
91	18979	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
52	18980	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
80	18981	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
37	18982	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
14	18983	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
90	18984	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
85	18985	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
46	18986	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
38	18987	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
15	18988	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
84	18989	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
60	18990	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
27	18991	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
41	18992	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
57	18993	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
70	18994	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
53	18995	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
79	18996	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
24	18997	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
40	18998	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
64	18999	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
65	19000	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
6	19001	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
62	19002	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
68	19003	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
35	19004	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
23	19005	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
30	19006	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
34	19007	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
2A	19008	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Miniopterus schreibersii
8	19009	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
45	19010	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
61	19011	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
58	19012	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
55	19013	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
86	19014	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
47	19015	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
9	19016	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
26	19017	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
73	19018	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
4	19019	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
2B	19020	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
75	19021	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
93	19022	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
28	19023	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
50	19024	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
71	19025	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
72	19026	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
17	19027	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
87	19028	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
7	19029	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
48	19030	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
13	19031	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
78	19032	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
94	19033	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
95	19034	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
18	19035	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
21	19036	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
89	19037	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
59	19038	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
88	19039	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
12	19040	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
81	19041	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
82	19042	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
1	19043	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
11	19044	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
66	19045	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
77	19046	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
76	19047	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
67	19048	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
44	19049	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
49	19050	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
22	19051	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
29	19052	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
16	19053	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
33	19054	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
31	19055	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
19	19056	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
69	19057	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
63	19058	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
83	19059	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
92	19060	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
10	19061	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
51	19062	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
2	19063	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
36	19064	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
54	19065	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
25	19066	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
39	19067	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
56	19068	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
32	19069	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
42	19070	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
74	19071	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
3	19072	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
43	19073	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
5	19074	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
91	19075	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
52	19076	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
80	19077	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
37	19078	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
14	19079	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
90	19080	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
85	19081	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
46	19082	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
38	19083	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
15	19084	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
84	19085	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
60	19086	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
27	19087	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
41	19088	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
57	19089	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
70	19090	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
53	19091	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
79	19092	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
24	19093	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
40	19094	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
64	19095	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
65	19096	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
6	19097	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
62	19098	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
68	19099	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
35	19100	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
23	19101	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
30	19102	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
34	19103	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
2A	19104	79305	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Miniopterus schreibersii
78	19105	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
92	19106	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
94	19107	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
95	19108	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
8	19109	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
10	19110	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
51	19111	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
2	19112	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
60	19113	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
27	19114	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
18	19115	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
36	19116	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
41	19117	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
45	19118	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
61	19119	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
21	19120	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
58	19121	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
89	19122	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
59	19123	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
54	19124	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
55	19125	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
57	19126	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
88	19127	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
25	19128	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
39	19129	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
70	19130	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
53	19131	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
56	19132	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
79	19133	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
86	19134	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
24	19135	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
40	19136	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
47	19137	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
64	19138	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
9	19139	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
12	19140	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
32	19141	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
65	19142	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
81	19143	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
82	19144	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
1	19145	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
26	19146	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
42	19147	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
73	19148	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
74	19149	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
3	19150	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
43	19151	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
11	19152	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
66	19153	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
4	19154	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
5	19155	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
6	19156	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
2B	19157	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
75	19158	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
77	19159	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
91	19160	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
93	19161	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
52	19162	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
80	19163	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
76	19164	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
28	19165	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
37	19166	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
14	19167	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
50	19168	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
71	19169	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
62	19170	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
67	19171	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
68	19172	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
90	19173	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
44	19174	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
49	19175	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
72	19176	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
85	19177	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
22	19178	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
29	19179	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
35	19180	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
16	19181	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
17	19182	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
33	19183	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
31	19184	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
46	19185	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
19	19186	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
23	19187	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
87	19188	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
7	19189	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
38	19190	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
69	19191	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
15	19192	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
63	19193	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
30	19194	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
34	19195	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
48	19196	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
13	19197	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
83	19198	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
84	19199	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
2A	19200	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus macrobullaris
78	19201	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
92	19202	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
94	19203	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
95	19204	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
8	19205	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
10	19206	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
51	19207	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
2	19208	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
60	19209	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
27	19210	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
18	19211	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
36	19212	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
41	19213	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
45	19214	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
61	19215	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
21	19216	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
58	19217	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
89	19218	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
59	19219	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
54	19220	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
55	19221	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
57	19222	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
88	19223	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
25	19224	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
39	19225	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
70	19226	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
53	19227	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
56	19228	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
79	19229	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
86	19230	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
24	19231	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
40	19232	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
47	19233	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
64	19234	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
9	19235	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
12	19236	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
32	19237	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
65	19238	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
81	19239	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
82	19240	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
1	19241	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
26	19242	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
42	19243	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
73	19244	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
74	19245	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
3	19246	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
43	19247	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
11	19248	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
66	19249	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
4	19250	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
5	19251	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
6	19252	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
2B	19253	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
75	19254	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
77	19255	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
91	19256	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
93	19257	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
52	19258	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
80	19259	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
76	19260	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
28	19261	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
37	19262	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
14	19263	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
50	19264	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
71	19265	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
62	19266	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
67	19267	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
68	19268	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
90	19269	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
44	19270	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
49	19271	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
72	19272	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
85	19273	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
22	19274	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
29	19275	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
35	19276	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
16	19277	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
17	19278	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
33	19279	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
31	19280	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
46	19281	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
19	19282	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
23	19283	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
87	19284	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
7	19285	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
38	19286	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
69	19287	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
15	19288	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
63	19289	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
30	19290	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
34	19291	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
48	19292	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
13	19293	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
83	19294	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
84	19295	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
2A	19296	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus macrobullaris
78	19297	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
92	19298	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
94	19299	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
95	19300	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
8	19301	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
10	19302	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
51	19303	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
2	19304	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
60	19305	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
27	19306	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
18	19307	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
36	19308	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
41	19309	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
45	19310	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
61	19311	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
21	19312	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
58	19313	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
89	19314	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
59	19315	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
54	19316	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
55	19317	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
57	19318	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
88	19319	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
25	19320	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
39	19321	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
70	19322	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
53	19323	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
56	19324	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
79	19325	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
86	19326	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
24	19327	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
40	19328	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
47	19329	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
64	19330	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
9	19331	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
12	19332	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
32	19333	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
65	19334	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
81	19335	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
82	19336	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
1	19337	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
26	19338	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
42	19339	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
73	19340	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
74	19341	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
3	19342	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
43	19343	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
11	19344	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
66	19345	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
4	19346	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
5	19347	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
6	19348	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
2B	19349	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
75	19350	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
77	19351	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
91	19352	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
93	19353	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
52	19354	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
80	19355	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
76	19356	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
28	19357	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
37	19358	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
14	19359	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
50	19360	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
71	19361	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
62	19362	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
67	19363	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
68	19364	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
90	19365	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
44	19366	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
49	19367	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
72	19368	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
85	19369	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
22	19370	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
29	19371	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
35	19372	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
16	19373	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
17	19374	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
33	19375	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
31	19376	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
46	19377	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
19	19378	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
23	19379	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
87	19380	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
7	19381	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
38	19382	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
69	19383	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
15	19384	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
63	19385	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
30	19386	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
34	19387	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
48	19388	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
13	19389	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
83	19390	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
84	19391	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
2A	19392	163463	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus macrobullaris
78	19393	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
92	19394	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
94	19395	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
95	19396	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
8	19397	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
10	19398	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
51	19399	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
2	19400	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
60	19401	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
27	19402	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
18	19403	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
36	19404	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
41	19405	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
45	19406	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
61	19407	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
21	19408	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
58	19409	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
89	19410	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
59	19411	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
54	19412	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
55	19413	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
57	19414	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
88	19415	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
25	19416	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
39	19417	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
70	19418	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
53	19419	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
56	19420	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
79	19421	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
86	19422	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
24	19423	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
40	19424	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
47	19425	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
64	19426	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
9	19427	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
12	19428	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
32	19429	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
65	19430	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
81	19431	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
82	19432	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
1	19433	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
26	19434	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
42	19435	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
73	19436	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
74	19437	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
3	19438	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
43	19439	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
11	19440	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
66	19441	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
4	19442	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
5	19443	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
6	19444	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
2B	19445	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
75	19446	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
77	19447	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
91	19448	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
93	19449	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
52	19450	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
80	19451	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
76	19452	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
28	19453	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
37	19454	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
14	19455	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
50	19456	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
71	19457	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
62	19458	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
67	19459	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
68	19460	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
90	19461	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
44	19462	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
49	19463	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
72	19464	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
85	19465	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
22	19466	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
29	19467	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
35	19468	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
16	19469	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
17	19470	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
33	19471	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
31	19472	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
46	19473	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
19	19474	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
23	19475	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
87	19476	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
7	19477	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
38	19478	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
69	19479	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
15	19480	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
63	19481	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
30	19482	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
34	19483	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
48	19484	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
13	19485	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
83	19486	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
84	19487	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
2A	19488	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis daubentonii
78	19489	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
92	19490	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
94	19491	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
95	19492	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
8	19493	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
10	19494	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
51	19495	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
2	19496	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
60	19497	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
27	19498	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
18	19499	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
36	19500	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
41	19501	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
45	19502	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
61	19503	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
21	19504	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
58	19505	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
89	19506	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
59	19507	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
54	19508	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
55	19509	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
57	19510	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
88	19511	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
25	19512	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
39	19513	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
70	19514	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
53	19515	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
56	19516	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
79	19517	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
86	19518	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
24	19519	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
40	19520	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
47	19521	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
64	19522	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
9	19523	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
12	19524	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
32	19525	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
65	19526	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
81	19527	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
82	19528	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
1	19529	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
26	19530	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
42	19531	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
73	19532	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
74	19533	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
3	19534	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
43	19535	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
11	19536	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
66	19537	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
4	19538	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
5	19539	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
6	19540	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
2B	19541	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
75	19542	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
77	19543	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
91	19544	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
93	19545	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
52	19546	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
80	19547	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
76	19548	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
28	19549	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
37	19550	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
14	19551	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
50	19552	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
71	19553	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
62	19554	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
67	19555	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
68	19556	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
90	19557	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
44	19558	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
49	19559	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
72	19560	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
85	19561	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
22	19562	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
29	19563	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
35	19564	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
16	19565	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
17	19566	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
33	19567	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
31	19568	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
46	19569	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
19	19570	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
23	19571	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
87	19572	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
7	19573	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
38	19574	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
69	19575	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
15	19576	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
63	19577	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
30	19578	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
34	19579	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
48	19580	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
13	19581	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
83	19582	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
84	19583	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
2A	19584	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis daubentonii
78	19585	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
92	19586	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
94	19587	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
95	19588	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
8	19589	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
10	19590	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
51	19591	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
2	19592	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
60	19593	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
27	19594	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
18	19595	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
36	19596	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
41	19597	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
45	19598	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
61	19599	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
21	19600	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
58	19601	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
89	19602	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
59	19603	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
54	19604	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
55	19605	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
57	19606	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
88	19607	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
25	19608	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
39	19609	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
70	19610	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
53	19611	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
56	19612	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
79	19613	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
86	19614	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
24	19615	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
40	19616	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
47	19617	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
64	19618	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
9	19619	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
12	19620	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
32	19621	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
65	19622	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
81	19623	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
82	19624	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
1	19625	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
26	19626	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
42	19627	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
73	19628	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
74	19629	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
3	19630	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
43	19631	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
11	19632	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
66	19633	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
4	19634	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
5	19635	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
6	19636	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
2B	19637	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
75	19638	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
77	19639	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
91	19640	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
93	19641	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
52	19642	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
80	19643	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
76	19644	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
28	19645	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
37	19646	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
14	19647	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
50	19648	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
71	19649	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
62	19650	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
67	19651	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
68	19652	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
90	19653	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
44	19654	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
49	19655	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
72	19656	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
85	19657	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
22	19658	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
29	19659	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
35	19660	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
16	19661	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
17	19662	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
33	19663	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
31	19664	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
46	19665	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
19	19666	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
23	19667	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
87	19668	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
7	19669	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
38	19670	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
69	19671	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
15	19672	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
63	19673	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
30	19674	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
34	19675	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
48	19676	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
13	19677	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
83	19678	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
84	19679	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
2A	19680	200118	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis daubentonii
78	19681	64435	20	2	\N	9	\N	Margaritifera margaritifera
92	19682	64435	20	2	\N	9	\N	Margaritifera margaritifera
94	19683	64435	20	2	\N	9	\N	Margaritifera margaritifera
95	19684	64435	20	2	\N	9	\N	Margaritifera margaritifera
8	19685	64435	20	2	\N	9	\N	Margaritifera margaritifera
10	19686	64435	20	2	\N	9	\N	Margaritifera margaritifera
51	19687	64435	20	2	\N	9	\N	Margaritifera margaritifera
2	19688	64435	20	2	\N	9	\N	Margaritifera margaritifera
60	19689	64435	20	2	\N	9	\N	Margaritifera margaritifera
27	19690	64435	20	2	\N	9	\N	Margaritifera margaritifera
18	19691	64435	20	2	\N	9	\N	Margaritifera margaritifera
36	19692	64435	20	2	\N	9	\N	Margaritifera margaritifera
41	19693	64435	20	2	\N	9	\N	Margaritifera margaritifera
45	19694	64435	20	2	\N	9	\N	Margaritifera margaritifera
61	19695	64435	20	2	\N	9	\N	Margaritifera margaritifera
21	19696	64435	20	2	\N	9	\N	Margaritifera margaritifera
58	19697	64435	20	2	\N	9	\N	Margaritifera margaritifera
89	19698	64435	20	2	\N	9	\N	Margaritifera margaritifera
59	19699	64435	20	2	\N	9	\N	Margaritifera margaritifera
54	19700	64435	20	2	\N	9	\N	Margaritifera margaritifera
55	19701	64435	20	2	\N	9	\N	Margaritifera margaritifera
57	19702	64435	20	2	\N	9	\N	Margaritifera margaritifera
88	19703	64435	20	2	\N	9	\N	Margaritifera margaritifera
25	19704	64435	20	2	\N	9	\N	Margaritifera margaritifera
39	19705	64435	20	2	\N	9	\N	Margaritifera margaritifera
70	19706	64435	20	2	\N	9	\N	Margaritifera margaritifera
53	19707	64435	20	2	\N	9	\N	Margaritifera margaritifera
24	19711	64435	20	2	\N	9	\N	Margaritifera margaritifera
40	19712	64435	20	2	\N	9	\N	Margaritifera margaritifera
47	19713	64435	20	2	\N	9	\N	Margaritifera margaritifera
64	19714	64435	20	2	\N	9	\N	Margaritifera margaritifera
9	19715	64435	20	2	\N	9	\N	Margaritifera margaritifera
12	19716	64435	20	2	\N	9	\N	Margaritifera margaritifera
32	19717	64435	20	2	\N	9	\N	Margaritifera margaritifera
65	19718	64435	20	2	\N	9	\N	Margaritifera margaritifera
81	19719	64435	20	2	\N	9	\N	Margaritifera margaritifera
82	19720	64435	20	2	\N	9	\N	Margaritifera margaritifera
1	19721	64435	20	2	\N	9	\N	Margaritifera margaritifera
26	19722	64435	20	2	\N	9	\N	Margaritifera margaritifera
42	19723	64435	20	2	\N	9	\N	Margaritifera margaritifera
73	19724	64435	20	2	\N	9	\N	Margaritifera margaritifera
74	19725	64435	20	2	\N	9	\N	Margaritifera margaritifera
3	19726	64435	20	2	\N	9	\N	Margaritifera margaritifera
43	19727	64435	20	2	\N	9	\N	Margaritifera margaritifera
11	19728	64435	20	2	\N	9	\N	Margaritifera margaritifera
66	19729	64435	20	2	\N	9	\N	Margaritifera margaritifera
4	19730	64435	20	2	\N	9	\N	Margaritifera margaritifera
5	19731	64435	20	2	\N	9	\N	Margaritifera margaritifera
6	19732	64435	20	2	\N	9	\N	Margaritifera margaritifera
2B	19733	64435	20	2	\N	9	\N	Margaritifera margaritifera
75	19734	64435	20	2	\N	9	\N	Margaritifera margaritifera
77	19735	64435	20	2	\N	9	\N	Margaritifera margaritifera
91	19736	64435	20	2	\N	9	\N	Margaritifera margaritifera
93	19737	64435	20	2	\N	9	\N	Margaritifera margaritifera
52	19738	64435	20	2	\N	9	\N	Margaritifera margaritifera
80	19739	64435	20	2	\N	9	\N	Margaritifera margaritifera
76	19740	64435	20	2	\N	9	\N	Margaritifera margaritifera
28	19741	64435	20	2	\N	9	\N	Margaritifera margaritifera
37	19742	64435	20	2	\N	9	\N	Margaritifera margaritifera
14	19743	64435	20	2	\N	9	\N	Margaritifera margaritifera
50	19744	64435	20	2	\N	9	\N	Margaritifera margaritifera
71	19745	64435	20	2	\N	9	\N	Margaritifera margaritifera
62	19746	64435	20	2	\N	9	\N	Margaritifera margaritifera
67	19747	64435	20	2	\N	9	\N	Margaritifera margaritifera
68	19748	64435	20	2	\N	9	\N	Margaritifera margaritifera
90	19749	64435	20	2	\N	9	\N	Margaritifera margaritifera
44	19750	64435	20	2	\N	9	\N	Margaritifera margaritifera
49	19751	64435	20	2	\N	9	\N	Margaritifera margaritifera
72	19752	64435	20	2	\N	9	\N	Margaritifera margaritifera
85	19753	64435	20	2	\N	9	\N	Margaritifera margaritifera
22	19754	64435	20	2	\N	9	\N	Margaritifera margaritifera
29	19755	64435	20	2	\N	9	\N	Margaritifera margaritifera
35	19756	64435	20	2	\N	9	\N	Margaritifera margaritifera
16	19757	64435	20	2	\N	9	\N	Margaritifera margaritifera
17	19758	64435	20	2	\N	9	\N	Margaritifera margaritifera
33	19759	64435	20	2	\N	9	\N	Margaritifera margaritifera
31	19760	64435	20	2	\N	9	\N	Margaritifera margaritifera
46	19761	64435	20	2	\N	9	\N	Margaritifera margaritifera
19	19762	64435	20	2	\N	9	\N	Margaritifera margaritifera
23	19763	64435	20	2	\N	9	\N	Margaritifera margaritifera
87	19764	64435	20	2	\N	9	\N	Margaritifera margaritifera
7	19765	64435	20	2	\N	9	\N	Margaritifera margaritifera
38	19766	64435	20	2	\N	9	\N	Margaritifera margaritifera
69	19767	64435	20	2	\N	9	\N	Margaritifera margaritifera
15	19768	64435	20	2	\N	9	\N	Margaritifera margaritifera
63	19769	64435	20	2	\N	9	\N	Margaritifera margaritifera
30	19770	64435	20	2	\N	9	\N	Margaritifera margaritifera
34	19771	64435	20	2	\N	9	\N	Margaritifera margaritifera
48	19772	64435	20	2	\N	9	\N	Margaritifera margaritifera
13	19773	64435	20	2	\N	9	\N	Margaritifera margaritifera
83	19774	64435	20	2	\N	9	\N	Margaritifera margaritifera
84	19775	64435	20	2	\N	9	\N	Margaritifera margaritifera
2A	19776	64435	20	2	\N	9	\N	Margaritifera margaritifera
78	19777	64437	20	2	\N	9	\N	Margaritifera auricularia
92	19778	64437	20	2	\N	9	\N	Margaritifera auricularia
94	19779	64437	20	2	\N	9	\N	Margaritifera auricularia
95	19780	64437	20	2	\N	9	\N	Margaritifera auricularia
8	19781	64437	20	2	\N	9	\N	Margaritifera auricularia
10	19782	64437	20	2	\N	9	\N	Margaritifera auricularia
51	19783	64437	20	2	\N	9	\N	Margaritifera auricularia
2	19784	64437	20	2	\N	9	\N	Margaritifera auricularia
60	19785	64437	20	2	\N	9	\N	Margaritifera auricularia
27	19786	64437	20	2	\N	9	\N	Margaritifera auricularia
18	19787	64437	20	2	\N	9	\N	Margaritifera auricularia
36	19788	64437	20	2	\N	9	\N	Margaritifera auricularia
41	19789	64437	20	2	\N	9	\N	Margaritifera auricularia
45	19790	64437	20	2	\N	9	\N	Margaritifera auricularia
61	19791	64437	20	2	\N	9	\N	Margaritifera auricularia
21	19792	64437	20	2	\N	9	\N	Margaritifera auricularia
58	19793	64437	20	2	\N	9	\N	Margaritifera auricularia
89	19794	64437	20	2	\N	9	\N	Margaritifera auricularia
59	19795	64437	20	2	\N	9	\N	Margaritifera auricularia
54	19796	64437	20	2	\N	9	\N	Margaritifera auricularia
55	19797	64437	20	2	\N	9	\N	Margaritifera auricularia
57	19798	64437	20	2	\N	9	\N	Margaritifera auricularia
88	19799	64437	20	2	\N	9	\N	Margaritifera auricularia
25	19800	64437	20	2	\N	9	\N	Margaritifera auricularia
39	19801	64437	20	2	\N	9	\N	Margaritifera auricularia
70	19802	64437	20	2	\N	9	\N	Margaritifera auricularia
53	19803	64437	20	2	\N	9	\N	Margaritifera auricularia
56	19804	64437	20	2	\N	9	\N	Margaritifera auricularia
79	19805	64437	20	2	\N	9	\N	Margaritifera auricularia
86	19806	64437	20	2	\N	9	\N	Margaritifera auricularia
24	19807	64437	20	2	\N	9	\N	Margaritifera auricularia
40	19808	64437	20	2	\N	9	\N	Margaritifera auricularia
47	19809	64437	20	2	\N	9	\N	Margaritifera auricularia
64	19810	64437	20	2	\N	9	\N	Margaritifera auricularia
9	19811	64437	20	2	\N	9	\N	Margaritifera auricularia
12	19812	64437	20	2	\N	9	\N	Margaritifera auricularia
32	19813	64437	20	2	\N	9	\N	Margaritifera auricularia
65	19814	64437	20	2	\N	9	\N	Margaritifera auricularia
81	19815	64437	20	2	\N	9	\N	Margaritifera auricularia
82	19816	64437	20	2	\N	9	\N	Margaritifera auricularia
1	19817	64437	20	2	\N	9	\N	Margaritifera auricularia
26	19818	64437	20	2	\N	9	\N	Margaritifera auricularia
42	19819	64437	20	2	\N	9	\N	Margaritifera auricularia
73	19820	64437	20	2	\N	9	\N	Margaritifera auricularia
74	19821	64437	20	2	\N	9	\N	Margaritifera auricularia
3	19822	64437	20	2	\N	9	\N	Margaritifera auricularia
43	19823	64437	20	2	\N	9	\N	Margaritifera auricularia
11	19824	64437	20	2	\N	9	\N	Margaritifera auricularia
66	19825	64437	20	2	\N	9	\N	Margaritifera auricularia
4	19826	64437	20	2	\N	9	\N	Margaritifera auricularia
5	19827	64437	20	2	\N	9	\N	Margaritifera auricularia
6	19828	64437	20	2	\N	9	\N	Margaritifera auricularia
2B	19829	64437	20	2	\N	9	\N	Margaritifera auricularia
75	19830	64437	20	2	\N	9	\N	Margaritifera auricularia
77	19831	64437	20	2	\N	9	\N	Margaritifera auricularia
91	19832	64437	20	2	\N	9	\N	Margaritifera auricularia
93	19833	64437	20	2	\N	9	\N	Margaritifera auricularia
52	19834	64437	20	2	\N	9	\N	Margaritifera auricularia
80	19835	64437	20	2	\N	9	\N	Margaritifera auricularia
76	19836	64437	20	2	\N	9	\N	Margaritifera auricularia
28	19837	64437	20	2	\N	9	\N	Margaritifera auricularia
37	19838	64437	20	2	\N	9	\N	Margaritifera auricularia
14	19839	64437	20	2	\N	9	\N	Margaritifera auricularia
50	19840	64437	20	2	\N	9	\N	Margaritifera auricularia
71	19841	64437	20	2	\N	9	\N	Margaritifera auricularia
62	19842	64437	20	2	\N	9	\N	Margaritifera auricularia
67	19843	64437	20	2	\N	9	\N	Margaritifera auricularia
68	19844	64437	20	2	\N	9	\N	Margaritifera auricularia
90	19845	64437	20	2	\N	9	\N	Margaritifera auricularia
44	19846	64437	20	2	\N	9	\N	Margaritifera auricularia
49	19847	64437	20	2	\N	9	\N	Margaritifera auricularia
72	19848	64437	20	2	\N	9	\N	Margaritifera auricularia
85	19849	64437	20	2	\N	9	\N	Margaritifera auricularia
22	19850	64437	20	2	\N	9	\N	Margaritifera auricularia
29	19851	64437	20	2	\N	9	\N	Margaritifera auricularia
35	19852	64437	20	2	\N	9	\N	Margaritifera auricularia
16	19853	64437	20	2	\N	9	\N	Margaritifera auricularia
17	19854	64437	20	2	\N	9	\N	Margaritifera auricularia
33	19855	64437	20	2	\N	9	\N	Margaritifera auricularia
31	19856	64437	20	2	\N	9	\N	Margaritifera auricularia
46	19857	64437	20	2	\N	9	\N	Margaritifera auricularia
19	19858	64437	20	2	\N	9	\N	Margaritifera auricularia
23	19859	64437	20	2	\N	9	\N	Margaritifera auricularia
87	19860	64437	20	2	\N	9	\N	Margaritifera auricularia
7	19861	64437	20	2	\N	9	\N	Margaritifera auricularia
38	19862	64437	20	2	\N	9	\N	Margaritifera auricularia
69	19863	64437	20	2	\N	9	\N	Margaritifera auricularia
15	19864	64437	20	2	\N	9	\N	Margaritifera auricularia
63	19865	64437	20	2	\N	9	\N	Margaritifera auricularia
30	19866	64437	20	2	\N	9	\N	Margaritifera auricularia
34	19867	64437	20	2	\N	9	\N	Margaritifera auricularia
48	19868	64437	20	2	\N	9	\N	Margaritifera auricularia
13	19869	64437	20	2	\N	9	\N	Margaritifera auricularia
83	19870	64437	20	2	\N	9	\N	Margaritifera auricularia
84	19871	64437	20	2	\N	9	\N	Margaritifera auricularia
2A	19872	64437	20	2	\N	9	\N	Margaritifera auricularia
78	19873	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
92	19874	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
94	19875	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
95	19876	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
8	19877	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
10	19878	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
51	19879	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
2	19880	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
60	19881	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
27	19882	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
18	19883	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
36	19884	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
41	19885	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
45	19886	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
61	19887	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
21	19888	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
58	19889	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
89	19890	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
59	19891	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
54	19892	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
55	19893	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
57	19894	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
88	19895	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
25	19896	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
39	19897	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
70	19898	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
53	19899	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
56	19900	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
79	19901	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
86	19902	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
24	19903	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
40	19904	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
47	19905	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
64	19906	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
9	19907	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
12	19908	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
32	19909	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
65	19910	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
81	19911	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
82	19912	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
1	19913	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
26	19914	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
42	19915	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
73	19916	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
74	19917	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
3	19918	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
43	19919	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
11	19920	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
66	19921	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
4	19922	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
5	19923	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
6	19924	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
2B	19925	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
75	19926	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
77	19927	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
91	19928	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
93	19929	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
52	19930	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
80	19931	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
76	19932	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
28	19933	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
37	19934	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
14	19935	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
50	19936	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
71	19937	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
62	19938	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
67	19939	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
68	19940	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
90	19941	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
44	19942	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
49	19943	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
72	19944	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
85	19945	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
22	19946	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
29	19947	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
35	19948	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
16	19949	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
17	19950	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
33	19951	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
31	19952	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
46	19953	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
19	19954	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
23	19955	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
87	19956	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
7	19957	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
38	19958	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
69	19959	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
15	19960	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
63	19961	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
30	19962	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
34	19963	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
48	19964	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
13	19965	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
83	19966	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
84	19967	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
2A	19968	286	10	2	uniquement si observation de nidification	9	3	Hyla africana
78	19969	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
92	19970	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
94	19971	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
95	19972	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
8	19973	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
10	19974	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
51	19975	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
2	19976	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
60	19977	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
27	19978	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
18	19979	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
36	19980	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
41	19981	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
45	19982	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
61	19983	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
21	19984	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
58	19985	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
89	19986	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
59	19987	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
54	19988	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
55	19989	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
57	19990	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
88	19991	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
25	19992	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
39	19993	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
70	19994	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
53	19995	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
56	19996	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
79	19997	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
86	19998	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
24	19999	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
40	20000	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
47	20001	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
64	20002	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
9	20003	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
12	20004	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
32	20005	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
65	20006	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
81	20007	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
82	20008	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
1	20009	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
26	20010	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
42	20011	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
73	20012	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
74	20013	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
3	20014	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
43	20015	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
11	20016	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
66	20017	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
4	20018	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
5	20019	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
92	20738	94041	\N	1	\N	9	\N	Cypripedium calceolus
6	20020	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
2B	20021	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
75	20022	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
77	20023	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
91	20024	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
93	20025	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
52	20026	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
80	20027	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
76	20028	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
28	20029	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
37	20030	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
14	20031	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
50	20032	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
71	20033	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
62	20034	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
67	20035	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
68	20036	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
90	20037	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
44	20038	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
49	20039	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
72	20040	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
85	20041	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
22	20042	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
29	20043	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
35	20044	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
16	20045	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
17	20046	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
33	20047	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
31	20048	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
46	20049	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
19	20050	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
23	20051	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
87	20052	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
7	20053	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
38	20054	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
69	20055	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
15	20056	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
63	20057	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
30	20058	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
34	20059	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
48	20060	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
13	20061	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
83	20062	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
84	20063	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
2A	20064	2514	10	3	uniquement si observation de nidification 	9	3	Ciconia nigra
78	20065	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
92	20066	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
94	20067	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
95	20068	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
8	20069	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
10	20070	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
51	20071	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
2	20072	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
60	20073	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
27	20074	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
18	20075	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
36	20076	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
41	20077	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
45	20078	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
61	20079	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
21	20080	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
58	20081	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
89	20082	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
59	20083	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
54	20084	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
94	20739	94041	\N	1	\N	9	\N	Cypripedium calceolus
55	20085	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
57	20086	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
88	20087	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
25	20088	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
39	20089	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
70	20090	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
53	20091	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
56	20092	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
79	20093	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
86	20094	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
24	20095	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
40	20096	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
47	20097	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
64	20098	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
9	20099	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
12	20100	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
32	20101	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
65	20102	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
81	20103	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
82	20104	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
1	20105	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
26	20106	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
42	20107	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
73	20108	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
74	20109	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
3	20110	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
43	20111	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
11	20112	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
66	20113	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
4	20114	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
5	20115	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
6	20116	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
2B	20117	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
75	20118	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
77	20119	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
91	20120	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
93	20121	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
52	20122	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
80	20123	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
76	20124	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
28	20125	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
37	20126	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
14	20127	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
50	20128	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
71	20129	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
62	20130	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
67	20131	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
68	20132	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
90	20133	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
44	20134	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
49	20135	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
72	20136	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
85	20137	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
22	20138	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
29	20139	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
35	20140	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
16	20141	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
17	20142	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
33	20143	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
31	20144	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
46	20145	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
19	20146	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
23	20147	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
87	20148	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
7	20149	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
95	20740	94041	\N	1	\N	9	\N	Cypripedium calceolus
38	20150	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
69	20151	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
15	20152	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
63	20153	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
30	20154	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
34	20155	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
48	20156	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
13	20157	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
83	20158	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
84	20159	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
2A	20160	2636	10	3	uniquement si observation de nidification 	9	3	Aquila pomarina
78	20161	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
92	20162	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
94	20163	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
95	20164	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
8	20165	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
10	20166	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
51	20167	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
2	20168	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
60	20169	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
27	20170	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
18	20171	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
36	20172	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
41	20173	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
45	20174	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
61	20175	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
21	20176	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
58	20177	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
89	20178	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
59	20179	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
54	20180	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
55	20181	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
57	20182	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
88	20183	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
25	20184	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
39	20185	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
70	20186	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
53	20187	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
56	20188	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
79	20189	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
86	20190	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
24	20191	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
40	20192	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
47	20193	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
64	20194	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
9	20195	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
12	20196	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
32	20197	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
65	20198	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
81	20199	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
82	20200	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
1	20201	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
26	20202	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
42	20203	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
73	20204	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
74	20205	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
3	20206	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
43	20207	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
11	20208	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
66	20209	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
4	20210	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
5	20211	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
6	20212	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
2B	20213	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
75	20214	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
77	20215	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
91	20216	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
93	20217	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
52	20218	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
80	20219	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
76	20220	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
28	20221	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
37	20222	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
14	20223	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
50	20224	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
71	20225	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
62	20226	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
67	20227	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
68	20228	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
90	20229	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
44	20230	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
49	20231	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
72	20232	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
85	20233	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
22	20234	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
29	20235	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
35	20236	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
16	20237	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
17	20238	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
33	20239	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
31	20240	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
46	20241	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
19	20242	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
23	20243	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
87	20244	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
7	20245	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
38	20246	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
69	20247	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
15	20248	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
63	20249	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
30	20250	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
34	20251	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
48	20252	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
13	20253	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
83	20254	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
84	20255	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
2A	20256	2655	10	3	uniquement si observation de nidification 	9	3	Hieraaetus fasciatus
78	20257	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
92	20258	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
94	20259	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
95	20260	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
8	20261	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
10	20262	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
51	20263	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
2	20264	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
60	20265	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
27	20266	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
18	20267	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
36	20268	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
41	20269	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
45	20270	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
61	20271	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
21	20272	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
8	20741	94041	\N	1	\N	9	\N	Cypripedium calceolus
58	20273	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
89	20274	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
59	20275	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
54	20276	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
55	20277	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
57	20278	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
88	20279	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
25	20280	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
39	20281	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
70	20282	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
53	20283	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
56	20284	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
79	20285	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
86	20286	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
24	20287	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
40	20288	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
47	20289	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
64	20290	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
9	20291	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
12	20292	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
32	20293	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
65	20294	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
81	20295	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
82	20296	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
1	20297	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
26	20298	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
42	20299	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
73	20300	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
74	20301	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
3	20302	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
43	20303	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
11	20304	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
66	20305	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
4	20306	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
5	20307	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
6	20308	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
2B	20309	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
75	20310	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
77	20311	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
91	20312	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
93	20313	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
52	20314	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
80	20315	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
76	20316	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
28	20317	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
37	20318	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
14	20319	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
50	20320	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
71	20321	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
62	20322	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
67	20323	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
68	20324	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
90	20325	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
44	20326	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
49	20327	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
72	20328	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
85	20329	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
22	20330	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
29	20331	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
35	20332	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
16	20333	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
10	20742	94041	\N	1	\N	9	\N	Cypripedium calceolus
17	20334	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
33	20335	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
31	20336	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
46	20337	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
19	20338	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
23	20339	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
87	20340	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
7	20341	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
38	20342	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
69	20343	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
15	20344	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
63	20345	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
30	20346	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
34	20347	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
48	20348	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
13	20349	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
83	20350	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
84	20351	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
2A	20352	2848	10	3	uniquement si observation de nidification 	9	3	Haliaeetus albicilla
78	20353	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
92	20354	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
94	20355	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
95	20356	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
8	20357	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
10	20358	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
51	20359	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
2	20360	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
60	20361	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
27	20362	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
18	20363	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
36	20364	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
41	20365	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
45	20366	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
61	20367	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
21	20368	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
58	20369	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
89	20370	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
59	20371	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
54	20372	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
55	20373	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
57	20374	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
88	20375	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
25	20376	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
39	20377	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
70	20378	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
53	20379	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
56	20380	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
79	20381	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
86	20382	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
24	20383	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
40	20384	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
47	20385	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
64	20386	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
9	20387	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
12	20388	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
32	20389	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
65	20390	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
81	20391	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
82	20392	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
1	20393	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
26	20394	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
42	20395	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
73	20396	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
74	20397	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
3	20398	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
43	20399	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
11	20400	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
66	20401	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
4	20402	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
5	20403	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
6	20404	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
2B	20405	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
75	20406	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
77	20407	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
91	20408	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
93	20409	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
52	20410	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
80	20411	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
76	20412	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
28	20413	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
37	20414	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
14	20415	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
50	20416	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
71	20417	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
62	20418	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
67	20419	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
68	20420	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
90	20421	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
44	20422	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
49	20423	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
72	20424	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
85	20425	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
22	20426	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
29	20427	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
35	20428	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
16	20429	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
17	20430	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
33	20431	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
31	20432	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
46	20433	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
19	20434	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
23	20435	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
87	20436	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
7	20437	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
38	20438	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
69	20439	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
15	20440	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
63	20441	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
30	20442	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
34	20443	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
48	20444	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
13	20445	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
83	20446	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
84	20447	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
2A	20448	2852	10	2	uniquement si observation de nidification ?	9	3	Gypaetus barbatus
8	20449	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
45	20450	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
61	20451	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
58	20452	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
55	20453	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
86	20454	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
47	20455	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
9	20456	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
26	20457	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
73	20458	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
4	20459	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
2B	20460	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
75	20461	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
93	20462	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
28	20463	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
50	20464	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
71	20465	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
72	20466	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
17	20467	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
87	20468	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
7	20469	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
48	20470	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
13	20471	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
78	20472	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
94	20473	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
95	20474	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
18	20475	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
21	20476	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
89	20477	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
59	20478	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
88	20479	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
12	20480	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
81	20481	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
82	20482	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
1	20483	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
11	20484	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
66	20485	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
77	20486	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
76	20487	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
67	20488	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
44	20489	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
49	20490	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
22	20491	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
29	20492	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
16	20493	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
33	20494	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
31	20495	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
19	20496	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
69	20497	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
63	20498	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
83	20499	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
92	20500	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
10	20501	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
51	20502	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
2	20503	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
36	20504	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
54	20505	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
25	20506	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
39	20507	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
56	20508	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
32	20509	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
42	20510	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
74	20511	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
3	20512	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
43	20513	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
5	20514	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
91	20515	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
52	20516	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
80	20517	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
37	20518	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
14	20519	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
90	20520	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
85	20521	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
46	20522	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
38	20523	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
15	20524	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
84	20525	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
60	20526	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
27	20527	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
41	20528	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
57	20529	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
70	20530	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
53	20531	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
79	20532	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
24	20533	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
40	20534	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
64	20535	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
65	20536	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
6	20537	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
62	20538	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
68	20539	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
35	20540	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
23	20541	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
30	20542	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
34	20543	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
2A	20544	2964	20	1	Place de chant, lek.	9	3	Tetrao urogallus
8	20545	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
45	20546	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
61	20547	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
58	20548	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
55	20549	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
86	20550	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
47	20551	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
9	20552	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
26	20553	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
73	20554	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
4	20555	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
2B	20556	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
75	20557	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
93	20558	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
28	20559	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
50	20560	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
71	20561	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
72	20562	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
17	20563	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
87	20564	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
7	20565	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
48	20566	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
13	20567	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
78	20568	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
94	20569	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
95	20570	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
18	20571	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
21	20572	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
89	20573	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
59	20574	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
88	20575	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
12	20576	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
81	20577	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
82	20578	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
1	20579	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
11	20580	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
66	20581	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
77	20582	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
76	20583	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
67	20584	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
44	20585	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
49	20586	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
22	20587	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
29	20588	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
16	20589	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
33	20590	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
31	20591	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
19	20592	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
69	20593	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
63	20594	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
83	20595	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
92	20596	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
10	20597	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
51	20598	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
2	20599	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
36	20600	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
54	20601	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
25	20602	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
39	20603	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
56	20604	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
32	20605	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
42	20606	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
74	20607	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
3	20608	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
43	20609	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
5	20610	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
91	20611	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
52	20612	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
80	20613	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
37	20614	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
14	20615	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
90	20616	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
85	20617	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
46	20618	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
38	20619	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
15	20620	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
84	20621	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
60	20622	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
27	20623	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
41	20624	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
57	20625	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
70	20626	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
53	20627	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
79	20628	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
24	20629	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
40	20630	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
64	20631	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
65	20632	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
6	20633	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
62	20634	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
68	20635	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
35	20636	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
23	20637	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
30	20638	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
34	20639	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
2A	20640	3076	10	3	uniquement si observation de nidification 	9	3	Grus grus
8	20641	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
45	20642	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
61	20643	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
58	20644	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
55	20645	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
86	20646	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
47	20647	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
9	20648	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
26	20649	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
73	20650	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
4	20651	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
2B	20652	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
75	20653	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
93	20654	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
28	20655	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
50	20656	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
71	20657	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
72	20658	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
17	20659	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
87	20660	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
7	20661	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
48	20662	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
13	20663	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
78	20664	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
94	20665	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
95	20666	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
18	20667	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
21	20668	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
89	20669	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
59	20670	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
88	20671	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
12	20672	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
81	20673	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
82	20674	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
1	20675	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
11	20676	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
66	20677	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
77	20678	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
76	20679	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
67	20680	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
44	20681	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
49	20682	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
22	20683	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
29	20684	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
16	20685	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
33	20686	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
31	20687	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
19	20688	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
69	20689	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
63	20690	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
83	20691	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
92	20692	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
10	20693	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
51	20694	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
2	20695	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
36	20696	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
54	20697	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
25	20698	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
39	20699	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
56	20700	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
32	20701	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
42	20702	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
74	20703	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
3	20704	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
43	20705	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
5	20706	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
91	20707	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
52	20708	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
80	20709	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
37	20710	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
14	20711	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
90	20712	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
85	20713	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
46	20714	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
38	20715	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
15	20716	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
84	20717	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
60	20718	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
27	20719	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
41	20720	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
57	20721	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
70	20722	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
53	20723	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
79	20724	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
24	20725	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
40	20726	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
64	20727	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
65	20728	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
6	20729	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
62	20730	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
68	20731	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
35	20732	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
23	20733	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
30	20734	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
34	20735	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
2A	20736	3638	1	1	uniquement si observation de nidification 	9	3	Picoides tridactylus
78	20737	94041	\N	1	\N	9	\N	Cypripedium calceolus
51	20743	94041	\N	1	\N	9	\N	Cypripedium calceolus
2	20744	94041	\N	1	\N	9	\N	Cypripedium calceolus
60	20745	94041	\N	1	\N	9	\N	Cypripedium calceolus
27	20746	94041	\N	1	\N	9	\N	Cypripedium calceolus
18	20747	94041	\N	1	\N	9	\N	Cypripedium calceolus
36	20748	94041	\N	1	\N	9	\N	Cypripedium calceolus
41	20749	94041	\N	1	\N	9	\N	Cypripedium calceolus
45	20750	94041	\N	1	\N	9	\N	Cypripedium calceolus
61	20751	94041	\N	1	\N	9	\N	Cypripedium calceolus
21	20752	94041	\N	1	\N	9	\N	Cypripedium calceolus
58	20753	94041	\N	1	\N	9	\N	Cypripedium calceolus
89	20754	94041	\N	1	\N	9	\N	Cypripedium calceolus
59	20755	94041	\N	1	\N	9	\N	Cypripedium calceolus
54	20756	94041	\N	1	\N	9	\N	Cypripedium calceolus
55	20757	94041	\N	1	\N	9	\N	Cypripedium calceolus
57	20758	94041	\N	1	\N	9	\N	Cypripedium calceolus
88	20759	94041	\N	1	\N	9	\N	Cypripedium calceolus
25	20760	94041	\N	1	\N	9	\N	Cypripedium calceolus
39	20761	94041	\N	1	\N	9	\N	Cypripedium calceolus
70	20762	94041	\N	1	\N	9	\N	Cypripedium calceolus
53	20763	94041	\N	1	\N	9	\N	Cypripedium calceolus
56	20764	94041	\N	1	\N	9	\N	Cypripedium calceolus
79	20765	94041	\N	1	\N	9	\N	Cypripedium calceolus
86	20766	94041	\N	1	\N	9	\N	Cypripedium calceolus
24	20767	94041	\N	1	\N	9	\N	Cypripedium calceolus
40	20768	94041	\N	1	\N	9	\N	Cypripedium calceolus
47	20769	94041	\N	1	\N	9	\N	Cypripedium calceolus
64	20770	94041	\N	1	\N	9	\N	Cypripedium calceolus
9	20771	94041	\N	1	\N	9	\N	Cypripedium calceolus
12	20772	94041	\N	1	\N	9	\N	Cypripedium calceolus
32	20773	94041	\N	1	\N	9	\N	Cypripedium calceolus
65	20774	94041	\N	1	\N	9	\N	Cypripedium calceolus
81	20775	94041	\N	1	\N	9	\N	Cypripedium calceolus
82	20776	94041	\N	1	\N	9	\N	Cypripedium calceolus
1	20777	94041	\N	1	\N	9	\N	Cypripedium calceolus
26	20778	94041	\N	1	\N	9	\N	Cypripedium calceolus
42	20779	94041	\N	1	\N	9	\N	Cypripedium calceolus
73	20780	94041	\N	1	\N	9	\N	Cypripedium calceolus
74	20781	94041	\N	1	\N	9	\N	Cypripedium calceolus
3	20782	94041	\N	1	\N	9	\N	Cypripedium calceolus
43	20783	94041	\N	1	\N	9	\N	Cypripedium calceolus
11	20784	94041	\N	1	\N	9	\N	Cypripedium calceolus
66	20785	94041	\N	1	\N	9	\N	Cypripedium calceolus
4	20786	94041	\N	1	\N	9	\N	Cypripedium calceolus
5	20787	94041	\N	1	\N	9	\N	Cypripedium calceolus
6	20788	94041	\N	1	\N	9	\N	Cypripedium calceolus
2B	20789	94041	\N	1	\N	9	\N	Cypripedium calceolus
75	20790	94041	\N	1	\N	9	\N	Cypripedium calceolus
77	20791	94041	\N	1	\N	9	\N	Cypripedium calceolus
91	20792	94041	\N	1	\N	9	\N	Cypripedium calceolus
93	20793	94041	\N	1	\N	9	\N	Cypripedium calceolus
52	20794	94041	\N	1	\N	9	\N	Cypripedium calceolus
80	20795	94041	\N	1	\N	9	\N	Cypripedium calceolus
76	20796	94041	\N	1	\N	9	\N	Cypripedium calceolus
28	20797	94041	\N	1	\N	9	\N	Cypripedium calceolus
37	20798	94041	\N	1	\N	9	\N	Cypripedium calceolus
14	20799	94041	\N	1	\N	9	\N	Cypripedium calceolus
50	20800	94041	\N	1	\N	9	\N	Cypripedium calceolus
71	20801	94041	\N	1	\N	9	\N	Cypripedium calceolus
62	20802	94041	\N	1	\N	9	\N	Cypripedium calceolus
67	20803	94041	\N	1	\N	9	\N	Cypripedium calceolus
68	20804	94041	\N	1	\N	9	\N	Cypripedium calceolus
90	20805	94041	\N	1	\N	9	\N	Cypripedium calceolus
44	20806	94041	\N	1	\N	9	\N	Cypripedium calceolus
49	20807	94041	\N	1	\N	9	\N	Cypripedium calceolus
72	20808	94041	\N	1	\N	9	\N	Cypripedium calceolus
85	20809	94041	\N	1	\N	9	\N	Cypripedium calceolus
22	20810	94041	\N	1	\N	9	\N	Cypripedium calceolus
29	20811	94041	\N	1	\N	9	\N	Cypripedium calceolus
35	20812	94041	\N	1	\N	9	\N	Cypripedium calceolus
16	20813	94041	\N	1	\N	9	\N	Cypripedium calceolus
17	20814	94041	\N	1	\N	9	\N	Cypripedium calceolus
33	20815	94041	\N	1	\N	9	\N	Cypripedium calceolus
31	20816	94041	\N	1	\N	9	\N	Cypripedium calceolus
46	20817	94041	\N	1	\N	9	\N	Cypripedium calceolus
19	20818	94041	\N	1	\N	9	\N	Cypripedium calceolus
23	20819	94041	\N	1	\N	9	\N	Cypripedium calceolus
87	20820	94041	\N	1	\N	9	\N	Cypripedium calceolus
7	20821	94041	\N	1	\N	9	\N	Cypripedium calceolus
38	20822	94041	\N	1	\N	9	\N	Cypripedium calceolus
69	20823	94041	\N	1	\N	9	\N	Cypripedium calceolus
15	20824	94041	\N	1	\N	9	\N	Cypripedium calceolus
63	20825	94041	\N	1	\N	9	\N	Cypripedium calceolus
30	20826	94041	\N	1	\N	9	\N	Cypripedium calceolus
34	20827	94041	\N	1	\N	9	\N	Cypripedium calceolus
48	20828	94041	\N	1	\N	9	\N	Cypripedium calceolus
13	20829	94041	\N	1	\N	9	\N	Cypripedium calceolus
83	20830	94041	\N	1	\N	9	\N	Cypripedium calceolus
84	20831	94041	\N	1	\N	9	\N	Cypripedium calceolus
2A	20832	94041	\N	1	\N	9	\N	Cypripedium calceolus
78	20833	67534	20	2	\N	9	\N	Misgurnus fossilis
92	20834	67534	20	2	\N	9	\N	Misgurnus fossilis
94	20835	67534	20	2	\N	9	\N	Misgurnus fossilis
95	20836	67534	20	2	\N	9	\N	Misgurnus fossilis
8	20837	67534	20	2	\N	9	\N	Misgurnus fossilis
10	20838	67534	20	2	\N	9	\N	Misgurnus fossilis
51	20839	67534	20	2	\N	9	\N	Misgurnus fossilis
2	20840	67534	20	2	\N	9	\N	Misgurnus fossilis
60	20841	67534	20	2	\N	9	\N	Misgurnus fossilis
27	20842	67534	20	2	\N	9	\N	Misgurnus fossilis
18	20843	67534	20	2	\N	9	\N	Misgurnus fossilis
36	20844	67534	20	2	\N	9	\N	Misgurnus fossilis
41	20845	67534	20	2	\N	9	\N	Misgurnus fossilis
45	20846	67534	20	2	\N	9	\N	Misgurnus fossilis
61	20847	67534	20	2	\N	9	\N	Misgurnus fossilis
21	20848	67534	20	2	\N	9	\N	Misgurnus fossilis
58	20849	67534	20	2	\N	9	\N	Misgurnus fossilis
89	20850	67534	20	2	\N	9	\N	Misgurnus fossilis
59	20851	67534	20	2	\N	9	\N	Misgurnus fossilis
54	20852	67534	20	2	\N	9	\N	Misgurnus fossilis
55	20853	67534	20	2	\N	9	\N	Misgurnus fossilis
57	20854	67534	20	2	\N	9	\N	Misgurnus fossilis
88	20855	67534	20	2	\N	9	\N	Misgurnus fossilis
25	20856	67534	20	2	\N	9	\N	Misgurnus fossilis
39	20857	67534	20	2	\N	9	\N	Misgurnus fossilis
70	20858	67534	20	2	\N	9	\N	Misgurnus fossilis
53	20859	67534	20	2	\N	9	\N	Misgurnus fossilis
56	20860	67534	20	2	\N	9	\N	Misgurnus fossilis
79	20861	67534	20	2	\N	9	\N	Misgurnus fossilis
86	20862	67534	20	2	\N	9	\N	Misgurnus fossilis
24	20863	67534	20	2	\N	9	\N	Misgurnus fossilis
40	20864	67534	20	2	\N	9	\N	Misgurnus fossilis
47	20865	67534	20	2	\N	9	\N	Misgurnus fossilis
64	20866	67534	20	2	\N	9	\N	Misgurnus fossilis
9	20867	67534	20	2	\N	9	\N	Misgurnus fossilis
12	20868	67534	20	2	\N	9	\N	Misgurnus fossilis
32	20869	67534	20	2	\N	9	\N	Misgurnus fossilis
65	20870	67534	20	2	\N	9	\N	Misgurnus fossilis
81	20871	67534	20	2	\N	9	\N	Misgurnus fossilis
82	20872	67534	20	2	\N	9	\N	Misgurnus fossilis
1	20873	67534	20	2	\N	9	\N	Misgurnus fossilis
26	20874	67534	20	2	\N	9	\N	Misgurnus fossilis
42	20875	67534	20	2	\N	9	\N	Misgurnus fossilis
73	20876	67534	20	2	\N	9	\N	Misgurnus fossilis
74	20877	67534	20	2	\N	9	\N	Misgurnus fossilis
3	20878	67534	20	2	\N	9	\N	Misgurnus fossilis
43	20879	67534	20	2	\N	9	\N	Misgurnus fossilis
11	20880	67534	20	2	\N	9	\N	Misgurnus fossilis
66	20881	67534	20	2	\N	9	\N	Misgurnus fossilis
4	20882	67534	20	2	\N	9	\N	Misgurnus fossilis
5	20883	67534	20	2	\N	9	\N	Misgurnus fossilis
6	20884	67534	20	2	\N	9	\N	Misgurnus fossilis
2B	20885	67534	20	2	\N	9	\N	Misgurnus fossilis
75	20886	67534	20	2	\N	9	\N	Misgurnus fossilis
77	20887	67534	20	2	\N	9	\N	Misgurnus fossilis
91	20888	67534	20	2	\N	9	\N	Misgurnus fossilis
93	20889	67534	20	2	\N	9	\N	Misgurnus fossilis
52	20890	67534	20	2	\N	9	\N	Misgurnus fossilis
80	20891	67534	20	2	\N	9	\N	Misgurnus fossilis
76	20892	67534	20	2	\N	9	\N	Misgurnus fossilis
28	20893	67534	20	2	\N	9	\N	Misgurnus fossilis
37	20894	67534	20	2	\N	9	\N	Misgurnus fossilis
14	20895	67534	20	2	\N	9	\N	Misgurnus fossilis
50	20896	67534	20	2	\N	9	\N	Misgurnus fossilis
71	20897	67534	20	2	\N	9	\N	Misgurnus fossilis
62	20898	67534	20	2	\N	9	\N	Misgurnus fossilis
67	20899	67534	20	2	\N	9	\N	Misgurnus fossilis
68	20900	67534	20	2	\N	9	\N	Misgurnus fossilis
90	20901	67534	20	2	\N	9	\N	Misgurnus fossilis
44	20902	67534	20	2	\N	9	\N	Misgurnus fossilis
49	20903	67534	20	2	\N	9	\N	Misgurnus fossilis
72	20904	67534	20	2	\N	9	\N	Misgurnus fossilis
85	20905	67534	20	2	\N	9	\N	Misgurnus fossilis
22	20906	67534	20	2	\N	9	\N	Misgurnus fossilis
29	20907	67534	20	2	\N	9	\N	Misgurnus fossilis
35	20908	67534	20	2	\N	9	\N	Misgurnus fossilis
16	20909	67534	20	2	\N	9	\N	Misgurnus fossilis
17	20910	67534	20	2	\N	9	\N	Misgurnus fossilis
33	20911	67534	20	2	\N	9	\N	Misgurnus fossilis
31	20912	67534	20	2	\N	9	\N	Misgurnus fossilis
46	20913	67534	20	2	\N	9	\N	Misgurnus fossilis
19	20914	67534	20	2	\N	9	\N	Misgurnus fossilis
23	20915	67534	20	2	\N	9	\N	Misgurnus fossilis
87	20916	67534	20	2	\N	9	\N	Misgurnus fossilis
7	20917	67534	20	2	\N	9	\N	Misgurnus fossilis
38	20918	67534	20	2	\N	9	\N	Misgurnus fossilis
69	20919	67534	20	2	\N	9	\N	Misgurnus fossilis
15	20920	67534	20	2	\N	9	\N	Misgurnus fossilis
63	20921	67534	20	2	\N	9	\N	Misgurnus fossilis
30	20922	67534	20	2	\N	9	\N	Misgurnus fossilis
34	20923	67534	20	2	\N	9	\N	Misgurnus fossilis
48	20924	67534	20	2	\N	9	\N	Misgurnus fossilis
13	20925	67534	20	2	\N	9	\N	Misgurnus fossilis
83	20926	67534	20	2	\N	9	\N	Misgurnus fossilis
84	20927	67534	20	2	\N	9	\N	Misgurnus fossilis
2A	20928	67534	20	2	\N	9	\N	Misgurnus fossilis
78	20929	159453	20	2	\N	9	\N	Cottus petiti
92	20930	159453	20	2	\N	9	\N	Cottus petiti
94	20931	159453	20	2	\N	9	\N	Cottus petiti
95	20932	159453	20	2	\N	9	\N	Cottus petiti
8	20933	159453	20	2	\N	9	\N	Cottus petiti
10	20934	159453	20	2	\N	9	\N	Cottus petiti
51	20935	159453	20	2	\N	9	\N	Cottus petiti
2	20936	159453	20	2	\N	9	\N	Cottus petiti
60	20937	159453	20	2	\N	9	\N	Cottus petiti
27	20938	159453	20	2	\N	9	\N	Cottus petiti
18	20939	159453	20	2	\N	9	\N	Cottus petiti
36	20940	159453	20	2	\N	9	\N	Cottus petiti
41	20941	159453	20	2	\N	9	\N	Cottus petiti
45	20942	159453	20	2	\N	9	\N	Cottus petiti
61	20943	159453	20	2	\N	9	\N	Cottus petiti
21	20944	159453	20	2	\N	9	\N	Cottus petiti
58	20945	159453	20	2	\N	9	\N	Cottus petiti
89	20946	159453	20	2	\N	9	\N	Cottus petiti
59	20947	159453	20	2	\N	9	\N	Cottus petiti
54	20948	159453	20	2	\N	9	\N	Cottus petiti
55	20949	159453	20	2	\N	9	\N	Cottus petiti
57	20950	159453	20	2	\N	9	\N	Cottus petiti
88	20951	159453	20	2	\N	9	\N	Cottus petiti
25	20952	159453	20	2	\N	9	\N	Cottus petiti
39	20953	159453	20	2	\N	9	\N	Cottus petiti
70	20954	159453	20	2	\N	9	\N	Cottus petiti
53	20955	159453	20	2	\N	9	\N	Cottus petiti
56	20956	159453	20	2	\N	9	\N	Cottus petiti
79	20957	159453	20	2	\N	9	\N	Cottus petiti
86	20958	159453	20	2	\N	9	\N	Cottus petiti
24	20959	159453	20	2	\N	9	\N	Cottus petiti
40	20960	159453	20	2	\N	9	\N	Cottus petiti
47	20961	159453	20	2	\N	9	\N	Cottus petiti
64	20962	159453	20	2	\N	9	\N	Cottus petiti
9	20963	159453	20	2	\N	9	\N	Cottus petiti
12	20964	159453	20	2	\N	9	\N	Cottus petiti
32	20965	159453	20	2	\N	9	\N	Cottus petiti
65	20966	159453	20	2	\N	9	\N	Cottus petiti
81	20967	159453	20	2	\N	9	\N	Cottus petiti
82	20968	159453	20	2	\N	9	\N	Cottus petiti
1	20969	159453	20	2	\N	9	\N	Cottus petiti
26	20970	159453	20	2	\N	9	\N	Cottus petiti
42	20971	159453	20	2	\N	9	\N	Cottus petiti
73	20972	159453	20	2	\N	9	\N	Cottus petiti
74	20973	159453	20	2	\N	9	\N	Cottus petiti
3	20974	159453	20	2	\N	9	\N	Cottus petiti
43	20975	159453	20	2	\N	9	\N	Cottus petiti
11	20976	159453	20	2	\N	9	\N	Cottus petiti
66	20977	159453	20	2	\N	9	\N	Cottus petiti
4	20978	159453	20	2	\N	9	\N	Cottus petiti
5	20979	159453	20	2	\N	9	\N	Cottus petiti
6	20980	159453	20	2	\N	9	\N	Cottus petiti
2B	20981	159453	20	2	\N	9	\N	Cottus petiti
75	20982	159453	20	2	\N	9	\N	Cottus petiti
77	20983	159453	20	2	\N	9	\N	Cottus petiti
91	20984	159453	20	2	\N	9	\N	Cottus petiti
93	20985	159453	20	2	\N	9	\N	Cottus petiti
52	20986	159453	20	2	\N	9	\N	Cottus petiti
80	20987	159453	20	2	\N	9	\N	Cottus petiti
76	20988	159453	20	2	\N	9	\N	Cottus petiti
28	20989	159453	20	2	\N	9	\N	Cottus petiti
37	20990	159453	20	2	\N	9	\N	Cottus petiti
14	20991	159453	20	2	\N	9	\N	Cottus petiti
50	20992	159453	20	2	\N	9	\N	Cottus petiti
71	20993	159453	20	2	\N	9	\N	Cottus petiti
62	20994	159453	20	2	\N	9	\N	Cottus petiti
67	20995	159453	20	2	\N	9	\N	Cottus petiti
68	20996	159453	20	2	\N	9	\N	Cottus petiti
90	20997	159453	20	2	\N	9	\N	Cottus petiti
44	20998	159453	20	2	\N	9	\N	Cottus petiti
49	20999	159453	20	2	\N	9	\N	Cottus petiti
72	21000	159453	20	2	\N	9	\N	Cottus petiti
85	21001	159453	20	2	\N	9	\N	Cottus petiti
22	21002	159453	20	2	\N	9	\N	Cottus petiti
29	21003	159453	20	2	\N	9	\N	Cottus petiti
35	21004	159453	20	2	\N	9	\N	Cottus petiti
16	21005	159453	20	2	\N	9	\N	Cottus petiti
17	21006	159453	20	2	\N	9	\N	Cottus petiti
33	21007	159453	20	2	\N	9	\N	Cottus petiti
31	21008	159453	20	2	\N	9	\N	Cottus petiti
46	21009	159453	20	2	\N	9	\N	Cottus petiti
19	21010	159453	20	2	\N	9	\N	Cottus petiti
23	21011	159453	20	2	\N	9	\N	Cottus petiti
87	21012	159453	20	2	\N	9	\N	Cottus petiti
7	21013	159453	20	2	\N	9	\N	Cottus petiti
38	21014	159453	20	2	\N	9	\N	Cottus petiti
69	21015	159453	20	2	\N	9	\N	Cottus petiti
15	21016	159453	20	2	\N	9	\N	Cottus petiti
63	21017	159453	20	2	\N	9	\N	Cottus petiti
30	21018	159453	20	2	\N	9	\N	Cottus petiti
34	21019	159453	20	2	\N	9	\N	Cottus petiti
48	21020	159453	20	2	\N	9	\N	Cottus petiti
13	21021	159453	20	2	\N	9	\N	Cottus petiti
83	21022	159453	20	2	\N	9	\N	Cottus petiti
84	21023	159453	20	2	\N	9	\N	Cottus petiti
2A	21024	159453	20	2	\N	9	\N	Cottus petiti
78	21025	78164	\N	1	\N	9	\N	Vipera ursinii
92	21026	78164	\N	1	\N	9	\N	Vipera ursinii
94	21027	78164	\N	1	\N	9	\N	Vipera ursinii
95	21028	78164	\N	1	\N	9	\N	Vipera ursinii
8	21029	78164	\N	1	\N	9	\N	Vipera ursinii
10	21030	78164	\N	1	\N	9	\N	Vipera ursinii
51	21031	78164	\N	1	\N	9	\N	Vipera ursinii
2	21032	78164	\N	1	\N	9	\N	Vipera ursinii
60	21033	78164	\N	1	\N	9	\N	Vipera ursinii
27	21034	78164	\N	1	\N	9	\N	Vipera ursinii
18	21035	78164	\N	1	\N	9	\N	Vipera ursinii
36	21036	78164	\N	1	\N	9	\N	Vipera ursinii
41	21037	78164	\N	1	\N	9	\N	Vipera ursinii
45	21038	78164	\N	1	\N	9	\N	Vipera ursinii
61	21039	78164	\N	1	\N	9	\N	Vipera ursinii
21	21040	78164	\N	1	\N	9	\N	Vipera ursinii
58	21041	78164	\N	1	\N	9	\N	Vipera ursinii
89	21042	78164	\N	1	\N	9	\N	Vipera ursinii
59	21043	78164	\N	1	\N	9	\N	Vipera ursinii
54	21044	78164	\N	1	\N	9	\N	Vipera ursinii
55	21045	78164	\N	1	\N	9	\N	Vipera ursinii
57	21046	78164	\N	1	\N	9	\N	Vipera ursinii
88	21047	78164	\N	1	\N	9	\N	Vipera ursinii
25	21048	78164	\N	1	\N	9	\N	Vipera ursinii
39	21049	78164	\N	1	\N	9	\N	Vipera ursinii
70	21050	78164	\N	1	\N	9	\N	Vipera ursinii
53	21051	78164	\N	1	\N	9	\N	Vipera ursinii
56	21052	78164	\N	1	\N	9	\N	Vipera ursinii
79	21053	78164	\N	1	\N	9	\N	Vipera ursinii
86	21054	78164	\N	1	\N	9	\N	Vipera ursinii
24	21055	78164	\N	1	\N	9	\N	Vipera ursinii
40	21056	78164	\N	1	\N	9	\N	Vipera ursinii
47	21057	78164	\N	1	\N	9	\N	Vipera ursinii
64	21058	78164	\N	1	\N	9	\N	Vipera ursinii
9	21059	78164	\N	1	\N	9	\N	Vipera ursinii
12	21060	78164	\N	1	\N	9	\N	Vipera ursinii
32	21061	78164	\N	1	\N	9	\N	Vipera ursinii
65	21062	78164	\N	1	\N	9	\N	Vipera ursinii
81	21063	78164	\N	1	\N	9	\N	Vipera ursinii
82	21064	78164	\N	1	\N	9	\N	Vipera ursinii
1	21065	78164	\N	1	\N	9	\N	Vipera ursinii
26	21066	78164	\N	1	\N	9	\N	Vipera ursinii
42	21067	78164	\N	1	\N	9	\N	Vipera ursinii
73	21068	78164	\N	1	\N	9	\N	Vipera ursinii
74	21069	78164	\N	1	\N	9	\N	Vipera ursinii
3	21070	78164	\N	1	\N	9	\N	Vipera ursinii
43	21071	78164	\N	1	\N	9	\N	Vipera ursinii
11	21072	78164	\N	1	\N	9	\N	Vipera ursinii
66	21073	78164	\N	1	\N	9	\N	Vipera ursinii
4	21074	78164	\N	1	\N	9	\N	Vipera ursinii
5	21075	78164	\N	1	\N	9	\N	Vipera ursinii
6	21076	78164	\N	1	\N	9	\N	Vipera ursinii
2B	21077	78164	\N	1	\N	9	\N	Vipera ursinii
75	21078	78164	\N	1	\N	9	\N	Vipera ursinii
77	21079	78164	\N	1	\N	9	\N	Vipera ursinii
91	21080	78164	\N	1	\N	9	\N	Vipera ursinii
93	21081	78164	\N	1	\N	9	\N	Vipera ursinii
52	21082	78164	\N	1	\N	9	\N	Vipera ursinii
80	21083	78164	\N	1	\N	9	\N	Vipera ursinii
76	21084	78164	\N	1	\N	9	\N	Vipera ursinii
28	21085	78164	\N	1	\N	9	\N	Vipera ursinii
37	21086	78164	\N	1	\N	9	\N	Vipera ursinii
14	21087	78164	\N	1	\N	9	\N	Vipera ursinii
50	21088	78164	\N	1	\N	9	\N	Vipera ursinii
71	21089	78164	\N	1	\N	9	\N	Vipera ursinii
62	21090	78164	\N	1	\N	9	\N	Vipera ursinii
67	21091	78164	\N	1	\N	9	\N	Vipera ursinii
68	21092	78164	\N	1	\N	9	\N	Vipera ursinii
90	21093	78164	\N	1	\N	9	\N	Vipera ursinii
44	21094	78164	\N	1	\N	9	\N	Vipera ursinii
49	21095	78164	\N	1	\N	9	\N	Vipera ursinii
72	21096	78164	\N	1	\N	9	\N	Vipera ursinii
85	21097	78164	\N	1	\N	9	\N	Vipera ursinii
22	21098	78164	\N	1	\N	9	\N	Vipera ursinii
29	21099	78164	\N	1	\N	9	\N	Vipera ursinii
35	21100	78164	\N	1	\N	9	\N	Vipera ursinii
16	21101	78164	\N	1	\N	9	\N	Vipera ursinii
17	21102	78164	\N	1	\N	9	\N	Vipera ursinii
33	21103	78164	\N	1	\N	9	\N	Vipera ursinii
31	21104	78164	\N	1	\N	9	\N	Vipera ursinii
46	21105	78164	\N	1	\N	9	\N	Vipera ursinii
19	21106	78164	\N	1	\N	9	\N	Vipera ursinii
23	21107	78164	\N	1	\N	9	\N	Vipera ursinii
87	21108	78164	\N	1	\N	9	\N	Vipera ursinii
7	21109	78164	\N	1	\N	9	\N	Vipera ursinii
38	21110	78164	\N	1	\N	9	\N	Vipera ursinii
69	21111	78164	\N	1	\N	9	\N	Vipera ursinii
15	21112	78164	\N	1	\N	9	\N	Vipera ursinii
63	21113	78164	\N	1	\N	9	\N	Vipera ursinii
30	21114	78164	\N	1	\N	9	\N	Vipera ursinii
34	21115	78164	\N	1	\N	9	\N	Vipera ursinii
48	21116	78164	\N	1	\N	9	\N	Vipera ursinii
13	21117	78164	\N	1	\N	9	\N	Vipera ursinii
83	21118	78164	\N	1	\N	9	\N	Vipera ursinii
84	21119	78164	\N	1	\N	9	\N	Vipera ursinii
2A	21120	78164	\N	1	\N	9	\N	Vipera ursinii
78	21121	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
92	21122	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
94	21123	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
95	21124	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
8	21125	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
10	21126	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
51	21127	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
2	21128	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
60	21129	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
27	21130	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
18	21131	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
36	21132	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
41	21133	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
45	21134	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
61	21135	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
21	21136	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
58	21137	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
89	21138	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
59	21139	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
54	21140	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
55	21141	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
57	21142	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
88	21143	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
25	21144	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
39	21145	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
70	21146	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
53	21147	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
56	21148	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
79	21149	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
86	21150	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
24	21151	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
40	21152	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
47	21153	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
64	21154	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
9	21155	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
12	21156	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
32	21157	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
65	21158	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
81	21159	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
82	21160	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
1	21161	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
26	21162	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
42	21163	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
73	21164	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
74	21165	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
3	21166	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
43	21167	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
11	21168	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
66	21169	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
4	21170	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
5	21171	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
6	21172	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
2B	21173	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
75	21174	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
77	21175	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
91	21176	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
93	21177	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
52	21178	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
80	21179	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
76	21180	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
28	21181	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
37	21182	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
14	21183	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
50	21184	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
71	21185	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
62	21186	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
67	21187	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
68	21188	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
90	21189	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
44	21190	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
49	21191	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
72	21192	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
85	21193	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
22	21194	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
29	21195	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
35	21196	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
16	21197	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
17	21198	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
33	21199	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
31	21200	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
46	21201	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
19	21202	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
23	21203	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
87	21204	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
7	21205	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
38	21206	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
69	21207	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
15	21208	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
63	21209	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
30	21210	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
34	21211	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
48	21212	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
13	21213	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
83	21214	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
84	21215	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
2A	21216	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus auritus
8	21217	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
45	21218	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
61	21219	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
58	21220	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
55	21221	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
86	21222	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
47	21223	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
9	21224	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
26	21225	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
73	21226	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
4	21227	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
2B	21228	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
75	21229	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
93	21230	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
28	21231	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
50	21232	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
71	21233	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
72	21234	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
17	21235	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
87	21236	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
7	21237	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
48	21238	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
13	21239	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
78	21240	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
94	21241	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
95	21242	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
18	21243	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
21	21244	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
89	21245	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
59	21246	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
88	21247	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
12	21248	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
81	21249	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
82	21250	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
1	21251	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
11	21252	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
66	21253	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
77	21254	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
76	21255	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
67	21256	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
44	21257	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
49	21258	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
22	21259	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
29	21260	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
16	21261	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
33	21262	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
31	21263	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
19	21264	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
69	21265	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
63	21266	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
83	21267	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
92	21268	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
10	21269	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
51	21270	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
2	21271	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
36	21272	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
54	21273	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
25	21274	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
39	21275	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
56	21276	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
32	21277	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
42	21278	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
74	21279	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
3	21280	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
43	21281	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
5	21282	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
91	21283	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
52	21284	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
80	21285	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
37	21286	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
14	21287	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
90	21288	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
85	21289	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
46	21290	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
38	21291	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
15	21292	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
84	21293	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
60	21294	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
27	21295	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
41	21296	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
57	21297	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
70	21298	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
53	21299	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
79	21300	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
24	21301	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
40	21302	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
64	21303	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
65	21304	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
6	21305	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
62	21306	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
68	21307	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
35	21308	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
23	21309	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
30	21310	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
34	21311	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
2A	21312	60518	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus auritus
8	21313	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
45	21314	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
61	21315	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
58	21316	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
55	21317	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
86	21318	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
47	21319	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
9	21320	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
26	21321	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
73	21322	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
4	21323	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
2B	21324	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
75	21325	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
93	21326	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
28	21327	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
50	21328	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
71	21329	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
72	21330	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
17	21331	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
87	21332	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
7	21333	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
48	21334	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
13	21335	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
78	21336	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
94	21337	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
95	21338	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
18	21339	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
21	21340	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
89	21341	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
59	21342	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
88	21343	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
12	21344	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
81	21345	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
82	21346	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
1	21347	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
11	21348	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
66	21349	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
77	21350	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
76	21351	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
67	21352	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
44	21353	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
49	21354	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
22	21355	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
29	21356	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
16	21357	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
33	21358	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
31	21359	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
19	21360	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
69	21361	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
63	21362	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
83	21363	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
92	21364	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
10	21365	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
51	21366	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
2	21367	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
36	21368	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
54	21369	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
25	21370	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
39	21371	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
56	21372	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
32	21373	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
42	21374	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
74	21375	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
3	21376	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
43	21377	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
5	21378	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
91	21379	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
52	21380	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
80	21381	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
37	21382	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
14	21383	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
90	21384	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
85	21385	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
46	21386	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
38	21387	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
15	21388	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
84	21389	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
60	21390	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
27	21391	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
41	21392	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
57	21393	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
70	21394	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
53	21395	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
79	21396	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
24	21397	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
40	21398	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
64	21399	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
65	21400	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
6	21401	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
62	21402	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
68	21403	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
35	21404	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
23	21405	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
30	21406	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
34	21407	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
2A	21408	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Plecotus austriacus
8	21409	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
45	21410	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
61	21411	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
58	21412	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
55	21413	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
86	21414	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
47	21415	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
9	21416	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
26	21417	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
73	21418	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
4	21419	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
2B	21420	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
75	21421	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
93	21422	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
28	21423	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
50	21424	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
71	21425	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
72	21426	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
17	21427	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
87	21428	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
7	21429	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
48	21430	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
13	21431	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
78	21432	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
94	21433	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
95	21434	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
18	21435	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
21	21436	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
89	21437	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
59	21438	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
88	21439	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
12	21440	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
81	21441	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
82	21442	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
1	21443	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
11	21444	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
66	21445	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
77	21446	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
76	21447	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
67	21448	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
44	21449	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
49	21450	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
22	21451	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
29	21452	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
16	21453	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
33	21454	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
31	21455	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
19	21456	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
69	21457	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
63	21458	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
83	21459	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
92	21460	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
10	21461	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
51	21462	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
2	21463	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
36	21464	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
54	21465	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
25	21466	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
39	21467	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
56	21468	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
32	21469	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
42	21470	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
74	21471	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
3	21472	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
43	21473	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
5	21474	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
91	21475	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
52	21476	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
80	21477	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
37	21478	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
14	21479	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
90	21480	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
85	21481	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
46	21482	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
38	21483	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
15	21484	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
84	21485	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
60	21486	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
27	21487	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
41	21488	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
57	21489	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
70	21490	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
53	21491	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
79	21492	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
24	21493	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
40	21494	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
64	21495	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
65	21496	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
6	21497	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
62	21498	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
68	21499	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
35	21500	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
23	21501	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
30	21502	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
34	21503	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
2A	21504	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Plecotus austriacus
78	21505	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
92	21506	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
94	21507	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
95	21508	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
8	21509	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
10	21510	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
51	21511	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
2	21512	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
60	21513	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
27	21514	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
18	21515	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
36	21516	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
41	21517	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
45	21518	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
61	21519	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
21	21520	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
58	21521	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
89	21522	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
59	21523	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
54	21524	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
55	21525	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
57	21526	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
88	21527	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
25	21528	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
39	21529	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
70	21530	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
53	21531	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
56	21532	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
79	21533	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
86	21534	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
24	21535	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
40	21536	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
47	21537	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
64	21538	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
9	21539	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
12	21540	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
32	21541	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
65	21542	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
81	21543	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
82	21544	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
1	21545	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
26	21546	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
42	21547	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
73	21548	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
74	21549	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
3	21550	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
43	21551	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
11	21552	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
66	21553	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
4	21554	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
5	21555	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
6	21556	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
2B	21557	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
75	21558	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
77	21559	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
91	21560	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
93	21561	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
52	21562	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
80	21563	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
76	21564	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
28	21565	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
37	21566	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
14	21567	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
50	21568	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
71	21569	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
62	21570	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
67	21571	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
68	21572	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
90	21573	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
44	21574	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
49	21575	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
72	21576	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
85	21577	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
22	21578	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
29	21579	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
35	21580	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
16	21581	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
17	21582	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
33	21583	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
31	21584	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
46	21585	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
19	21586	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
23	21587	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
87	21588	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
7	21589	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
38	21590	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
69	21591	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
15	21592	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
63	21593	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
30	21594	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
34	21595	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
48	21596	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
13	21597	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
83	21598	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
84	21599	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
2A	21600	60527	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Plecotus austriacus
78	21601	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
92	21602	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
94	21603	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
95	21604	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
8	21605	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
10	21606	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
51	21607	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
2	21608	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
60	21609	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
27	21610	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
18	21611	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
36	21612	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
41	21613	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
45	21614	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
61	21615	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
21	21616	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
58	21617	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
89	21618	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
59	21619	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
54	21620	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
55	21621	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
57	21622	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
88	21623	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
25	21624	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
39	21625	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
70	21626	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
53	21627	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
56	21628	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
79	21629	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
86	21630	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
24	21631	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
40	21632	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
47	21633	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
64	21634	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
9	21635	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
12	21636	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
32	21637	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
65	21638	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
81	21639	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
82	21640	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
1	21641	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
26	21642	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
42	21643	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
73	21644	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
74	21645	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
3	21646	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
43	21647	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
11	21648	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
66	21649	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
4	21650	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
5	21651	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
6	21652	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
2B	21653	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
75	21654	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
77	21655	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
91	21656	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
93	21657	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
52	21658	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
80	21659	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
76	21660	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
28	21661	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
37	21662	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
14	21663	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
50	21664	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
71	21665	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
62	21666	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
67	21667	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
68	21668	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
90	21669	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
44	21670	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
49	21671	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
72	21672	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
85	21673	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
22	21674	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
29	21675	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
35	21676	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
16	21677	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
17	21678	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
33	21679	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
31	21680	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
46	21681	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
19	21682	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
23	21683	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
87	21684	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
7	21685	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
38	21686	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
69	21687	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
15	21688	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
63	21689	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
30	21690	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
34	21691	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
48	21692	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
13	21693	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
83	21694	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
84	21695	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
2A	21696	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis punicus
78	21697	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
92	21698	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
94	21699	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
95	21700	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
8	21701	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
10	21702	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
51	21703	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
2	21704	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
60	21705	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
27	21706	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
18	21707	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
36	21708	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
41	21709	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
45	21710	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
61	21711	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
21	21712	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
58	21713	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
89	21714	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
59	21715	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
54	21716	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
55	21717	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
57	21718	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
88	21719	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
25	21720	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
39	21721	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
70	21722	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
53	21723	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
56	21724	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
79	21725	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
86	21726	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
24	21727	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
40	21728	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
47	21729	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
64	21730	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
9	21731	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
12	21732	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
32	21733	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
65	21734	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
81	21735	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
82	21736	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
1	21737	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
26	21738	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
42	21739	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
73	21740	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
74	21741	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
3	21742	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
43	21743	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
11	21744	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
66	21745	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
4	21746	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
5	21747	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
6	21748	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
2B	21749	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
75	21750	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
77	21751	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
91	21752	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
93	21753	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
52	21754	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
80	21755	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
76	21756	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
28	21757	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
37	21758	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
14	21759	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
50	21760	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
71	21761	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
62	21762	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
67	21763	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
68	21764	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
90	21765	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
44	21766	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
49	21767	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
72	21768	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
85	21769	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
22	21770	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
29	21771	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
35	21772	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
16	21773	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
17	21774	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
33	21775	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
31	21776	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
46	21777	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
19	21778	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
23	21779	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
87	21780	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
7	21781	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
38	21782	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
69	21783	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
15	21784	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
63	21785	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
30	21786	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
34	21787	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
48	21788	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
13	21789	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
83	21790	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
84	21791	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
2A	21792	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis punicus
78	21793	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
92	21794	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
94	21795	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
95	21796	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
8	21797	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
10	21798	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
51	21799	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
2	21800	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
60	21801	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
27	21802	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
18	21803	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
36	21804	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
41	21805	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
45	21806	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
61	21807	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
21	21808	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
58	21809	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
89	21810	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
59	21811	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
54	21812	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
55	21813	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
57	21814	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
88	21815	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
25	21816	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
39	21817	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
70	21818	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
53	21819	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
56	21820	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
79	21821	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
86	21822	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
24	21823	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
40	21824	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
47	21825	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
64	21826	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
9	21827	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
12	21828	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
32	21829	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
65	21830	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
81	21831	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
82	21832	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
1	21833	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
26	21834	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
42	21835	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
73	21836	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
74	21837	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
3	21838	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
43	21839	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
11	21840	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
66	21841	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
4	21842	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
5	21843	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
6	21844	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
2B	21845	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
75	21846	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
77	21847	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
91	21848	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
93	21849	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
52	21850	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
80	21851	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
76	21852	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
28	21853	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
37	21854	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
14	21855	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
50	21856	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
71	21857	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
62	21858	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
67	21859	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
68	21860	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
90	21861	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
44	21862	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
49	21863	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
72	21864	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
85	21865	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
22	21866	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
29	21867	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
35	21868	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
16	21869	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
17	21870	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
33	21871	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
31	21872	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
46	21873	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
19	21874	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
23	21875	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
87	21876	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
7	21877	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
38	21878	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
69	21879	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
15	21880	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
63	21881	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
30	21882	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
34	21883	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
48	21884	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
13	21885	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
83	21886	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
84	21887	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
2A	21888	79298	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis punicus
78	21889	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
92	21890	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
94	21891	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
95	21892	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
8	21893	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
10	21894	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
51	21895	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
2	21896	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
60	21897	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
27	21898	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
18	21899	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
36	21900	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
41	21901	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
45	21902	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
61	21903	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
21	21904	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
58	21905	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
89	21906	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
59	21907	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
54	21908	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
55	21909	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
57	21910	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
88	21911	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
25	21912	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
39	21913	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
70	21914	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
53	21915	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
56	21916	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
79	21917	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
86	21918	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
24	21919	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
40	21920	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
47	21921	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
64	21922	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
9	21923	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
12	21924	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
32	21925	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
65	21926	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
81	21927	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
82	21928	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
1	21929	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
26	21930	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
42	21931	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
73	21932	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
74	21933	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
3	21934	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
43	21935	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
11	21936	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
66	21937	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
4	21938	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
5	21939	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
6	21940	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
2B	21941	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
75	21942	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
77	21943	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
91	21944	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
93	21945	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
52	21946	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
80	21947	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
76	21948	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
28	21949	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
37	21950	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
14	21951	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
50	21952	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
71	21953	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
62	21954	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
67	21955	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
68	21956	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
90	21957	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
44	21958	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
49	21959	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
72	21960	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
85	21961	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
22	21962	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
29	21963	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
35	21964	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
16	21965	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
17	21966	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
33	21967	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
31	21968	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
46	21969	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
19	21970	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
23	21971	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
87	21972	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
7	21973	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
38	21974	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
69	21975	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
15	21976	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
63	21977	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
30	21978	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
34	21979	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
48	21980	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
13	21981	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
83	21982	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
84	21983	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
2A	21984	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis alcathoe
78	21985	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
92	21986	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
94	21987	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
95	21988	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
8	21989	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
10	21990	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
51	21991	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
2	21992	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
60	21993	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
27	21994	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
18	21995	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
36	21996	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
41	21997	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
45	21998	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
61	21999	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
21	22000	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
58	22001	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
89	22002	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
59	22003	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
54	22004	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
55	22005	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
57	22006	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
88	22007	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
25	22008	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
39	22009	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
70	22010	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
53	22011	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
56	22012	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
79	22013	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
86	22014	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
24	22015	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
40	22016	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
47	22017	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
64	22018	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
9	22019	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
12	22020	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
32	22021	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
65	22022	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
81	22023	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
82	22024	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
1	22025	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
26	22026	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
42	22027	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
73	22028	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
74	22029	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
3	22030	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
43	22031	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
11	22032	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
66	22033	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
4	22034	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
5	22035	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
6	22036	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
2B	22037	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
75	22038	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
77	22039	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
91	22040	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
93	22041	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
52	22042	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
80	22043	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
76	22044	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
28	22045	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
37	22046	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
14	22047	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
50	22048	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
71	22049	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
62	22050	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
67	22051	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
68	22052	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
90	22053	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
44	22054	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
49	22055	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
72	22056	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
85	22057	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
22	22058	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
29	22059	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
35	22060	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
16	22061	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
17	22062	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
33	22063	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
31	22064	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
46	22065	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
19	22066	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
23	22067	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
87	22068	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
7	22069	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
38	22070	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
69	22071	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
15	22072	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
63	22073	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
30	22074	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
34	22075	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
48	22076	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
13	22077	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
83	22078	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
84	22079	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
2A	22080	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis alcathoe
78	22081	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
92	22082	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
94	22083	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
95	22084	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
8	22085	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
10	22086	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
51	22087	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
2	22088	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
60	22089	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
27	22090	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
18	22091	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
36	22092	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
41	22093	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
45	22094	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
61	22095	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
21	22096	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
58	22097	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
89	22098	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
59	22099	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
54	22100	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
55	22101	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
57	22102	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
88	22103	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
25	22104	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
39	22105	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
70	22106	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
53	22107	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
56	22108	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
79	22109	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
86	22110	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
24	22111	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
40	22112	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
47	22113	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
64	22114	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
9	22115	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
12	22116	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
32	22117	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
65	22118	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
81	22119	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
82	22120	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
1	22121	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
26	22122	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
42	22123	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
73	22124	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
74	22125	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
3	22126	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
43	22127	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
11	22128	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
66	22129	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
4	22130	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
5	22131	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
6	22132	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
2B	22133	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
75	22134	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
77	22135	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
91	22136	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
93	22137	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
52	22138	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
80	22139	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
76	22140	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
28	22141	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
37	22142	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
14	22143	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
50	22144	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
71	22145	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
62	22146	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
67	22147	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
68	22148	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
90	22149	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
44	22150	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
49	22151	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
72	22152	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
85	22153	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
22	22154	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
29	22155	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
35	22156	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
16	22157	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
17	22158	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
33	22159	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
31	22160	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
46	22161	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
19	22162	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
23	22163	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
87	22164	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
7	22165	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
38	22166	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
69	22167	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
15	22168	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
63	22169	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
30	22170	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
34	22171	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
48	22172	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
13	22173	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
83	22174	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
84	22175	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
2A	22176	79299	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	7	Myotis alcathoe
78	22177	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
92	22178	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
94	22179	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
95	22180	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
8	22181	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
10	22182	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
51	22183	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
2	22184	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
60	22185	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
27	22186	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
18	22187	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
36	22188	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
41	22189	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
45	22190	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
61	22191	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
21	22192	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
58	22193	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
89	22194	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
59	22195	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
54	22196	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
55	22197	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
57	22198	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
88	22199	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
25	22200	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
39	22201	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
70	22202	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
53	22203	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
56	22204	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
79	22205	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
86	22206	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
24	22207	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
40	22208	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
47	22209	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
64	22210	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
9	22211	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
12	22212	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
32	22213	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
65	22214	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
81	22215	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
82	22216	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
1	22217	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
26	22218	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
42	22219	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
73	22220	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
74	22221	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
3	22222	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
43	22223	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
11	22224	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
66	22225	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
4	22226	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
5	22227	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
6	22228	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
2B	22229	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
75	22230	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
77	22231	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
91	22232	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
93	22233	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
52	22234	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
80	22235	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
76	22236	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
28	22237	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
37	22238	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
14	22239	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
50	22240	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
71	22241	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
62	22242	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
67	22243	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
68	22244	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
90	22245	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
44	22246	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
49	22247	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
72	22248	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
85	22249	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
22	22250	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
29	22251	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
35	22252	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
16	22253	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
17	22254	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
33	22255	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
31	22256	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
46	22257	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
19	22258	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
23	22259	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
87	22260	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
7	22261	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
38	22262	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
69	22263	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
15	22264	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
63	22265	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
30	22266	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
34	22267	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
48	22268	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
13	22269	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
83	22270	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
84	22271	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
2A	22272	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	3	Myotis brandtii
78	22273	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
92	22274	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
94	22275	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
95	22276	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
8	22277	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
10	22278	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
51	22279	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
2	22280	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
60	22281	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
27	22282	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
18	22283	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
36	22284	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
41	22285	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
45	22286	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
61	22287	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
21	22288	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
58	22289	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
89	22290	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
59	22291	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
54	22292	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
55	22293	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
57	22294	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
88	22295	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
25	22296	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
39	22297	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
70	22298	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
53	22299	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
56	22300	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
79	22301	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
86	22302	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
24	22303	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
40	22304	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
47	22305	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
64	22306	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
9	22307	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
12	22308	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
32	22309	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
65	22310	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
81	22311	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
82	22312	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
1	22313	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
26	22314	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
42	22315	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
73	22316	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
74	22317	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
3	22318	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
43	22319	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
11	22320	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
66	22321	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
4	22322	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
5	22323	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
6	22324	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
2B	22325	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
75	22326	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
77	22327	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
91	22328	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
93	22329	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
52	22330	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
80	22331	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
76	22332	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
28	22333	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
37	22334	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
14	22335	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
50	22336	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
71	22337	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
62	22338	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
67	22339	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
68	22340	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
90	22341	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
44	22342	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
49	22343	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
72	22344	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
85	22345	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
22	22346	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
29	22347	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
35	22348	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
16	22349	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
17	22350	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
33	22351	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
31	22352	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
46	22353	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
19	22354	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
23	22355	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
87	22356	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
7	22357	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
38	22358	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
69	22359	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
15	22360	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
63	22361	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
30	22362	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
34	22363	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
48	22364	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
13	22365	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
83	22366	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
84	22367	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
2A	22368	79300	\N	2	Gîtes hypogés et fortifications (données de détection acoustique non sensibles)	9	4	Myotis brandtii
\.


--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 289
-- Name: especesensible_id_seq; Type: SEQUENCE SET; Schema: referentiels; Owner: admin
--

SELECT pg_catalog.setval('especesensible_id_seq', 22368, true);


--
-- TOC entry 3910 (class 2606 OID 116784)
-- Name: pk; Type: CONSTRAINT; Schema: referentiels; Owner: admin; Tablespace: 
--

ALTER TABLE ONLY especesensible
    ADD CONSTRAINT pk PRIMARY KEY (id);


-- Completed on 2016-07-20 09:31:28 CEST

--
-- PostgreSQL database dump complete
--

