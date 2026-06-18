--
-- PostgreSQL database dump
--

\restrict z6io5hSXF7aOmPhX466WyhvlgWK8imbeJBFk9xUgfsFskKArYeQ7O0UsC5ilOJM

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-06-18 18:57:10

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
    latitude numeric(9,6),
    longitude numeric(9,6),
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

COPY public.business (businessid, name, address, phone, website, subscription_tier, is_verified, directions_click_count, website_click_count, latitude, longitude) FROM stdin;
1	Ocean View Restaurant	25 Thames St	4015551000	https://www.oceanviewrestaurant.com	Premium	t	0	0	41.483200	-71.317500
2	Thames Street Boutique	15 Thames St	4015551001	https://www.thamesboutique.com	Basic	t	0	0	41.483100	-71.317700
6	Nigels Star Gazing Tours	35 East Bowery St	4015552001	https://www.stargazewithnigel.com	Basic	f	0	0	41.492300	-71.304100
7	Newport History Museum	25 Young St	4015552002	https://www.newporthistorymuseum.com	Basic	t	0	0	41.487800	-71.312400
8	Seafood by the Sea	100 Americas Cup Ave	4015552003	https://www.seafoodbythesea.com	Premium	t	0	0	41.486800	-71.313100
9	Andrews Burgers	33 Howard St	4015552004	https://www.andrewsburgers.com	Basic	t	2	1	41.481200	-71.319800
3	Newport Sailing Adventures	22 Bowen Wharf	4015551002	https://www.newportsailing.com	Premium	t	1	0	41.480100	-71.326900
5	Cliff Walk Cafe	50 Memorial Blvd	4015551004	https://www.cliffwalkcafe.com	Basic	t	2	1	41.490200	-71.308900
11	Midtown Oyster Bar	345 Thames St	4016194100	https://www.midtownoyster.com/	Basic	t	2	2	42.484422	-71.314946
4	Family Fun Arcade	10 Americas Cup Ave	4015551003	https://www.familyfunarcade.com	Basic	t	0	1	41.486800	-71.313100
12	Benjamins	254 Thames St	4018468768	https://benjaminsnewportri.com/	Basic	t	0	0	41.486759	-71.314842
13	Cappys Hillside Cafe	8 Memorial Blvd W, Newport, RI 02840	(401) 847-9419	https://www.cappyshillsidecafe.com/	Basic	t	0	0	41.484059	-71.308974
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
4	4
5	1
5	4
6	3
7	4
8	1
9	1
11	1
12	1
13	1
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
11	1
12	1
13	1
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
1	1	Happy Hour	20% off all drinks at the bar	Percent	20.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
2	2	Buy One Get One	Buy one shirt, get one 50% off	Percent	50.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
3	3	Sunset Cruise Special	$15 off any sailing trip booking	Flat	15.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
4	4	Family Game Night	Unlimited arcade play for $20 per person	Flat	20.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
5	5	Breakfast Combo	10% off all breakfast combos	Percent	10.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
6	5	Kids Eat Free	One free kids meal per adult entree purchased	Flat	0.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
7	6	Evening Telescope Tour	25% off any evening stargazing tour	Percent	25.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
8	7	Museum Admission Discount	$5 off general admission	Flat	5.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
9	8	Lobster Roll Special	15% off lobster rolls every weekend	Percent	15.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
10	9	Burger Combo Deal	Free fries with any combo purchase	Flat	0.00	\N	\N	t	0	0	2026-06-17 09:26:43.508355-04	2026-06-17 09:26:43.508355-04
12	11	Half off Appetizers	50% off appetizers 2pm - 4pm	Percent	50.00	\N	\N	t	0	0	2026-06-18 16:27:15.64993-04	2026-06-18 16:30:25.122901-04
13	12	Buck-a-Shuck	$1 Oysters and Clams	Custom	\N	\N	\N	t	0	0	2026-06-18 16:37:54.682294-04	2026-06-18 16:37:54.682294-04
14	12	Buck-a-Shuck	$1 Oysters and Clams	Custom	\N	2026-07-01	2026-09-01	t	0	0	2026-06-18 17:18:49.453198-04	2026-06-18 17:18:49.453198-04
15	13	Appetizer Special 	Half off any appetizer when you buy 1 well drink	Custom	\N	\N	\N	t	0	0	2026-06-18 17:46:28.692254-04	2026-06-18 17:46:28.692254-04
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
4	4
5	1
6	1
6	4
7	3
8	4
9	1
10	1
12	1
13	1
15	1
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
7	7	Saturday	19:00:00	22:00:00
8	8	Sunday	10:00:00	17:00:00
9	9	Friday	11:00:00	20:00:00
10	10	Saturday	11:00:00	21:00:00
18	12	Monday	14:00:00	16:00:00
19	12	Tuesday	14:00:00	16:00:00
20	12	Wednesday	14:00:00	16:00:00
21	12	Thursday	14:00:00	16:00:00
22	12	Friday	14:00:00	16:00:00
23	13	Monday	14:00:00	16:00:00
24	13	Tuesday	14:00:00	16:00:00
25	13	Wednesday	14:00:00	16:00:00
26	13	Thursday	14:00:00	16:00:00
27	13	Friday	14:00:00	16:00:00
28	13	Saturday	14:00:00	16:00:00
29	13	Sunday	14:00:00	16:00:00
30	14	Tuesday	09:00:00	23:30:00
31	15	Monday	11:00:00	20:00:00
32	15	Tuesday	11:00:00	20:00:00
33	15	Wednesday	11:00:00	20:00:00
34	15	Thursday	11:00:00	20:00:00
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

SELECT pg_catalog.setval('public.business_businessid_seq', 14, true);


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

SELECT pg_catalog.setval('public.deal_dealid_seq', 18, true);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 229
-- Name: dealschedule_scheduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealschedule_scheduleid_seq', 49, true);


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


-- Completed on 2026-06-18 18:57:11

--
-- PostgreSQL database dump complete
--

\unrestrict z6io5hSXF7aOmPhX466WyhvlgWK8imbeJBFk9xUgfsFskKArYeQ7O0UsC5ilOJM

