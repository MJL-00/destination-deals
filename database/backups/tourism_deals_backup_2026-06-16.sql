--
-- PostgreSQL database dump
--

\restrict YGdnPQ68dEnIwebYpbSDq8SkMNaR7bBD6HfNHTn1AfgbJ7x0TDpsJDF0FcOwZIv

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-17 08:12:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 16511)
-- Name: fn_set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: business; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business (
    businessid integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(150),
    phone character varying(15),
    website character varying(100),
    subscription_tier character varying(20) DEFAULT 'Basic'::character varying NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    directions_click_count integer DEFAULT 0 NOT NULL,
    website_click_count integer DEFAULT 0 NOT NULL,
    CONSTRAINT chk_subscription_tier CHECK (((subscription_tier)::text = ANY ((ARRAY['Basic'::character varying, 'Premium'::character varying])::text[])))
);


ALTER TABLE public.business OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: business_businessid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.business_businessid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.business_businessid_seq OWNER TO postgres;

--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_businessid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_businessid_seq OWNED BY public.business.businessid;


--
-- TOC entry 226 (class 1259 OID 16432)
-- Name: businesscategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businesscategory (
    businessid integer NOT NULL,
    categoryid integer NOT NULL
);


ALTER TABLE public.businesscategory OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16406)
-- Name: businesslocation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.businesslocation (
    businessid integer NOT NULL,
    locationid integer NOT NULL
);


ALTER TABLE public.businesslocation OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16424)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    categoryid integer NOT NULL,
    categoryname character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16423)
-- Name: category_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_categoryid_seq OWNER TO postgres;

--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 224
-- Name: category_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_categoryid_seq OWNED BY public.category.categoryid;


--
-- TOC entry 228 (class 1259 OID 16450)
-- Name: deal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deal (
    dealid integer NOT NULL,
    businessid integer,
    title character varying(100),
    description text,
    discounttype character varying(20),
    discountvalue numeric(5,2),
    startdate date,
    enddate date,
    isactive boolean,
    click_count integer DEFAULT 0 NOT NULL,
    redemption_count integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.deal OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16449)
-- Name: deal_dealid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deal_dealid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deal_dealid_seq OWNER TO postgres;

--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 227
-- Name: deal_dealid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deal_dealid_seq OWNED BY public.deal.dealid;


--
-- TOC entry 231 (class 1259 OID 16477)
-- Name: dealcategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealcategory (
    dealid integer NOT NULL,
    categoryid integer NOT NULL
);


ALTER TABLE public.dealcategory OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16465)
-- Name: dealschedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealschedule (
    scheduleid integer NOT NULL,
    dealid integer,
    dayofweek character varying(10),
    starttime time without time zone,
    endtime time without time zone
);


ALTER TABLE public.dealschedule OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16464)
-- Name: dealschedule_scheduleid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dealschedule_scheduleid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dealschedule_scheduleid_seq OWNER TO postgres;

--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 229
-- Name: dealschedule_scheduleid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dealschedule_scheduleid_seq OWNED BY public.dealschedule.scheduleid;


--
-- TOC entry 222 (class 1259 OID 16399)
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    locationid integer NOT NULL,
    city character varying(50),
    state character(2),
    description character varying(150)
);


ALTER TABLE public.location OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16398)
-- Name: location_locationid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_locationid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.location_locationid_seq OWNER TO postgres;

--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 221
-- Name: location_locationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_locationid_seq OWNED BY public.location.locationid;


--
-- TOC entry 4889 (class 2604 OID 16393)
-- Name: business businessid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business ALTER COLUMN businessid SET DEFAULT nextval('public.business_businessid_seq'::regclass);


--
-- TOC entry 4895 (class 2604 OID 16427)
-- Name: category categoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN categoryid SET DEFAULT nextval('public.category_categoryid_seq'::regclass);


--
-- TOC entry 4896 (class 2604 OID 16453)
-- Name: deal dealid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal ALTER COLUMN dealid SET DEFAULT nextval('public.deal_dealid_seq'::regclass);


