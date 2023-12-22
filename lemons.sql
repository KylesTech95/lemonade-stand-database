--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5 (Debian 15.5-1.pgdg110+1)
-- Dumped by pg_dump version 15.5 (Debian 15.5-1.pgdg110+1)

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

DROP DATABASE lemonade;
--
-- Name: lemonade; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE lemonade WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE lemonade OWNER TO postgres;

\connect lemonade

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

SET default_table_access_method = heap;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(15),
    first_lemon character varying(15),
    second_lemon character varying(15)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id integer NOT NULL,
    available boolean DEFAULT true,
    lemons character varying(15),
    customer_lemons_id integer
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_product_id_seq OWNER TO postgres;

--
-- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product.product_id;


--
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    transaction_id integer NOT NULL,
    price numeric(3,2) DEFAULT 3.50,
    payment_received numeric(4,2),
    product_id integer NOT NULL,
    customer_id integer NOT NULL,
    quantity_bought integer NOT NULL
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_transaction_id_seq OWNER TO postgres;

--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_transaction_id_seq OWNED BY public.transaction.transaction_id;


--
-- Name: view_all_updated; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.view_all_updated AS
 SELECT transaction.customer_id,
    product.product_id,
    product.available,
    product.lemons,
    product.customer_lemons_id,
    transaction.transaction_id,
    transaction.price,
    transaction.payment_received,
    transaction.quantity_bought,
    customers.name,
    customers.first_lemon,
    customers.second_lemon
   FROM ((public.product
     JOIN public.transaction USING (product_id))
     JOIN public.customers USING (customer_id));


ALTER TABLE public.view_all_updated OWNER TO postgres;

--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: product product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN product_id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


--
-- Name: transaction transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN transaction_id SET DEFAULT nextval('public.transaction_transaction_id_seq'::regclass);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (1, 'Kyle', 'Eureka', 'Myer');
INSERT INTO public.customers VALUES (2, 'Sam', 'Bearss', 'Eureka');
INSERT INTO public.customers VALUES (3, 'Craig', 'Lisbon', NULL);
INSERT INTO public.customers VALUES (4, 'mason', 'Limetta', 'Myer');
INSERT INTO public.customers VALUES (5, 'Grain', 'Primoiori', 'Limetta');
INSERT INTO public.customers VALUES (6, 'tammy', 'Lisbon', 'Lisbon');
INSERT INTO public.customers VALUES (7, 'Martin', 'Verna', NULL);
INSERT INTO public.customers VALUES (8, 'nathan', 'Lisbon', NULL);
INSERT INTO public.customers VALUES (9, 'Jackyl', 'Myer', NULL);
INSERT INTO public.customers VALUES (10, 'kyon', 'Eureka', NULL);
INSERT INTO public.customers VALUES (11, 'Bryan', 'Bearss', NULL);
INSERT INTO public.customers VALUES (12, 'nute', 'Bearss', NULL);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES (1, true, 'Lisbon', NULL);
INSERT INTO public.product VALUES (2, true, 'Eureka', NULL);
INSERT INTO public.product VALUES (3, true, 'Myer', NULL);
INSERT INTO public.product VALUES (4, true, 'Bearss', NULL);
INSERT INTO public.product VALUES (5, true, 'Limetta', NULL);
INSERT INTO public.product VALUES (6, true, 'Primoiori', NULL);
INSERT INTO public.product VALUES (7, true, 'Verna', NULL);
INSERT INTO public.product VALUES (8, true, 'Limetta', NULL);
INSERT INTO public.product VALUES (9, true, 'Primoiori', NULL);
INSERT INTO public.product VALUES (11, true, 'Limetta', NULL);
INSERT INTO public.product VALUES (13, true, 'Eureka', NULL);
INSERT INTO public.product VALUES (16, true, 'Primoiori', NULL);
INSERT INTO public.product VALUES (17, true, 'Lisbon', NULL);
INSERT INTO public.product VALUES (19, true, 'Myer', NULL);
INSERT INTO public.product VALUES (22, true, 'Verna', NULL);
INSERT INTO public.product VALUES (24, true, 'Myer', NULL);
INSERT INTO public.product VALUES (25, true, 'Bearss', NULL);
INSERT INTO public.product VALUES (26, true, 'Primoiori', NULL);
INSERT INTO public.product VALUES (28, true, 'Eureka', NULL);
INSERT INTO public.product VALUES (29, true, 'Verna', NULL);
INSERT INTO public.product VALUES (32, true, 'Verna', NULL);
INSERT INTO public.product VALUES (33, true, 'Limetta', NULL);
INSERT INTO public.product VALUES (35, true, 'Eureka', NULL);
INSERT INTO public.product VALUES (23, false, 'Eureka', NULL);
INSERT INTO public.product VALUES (14, false, 'Myer', NULL);
INSERT INTO public.product VALUES (40, false, 'Bearss', NULL);
INSERT INTO public.product VALUES (38, false, 'Eureka', NULL);
INSERT INTO public.product VALUES (12, false, 'Lisbon', NULL);
INSERT INTO public.product VALUES (30, false, 'Limetta', NULL);
INSERT INTO public.product VALUES (36, false, 'Myer', NULL);
INSERT INTO public.product VALUES (31, false, 'Primoiori', NULL);
INSERT INTO public.product VALUES (21, false, 'Limetta', NULL);
INSERT INTO public.product VALUES (37, false, 'Lisbon', NULL);
INSERT INTO public.product VALUES (34, false, 'Lisbon', NULL);
INSERT INTO public.product VALUES (10, false, 'Verna', NULL);
INSERT INTO public.product VALUES (27, false, 'Lisbon', NULL);
INSERT INTO public.product VALUES (39, false, 'Myer', NULL);
INSERT INTO public.product VALUES (18, false, 'Eureka', NULL);
INSERT INTO public.product VALUES (15, false, 'Bearss', NULL);
INSERT INTO public.product VALUES (20, false, 'Bearss', NULL);


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 12, true);


--
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_product_id_seq', 40, true);


--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_transaction_id_seq', 1, false);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);


--
-- Name: product product_customer_lemons_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_customer_lemons_id_fkey FOREIGN KEY (customer_lemons_id) REFERENCES public.customers(customer_id);


--
-- Name: transaction transaction_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- PostgreSQL database dump complete
--

