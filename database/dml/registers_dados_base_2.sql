/*
    Projeto: ISEEYOU
    Arquivo: 02_seed_registros_teste.sql
    Objetivo: inserir registros fictícios para testes de consultas, views e validações.

    Observações:
    - Execute depois de 01_seed_dados_base.sql.
    - Não contém dados reais.
    - Os IDs foram fixados com IDENTITY_INSERT para facilitar testes e joins.
*/

SET IDENTITY_INSERT dbo.TB_SY_ENDERECO ON;
MERGE dbo.TB_SY_ENDERECO AS T
USING (VALUES
    (1, '89120000', 'Rua das Flores',       '120', 'Sala 2',      'Centro',       'Timbó',      'SC'),
    (2, '89010000', 'Avenida Brasil',       '450', NULL,          'Vila Nova',    'Blumenau',   'SC'),
    (3, '89160000', 'Rua dos Pinheiros',    '88',  'Consultório', 'Nações',       'Rio do Sul', 'SC')
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
    (1, 'Ana Clara Martins',    'ana.martins@exemplo.com',    '479999900001', 'hash_teste_ana',    'P'),
    (2, 'Bruno Henrique Souza', 'bruno.souza@exemplo.com',    '479999900002', 'hash_teste_bruno',  'P'),
    (3, 'Carla Menezes Lima',   'carla.lima@exemplo.com',     '479999900003', 'hash_teste_carla',  'P'),
    (4, 'Diego Rafael Alves',   'diego.alves@exemplo.com',    '479999900004', 'hash_teste_diego',  'P'),
    (5, 'Marina Costa Ribeiro', 'marina.ribeiro@exemplo.com', '479999900005', 'hash_teste_marina', 'S')
) AS S (id_usuario, nm_completo, ds_email, nr_telefone, ds_senha_hash, tp_perfil)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, nm_completo, ds_email, nr_telefone, ds_senha_hash, tp_perfil)
    VALUES (S.id_usuario, S.nm_completo, S.ds_email, S.nr_telefone, S.ds_senha_hash, S.tp_perfil);
SET IDENTITY_INSERT dbo.TB_SY_USUARIO OFF;
GO

MERGE dbo.TB_SY_PESSOA_FISICA AS T
USING (VALUES
    (1, '2008-03-15', 'responsavel.ana@exemplo.com',   '11122233344'),
    (2, '2007-11-22', 'responsavel.bruno@exemplo.com', '22233344455'),
    (3, '2006-08-09', NULL,                            '33344455566'),
    (4, '2009-01-28', 'responsavel.diego@exemplo.com', '44455566677')
) AS S (id_usuario, dt_nascimento, ds_email_guardiao, nr_cpf)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, dt_nascimento, ds_email_guardiao, nr_cpf)
    VALUES (S.id_usuario, S.dt_nascimento, S.ds_email_guardiao, S.nr_cpf);
GO

MERGE dbo.TB_SY_PSICOLOGO AS T
USING (VALUES
    (5, 1, '1234567')
) AS S (id_usuario, id_endereco, nr_crp)
ON T.id_usuario = S.id_usuario
WHEN NOT MATCHED THEN
    INSERT (id_usuario, id_endereco, nr_crp)
    VALUES (S.id_usuario, S.id_endereco, S.nr_crp);
GO

SET IDENTITY_INSERT dbo.TB_SY_ASSINATURA ON;
MERGE dbo.TB_SY_ASSINATURA AS T
USING (VALUES
    (1, 1, 1, 'A', '2026-06-01T08:00:00',  0.00, 'C', 'M'),
    (2, 2, 2, 'A', '2026-06-02T09:30:00', 29.90, 'P', 'M'),
    (3, 2, 3, 'A', '2026-06-05T14:15:00', 29.90, 'D', 'M'),
    (4, 1, 4, 'I', '2026-05-20T17:45:00',  0.00, 'B', 'M')
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
    (1, 1, 'https://exemplo.com/relatorio/ana',   '2026-06-03T10:00:00', 'R'),
    (2, 2, 'https://exemplo.com/relatorio/bruno', '2026-06-04T10:00:00', 'R'),
    (3, 3, 'https://exemplo.com/convite/carla',   '2026-06-06T10:00:00', 'C')
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
    (1, 1, 2,  9, '2026-06-10T08:10:00'),
    (2, 1, 1, 10, '2026-06-11T08:05:00'),
    (3, 1, 5,  7, '2026-06-12T08:20:00'),
    (4, 2, 3,  8, '2026-06-10T07:50:00'),
    (5, 2, 6,  7, '2026-06-11T07:55:00'),
    (6, 2, 4,  6, '2026-06-12T08:00:00'),
    (7, 3, 1, 10, '2026-06-10T09:15:00'),
    (8, 3, 2,  9, '2026-06-11T09:10:00'),
    (9, 4, 5,  7, '2026-06-10T06:45:00'),
    (10,4, 3,  8, '2026-06-11T06:50:00')
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
    (1, 1, 4, '2026-06-09T23:10:00', '2026-06-10T06:40:00', 'Sono bom, acordou disposto'),
    (2, 1, 5, '2026-06-10T22:50:00', '2026-06-11T06:55:00', 'Sono profundo e contínuo'),
    (3, 1, 2, '2026-06-11T23:45:00', '2026-06-12T05:50:00', 'Acordou durante a noite'),
    (4, 2, 3, '2026-06-09T23:30:00', '2026-06-10T06:10:00', 'Sono regular'),
    (5, 2, 2, '2026-06-10T00:20:00', '2026-06-10T05:45:00', 'Dormiu tarde e acordou cansado'),
    (6, 2, 1, '2026-06-11T01:00:00', '2026-06-11T05:30:00', 'Sono muito curto'),
    (7, 3, 5, '2026-06-09T22:40:00', '2026-06-10T07:00:00', 'Sono excelente'),
    (8, 3, 4, '2026-06-10T23:00:00', '2026-06-11T06:50:00', 'Sono bom'),
    (9, 4, 2, '2026-06-09T23:55:00', '2026-06-10T05:40:00', 'Sono ruim por ansiedade'),
    (10,4, 3, '2026-06-10T23:20:00', '2026-06-11T06:00:00', 'Sono mediano')
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
    (1, 1, 19, '2026-06-10T18:20:00', 'Estresse moderado por provas'),
    (2, 1, 21, '2026-06-11T18:00:00', 'Rotina acumulada'),
    (3, 2, 22, '2026-06-10T19:10:00', 'Pressão no trabalho'),
    (4, 2, 24, '2026-06-11T20:15:00', 'Dia muito cansativo'),
    (5, 3, 18, '2026-06-10T17:35:00', 'Dia tranquilo com leve preocupação'),
    (6, 3, 17, '2026-06-11T17:20:00', 'Baixo estresse'),
    (7, 4, 23, '2026-06-10T21:00:00', 'Ansiedade antes de entrega'),
    (8, 4, 20, '2026-06-11T21:10:00', 'Cansaço mental')
) AS S (id_estresse, id_usuario, id_classificacao, dt_registro, ds_estresse)
ON T.id_estresse = S.id_estresse
WHEN NOT MATCHED THEN
    INSERT (id_estresse, id_usuario, id_classificacao, dt_registro, ds_estresse)
    VALUES (S.id_estresse, S.id_usuario, S.id_classificacao, S.dt_registro, S.ds_estresse);
