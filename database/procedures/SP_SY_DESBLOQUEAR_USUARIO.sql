USE DB_I_SEE_YOU;
GO

-- Usuário desfaz um bloqueio que ele mesmo fez.
--    Não apaga a linha: só preenche dt_fim, para manter o histórico.
--    Uso: EXEC dbo.SP_SY_DESBLOQUEAR_USUARIO @id_usuario = 2, @id_bloqueio = 3;
CREATE PROCEDURE dbo.SP_SY_DESBLOQUEAR_USUARIO
    @id_usuario  INT,
    @id_bloqueio INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.TB_SY_BLOQUEIO_USUARIO
                   WHERE id_bloqueio = @id_bloqueio
                     AND id_usuario  = @id_usuario
                     AND dt_fim IS NULL)
    BEGIN
        PRINT 'Bloqueio inexistente, já encerrado ou não pertence ao usuário.';
        RETURN;
    END;

    UPDATE dbo.TB_SY_BLOQUEIO_USUARIO
    SET dt_fim = SYSUTCDATETIME()
    WHERE id_bloqueio = @id_bloqueio;

    PRINT 'Bloqueio encerrado.';
END;
GO
