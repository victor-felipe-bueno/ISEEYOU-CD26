USE DB_I_SEE_YOU;
GO

-- Sempre que a sequência atual mudar, grava o antes e o depois no log.
CREATE TRIGGER dbo.TR_SY_SEQUENCIA_LOG_STATUS
ON dbo.TB_SY_SEQUENCIA
AFTER UPDATE
AS
BEGIN
    INSERT INTO dbo.TB_SY_LOG_STATUS_SEQUENCIA (nr_anterior, nr_novo, id_sequencia)
    SELECT d.nr_sequencia_atual, i.nr_sequencia_atual, i.id_sequencia
    FROM inserted i
    JOIN deleted d ON d.id_sequencia = i.id_sequencia
    -- só registra se o número mudou de verdade (o CHECK do log também exige isso)
    WHERE i.nr_sequencia_atual <> d.nr_sequencia_atual;
END;
GO
