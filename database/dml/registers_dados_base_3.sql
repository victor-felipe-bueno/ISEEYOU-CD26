/*
    Projeto: ISEEYOU
    Arquivo: 03_seed_registros_complementares.sql
    Objetivo: inserir registros fictícios complementares para ampliar testes de consultas, views e dashboards.

    Observações:
    - Execute depois de 02_seed_registros_teste.sql.
    - Não contém dados reais.
    - Os IDs foram fixados com IDENTITY_INSERT para facilitar testes e joins.
*/

SET IDENTITY_INSERT dbo.TB_SY_ENDERECO ON;
MERGE dbo.TB_SY_ENDERECO AS T
USING (VALUES
    (4, '89120110', 'Rua XV de Novembro',       '210', NULL,             'Centro',      'Timbó',       'SC'),
    (5, '89035000', 'Rua Amazonas',             '980', 'Apto 304',       'Garcia',      'Blumenau',    'SC'),
    (6, '89170000', 'Rua Joinville',            '55',  NULL,             'Industrial',  'Pomerode',    'SC'),
    (7, '89200000', 'Avenida Getúlio Vargas',   '700', 'Sala 12',        'Centro',      'Joinville',   'SC')
) AS S (id_endereco, nr_cep, ds_logradouro, nr_numero, ds_complemento, nm_bairro, nm_cidade, sg_estado)
ON T.id_endereco = S.id_endereco
WHEN NOT MATCHED THEN
    INSERT (id_endereco, nr_cep, ds_logradouro, nr_numero, ds_complemento, nm_bairro, nm_cidade, sg_estado)
    VALUES (S.id_endereco, S.nr_cep, S.ds_logradouro, S.nr_numero, S.ds_complemento, S.nm_bairro, S.nm_cidade, S.sg_estado);
SET IDENTITY_INSERT dbo.TB_SY_ENDERECO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_USUARIO ON;
MERGE dbo.TB_SY_USUARIO AS T
USING (VALUES
    (6,  'Lucas Pereira Nunes',    'lucas.nunes@exemplo.com',      '479999900006', 'hash_teste_lucas',    'P'),
    (7,  'Julia Fernanda Rocha',   'julia.rocha@exemplo.com',      '479999900007', 'hash_teste_julia',    'P'),
    (8,  'Pedro Augusto Vieira',   'pedro.vieira@exemplo.com',     '479999900008', 'hash_teste_pedro',    'P'),
    (9,  'Sofia Almeida Cardoso',  'sofia.cardoso@exemplo.com',    '479999900009', 'hash_teste_sofia',    'P'),
    (10, 'Rafael Gomes Ferreira',  'rafael.ferreira@exemplo.com',  '479999900010', 'hash_teste_rafael',   'P'),
    (11, 'Helena Duarte Psicologa','helena.duarte@exemplo.com',    '479999900011', 'hash_teste_helena',   'S')
) AS S (id_usuario, nm_completo, ds_email, nr_telefone, ds_senha_hash, tp_perfil)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, nm_completo, ds_email, nr_telefone, ds_senha_hash, tp_perfil)
    VALUES (S.id_usuario, S.nm_completo, S.ds_email, S.nr_telefone, S.ds_senha_hash, S.tp_perfil);
SET IDENTITY_INSERT dbo.TB_SY_USUARIO OFF;
GO

MERGE dbo.TB_SY_PESSOA_FISICA AS T
USING (VALUES
    (6,  '2008-06-18', 'responsavel.lucas@exemplo.com',  '55566677788'),
    (7,  '2007-04-02', 'responsavel.julia@exemplo.com',  '66677788899'),
    (8,  '2009-09-12', 'responsavel.pedro@exemplo.com',  '77788899900'),
    (9,  '2006-12-05', NULL,                             '88899900011'),
    (10, '2008-10-21', 'responsavel.rafael@exemplo.com', '99900011122')
) AS S (id_usuario, dt_nascimento, ds_email_guardiao, nr_cpf)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, dt_nascimento, ds_email_guardiao, nr_cpf)
    VALUES (S.id_usuario, S.dt_nascimento, S.ds_email_guardiao, S.nr_cpf);
GO

MERGE dbo.TB_SY_PSICOLOGO AS T
USING (VALUES
    (11, 7, '7654321')
) AS S (id_usuario, id_endereco, nr_crp)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, id_endereco, nr_crp)
    VALUES (S.id_usuario, S.id_endereco, S.nr_crp);
