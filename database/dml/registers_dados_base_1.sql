/*
    Projeto: ISEEYOU
    Arquivo: 01_seed_dados_base.sql
    Objetivo: inserir dados base/de domínio para testes do app e relatórios.

    Não inclui usuários reais.
*/

SET IDENTITY_INSERT dbo.TB_SY_PLANO ON;
MERGE dbo.TB_SY_PLANO AS T
USING (VALUES
    (1, 'basic', 'Plano básico do aplicativo'),
    (2, 'deep',  'Plano com recursos ampliados de acompanhamento')
) AS S (id_plano, nm_plano, ds_plano)
ON T.id_plano = S.id_plano
WHEN NOT MATCHED THEN
    INSERT (id_plano, nm_plano, ds_plano)
    VALUES (S.id_plano, S.nm_plano, S.ds_plano);
SET IDENTITY_INSERT dbo.TB_SY_PLANO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_TP_CLASSIFICACAO ON;
MERGE dbo.TB_SY_TP_CLASSIFICACAO AS T
USING (VALUES
    (1, 'SONO',            'Escala de qualidade do sono',         1, 5),
    (2, 'HUMOR',           'Escala de humor percebido',           1, 5),
    (3, 'FEEDBACK',        'Escala de feedback do usuário',       1, 5),
    (4, 'ESTRESSE',        'Escala de estresse percebido',        1, 10),
    (5, 'RESULTADO_TESTE', 'Escala de resultado por faixa',       1, 4)
) AS S (id_tp_classificacao, nm_tp_classificacao, ds_tp_classificacao, vl_min, vl_max)
ON T.id_tp_classificacao = S.id_tp_classificacao
WHEN NOT MATCHED THEN
    INSERT (id_tp_classificacao, nm_tp_classificacao, ds_tp_classificacao, vl_min, vl_max)
    VALUES (S.id_tp_classificacao, S.nm_tp_classificacao, S.ds_tp_classificacao, S.vl_min, S.vl_max);
SET IDENTITY_INSERT dbo.TB_SY_TP_CLASSIFICACAO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_CLASSIFICACAO ON;
MERGE dbo.TB_SY_CLASSIFICACAO AS T
USING (VALUES
    -- Sono: 1 a 5
    (1,  1, 1, 'Muito ruim'),
    (2,  1, 2, 'Ruim'),
    (3,  1, 3, 'Regular'),
    (4,  1, 4, 'Bom'),
    (5,  1, 5, 'Muito bom'),

    -- Humor: 1 a 5
    (6,  2, 1, 'Muito negativo'),
    (7,  2, 2, 'Negativo'),
    (8,  2, 3, 'Neutro'),
    (9,  2, 4, 'Positivo'),
    (10, 2, 5, 'Muito positivo'),

    -- Feedback: 1 a 5
    (11, 3, 1, 'Muito ruim'),
    (12, 3, 2, 'Ruim'),
    (13, 3, 3, 'Regular'),
    (14, 3, 4, 'Bom'),
    (15, 3, 5, 'Muito bom'),

    -- Estresse: 1 a 10
    (16, 4, 1,  'Nivel 1'),
    (17, 4, 2,  'Nivel 2'),
    (18, 4, 3,  'Nivel 3'),
    (19, 4, 4,  'Nivel 4'),
    (20, 4, 5,  'Nivel 5'),
    (21, 4, 6,  'Nivel 6'),
    (22, 4, 7,  'Nivel 7'),
    (23, 4, 8,  'Nivel 8'),
    (24, 4, 9,  'Nivel 9'),
    (25, 4, 10, 'Nivel 10'),

    -- Resultado de testes: 1 a 4
    (26, 5, 1, 'Baixo'),
    (27, 5, 2, 'Leve'),
    (28, 5, 3, 'Moderado'),
    (29, 5, 4, 'Alto')
) AS S (id_classificacao, id_tp_classificacao, vl_classificacao, nm_classificacao)
ON T.id_classificacao = S.id_classificacao
WHEN NOT MATCHED THEN
    INSERT (id_classificacao, id_tp_classificacao, vl_classificacao, nm_classificacao)
    VALUES (S.id_classificacao, S.id_tp_classificacao, S.vl_classificacao, S.nm_classificacao);
