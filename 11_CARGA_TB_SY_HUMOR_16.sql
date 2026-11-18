/* Tabela: dbo.TB_SY_HUMOR | Parte 1 de 1 | Linhas: 16 | Faixa de id_humor: 1..16
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
SET IDENTITY_INSERT dbo.TB_SY_HUMOR ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_HUMOR (id_humor, nm_humor, ds_humor) VALUES
(1, N'Feliz', N'Dia leve, com vontade de sorrir e de estar com gente.'),
(2, N'Grato', N'Reconhecendo coisas boas que aconteceram, mesmo pequenas.'),
(3, N'Tranquilo', N'Calma por dentro, sem pressa e sem peso.'),
(4, N'Animado', N'Energia alta e vontade de fazer acontecer.'),
(5, N'Confiante', N'Sentindo que dá conta do que vem pela frente.'),
(6, N'Esperançoso', N'Ainda não está tudo bem, mas parece que vai melhorar.'),
(7, N'Orgulhoso', N'Satisfeito com algo que conseguiu fazer.'),
(8, N'Neutro', N'Nem bem nem mal, um dia comum.'),
(9, N'Cansado', N'Corpo ou cabeça pedindo descanso.'),
(10, N'Entediado', N'Sem estímulo, o tempo parece arrastado.'),
(11, N'Ansioso', N'Cabeça acelerada, preocupação com o que pode acontecer.'),
(12, N'Irritado', N'Paciência curta, tudo incomoda um pouco mais.'),
(13, N'Triste', N'Um aperto no peito, vontade de ficar quieto.'),
(14, N'Sobrecarregado', N'Coisa demais ao mesmo tempo, difícil saber por onde começar.'),
(15, N'Sozinho', N'Sentindo falta de companhia ou de alguém para conversar.'),
(16, N'Frustrado', N'Algo não saiu como esperado e isso pesou.');
GO
SET IDENTITY_INSERT dbo.TB_SY_HUMOR OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'11_CARGA_TB_SY_HUMOR_16.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 11_CARGA_TB_SY_HUMOR_16.sql: 16 linhas em dbo.TB_SY_HUMOR.';
END;
GO