GO

SET IDENTITY_INSERT dbo.TB_SY_ASSINATURA ON;
MERGE dbo.TB_SY_ASSINATURA AS T
USING (VALUES
    (5,  1, 6,  'A', '2026-06-06T08:15:00',  0.00, 'C', 'M'),
    (6,  2, 7,  'A', '2026-06-07T09:20:00', 29.90, 'P', 'M'),
    (7,  2, 8,  'A', '2026-06-08T10:40:00', 29.90, 'D', 'M'),
    (8,  1, 9,  'A', '2026-06-09T11:30:00',  0.00, 'B', 'M'),
    (9,  2, 10, 'I', '2026-05-28T16:10:00', 29.90, 'C', 'M'),
    (10, 2, 11, 'A', '2026-06-10T13:00:00', 29.90, 'P', 'M')
) AS S (id_assinatura, id_plano, id_usuario, st_status, dt_assinatura, nr_valor, sg_tipo_pagamento, tp_periodo)
ON T.id_assinatura = S.id_assinatura
WHEN NOT MATCHED THEN
    INSERT (id_assinatura, id_plano, id_usuario, st_status, dt_assinatura, nr_valor, sg_tipo_pagamento, tp_periodo)
    VALUES (S.id_assinatura, S.id_plano, S.id_usuario, S.st_status, S.dt_assinatura, S.nr_valor, S.sg_tipo_pagamento, S.tp_periodo);
SET IDENTITY_INSERT dbo.TB_SY_ASSINATURA OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_LINK ON;
MERGE dbo.TB_SY_LINK AS T
USING (VALUES
    (4,  6,  'https://exemplo.com/relatorio/lucas',   '2026-06-13T10:00:00', 'R'),
    (5,  7,  'https://exemplo.com/relatorio/julia',   '2026-06-13T10:20:00', 'R'),
    (6,  8,  'https://exemplo.com/convite/pedro',     '2026-06-13T10:40:00', 'C'),
    (7,  9,  'https://exemplo.com/relatorio/sofia',   '2026-06-13T11:00:00', 'R'),
    (8,  10, 'https://exemplo.com/outros/rafael',     '2026-06-13T11:20:00', 'O')
) AS S (id_link, id_pessoa_fisica, url_completa, dt_criacao, tp_link)
ON T.id_link = S.id_link
WHEN NOT MATCHED THEN
    INSERT (id_link, id_pessoa_fisica, url_completa, dt_criacao, tp_link)
    VALUES (S.id_link, S.id_pessoa_fisica, S.url_completa, S.dt_criacao, S.tp_link);
SET IDENTITY_INSERT dbo.TB_SY_LINK OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_REGISTRO_HUMOR ON;
MERGE dbo.TB_SY_REGISTRO_HUMOR AS T
USING (VALUES
    (11, 6,  2,  9, '2026-06-13T07:40:00'),
    (12, 6,  1, 10, '2026-06-14T08:00:00'),
    (13, 6,  3,  8, '2026-06-15T07:55:00'),
    (14, 6,  5,  7, '2026-06-16T08:10:00'),
    (15, 7,  4,  6, '2026-06-13T07:30:00'),
    (16, 7,  3,  8, '2026-06-14T07:35:00'),
    (17, 7,  2,  9, '2026-06-15T07:45:00'),
    (18, 7,  1, 10, '2026-06-16T07:50:00'),
    (19, 8,  5,  7, '2026-06-13T09:10:00'),
    (20, 8,  6,  7, '2026-06-14T09:15:00'),
    (21, 8,  3,  8, '2026-06-15T09:20:00'),
    (22, 8,  2,  9, '2026-06-16T09:25:00'),
    (23, 9,  1, 10, '2026-06-13T08:40:00'),
    (24, 9,  2,  9, '2026-06-14T08:45:00'),
    (25, 9,  3,  8, '2026-06-15T08:50:00'),
    (26, 9,  4,  6, '2026-06-16T08:55:00'),
    (27, 10, 6,  7, '2026-06-13T06:50:00'),
    (28, 10, 5,  7, '2026-06-14T07:00:00'),
    (29, 10, 3,  8, '2026-06-15T07:05:00'),
    (30, 10, 1, 10, '2026-06-16T07:10:00')
) AS S (id_registro_humor, id_usuario, id_humor, id_classificacao, dt_registro)
ON T.id_registro_humor = S.id_registro_humor
WHEN NOT MATCHED THEN
    INSERT (id_registro_humor, id_usuario, id_humor, id_classificacao, dt_registro)
    VALUES (S.id_registro_humor, S.id_usuario, S.id_humor, S.id_classificacao, S.dt_registro);
