USE DB_I_SEE_YOU;
GO

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
