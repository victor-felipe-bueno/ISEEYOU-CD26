/* Tabela: dbo.TB_SY_GATILHO | Parte 1 de 1 | Linhas: 20 | Faixa de id_gatilho: 1..20
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
SET IDENTITY_INSERT dbo.TB_SY_GATILHO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_GATILHO (id_gatilho, nm_gatilho, ds_gatilho) VALUES
(1, N'Prova ou avaliação', N'Provas, trabalhos avaliativos, seminários e notas.'),
(2, N'Prazo apertado', N'Entregas com pouco tempo, na escola, na faculdade ou no trabalho.'),
(3, N'Trabalho', N'Demandas, cobranças ou clima no ambiente de trabalho.'),
(4, N'Família', N'Conversas difíceis, cobranças ou preocupações com pessoas da família.'),
(5, N'Dinheiro', N'Contas, gastos inesperados ou incerteza financeira.'),
(6, N'Futuro e carreira', N'Escolha de curso, vestibular, emprego e planos para depois.'),
(7, N'Solidão', N'Sensação de estar sem companhia ou sem com quem dividir as coisas.'),
(8, N'Redes sociais', N'Comparações, excesso de tela ou algo que viu on-line.'),
(9, N'Sono ruim', N'Noite mal dormida, insônia ou despertares que deixaram o dia pesado.'),
(10, N'Saúde', N'Preocupações com o próprio corpo ou consultas e exames.'),
(11, N'Relacionamento', N'Desentendimentos ou incertezas com quem você namora ou se relaciona.'),
(12, N'Amizades', N'Afastamentos, conflitos ou mudanças em grupos de amigos.'),
(13, N'Deslocamento', N'Trânsito, ônibus lotado, atrasos e tempo perdido no caminho.'),
(14, N'Excesso de tarefas', N'Muitas coisas acumuladas ao mesmo tempo.'),
(15, N'Conflito na escola', N'Desentendimentos com colegas ou professores.'),
(16, N'Autocobrança', N'Exigência consigo mesmo acima do que dá para entregar.'),
(17, N'Mudança na rotina', N'Horários novos, mudança de casa, de turma ou de emprego.'),
(18, N'Notícias', N'Acontecimentos no mundo ou na cidade que deixaram apreensivo.'),
(19, N'Barulho e ambiente', N'Barulho, calor, frio ou um lugar desconfortável para ficar.'),
(20, N'Comparação com outros', N'Sensação de estar atrás das outras pessoas.');
GO
SET IDENTITY_INSERT dbo.TB_SY_GATILHO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'06_CARGA_TB_SY_GATILHO_20.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 06_CARGA_TB_SY_GATILHO_20.sql: 20 linhas em dbo.TB_SY_GATILHO.';
END;
GO
