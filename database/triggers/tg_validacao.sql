/*
    Projeto: ISEEYOU
    Arquivo: 01_triggers_validacao.sql
    Objetivo: criar triggers para regras que dependem de relacionamento entre tabelas.

    Observação importante:
    CHECK não consegue consultar outra tabela no SQL Server. Por isso, regras como
    "vl_classificacao deve ficar entre vl_min e vl_max do tipo" foram implementadas aqui.
*/

CREATE OR ALTER TRIGGER dbo.TR_TB_SY_CLASSIFICACAO_VALIDAR_FAIXA
ON dbo.TB_SY_CLASSIFICACAO
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.TB_SY_TP_CLASSIFICACAO AS tp
            ON tp.id_tp_classificacao = i.id_tp_classificacao
        WHERE i.vl_classificacao < tp.vl_min
           OR i.vl_classificacao > tp.vl_max
    )
    BEGIN
        THROW 50001, 'Classificacao invalida: vl_classificacao deve ficar entre vl_min e vl_max do tipo de classificacao.', 1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_TB_SY_TP_CLASSIFICACAO_VALIDAR_ATUALIZACAO
ON dbo.TB_SY_TP_CLASSIFICACAO
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.TB_SY_CLASSIFICACAO AS c
        INNER JOIN inserted AS tp
            ON tp.id_tp_classificacao = c.id_tp_classificacao
        WHERE c.vl_classificacao < tp.vl_min
           OR c.vl_classificacao > tp.vl_max
    )
    BEGIN
        THROW 50002, 'Atualizacao invalida: ja existem classificacoes fora do novo intervalo definido para o tipo.', 1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_TB_SY_APLICACAO_TESTE_VALIDAR_FAIXA
ON dbo.TB_SY_APLICACAO_TESTE
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.TB_SY_FAIXA_RESULTADO_TESTE AS f
            ON f.id_faixa_resultado = i.id_faixa_resultado
        WHERE f.id_teste <> i.id_teste
    )
    BEGIN
        THROW 50003, 'Aplicacao de teste invalida: a faixa de resultado informada nao pertence ao teste aplicado.', 1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_TB_SY_RESPOSTA_TESTE_USUARIO_VALIDAR_PERGUNTA
ON dbo.TB_SY_RESPOSTA_TESTE_USUARIO
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.TB_SY_APLICACAO_TESTE AS ap
            ON ap.id_aplicacao = i.id_aplicacao
        LEFT JOIN dbo.TB_SY_A_TESTE_PERGUNTA_TESTE AS atp
            ON atp.id_teste = ap.id_teste
           AND atp.id_pergunta = i.id_pergunta
        WHERE atp.id_pergunta IS NULL
    )
    BEGIN
        THROW 50004, 'Resposta invalida: a pergunta informada nao pertence ao teste da aplicacao.', 1;
    END;
END;
GO
