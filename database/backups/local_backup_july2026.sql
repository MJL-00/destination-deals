--
-- PostgreSQL database dump
--

\restrict 5b5rtuTdPZoCbZWxLaJGytKEy7dKIYaAEpbDvxuaQhY6tfMtA5dfXLnlJDcqFBU

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-07-18 11:46:41

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
-- TOC entry 241 (class 1255 OID 16747)
-- Name: fn_prospect_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fn_prospect_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_prospect_updated_at() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 16511)
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
    outdoor_dining boolean DEFAULT false NOT NULL,
    live_music boolean DEFAULT false NOT NULL,
    waterfront boolean DEFAULT false NOT NULL,
    pet_friendly boolean DEFAULT false NOT NULL,
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
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_businessid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_businessid_seq OWNED BY public.business.businessid;


--
-- TOC entry 239 (class 1259 OID 24905)
-- Name: business_click; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_click (
    clickid integer NOT NULL,
    businessid integer NOT NULL,
    click_type character varying(20) NOT NULL,
    device_id character varying(64),
    clicked_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT business_click_click_type_check CHECK (((click_type)::text = ANY ((ARRAY['website'::character varying, 'directions'::character varying])::text[])))
);


ALTER TABLE public.business_click OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 24904)
-- Name: business_click_clickid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.business_click_clickid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.business_click_clickid_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 238
-- Name: business_click_clickid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_click_clickid_seq OWNED BY public.business_click.clickid;


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
-- TOC entry 5158 (class 0 OID 0)
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
-- TOC entry 5159 (class 0 OID 0)
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
-- TOC entry 5160 (class 0 OID 0)
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
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 221
-- Name: location_locationid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_locationid_seq OWNED BY public.location.locationid;


--
-- TOC entry 237 (class 1259 OID 24892)
-- Name: page_view; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_view (
    viewid integer NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(50),
    ip_hash character varying(64),
    device_id character varying(64),
    viewed_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.page_view OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24891)
-- Name: page_view_viewid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_view_viewid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.page_view_viewid_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 236
-- Name: page_view_viewid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_view_viewid_seq OWNED BY public.page_view.viewid;


--
-- TOC entry 233 (class 1259 OID 16706)
-- Name: prospect; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prospect (
    prospectid integer NOT NULL,
    business_name character varying(150) NOT NULL,
    address character varying(255),
    city character varying(100),
    state character varying(50),
    phone character varying(20),
    website character varying(255),
    contact_name character varying(100),
    contact_email character varying(150),
    category_notes text,
    status character varying(30) DEFAULT 'not_approached'::character varying NOT NULL,
    assigned_to character varying(100),
    businessid integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    follow_up_date date,
    CONSTRAINT chk_prospect_status CHECK (((status)::text = ANY ((ARRAY['not_approached'::character varying, 'initial_contact_made'::character varying, 'follow_up_required'::character varying, 'waiting_for_response'::character varying, 'deal_setup_pending'::character varying, 'converted'::character varying, 'not_interested'::character varying, 'no_response'::character varying])::text[])))
);


ALTER TABLE public.prospect OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16729)
-- Name: prospect_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prospect_note (
    noteid integer NOT NULL,
    prospectid integer NOT NULL,
    note text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.prospect_note OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16728)
-- Name: prospect_note_noteid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prospect_note_noteid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prospect_note_noteid_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 234
-- Name: prospect_note_noteid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prospect_note_noteid_seq OWNED BY public.prospect_note.noteid;


--
-- TOC entry 232 (class 1259 OID 16705)
-- Name: prospect_prospectid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prospect_prospectid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prospect_prospectid_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 232
-- Name: prospect_prospectid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prospect_prospectid_seq OWNED BY public.prospect.prospectid;


--
-- TOC entry 4910 (class 2604 OID 16393)
-- Name: business businessid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business ALTER COLUMN businessid SET DEFAULT nextval('public.business_businessid_seq'::regclass);


