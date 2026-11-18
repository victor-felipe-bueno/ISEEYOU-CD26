/* Tabela: dbo.TB_SY_CATEGORIA_PUBLICACAO | Parte 1 de 1 | Linhas: 10 | Faixa de id_categoria: 1..10
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
SET IDENTITY_INSERT dbo.TB_SY_CATEGORIA_PUBLICACAO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_CATEGORIA_PUBLICACAO (id_categoria, nm_categoria, ds_categoria) VALUES
(1, N'Estudos e provas', N'Rotina de estudo, provas, vestibular e a pressão que vem junto.'),
(2, N'Trabalho e rotina', N'Conciliar trabalho, estudo e o resto da vida.'),
(3, N'Família', N'Convivência, conversas e vínculos em casa.'),
(4, N'Amizades', N'Amigos que chegam, que se afastam e que fazem diferença.'),
(5, N'Sono e cansaço', N'Noites difíceis, cansaço acumulado e tentativas de descansar melhor.'),
(6, N'Ansiedade do dia a dia', N'Preocupações, cabeça acelerada e jeitos de lidar com isso.'),
(7, N'Pequenas vitórias', N'Conquistas do dia que merecem ser lembradas.'),
(8, N'Autocuidado', N'Pausas, hábitos e cuidados que ajudam a seguir.'),
(9, N'Futuro e escolhas', N'Curso, carreira, mudanças e decisões importantes.'),
(10, N'Desabafo livre', N'Espaço para o que não cabe nas outras categorias.');
GO
SET IDENTITY_INSERT dbo.TB_SY_CATEGORIA_PUBLICACAO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'09_CARGA_TB_SY_CATEGORIA_PUBLICACAO_10.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 09_CARGA_TB_SY_CATEGORIA_PUBLICACAO_10.sql: 10 linhas em dbo.TB_SY_CATEGORIA_PUBLICACAO.';
END;
GO