SET IDENTITY_INSERT dbo.TB_SY_CLASSIFICACAO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_HUMOR ON;
MERGE dbo.TB_SY_HUMOR AS T
USING (VALUES
    (1, 'Feliz',    'Sensação positiva e agradável'),
    (2, 'Calmo',    'Sensação de tranquilidade'),
    (3, 'Neutro',   'Sem alteração emocional marcante'),
    (4, 'Triste',   'Sensação de tristeza ou desânimo'),
    (5, 'Ansioso',  'Sensação de ansiedade ou inquietação'),
    (6, 'Irritado', 'Sensação de irritação')
) AS S (id_humor, nm_humor, ds_humor)
ON T.id_humor = S.id_humor
WHEN NOT MATCHED THEN
    INSERT (id_humor, nm_humor, ds_humor)
    VALUES (S.id_humor, S.nm_humor, S.ds_humor);
SET IDENTITY_INSERT dbo.TB_SY_HUMOR OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_GATILHOS ON;
MERGE dbo.TB_SY_GATILHOS AS T
USING (VALUES
    (1, 'Estudo',      'Situações ligadas à rotina de estudos'),
    (2, 'Trabalho',    'Situações ligadas ao trabalho'),
    (3, 'Família',     'Conflitos ou responsabilidades familiares'),
    (4, 'Social',      'Interações sociais ou eventos'),
    (5, 'Saúde',       'Preocupações com saúde'),
    (6, 'Sono',        'Noites mal dormidas ou cansaço'),
    (7, 'Alimentação', 'Mudanças na alimentação')
) AS S (id_gatilho, nm_gatilho, ds_gatilho)
ON T.id_gatilho = S.id_gatilho
WHEN NOT MATCHED THEN
    INSERT (id_gatilho, nm_gatilho, ds_gatilho)
    VALUES (S.id_gatilho, S.nm_gatilho, S.ds_gatilho);
SET IDENTITY_INSERT dbo.TB_SY_GATILHOS OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_PERSONALIDADE ON;
MERGE dbo.TB_SY_PERSONALIDADE AS T
USING (VALUES
    (1, 'Abertura',        'Tendência a buscar novas experiências e ideias'),
    (2, 'Conscienciosidade','Tendência a organização e responsabilidade'),
    (3, 'Extroversão',     'Tendência a buscar interação social'),
    (4, 'Amabilidade',     'Tendência a cooperação e empatia'),
    (5, 'Neuroticismo',    'Tendência a maior sensibilidade emocional')
) AS S (id_personalidade, nm_personalidade, ds_personalidade)
ON T.id_personalidade = S.id_personalidade
WHEN NOT MATCHED THEN
    INSERT (id_personalidade, nm_personalidade, ds_personalidade)
    VALUES (S.id_personalidade, S.nm_personalidade, S.ds_personalidade);
SET IDENTITY_INSERT dbo.TB_SY_PERSONALIDADE OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_CARACTERISTICA ON;
MERGE dbo.TB_SY_CARACTERISTICA AS T
USING (VALUES
    (1, 'Criatividade'),
    (2, 'Organização'),
    (3, 'Sociabilidade'),
    (4, 'Empatia'),
    (5, 'Sensibilidade emocional')
) AS S (id_caracteristica, nm_caracteristica)
ON T.id_caracteristica = S.id_caracteristica
WHEN NOT MATCHED THEN
    INSERT (id_caracteristica, nm_caracteristica)
    VALUES (S.id_caracteristica, S.nm_caracteristica);
SET IDENTITY_INSERT dbo.TB_SY_CARACTERISTICA OFF;
GO

MERGE dbo.TB_SY_A_PERSONALIDADE_CARACTERISTICA AS T
USING (VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5)
) AS S (id_personalidade, id_caracteristica)
ON T.id_personalidade = S.id_personalidade AND T.id_caracteristica = S.id_caracteristica
WHEN NOT MATCHED THEN
    INSERT (id_personalidade, id_caracteristica)
    VALUES (S.id_personalidade, S.id_caracteristica);
GO

