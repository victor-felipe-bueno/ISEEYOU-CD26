USE DB_I_SEE_YOU;

CREATE OR ALTER VIEW dbo.vw_mundo_usuario AS
SELECT
    u.id_usuario,
    atual.id_mundo,
    atual.nm_mundo,
    atual.ds_mundo,
    atual.nr_ordem AS nr_nivel,
    p.nr_pontos AS nr_pontos_acumulados,
    prox.id_mundo AS id_mundo_proximo,
    prox.nm_mundo AS nm_mundo_proximo,
    prox.nr_pontos_necessarios AS nr_pontos_proximo_nivel,
    CASE
        WHEN prox.id_mundo IS NULL THEN 100
        WHEN p.nr_pontos >= prox.nr_pontos_necessarios THEN 100
        ELSE p.nr_pontos * 100 / prox.nr_pontos_necessarios
    END AS nr_percentual_progresso
FROM dbo.TB_SY_USUARIO u
CROSS APPLY (SELECT dbo.FN_SY_PONTOS_ACUMULADOS(u.id_usuario) AS nr_pontos) p
OUTER APPLY (
    SELECT TOP (1) m.id_mundo, m.nm_mundo, m.ds_mundo, m.nr_ordem
    FROM dbo.TB_SY_A_USUARIO_MUNDO um
    JOIN dbo.TB_SY_MUNDO m
        ON m.id_mundo = um.id_mundo
    WHERE um.id_usuario = u.id_usuario
    ORDER BY m.nr_ordem DESC
) atual
OUTER APPLY (
    SELECT TOP (1) m.id_mundo, m.nm_mundo, m.nr_pontos_necessarios
    FROM dbo.TB_SY_MUNDO m
    WHERE m.fl_ativo = 1
      AND m.nr_ordem > ISNULL(atual.nr_ordem, 0)
    ORDER BY m.nr_ordem
) prox
WHERE u.dt_exclusao IS NULL;
GO
