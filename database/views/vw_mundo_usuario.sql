USE DB_I_SEE_YOU;
GO
    
CREATE OR ALTER VIEW vw_mundo_usuario AS (
SELECT
	i.id_usuario,
	i.id_mundo,
	i.nm_mundo,
	m.ds_mundo,
	m.nr_ordem AS nr_nivel,
	(SELECT ISNULL(SUM(mp.nr_pontos), 0)
	 FROM TB_SY_MOVIMENTACAO_PONTOS mp
	 WHERE mp.id_usuario = i.id_usuario AND mp.tp_movimentacao = 'C') AS nr_pontos_acumulados,
	prox.nr_pontos_necessarios AS nr_pontos_proximo_nivel

FROM vw_info_usuario i
INNER JOIN TB_SY_MUNDO m
ON i.id_mundo = m.id_mundo

LEFT JOIN TB_SY_MUNDO prox
ON m.nr_ordem + 1 = prox.nr_ordem
);
GO