--
-- TOC entry 4901 (class 2604 OID 16468)
-- Name: dealschedule scheduleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule ALTER COLUMN scheduleid SET DEFAULT nextval('public.dealschedule_scheduleid_seq'::regclass);


--
-- TOC entry 4894 (class 2604 OID 16402)
-- Name: location locationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN locationid SET DEFAULT nextval('public.location_locationid_seq'::regclass);


--
-- TOC entry 5076 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business (businessid, name, address, phone, website, subscription_tier, is_verified, directions_click_count, website_click_count) FROM stdin;
2	Thames Street Boutique	15 Thames St, Newport, RI 02840	4015551001	www.thamesboutique.com	Basic	f	0	0
3	Newport Sailing Adventures	22 Bowen Wharf, Newport, RI 02840	4015551002	www.newportsailing.com	Basic	f	0	0
4	Family Fun Arcade	10 America's Cup Ave, Newport, RI 02840	4015551003	www.familyfunarcade.com	Basic	f	0	0
5	Cliff Walk Cafe	50 Memorial Blvd, Newport, RI 02840	4015551004	www.cliffwalkcafe.com	Basic	f	0	0
9	Seafood by the Sea	1000 America's Cup Ave, Newport, RI 02840	4015552003	www.seafoodbythesea.com	Basic	f	0	0
1	Ocean View Restaurant	600 Ocean Ave, Newport, RI 02840	4015553002	www.oceanviewrestaurant.com	Basic	f	0	0
6	Tobys Tango Dancing Lessons	44 Smith Ave, Newport, RI 02840	4015553001	www.tobystangolessons.com	Basic	f	0	0
7	Nigels Star Gazing Tours	49 East Bowery St, Newport, RI 02840	4015552001	www.stargazewithnigel.com	Basic	f	0	0
8	Newport History Museum	25 Young St, Newport, RI 02840	4015552002	www.newporthistorymuseum.com	Basic	f	0	0
10	Andrews Burgers	33 Howard St, Newport, RI 02840	4015552004	www.andrewsburgers.com	Basic	f	0	0
11	Test Business admin page	325 Washington St	4018881100	https://www.providenceri.gov/	Basic	f	0	0
12	Midtown Oyster Bar	345 Thames St	4016194100	https://www.midtownoyster.com/	Basic	f	0	0
14	Midtown Oyster Bar 2	345 Thames St	4011111111	https://www.midtownoyster.com/	Basic	f	0	0
15	Simple Merchant Coffee	513 Broadway	4018858855	\N	Basic	f	0	0
16	Nitro Bar - Newport (Thames)	404 Thames St	4018889999	https://thenitrocart.com/	Basic	f	0	0
17	Nitro Bar - Newport (Pond)	2 Pond Ave	4013333332	https://thenitrocart.com/	Basic	f	0	0
18	Nitro Bar - Providence	228 Broadway	4015555552	https://thenitrocart.com/	Basic	f	0	0
19	Benjamins	254 Thames St	4018468768	https://benjaminsnewportri.com/	Basic	f	0	0
\.


--
-- TOC entry 5082 (class 0 OID 16432)
-- Dependencies: 226
-- Data for Name: businesscategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesscategory (businessid, categoryid) FROM stdin;
1	1
2	2
3	3
3	4
4	3
5	1
6	3
7	3
7	4
8	3
8	4
9	1
10	1
16	1
17	1
18	1
19	1
\.


--
-- TOC entry 5079 (class 0 OID 16406)
-- Dependencies: 223
-- Data for Name: businesslocation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesslocation (businessid, locationid) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
14	1
15	1
16	1
17	1
18	2
19	1
\.


--
-- TOC entry 5081 (class 0 OID 16424)
-- Dependencies: 225
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (categoryid, categoryname) FROM stdin;
1	Restaurant
2	Retail
3	Activity
4	Family-Friendly
\.


