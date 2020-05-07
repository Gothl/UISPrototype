--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Ubuntu 11.7-2.pgdg18.04+1)
-- Dumped by pg_dump version 11.7 (Ubuntu 11.7-2.pgdg18.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.accounts (
    account_number integer NOT NULL,
    created_date date,
    cpr_number integer
);


ALTER TABLE public.accounts OWNER TO gothlip;

--
-- Name: accounts_account_number_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.accounts_account_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_account_number_seq OWNER TO gothlip;

--
-- Name: accounts_account_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.accounts_account_number_seq OWNED BY public.accounts.account_number;


--
-- Name: certificates_of_deposit; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.certificates_of_deposit (
    cd_number integer NOT NULL,
    account_number integer,
    start_date date,
    amount integer,
    maturity_date date,
    rate integer
);


ALTER TABLE public.certificates_of_deposit OWNER TO gothlip;

--
-- Name: COLUMN certificates_of_deposit.rate; Type: COMMENT; Schema: public; Owner: gothlip
--

COMMENT ON COLUMN public.certificates_of_deposit.rate IS 'at fixed rate certificated´s of deposite';


--
-- Name: certificates_of_deposit_cd_number_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.certificates_of_deposit_cd_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.certificates_of_deposit_cd_number_seq OWNER TO gothlip;

--
-- Name: certificates_of_deposit_cd_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.certificates_of_deposit_cd_number_seq OWNED BY public.certificates_of_deposit.cd_number;


--
-- Name: checkingaccounts; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.checkingaccounts (
    account_number integer NOT NULL
);


ALTER TABLE public.checkingaccounts OWNER TO gothlip;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.customers (
    cpr_number integer NOT NULL,
    risk_type boolean DEFAULT false,
    password character varying(120),
    name character varying(60),
    address text
);


ALTER TABLE public.customers OWNER TO gothlip;

--
-- Name: deposits; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.deposits (
    id integer NOT NULL,
    account_number integer,
    amount integer,
    deposit_date date
);


ALTER TABLE public.deposits OWNER TO gothlip;

--
-- Name: deposits_id_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.deposits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deposits_id_seq OWNER TO gothlip;

--
-- Name: deposits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.deposits_id_seq OWNED BY public.deposits.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying(20),
    password character varying(120)
);


ALTER TABLE public.employees OWNER TO gothlip;

--
-- Name: investmentaccounts; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.investmentaccounts (
    account_number integer NOT NULL
);


ALTER TABLE public.investmentaccounts OWNER TO gothlip;

--
-- Name: investmentaccounts_account_number_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.investmentaccounts_account_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.investmentaccounts_account_number_seq OWNER TO gothlip;

--
-- Name: investmentaccounts_account_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.investmentaccounts_account_number_seq OWNED BY public.investmentaccounts.account_number;


--
-- Name: manages; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.manages (
    emp_cpr_number integer NOT NULL,
    account_number integer NOT NULL
);


ALTER TABLE public.manages OWNER TO gothlip;

--
-- Name: transfers; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.transfers (
    id integer NOT NULL,
    transfer_date date,
    amount integer,
    from_account integer,
    to_account integer
);


ALTER TABLE public.transfers OWNER TO gothlip;

--
-- Name: COLUMN transfers.from_account; Type: COMMENT; Schema: public; Owner: gothlip
--

COMMENT ON COLUMN public.transfers.from_account IS 'has origin';


--
-- Name: COLUMN transfers.to_account; Type: COMMENT; Schema: public; Owner: gothlip
--

COMMENT ON COLUMN public.transfers.to_account IS 'has destination';


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfers_id_seq OWNER TO gothlip;

--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- Name: vw_cd_sum; Type: VIEW; Schema: public; Owner: gothlip
--

CREATE VIEW public.vw_cd_sum AS
 SELECT i.account_number,
    a.cpr_number,
    a.created_date,
    sum(cd.amount) AS sum
   FROM ((public.investmentaccounts i
     JOIN public.accounts a ON ((i.account_number = a.account_number)))
     JOIN public.certificates_of_deposit cd ON ((i.account_number = cd.account_number)))
  GROUP BY i.account_number, a.cpr_number, a.created_date;


ALTER TABLE public.vw_cd_sum OWNER TO gothlip;

--
-- Name: withdraws; Type: TABLE; Schema: public; Owner: gothlip
--

CREATE TABLE public.withdraws (
    id integer NOT NULL,
    account_number integer,
    amount integer,
    withdraw_date date
);


ALTER TABLE public.withdraws OWNER TO gothlip;

