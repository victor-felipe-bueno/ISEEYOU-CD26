/* Tabela: dbo.TB_SY_CONQUISTA | Parte 1 de 1 | Linhas: 30 | Faixa de id_conquista: 1..30
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
SET IDENTITY_INSERT dbo.TB_SY_CONQUISTA ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_CONQUISTA (id_conquista, nm_conquista, ds_conquista, nr_pontos_recompensa, fl_ativo) VALUES
(1, N'Primeiro passo', N'Fez o primeiro registro no diário.', 20, 1),
(2, N'Três dias seguidos', N'Usou o diário por três dias seguidos.', 30, 1),
(3, N'Uma semana inteira', N'Usou o diário por sete dias seguidos.', 60, 1),
(4, N'Duas semanas firmes', N'Usou o diário por catorze dias seguidos.', 100, 1),
(5, N'Um mês de constância', N'Usou o diário por trinta dias seguidos.', 200, 1),
(6, N'Sessenta dias', N'Usou o diário por sessenta dias seguidos.', 350, 1),
(7, N'Cem dias', N'Usou o diário por cem dias seguidos.', 500, 1),
(8, N'Retomada', N'Voltou a registrar depois de mais de duas semanas sem usar o app.', 40, 1),
(9, N'Dez registros de humor', N'Fez dez registros de humor.', 30, 1),
(10, N'Cinquenta registros de humor', N'Fez cinquenta registros de humor.', 80, 1),
(11, N'Duzentos registros de humor', N'Fez duzentos registros de humor.', 200, 1),
(12, N'Guardião do sono', N'Registrou vinte noites de sono.', 60, 1),
(13, N'Cem noites', N'Registrou cem noites de sono.', 180, 1),
(14, N'Noite bem dormida', N'Registrou uma noite com qualidade cinco.', 20, 1),
(15, N'Olho no estresse', N'Fez dez registros de estresse.', 40, 1),
(16, N'Mapa dos gatilhos', N'Marcou cinco gatilhos diferentes nos registros de estresse.', 50, 1),
(17, N'Primeira memória', N'Guardou a primeira memória afetiva.', 25, 1),
(18, N'Álbum de memórias', N'Guardou dez memórias afetivas.', 90, 1),
(19, N'Agenda organizada', N'Concluiu dez eventos da agenda.', 50, 1),
(20, N'Missão cumprida', N'Concluiu a primeira missão.', 20, 1),
(21, N'Dez missões', N'Concluiu dez missões.', 100, 1),
(22, N'Vinte e cinco missões', N'Concluiu vinte e cinco missões.', 250, 1),
(23, N'Explorador de mundos', N'Desbloqueou o terceiro mundo.', 80, 1),
(24, N'Viajante', N'Desbloqueou o quinto mundo.', 150, 1),
(25, N'Primeiro relato', N'Publicou o primeiro relato na comunidade.', 25, 1),
(26, N'Rede de apoio', N'Recebeu vinte reações de apoio nos seus relatos.', 70, 1),
(27, N'Mão estendida', N'Reagiu com apoio a dez relatos de outras pessoas.', 40, 1),
(28, N'Pessoa de confiança', N'Teve o primeiro convite de guardião aceito.', 40, 1),
(29, N'Primeira recompensa', N'Resgatou o primeiro prêmio.', 20, 1),
(30, N'Um ano de cuidado', N'Completou um ano desde o cadastro com uso no último mês.', 300, 1);
GO
SET IDENTITY_INSERT dbo.TB_SY_CONQUISTA OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'07_CARGA_TB_SY_CONQUISTA_30.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 07_CARGA_TB_SY_CONQUISTA_30.sql: 30 linhas em dbo.TB_SY_CONQUISTA.';
END;
GO