SET IDENTITY_INSERT dbo.TB_SY_MNT_ESTRESSE OFF;
GO

MERGE dbo.TB_SY_A_ESTRESSE_GATILHO AS T
USING (VALUES
    (1, 1), (1, 6),
    (2, 1), (2, 2),
    (3, 2),
    (4, 2), (4, 6),
    (5, 1),
    (6, 4),
    (7, 1), (7, 6),
    (8, 1), (8, 5)
) AS S (id_estresse, id_gatilho)
ON T.id_estresse = S.id_estresse AND T.id_gatilho = S.id_gatilho
WHEN NOT MATCHED THEN
    INSERT (id_estresse, id_gatilho)
    VALUES (S.id_estresse, S.id_gatilho);
GO

SET IDENTITY_INSERT dbo.TB_SY_FEEDBACK ON;
MERGE dbo.TB_SY_FEEDBACK AS T
USING (VALUES
    (1, 1, 14, 'Gostei da visualização dos registros de sono.',       '2026-06-12T12:00:00'),
    (2, 2, 13, 'O app poderia explicar melhor os resultados.',         '2026-06-12T12:20:00'),
    (3, 3, 15, 'Interface simples e fácil de usar.',                   '2026-06-12T13:10:00'),
    (4, 4, 12, 'Senti falta de lembretes personalizados.',             '2026-06-12T13:40:00')
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
    (1, 1, 'Semana de provas e rotina intensa de estudos.',     'M', '2026-06-10T18:30:00'),
    (2, 2, 'Dificuldade para dormir após dia de trabalho.',      'A', '2026-06-11T20:30:00'),
    (3, 3, 'Rotina equilibrada e boa organização pessoal.',      'B', '2026-06-11T19:00:00'),
    (4, 4, 'Ansiedade antes de apresentar trabalho escolar.',    'M', '2026-06-12T07:30:00')
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
    (1, 1, 1, 3, '2026-06-10T08:30:00', 6),
    (2, 1, 2, 7, '2026-06-11T08:30:00', 4),
    (3, 2, 1, 4, '2026-06-10T09:00:00', 8),
    (4, 2, 2, 8, '2026-06-11T09:00:00', 7),
    (5, 3, 1, 2, '2026-06-10T09:30:00', 3),
    (6, 4, 1, 4, '2026-06-10T10:00:00', 7)
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
    (1,  1, 1, 2, 2),
    (2,  2, 1, 2, 2),
    (3,  3, 1, 2, 2),
    (4,  4, 2, 1, 1),
    (5,  5, 2, 2, 2),
    (6,  6, 2, 1, 1),
    (7,  1, 3, 3, 3),
    (8,  2, 3, 3, 3),
    (9,  3, 3, 2, 2),
    (10, 4, 4, 2, 2),
    (11, 5, 4, 3, 3),
    (12, 6, 4, 2, 2),
    (13, 1, 5, 1, 1),
    (14, 2, 5, 1, 1),
    (15, 3, 5, 1, 1),
    (16, 1, 6, 3, 3),
    (17, 2, 6, 2, 2),
    (18, 3, 6, 2, 2)
) AS S (id_resposta_teste_usuario, id_pergunta, id_aplicacao, nr_resposta, nr_pontuacao)
ON T.id_resposta_teste_usuario = S.id_resposta_teste_usuario
WHEN NOT MATCHED THEN
    INSERT (id_resposta_teste_usuario, id_pergunta, id_aplicacao, nr_resposta, nr_pontuacao)
    VALUES (S.id_resposta_teste_usuario, S.id_pergunta, S.id_aplicacao, S.nr_resposta, S.nr_pontuacao);
SET IDENTITY_INSERT dbo.TB_SY_RESPOSTA_TESTE_USUARIO OFF;
GO
