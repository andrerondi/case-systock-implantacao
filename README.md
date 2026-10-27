Parte 1 - Documentação do Processo de Importação

1. Ferramenta utilizada para importação:
A importação inicial dos dados foi realizada através da ferramenta DBeaver (através da funcionalidade Data Import / Export), conforme sugerido no escopo do projeto, garantindo uma carga direta para o PostgreSQL local. Em cenários produtivos de larga escala ou integrações recorrentes, a mesma lógica pode ser orquestrada através de fluxos ETL utilizando o PDI Pentaho.

2. Estrutura da Planilha (Ficheiro base_teste_systock.xlsx):
O ficheiro contém 5 separadores (abas) que correspondem às tabelas do banco de dados:

venda (33 linhas): venda_id (Numérico), data_emissao (Data), horariomov (Texto/Hora), produto_id (Texto), qtde_vendida (Decimal), valor_unitario (Decimal), filial_id (Numérico), item (Numérico), unidade_medida (Texto).

pedido_compra (29 linhas): pedido_id (Numérico), data_pedido (Data), item (Numérico), produto_id (Texto), descricao_produto (Texto), ordem_compra (Numérico), qtde_pedida (Numérico), filial_id (Numérico), data_entrega (Data), qtde_entregue (Numérico), preco_compra (Decimal), fornecedor_id (Numérico/Texto). Identificadas 11 colunas lixo/vazias (Unnamed: 12 a Unnamed: 22).

entradas_mercadoria (20 linhas): data_entrada (Data), nro_nfe (Texto), item (Numérico), produto_id (Texto), descricao_produto (Texto), ordem_compra (Numérico), qtde_recebida (Decimal), filial_id (Numérico), custo_unitario (Decimal).

produtos_filial (20 linhas): filial_id (Numérico), idproduto (Texto - convertido para produto_id), descricao (Texto), estoque (Decimal), preco_unitario (Decimal), preco_compra (Decimal), preco_venda (Decimal), idfornecedor (Texto).

fornecedor (20 linhas): idfornecedor (Texto), razao_social (Texto).

3. Tratamentos Aplicados e 4. Ajustes ou Correções Realizadas:
Durante o processo de importação e criação de tabelas (DDL), foi necessária uma validação rigorosa de Data Quality para contornar erros intencionais e falhas de formatação:

Correção DDL (Chaves Primárias e Colunas Ausentes): A PK original de entradas_mercadoria exigia o campo ordem_compra, que não existia na instrução CREATE TABLE. O campo foi adicionado para manter a integridade referencial com os pedidos de compra. As Primary Keys de produtos_filial e fornecedor referenciavam colunas com nomenclatura errada, o que foi corrigido no script inicial.

Mapeamento de Nomenclatura (Mapping): Na importação do separador produtos_filial, a coluna idproduto da folha de cálculo foi mapeada explicitamente para a coluna de destino produto_id no banco de dados. O mesmo ocorreu para corrigir o erro de digitação decricao no SQL original para descricao.

Isolamento de Sujidade (Clean-up): No separador pedido_compra, o DBeaver foi configurado para ignorar o intervalo de colunas vazias geradas acidentalmente no Excel (Unnamed: 12 a Unnamed: 22).

Tipagem de Dados de Fornecedor: O campo idfornecedor na tabela original estava sugerido como Inteiro, mas na folha de cálculo possui o padrão alfanumérico "F1", "F2", etc. O tipo de dados no banco de destino foi retificado para varchar(25).

Valores Default Vazios: Parâmetros de default com erro de sintaxe nos scripts originais (ex: DEFAULT ::, DEFAULT '0", e DEFAULT NOT NULL em vez de DEFAULT 0 NOT NULL) foram higienizados antes da execução e carga.
