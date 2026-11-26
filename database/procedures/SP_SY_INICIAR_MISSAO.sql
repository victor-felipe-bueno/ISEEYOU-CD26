USE DB_I_SEE_YOU;
GO

-- Usuário abre uma missão (fica com fl_concluido = 0).
--    Se a missão não existir, a FK do banco já barra o INSERT.
--    Uso: EXEC dbo.SP_SY_INICIAR_MISSAO @id_usuario = 1, @id_missao = 3;
CREATE PROCEDURE dbo.SP_SY_INICIAR_MISSAO
    @id_usuario INT,
    @id_missao  INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.TB_SY_USUARIO
                   WHERE id_usuario = @id_usuario AND dt_exclusao IS NULL)
    BEGIN
        PRINT 'Usuário inexistente ou excluído.';
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM dbo.TB_SY_A_USUARIO_MISSAO
               WHERE id_usuario = @id_usuario AND id_missao = @id_missao)
    BEGIN
        PRINT 'Essa missão já foi iniciada.';
        RETURN;
    END;

    INSERT INTO dbo.TB_SY_A_USUARIO_MISSAO (id_usuario, id_missao)
    VALUES (@id_usuario, @id_missao);

    PRINT 'Missão iniciada.';
END;
GO
