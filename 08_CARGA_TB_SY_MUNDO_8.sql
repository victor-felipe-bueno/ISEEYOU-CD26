/* Tabela: dbo.TB_SY_MUNDO | Parte 1 de 1 | Linhas: 8 | Faixa de id_mundo: 1..8
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
SET IDENTITY_INSERT dbo.TB_SY_MUNDO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_MUNDO (id_mundo, nm_mundo, ds_mundo, nr_pontos_necessarios, nr_ordem, fl_ativo) VALUES
(1, N'Jardim do Começo', N'Um jardim calmo onde a jornada começa. Liberado no cadastro.', 0, 1, 1),
(2, N'Vale da Neblina', N'Um vale de manhãs frias, onde aprender a ir devagar faz parte do caminho.', 150, 2, 1),
(3, N'Bosque das Lanternas', N'Trilhas iluminadas por pequenas luzes, uma para cada dia registrado.', 400, 3, 1),
(4, N'Lago Espelhado', N'Águas paradas que refletem o céu e convidam a olhar para dentro.', 800, 4, 1),
(5, N'Serra dos Ventos', N'Uma subida com vista ampla, para quem já pegou ritmo.', 1400, 5, 1),
(6, N'Ilha das Marés', N'Um lugar que muda com a maré e lembra que os dias também mudam.', 2200, 6, 1),
(7, N'Campo das Estrelas', N'Uma noite aberta e silenciosa para descansar depois de tanto caminho.', 3200, 7, 1),
(8, N'Farol do Horizonte', N'O ponto mais alto da jornada, de onde dá para ver tudo o que já foi feito.', 4500, 8, 1);
GO
SET IDENTITY_INSERT dbo.TB_SY_MUNDO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'08_CARGA_TB_SY_MUNDO_8.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 08_CARGA_TB_SY_MUNDO_8.sql: 8 linhas em dbo.TB_SY_MUNDO.';
END;
GO
