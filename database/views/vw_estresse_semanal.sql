USE DB_I_SEE_YOU;
GO

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
