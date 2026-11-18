/* Tabela: dbo.TB_SY_CATEGORIA_MISSAO | Parte 1 de 1 | Linhas: 8 | Faixa de id_categoria: 1..8
   Gerado por gerador/gerar.py (seed 20261118). Arquivo atômico: se falhar, nada dele fica gravado; corrija e rode só ele. */
USE [DB_I_SEE_YOU];
GO
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
SET XACT_ABORT ON;
SET NOCOUNT ON;
BEGIN TRANSACTION;
SET IDENTITY_INSERT dbo.TB_SY_CATEGORIA_MISSAO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_CATEGORIA_MISSAO (id_categoria, nm_categoria, ds_categoria) VALUES
(1, N'Autoconhecimento', N'Missões para observar sentimentos, padrões e o que faz bem para você.'),
(2, N'Sono', N'Missões ligadas à rotina de descanso e ao registro das noites.'),
(3, N'Movimento', N'Missões com pequenas atividades para o corpo, no seu ritmo.'),
(4, N'Pausas e respiro', N'Missões para parar alguns minutos no meio do dia.'),
(5, N'Conexões', N'Missões para fortalecer contato com pessoas de confiança.'),
(6, N'Organização', N'Missões para planejar a semana e diminuir o acúmulo de tarefas.'),
(7, N'Gratidão', N'Missões para perceber e registrar coisas boas do dia.'),
(8, N'Registro diário', N'Missões para criar o hábito de usar o diário de humor, sono e estresse.');
GO
SET IDENTITY_INSERT dbo.TB_SY_CATEGORIA_MISSAO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'04_CARGA_TB_SY_CATEGORIA_MISSAO_8.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 04_CARGA_TB_SY_CATEGORIA_MISSAO_8.sql: 8 linhas em dbo.TB_SY_CATEGORIA_MISSAO.';
END;
GO
