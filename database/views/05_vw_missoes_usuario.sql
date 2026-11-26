USE DB_I_SEE_YOU;
GO
    
CREATE OR ALTER VIEW vw_missoes_usuario AS (
SELECT
	u.id_usuario,
	m.id_missao,
	m.nm_missao,
	m.ds_missao,
	m.vl_ponto,
	ISNULL(um.fl_concluido, 0) AS fl_concluido,
	dbo.FN_SY_SALDO_PONTOS(u.id_usuario) AS nr_saldo_pontos

FROM TB_SY_USUARIO u
CROSS JOIN TB_SY_MISSAO m
LEFT JOIN TB_SY_A_USUARIO_MISSAO um
ON u.id_usuario = um.id_usuario AND m.id_missao = um.id_missao

WHERE u.dt_exclusao IS NULL
);
GO