--
-- TOC entry 5084 (class 0 OID 16450)
-- Dependencies: 228
-- Data for Name: deal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deal (dealid, businessid, title, description, discounttype, discountvalue, startdate, enddate, isactive, click_count, redemption_count, created_at, updated_at) FROM stdin;
1	1	Happy Hour	20% off drinks	Percent	20.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
2	2	Buy One Get One	Buy one shirt get one 50% off	Percent	50.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
3	3	Sunset Cruise Special	$45 off sunset sailing trip	Flat	45.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
4	4	Family Game Night	Unlimited arcade play for $20	Flat	20.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
5	5	Breakfast Combo	10% off breakfast combos	Percent	10.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
6	5	Kids Eat Free	One free kids meal per adult entree	Flat	0.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
7	6	Buy One Get One	Buy one lesson get one 50% off	Percent	50.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
8	6	Group Special	4 persons or more get 15% off	Percent	15.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
9	7	Weekday Tour Special	$25 off Star Gazing tour	Flat	25.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
10	8	Weekday Ticket Special	20% off tickets	Percent	20.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
11	9	Dollar Shellfish	$1 oyserts and clams	flat	1.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
12	9	1 Free Drink with lobster dinner	1 Free drink when you order a lobster entree	flat	1.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
13	10	Lunch Special	15% off when you get a meal and a drink	Percent	15.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
14	10	Kids Lunch Special	One free kids meal per adult entree	Flat	1.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
15	11	15% off something	15% off something	Percentage	15.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
16	12	Half off Appetizers	50% off appetizers	Percentage	50.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
17	14	Half off appetizers	Half off appetizers	Percent	50.00	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
18	15	free doughnut tuesdays & thursdays	Purchase any size coffee and get a free doughnut	BOGO	\N	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
19	11	time test	testing the time slots 	Custom	\N	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
20	17	Free Pastry Mondays	Free pastry with the purchase of any coffee	Custom	\N	\N	\N	t	0	0	2026-06-17 06:23:18.489421-04	2026-06-17 06:23:18.489421-04
21	19	Buck-a-Shuck	$1 Oysters and Clams every day from 3pm-6pm	Custom	\N	\N	\N	t	0	0	2026-06-17 07:40:04.10672-04	2026-06-17 07:40:04.10672-04
\.


--
-- TOC entry 5087 (class 0 OID 16477)
-- Dependencies: 231
-- Data for Name: dealcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealcategory (dealid, categoryid) FROM stdin;
1	1
2	2
3	3
3	4
4	3
4	4
5	1
6	4
6	1
7	3
8	3
9	3
9	4
10	3
11	1
12	1
13	1
14	4
14	1
16	1
17	1
18	1
19	2
20	1
21	1
\.


--
-- TOC entry 5086 (class 0 OID 16465)
-- Dependencies: 230
-- Data for Name: dealschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealschedule (scheduleid, dealid, dayofweek, starttime, endtime) FROM stdin;
1	1	Friday	16:00:00	18:00:00
2	2	Saturday	10:00:00	18:00:00
3	3	Sunday	17:00:00	20:00:00
4	4	Friday	18:00:00	22:00:00
5	5	Saturday	08:00:00	12:00:00
6	6	Sunday	12:00:00	20:00:00
7	7	Saturday	12:00:00	16:00:00
8	8	Saturday	12:00:00	16:00:00
9	9	Thursday	20:00:00	22:00:00
10	10	Thursday	12:00:00	19:00:00
11	11	Wednesday	15:00:00	21:00:00
12	12	Saturday	11:00:00	22:00:00
13	13	Thursday	11:00:00	15:00:00
14	14	Sunday	11:00:00	20:00:00
15	1	Thursday	16:00:00	18:00:00
16	1	Wednesday	16:00:00	18:00:00
17	1	Tuesday	16:00:00	18:00:00
18	1	Monday	16:00:00	18:00:00
19	1	Saturday	16:00:00	18:00:00
20	1	Sunday	16:00:00	18:00:00
21	18	Tuesday	\N	\N
22	18	Thursday	\N	\N
23	19	Monday	14:00:00	17:00:00
24	19	Tuesday	14:00:00	17:00:00
25	19	Wednesday	14:00:00	17:00:00
26	19	Thursday	14:00:00	17:00:00
27	19	Friday	14:00:00	17:00:00
28	19	Saturday	14:00:00	17:00:00
29	19	Sunday	14:00:00	17:00:00
30	20	Monday	07:00:00	16:00:00
31	21	Monday	15:00:00	18:00:00
32	21	Tuesday	15:00:00	18:00:00
33	21	Wednesday	15:00:00	18:00:00
34	21	Thursday	15:00:00	18:00:00
35	21	Friday	15:00:00	18:00:00
36	21	Saturday	15:00:00	18:00:00
37	21	Sunday	15:00:00	18:00:00
\.


