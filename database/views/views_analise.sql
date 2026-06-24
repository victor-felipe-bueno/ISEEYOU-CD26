/*
    Projeto: ISEEYOU
    Arquivo: 01_views_analise.sql
    Objetivo: criar views úteis para análise, dashboard e validação dos dados.
*/

CREATE OR ALTER VIEW dbo.VW_SY_USUARIO_PERFIL AS
SELECT
    u.id_usuario,
    u.nm_completo,
    u.ds_email,
    u.nr_telefone,
    u.tp_perfil,
    CASE WHEN pf.id_usuario IS NOT NULL THEN 1 ELSE 0 END AS fl_pessoa_fisica,
    pf.dt_nascimento,
    pf.ds_email_guardiao,
    CASE WHEN ps.id_usuario IS NOT NULL THEN 1 ELSE 0 END AS fl_psicologo,
    ps.nr_crp,
    ps.id_endereco
FROM dbo.TB_SY_USUARIO AS u
LEFT JOIN dbo.TB_SY_PESSOA_FISICA AS pf
    ON pf.id_usuario = u.id_usuario
LEFT JOIN dbo.TB_SY_PSICOLOGO AS ps
    ON ps.id_usuario = u.id_usuario;
GO

CREATE OR ALTER VIEW dbo.VW_SY_REGISTROS_DIARIOS AS
SELECT
    rh.id_usuario,
    CAST(rh.dt_registro AS DATE) AS dt_referencia,
    rh.dt_registro AS dt_evento,
    'HUMOR' AS tp_registro,
    rh.id_registro_humor AS id_registro,
    rh.id_classificacao,
    c.vl_classificacao,
    c.nm_classificacao,
    h.nm_humor AS ds_detalhe,
    CAST(NULL AS DECIMAL(10,2)) AS vl_auxiliar
FROM dbo.TB_SY_REGISTRO_HUMOR AS rh
INNER JOIN dbo.TB_SY_HUMOR AS h
    ON h.id_humor = rh.id_humor
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = rh.id_classificacao

UNION ALL

SELECT
    s.id_usuario,
    CAST(s.dt_inicio AS DATE) AS dt_referencia,
    s.dt_inicio AS dt_evento,
    'SONO' AS tp_registro,
    s.id_sono AS id_registro,
    s.id_classificacao,
    c.vl_classificacao,
    c.nm_classificacao,
    s.ds_sono AS ds_detalhe,
    CAST(DATEDIFF(MINUTE, s.dt_inicio, s.dt_fim) / 60.0 AS DECIMAL(10,2)) AS vl_auxiliar
FROM dbo.TB_SY_MNT_SONO AS s
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = s.id_classificacao

UNION ALL

SELECT
    e.id_usuario,
    CAST(e.dt_registro AS DATE) AS dt_referencia,
    e.dt_registro AS dt_evento,
    'ESTRESSE' AS tp_registro,
    e.id_estresse AS id_registro,
    e.id_classificacao,
    c.vl_classificacao,
    c.nm_classificacao,
    e.ds_estresse AS ds_detalhe,
    CAST(NULL AS DECIMAL(10,2)) AS vl_auxiliar
FROM dbo.TB_SY_MNT_ESTRESSE AS e
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = e.id_classificacao

UNION ALL

SELECT
    f.id_usuario,
    CAST(f.dt_registro AS DATE) AS dt_referencia,
    f.dt_registro AS dt_evento,
    'FEEDBACK' AS tp_registro,
    f.id_feedback AS id_registro,
    f.id_classificacao,
    c.vl_classificacao,
    c.nm_classificacao,
    f.ds_feedback AS ds_detalhe,
    CAST(NULL AS DECIMAL(10,2)) AS vl_auxiliar
FROM dbo.TB_SY_FEEDBACK AS f
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = f.id_classificacao;
GO

CREATE OR ALTER VIEW dbo.VW_SY_RESUMO_SONO AS
SELECT
    s.id_usuario,
    CAST(s.dt_inicio AS DATE) AS dt_sono,
    COUNT(*) AS qt_registros_sono,
    AVG(CAST(DATEDIFF(MINUTE, s.dt_inicio, s.dt_fim) / 60.0 AS DECIMAL(10,2))) AS media_horas_sono,
    AVG(CAST(c.vl_classificacao AS DECIMAL(10,2))) AS media_classificacao_sono,
    MIN(s.dt_inicio) AS primeira_hora_inicio,
    MAX(s.dt_fim) AS ultima_hora_fim
FROM dbo.TB_SY_MNT_SONO AS s
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = s.id_classificacao
GROUP BY
    s.id_usuario,
    CAST(s.dt_inicio AS DATE);
GO

CREATE OR ALTER VIEW dbo.VW_SY_RESULTADO_TESTE AS
SELECT
    ap.id_aplicacao,
    ap.id_usuario,
    ap.dt_aplicacao,
    ap.nr_pontuacao_total,
    t.id_teste,
    t.nm_teste,
    tt.nm_tipo_teste,
    f.id_faixa_resultado,
    f.vl_min_pontuacao,
    f.vl_max_pontuacao,
    c.id_classificacao,
    c.vl_classificacao,
    c.nm_classificacao AS nm_resultado
FROM dbo.TB_SY_APLICACAO_TESTE AS ap
INNER JOIN dbo.TB_SY_TESTE AS t
    ON t.id_teste = ap.id_teste
INNER JOIN dbo.TB_SY_TP_TESTE AS tt
    ON tt.id_tp_teste = t.id_tp_teste
INNER JOIN dbo.TB_SY_FAIXA_RESULTADO_TESTE AS f
    ON f.id_faixa_resultado = ap.id_faixa_resultado
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = f.id_classificacao;
GO

CREATE OR ALTER VIEW dbo.VW_SY_ESTRESSE_GATILHOS AS
SELECT
    e.id_estresse,
    e.id_usuario,
    e.dt_registro,
    CAST(e.dt_registro AS DATE) AS dt_estresse,
    e.ds_estresse,
    c.vl_classificacao AS vl_estresse,
    c.nm_classificacao,
    STRING_AGG(g.nm_gatilho, ', ') AS gatilhos
FROM dbo.TB_SY_MNT_ESTRESSE AS e
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = e.id_classificacao
LEFT JOIN dbo.TB_SY_A_ESTRESSE_GATILHO AS eg
    ON eg.id_estresse = e.id_estresse
LEFT JOIN dbo.TB_SY_GATILHOS AS g
    ON g.id_gatilho = eg.id_gatilho
GROUP BY
    e.id_estresse,
    e.id_usuario,
    e.dt_registro,
    e.ds_estresse,
    c.vl_classificacao,
    c.nm_classificacao;
GO

CREATE OR ALTER VIEW dbo.VW_SY_ASSINATURAS_ATIVAS AS
SELECT
    a.id_assinatura,
    a.id_usuario,
    u.nm_completo,
    u.ds_email,
    a.id_plano,
    p.nm_plano,
    p.ds_plano,
    a.dt_assinatura,
    a.nr_valor,
    a.sg_tipo_pagamento,
    a.tp_periodo,
    a.st_status
FROM dbo.TB_SY_ASSINATURA AS a
INNER JOIN dbo.TB_SY_USUARIO AS u
    ON u.id_usuario = a.id_usuario
INNER JOIN dbo.TB_SY_PLANO AS p
    ON p.id_plano = a.id_plano
WHERE a.st_status = 'A';
GO
