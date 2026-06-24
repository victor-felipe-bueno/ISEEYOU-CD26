/*
    Projeto: ISEEYOU
    Arquivo: 02_consultas_analise_app.sql
    Objetivo: consultas úteis para análise no app, dashboard e Power BI.
*/

DECLARE @id_usuario INT = 1;

-- 1) Linha do tempo geral do usuário: sono, humor, estresse e feedback
SELECT
    dt_referencia,
    dt_evento,
    tp_registro,
    id_registro,
    vl_classificacao,
    nm_classificacao,
    ds_detalhe,
    vl_auxiliar AS horas_sono_quando_aplicavel
FROM dbo.VW_SY_REGISTROS_DIARIOS
WHERE id_usuario = @id_usuario
ORDER BY dt_evento DESC;
GO

-- 2) Média diária de sono por usuário
SELECT
    id_usuario,
    dt_sono,
    qt_registros_sono,
    media_horas_sono,
    media_classificacao_sono
FROM dbo.VW_SY_RESUMO_SONO
ORDER BY dt_sono DESC, id_usuario;
GO

-- 3) Evolução semanal do estresse
SELECT
    e.id_usuario,
    DATEPART(YEAR, e.dt_registro) AS nr_ano,
    DATEPART(WEEK, e.dt_registro) AS nr_semana,
    COUNT(*) AS qt_registros_estresse,
    AVG(CAST(c.vl_classificacao AS DECIMAL(10,2))) AS media_estresse
FROM dbo.TB_SY_MNT_ESTRESSE AS e
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = e.id_classificacao
GROUP BY
    e.id_usuario,
    DATEPART(YEAR, e.dt_registro),
    DATEPART(WEEK, e.dt_registro)
ORDER BY
    e.id_usuario,
    nr_ano,
    nr_semana;
GO

-- 4) Humor mais registrado por usuário
WITH humor_rank AS (
    SELECT
        rh.id_usuario,
        h.nm_humor,
        COUNT(*) AS qt_registros,
        ROW_NUMBER() OVER (
            PARTITION BY rh.id_usuario
            ORDER BY COUNT(*) DESC
        ) AS nr_ranking
    FROM dbo.TB_SY_REGISTRO_HUMOR AS rh
    INNER JOIN dbo.TB_SY_HUMOR AS h
        ON h.id_humor = rh.id_humor
    GROUP BY
        rh.id_usuario,
        h.nm_humor
)
SELECT
    id_usuario,
    nm_humor,
    qt_registros
FROM humor_rank
WHERE nr_ranking = 1
ORDER BY id_usuario;
GO

-- 5) Principais gatilhos relacionados ao estresse
SELECT
    g.nm_gatilho,
    COUNT(*) AS qt_ocorrencias,
    AVG(CAST(c.vl_classificacao AS DECIMAL(10,2))) AS media_estresse
FROM dbo.TB_SY_A_ESTRESSE_GATILHO AS eg
INNER JOIN dbo.TB_SY_GATILHOS AS g
    ON g.id_gatilho = eg.id_gatilho
INNER JOIN dbo.TB_SY_MNT_ESTRESSE AS e
    ON e.id_estresse = eg.id_estresse
INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
    ON c.id_classificacao = e.id_classificacao
GROUP BY
    g.nm_gatilho
ORDER BY
    qt_ocorrencias DESC,
    media_estresse DESC;
GO

-- 6) Resultado dos testes aplicados
SELECT
    id_usuario,
    dt_aplicacao,
    nm_teste,
    nm_tipo_teste,
    nr_pontuacao_total,
    nm_resultado,
    vl_min_pontuacao,
    vl_max_pontuacao
FROM dbo.VW_SY_RESULTADO_TESTE
ORDER BY dt_aplicacao DESC;
GO

-- 7) Sono x estresse no mesmo dia
WITH sono_dia AS (
    SELECT
        id_usuario,
        dt_sono AS dt_referencia,
        media_horas_sono,
        media_classificacao_sono
    FROM dbo.VW_SY_RESUMO_SONO
),
estresse_dia AS (
    SELECT
        e.id_usuario,
        CAST(e.dt_registro AS DATE) AS dt_referencia,
        AVG(CAST(c.vl_classificacao AS DECIMAL(10,2))) AS media_estresse
    FROM dbo.TB_SY_MNT_ESTRESSE AS e
    INNER JOIN dbo.TB_SY_CLASSIFICACAO AS c
        ON c.id_classificacao = e.id_classificacao
    GROUP BY
        e.id_usuario,
        CAST(e.dt_registro AS DATE)
)
SELECT
    COALESCE(s.id_usuario, e.id_usuario) AS id_usuario,
    COALESCE(s.dt_referencia, e.dt_referencia) AS dt_referencia,
    s.media_horas_sono,
    s.media_classificacao_sono,
    e.media_estresse
FROM sono_dia AS s
FULL OUTER JOIN estresse_dia AS e
    ON e.id_usuario = s.id_usuario
   AND e.dt_referencia = s.dt_referencia
ORDER BY
    id_usuario,
    dt_referencia;
GO

-- 8) Usuários sem registros de acompanhamento
SELECT
    u.id_usuario,
    u.nm_completo,
    u.ds_email
FROM dbo.TB_SY_USUARIO AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.VW_SY_REGISTROS_DIARIOS AS r
    WHERE r.id_usuario = u.id_usuario
)
ORDER BY u.nm_completo;
GO

-- 9) Quantidade de assinaturas por plano e status
SELECT
    p.nm_plano,
    a.st_status,
    COUNT(*) AS qt_assinaturas,
    SUM(a.nr_valor) AS vl_total
FROM dbo.TB_SY_ASSINATURA AS a
INNER JOIN dbo.TB_SY_PLANO AS p
    ON p.id_plano = a.id_plano
GROUP BY
    p.nm_plano,
    a.st_status
ORDER BY
    p.nm_plano,
    a.st_status;
GO

-- 10) Base única para dashboard diário do usuário
SELECT
    id_usuario,
    dt_referencia,
    SUM(CASE WHEN tp_registro = 'SONO' THEN 1 ELSE 0 END) AS qt_reg_sono,
    SUM(CASE WHEN tp_registro = 'HUMOR' THEN 1 ELSE 0 END) AS qt_reg_humor,
    SUM(CASE WHEN tp_registro = 'ESTRESSE' THEN 1 ELSE 0 END) AS qt_reg_estresse,
    AVG(CASE WHEN tp_registro = 'SONO' THEN vl_auxiliar END) AS media_horas_sono,
    AVG(CASE WHEN tp_registro = 'HUMOR' THEN CAST(vl_classificacao AS DECIMAL(10,2)) END) AS media_humor,
    AVG(CASE WHEN tp_registro = 'ESTRESSE' THEN CAST(vl_classificacao AS DECIMAL(10,2)) END) AS media_estresse
FROM dbo.VW_SY_REGISTROS_DIARIOS
GROUP BY
    id_usuario,
    dt_referencia
ORDER BY
    id_usuario,
    dt_referencia;
GO