--
-- TOC entry 5078 (class 0 OID 16399)
-- Dependencies: 222
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (locationid, city, state, description) FROM stdin;
1	Newport	RI	Historic coastal tourist destination
2	Providence	RI	Capital city with restaurants and nightlife
3	Narragansett	RI	Beach and surfing destination
4	Westerly	RI	Family-friendly beach town
5	Boston	MA	Major metropolitan tourist hub
6	Mystic	CT	Historic maritime tourism town
\.


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_businessid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_businessid_seq', 19, true);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 224
-- Name: category_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_categoryid_seq', 4, true);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 227
-- Name: deal_dealid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deal_dealid_seq', 21, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 229
-- Name: dealschedule_scheduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealschedule_scheduleid_seq', 37, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 221
-- Name: location_locationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_locationid_seq', 6, true);


--
-- TOC entry 4904 (class 2606 OID 16397)
-- Name: business business_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_pkey PRIMARY KEY (businessid);


--
-- TOC entry 4912 (class 2606 OID 16438)
-- Name: businesscategory businesscategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_pkey PRIMARY KEY (businessid, categoryid);


--
-- TOC entry 4908 (class 2606 OID 16412)
-- Name: businesslocation businesslocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_pkey PRIMARY KEY (businessid, locationid);


--
-- TOC entry 4910 (class 2606 OID 16431)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- TOC entry 4914 (class 2606 OID 16458)
-- Name: deal deal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal
    ADD CONSTRAINT deal_pkey PRIMARY KEY (dealid);


--
-- TOC entry 4918 (class 2606 OID 16483)
-- Name: dealcategory dealcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_pkey PRIMARY KEY (dealid, categoryid);


--
-- TOC entry 4916 (class 2606 OID 16471)
-- Name: dealschedule dealschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule
    ADD CONSTRAINT dealschedule_pkey PRIMARY KEY (scheduleid);


--
-- TOC entry 4906 (class 2606 OID 16405)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (locationid);


--
-- TOC entry 4927 (class 2620 OID 16512)
-- Name: deal trg_deal_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_deal_updated_at BEFORE UPDATE ON public.deal FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- TOC entry 4921 (class 2606 OID 16439)
-- Name: businesscategory businesscategory_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4922 (class 2606 OID 16444)
-- Name: businesscategory businesscategory_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.category(categoryid);


--
-- TOC entry 4919 (class 2606 OID 16413)
-- Name: businesslocation businesslocation_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4920 (class 2606 OID 16418)
-- Name: businesslocation businesslocation_locationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_locationid_fkey FOREIGN KEY (locationid) REFERENCES public.location(locationid);


--
-- TOC entry 4923 (class 2606 OID 16459)
-- Name: deal deal_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal
    ADD CONSTRAINT deal_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4925 (class 2606 OID 16489)
-- Name: dealcategory dealcategory_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.category(categoryid);


--
-- TOC entry 4926 (class 2606 OID 16484)
-- Name: dealcategory dealcategory_dealid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_dealid_fkey FOREIGN KEY (dealid) REFERENCES public.deal(dealid);


--
-- TOC entry 4924 (class 2606 OID 16472)
-- Name: dealschedule dealschedule_dealid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule
    ADD CONSTRAINT dealschedule_dealid_fkey FOREIGN KEY (dealid) REFERENCES public.deal(dealid);


-- Completed on 2026-06-17 08:12:04

--
-- PostgreSQL database dump complete
--

\unrestrict YGdnPQ68dEnIwebYpbSDq8SkMNaR7bBD6HfNHTn1AfgbJ7x0TDpsJDF0FcOwZIv

