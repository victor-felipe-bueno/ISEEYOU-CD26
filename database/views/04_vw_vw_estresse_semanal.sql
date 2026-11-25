USE DB_I_SEE_YOU;

CREATE OR ALTER VIEW vw_vw_estresse_semanal AS

WITH base AS (

    SELECT 
        id_usuario,
        CAST(DATEADD(HOUR, -3, dt_fim) AS DATE) AS dt_dia,
        nr_despertares,
        nr_qualidade,
        dbo.FN_SY_CAL_PERIODO(dt_inicio, dt_fim) AS nr_horas

    FROM TB_SY_MNT_SONO
    )

    SELECT
        id_usuario,
        dt_dia,
        DATEADD(DAY, -(DATEDIFF(DAY, '19000101', dt_dia) % 7), dt_dia) AS dt_inicio_semana,
        CASE DATEDIFF(DAY, '19000101', dt_dia) % 7
            WHEN 0 THEN 'Seg' 
            WHEN 1 THEN 'Ter' 
            WHEN 2 THEN 'Qua'
            WHEN 3 THEN 'Qui' 
            WHEN 4 THEN 'Sex' 
            WHEN 5 THEN 'Sáb'
            WHEN 6 THEN 'Dom'
        END 
            AS nm_dia_semana,
        DATEDIFF(DAY, '19000101', dt_dia) % 7 + 1 AS nr_dia_semana,
        SUM(nr_horas) AS nr_horas_dormidas,
        SUM(nr_despertares) AS nr_despertares,
        CAST(AVG(CAST(nr_qualidade AS DECIMAL(3,2))) AS DECIMAL(3,2)) AS nr_qualidade_media
    FROM base
    GROUP BY id_usuario, dt_dia
    ;
GO
