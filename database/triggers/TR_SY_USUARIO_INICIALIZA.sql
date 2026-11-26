USE DB_I_SEE_YOU;
GO

-- Ao cadastrar um usuário, cria a sequência dele zerada.
--    ATENÇÃO: crie depois da carga de dados. A carga já insere as sequências,
--    e com o trigger ativo cada usuário ganharia uma segunda (erro de UNIQUE).
CREATE TRIGGER dbo.TR_SY_USUARIO_INICIALIZA
ON dbo.TB_SY_USUARIO
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.TB_SY_SEQUENCIA (nr_sequencia_atual, nr_maior_sequencia, dt_ultima_atividade, id_usuario)
    SELECT 0, 0, dt_registro, id_usuario
    FROM inserted;
END;
GO
