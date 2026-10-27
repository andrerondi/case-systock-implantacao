-- 1. Tabela de Vendas (Corrigido: defaults de produto_id e item)
CREATE TABLE public.venda (
    venda_id int8 NOT NULL, 
    data_emissao date NOT NULL, 
    horariomov varchar(8) DEFAULT '00:00:00' NOT NULL, 
    produto_id varchar(25) DEFAULT '' NOT NULL, 
    qtde_vendida float8 NULL, 
    valor_unitario numeric(12, 4) DEFAULT 0 NOT NULL, 
    filial_id int8 DEFAULT 1 NOT NULL, 
    item int4 DEFAULT 0 NOT NULL, 
    unidade_medida varchar(3) NULL, 
    CONSTRAINT pk_consumo PRIMARY KEY (filial_id, venda_id, data_emissao, produto_id, item, horariomov)
);

-- 2. Tabela de Pedidos de Compra (Corrigido: defaults vazios e aspas erradas)
CREATE TABLE public.pedido_compra (
    pedido_id float8 DEFAULT 0 NOT NULL, 
    data_pedido date NULL, 
    item float8 DEFAULT 0 NOT NULL, 
    produto_id varchar(25) DEFAULT '0' NOT NULL, 
    descricao_produto varchar(255) NULL, 
    ordem_compra float8 DEFAULT 0 NOT NULL, 
    qtde_pedida float8 NULL, 
    filial_id int4 NULL, 
    data_entrega date NULL, 
    qtde_entregue float8 DEFAULT 0 NOT NULL, 
    qtde_pendente float8 DEFAULT 0 NOT NULL, 
    preco_compra float8 DEFAULT NULL, 
    fornecedor_id int4 DEFAULT NULL, 
    CONSTRAINT pedido_compra_pkey PRIMARY KEY (pedido_id, produto_id, item) 
);

-- 3. Tabela de Entradas de Mercadoria (Corrigido: adicionado ordem_compra para bater com a PK e a regra de negócio)
CREATE TABLE public.entradas_mercadoria (
    data_entrada date NULL, 
    nro_nfe varchar(255) NOT NULL, 
    item float8 DEFAULT 0 NOT NULL, 
    produto_id varchar(25) DEFAULT '0' NOT NULL, 
    descricao_produto varchar(255) NULL, 
    qtde_recebida float8 NULL, 
    filial_id int4 NULL, 
    custo_unitario numeric(12, 4) DEFAULT 0 NOT NULL, 
    ordem_compra float8 NOT NULL, -- Coluna adicionada pois é exigida na PK abaixo e citada na observação
    CONSTRAINT entradas_mercadoria_pkey PRIMARY KEY (ordem_compra, item, produto_id, nro_nfe) 
);

-- 4. Tabela de Fornecedor (Criada antes de produtos para a FK funcionar. Corrigido: PK referenciando apenas idfornecedor)
CREATE TABLE public.fornecedor (
    idfornecedor varchar(25) NOT NULL, -- Nome corrigido
    razao_social varchar(255) NOT NULL, 
    CONSTRAINT fornecedor_pkey PRIMARY KEY (idfornecedor)
);

-- 5. Tabela de Produtos (Corrigido: defaults vazios, nome da coluna decricao, idproduto na PK corrigido para produto_id)
CREATE TABLE public.produtos_filial (
    filial_id int4 NOT NULL, 
    produto_id varchar(25) NOT NULL, 
    descricao varchar(255) NOT NULL, 
    estoque float8 DEFAULT 0 NOT NULL, 
    preco_unitario float8 DEFAULT 0 NOT NULL, 
    preco_compra float8 DEFAULT 0 NOT NULL, 
    preco_venda float8 DEFAULT 0 NOT NULL, 
    idfornecedor varchar(25) NULL, 
    CONSTRAINT produtos_filial_pkey PRIMARY KEY (filial_id, produto_id)
);