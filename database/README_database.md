# I SEE YOU — Banco de dados

Scripts T-SQL do banco **`DB_I_SEE_YOU`**, a camada de dados do I SEE YOU (TCC do Técnico em Ciência de Dados 2026 — CEDUP Timbó).

O modelo segue o **DER V14** (disponível em [`docs/diagramas/`](../docs/diagramas/)) e cobre monitoramento emocional, sono, memórias afetivas, eventos, gamificação, comunidade anônima, guardiões, assinaturas e LGPD.

| Item | Valor |
|---|---|
| SGBD | Microsoft SQL Server **2019 ou superior** |
| Banco | `DB_I_SEE_YOU` (collation `Latin1_General_100_CI_AS_SC_UTF8`) |
| Schema | `dbo` |
| Tabelas | 47 (prefixo `TB_SY_`) |
| Carga de teste | ~777 mil linhas fictícias (1.008 usuários) |

> O SQL Server 2019+ é obrigatório por causa da collation UTF-8. O DDL verifica a versão e aborta se ela for menor.

---

## Estrutura

```text
database/
├── ddl/          criação do banco, tabelas, constraints e índices
├── dml/          carga de dados fictícios (4 partes)
├── dql/          script consolidado de views de consulta
├── functions/    funções escalares (FN_SY_*)
├── views/        views de análise (vw_*)
├── procedures/   stored procedures (SP_SY_*)
└── triggers/     triggers de regra de negócio (TR_SY_*)
```

### `ddl/`
- **`script_DDL-iseeyou.sql`** — cria o banco `DB_I_SEE_YOU`, as 47 tabelas, PKs, FKs, UNIQUEs, CHECKs, DEFAULTs e índices em uma única transação. Colunas sensíveis (nome, e-mail, senha, data de nascimento, dados do responsável) usam **Dynamic Data Masking**.

### `dml/`
Carga gerada por `gerador/gerar.py` (seed `20261118`). Cada bloco de tabela é atômico: se falhar, nada dele é gravado e dá para rodar só aquele bloco de novo.

| Arquivo | Cargas | Conteúdo principal |
|---|---|---|
| `script_DML-popula_iseeyou_parte1de4.sql` | 01–23 | Catálogos (planos, humores, gatilhos, missões, mundos, prêmios, áudios), usuários, responsáveis, termos LGPD, dispositivos, log de acesso |
| `script_DML-popula_iseeyou_parte2de4.sql` | 24–26 | Registros de sono e de humor |
| `script_DML-popula_iseeyou_parte3de4.sql` | 27–38 | Estresse e gatilhos, eventos, pontos, missões, conquistas, mundos, memórias, resgates, log de sequência (parte 1) |
| `script_DML-popula_iseeyou_parte4de4.sql` | 39–50 | Log de sequência (parte 2), comunidade (publicações, reações, denúncias, bloqueios), guardiões, assinaturas |

Os arquivos são grandes (5 a 21 MB). Prefira rodar pelo `sqlcmd` em vez de abrir no SSMS.

### `functions/`
| Função | Retorno | O que faz |
|---|---|---|
| `FN_SY_IDADE(@dt_nascimento)` | `INT` | Idade em anos completos |
| `FN_SY_EH_MENOR(@id_usuario)` | `BIT` | 1 = menor de idade, 0 = maior, `NULL` = usuário não existe. Depende de `FN_SY_IDADE` |
| `FN_SY_CAL_PERIODO(@dt_inicio, @dt_fim)` | `DECIMAL(10,2)` | Horas entre duas datas (usada para a duração do sono) |
| `FN_SY_SALDO_PONTOS(@usuario)` | `INT` | Saldo de pontos: créditos (`C`) menos débitos (`D`) |

### `views/`
| View | O que entrega | Depende de |
|---|---|---|
| `vw_info_usuario` | Usuário e o mundo mais avançado que ele desbloqueou | — |
| `vw_mundo_usuario` | Mundo atual, pontos acumulados e pontos para o próximo nível | `vw_info_usuario` |
| `vw_missoes_usuario` | Todas as missões por usuário ativo, com status e saldo de pontos | `FN_SY_SALDO_PONTOS` |
| `vw_eventos_usuario` | Agenda de eventos com data, hora e dia da semana | — |
| `vw_estresse_semanal` | Pico diário de estresse, agrupado por semana | — |
| `vw_sono_semanal` | Horas dormidas, despertares e qualidade média por dia | `FN_SY_CAL_PERIODO` |

As views convertem datas de UTC para o horário de Brasília (`DATEADD(HOUR, -3, ...)`).

### `dql/`
- **`script_DQL-consulta_iseeyou.sql`** — reúne todas as views acima em um único script e acrescenta a **`vw_correlacao_sono_estresse`** (pico de estresse × horas dormidas no mesmo dia), que só existe aqui.

