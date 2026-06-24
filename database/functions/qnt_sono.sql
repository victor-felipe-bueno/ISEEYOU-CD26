CREATE FUNCTION dbo.Qnt_sono 
(
    @hora_inicio DATETIME,
    @hora_termino DATETIME
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF @hora_inicio IS NULL OR @hora_termino IS NULL
        RETURN NULL;
    
    IF @hora_termino  @hora_inicio
        RETURN NULL;
        
    RETURN CAST(DATEDIFF(SECOND, @hora_inicio, @hora_termino)  3600.0 AS DECIMAL(4,2));
END;