SET IDENTITY_INSERT dbo.TB_SY_REGISTRO_HUMOR OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_MNT_SONO ON;
MERGE dbo.TB_SY_MNT_SONO AS T
USING (VALUES
    (11, 6,  4, '2026-06-12T23:05:00', '2026-06-13T06:45:00', 'Sono estável, acordou bem'),
    (12, 6,  5, '2026-06-13T22:40:00', '2026-06-14T07:10:00', 'Sono longo e reparador'),
    (13, 6,  3, '2026-06-14T23:30:00', '2026-06-15T06:20:00', 'Sono regular'),
    (14, 6,  2, '2026-06-15T00:10:00', '2026-06-15T05:40:00', 'Sono curto'),
    (15, 7,  2, '2026-06-12T00:20:00', '2026-06-12T05:50:00', 'Dormiu tarde'),
    (16, 7,  3, '2026-06-13T23:40:00', '2026-06-14T06:20:00', 'Sono mediano'),
    (17, 7,  4, '2026-06-14T23:00:00', '2026-06-15T06:50:00', 'Sono bom'),
    (18, 7,  5, '2026-06-15T22:35:00', '2026-06-16T07:05:00', 'Sono excelente'),
    (19, 8,  1, '2026-06-12T01:15:00', '2026-06-12T05:20:00', 'Sono muito curto'),
    (20, 8,  2, '2026-06-13T00:45:00', '2026-06-13T06:00:00', 'Sono ruim'),
    (21, 8,  3, '2026-06-14T23:50:00', '2026-06-15T06:30:00', 'Sono regular'),
    (22, 8,  4, '2026-06-15T23:10:00', '2026-06-16T06:50:00', 'Sono bom'),
    (23, 9,  5, '2026-06-12T22:30:00', '2026-06-13T07:20:00', 'Sono muito bom'),
    (24, 9,  4, '2026-06-13T23:00:00', '2026-06-14T06:55:00', 'Sono bom'),
    (25, 9,  4, '2026-06-14T23:15:00', '2026-06-15T07:00:00', 'Sono bom, leve despertar'),
    (26, 9,  3, '2026-06-15T23:35:00', '2026-06-16T06:25:00', 'Sono regular'),
    (27, 10, 2, '2026-06-12T00:30:00', '2026-06-12T05:40:00', 'Acordou cansado'),
    (28, 10, 2, '2026-06-13T00:10:00', '2026-06-13T05:55:00', 'Sono interrompido'),
    (29, 10, 3, '2026-06-14T23:40:00', '2026-06-15T06:10:00', 'Sono razoável'),
    (30, 10, 4, '2026-06-15T23:05:00', '2026-06-16T06:45:00', 'Sono melhor que o anterior')
) AS S (id_sono, id_usuario, id_classificacao, dt_inicio, dt_fim, ds_sono)
ON T.id_sono = S.id_sono
WHEN NOT MATCHED THEN
    INSERT (id_sono, id_usuario, id_classificacao, dt_inicio, dt_fim, ds_sono)
    VALUES (S.id_sono, S.id_usuario, S.id_classificacao, S.dt_inicio, S.dt_fim, S.ds_sono);