### `procedures/`
| Procedure | O que faz |
|---|---|
| `SP_SY_CONVITE_CRIAR` | Cria um convite de guardião pendente para um usuário ativo |
| `SP_SY_INICIAR_MISSAO` | Inicia uma missão para o usuário, se ainda não foi iniciada |
| `SP_SY_DESBLOQUEAR_USUARIO` | Encerra um bloqueio preenchendo `dt_fim`, sem apagar o histórico |

### `triggers/`
| Trigger | Tabela | O que faz |
|---|---|---|
| `TR_SY_USUARIO_INICIALIZA` | `TB_SY_USUARIO` | Cria a sequência zerada do novo usuário |
| `TR_SY_USUARIO_SOFT_DELETE` | `TB_SY_USUARIO` | Troca o `DELETE` por exclusão lógica (`dt_exclusao`) |
| `TR_SY_SEQUENCIA_LOG_STATUS` | `TB_SY_SEQUENCIA` | Grava o valor anterior e o novo da sequência no log |
| `tg_validacao.sql` | — | **Legado**: ver pontos de atenção |

---

## Ordem de execução

1. `ddl/script_DDL-iseeyou.sql`
2. `dml/` partes **1 → 2 → 3 → 4**, nessa ordem
3. `functions/`: `FN_SY_IDADE` → `FN_SY_EH_MENOR` → `FN_SY_CAL_PERIODO` → `FN_SY_SALDO_PONTOS`
4. `views/`: `vw_info_usuario` antes de `vw_mundo_usuario`; as demais em qualquer ordem
5. `procedures/`
6. `triggers/` (**sempre depois da carga**)

Exemplo com `sqlcmd`:

```bash
sqlcmd -S localhost -E -i ddl/script_DDL-iseeyou.sql
sqlcmd -S localhost -E -i dml/script_DML-popula_iseeyou_parte1de4.sql
# ... partes 2, 3 e 4
```

> **Por que os triggers ficam por último:** a carga já insere as sequências dos usuários. Com `TR_SY_USUARIO_INICIALIZA` ativo, cada usuário ganharia uma segunda sequência e a carga quebraria na constraint UNIQUE.

---

## Convenção de nomes

| Objeto | Padrão |
|---|---|
| Tabela | `TB_SY_NOME` (associativas: `TB_SY_A_...`) |
| Primary key | `PK_NOME_TABELA` |
| Foreign key | `FK_TABELA_ORIGEM_TABELA_DESTINO` (associativas: `PF_...`) |
| Unique / Check / Default | `UN_...` / `CK_...` / `DF_...` |
| Índice não único | `IX_TABELA_COLUNA(S)` |
| Função / Procedure / Trigger / View | `FN_SY_` / `SP_SY_` / `TR_SY_` / `vw_` |

Todas as FKs usam `NO ACTION`.

---

## Pontos de atenção

Problemas conhecidos nos scripts atuais. Corrija antes de rodar a pasta inteira:

- **`views/vw_sono_semanal.sql`** usa `USE BD_I_SEE_YOU`, mas o banco se chama `DB_I_SEE_YOU`. Do jeito que está, o script falha.
- **`functions/FN_SY_SALDO_PONTOS.sql`** cria um índice antes da função sem `GO` entre os dois. No SQL Server, `CREATE FUNCTION` precisa ser o primeiro comando do lote, então o script dá erro. Esse índice também duplica parte do `IX_MOVIMENTACAO_PONTOS_ID_USUARIO_DT_REGISTRO`, que já existe no DDL.
- **`FN_SY_CAL_PERIODO.sql`** e **`FN_SY_SALDO_PONTOS.sql`** não têm `USE DB_I_SEE_YOU`, então criam a função no banco que estiver selecionado na sessão.
- **`triggers/tg_validacao.sql`** é de uma versão antiga do modelo: referencia tabelas que não existem no DDL V14 (`TB_SY_CLASSIFICACAO`, `TB_SY_TP_CLASSIFICACAO`, `TB_SY_APLICACAO_TESTE`, `TB_SY_RESPOSTA_TESTE_USUARIO`). **Não execute.**
- **`vw_eventos_usuario`** converte `dt_inicio` para o horário de Brasília, mas não converte `dt_fim`.
- As funções e procedures usam `CREATE`, não `CREATE OR ALTER`. Rodar de novo gera erro de objeto já existente.
- `procedures/deleteme` é só um arquivo para manter a pasta no Git e pode ser apagado.

---

## Dados e LGPD

- Toda a carga é **fictícia**, gerada por script. Não suba dados reais de usuários para este repositório.
- O DDL aplica máscara dinâmica nas colunas sensíveis. Um usuário sem permissão `UNMASK` vê os dados mascarados.
- As análises das views mostram associações (por exemplo, sono × estresse), não relações de causa e efeito, e **não são diagnóstico**.
