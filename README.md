# 🚀 Case Técnico: Analista de Integração de Dados (Implantação) - Systock

Este repositório contém a resolução completa do case técnico para a vaga de Analista de Integração de Dados. O projeto foi estruturado utilizando boas práticas de versionamento (Git), infraestrutura conteinerizada (Docker/PostgreSQL) e scripts SQL otimizados e corrigidos.

---

## 🛠️ Parte 1 - Documentação do Processo de Importação

**1. Ferramenta utilizada para importação:** 
A importação inicial dos dados foi realizada através da ferramenta **DBeaver** (através da funcionalidade *Data Import / Export*), conforme sugerido no escopo do projeto, garantindo uma carga direta para o PostgreSQL local. Em cenários produtivos de larga escala ou integrações recorrentes, a mesma lógica pode ser orquestrada através de fluxos ETL utilizando o **PDI Pentaho**.

**2. Estrutura da Planilha (Ficheiro `base_teste_systock.xlsx`):** 
O ficheiro contém 5 separadores (abas) que correspondem às tabelas do banco de dados:
* **venda (33 linhas):** `venda_id` (Numérico), `data_emissao` (Data), `horariomov` (Texto/Hora), `produto_id` (Texto), `qtde_vendida` (Decimal), `valor_unitario` (Decimal), `filial_id` (Numérico), `item` (Numérico), `unidade_medida` (Texto).
* **pedido_compra (29 linhas):** `pedido_id` (Numérico), `data_pedido` (Data), `item` (Numérico), `produto_id` (Texto), `descricao_produto` (Texto), `ordem_compra` (Numérico), `qtde_pedida` (Numérico), `filial_id` (Numérico), `data_entrega` (Data), `qtde_entregue` (Numérico), `preco_compra` (Decimal), `fornecedor_id` (Numérico/Texto). Identificadas 11 colunas lixo/vazias (`Unnamed: 12` a `Unnamed: 22`).
* **entradas_mercadoria (20 linhas):** `data_entrada` (Data), `nro_nfe` (Texto), `item` (Numérico), `produto_id` (Texto), `descricao_produto` (Texto), `ordem_compra` (Numérico), `qtde_recebida` (Decimal), `filial_id` (Numérico), `custo_unitario` (Decimal).
* **produtos_filial (20 linhas):** `filial_id` (Numérico), `idproduto` (Texto - convertido para `produto_id`), `descricao` (Texto), `estoque` (Decimal), `preco_unitario` (Decimal), `preco_compra` (Decimal), `preco_venda` (Decimal), `idfornecedor` (Texto).
* **fornecedor (20 linhas):** `idfornecedor` (Texto), `razao_social` (Texto).

**3. Tratamentos Aplicados e 4. Ajustes ou Correções Realizadas:** 
Durante o processo de importação e criação de tabelas (DDL), foi necessária uma validação rigorosa de *Data Quality* para contornar erros intencionais e falhas de formatação:
* **Correção DDL (Chaves Primárias e Colunas Ausentes):** A PK original de `entradas_mercadoria` exigia o campo `ordem_compra`, que não existia na instrução `CREATE TABLE`. O campo foi adicionado para manter a integridade referencial com os pedidos de compra. As Primary Keys de `produtos_filial` e `fornecedor` referenciavam colunas com nomenclatura errada, o que foi corrigido no script inicial.
* **Mapeamento de Nomenclatura (Mapping):** Na importação do separador `produtos_filial`, a coluna `idproduto` da folha de cálculo foi mapeada explicitamente para a coluna de destino `produto_id` no banco de dados. O mesmo ocorreu para corrigir o erro de digitação `decricao` no SQL original para `descricao`.
* **Isolamento de Sujidade (Clean-up):** No separador `pedido_compra`, o DBeaver foi configurado para ignorar o intervalo de colunas vazias geradas acidentalmente no Excel (`Unnamed: 12` a `Unnamed: 22`).
* **Tipagem de Dados de Fornecedor:** O campo `idfornecedor` na tabela original estava sugerido como Inteiro, mas na folha de cálculo possui o padrão alfanumérico "F1", "F2", etc. O tipo de dados no banco de destino foi retificado para `varchar(25)`.
* **Valores Default Vazios:** Parâmetros de default com erro de sintaxe nos scripts originais (ex: `DEFAULT ::`, `DEFAULT '0"`, e `DEFAULT NOT NULL` em vez de `DEFAULT 0 NOT NULL`) foram higienizados antes da execução e carga.

**5. Estratégia de Bypass para Limitação da Ferramenta GUI:**
Devido à presença de formatações espúrias e à limitação da versão Community do DBeaver para `.xlsx`, optou-se pela geração automatizada de scripts `INSERT` para carga direta via SQL (presentes na pasta `/scripts`). Esta manobra garante a atomicidade, previne falhas de codificação e assegura o carregamento seguro e tipado para o PostgreSQL.

