# ISEEYOU — Scripts do banco de dados

Scripts em **SQL Server** para criação, popularização, validação e análise do banco de dados do projeto **ISEEYOU**.

Este repositório foi organizado separando os arquivos por responsabilidade: estrutura do banco, registros iniciais, consultas de análise, funções, triggers e views.

---

## Estrutura do projeto

```text
database/
├── ddl/
│   ├── index/
│   │   └── indexs.sql
│   ├── reset_tables/
│   │   └── reset_tables.sql
│   └── schema/
│       └── schema.sql
├── dml/
│   ├── registers_dados_base_1.sql
│   ├── registers_dados_base_2.sql
│   └── registers_dados_base_3.sql
├── dql/
│   ├── analise_geral.sql
│   └── validacao_estrutura.sql
├── functions/
│   └── qnt_sono.sql
├── procedures/
├── triggers/
│   └── tg_validacao.sql
└── views/
    └── views_analise.sql
```

---

## Descrição das pastas

### `ddl/`
Arquivos responsáveis pela estrutura do banco de dados.

- `ddl/schema/schema.sql`: cria as tabelas, chaves primárias, chaves estrangeiras e restrições principais.
- `ddl/index/indexs.sql`: cria índices auxiliares para melhorar consultas e relacionamentos.
- `ddl/reset_tables/reset_tables.sql`: remove ou reinicia objetos/tabelas do banco. Use apenas quando quiser recriar o banco do zero.

### `dml/`
Arquivos responsáveis pela inserção de dados.

- `dml/registers_dados_base_1.sql`: registros base do sistema, como planos, tipos, classificações e dados essenciais.
- `dml/registers_dados_base_2.sql`: registros fictícios para teste, como usuários, registros de sono, humor, estresse e feedback.
- `dml/registers_dados_base_3.sql`: registros complementares para aumentar o volume de dados e permitir mais testes de consulta/análise.

### `dql/`
Arquivos responsáveis por consultas.

- `dql/validacao_estrutura.sql`: consultas para validar se tabelas, constraints, relacionamentos e registros foram criados corretamente.
- `dql/analise_geral.sql`: consultas analíticas para explorar dados do aplicativo, como sono, humor, estresse, feedback e testes.

### `functions/`
Funções reutilizáveis do banco.

- `functions/qnt_sono.sql`: calcula a quantidade de horas dormidas a partir do horário de início e término do sono.

### `procedures/`
Pasta reservada para procedures. No momento, não há procedures definidas.

### `triggers/`
Gatilhos de validação e regras de negócio.

- `triggers/tg_validacao.sql`: contém triggers usadas para validar regras que não podem ser garantidas apenas com `CHECK`, como regras dependentes de outra tabela.

### `views/`
Views para facilitar consultas e análises.

- `views/views_analise.sql`: cria views voltadas para análise dos dados do aplicativo.

---

## Ordem recomendada de execução

Execute os scripts nesta ordem:

1. `ddl/reset_tables/reset_tables.sql`  
   Opcional. Use somente se quiser apagar/recriar a estrutura atual.

2. `ddl/schema/schema.sql`  
   Cria as tabelas, constraints, chaves primárias e chaves estrangeiras.

3. `ddl/index/indexs.sql`  
   Cria os índices auxiliares.

4. `functions/qnt_sono.sql`  
   Cria a função de cálculo da quantidade de horas de sono.

5. `triggers/tg_validacao.sql`  
   Cria triggers de validação e regras de negócio.

6. `views/views_analise.sql`  
   Cria views para análise e consultas recorrentes.

7. `dml/registers_dados_base_1.sql`  
   Insere os dados base do sistema.

8. `dml/registers_dados_base_2.sql`  
   Insere registros fictícios para teste.

9. `dml/registers_dados_base_3.sql`  
   Insere registros complementares para ampliar o volume de dados.

10. `dql/validacao_estrutura.sql`  
    Valida a estrutura criada e os principais objetos do banco.

11. `dql/analise_geral.sql`  
    Executa consultas analíticas gerais sobre os dados.

---

## Pontos de atenção

- O banco foi estruturado para **SQL Server**.
- O schema padrão utilizado é `dbo`.
- Os arquivos de `DML` usam dados fictícios e não devem conter informações reais de usuários.
- A função `qnt_sono.sql` deve retornar `NULL` quando os horários forem inválidos ou não informados.
- O arquivo `reset_tables.sql` deve ser usado com cuidado, pois pode apagar estruturas e dados existentes.
- Algumas validações foram feitas por trigger porque o SQL Server não permite que `CHECK` consulte valores em outra tabela.

---

## Objetivo dos scripts

A estrutura foi pensada para apoiar:

- criação do banco do projeto ISEEYOU;
- testes com dados fictícios;
- validação de integridade dos relacionamentos;
- análise de registros de sono, humor e estresse;
- organização do projeto para apresentação no TCC/TCS e versionamento no GitHub.
