/* Tabela: dbo.TB_SY_AUDIO_RELAXAMENTO | Parte 1 de 1 | Linhas: 120 | Faixa de id_audio: 1..120
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
SET IDENTITY_INSERT dbo.TB_SY_AUDIO_RELAXAMENTO ON;
GO
IF @@TRANCOUNT = 0 RETURN;  -- transação revertida por erro anterior: não insere nada
INSERT INTO dbo.TB_SY_AUDIO_RELAXAMENTO (id_audio, nm_audio, ds_audio, tp_audio, ds_objetivo, nr_frequencia_hz, nr_frequencia_secundaria_hz, nr_duracao_segundos, fl_ativo, dt_registro, id_link) VALUES
(1, N'Meio da Tarde', N'Batimento binaural de 10 Hz (faixa alfa), tom médio, sem variações bruscas. Use fones de ouvido.', N'BINAURAL', N'Pausa curta no meio do dia', 250.00, 260.00, 600, 1, '2024-11-16T16:44:52.705', 1),
(2, N'Lista de Exercícios', N'Batimento binaural de 16 Hz (faixa beta), sem música, só o tom. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 320.00, 336.00, 3023, 1, '2024-11-16T18:46:37.027', 2),
(3, N'Cachoeira Pequena', N'Gravação de natureza: queda d''água em trilha de mata.', N'NATUREZA', N'Concentração em estudo ou trabalho', 900.00, NULL, 2700, 1, '2024-11-16T19:58:12.724', 3),
(4, N'Cello Profundo', N'Música instrumental: violoncelo solo grave.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1544, 1, '2024-11-16T14:26:17.733', 4),
(5, N'Motor de Barco', N'Ruído contínuo, barco pequeno em água calma.', N'RUIDO', N'Criar um ambiente sonoro tranquilo', 130.00, NULL, 2131, 1, '2024-11-16T20:40:26.834', 5),
(6, N'Ruído Marrom Profundo', N'Ruído contínuo, grave e encorpado, lembra um rio distante.', N'RUIDO', N'Desacelerar antes de dormir', 250.00, NULL, 3644, 1, '2024-11-16T14:57:56.370', 6),
(7, N'Jazz de Madrugada', N'Música instrumental: trio de jazz em volume baixo.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 2431, 1, '2024-11-16T14:57:26.276', 7),
(8, N'Gotas na Caverna', N'Gravação de natureza: gotejar espaçado com eco.', N'NATUREZA', N'Acompanhar a respiração por alguns minutos', 1300.00, NULL, 751, 1, '2024-11-16T18:50:19.771', 8),
(9, N'Chuva no Telhado de Zinco', N'Gravação de natureza: pingos fortes e ritmados.', N'NATUREZA', N'Desacelerar antes de dormir', 1800.00, NULL, 3600, 1, '2024-11-16T12:06:49.483', 9),
(10, N'Trilha de Leitura', N'Música instrumental: piano e cordas sem mudanças bruscas.', N'MUSICA', N'Concentração em estudo ou trabalho', 440.00, NULL, 3031, 1, '2024-11-16T14:57:28.217', 10),
(11, N'Despertar Sem Susto', N'Batimento binaural de 9.5 Hz (faixa alfa), começa quase inaudível. Use fones de ouvido.', N'BINAURAL', N'Começar a manhã sem pressa', 240.00, 249.50, 923, 1, '2024-11-16T15:07:47.405', 11),
(12, N'Vento no Campo', N'Gravação de natureza: brisa em campo aberto.', N'NATUREZA', N'Acompanhar a respiração por alguns minutos', 200.00, NULL, 612, 1, '2024-11-16T20:15:43.662', 12),
(13, N'Tic-Tac de Estudo', N'Tons isocrônicos a 15 pulsos por segundo (faixa beta), pulsos firmes para blocos de estudo.', N'ISOCRONICO', N'Concentração em estudo ou trabalho', 15.00, NULL, 1544, 1, '2024-11-16T15:10:18.180', 13),
(14, N'Manhã de Segunda', N'Tons isocrônicos a 12 pulsos por segundo (faixa alfa), pulsos que aceleram aos poucos.', N'ISOCRONICO', N'Começar a manhã sem pressa', 12.00, NULL, 607, 1, '2024-11-16T17:39:47.792', 14),
(15, N'Neve Caindo na Serra', N'Gravação de natureza: silêncio com vento leve.', N'NATUREZA', N'Desacelerar antes de dormir', 150.00, NULL, 3031, 1, '2024-11-16T17:10:47.388', 15),
(16, N'Lo-fi de Chuva', N'Música instrumental: lo-fi com chuva ao fundo.', N'MUSICA', N'Concentração em estudo ou trabalho', 440.00, NULL, 3012, 1, '2024-11-16T13:52:47.549', 16),
(17, N'Rio de Montanha', N'Gravação de natureza: água fria e rápida.', N'NATUREZA', N'Concentração em estudo ou trabalho', 1000.00, NULL, 3031, 1, '2024-11-16T15:04:39.471', 17),
(18, N'Café Esfriando', N'Batimento binaural de 12 Hz (faixa alfa), chiado leve de vinil. Use fones de ouvido.', N'BINAURAL', N'Pausa curta no meio do dia', 256.00, 268.00, 931, 1, '2024-11-16T13:00:01.705', 18),
(19, N'Ressaca no Costão', N'Gravação de natureza: ondas fortes batendo nas rochas.', N'NATUREZA', N'Abafar barulhos ao redor', 250.00, NULL, 2400, 0, '2024-11-16T12:05:57.552', 19),
(20, N'Chuva na Floresta', N'Gravação de natureza: chuva sobre copas de árvores.', N'NATUREZA', N'Concentração em estudo ou trabalho', 1600.00, NULL, 3600, 1, '2024-11-16T18:39:04.903', 20),
(21, N'Sala de Servidores', N'Ruído contínuo, zumbido de equipamentos em sala fechada.', N'RUIDO', N'Concentração em estudo ou trabalho', 300.00, NULL, 2723, 1, '2024-11-16T18:47:18.933', 21),
(22, N'Cinco Minutos', N'Tons isocrônicos a 9 pulsos por segundo (faixa alfa), versão curta para usar entre aulas.', N'ISOCRONICO', N'Pausa curta no meio do dia', 9.00, NULL, 307, 1, '2024-11-16T14:58:35.223', 22),
(23, N'Baleias ao Longe', N'Gravação de natureza: canto grave em mar aberto.', N'NATUREZA', N'Desacelerar antes de dormir', 110.00, NULL, 2700, 1, '2024-11-16T17:28:43.920', 23),
(24, N'Linha Reta', N'Batimento binaural de 13.5 Hz (faixa beta), portadora grave para quem não gosta de tons agudos. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 210.00, 223.50, 2412, 1, '2024-11-16T17:45:05.134', 24),
(25, N'Maré Baixa', N'Gravação de natureza: água indo e vindo devagar.', N'NATUREZA', N'Acompanhar a respiração por alguns minutos', 280.00, NULL, 944, 1, '2024-11-16T12:54:53.245', 25),
(26, N'Avião em Cruzeiro', N'Ruído contínuo, cabine de avião em voo estável.', N'RUIDO', N'Abafar barulhos ao redor', 200.00, NULL, 3600, 1, '2024-11-16T19:33:10.401', 26),
(27, N'Cobertor de Lã', N'Batimento binaural de 2 Hz (faixa delta), zumbido grave e constante. Use fones de ouvido.', N'BINAURAL', N'Desacelerar antes de dormir', 160.00, 162.00, 2400, 1, '2024-11-16T19:57:55.422', 27),
(28, N'Ruído Rosa Suave', N'Ruído contínuo, mais grave que o branco, menos cansativo.', N'RUIDO', N'Desacelerar antes de dormir', 500.00, NULL, 3607, 1, '2024-11-16T13:28:07.008', 28),
(29, N'Janela Aberta', N'Batimento binaural de 9 Hz (faixa alfa), pássaros ao longe. Use fones de ouvido.', N'BINAURAL', N'Pausa curta no meio do dia', 260.00, 269.00, 720, 1, '2024-11-16T12:15:32.865', 29),
(30, N'Pássaros no Quintal', N'Gravação de natureza: sabiás e bem-te-vis pela manhã.', N'NATUREZA', N'Começar a manhã sem pressa', 3500.00, NULL, 1231, 1, '2024-11-16T17:42:57.915', 30),
(31, N'Riacho Entre Pedras', N'Gravação de natureza: água rasa correndo sobre pedras.', N'NATUREZA', N'Pausa curta no meio do dia', 1200.00, NULL, 1200, 1, '2024-11-16T16:35:15.835', 31),
(32, N'Máquina de Lavar', N'Ruído contínuo, ciclo de lavagem sem centrifugação.', N'RUIDO', N'Criar um ambiente sonoro tranquilo', 190.00, NULL, 2431, 1, '2024-11-16T16:32:45.917', 32),
(33, N'Canção sem Palavras', N'Música instrumental: vocalise suave sem letra.', N'MUSICA', N'Pausa curta no meio do dia', 440.00, NULL, 480, 1, '2024-11-16T18:17:57.671', 33),
(34, N'Batida da Madrugada', N'Tons isocrônicos a 3 pulsos por segundo (faixa delta), pulsos espaçados e suaves.', N'ISOCRONICO', N'Desacelerar antes de dormir', 3.00, NULL, 2700, 1, '2024-11-16T14:15:30.962', 34),
(35, N'Rosa com Chuva', N'Ruído contínuo, ruído rosa misturado a chuva leve.', N'RUIDO', N'Desacelerar antes de dormir', 450.00, NULL, 3623, 1, '2024-11-16T14:41:44.113', 35),
(36, N'Maré Noturna', N'Batimento binaural de 3 Hz (faixa delta), ondas distantes misturadas ao tom. Use fones de ouvido.', N'BINAURAL', N'Desacelerar antes de dormir', 200.00, 203.00, 3623, 1, '2024-11-16T13:09:13.490', 36),
(37, N'Prova Amanhã', N'Tons isocrônicos a 14 pulsos por segundo (faixa beta), pulsos estáveis, sem melodia.', N'ISOCRONICO', N'Concentração em estudo ou trabalho', 14.00, NULL, 3023, 1, '2024-11-16T19:28:49.876', 37),
(38, N'Chuva de Verão Rápida', N'Gravação de natureza: pancada forte que passa.', N'NATUREZA', N'Pausa curta no meio do dia', 1900.00, NULL, 600, 1, '2024-11-16T16:18:20.090', 38),
(39, N'Violino na Neblina', N'Música instrumental: violino com reverberação longa.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1080, 1, '2024-11-16T17:16:52.203', 39),
(40, N'Pulso Grave', N'Tons isocrônicos a 2 pulsos por segundo (faixa delta), pulsos sobre um tom de 110 Hz.', N'ISOCRONICO', N'Desacelerar antes de dormir', 2.00, NULL, 2407, 1, '2024-11-16T15:04:54.206', 40),
(41, N'Mesa Limpa', N'Batimento binaural de 14 Hz (faixa beta), tom estável para blocos de leitura. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 300.00, 314.00, 1544, 1, '2024-11-16T14:05:24.368', 41),
(42, N'Quatro Tempos', N'Tons isocrônicos a 4.5 pulsos por segundo (faixa teta), guia de respiração em quatro tempos.', N'ISOCRONICO', N'Acompanhar a respiração por alguns minutos', 4.50, NULL, 360, 1, '2024-11-16T16:53:28.543', 42),
(43, N'Últimas Luzes', N'Batimento binaural de 3.5 Hz (faixa delta), volume que diminui aos poucos nos dez minutos finais. Use fones de ouvido.', N'BINAURAL', N'Desacelerar antes de dormir', 210.00, 213.50, 1844, 1, '2024-11-16T17:29:51.722', 43),
(44, N'Grilos de Verão', N'Gravação de natureza: noite quente no interior.', N'NATUREZA', N'Desacelerar antes de dormir', 4500.00, NULL, 3000, 1, '2024-11-16T13:42:48.012', 44),
(45, N'Violão de Varanda', N'Música instrumental: violão dedilhado sem pressa.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1823, 1, '2024-11-16T20:48:38.586', 45),
(46, N'Marimba do Quintal', N'Música instrumental: marimba alegre e calma.', N'MUSICA', N'Começar a manhã sem pressa', 440.00, NULL, 727, 1, '2024-11-16T12:55:39.474', 46),
(47, N'Marrom para Estudar', N'Ruído contínuo, ruído marrom com volume constante.', N'RUIDO', N'Concentração em estudo ou trabalho', 260.00, NULL, 3023, 1, '2024-11-16T14:43:41.063', 47),
(48, N'Intervalo Curto', N'Tons isocrônicos a 10 pulsos por segundo (faixa alfa), pulsos claros por dez minutos.', N'ISOCRONICO', N'Pausa curta no meio do dia', 10.00, NULL, 644, 1, '2024-11-16T17:23:23.178', 48),
(49, N'Lago com Patos', N'Gravação de natureza: água parada e patos ao longe.', N'NATUREZA', N'Pausa curta no meio do dia', 800.00, NULL, 944, 1, '2024-11-16T13:48:26.261', 49),
(50, N'Garoa na Janela', N'Gravação de natureza: chuva fina batendo no vidro.', N'NATUREZA', N'Desacelerar antes de dormir', 2200.00, NULL, 2707, 1, '2024-11-16T17:15:36.437', 50),
(51, N'Código Concentrado', N'Tons isocrônicos a 18 pulsos por segundo (faixa beta), pulsos sobre ruído marrom.', N'ISOCRONICO', N'Concentração em estudo ou trabalho', 18.00, NULL, 3600, 1, '2024-11-16T17:27:27.934', 51),
(52, N'Exaustor de Cozinha', N'Ruído contínuo, exaustor ligado em casa tranquila.', N'RUIDO', N'Abafar barulhos ao redor', 210.00, NULL, 2412, 1, '2024-11-16T14:33:17.527', 52),
(53, N'Trovoada Sem Chuva', N'Gravação de natureza: trovões espaçados e vento.', N'NATUREZA', N'Criar um ambiente sonoro tranquilo', 80.00, NULL, 2107, 1, '2024-11-16T18:58:51.029', 53),
(54, N'Temporal ao Longe', N'Gravação de natureza: trovões distantes e chuva constante.', N'NATUREZA', N'Desacelerar antes de dormir', 90.00, NULL, 3631, 1, '2024-11-16T17:07:52.712', 54),
(55, N'Harpa ao Entardecer', N'Música instrumental: harpa solo com eco.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1200, 1, '2024-11-16T15:09:33.706', 55),
(56, N'Pinheiral com Vento', N'Gravação de natureza: vento atravessando pinheiros.', N'NATUREZA', N'Fechar o dia com mais calma', 450.00, NULL, 1812, 1, '2024-11-16T14:39:08.442', 56),
(57, N'Tigelas de Cristal', N'Música instrumental: tigelas tocadas devagar.', N'MUSICA', N'Acompanhar a respiração por alguns minutos', 432.00, NULL, 912, 1, '2024-11-16T12:27:47.844', 57),
(58, N'Ritmo de Trem', N'Música instrumental: percussão leve que lembra trilhos.', N'MUSICA', N'Concentração em estudo ou trabalho', 440.00, NULL, 2423, 1, '2024-11-16T17:13:03.023', 58),
(59, N'Piano e Chuva', N'Música instrumental: piano com chuva fina.', N'MUSICA', N'Desacelerar antes de dormir', 440.00, NULL, 2731, 0, '2024-11-16T16:32:11.942', 59),
(60, N'Ar-Condicionado Antigo', N'Ruído contínuo, zumbido constante de aparelho de janela.', N'RUIDO', N'Abafar barulhos ao redor', 220.00, NULL, 3644, 1, '2024-11-16T19:49:33.945', 60),
(61, N'Sintetizador Lento', N'Música instrumental: pads longos e graves.', N'MUSICA', N'Desacelerar antes de dormir', 432.00, NULL, 3007, 1, '2024-11-16T13:06:19.003', 61),
(62, N'Biblioteca Vazia', N'Batimento binaural de 15 Hz (faixa beta), ruído marrom bem baixo. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 280.00, 295.00, 2700, 1, '2024-11-16T15:07:32.421', 62),
(63, N'Órgão Distante', N'Música instrumental: órgão suave em sala grande.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1231, 1, '2024-11-16T16:18:25.916', 63),
(64, N'Ruído Cinza', N'Ruído contínuo, equalizado para soar igual em todas as faixas.', N'RUIDO', N'Concentração em estudo ou trabalho', 800.00, NULL, 3012, 1, '2024-11-16T16:11:01.055', 64),
(65, N'Folhas Secas no Outono', N'Gravação de natureza: passos lentos e folhas.', N'NATUREZA', N'Pausa curta no meio do dia', 2500.00, NULL, 907, 1, '2024-11-16T15:05:37.651', 65),
(66, N'Fogueira de Acampamento', N'Gravação de natureza: fogo ao ar livre e grilos.', N'NATUREZA', N'Fechar o dia com mais calma', 400.00, NULL, 2423, 1, '2024-11-16T20:59:00.166', 66),
(67, N'Sinos de Vento', N'Música instrumental: sinos tocados pela brisa.', N'MUSICA', N'Pausa curta no meio do dia', 440.00, NULL, 600, 1, '2024-11-16T19:30:20.832', 67),
(68, N'Respira Comigo', N'Tons isocrônicos a 4 pulsos por segundo (faixa teta), pulsos que acompanham inspirar e expirar.', N'ISOCRONICO', N'Acompanhar a respiração por alguns minutos', 4.00, NULL, 480, 1, '2024-11-16T16:12:11.511', 68),
(69, N'Rede na Sombra', N'Batimento binaural de 4.5 Hz (faixa teta), vento leve gravado em área rural. Use fones de ouvido.', N'BINAURAL', N'Fechar o dia com mais calma', 174.00, 178.50, 2112, 1, '2024-11-16T20:18:47.530', 69),
(70, N'Caderno Fechado', N'Batimento binaural de 7 Hz (faixa teta), tom limpo para o fim do expediente. Use fones de ouvido.', N'BINAURAL', N'Fechar o dia com mais calma', 240.00, 247.00, 1200, 1, '2024-11-16T12:42:38.972', 70),
(71, N'Piano para Dormir', N'Música instrumental: piano solo lento e espaçado.', N'MUSICA', N'Desacelerar antes de dormir', 440.00, NULL, 2700, 1, '2024-11-16T15:27:30.834', 71),
(72, N'Kalimba Leve', N'Música instrumental: kalimba com notas espaçadas.', N'MUSICA', N'Pausa curta no meio do dia', 440.00, NULL, 600, 1, '2024-11-16T18:44:38.477', 72),
(73, N'Geladeira na Madrugada', N'Ruído contínuo, motor de geladeira em cozinha silenciosa.', N'RUIDO', N'Desacelerar antes de dormir', 120.00, NULL, 2723, 1, '2024-11-16T15:43:52.436', 73),
(74, N'Planilha em Ordem', N'Batimento binaural de 20 Hz (faixa beta), tom levemente mais agudo. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 340.00, 360.00, 1800, 1, '2024-11-16T20:25:52.423', 74),
(75, N'Pausa no Trabalho', N'Tons isocrônicos a 11 pulsos por segundo (faixa alfa), pulsos sobre um pad leve.', N'ISOCRONICO', N'Pausa curta no meio do dia', 11.00, NULL, 720, 1, '2024-11-16T20:03:36.318', 75),
(76, N'Sapos na Lagoa', N'Gravação de natureza: coro de sapos depois da chuva.', N'NATUREZA', N'Fechar o dia com mais calma', 1500.00, NULL, 2444, 1, '2024-11-16T12:41:06.304', 76),
(77, N'Corredor Silencioso', N'Batimento binaural de 12.5 Hz (faixa alfa), tom contínuo para atravessar o dia. Use fones de ouvido.', N'BINAURAL', N'Abafar barulhos ao redor', 230.00, 242.50, 3631, 1, '2024-11-16T13:06:31.812', 77),
(78, N'Branco com Fade', N'Ruído contínuo, ruído branco que diminui até sumir.', N'RUIDO', N'Desacelerar antes de dormir', 950.00, NULL, 1844, 1, '2024-11-16T20:22:35.783', 78),
(79, N'Ambient de Nuvens', N'Música instrumental: camadas sintetizadas sem batida.', N'MUSICA', N'Desacelerar antes de dormir', 432.00, NULL, 3607, 1, '2024-11-16T14:42:50.749', 79),
(80, N'Praia à Noite', N'Gravação de natureza: ondas e vento noturno.', N'NATUREZA', N'Desacelerar antes de dormir', 320.00, NULL, 3600, 1, '2024-11-16T20:26:01.443', 80),
(81, N'Batida Constante', N'Música instrumental: batida eletrônica suave para foco.', N'MUSICA', N'Concentração em estudo ou trabalho', 440.00, NULL, 2700, 1, '2025-05-11T15:06:50.607', 81),
(82, N'Música para Respirar', N'Música instrumental: frases musicais no tempo da respiração.', N'MUSICA', N'Acompanhar a respiração por alguns minutos', 432.00, NULL, 487, 1, '2025-12-06T17:32:41.188', 82),
(83, N'Respiro de Dez', N'Batimento binaural de 8.5 Hz (faixa alfa), marcações suaves a cada minuto. Use fones de ouvido.', N'BINAURAL', N'Pausa curta no meio do dia', 270.00, 278.50, 600, 1, '2025-12-17T19:22:00.103', 83),
(84, N'Flauta da Montanha', N'Música instrumental: flauta de bambu com vento.', N'MUSICA', N'Pausa curta no meio do dia', 440.00, NULL, 764, 1, '2025-04-29T18:49:10.098', 84),
(85, N'Lareira Acesa', N'Gravação de natureza: estalos de lenha queimando.', N'NATUREZA', N'Fechar o dia com mais calma', 350.00, NULL, 2731, 1, '2025-05-17T13:26:06.463', 85),
(86, N'Bossa Tranquila', N'Música instrumental: violão e voz sem letra.', N'MUSICA', N'Pausa curta no meio do dia', 440.00, NULL, 1212, 1, '2025-09-04T19:27:06.661', 86),
(87, N'Revisão de Véspera', N'Batimento binaural de 18 Hz (faixa beta), blocos de 25 minutos com sinal suave no fim. Use fones de ouvido.', N'BINAURAL', N'Concentração em estudo ou trabalho', 310.00, 328.00, 3000, 1, '2024-12-29T18:26:45.470', 87),
(88, N'Ruído Azul', N'Ruído contínuo, mais agudo, para ambientes com barulho grave.', N'RUIDO', N'Abafar barulhos ao redor', 4000.00, NULL, 1807, 0, '2025-12-14T14:03:54.832', 88),
(89, N'Lo-fi de Estudo', N'Música instrumental: batida leve e acordes repetidos.', N'MUSICA', N'Concentração em estudo ou trabalho', 440.00, NULL, 3631, 1, '2026-09-30T12:08:22.843', 89),
(90, N'Mar Calmo', N'Gravação de natureza: ondas pequenas em praia vazia.', N'NATUREZA', N'Desacelerar antes de dormir', 300.00, NULL, 3623, 0, '2025-03-20T19:10:10.859', 90),
(91, N'Vento no Bambuzal', N'Gravação de natureza: bambus rangendo com o vento.', N'NATUREZA', N'Pausa curta no meio do dia', 700.00, NULL, 1244, 1, '2025-10-29T20:17:18.271', 91),
(92, N'Banco de Praça', N'Batimento binaural de 11 Hz (faixa alfa), ambiente urbano bem distante. Use fones de ouvido.', N'BINAURAL', N'Pausa curta no meio do dia', 244.00, 255.00, 900, 1, '2025-09-30T16:13:41.437', 92),
(93, N'Secador de Roupa', N'Ruído contínuo, giro grave e regular.', N'RUIDO', N'Desacelerar antes de dormir', 160.00, NULL, 2712, 1, '2026-01-05T17:45:54.645', 93),
(94, N'Ritmo de Escrita', N'Tons isocrônicos a 16 pulsos por segundo (faixa beta), pulsos com tom mais suave.', N'ISOCRONICO', N'Concentração em estudo ou trabalho', 16.00, NULL, 2400, 1, '2025-07-16T18:24:20.671', 94),
(95, N'Ambient Oceânico', N'Música instrumental: sintetizador com ondas.', N'MUSICA', N'Desacelerar antes de dormir', 432.00, NULL, 3644, 1, '2026-02-26T18:32:09.233', 95),
(96, N'Caixinha de Música', N'Música instrumental: melodia simples de caixinha.', N'MUSICA', N'Desacelerar antes de dormir', 440.00, NULL, 907, 1, '2025-02-22T20:01:23.722', 96),
(97, N'Trem Noturno', N'Ruído contínuo, trilhos ritmados e vagão fechado.', N'RUIDO', N'Desacelerar antes de dormir', 140.00, NULL, 3631, 1, '2026-02-15T19:27:35.720', 97),
(98, N'Varanda à Noite', N'Batimento binaural de 5 Hz (faixa teta), grilos discretos ao fundo. Use fones de ouvido.', N'BINAURAL', N'Fechar o dia com mais calma', 196.00, 201.00, 1812, 1, '2025-07-02T20:28:05.919', 98),
(99, N'Mata Atlântica de Manhã', N'Gravação de natureza: pássaros e folhas ao vento.', N'NATUREZA', N'Começar a manhã sem pressa', 3000.00, NULL, 1500, 1, '2026-07-06T20:51:50.814', 99),
(100, N'Ritmo de Ônibus', N'Tons isocrônicos a 7 pulsos por segundo (faixa teta), pulsos com textura de motor distante.', N'ISOCRONICO', N'Fechar o dia com mais calma', 7.00, NULL, 1812, 1, '2025-05-26T15:36:31.098', 100),
(101, N'Descida Lenta', N'Batimento binaural de 2.5 Hz (faixa delta), camada de ruído rosa bem baixa ao fundo. Use fones de ouvido.', N'BINAURAL', N'Desacelerar antes de dormir', 180.00, 182.50, 2707, 1, '2025-12-12T17:50:17.296', 101),
(102, N'Cigarras ao Meio-Dia', N'Gravação de natureza: calor de verão no interior.', N'NATUREZA', N'Criar um ambiente sonoro tranquilo', 5000.00, NULL, 1244, 0, '2025-09-13T19:18:09.997', 102),
(103, N'Fim de Expediente', N'Tons isocrônicos a 6 pulsos por segundo (faixa teta), pulsos médios com fade longo.', N'ISOCRONICO', N'Fechar o dia com mais calma', 6.00, NULL, 1223, 1, '2025-01-13T16:46:21.122', 103),
(104, N'Primeira Luz', N'Batimento binaural de 10.5 Hz (faixa alfa), tom que cresce devagar no início. Use fones de ouvido.', N'BINAURAL', N'Começar a manhã sem pressa', 260.00, 270.50, 764, 0, '2025-11-04T13:46:44.935', 104),
(105, N'Brejo ao Entardecer', N'Gravação de natureza: aves e insetos no fim da tarde.', N'NATUREZA', N'Fechar o dia com mais calma', 2600.00, NULL, 1800, 1, '2026-07-30T12:30:35.619', 105),
(106, N'Estática Suave', N'Ruído contínuo, chiado bem baixo, quase imperceptível.', N'RUIDO', N'Concentração em estudo ou trabalho', 700.00, NULL, 3607, 1, '2025-05-25T17:28:27.806', 106),
(107, N'Orvalho na Grama', N'Gravação de natureza: manhã fria e silenciosa.', N'NATUREZA', N'Começar a manhã sem pressa', 2400.00, NULL, 931, 1, '2026-08-02T13:31:12.599', 107),
(108, N'Rio Itajaí ao Amanhecer', N'Gravação de natureza: correnteza calma e pássaros.', N'NATUREZA', N'Começar a manhã sem pressa', 600.00, NULL, 1831, 1, '2025-09-18T15:26:53.045', 108),
(109, N'Ruído Branco Clássico', N'Ruído contínuo, espectro plano, chiado uniforme.', N'RUIDO', N'Abafar barulhos ao redor', 1000.00, NULL, 3623, 1, '2025-04-29T17:02:46.100', 109),
(110, N'Chiado de Rádio', N'Ruído contínuo, estática de rádio sem sintonia.', N'RUIDO', N'Concentração em estudo ou trabalho', 900.00, NULL, 2712, 1, '2026-04-08T16:33:09.099', 110),
(111, N'Volta pra Casa', N'Tons isocrônicos a 5.5 pulsos por segundo (faixa teta), pulsos sobre ruído de chuva.', N'ISOCRONICO', N'Fechar o dia com mais calma', 5.50, NULL, 1531, 1, '2026-06-04T13:48:30.853', 111),
(112, N'Quarto Escuro', N'Batimento binaural de 1.5 Hz (faixa delta), tom puro, sem outros sons. Use fones de ouvido.', N'BINAURAL', N'Desacelerar antes de dormir', 150.00, 151.50, 3600, 1, '2026-07-27T16:01:06.696', 112),
(113, N'Cordas Suaves', N'Música instrumental: quarteto de cordas em andamento lento.', N'MUSICA', N'Fechar o dia com mais calma', 440.00, NULL, 1531, 1, '2025-01-02T16:06:09.986', 113),
(114, N'Neblina Interior', N'Batimento binaural de 6 Hz (faixa teta), pad sintetizado suave por cima. Use fones de ouvido.', N'BINAURAL', N'Fechar o dia com mais calma', 220.00, 226.00, 1512, 1, '2025-05-12T13:39:39.191', 114),
(115, N'Chá de Camomila', N'Batimento binaural de 6.5 Hz (faixa teta), piano esparso em segundo plano. Use fones de ouvido.', N'BINAURAL', N'Fechar o dia com mais calma', 230.00, 236.50, 1523, 1, '2026-02-13T16:34:21.048', 115),
(116, N'Ventilador de Teto', N'Ruído contínuo, gravação de ventilador em velocidade baixa.', N'RUIDO', N'Desacelerar antes de dormir', 180.00, NULL, 3607, 1, '2026-08-24T19:58:24.193', 116),
(117, N'Contagem Lenta', N'Tons isocrônicos a 1.5 pulsos por segundo (faixa delta), pulsos que lembram um metrônomo distante.', N'ISOCRONICO', N'Desacelerar antes de dormir', 1.50, NULL, 1823, 1, '2025-08-27T13:35:24.871', 117),
(118, N'Acordes de Manhã', N'Música instrumental: violão e sinos leves.', N'MUSICA', N'Começar a manhã sem pressa', 440.00, NULL, 644, 1, '2025-07-21T12:49:44.907', 118),
(119, N'Tarde de Chuva no Sítio', N'Gravação de natureza: chuva, galos distantes e varanda.', N'NATUREZA', N'Fechar o dia com mais calma', 1700.00, NULL, 2444, 1, '2025-11-01T13:54:15.896', 119),
(120, N'Piano de Domingo', N'Música instrumental: peças curtas e tranquilas.', N'MUSICA', N'Criar um ambiente sonoro tranquilo', 440.00, NULL, 2107, 1, '2025-04-30T16:45:08.074', 120);
GO
SET IDENTITY_INSERT dbo.TB_SY_AUDIO_RELAXAMENTO OFF;
IF @@TRANCOUNT = 0
    RAISERROR(N'13_CARGA_TB_SY_AUDIO_RELAXAMENTO_120.sql: NÃO carregado (transação revertida). Corrija o erro acima e rode só este arquivo de novo.', 16, 1);
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT N'OK 13_CARGA_TB_SY_AUDIO_RELAXAMENTO_120.sql: 120 linhas em dbo.TB_SY_AUDIO_RELAXAMENTO.';
END;
GO
