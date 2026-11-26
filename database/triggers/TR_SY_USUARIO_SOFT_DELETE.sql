USE DB_I_SEE_YOU;
GO

-- DELETE de usuário vira exclusão lógica: só preenche dt_exclusao.
--    INSTEAD OF = roda NO LUGAR do DELETE, então a linha não é apagada
--    e as FKs dos registros do usuário não quebram.
CREATE TRIGGER dbo.TR_SY_USUARIO_SOFT_DELETE
ON dbo.TB_SY_USUARIO
INSTEAD OF DELETE
AS
BEGIN
    UPDATE dbo.TB_SY_USUARIO
    SET dt_exclusao = SYSUTCDATETIME()
    WHERE id_usuario IN (SELECT id_usuario FROM deleted)
      AND dt_exclusao IS NULL;
END;
GO