--
-- TOC entry 4935 (class 2604 OID 24908)
-- Name: business_click clickid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_click ALTER COLUMN clickid SET DEFAULT nextval('public.business_click_clickid_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16427)
-- Name: category categoryid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN categoryid SET DEFAULT nextval('public.category_categoryid_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 16453)
-- Name: deal dealid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal ALTER COLUMN dealid SET DEFAULT nextval('public.deal_dealid_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 16468)
-- Name: dealschedule scheduleid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule ALTER COLUMN scheduleid SET DEFAULT nextval('public.dealschedule_scheduleid_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16402)
-- Name: location locationid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN locationid SET DEFAULT nextval('public.location_locationid_seq'::regclass);


--
-- TOC entry 4933 (class 2604 OID 24895)
-- Name: page_view viewid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_view ALTER COLUMN viewid SET DEFAULT nextval('public.page_view_viewid_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 16709)
-- Name: prospect prospectid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect ALTER COLUMN prospectid SET DEFAULT nextval('public.prospect_prospectid_seq'::regclass);


--
-- TOC entry 4931 (class 2604 OID 16732)
-- Name: prospect_note noteid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect_note ALTER COLUMN noteid SET DEFAULT nextval('public.prospect_note_noteid_seq'::regclass);


--
-- TOC entry 5131 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business (businessid, name, address, phone, website, subscription_tier, is_verified, directions_click_count, website_click_count, latitude, longitude, outdoor_dining, live_music, waterfront, pet_friendly) FROM stdin;
3	Twist and Shout Cocktail Bar	7 Bannister Wharf	4018464388	https://www.twistandshout-newport.com	Basic	t	0	0	41.486500	-71.323100	t	f	t	t
7	Ocean Breeze Cafe	150 Broadway	4018471122	https://www.oceanbreezenewport.com	Basic	f	1	0	41.488800	-71.314400	t	f	f	t
10	Bella Napoli	673 Thames St	4018482077	https://www.bellanapoli-newport.com	Basic	t	1	0	41.478900	-71.316200	f	f	f	f
14	Newport Surf Co.	182 Thames St	4018479933	https://www.newportsurfco.com	Basic	t	0	0	41.485700	-71.319700	f	f	f	f
19	Newport Kayak Center	9 Waites Wharf	4018453277	https://www.newportkayak.com	Basic	t	0	0	41.485700	-71.321900	f	f	t	t
22	Newport Heritage Center	25 Young St	4015552002	https://www.newportheritage.com	Basic	t	2	0	41.487800	-71.312400	f	f	f	f
23	Fort Adams State Park	90 Fort Adams Dr	4018410707	https://www.fortadams.org	Basic	t	0	0	41.470100	-71.339800	t	f	t	t
32	Senegal's Raw Bar	254 Thames St	4018468768	https://www.senegalsrawbar.com	Basic	t	5	0	41.483500	-71.310100	t	f	f	f
33	Maison Renard	960 Hope St	4014212485	https://www.maisonrenard.com	Premium	t	0	0	41.836800	-71.388600	t	f	f	f
34	The Colony Bar	122 Fountain St	4012731116	https://www.thecolonybar.com	Basic	t	0	0	41.821800	-71.413300	f	t	f	f
35	Faneuil Street Grille	1 Faneuil Hall Marketplace	6172271115	https://www.faneuilstreetgrille.com	Basic	t	0	0	42.360000	-71.056000	f	f	f	f
36	Jimbabwe Lighthouse Tours	1 Long Wharf	6172272628	https://www.jimbabwetours.com	Premium	t	0	0	42.359700	-71.049500	f	f	t	f
41	Brian's Duck Boat Tour	1 State St	6172291234	https://www.briansduckboat.com	Basic	t	1	1	42.358800	-71.057700	f	f	t	f
13	Elsa's Gifts on Bowens Wharf	5 Bowen Wharf	4018476622	https://www.elsasgifts.com	Basic	f	1	0	41.486600	-71.323200	f	f	t	f
15	Newport Sailing Adventures	22 Bowen Wharf	4015551002	https://www.newportsailing.com	Premium	t	4	4	41.486800	-71.323400	f	f	t	f
25	Cliff Walk Cafe	50 Memorial Blvd	4015551004	https://www.cliffwalkcafe.com	Basic	f	2	1	41.490200	-71.308900	t	f	f	f
16	Vintage Cruiseline Excursions	1 Bannister Wharf	4018470955	https://www.vintagecruiseline.com	Premium	t	1	3	41.486400	-71.323000	f	f	t	f
18	Nigel's Star Gazing Tours	35 East Bowery St	4015552001	https://www.stargazewithnigel.com	Basic	f	6	0	41.492300	-71.304100	f	f	f	f
20	Aquidneck Island Bike Tours	62 Broadway	4018476688	https://www.aquidneckbiketours.com	Basic	t	3	3	41.488900	-71.314100	f	f	f	t
8	Anchor & Vine Pub	140 Thames St	4018490111	https://www.anchorandvinepub.com	Premium	t	7	3	41.485300	-71.318800	f	t	f	f
2	Fagooli's Grille	1 Sayers Wharf	4018496664	https://www.fagoolis.com	Premium	t	2	1	41.487800	-71.324300	t	f	t	f
6	The Blue Macaw	348 Thames St	4018477427	https://www.thebluemacaw.com	Basic	t	1	1	41.483200	-71.317500	t	t	f	f
12	Newport Vintage Market	220 Bellevue Ave	4018473345	https://www.newportvintagemkt.com	Basic	t	0	1	41.480100	-71.306800	f	f	f	f
21	Family Fun Arcade	10 Americas Cup Ave	4015551003	https://www.familyfunarcade.com	Basic	t	2	4	41.486800	-71.313100	f	f	f	f
28	Hillside Grille	254 Thames St	4018468768	https://www.hillsidegrillenewport.com	Basic	t	1	3	41.483500	-71.318000	t	t	f	f
11	Thames Street Boutique	15 Thames St	4015551001	https://www.thamesboutique.com	Basic	t	3	1	41.485500	-71.319300	f	f	f	f
29	Bolt Coffee - Thames	404 Thames St	4018889999	https://www.boltcoffeenewport.com	Basic	t	2	3	41.482100	-71.317000	f	f	f	f
40	Mack's Music Store	174 Broadway	4018473388	https://www.macksmusicnewport.com	Basic	t	5	2	41.488400	-71.314600	f	t	f	f
30	Bolt Coffee - Broadway	228 Broadway	4015555552	https://www.boltcoffeenewport.com	Basic	t	1	0	41.488800	-71.314800	f	f	f	f
17	Cliff Walk Tours	175 Memorial Blvd	4018471177	https://www.cliffwalktours.com	Basic	t	1	1	41.491200	-71.304800	f	f	f	t
39	Arden Luxury Clothing Line	332 Thames St	4018476655	https://www.ardenluxury.com	Basic	t	8	7	41.482900	-71.317400	f	f	f	f
9	Casa del Sol	19 Charles St	4018495832	https://www.casadelsol-newport.com	Basic	t	3	2	41.484200	-71.317100	t	f	f	f
37	Wind Surf Newport	3 Waites Wharf	4018479922	https://www.windsurfnewport.com	Basic	t	7	8	41.485600	-71.321800	f	f	t	f
31	Mercantile Coffee	513 Broadway	4018858855	https://www.simplemerchant.com	Basic	t	3	0	41.489700	-71.315800	t	f	f	t
27	Andrew's Burgers	33 Howard St	4015552004	https://www.andrewsburgers.com	Basic	t	3	2	41.481200	-71.319800	f	f	f	f
38	Newport Nicknacks	108 Thames St	4018471234	https://www.newportnicknacks.com	Basic	t	4	3	41.485100	-71.319100	f	f	f	f
24	Shoreline Snack Shack	175 Memorial Blvd	4018477171	https://www.shorelinesnackshack.com	Basic	t	0	1	41.494100	-71.296800	t	f	f	t
5	Fluke Wine Bar & Kitchen	41 Bowen Wharf	4018494004	https://www.flukewineandkitchen.com	Basic	t	0	3	41.486300	-71.322900	f	t	f	f
26	Seafood by the Sea	100 Americas Cup Ave	4015552003	https://www.seafoodbythesea.com	Premium	t	5	4	41.486800	-71.313100	t	f	t	f
4	Up-a-Notch Kitchen	677 Thames St	4018463474	https://www.upanothcnewport.com	Premium	t	8	2	41.479100	-71.316300	f	t	f	f
1	Caroline's Oyster Bar	345 Thames St	4018472489	https://www.carolinesoysterbar.com	Premium	t	11	7	41.483100	-71.317600	t	t	f	f
\.


--
-- TOC entry 5150 (class 0 OID 24905)
-- Dependencies: 239
-- Data for Name: business_click; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_click (clickid, businessid, click_type, device_id, clicked_at) FROM stdin;
1	4	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:38:53.158746-04
2	4	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:38:55.972044-04
3	16	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:39:01.103811-04
4	16	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:39:04.043332-04
5	4	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:47:59.698172-04
6	4	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:48:02.616788-04
7	4	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:48:05.009526-04
8	4	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:48:06.978201-04
9	16	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:48:09.848181-04
10	16	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:48:13.885133-04
11	8	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:31.398449-04
12	8	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:34.900086-04
13	15	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:38.82798-04
14	15	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:41.03219-04
15	15	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:43.591613-04
16	15	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:46.240741-04
17	15	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:48.418788-04
18	15	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:50.590999-04
19	15	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:52.566483-04
20	15	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:54.91828-04
21	26	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:57.710317-04
22	26	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:53:59.82437-04
23	26	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:03.833547-04
24	26	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:05.88925-04
25	26	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:07.728947-04
26	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:10.641712-04
27	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:13.622693-04
28	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:16.178403-04
29	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:18.227559-04
30	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:20.329187-04
31	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:22.366331-04
32	1	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:24.970474-04
33	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:27.554233-04
34	1	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:29.318507-04
35	1	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:33.485802-04
36	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:37.927928-04
37	1	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:40.609877-04
38	1	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:42.566985-04
39	2	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:45.530417-04
40	2	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:48.119329-04
41	2	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:51.500817-04
42	6	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:54:55.563312-04
43	21	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:00.537016-04
44	21	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:02.832198-04
45	21	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:04.945743-04
46	21	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:07.153016-04
47	21	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:08.91708-04
48	20	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:11.851993-04
49	20	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:14.533391-04
50	20	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:16.829548-04
51	20	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:19.257343-04
52	12	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:22.413201-04
53	25	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:27.572638-04
54	25	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:29.808385-04
55	25	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:33.336665-04
56	40	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:37.836504-04
57	40	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:40.087721-04
58	40	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:42.439945-04
59	40	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:44.458631-04
60	39	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:47.561785-04
61	39	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:49.546595-04
62	39	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:51.788544-04
63	39	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:54.522293-04
64	39	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:56.736116-04
65	39	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:55:58.729309-04
66	39	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:00.831908-04
67	29	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:04.189784-04
68	29	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:06.484319-04
69	29	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:08.743126-04
70	29	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:11.206181-04
71	17	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:13.751012-04
72	17	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:15.962443-04
73	9	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:25.652103-04
74	9	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:27.632638-04
75	9	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:30.165423-04
76	9	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:33.297331-04
77	9	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:36.614836-04
78	18	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:40.773783-04
79	18	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:43.229524-04
80	11	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:46.780484-04
81	11	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:49.550733-04
82	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:53.590841-04
83	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:56.366887-04
84	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:56:58.864842-04
85	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:02.479323-04
86	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:04.780854-04
87	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:07.657246-04
88	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:10.082027-04
89	37	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:12.195479-04
90	37	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:14.447696-04
91	37	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:17.59212-04
92	37	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:19.933445-04
93	37	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:21.970105-04
94	28	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:24.767868-04
95	28	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:26.658973-04
96	28	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:29.444397-04
97	28	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:31.612929-04
98	38	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:34.28694-04
99	38	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:36.749075-04
100	38	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:39.11405-04
101	38	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:41.164174-04
102	24	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:45.34263-04
103	30	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:49.037529-04
104	27	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:57:58.128101-04
105	27	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:58:00.882375-04
106	5	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:58:04.380827-04
107	5	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:58:06.55851-04
108	5	website	dev_uapto6im2qymjt1s837ns	2026-06-26 12:58:09.260918-04
109	31	directions	dev_uapto6im2qymjt1s837ns	2026-06-26 12:58:13.144784-04
110	26	directions	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:02.591421-04
111	26	website	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:09.738743-04
112	26	website	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:15.241747-04
113	4	directions	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:19.168198-04
114	1	website	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:22.500279-04
115	1	website	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:24.775747-04
116	1	directions	dev_uapto6im2qymjt1s837ns	2026-07-18 11:12:29.841564-04
117	1	website	dev_uapto6im2qymjt1s837ns	2026-07-18 11:13:33.443723-04
118	1	directions	dev_uapto6im2qymjt1s837ns	2026-07-18 11:13:35.836712-04
\.


--
-- TOC entry 5137 (class 0 OID 16432)
-- Dependencies: 226
-- Data for Name: businesscategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.businesscategory (businessid, categoryid) FROM stdin;
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
11	2
12	2
13	2
14	2
15	3
16	3
17	3
18	3
19	3
20	3
21	4
22	4
23	4
24	4
25	1
25	4
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	1
34	1
35	1
36	3
37	3
37	4
38	2
39	2
40	2
41	3
41	4
\.


--
-- TOC entry 5134 (class 0 OID 16406)
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
11	1
12	1
13	1
14	1
15	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
27	1
28	1
29	1
30	1
31	1
32	1
33	2
34	2
35	5
36	5
37	1
38	1
39	1
40	1
41	5
\.


--
-- TOC entry 5136 (class 0 OID 16424)
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
-- TOC entry 5139 (class 0 OID 16450)
-- Dependencies: 228
-- Data for Name: deal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deal (dealid, businessid, title, description, discounttype, discountvalue, startdate, enddate, isactive, click_count, redemption_count, created_at, updated_at) FROM stdin;
1	1	Happy Hour	20% off all drinks 4-6pm	Percent	20.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
2	1	Half Off Appetizers	50% off all appetizers Mon-Thu 2-4pm	Percent	50.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
3	2	Sunset Dinner Special	$15 off any entree after 7pm	Flat	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
4	2	Lobster Roll Monday	Market price lobster rolls every Monday	Custom	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
5	3	Cocktail Hour Special	10% off brunch for parties of 4 or more	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
6	4	Date Night Special	$20 off when you spend $80 or more	Flat	20.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
7	4	Tasting Menu Tuesday	15% off the full tasting menu on Tuesdays	Percent	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
8	5	Wine Wednesday	25% off all bottles every Wednesday	Percent	25.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
9	6	Live Music Happy Hour	BOGO cocktails during live music sets	BOGO	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
10	7	Breakfast Combo	10% off any breakfast combo before 11am	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
11	8	Pub Night Special	$5 off any burger and beer combo	Flat	5.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
12	8	Wing Wednesday	Half price wings every Wednesday night	Percent	50.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
13	9	Taco Tuesday	$2 tacos all day every Tuesday	Flat	2.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
14	10	Family Sunday Supper	15% off for tables of 6 or more on Sundays	Percent	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
15	11	Buy One Get One	Buy one shirt get one 50% off	Percent	50.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
16	12	Weekend Discount	10% off any single item every weekend	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
17	13	Summer Clearance	20% off all sale items	Percent	20.00	2026-06-20	2026-08-31	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
18	14	Rental Deal	$5 off any equipment rental on weekdays	Flat	5.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
19	15	Sunset Cruise Special	$15 off any sailing trip booking	Flat	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
20	15	Morning Sail Discount	20% off morning departures before 10am	Percent	20.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
21	16	Sunset Cruise	$10 off per person on sunset cruise tickets	Flat	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
22	17	Group Tour Deal	15% off for groups of 8 or more	Percent	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
23	18	Evening Telescope Tour	25% off any evening stargazing tour	Percent	25.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
24	19	Kayak Rental Special	$10 off 2-hour kayak rentals on weekdays	Flat	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
25	20	Bike Tour Bundle	$5 off per person for groups of 4 or more	Flat	5.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
26	21	Family Game Night	Unlimited arcade play for $20 per person	Flat	20.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
27	22	Museum Admission	$5 off general admission any day	Flat	5.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
28	23	Summer Festival Pass	20% off event tickets purchased in advance	Percent	20.00	2026-07-01	2026-08-31	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
29	24	Beach Day Combo	Free drink with any food order over $15	Custom	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
30	25	Breakfast Combo	10% off all breakfast combos	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
31	25	Kids Eat Free	One free kids meal per adult entree	Flat	0.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
32	26	Lobster Roll Special	15% off lobster rolls every weekend	Percent	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
33	27	Burger Combo Deal	Free fries with any combo purchase	Flat	0.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
34	28	Happy Hour Appetizers	Half off any appetizer with 1 well drink	Percent	50.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
35	29	Morning Cold Brew Deal	$1 off any nitro cold brew before 10am	Flat	1.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
36	30	Morning Coffee Special	$1 off any nitro drink before 10am	Flat	1.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
37	31	Loyalty Stamp Card	Buy 9 coffees get the 10th free	Custom	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
38	32	Senegal's Raw Bar Hour	$1 oysters and clams 3-6pm daily	Custom	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
39	33	Pre-Theatre Menu	3-course dinner for $45 before 6pm	Flat	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
40	34	Happy Hour	2-for-1 craft cocktails every weekday	BOGO	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
41	35	Lunch Special	10% off any order over $20 at lunch	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
42	36	Jimbabwe Sunset Tour	$12 off per person on the sunset cruise	Flat	12.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
43	37	Beginner Lesson Deal	20% off your first windsurfing lesson	Percent	20.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
44	37	Family Surf Package	$25 off group lessons for 3 or more	Flat	25.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
45	38	Buy 2 Get 1 Free	Buy any two get the third free	BOGO	\N	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
46	39	Luxury Friday	15% off all purchases every Friday	Percent	15.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
47	39	Summer Luxury Sale	20% off all summer luxury items	Percent	20.00	2026-06-21	2026-08-31	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
48	40	String Section Special	10% off all string instruments	Percent	10.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
49	41	Family Duck Boat Deal	$8 off per person for families of 4+	Flat	8.00	\N	\N	t	0	0	2026-06-19 10:27:56-04	2026-06-19 10:27:56-04
\.


--
-- TOC entry 5142 (class 0 OID 16477)
-- Dependencies: 231
-- Data for Name: dealcategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealcategory (dealid, categoryid) FROM stdin;
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
11	1
12	1
13	1
14	1
15	2
16	2
17	2
18	2
19	3
20	3
21	3
22	3
23	3
24	3
25	3
26	4
27	4
28	4
29	4
30	1
31	1
31	4
32	1
33	1
34	1
35	1
36	1
37	1
38	1
39	1
40	1
41	1
42	3
43	3
43	4
44	3
44	4
45	2
46	2
47	2
48	2
49	3
49	4
\.


--
-- TOC entry 5141 (class 0 OID 16465)
-- Dependencies: 230
-- Data for Name: dealschedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealschedule (scheduleid, dealid, dayofweek, starttime, endtime) FROM stdin;
1	1	Monday	16:00:00	18:00:00
2	1	Tuesday	16:00:00	18:00:00
3	1	Wednesday	16:00:00	18:00:00
4	1	Thursday	16:00:00	18:00:00
5	1	Friday	16:00:00	18:00:00
6	2	Monday	14:00:00	16:00:00
7	2	Tuesday	14:00:00	16:00:00
8	2	Wednesday	14:00:00	16:00:00
9	2	Thursday	14:00:00	16:00:00
10	3	Sunday	19:00:00	22:00:00
11	3	Monday	19:00:00	22:00:00
12	3	Tuesday	19:00:00	22:00:00
13	3	Wednesday	19:00:00	22:00:00
14	3	Thursday	19:00:00	22:00:00
15	3	Friday	19:00:00	22:00:00
16	3	Saturday	19:00:00	22:00:00
17	4	Monday	11:00:00	21:00:00
18	5	Saturday	10:00:00	14:00:00
19	5	Sunday	10:00:00	14:00:00
20	6	Thursday	17:00:00	22:00:00
21	6	Friday	17:00:00	22:00:00
22	6	Saturday	17:00:00	22:00:00
23	7	Tuesday	17:00:00	22:00:00
24	8	Wednesday	17:00:00	22:00:00
25	9	Friday	17:00:00	19:00:00
26	9	Saturday	17:00:00	19:00:00
27	10	Monday	07:00:00	11:00:00
28	10	Tuesday	07:00:00	11:00:00
29	10	Wednesday	07:00:00	11:00:00
30	10	Thursday	07:00:00	11:00:00
31	10	Friday	07:00:00	11:00:00
32	10	Saturday	07:00:00	11:00:00
33	10	Sunday	07:00:00	11:00:00
34	11	Thursday	17:00:00	22:00:00
35	11	Friday	17:00:00	22:00:00
36	12	Wednesday	17:00:00	22:00:00
37	13	Tuesday	11:00:00	21:00:00
38	14	Sunday	15:00:00	21:00:00
39	15	Saturday	10:00:00	18:00:00
40	16	Saturday	10:00:00	18:00:00
41	16	Sunday	10:00:00	18:00:00
42	17	Monday	10:00:00	18:00:00
43	17	Tuesday	10:00:00	18:00:00
44	17	Wednesday	10:00:00	18:00:00
45	17	Thursday	10:00:00	18:00:00
46	17	Friday	10:00:00	18:00:00
47	17	Saturday	10:00:00	18:00:00
48	17	Sunday	10:00:00	18:00:00
49	18	Monday	09:00:00	17:00:00
50	18	Tuesday	09:00:00	17:00:00
51	18	Wednesday	09:00:00	17:00:00
52	18	Thursday	09:00:00	17:00:00
53	18	Friday	09:00:00	17:00:00
54	19	Sunday	17:00:00	20:00:00
55	19	Wednesday	17:00:00	20:00:00
56	19	Friday	17:00:00	20:00:00
57	20	Saturday	08:00:00	10:00:00
58	20	Sunday	08:00:00	10:00:00
59	21	Friday	18:00:00	20:00:00
60	21	Saturday	18:00:00	20:00:00
61	21	Sunday	18:00:00	20:00:00
62	22	Saturday	09:00:00	17:00:00
63	22	Sunday	09:00:00	17:00:00
64	23	Saturday	20:00:00	23:00:00
65	24	Monday	09:00:00	17:00:00
66	24	Tuesday	09:00:00	17:00:00
67	24	Wednesday	09:00:00	17:00:00
68	24	Thursday	09:00:00	17:00:00
69	24	Friday	09:00:00	17:00:00
70	25	Saturday	09:00:00	16:00:00
71	25	Sunday	09:00:00	16:00:00
72	26	Friday	18:00:00	22:00:00
73	26	Saturday	18:00:00	22:00:00
74	27	Monday	10:00:00	17:00:00
75	27	Tuesday	10:00:00	17:00:00
76	27	Wednesday	10:00:00	17:00:00
77	27	Thursday	10:00:00	17:00:00
78	27	Friday	10:00:00	17:00:00
79	27	Saturday	10:00:00	17:00:00
80	27	Sunday	10:00:00	17:00:00
81	28	Saturday	10:00:00	18:00:00
82	28	Sunday	10:00:00	18:00:00
83	29	Saturday	10:00:00	18:00:00
84	29	Sunday	10:00:00	18:00:00
85	30	Monday	07:00:00	11:00:00
86	30	Tuesday	07:00:00	11:00:00
87	30	Wednesday	07:00:00	11:00:00
88	30	Thursday	07:00:00	11:00:00
89	30	Friday	07:00:00	11:00:00
90	30	Saturday	07:00:00	11:00:00
91	30	Sunday	07:00:00	11:00:00
92	31	Sunday	12:00:00	20:00:00
93	32	Saturday	11:00:00	21:00:00
94	32	Sunday	11:00:00	21:00:00
95	33	Saturday	11:00:00	21:00:00
96	34	Monday	16:00:00	21:00:00
97	34	Tuesday	16:00:00	21:00:00
98	34	Wednesday	16:00:00	21:00:00
99	34	Thursday	16:00:00	21:00:00
100	34	Friday	16:00:00	21:00:00
101	34	Saturday	16:00:00	21:00:00
102	34	Sunday	16:00:00	21:00:00
103	35	Monday	07:00:00	10:00:00
104	35	Tuesday	07:00:00	10:00:00
105	35	Wednesday	07:00:00	10:00:00
106	35	Thursday	07:00:00	10:00:00
107	35	Friday	07:00:00	10:00:00
108	35	Saturday	07:00:00	10:00:00
109	35	Sunday	07:00:00	10:00:00
110	36	Monday	07:00:00	10:00:00
111	36	Tuesday	07:00:00	10:00:00
112	36	Wednesday	07:00:00	10:00:00
113	36	Thursday	07:00:00	10:00:00
114	36	Friday	07:00:00	10:00:00
115	36	Saturday	07:00:00	10:00:00
116	36	Sunday	07:00:00	10:00:00
117	37	Monday	07:00:00	17:00:00
118	37	Tuesday	07:00:00	17:00:00
119	37	Wednesday	07:00:00	17:00:00
120	37	Thursday	07:00:00	17:00:00
121	37	Friday	07:00:00	17:00:00
122	37	Saturday	08:00:00	17:00:00
123	37	Sunday	08:00:00	17:00:00
124	38	Sunday	15:00:00	18:00:00
125	38	Monday	15:00:00	18:00:00
126	38	Tuesday	15:00:00	18:00:00
127	38	Wednesday	15:00:00	18:00:00
128	38	Thursday	15:00:00	18:00:00
129	38	Friday	15:00:00	18:00:00
130	38	Saturday	15:00:00	18:00:00
131	39	Thursday	17:00:00	18:00:00
132	39	Friday	17:00:00	18:00:00
133	39	Saturday	17:00:00	18:00:00
134	40	Monday	16:00:00	18:00:00
135	40	Tuesday	16:00:00	18:00:00
136	40	Wednesday	16:00:00	18:00:00
137	40	Thursday	16:00:00	18:00:00
138	40	Friday	16:00:00	18:00:00
139	41	Monday	11:00:00	14:00:00
140	41	Tuesday	11:00:00	14:00:00
141	41	Wednesday	11:00:00	14:00:00
142	41	Thursday	11:00:00	14:00:00
143	41	Friday	11:00:00	14:00:00
144	42	Friday	18:00:00	20:00:00
145	42	Saturday	18:00:00	20:00:00
146	42	Sunday	18:00:00	20:00:00
147	43	Saturday	09:00:00	17:00:00
148	43	Sunday	09:00:00	17:00:00
149	44	Saturday	09:00:00	17:00:00
150	44	Sunday	09:00:00	17:00:00
151	45	Monday	10:00:00	18:00:00
152	45	Tuesday	10:00:00	18:00:00
153	45	Wednesday	10:00:00	18:00:00
154	45	Thursday	10:00:00	18:00:00
155	45	Friday	10:00:00	18:00:00
156	45	Saturday	10:00:00	18:00:00
157	45	Sunday	10:00:00	18:00:00
158	46	Friday	11:00:00	18:00:00
159	47	Monday	11:00:00	18:00:00
160	47	Tuesday	11:00:00	18:00:00
161	47	Wednesday	11:00:00	18:00:00
162	47	Thursday	11:00:00	18:00:00
163	47	Friday	11:00:00	18:00:00
164	47	Saturday	11:00:00	18:00:00
165	47	Sunday	11:00:00	18:00:00
166	48	Monday	10:00:00	18:00:00
167	48	Tuesday	10:00:00	18:00:00
168	48	Wednesday	10:00:00	18:00:00
169	48	Thursday	10:00:00	18:00:00
170	48	Friday	10:00:00	18:00:00
171	48	Saturday	10:00:00	18:00:00
172	48	Sunday	10:00:00	18:00:00
173	49	Monday	09:00:00	17:00:00
174	49	Tuesday	09:00:00	17:00:00
175	49	Wednesday	09:00:00	17:00:00
176	49	Thursday	09:00:00	17:00:00
177	49	Friday	09:00:00	17:00:00
178	49	Saturday	09:00:00	17:00:00
179	49	Sunday	09:00:00	17:00:00
\.


--
-- TOC entry 5133 (class 0 OID 16399)
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
-- TOC entry 5148 (class 0 OID 24892)
-- Dependencies: 237
-- Data for Name: page_view; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_view (viewid, city, state, ip_hash, device_id, viewed_at) FROM stdin;
1	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-06-26 11:09:47.708691-04
2	Narragansett	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-06-26 11:10:02.543629-04
3	Boston	MA	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-06-26 11:10:10.134931-04
4	Mystic	CT	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-06-26 11:46:00.718519-04
5	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 10:45:20.035919-04
6	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_p7cee5l2clg6odcn1x326	2026-07-11 10:52:37.998976-04
7	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:14:13.992992-04
8	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:16:26.460683-04
9	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:18:51.535462-04
10	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:29:05.541382-04
11	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:37:06.581374-04
12	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:41:40.153045-04
13	Providence	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:44:10.655168-04
14	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:44:12.653758-04
15	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 21:44:18.069306-04
16	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-11 22:02:52.416398-04
17	Newport	RI	eff8e7ca506627fe15dda5e0e512fcaad70b6d520f37cc76597fdb4f2d83a1a3	dev_uapto6im2qymjt1s837ns	2026-07-18 11:11:58.668103-04
\.


--
-- TOC entry 5144 (class 0 OID 16706)
-- Dependencies: 233
-- Data for Name: prospect; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prospect (prospectid, business_name, address, city, state, phone, website, contact_name, contact_email, category_notes, status, assigned_to, businessid, created_at, updated_at, follow_up_date) FROM stdin;
1	Pat's Art Gallery	216 Broadway	Newport	RI	4018186000	patspics.com	\N	\N	\N	follow_up_required	\N	\N	2026-06-19 16:36:57-04	2026-06-19 16:54:40-04	2026-07-01
3	DanBo's Wood Carving	18 Webster St	Newport	RI	4013131100	danboswoodvarving.com	Daniel	\N	\N	waiting_for_response	\N	\N	2026-06-19 16:42:53-04	2026-06-19 16:43:51-04	2026-06-23
4	Scurvy Pirate Snorkeling	118 bannisters wharf	Newport	RI	4019790221	scurvypiratesnorkeling.com	\N	\N	\N	not_approached	\N	\N	2026-06-19 16:45:02-04	2026-06-19 16:45:02-04	\N
5	SteepHeart Glass Blowing	299 Thames St	Newport	RI	4015663222	steepheartglass.com	\N	\N	\N	not_approached	\N	\N	2026-06-19 16:46:24-04	2026-06-19 16:46:46-04	\N
6	Artemis Helo Tours	117 Bellevue Ave	Newport	RI	4014011000	artemishelo.com	\N	\N	\N	not_approached	\N	\N	2026-06-19 16:49:33-04	2026-06-19 16:49:33-04	\N
2	Tommy's Pizza	19 East Bowery	Newport	RI	4017172000	tommyspizza.com	Tom	tommyspizza@gmail.com	\N	deal_setup_pending	\N	\N	2026-06-19 16:40:08-04	2026-07-18 11:24:05.105842-04	\N
\.


--
-- TOC entry 5146 (class 0 OID 16729)
-- Dependencies: 235
-- Data for Name: prospect_note; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prospect_note (noteid, prospectid, note, created_at) FROM stdin;
1	1	initial contact made; semi-interested. follow up by 7/1	2026-06-19 16:37:16-04
2	2	Met with tommy from tommys pizza. he said circle back in 1 month	2026-06-19 16:40:31-04
3	2	Agreed to make a meeting. waiting for the Managers schedule to pick a date	2026-06-19 16:40:43-04
4	2	agreed to join.	2026-06-19 16:40:54-04
5	3	Met with dan, said he was interested and he would call me back by 6/25.	2026-06-19 16:43:22-04
\.


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 219
-- Name: business_businessid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_businessid_seq', 41, true);


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 238
-- Name: business_click_clickid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_click_clickid_seq', 118, true);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 224
-- Name: category_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_categoryid_seq', 4, true);


--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 227
-- Name: deal_dealid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deal_dealid_seq', 49, true);


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 229
-- Name: dealschedule_scheduleid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealschedule_scheduleid_seq', 179, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 221
-- Name: location_locationid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.location_locationid_seq', 6, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 236
-- Name: page_view_viewid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_view_viewid_seq', 17, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 234
-- Name: prospect_note_noteid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prospect_note_noteid_seq', 5, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 232
-- Name: prospect_prospectid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prospect_prospectid_seq', 6, true);


--
-- TOC entry 4967 (class 2606 OID 24916)
-- Name: business_click business_click_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_click
    ADD CONSTRAINT business_click_pkey PRIMARY KEY (clickid);


--
-- TOC entry 4941 (class 2606 OID 16397)
-- Name: business business_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_pkey PRIMARY KEY (businessid);


--
-- TOC entry 4949 (class 2606 OID 16438)
-- Name: businesscategory businesscategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_pkey PRIMARY KEY (businessid, categoryid);


--
-- TOC entry 4945 (class 2606 OID 16412)
-- Name: businesslocation businesslocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_pkey PRIMARY KEY (businessid, locationid);


--
-- TOC entry 4947 (class 2606 OID 16431)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (categoryid);


--
-- TOC entry 4951 (class 2606 OID 16458)
-- Name: deal deal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal
    ADD CONSTRAINT deal_pkey PRIMARY KEY (dealid);


--
-- TOC entry 4955 (class 2606 OID 16483)
-- Name: dealcategory dealcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_pkey PRIMARY KEY (dealid, categoryid);


--
-- TOC entry 4953 (class 2606 OID 16471)
-- Name: dealschedule dealschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule
    ADD CONSTRAINT dealschedule_pkey PRIMARY KEY (scheduleid);


--
-- TOC entry 4943 (class 2606 OID 16405)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (locationid);


--
-- TOC entry 4965 (class 2606 OID 24901)
-- Name: page_view page_view_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_view
    ADD CONSTRAINT page_view_pkey PRIMARY KEY (viewid);


--
-- TOC entry 4961 (class 2606 OID 16741)
-- Name: prospect_note prospect_note_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect_note
    ADD CONSTRAINT prospect_note_pkey PRIMARY KEY (noteid);


--
-- TOC entry 4958 (class 2606 OID 16722)
-- Name: prospect prospect_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect
    ADD CONSTRAINT prospect_pkey PRIMARY KEY (prospectid);


--
-- TOC entry 4968 (class 1259 OID 24922)
-- Name: idx_bclick_business_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bclick_business_date ON public.business_click USING btree (businessid, clicked_at);


--
-- TOC entry 4969 (class 1259 OID 24923)
-- Name: idx_bclick_device; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bclick_device ON public.business_click USING btree (device_id, businessid, clicked_at);


--
-- TOC entry 4962 (class 1259 OID 24902)
-- Name: idx_pageview_city_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pageview_city_date ON public.page_view USING btree (city, viewed_at);


--
-- TOC entry 4963 (class 1259 OID 24903)
-- Name: idx_pageview_device_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pageview_device_city ON public.page_view USING btree (device_id, city, viewed_at);


--
-- TOC entry 4959 (class 1259 OID 16750)
-- Name: idx_prospect_note_pid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_prospect_note_pid ON public.prospect_note USING btree (prospectid);


--
-- TOC entry 4956 (class 1259 OID 16749)
-- Name: idx_prospect_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_prospect_status ON public.prospect USING btree (status);


--
-- TOC entry 4981 (class 2620 OID 16512)
-- Name: deal trg_deal_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_deal_updated_at BEFORE UPDATE ON public.deal FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- TOC entry 4982 (class 2620 OID 16751)
-- Name: prospect trg_prospect_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_prospect_updated_at BEFORE UPDATE ON public.prospect FOR EACH ROW EXECUTE FUNCTION public.fn_prospect_updated_at();


--
-- TOC entry 4980 (class 2606 OID 24917)
-- Name: business_click business_click_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_click
    ADD CONSTRAINT business_click_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid) ON DELETE CASCADE;


--
-- TOC entry 4972 (class 2606 OID 16439)
-- Name: businesscategory businesscategory_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4973 (class 2606 OID 16444)
-- Name: businesscategory businesscategory_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesscategory
    ADD CONSTRAINT businesscategory_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.category(categoryid);


--
-- TOC entry 4970 (class 2606 OID 16413)
-- Name: businesslocation businesslocation_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4971 (class 2606 OID 16418)
-- Name: businesslocation businesslocation_locationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.businesslocation
    ADD CONSTRAINT businesslocation_locationid_fkey FOREIGN KEY (locationid) REFERENCES public.location(locationid);


--
-- TOC entry 4974 (class 2606 OID 16459)
-- Name: deal deal_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal
    ADD CONSTRAINT deal_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid);


--
-- TOC entry 4976 (class 2606 OID 16489)
-- Name: dealcategory dealcategory_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.category(categoryid);


--
-- TOC entry 4977 (class 2606 OID 16484)
-- Name: dealcategory dealcategory_dealid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealcategory
    ADD CONSTRAINT dealcategory_dealid_fkey FOREIGN KEY (dealid) REFERENCES public.deal(dealid);


--
-- TOC entry 4975 (class 2606 OID 16472)
-- Name: dealschedule dealschedule_dealid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealschedule
    ADD CONSTRAINT dealschedule_dealid_fkey FOREIGN KEY (dealid) REFERENCES public.deal(dealid);


--
-- TOC entry 4978 (class 2606 OID 16723)
-- Name: prospect prospect_businessid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect
    ADD CONSTRAINT prospect_businessid_fkey FOREIGN KEY (businessid) REFERENCES public.business(businessid) ON DELETE SET NULL;


--
-- TOC entry 4979 (class 2606 OID 16742)
-- Name: prospect_note prospect_note_prospectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prospect_note
    ADD CONSTRAINT prospect_note_prospectid_fkey FOREIGN KEY (prospectid) REFERENCES public.prospect(prospectid) ON DELETE CASCADE;


-- Completed on 2026-07-18 11:46:42

--
-- PostgreSQL database dump complete
--

\unrestrict 5b5rtuTdPZoCbZWxLaJGytKEy7dKIYaAEpbDvxuaQhY6tfMtA5dfXLnlJDcqFBU