---

## 📊 Parte 2 e 3 - Consultas, Transformações e Triggers

Os scripts SQL para a resolução da etapa de manipulação de dados encontram-se documentados e versionados na pasta `/scripts` do repositório:
* `03_consultas_basicas.sql`: Responde ao consumo por produto (Fev/2025) e lista produtos requisitados, mas não recebidos, utilizando cruzamento via `LEFT JOIN` e verificação de nulos (`IS NULL`).
* `04_transformacoes_e_triggers.sql`: Apresenta formatação de strings e datas (`CONCAT`, `TO_CHAR`) e a implementação de uma **Trigger de Banco de Dados** com Sequence. A trigger automatiza a criação de registros na tabela de fornecedores caso um produto seja inserido sem amarração, garantindo 100% de integridade referencial.

---

## 🤝 Parte 4 - Estratégia de Validação com o Cliente

Como Analista de Implantação, a reunião de validação é o momento de gerar **confiança**. O roteiro abaixo simula a abordagem com o cliente final para o fechamento do mês de **Fevereiro de 2025**.

### 1. Principais pontos de validação com o cliente
* **Alinhamento Financeiro:** Confirmar se o Totalizador de Vendas (em R$) calculado no novo banco de dados bate perfeitamente com os relatórios gerenciais/DRE do ERP de origem do cliente referente a Fev/2025.
* **Validação de Estoque (Furos de Processo):** Apresentar as divergências operacionais encontradas, como pedidos de compra emitidos que nunca receberam entrada de mercadoria, ou notas fiscais sem amarração ao pedido de origem (ex: `ordem_compra = 0`).
* **Consistência de Cadastros:** Validar se a padronização de nomenclatura de produtos (ex: "ID - Descrição") e a inserção automática de fornecedores (feita pela nossa Trigger) atendem às necessidades de visualização das telas de relatório do cliente.

### 2. Técnicas para garantir Exatidão e Precisão
* **Cruzamento de Controle (Conciliação):** Utilização de queries de agregação (`SUM`, `COUNT`) nos dados brutos espelhando as totalizações do sistema legado.
* **Data Quality Analytics:** Uso de constraints relacionais (Foreign Keys) para impedir a entrada de dados "órfãos" e mapeamento de nulos (`IS NULL`) para encontrar lacunas operacionais em joins.
* **Automação de Correção:** Emprego de Triggers transacionais para higienizar dados em tempo real, evitando que erros humanos no ERP original poluam as métricas do Systock.

### 3. Consultas SQL prontas para a Reunião
Deixaria o DBeaver pronto com três consultas focadas em linguagem de negócio para demonstrar segurança na integração:

**A. Consulta de Validação de Faturamento (O "Bate-Caixa"):**
> *"Sr. Cliente, vamos conferir se o total faturado que o nosso sistema recebeu no mês de Fevereiro confere com o seu relatório contábil?"*
```sql
SELECT 
    TO_CHAR(v.data_emissao, 'DD/MM/YYYY') AS data_venda,
    COUNT(v.venda_id) AS total_cupons_emitidos,
    SUM(v.qtde_vendida * v.valor_unitario) AS faturamento_diario
FROM public.venda v
WHERE v.data_emissao BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY v.data_emissao
ORDER BY v.data_emissao;
```

**B. Consulta de Auditoria de Recebimento (Mostrando valor consultivo):**
> *"Detetámos que a vossa equipa fez algumas requisições de mercadoria, mas elas não deram entrada física. Isto está retido no fornecedor?"*
```sql
SELECT 
    pc.pedido_id AS nro_pedido,
    CONCAT(pc.produto_id, ' - ', pc.descricao_produto) AS produto,
    pc.qtde_pedida AS comprado,
    COALESCE(SUM(em.qtde_recebida), 0) AS entregue
FROM public.pedido_compra pc
LEFT JOIN public.entradas_mercadoria em ON pc.ordem_compra = em.ordem_compra
GROUP BY pc.pedido_id, pc.produto_id, pc.descricao_produto, pc.qtde_pedida
HAVING (pc.qtde_pedida - COALESCE(SUM(em.qtde_recebida), 0)) > 0;
```

**C. Consulta de Higiene Cadastral (Erros Intencionais Operacionais):**
> *"Sr. Cliente, notámos algumas entradas de notas que estão 'órfãs', sem ligação ao pedido de compra. A nossa plataforma já mapeou essas inconsistências."*
```sql
SELECT 
    data_entrada, 
    nro_nfe, 
    descricao_produto, 
    qtde_recebida 
FROM public.entradas_mercadoria 
WHERE ordem_compra = 0 OR ordem_compra IS NULL;
```