--
-- Name: withdraws_id_seq; Type: SEQUENCE; Schema: public; Owner: gothlip
--

CREATE SEQUENCE public.withdraws_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.withdraws_id_seq OWNER TO gothlip;

--
-- Name: withdraws_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gothlip
--

ALTER SEQUENCE public.withdraws_id_seq OWNED BY public.withdraws.id;


--
-- Name: accounts account_number; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_number SET DEFAULT nextval('public.accounts_account_number_seq'::regclass);


--
-- Name: certificates_of_deposit cd_number; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.certificates_of_deposit ALTER COLUMN cd_number SET DEFAULT nextval('public.certificates_of_deposit_cd_number_seq'::regclass);


--
-- Name: deposits id; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.deposits ALTER COLUMN id SET DEFAULT nextval('public.deposits_id_seq'::regclass);


--
-- Name: investmentaccounts account_number; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.investmentaccounts ALTER COLUMN account_number SET DEFAULT nextval('public.investmentaccounts_account_number_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Name: withdraws id; Type: DEFAULT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.withdraws ALTER COLUMN id SET DEFAULT nextval('public.withdraws_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.accounts (account_number, created_date, cpr_number) FROM stdin;
8000	2018-06-01	5000
8001	2018-07-01	5000
8002	2018-08-01	5001
8003	2018-09-01	5001
8004	2018-10-01	5002
8005	2018-11-01	5002
8006	2018-12-01	5003
8007	2018-02-01	5003
8008	2018-03-01	5004
8009	2018-04-01	5004
8010	2018-05-01	5005
8011	2018-06-01	5005
8012	2018-07-01	5006
8013	2018-08-01	5006
8014	2018-09-01	5007
8015	2018-10-01	5007
\.


--
-- Data for Name: certificates_of_deposit; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.certificates_of_deposit (cd_number, account_number, start_date, amount, maturity_date, rate) FROM stdin;
1	8014	2020-04-30	10000	2020-04-30	\N
2	8014	2020-04-30	20000	2020-04-30	\N
3	8014	2020-04-30	40000	2020-04-30	\N
4	8014	2020-04-30	1000	2020-04-30	\N
5	8014	2020-04-30	2000	2020-04-30	\N
7000	8015	2020-04-30	10000	2020-04-30	\N
6	8013	2020-04-30	10000	2020-04-30	4
7001	8012	2020-04-30	10000	2020-04-30	5
\.


--
-- Data for Name: checkingaccounts; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.checkingaccounts (account_number) FROM stdin;
8000
8001
8002
8003
8004
8005
8006
8007
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.customers (cpr_number, risk_type, password, name, address) FROM stdin;
5000	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-DB3-C-Lasse	aud Auditorium A, bygning 1, 1. sal Universitetsparken 15 (Zoo)
5001	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-PD3-C-Anders	øv* Kursussal 1, bygning 3, 1.sal Universitetsparken 15 (Zoo)
5002	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-DB2-C-Ziming	øv 4032, Ole Maaløes Vej 5 (Biocenter)
5003	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-PD2-C-Hubert	øv Auditorium Syd, Nørre Alle 51
5004	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-DB1-C-Jan	øv A112, Universitetsparken 5, HCØ
5005	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-PD1-C-Marco	Aud 07, Universitetsparken 5, HCØ
5006	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-LE1-C-Marcos	AUD 02 in the HCØ building (HCØ, Universitetsparken 5)
5007	t	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO	UIS-LE2-C-Finn	AUD 02 in the HCØ building (HCØ, Universitetsparken 5)
\.


--
-- Data for Name: deposits; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.deposits (id, account_number, amount, deposit_date) FROM stdin;
1	\N	40960	2020-04-30
2	\N	81920	2020-04-30
3	\N	163840	2020-04-30
4	\N	327696	2020-04-30
5	\N	655392	2020-04-30
6	\N	1310784	2020-04-30
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.employees (id, name, password) FROM stdin;
6000	UIS-DB3-E-Lasse	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx
6001	UIS-PD3-E-Anders	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6002	UIS-DB2-E-Ziming	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6003	UIS-PD2-E-Hubert	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6004	UIS-DB1-E-Jan	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6005	UIS-PD1-E-Marco	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6006	UIS-LE1-E-Marcos	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
6007	UIS-LE2-E-Finn	$2b$12$KFkp1IEMGT4QrWwjPGhE3ejOv6Z3pYhx/S4qOoFbanR2sMiZqgeJO
\.


--
-- Data for Name: investmentaccounts; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.investmentaccounts (account_number) FROM stdin;
8008
8009
8010
8011
8012
8013
8014
8015
\.


--
-- Data for Name: manages; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.manages (emp_cpr_number, account_number) FROM stdin;
6000	8000
6000	8001
6001	8002
6001	8003
6002	8004
6002	8005
6003	8006
6003	8007
6004	8008
6004	8009
6005	8010
6005	8011
6006	8012
6006	8013
6007	8014
6007	8015
\.


--
-- Data for Name: transfers; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.transfers (id, transfer_date, amount, from_account, to_account) FROM stdin;
1	2020-04-30	10	8000	8001
2	2020-04-30	20	8009	8008
3	2020-04-30	40	8005	8006
4	2020-04-30	80	8003	8011
5	2020-04-30	160	8002	8003
6	2020-04-30	320	8004	8012
\.


--
-- Data for Name: withdraws; Type: TABLE DATA; Schema: public; Owner: gothlip
--

COPY public.withdraws (id, account_number, amount, withdraw_date) FROM stdin;
1	\N	20480	2020-04-30
2	\N	10240	2020-04-30
3	\N	5120	2020-04-30
4	\N	2560	2020-04-30
5	\N	1280	2020-04-30
6	\N	640	2020-04-30
\.


--
-- Name: accounts_account_number_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.accounts_account_number_seq', 1, false);


--
-- Name: certificates_of_deposit_cd_number_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.certificates_of_deposit_cd_number_seq', 6, true);


--
-- Name: deposits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.deposits_id_seq', 6, true);


--
-- Name: investmentaccounts_account_number_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.investmentaccounts_account_number_seq', 1, false);


--
-- Name: transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.transfers_id_seq', 6, true);


--
-- Name: withdraws_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gothlip
--

SELECT pg_catalog.setval('public.withdraws_id_seq', 6, true);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_number);