SET IDENTITY_INSERT dbo.TB_SY_MNT_SONO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_MNT_ESTRESSE ON;
MERGE dbo.TB_SY_MNT_ESTRESSE AS T
USING (VALUES
    (9,  6,  18, '2026-06-13T18:00:00', 'Leve preocupação com estudos'),
    (10, 6,  20, '2026-06-14T18:15:00', 'Rotina cheia, mas controlada'),
    (11, 6,  21, '2026-06-15T18:30:00', 'Cansaço por acúmulo de tarefas'),
    (12, 7,  23, '2026-06-13T19:00:00', 'Ansiedade antes de apresentação'),
    (13, 7,  22, '2026-06-14T19:10:00', 'Preocupação com prazos'),
    (14, 7,  19, '2026-06-15T19:20:00', 'Estresse moderado controlado'),
    (15, 8,  24, '2026-06-13T20:00:00', 'Dia pesado no trabalho'),
    (16, 8,  25, '2026-06-14T20:20:00', 'Sobrecarga intensa'),
    (17, 8,  22, '2026-06-15T20:30:00', 'Melhora parcial após descanso'),
    (18, 9,  17, '2026-06-13T17:40:00', 'Dia tranquilo'),
    (19, 9,  18, '2026-06-14T17:50:00', 'Leve preocupação'),
    (20, 9,  19, '2026-06-15T18:05:00', 'Pequena pressão por tarefas'),
    (21, 10, 23, '2026-06-13T21:10:00', 'Ansiedade e sono ruim'),
    (22, 10, 21, '2026-06-14T21:20:00', 'Cansaço acumulado'),
    (23, 10, 20, '2026-06-15T21:30:00', 'Estresse em queda')
) AS S (id_estresse, id_usuario, id_classificacao, dt_registro, ds_estresse)
ON T.id_estresse = S.id_estresse
WHEN NOT MATCHED THEN
    INSERT (id_estresse, id_usuario, id_classificacao, dt_registro, ds_estresse)
    VALUES (S.id_estresse, S.id_usuario, S.id_classificacao, S.dt_registro, S.ds_estresse);
SET IDENTITY_INSERT dbo.TB_SY_MNT_ESTRESSE OFF;
GO

MERGE dbo.TB_SY_A_ESTRESSE_GATILHO AS T
USING (VALUES
    (9,  1), (9,  4),
    (10, 1), (10, 6),
    (11, 1), (11, 2),
    (12, 1), (12, 4),
    (13, 1), (13, 6),
    (14, 1),
    (15, 2), (15, 6),
    (16, 2), (16, 5), (16, 6),
    (17, 2), (17, 6),
    (18, 4),
    (19, 1),
    (20, 1), (20, 3),
    (21, 5), (21, 6),
    (22, 6),
    (23, 1), (23, 6)
) AS S (id_estresse, id_gatilho)
ON T.id_estresse = S.id_estresse AND T.id_gatilho = S.id_gatilho
WHEN NOT MATCHED THEN
    INSERT (id_estresse, id_gatilho)
    VALUES (S.id_estresse, S.id_gatilho);
GO

SET IDENTITY_INSERT dbo.TB_SY_FEEDBACK ON;
MERGE dbo.TB_SY_FEEDBACK AS T
USING (VALUES
    (5,  6,  15, 'Gostei dos gráficos de evolução semanal.',              '2026-06-16T12:10:00'),
    (6,  7,  14, 'O registro de humor ficou simples de preencher.',        '2026-06-16T12:25:00'),
    (7,  8,  13, 'Poderia ter comparação entre sono e estresse.',          '2026-06-16T12:40:00'),
    (8,  9,  15, 'A análise diária ajuda a perceber padrões.',             '2026-06-16T13:00:00'),
    (9,  10, 12, 'Senti falta de recomendações após o registro.',          '2026-06-16T13:20:00')
) AS S (id_feedback, id_usuario, id_classificacao, ds_feedback, dt_registro)
ON T.id_feedback = S.id_feedback
WHEN NOT MATCHED THEN
    INSERT (id_feedback, id_usuario, id_classificacao, ds_feedback, dt_registro)
    VALUES (S.id_feedback, S.id_usuario, S.id_classificacao, S.ds_feedback, S.dt_registro);
SET IDENTITY_INSERT dbo.TB_SY_FEEDBACK OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_SITUACAO ON;
MERGE dbo.TB_SY_SITUACAO AS T
USING (VALUES
    (5,  6,  'Retorno de rotina após semana de avaliações.',          'B', '2026-06-13T18:30:00'),
    (6,  6,  'Acúmulo de tarefas escolares e pessoais.',              'M', '2026-06-15T18:45:00'),
    (7,  7,  'Preparação para apresentação em grupo.',                 'A', '2026-06-13T19:30:00'),
    (8,  7,  'Organização melhorou após planejamento semanal.',        'B', '2026-06-16T19:30:00'),
    (9,  8,  'Sobrecarga por trabalho e pouco descanso.',              'A', '2026-06-14T20:45:00'),
    (10, 9,  'Semana produtiva com boa rotina de sono.',               'B', '2026-06-15T18:10:00'),
    (11, 10, 'Sono irregular afetando disposição durante o dia.',      'M', '2026-06-14T21:40:00'),
    (12, 10, 'Melhora gradual após ajustar horário de dormir.',        'B', '2026-06-16T21:20:00')
) AS S (id_situacao, id_usuario, ds_situacao, nv_gravidade, dt_criacao)
ON T.id_situacao = S.id_situacao
WHEN NOT MATCHED THEN
    INSERT (id_situacao, id_usuario, ds_situacao, nv_gravidade, dt_criacao)
    VALUES (S.id_situacao, S.id_usuario, S.ds_situacao, S.nv_gravidade, S.dt_criacao);
