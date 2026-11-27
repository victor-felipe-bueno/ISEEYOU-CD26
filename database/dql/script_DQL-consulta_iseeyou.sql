USE DB_I_SEE_YOU;
GO

-- vw_info_usuario
CREATE OR ALTER VIEW vw_info_usuario AS (
SELECT
	r.id_usuario,
	r.nm_exibicao,
	r.id_mundo,
	r.nm_mundo

FROM (
	SELECT
		mu.id_usuario,
		ISNULL(u.nm_exibicao, 'Desconhecido') AS nm_exibicao,
		mu.id_mundo,
		m.nm_mundo,
		ROW_NUMBER() OVER(PARTITION BY mu.id_usuario ORDER BY m.nr_ordem DESC) AS nr_rank

	FROM TB_SY_A_USUARIO_MUNDO mu
	LEFT JOIN TB_SY_USUARIO u
	ON mu.id_usuario = u.id_usuario

	LEFT JOIN TB_SY_MUNDO m
	ON mu.id_mundo = m.id_mundo
) r

WHERE r.nr_rank = 1
);
GO

-- vw_eventos_usuario
CREATE OR ALTER VIEW vw_eventos_usuario AS (
SELECT
	e.id_usuario,
	ISNULL(u.nm_exibicao, 'Desconhecido') AS nm_exibicao,
	e.nm_evento,
	e.ds_evento,
	CAST(DATEADD(HOUR, -3, e.dt_inicio) AS DATE) AS dt_inicio,
	FORMAT(DATEADD(HOUR, -3, e.dt_inicio), 'HH:mm') AS dt_hora_minuto_inicio,
	FORMAT(DATEADD(HOUR, -3, e.dt_inicio), 'dddd', 'pt-BR') AS dt_dia_semana,
	CAST(e.dt_fim AS DATE) AS dt_fim,
	FORMAT(DATEADD(HOUR, -3,e.dt_fim), 'HH:mm') AS dt_hora_minuto_fim,
	e.fl_concluido

FROM TB_SY_EVENTO e
LEFT JOIN TB_SY_USUARIO u
ON e.id_usuario = u.id_usuario
);
GO

-- vw_estresse_semanal
CREATE OR ALTER VIEW vw_estresse_semanal AS (
SELECT
	e.id_usuario,
	e.dt_dia,
	DATEADD(DAY, -(DATEDIFF(DAY, '19000101', e.dt_dia) % 7), e.dt_dia) AS dt_inicio_semana,
	CASE DATEDIFF(DAY, '19000101', e.dt_dia) % 7
		WHEN 0 THEN 'Seg'
		WHEN 1 THEN 'Ter'
		WHEN 2 THEN 'Qua'
		WHEN 3 THEN 'Qui'
		WHEN 4 THEN 'Sex'
		WHEN 5 THEN 'Sáb'
		WHEN 6 THEN 'Dom'
	END AS nm_dia_semana,
	DATEDIFF(DAY, '19000101', e.dt_dia) % 7 + 1 AS nr_dia_semana,
	MAX(e.nr_nivel) AS nr_pico

FROM (
	SELECT
		id_usuario,
		CAST(DATEADD(HOUR, -3, dt_registro) AS DATE) AS dt_dia,
		nr_nivel
	FROM TB_SY_MNT_ESTRESSE
) e

GROUP BY e.id_usuario, e.dt_dia
);
GO

-- vw_sono_semanal
CREATE OR ALTER VIEW vw_sono_semanal AS (
SELECT
	s.id_usuario,
	s.dt_dia,
	DATEADD(DAY, -(DATEDIFF(DAY, '19000101', s.dt_dia) % 7), s.dt_dia) AS dt_inicio_semana,
	CASE DATEDIFF(DAY, '19000101', s.dt_dia) % 7
		WHEN 0 THEN 'Seg'
		WHEN 1 THEN 'Ter'
		WHEN 2 THEN 'Qua'
		WHEN 3 THEN 'Qui'
		WHEN 4 THEN 'Sex'
		WHEN 5 THEN 'Sáb'
		WHEN 6 THEN 'Dom'
	END AS nm_dia_semana,
	DATEDIFF(DAY, '19000101', s.dt_dia) % 7 + 1 AS nr_dia_semana,
	SUM(s.nr_horas) AS nr_horas_dormidas,
	SUM(s.nr_despertares) AS nr_despertares,
	CAST(AVG(CAST(s.nr_qualidade AS DECIMAL(3,2))) AS DECIMAL(3,2)) AS nr_qualidade_media

FROM (
	SELECT
		id_usuario,
		CAST(DATEADD(HOUR, -3, dt_fim) AS DATE) AS dt_dia,
		nr_despertares,
		nr_qualidade,
		dbo.FN_SY_CAL_PERIODO(dt_inicio, dt_fim) AS nr_horas
	FROM TB_SY_MNT_SONO
) s

GROUP BY s.id_usuario, s.dt_dia
);
GO

-- vw_correlacao_sono_estresse
CREATE OR ALTER VIEW vw_correlacao_sono_estresse AS (
SELECT
	e.id_usuario,
	ISNULL(u.nm_exibicao, 'Desconhecido') AS nm_exibicao,
	e.nr_pico,
	s.nr_horas_dormidas,
	e.dt_dia

FROM vw_estresse_semanal e
INNER JOIN vw_sono_semanal s
ON e.id_usuario = s.id_usuario AND e.dt_dia = s.dt_dia

LEFT JOIN TB_SY_USUARIO u
ON e.id_usuario = u.id_usuario
);
GO

-- vw_missoes_usuario
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

-- vw_mundo_usuario
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
