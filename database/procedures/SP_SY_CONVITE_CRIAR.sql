USE DB_I_SEE_YOU;
GO

-- Usuário cria um convite de guardião (nasce pendente, 'P').
--    O guardião só é preenchido quando alguém aceitar.
--    tp_relacao: F família | A amigo | P parceiro | O outro
--    Uso: EXEC dbo.SP_SY_CONVITE_CRIAR @id_usuario_monitorado = 1, @tp_relacao = 'F';
CREATE PROCEDURE dbo.SP_SY_CONVITE_CRIAR
    @id_usuario_monitorado INT,
    @tp_relacao            CHAR(1)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.TB_SY_USUARIO
                   WHERE id_usuario = @id_usuario_monitorado AND dt_exclusao IS NULL)
    BEGIN
        PRINT 'Usuário inexistente ou excluído.';
        RETURN;
    END;

    -- st_convite e dt_solicitacao são preenchidos pelo DEFAULT da tabela
    INSERT INTO dbo.TB_SY_CONVITE_GUARDIAO (tp_relacao, id_usuario_monitorado)
    VALUES (@tp_relacao, @id_usuario_monitorado);

    PRINT 'Convite criado.';
END;
GO
