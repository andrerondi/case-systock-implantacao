--
-- PostgreSQL database dump
--

\restrict Gi1mCKWJ8Wti1hs3fQTPK5owOTzKoWOOgv8qH5VND9wrmIo3DcHSFDfVhev84I8

-- Dumped from database version 15.18
-- Dumped by pg_dump version 15.18

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

--
-- Name: fn_gerar_fornecedor_automatico(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.fn_gerar_fornecedor_automatico() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_novo_id_fornecedor VARCHAR(25);
BEGIN
    -- Se o produto for inserido sem idfornecedor, a automação entra em ação
    IF NEW.idfornecedor IS NULL THEN
        
        -- Pega o próximo número da sequência e converte para texto (para bater com a tipagem da coluna)
        v_novo_id_fornecedor := NEXTVAL('seq_novo_fornecedor')::VARCHAR;
        
        -- Insere na tabela 'fornecedor' para garantir a integridade referencial
        INSERT INTO public.fornecedor (idfornecedor, razao_social)
        VALUES (v_novo_id_fornecedor, 'Fornecedor Gerado Automaticamente - ' || v_novo_id_fornecedor);
        
        -- Atribui o novo ID gerado à linha do produto que está a ser inserida
        NEW.idfornecedor := v_novo_id_fornecedor;
        
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.fn_gerar_fornecedor_automatico() OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entradas_mercadoria; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.entradas_mercadoria (
    data_entrada date,
    nro_nfe character varying(255) NOT NULL,
    item double precision DEFAULT 0 NOT NULL,
    produto_id character varying(25) DEFAULT '0'::character varying NOT NULL,
    descricao_produto character varying(255),
    qtde_recebida double precision,
    filial_id integer,
    custo_unitario numeric(12,4) DEFAULT 0 NOT NULL,
    ordem_compra double precision NOT NULL
);


ALTER TABLE public.entradas_mercadoria OWNER TO admin;

--
-- Name: fornecedor; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.fornecedor (
    idfornecedor character varying(25) NOT NULL,
    razao_social character varying(255) NOT NULL,
    "idfornecedor;razao_social" character varying(50)
);


ALTER TABLE public.fornecedor OWNER TO admin;

--
-- Name: pedido_compra; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.pedido_compra (
    pedido_id double precision DEFAULT 0 NOT NULL,
    data_pedido date,
    item double precision DEFAULT 0 NOT NULL,
    produto_id character varying(25) DEFAULT '0'::character varying NOT NULL,
    descricao_produto character varying(255),
    ordem_compra double precision DEFAULT 0 NOT NULL,
    qtde_pedida double precision,
    filial_id integer,
    data_entrega date,
    qtde_entregue double precision DEFAULT 0 NOT NULL,
    qtde_pendente double precision DEFAULT 0 NOT NULL,
    preco_compra double precision,
    fornecedor_id integer
);


ALTER TABLE public.pedido_compra OWNER TO admin;

--
-- Name: produtos_filial; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.produtos_filial (
    filial_id integer NOT NULL,
    produto_id character varying(25) NOT NULL,
    descricao character varying(255) NOT NULL,
    estoque double precision DEFAULT 0 NOT NULL,
    preco_unitario double precision DEFAULT 0 NOT NULL,
    preco_compra double precision DEFAULT 0 NOT NULL,
    preco_venda double precision DEFAULT 0 NOT NULL,
    idfornecedor character varying(25)
);


ALTER TABLE public.produtos_filial OWNER TO admin;

--
-- Name: seq_novo_fornecedor; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.seq_novo_fornecedor
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seq_novo_fornecedor OWNER TO admin;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.venda (
    venda_id bigint NOT NULL,
    data_emissao date NOT NULL,
    horariomov character varying(8) DEFAULT '00:00:00'::character varying NOT NULL,
    produto_id character varying(25) DEFAULT ''::character varying NOT NULL,
    qtde_vendida double precision,
    valor_unitario numeric(12,4) DEFAULT 0 NOT NULL,
    filial_id bigint DEFAULT 1 NOT NULL,
    item integer DEFAULT 0 NOT NULL,
    unidade_medida character varying(3)
);


ALTER TABLE public.venda OWNER TO admin;

--
-- Data for Name: entradas_mercadoria; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.entradas_mercadoria (data_entrada, nro_nfe, item, produto_id, descricao_produto, qtde_recebida, filial_id, custo_unitario, ordem_compra) FROM stdin;
2025-02-27	NFE1	1	P1	Produto 1	77	1	84.3500	1
2025-01-20	NFE2	1	P2	Produto 2	64	1	16.6600	2
2025-02-18	NFE3	1	P3	Produto 3	88	1	90.3600	3
2025-02-12	NFE4	1	P4	Produto 4	4	1	84.6800	4
2025-02-19	NFE5	1	P5	Produto 5	95	1	98.9900	5
2025-02-08	NFE6	1	P6	Produto 6	41	1	90.2900	6
2025-01-03	NFE7	1	P7	Produto 7	75	1	27.2200	7
2025-02-21	NFE8	1	P8	Produto 8	25	1	71.1000	8
2025-02-13	NFE9	1	P9	Produto 9	57	1	19.5500	9
2025-03-01	NFE10	1	P10	Produto 10	7	1	54.3900	10
2025-01-23	NFE11	1	P11	Produto 11	85	1	91.8900	11
2025-01-02	NFE12	1	P12	Produto 12	12	1	38.5300	12
2025-02-20	NFE13	1	P13	Produto 13	7	1	60.8600	13
2025-01-10	NFE14	1	P14	Produto 14	92	1	38.4800	14
2025-01-13	NFE15	1	P15	Produto 15	68	1	95.5800	15
2025-01-22	NFE16	1	P16	Produto 16	89	1	39.4600	16
2025-02-24	NFE17	1	P17	Produto 17	10	1	10.3200	17
2025-01-31	NFE18	1	P18	Produto 18	48	1	62.5600	18
2025-02-13	NFE19	1	P19	Produto 19	64	1	84.5400	19
2025-01-01	NFE20	1	P20	Produto 20	6	1	65.7000	20
\.


--
-- Data for Name: fornecedor; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.fornecedor (idfornecedor, razao_social, "idfornecedor;razao_social") FROM stdin;
F1	Fornecedor 1 LTDA	\N
F2	Fornecedor 2 LTDA	\N
F3	Fornecedor 3 LTDA	\N
F4	Fornecedor 4 LTDA	\N
F5	Fornecedor 5 LTDA	\N
F6	Fornecedor 6 LTDA	\N
F7	Fornecedor 7 LTDA	\N
F8	Fornecedor 8 LTDA	\N
F9	Fornecedor 9 LTDA	\N
F10	Fornecedor 10 LTDA	\N
F11	Fornecedor 11 LTDA	\N
F12	Fornecedor 12 LTDA	\N
F13	Fornecedor 13 LTDA	\N
F14	Fornecedor 14 LTDA	\N
F15	Fornecedor 15 LTDA	\N
F16	Fornecedor 16 LTDA	\N
F17	Fornecedor 17 LTDA	\N
F18	Fornecedor 18 LTDA	\N
F19	Fornecedor 19 LTDA	\N
F20	Fornecedor 20 LTDA	\N
1000	Fornecedor Gerado Automaticamente - 1000	\N
\.


--
-- Data for Name: pedido_compra; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.pedido_compra (pedido_id, data_pedido, item, produto_id, descricao_produto, ordem_compra, qtde_pedida, filial_id, data_entrega, qtde_entregue, qtde_pendente, preco_compra, fornecedor_id) FROM stdin;
1	2025-01-02	1	P1	Produto 1	1	96	1	2025-02-27	10	0	46.67	\N
2	2025-01-07	1	P2	Produto 2	2	14	1	2025-01-07	7	0	77.32	\N
3	2025-01-05	1	P3	Produto 3	3	12	1	2025-01-03	2	0	47.82	\N
4	2025-01-22	1	P4	Produto 4	4	27	1	2025-01-28	3	0	49.57	\N
5	2025-01-28	1	P5	Produto 5	5	35	1	2025-02-28	12	0	57.18	\N
6	2025-02-22	1	P6	Produto 6	6	98	1	2025-01-05	55	0	59.96	\N
7	2025-03-01	1	P7	Produto 7	7	34	1	2025-02-01	29	0	49.22	\N
8	2025-02-02	1	P8	Produto 8	8	29	1	2025-02-14	24	0	35.88	\N
9	2025-01-15	1	P9	Produto 9	9	57	1	2025-01-28	34	0	28.48	\N
10	2025-01-09	1	P10	Produto 10	10	49	1	2025-02-09	4	0	42.86	\N
11	2025-02-22	1	P11	Produto 11	11	24	1	2025-01-08	12	0	14.82	\N
12	2025-02-25	1	P12	Produto 12	12	91	1	2025-02-20	48	0	6.92	\N
13	2025-02-23	1	P13	Produto 13	13	99	1	2025-02-02	91	0	65.44	\N
14	2025-01-21	1	P14	Produto 14	14	96	1	2025-01-01	27	0	21.91	\N
15	2025-02-04	1	P15	Produto 15	15	45	1	2025-01-04	1	0	85.04	\N
16	2025-02-27	1	P16	Produto 16	16	84	1	2025-01-14	51	0	64.17	\N
17	2025-01-08	1	P17	Produto 17	17	22	1	2025-01-19	7	0	74.55	\N
18	2025-02-17	1	P18	Produto 18	18	63	1	2025-01-02	17	0	24.94	\N
19	2025-02-19	1	P19	Produto 19	0	20	1	2025-01-08	0	0	22.21	\N
20	2025-02-10	1	P20	Produto 20	0	25	1	2025-01-15	0	0	38.51	\N
21	2025-02-25	1	P12	Produto 12	0	12	1	2025-02-20	0	0	6.92	\N
22	2025-02-23	1	P13	Produto 13	0	4	1	2025-02-02	0	0	65.44	\N
23	2025-01-21	1	P14	Produto 14	0	6	1	2025-01-01	0	0	21.91	\N
24	2025-02-04	1	P15	Produto 15	0	8	1	2025-01-04	0	0	85.04	\N
25	2025-02-27	1	P16	Produto 16	0	9	1	2025-01-14	0	0	64.17	\N
26	2025-01-08	1	P17	Produto 17	0	4	1	2025-01-19	0	0	74.55	\N
27	2025-02-17	1	P18	Produto 18	0	3	1	2025-01-02	0	0	24.94	\N
28	2025-02-19	1	P19	Produto 19	0	3	1	2025-01-08	0	0	22.21	\N
29	2025-02-10	1	P20	Produto 20	0	2	1	2025-01-15	0	0	38.51	\N
\.


--
-- Data for Name: produtos_filial; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.produtos_filial (filial_id, produto_id, descricao, estoque, preco_unitario, preco_compra, preco_venda, idfornecedor) FROM stdin;
1	P1	Produto 1	88	42.65	144.13	40.79	F8
1	P2	Produto 2	28	79.52	103.56	174.18	F9
1	P3	Produto 3	40	119.5	24.14	60.69	F10
1	P4	Produto 4	73	89.67	7.75	226.5	F11
1	P5	Produto 5	97	135.99	36.18	89.92	F12
1	P6	Produto 6	38	161.31	55.37	95.6	F13
1	P7	Produto 7	131	153.82	14.04	46.64	F7
1	P8	Produto 8	71	140.57	149.5	95.28	F17
1	P9	Produto 9	2	30.88	137	164.32	F18
1	P10	Produto 10	38	115.71	27.77	87.7	F19
1	P11	Produto 11	154	147.99	29.39	44.95	F1
1	P12	Produto 12	78	32.47	64.63	276.58	F2
1	P13	Produto 13	79	194.04	58.3	99.05	F3
1	P14	Produto 14	9	199.56	56.8	80.74	F4
1	P15	Produto 15	131	101.15	107.6	29.24	F5
1	P16	Produto 16	177	24.64	75.94	278.88	F6
1	P17	Produto 17	105	195.63	126.25	183.92	F7
1	P18	Produto 18	198	162.2	134.12	105.61	F18
1	P19	Produto 19	148	184.36	121.69	234.58	F19
1	P20	Produto 20	196	52.04	124.87	157.93	F20
1	P99	Produto de Teste Trigger	10	0	0	0	1000
\.


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.venda (venda_id, data_emissao, horariomov, produto_id, qtde_vendida, valor_unitario, filial_id, item, unidade_medida) FROM stdin;
1	2025-01-11	08:00:00	P1	5	78.9300	1	1	UN
2	2025-03-02	08:00:00	P2	7	92.9600	1	1	UN
3	2025-01-28	08:00:00	P3	9	197.6100	1	1	UN
4	2025-01-10	08:00:00	P4	38.6	139.7100	1	1	UN
5	2025-01-11	08:00:00	P5	3	126.7900	1	1	UN
6	2025-01-24	08:00:00	P6	2	36.8300	1	1	UN
7	2025-02-22	08:00:00	P7	5	40.7500	1	1	UN
8	2025-01-26	08:00:00	P8	20.04	51.3700	1	1	UN
9	2025-01-17	08:00:00	P9	6	172.5500	1	1	UN
10	2025-01-03	08:00:00	P10	90	44.2200	1	1	UN
11	2025-01-08	08:00:00	P11	6	190.3700	1	1	UN
12	2025-01-21	08:00:00	P12	2.86	136.4000	1	1	UN
13	2025-01-24	08:00:00	P13	13	61.8500	1	1	UN
14	2025-02-07	08:00:00	P14	53	106.3000	1	1	UN
15	2025-02-20	08:00:00	P15	27	43.4000	1	1	UN
16	2025-02-17	08:00:00	P16	37.11	14.4100	1	1	UN
17	2025-02-22	08:00:00	P17	3	139.8000	1	1	UN
18	2025-02-18	08:00:00	P18	5	185.2300	1	1	UN
19	2025-02-20	08:00:00	P19	10	182.5100	1	1	UN
20	2025-02-28	08:00:00	P20	2	68.5400	1	1	UN
21	2025-01-24	08:00:00	P21	25	61.8500	1	1	UN
22	2025-02-07	08:00:00	P22	6	106.3000	1	1	UN
23	2025-02-20	08:00:00	P23	7	43.4000	1	1	UN
24	2025-02-17	08:00:00	P24	4	14.4100	1	1	UN
25	2025-02-22	08:00:00	P25	8	139.8000	1	1	UN
26	2025-02-18	08:00:00	P26	3.11	185.2300	1	1	UN
27	2025-02-20	08:00:00	P27	3	182.5100	2	1	UN
28	2025-03-28	08:00:00	P28	6	68.5400	3	1	UN
29	2025-03-17	08:00:00	P24	5	14.4100	1	1	UN
30	2025-03-22	08:00:00	P25	3	139.8000	1	1	UN
31	2025-03-18	08:00:00	P26	4	185.2300	1	1	UN
32	2025-03-20	08:00:00	P27	2	182.5100	2	1	UN
33	2025-03-28	08:00:00	P28	1	68.5400	3	1	UN
\.


--
-- Name: seq_novo_fornecedor; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.seq_novo_fornecedor', 1002, true);


--
-- Name: entradas_mercadoria entradas_mercadoria_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.entradas_mercadoria
    ADD CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (ordem_compra, item, produto_id, nro_nfe);


--
-- Name: fornecedor fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (idfornecedor);


--
-- Name: pedido_compra pedido_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.pedido_compra
    ADD CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id, produto_id, item);


--
-- Name: venda pk_consumo; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov);


--
-- Name: produtos_filial produtos_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.produtos_filial
    ADD CONSTRAINT produtos_filial_pkey PRIMARY KEY (filial_id, produto_id);


--
-- Name: produtos_filial trg_gera_fornecedor; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER trg_gera_fornecedor BEFORE INSERT ON public.produtos_filial FOR EACH ROW EXECUTE FUNCTION public.fn_gerar_fornecedor_automatico();


--
-- PostgreSQL database dump complete
--

\unrestrict Gi1mCKWJ8Wti1hs3fQTPK5owOTzKoWOOgv8qH5VND9wrmIo3DcHSFDfVhev84I8

