USE DB_I_SEE_YOU;
GO

-- Idade em anos completos a partir da data de nascimento.
--    Uso: SELECT dbo.FN_SY_IDADE('2009-01-15');
CREATE FUNCTION dbo.FN_SY_IDADE (@dt_nascimento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @idade INT;

    -- DATEDIFF só conta a virada do ano
    SET @idade = DATEDIFF(YEAR, @dt_nascimento, GETDATE());

    -- Se o aniversário deste ano ainda não chegou, tira 1
    IF DATEADD(YEAR, @idade, @dt_nascimento) > GETDATE()
        SET @idade = @idade - 1;

    RETURN @idade;
END;
GO
