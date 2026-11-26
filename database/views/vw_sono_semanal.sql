USE BD_I_SEE_YOU;
GO

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
