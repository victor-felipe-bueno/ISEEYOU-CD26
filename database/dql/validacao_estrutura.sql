/*
    Projeto: ISEEYOU
    Arquivo: 01_validacao_estrutura.sql
    Objetivo: consultas rápidas para validar se tabelas, views, triggers e dados base foram criados.
*/

-- 1) Verificar tabelas criadas
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME LIKE 'TB_SY_%'
ORDER BY TABLE_NAME;
GO

-- 2) Verificar views criadas
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME LIKE 'VW_SY_%'
ORDER BY TABLE_NAME;
GO

-- 3) Verificar triggers criadas
SELECT
    name AS nm_trigger,
    OBJECT_NAME(parent_id) AS nm_tabela
FROM sys.triggers
WHERE name LIKE 'TR_TB_SY_%'
ORDER BY name;
GO

-- 4) Verificar quantidade de registros em tabelas de domínio
SELECT 'TB_SY_PLANO' AS nm_tabela, COUNT(*) AS qt_registros FROM dbo.TB_SY_PLANO
UNION ALL SELECT 'TB_SY_TP_CLASSIFICACAO', COUNT(*) FROM dbo.TB_SY_TP_CLASSIFICACAO
UNION ALL SELECT 'TB_SY_CLASSIFICACAO', COUNT(*) FROM dbo.TB_SY_CLASSIFICACAO
UNION ALL SELECT 'TB_SY_HUMOR', COUNT(*) FROM dbo.TB_SY_HUMOR
UNION ALL SELECT 'TB_SY_GATILHOS', COUNT(*) FROM dbo.TB_SY_GATILHOS
UNION ALL SELECT 'TB_SY_TP_TESTE', COUNT(*) FROM dbo.TB_SY_TP_TESTE
UNION ALL SELECT 'TB_SY_TESTE', COUNT(*) FROM dbo.TB_SY_TESTE
UNION ALL SELECT 'TB_SY_PERGUNTA_TESTE', COUNT(*) FROM dbo.TB_SY_PERGUNTA_TESTE
UNION ALL SELECT 'TB_SY_FAIXA_RESULTADO_TESTE', COUNT(*) FROM dbo.TB_SY_FAIXA_RESULTADO_TESTE;
GO

-- 5) Verificar classificações e seus intervalos
SELECT
    tp.nm_tp_classificacao,
    tp.vl_min,
    tp.vl_max,
    c.vl_classificacao,
    c.nm_classificacao
FROM dbo.TB_SY_CLASSIFICACAO AS c
INNER JOIN dbo.TB_SY_TP_CLASSIFICACAO AS tp
    ON tp.id_tp_classificacao = c.id_tp_classificacao
ORDER BY
    tp.id_tp_classificacao,
    c.vl_classificacao;
GO
