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
    lemons character varying(15)
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
    quantity integer NOT NULL
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

INSERT INTO public.customers VALUES (1, 'Nate', 'Verna', NULL);
INSERT INTO public.customers VALUES (2, 'Jackson', 'Limetta', NULL);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES (1, true, 'Lisbon');
INSERT INTO public.product VALUES (2, true, 'Eureka');
INSERT INTO public.product VALUES (3, true, 'Myer');
INSERT INTO public.product VALUES (4, true, 'Bearss');
INSERT INTO public.product VALUES (5, true, 'Limetta');
INSERT INTO public.product VALUES (6, true, 'Primoiori');
INSERT INTO public.product VALUES (7, true, 'Verna');
INSERT INTO public.product VALUES (8, true, 'Limetta');
INSERT INTO public.product VALUES (9, true, 'Primoiori');
INSERT INTO public.product VALUES (10, true, 'Verna');
INSERT INTO public.product VALUES (11, true, 'Limetta');
INSERT INTO public.product VALUES (12, true, 'Lisbon');
INSERT INTO public.product VALUES (13, true, 'Eureka');
INSERT INTO public.product VALUES (14, true, 'Myer');
INSERT INTO public.product VALUES (15, true, 'Bearss');
INSERT INTO public.product VALUES (16, true, 'Primoiori');
INSERT INTO public.product VALUES (17, true, 'Lisbon');
INSERT INTO public.product VALUES (18, true, 'Eureka');
INSERT INTO public.product VALUES (19, true, 'Myer');
INSERT INTO public.product VALUES (20, true, 'Bearss');
INSERT INTO public.product VALUES (21, true, 'Limetta');
INSERT INTO public.product VALUES (23, true, 'Eureka');
INSERT INTO public.product VALUES (24, true, 'Myer');
INSERT INTO public.product VALUES (25, true, 'Bearss');
INSERT INTO public.product VALUES (26, true, 'Primoiori');
INSERT INTO public.product VALUES (27, true, 'Lisbon');
INSERT INTO public.product VALUES (28, true, 'Eureka');
INSERT INTO public.product VALUES (29, true, 'Verna');
INSERT INTO public.product VALUES (31, true, 'Primoiori');
INSERT INTO public.product VALUES (32, true, 'Verna');
INSERT INTO public.product VALUES (33, true, 'Limetta');
INSERT INTO public.product VALUES (34, true, 'Lisbon');
INSERT INTO public.product VALUES (35, true, 'Eureka');
INSERT INTO public.product VALUES (36, true, 'Myer');
INSERT INTO public.product VALUES (37, true, 'Lisbon');
INSERT INTO public.product VALUES (38, true, 'Eureka');
INSERT INTO public.product VALUES (39, true, 'Myer');
INSERT INTO public.product VALUES (40, true, 'Bearss');
INSERT INTO public.product VALUES (22, false, 'Verna');
INSERT INTO public.product VALUES (30, false, 'Limetta');


--
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.transaction VALUES (1, 3.50, 19.20, 22, 1, 1);
INSERT INTO public.transaction VALUES (2, 3.50, 3.50, 30, 2, 1);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 2, true);


--
-- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_product_id_seq', 40, true);


--
-- Name: transaction_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_transaction_id_seq', 2, true);


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
-- Name: transaction transaction_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: transaction transaction_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- PostgreSQL database dump complete
--