--
-- Name: certificates_of_deposit certificates_of_deposit_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.certificates_of_deposit
    ADD CONSTRAINT certificates_of_deposit_pkey PRIMARY KEY (cd_number);


--
-- Name: checkingaccounts checkingaccounts_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.checkingaccounts
    ADD CONSTRAINT checkingaccounts_pkey PRIMARY KEY (account_number);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (cpr_number);


--
-- Name: deposits deposits_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT deposits_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: investmentaccounts investmentaccounts_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.investmentaccounts
    ADD CONSTRAINT investmentaccounts_pkey PRIMARY KEY (account_number);


--
-- Name: manages pk_manages; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT pk_manages PRIMARY KEY (emp_cpr_number, account_number);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: withdraws withdraws_pkey; Type: CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.withdraws
    ADD CONSTRAINT withdraws_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_cpr_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_cpr_number_fkey FOREIGN KEY (cpr_number) REFERENCES public.customers(cpr_number);


--
-- Name: certificates_of_deposit certificates_of_deposit_account_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.certificates_of_deposit
    ADD CONSTRAINT certificates_of_deposit_account_number_fkey FOREIGN KEY (account_number) REFERENCES public.investmentaccounts(account_number);


--
-- Name: deposits deposits_account_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.deposits
    ADD CONSTRAINT deposits_account_number_fkey FOREIGN KEY (account_number) REFERENCES public.checkingaccounts(account_number);


--
-- Name: checkingaccounts fk_chacc_001; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.checkingaccounts
    ADD CONSTRAINT fk_chacc_001 FOREIGN KEY (account_number) REFERENCES public.accounts(account_number);


--
-- Name: investmentaccounts fk_inacc_001; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.investmentaccounts
    ADD CONSTRAINT fk_inacc_001 FOREIGN KEY (account_number) REFERENCES public.accounts(account_number);


--
-- Name: manages manages_account_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT manages_account_number_fkey FOREIGN KEY (account_number) REFERENCES public.accounts(account_number);


--
-- Name: manages manages_emp_cpr_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.manages
    ADD CONSTRAINT manages_emp_cpr_number_fkey FOREIGN KEY (emp_cpr_number) REFERENCES public.employees(id);


--
-- Name: transfers transfers_from_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_from_account_fkey FOREIGN KEY (from_account) REFERENCES public.accounts(account_number);


--
-- Name: transfers transfers_to_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_to_account_fkey FOREIGN KEY (to_account) REFERENCES public.accounts(account_number);


--
-- Name: withdraws withdraws_account_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gothlip
--

ALTER TABLE ONLY public.withdraws
    ADD CONSTRAINT withdraws_account_number_fkey FOREIGN KEY (account_number) REFERENCES public.checkingaccounts(account_number);


--
-- PostgreSQL database dump complete
--

