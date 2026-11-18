/* Tabela: dbo.TB_SY_PREMIO | Parte 1 de 1 | Linhas: 25 | Faixa de id_premio: 1..25
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
SET IDENTITY_INSERT dbo.TB_SY_PREMIO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_PREMIO (id_premio, nm_premio, ds_premio, nr_custo_pontos, fl_ativo) VALUES
(1, N'Tema Verde Musgo', N'Tema de cores em tons de verde para o aplicativo.', 120, 1),
(2, N'Tema Pôr do Sol', N'Tema de cores em laranja e lilás.', 120, 1),
(3, N'Tema Noite Azul', N'Tema escuro com detalhes em azul profundo.', 150, 1),
(4, N'Tema Areia', N'Tema claro em tons de bege e areia.', 120, 1),
(5, N'Tema Floresta', N'Tema com ilustrações de folhas e musgo.', 220, 1),
(6, N'Ícone Lua Crescente', N'Ícone alternativo do aplicativo com uma lua crescente.', 90, 1),
(7, N'Ícone Folha', N'Ícone alternativo do aplicativo com uma folha.', 90, 1),
(8, N'Ícone Farol', N'Ícone alternativo inspirado no último mundo.', 300, 1),
(9, N'Moldura de Avatar Flores', N'Moldura com flores para a foto de perfil.', 100, 1),
(10, N'Moldura de Avatar Ondas', N'Moldura com ondas para a foto de perfil.', 100, 1),
(11, N'Moldura de Avatar Estrelas', N'Moldura com estrelas para a foto de perfil.', 180, 1),
(12, N'Pacote de Adesivos Bichinhos', N'Adesivos de animais para enfeitar memórias.', 140, 1),
(13, N'Pacote de Adesivos Clima', N'Adesivos de sol, chuva e nuvens para o diário.', 140, 1),
(14, N'Pacote de Adesivos Comidas', N'Adesivos de comidas para enfeitar memórias.', 140, 1),
(15, N'Som de Notificação Sino', N'Som suave de sino para os lembretes.', 80, 1),
(16, N'Som de Notificação Gota', N'Som de gota d''água para os lembretes.', 80, 1),
(17, N'Som de Notificação Pássaro', N'Canto curto de pássaro para os lembretes.', 110, 1),
(18, N'Fundo do Diário Papel Kraft', N'Fundo com textura de papel para o diário.', 160, 1),
(19, N'Fundo do Diário Aquarela', N'Fundo em aquarela para o diário.', 160, 1),
(20, N'Fundo do Diário Céu Noturno', N'Fundo com céu estrelado para o diário.', 200, 1),
(21, N'Widget Frase do Dia', N'Widget de tela inicial com uma frase gentil por dia.', 250, 1),
(22, N'Widget Sequência', N'Widget de tela inicial que mostra sua sequência atual.', 250, 1),
(23, N'Capa Especial de Relatório', N'Capa ilustrada para o relatório mensal exportado.', 350, 1),
(24, N'Áudio Bônus Chuva na Serra', N'Libera um áudio extra de chuva gravado em área de serra.', 400, 1),
(25, N'Selo Jornada Completa', N'Selo especial para o perfil de quem chegou ao último mundo.', 900, 1);
GO
SET IDENTITY_INSERT dbo.TB_SY_PREMIO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'12_CARGA_TB_SY_PREMIO_25.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 12_CARGA_TB_SY_PREMIO_25.sql: 25 linhas em dbo.TB_SY_PREMIO.';
END;
GO
