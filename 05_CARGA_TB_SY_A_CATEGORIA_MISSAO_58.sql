/* Tabela: dbo.TB_SY_A_CATEGORIA_MISSAO | Parte 1 de 1 | Linhas: 58 | Faixa de id_categoria: 1..8
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
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_A_CATEGORIA_MISSAO (id_categoria, id_missao) VALUES
(1, 3),
(1, 22),
(1, 24),
(1, 28),
(1, 29),
(1, 30),
(1, 31),
(1, 32),
(1, 33),
(1, 39),
(2, 2),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 30),
(2, 37),
(2, 38),
(3, 13),
(3, 14),
(3, 15),
(3, 16),
(3, 38),
(4, 7),
(4, 9),
(4, 10),
(4, 11),
(4, 12),
(4, 14),
(4, 36),
(4, 39),
(5, 17),
(5, 18),
(5, 19),
(5, 20),
(5, 34),
(5, 35),
(6, 12),
(6, 25),
(6, 26),
(6, 27),
(6, 28),
(6, 37),
(7, 16),
(7, 20),
(7, 21),
(7, 22),
(7, 23),
(7, 24),
(7, 34),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 32),
(8, 33),
(8, 40);
GO
IF @@TRANCOUNT = 0
    RAISERROR(N'05_CARGA_TB_SY_A_CATEGORIA_MISSAO_58.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 05_CARGA_TB_SY_A_CATEGORIA_MISSAO_58.sql: 58 linhas em dbo.TB_SY_A_CATEGORIA_MISSAO.';
END;
GO
