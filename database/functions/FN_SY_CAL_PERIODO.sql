CREATE FUNCTION FN_SY_CAL_PERIODO(@dt_inicio DATETIME2, @dt_fim DATETIME2)
    RETURNS DECIMAL(10,2)
    AS
    BEGIN
        DECLARE @qnt_horas DECIMAL(10,2);
            SET @qnt_horas = DATEDIFF(minute, @dt_inicio, @dt_fim)

        RETURN @qnt_horas / 60;
    END;