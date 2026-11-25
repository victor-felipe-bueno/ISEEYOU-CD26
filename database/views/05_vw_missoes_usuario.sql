USE DB_I_SEE_YOU;

CREATE OR ALTER VIEW dbo.vw_missoes_usuario AS
WITH dia AS (
    SELECT CONVERT(DATE, (SYSUTCDATETIME() AT TIME ZONE 'UTC') AT TIME ZONE 'E. South America Standard Time') AS dt_hoje
),
categoria AS (
    SELECT
        ac.id_missao,
        STRING_AGG(c.nm_categoria, ', ') WITHIN GROUP (ORDER BY c.nm_categoria) AS ds_categorias
    FROM dbo.TB_SY_A_CATEGORIA_MISSAO ac
    JOIN dbo.TB_SY_CATEGORIA_MISSAO c
        ON c.id_categoria = ac.id_categoria
    GROUP BY ac.id_missao
),
base AS (
    SELECT
        u.id_usuario,
        m.id_missao,
        m.nm_missao,
        m.ds_missao,
        m.vl_ponto,
        cat.ds_categorias,
        um.dt_acesso,
        um.dt_conclusao,
        CASE
            WHEN um.fl_concluido = 1 THEN 'C'
            WHEN um.id_usuario IS NOT NULL THEN 'A'
            ELSE 'D'
        END AS st_missao,
        -- Concluída antes de hoje (horário de Brasília): sai da disputa pela missão do dia.
        CASE
            WHEN um.fl_concluido = 1
             AND CONVERT(DATE, (um.dt_conclusao AT TIME ZONE 'UTC') AT TIME ZONE 'E. South America Standard Time') < d.dt_hoje
            THEN 1 ELSE 0
        END AS fl_fechada_antes_hoje,
        d.dt_hoje,
        dbo.FN_SY_SALDO_PONTOS(u.id_usuario) AS nr_saldo_pontos
    FROM dbo.TB_SY_USUARIO u
    CROSS JOIN dbo.TB_SY_MISSAO m
    CROSS JOIN dia d
    LEFT JOIN dbo.TB_SY_A_USUARIO_MISSAO um
        ON um.id_usuario = u.id_usuario
       AND um.id_missao  = m.id_missao
    LEFT JOIN categoria cat
        ON cat.id_missao = m.id_missao
    WHERE u.dt_exclusao IS NULL
),
ordenada AS (
    SELECT
        b.*,
        ROW_NUMBER() OVER (
            PARTITION BY b.id_usuario
            ORDER BY b.fl_fechada_antes_hoje,
                     CHECKSUM(b.id_usuario, b.id_missao, b.dt_hoje),
                     b.id_missao
        ) AS nr_ordem
    FROM base b
)
SELECT
    o.id_usuario,
    o.id_missao,
    o.nm_missao,
    o.ds_missao,
    o.vl_ponto,
    o.ds_categorias,
    o.st_missao,
    o.dt_acesso,
    o.dt_conclusao,
    CAST(CASE WHEN o.nr_ordem = 1 AND o.fl_fechada_antes_hoje = 0 THEN 1 ELSE 0 END AS BIT) AS fl_missao_do_dia,
    o.nr_ordem,
    o.nr_saldo_pontos
FROM ordenada o;
GO