SET IDENTITY_INSERT dbo.TB_SY_SITUACAO OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_APLICACAO_TESTE ON;
MERGE dbo.TB_SY_APLICACAO_TESTE AS T
USING (VALUES
    (7,  6,  1, 2, '2026-06-13T08:30:00', 4),
    (8,  6,  2, 8, '2026-06-14T08:30:00', 7),
    (9,  7,  1, 4, '2026-06-13T09:00:00', 8),
    (10, 7,  2, 7, '2026-06-15T09:00:00', 6),
    (11, 8,  1, 4, '2026-06-14T09:30:00', 9),
    (12, 8,  2, 6, '2026-06-16T09:30:00', 4),
    (13, 9,  1, 1, '2026-06-13T10:00:00', 2),
    (14, 9,  2, 8, '2026-06-15T10:00:00', 8),
    (15, 10, 1, 3, '2026-06-14T10:30:00', 6),
    (16, 10, 2, 6, '2026-06-16T10:30:00', 4)
) AS S (id_aplicacao, id_usuario, id_teste, id_faixa_resultado, dt_aplicacao, nr_pontuacao_total)
ON T.id_aplicacao = S.id_aplicacao
WHEN NOT MATCHED THEN
    INSERT (id_aplicacao, id_usuario, id_teste, id_faixa_resultado, dt_aplicacao, nr_pontuacao_total)
    VALUES (S.id_aplicacao, S.id_usuario, S.id_teste, S.id_faixa_resultado, S.dt_aplicacao, S.nr_pontuacao_total);
SET IDENTITY_INSERT dbo.TB_SY_APLICACAO_TESTE OFF;
GO

SET IDENTITY_INSERT dbo.TB_SY_RESPOSTA_TESTE_USUARIO ON;
MERGE dbo.TB_SY_RESPOSTA_TESTE_USUARIO AS T
USING (VALUES
    (19, 1,  7, 1, 1),
    (20, 2,  7, 1, 1),
    (21, 3,  7, 2, 2),
    (22, 4,  8, 3, 3),
    (23, 5,  8, 2, 2),
    (24, 6,  8, 2, 2),
    (25, 1,  9, 3, 3),
    (26, 2,  9, 3, 3),
    (27, 3,  9, 2, 2),
    (28, 4, 10, 2, 2),
    (29, 5, 10, 2, 2),
    (30, 6, 10, 2, 2),
    (31, 1, 11, 3, 3),
    (32, 2, 11, 3, 3),
    (33, 3, 11, 3, 3),
    (34, 4, 12, 1, 1),
    (35, 5, 12, 2, 2),
    (36, 6, 12, 1, 1),
    (37, 1, 13, 0, 0),
    (38, 2, 13, 1, 1),
    (39, 3, 13, 1, 1),
    (40, 4, 14, 3, 3),
    (41, 5, 14, 3, 3),
    (42, 6, 14, 2, 2),
    (43, 1, 15, 2, 2),
    (44, 2, 15, 2, 2),
    (45, 3, 15, 2, 2),
    (46, 4, 16, 1, 1),
    (47, 5, 16, 2, 2),
    (48, 6, 16, 1, 1)
) AS S (id_resposta_teste_usuario, id_pergunta, id_aplicacao, nr_resposta, nr_pontuacao)
ON T.id_resposta_teste_usuario = S.id_resposta_teste_usuario
WHEN NOT MATCHED THEN
    INSERT (id_resposta_teste_usuario, id_pergunta, id_aplicacao, nr_resposta, nr_pontuacao)
    VALUES (S.id_resposta_teste_usuario, S.id_pergunta, S.id_aplicacao, S.nr_resposta, S.nr_pontuacao);
SET IDENTITY_INSERT dbo.TB_SY_RESPOSTA_TESTE_USUARIO OFF;
GO