SET IDENTITY_INSERT dbo.TB_SY_TP_TESTE ON;
MERGE dbo.TB_SY_TP_TESTE AS T
USING (VALUES
    (1, 'Autoavaliação', 'Teste de autopreenchimento no aplicativo', 5),
    (2, 'Bem-estar',     'Teste simples de acompanhamento de bem-estar', 5)
) AS S (id_tp_teste, nm_tipo_teste, ds_tipo_teste, tm_duracao)
ON T.id_tp_teste = S.id_tp_teste
WHEN NOT MATCHED THEN
    INSERT (id_tp_teste, nm_tipo_teste, ds_tipo_teste, tm_duracao)
    VALUES (S.id_tp_teste, S.nm_tipo_teste, S.ds_tipo_teste, S.tm_duracao);
SET IDENTITY_INSERT dbo.TB_SY_TP_TESTE OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_TESTE ON;
MERGE dbo.TB_SY_TESTE AS T
USING (VALUES
    (1, 1, 'Teste de Estresse', 'Autoavaliação rápida de estresse percebido', GETDATE()),
    (2, 2, 'Teste de Bem-estar', 'Autoavaliação rápida de bem-estar percebido', GETDATE())
) AS S (id_teste, id_tp_teste, nm_teste, ds_teste, dt_criacao)
ON T.id_teste = S.id_teste
WHEN NOT MATCHED THEN
    INSERT (id_teste, id_tp_teste, nm_teste, ds_teste, dt_criacao)
    VALUES (S.id_teste, S.id_tp_teste, S.nm_teste, S.ds_teste, S.dt_criacao);
SET IDENTITY_INSERT dbo.TB_SY_TESTE OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_PERGUNTA_TESTE ON;
MERGE dbo.TB_SY_PERGUNTA_TESTE AS T
USING (VALUES
    (1, 'Nos últimos dias, senti dificuldade para relaxar.', 1),
    (2, 'Nos últimos dias, senti preocupação constante.', 2),
    (3, 'Nos últimos dias, tive sensação de sobrecarga.', 3),
    (4, 'Nos últimos dias, tive energia para realizar minhas atividades.', 1),
    (5, 'Nos últimos dias, consegui manter uma rotina equilibrada.', 2),
    (6, 'Nos últimos dias, senti satisfação com minha rotina.', 3)
) AS S (id_pergunta, ds_pergunta, nr_ordem)
ON T.id_pergunta = S.id_pergunta
WHEN NOT MATCHED THEN
    INSERT (id_pergunta, ds_pergunta, nr_ordem)
    VALUES (S.id_pergunta, S.ds_pergunta, S.nr_ordem);
SET IDENTITY_INSERT dbo.TB_SY_PERGUNTA_TESTE OFF;
GO

MERGE dbo.TB_SY_A_TESTE_PERGUNTA_TESTE AS T
USING (VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 2),
    (5, 2),
    (6, 2)
) AS S (id_pergunta, id_teste)
ON T.id_pergunta = S.id_pergunta AND T.id_teste = S.id_teste
WHEN NOT MATCHED THEN
    INSERT (id_pergunta, id_teste)
    VALUES (S.id_pergunta, S.id_teste);
GO

SET IDENTITY_INSERT dbo.TB_SY_FAIXA_RESULTADO_TESTE ON;
MERGE dbo.TB_SY_FAIXA_RESULTADO_TESTE AS T
USING (VALUES
    -- Teste de Estresse: pontuação 0 a 9
    (1, 1, 26, 0, 2),
    (2, 1, 27, 3, 4),
    (3, 1, 28, 5, 6),
    (4, 1, 29, 7, 9),

    -- Teste de Bem-estar: pontuação 0 a 9
    (5, 2, 26, 0, 2),
    (6, 2, 27, 3, 4),
    (7, 2, 28, 5, 6),
    (8, 2, 29, 7, 9)
) AS S (id_faixa_resultado, id_teste, id_classificacao, vl_min_pontuacao, vl_max_pontuacao)
ON T.id_faixa_resultado = S.id_faixa_resultado
WHEN NOT MATCHED THEN
    INSERT (id_faixa_resultado, id_teste, id_classificacao, vl_min_pontuacao, vl_max_pontuacao)
    VALUES (S.id_faixa_resultado, S.id_teste, S.id_classificacao, S.vl_min_pontuacao, S.vl_max_pontuacao);
SET IDENTITY_INSERT dbo.TB_SY_FAIXA_RESULTADO_TESTE OFF;
GO
