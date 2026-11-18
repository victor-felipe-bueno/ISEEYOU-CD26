/* Tabela: dbo.TB_SY_PLANO | Parte 1 de 1 | Linhas: 4 | Faixa de id_plano: 1..4
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
SET IDENTITY_INSERT dbo.TB_SY_PLANO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_PLANO (id_plano, nm_plano, tp_periodicidade, ds_plano, fl_ativo) VALUES
(1, N'Essencial Mensal', N'M', N'Relatórios semanais, histórico completo de sono e humor e todos os áudios do catálogo. Cobrança mensal pela loja de aplicativos.', 1),
(2, N'Essencial Anual', N'A', N'Os mesmos recursos do Essencial, com cobrança anual pela loja de aplicativos e valor menor por mês.', 1),
(3, N'Plus Mensal', N'M', N'Tudo do Essencial, mais exportação dos seus registros, temas extras e convites ilimitados para guardiões. Cobrança mensal.', 1),
(4, N'Plus Anual', N'A', N'Tudo do Plus, com cobrança anual pela loja de aplicativos.', 1);
GO
SET IDENTITY_INSERT dbo.TB_SY_PLANO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'01_CARGA_TB_SY_PLANO_4.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 01_CARGA_TB_SY_PLANO_4.sql: 4 linhas em dbo.TB_SY_PLANO.';
END;
GO
