/* Tabela: dbo.TB_SY_MISSAO | Parte 1 de 1 | Linhas: 40 | Faixa de id_missao: 1..40
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
SET IDENTITY_INSERT dbo.TB_SY_MISSAO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_MISSAO (id_missao, nm_missao, ds_missao, vl_ponto) VALUES
(1, N'Primeiro registro de humor', N'Registre como você está se sentindo agora.', 10),
(2, N'Primeira noite registrada', N'Anote o horário em que dormiu e acordou na última noite.', 10),
(3, N'Conheça seus gatilhos', N'Faça um registro de estresse e marque o que pesou no dia.', 15),
(4, N'Três dias de diário', N'Registre o humor em três dias diferentes.', 20),
(5, N'Semana completa de sono', N'Registre o sono em sete noites, seguidas ou não.', 40),
(6, N'Hora de desligar', N'Escolha um horário para largar o celular antes de dormir e cumpra.', 25),
(7, N'Manhã sem pressa', N'Acorde dez minutos antes e use esse tempo só para você.', 20),
(8, N'Cochilo consciente', N'Se precisar cochilar, registre e mantenha abaixo de 30 minutos.', 15),
(9, N'Respiração de dois minutos', N'Ouça um áudio curto de respiração do catálogo.', 10),
(10, N'Pausa entre aulas', N'Faça uma pausa de cinco minutos longe da tela entre duas tarefas.', 15),
(11, N'Som de chuva', N'Escute um áudio da categoria natureza até o fim.', 15),
(12, N'Foco de 25 minutos', N'Use um áudio de foco durante um bloco de estudo ou trabalho.', 20),
(13, N'Caminhada curta', N'Dê uma volta de pelo menos dez minutos, no seu ritmo.', 20),
(14, N'Alongar o corpo', N'Faça cinco minutos de alongamento depois de muito tempo sentado.', 15),
(15, N'Subir de escada', N'Troque o elevador pela escada em um trajeto do dia.', 10),
(16, N'Dançar uma música', N'Coloque uma música que você gosta e se mexa até ela acabar.', 15),
(17, N'Mensagem para alguém', N'Mande uma mensagem para alguém de quem você sente falta.', 20),
(18, N'Convide um guardião', N'Convide uma pessoa de confiança para acompanhar seu progresso.', 30),
(19, N'Conversa sem celular', N'Tenha uma conversa de dez minutos sem olhar o celular.', 20),
(20, N'Agradeça a alguém', N'Diga obrigado a alguém por algo específico que essa pessoa fez.', 15),
(21, N'Três coisas boas', N'Anote três coisas boas que aconteceram hoje, por menores que sejam.', 15),
(22, N'Guarde uma memória', N'Registre uma memória afetiva que você não quer esquecer.', 25),
(23, N'Foto de um momento bom', N'Anexe uma foto a uma memória afetiva.', 20),
(24, N'Elogio para si', N'Escreva uma coisa que você fez bem esta semana.', 15),
(25, N'Planeje a semana', N'Cadastre na agenda pelo menos três compromissos da semana.', 25),
(26, N'Uma tarefa de cada vez', N'Conclua um evento da agenda antes de começar outro.', 15),
(27, N'Agenda em dia', N'Marque como concluídos os eventos que já aconteceram.', 20),
(28, N'Divida o que é grande', N'Quebre uma tarefa grande em três eventos menores.', 25),
(29, N'Olhe seu relatório', N'Abra o relatório semanal e veja como foi sua semana.', 15),
(30, N'Sono e humor lado a lado', N'Compare no gráfico as noites curtas com o humor do dia seguinte.', 30),
(31, N'O que pesou este mês', N'Veja quais gatilhos apareceram mais no último mês.', 30),
(32, N'Nomeie o sentimento', N'Escolha um humor diferente de Neutro em três registros.', 20),
(33, N'Intensidade sincera', N'Registre o humor usando a intensidade que realmente sente.', 10),
(34, N'Compartilhe uma vitória', N'Publique um relato na categoria Pequenas vitórias.', 25),
(35, N'Apoie um relato', N'Reaja com apoio a um relato da comunidade.', 10),
(36, N'Água ao lado', N'Deixe um copo de água por perto durante o estudo ou o trabalho.', 10),
(37, N'Domingo de preparo', N'No domingo, organize roupa, material e agenda da segunda.', 25),
(38, N'Luz do dia', N'Passe alguns minutos ao ar livre pela manhã.', 15),
(39, N'Desabafe por escrito', N'Escreva sobre o que está sentindo, mesmo que não publique.', 20),
(40, N'Mês de constância', N'Use o diário em vinte dias diferentes dentro de um mês.', 60);
GO
SET IDENTITY_INSERT dbo.TB_SY_MISSAO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'03_CARGA_TB_SY_MISSAO_40.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 03_CARGA_TB_SY_MISSAO_40.sql: 40 linhas em dbo.TB_SY_MISSAO.';
END;
GO
