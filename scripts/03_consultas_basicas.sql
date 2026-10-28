-- 1. Consumo por produto e mês (Fevereiro 2025)
SELECT 
    v.produto_id,
    pf.descricao AS descricao_produto,
    SUM(v.qtde_vendida) AS total_quantidade_vendida,
    SUM(v.qtde_vendida * v.valor_unitario) AS valor_total_rs
FROM public.venda v
LEFT JOIN public.produtos_filial pf 
    ON v.produto_id = pf.produto_id
WHERE v.data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY 
    v.produto_id, 
    pf.descricao
ORDER BY 
    v.produto_id;


-- 2. Produtos com requisição pendente (Requisitados, mas não recebidos)
SELECT 
    pc.pedido_id,
    pc.ordem_compra,
    pc.produto_id,
    pc.descricao_produto,
    pc.data_pedido,
    pc.qtde_pedida
FROM public.pedido_compra pc
LEFT JOIN public.entradas_mercadoria em 
    ON pc.ordem_compra = em.ordem_compra
WHERE em.ordem_compra IS NULL
ORDER BY pc.pedido_id;