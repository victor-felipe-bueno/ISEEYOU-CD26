USE DB_I_SEE_YOU;
GO

-- Diz se o usuário é menor de idade: 1 = menor, 0 = maior, NULL = não existe.
--    Usa a FN_SY_IDADE, então precisa ser criada depois dela.
--    Uso: SELECT dbo.FN_SY_EH_MENOR(1);
CREATE FUNCTION dbo.FN_SY_EH_MENOR (@id_usuario INT)
RETURNS BIT
AS
BEGIN
    DECLARE @dt_nascimento DATE;

    SELECT @dt_nascimento = dt_nascimento
    FROM dbo.TB_SY_USUARIO
    WHERE id_usuario = @id_usuario;

    IF @dt_nascimento IS NULL
        RETURN NULL;

    IF dbo.FN_SY_IDADE(@dt_nascimento) < 18
        RETURN 1;

    RETURN 0;
END;
GO
