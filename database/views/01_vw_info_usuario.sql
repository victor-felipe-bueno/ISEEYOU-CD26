USE DB_I_SEE_YOU;

CREATE OR ALTER VIEW vw_info_usuario AS

WITH MundoRanqueado AS (

SELECT 
	mu.id_usuario,
	ISNULL(u.nm_exibicao, 'Desconhecido') AS nm_exibicao,
    mu.id_mundo,
    m.nm_mundo,
    ROW_NUMBER() OVER( PARTITION BY mu.id_usuario ORDER BY m.nr_ordem DESC) AS nr_rank

FROM TB_SY_A_USUARIO_MUNDO mu
LEFT JOIN TB_SY_USUARIO u
ON mu.id_usuario = u.id_usuario

LEFT JOIN TB_SY_MUNDO m
ON mu.id_mundo = m.id_mundo
)

SELECT 
    id_usuario,
    nm_exibicao,
    id_mundo,
    nm_mundo    
FROM MundoRanqueado
WHERE nr_rank = 1
;
GO
