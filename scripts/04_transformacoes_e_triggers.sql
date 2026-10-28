-- Parte 3 (Req 1, 2 e 3): Consulta de Transformação de Dados
SELECT 
    CONCAT(produto_id, ' - ', descricao_produto) AS "Produto",
    SUM(qtde_pedida) AS "Qtde Requisitada",
    TO_CHAR(MIN(data_pedido), 'DD/MM/YYYY') AS "Data Solicitação"
FROM 
    public.pedido_compra
GROUP BY 
    produto_id, 
    descricao_produto
HAVING 
    SUM(qtde_pedida) > 10
ORDER BY 
    SUM(qtde_pedida) DESC;



-- Parte 3 (Req 4): Criação de Sequência, Função e Trigger

-- 1. Cria uma sequência numérica para gerar os IDs
CREATE SEQUENCE IF NOT EXISTS seq_novo_fornecedor START 1000;

-- 2. Cria a função que será executada pela Trigger
CREATE OR REPLACE FUNCTION fn_gerar_fornecedor_automatico()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

-- 3. Cria a Trigger atrelada à tabela produtos_filial
CREATE TRIGGER trg_gera_fornecedor
BEFORE INSERT ON public.produtos_filial
FOR EACH ROW
EXECUTE FUNCTION fn_gerar_fornecedor_automatico();