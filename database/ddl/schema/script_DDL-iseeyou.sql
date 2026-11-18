/*
    I SEE YOU | Trabalho de Conclusão de Curso | Sprint 7
    DDL DEFINITIVO, alinhado ao DER V14 (versão de 2026-11-11) - SQL Server 2019 ou superior
    (collation UTF-8 exige 2019+; máscara dinâmica de dados exige 2016+).
    Execute o arquivo completo no SSMS ou no sqlcmd.

    ======================================================================
    CONVENÇÃO DE NOMES (Guia de Apelidos)
    ======================================================================
    PRIMARY KEY ........ PK_NOME_TABELA
    FOREIGN KEY ........ FK_TABELA_ORIGEM_TABELA_DESTINO
                         (a entidade referenciada precede a tabela que
                          contém a restrição; sufixo extra só quando há
                          mais de uma FK para a mesma tabela)
    FK em associativas . PF_TABELA_ORIGEM_A_TABELA_DESTINO
    UNIQUE ............. UN_TABELA_COLUNA(S)
    UNIQUE em 1:1 ...... UN_TABELA_FK_COLUNA
    CHECK .............. CK_TABELA_COLUNA
    DEFAULT ............ DF_TABELA_COLUNA
    Índice não único ... IX_TABELA_COLUNA(S)
                         (o guia não cobre índices; adotado o mesmo padrão)
    As tabelas mantêm o prefixo TB_SY_. As FKs usam NO ACTION.
    Tabelas e índices são criados em uma única transação.

*/
USE [master];
GO

IF CAST(SERVERPROPERTY('ProductMajorVersion') AS INT) < 15
    THROW 50002, N'Este script exige SQL Server 2019 ou superior (collation UTF-8).', 1;

IF DB_ID(N'DB_I_SEE_YOU') IS NULL
BEGIN
    -- Collation UTF-8: VARCHAR/CHAR passam a aceitar todos os caracteres (SQL Server 2019+).
    EXEC (N'CREATE DATABASE [DB_I_SEE_YOU] COLLATE Latin1_General_100_CI_AS_SC_UTF8');
END;
GO

USE [DB_I_SEE_YOU];
GO

IF DB_NAME() <> N'DB_I_SEE_YOU'
    THROW 50000, N'Execute o script no banco DB_I_SEE_YOU.', 1;

IF CAST(SERVERPROPERTY('ProductMajorVersion') AS INT) < 15
    THROW 50002, N'Este script exige SQL Server 2019 ou superior (collation UTF-8).', 1;

IF CAST(DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS NVARCHAR(128)) NOT LIKE N'%UTF8'
    THROW 50003, N'O banco precisa usar uma collation UTF-8 (ex.: Latin1_General_100_CI_AS_SC_UTF8).', 1;

-- Opções exigidas pelo SQL Server para índices filtrados.
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.TB_SY_USUARIO', N'U') IS NOT NULL
        THROW 50001, N'As tabelas já existem neste banco. Remova-as antes de executar o script novamente.', 1;

    -- Cadastrar as contas do aplicativo, seus dados de acesso, perfil, nascimento e exclusão lógica.
    -- O serviço de autenticação normaliza o e-mail e armazena somente o hash da senha.
    -- A máscara dinâmica é aplicada na consulta conforme as permissões do usuário do banco.
    -- Domínio de sg_sexo: M, N e I. Idade mínima de 16 anos, verificada ao gravar o nascimento.
    -- A regra de responsável legal para menores de 18 anos fica na aplicação.
    CREATE TABLE dbo.TB_SY_USUARIO
    (
        id_usuario INT IDENTITY(1,1) NOT NULL,
        nm_completo VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXXXXX",0)') NOT NULL,
        nm_exibicao VARCHAR(100) NULL,
        sg_sexo CHAR(1) NOT NULL,
        ds_email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
        ds_senha_hash VARCHAR(255) MASKED WITH (FUNCTION = 'default()') NOT NULL,
        tp_perfil CHAR(1) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_USUARIO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        dt_exclusao DATETIME2 NULL,
        dt_nascimento DATE MASKED WITH (FUNCTION = 'default()') NOT NULL,
        CONSTRAINT PK_USUARIO PRIMARY KEY (id_usuario),
        CONSTRAINT CK_USUARIO_DS_EMAIL
            CHECK (ds_email LIKE '_%@_%._%' AND ds_email NOT LIKE '%@%@%' AND ds_email NOT LIKE '% %'),
        CONSTRAINT CK_USUARIO_SG_SEXO
            CHECK (sg_sexo COLLATE Latin1_General_100_BIN2_UTF8 IN ('M', 'F', 'I')),
        CONSTRAINT CK_USUARIO_TP_PERFIL
            CHECK (tp_perfil COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'M', 'A')),
        CONSTRAINT CK_USUARIO_DT_NASCIMENTO
            CHECK (dt_nascimento > CONVERT(DATE, '19000101', 112) AND dt_nascimento <= DATEADD(YEAR, -16, CONVERT(DATE, SYSUTCDATETIME())))
    );

    -- E-mail único entre contas ativas; o e-mail de conta excluída logicamente não bloqueia novo cadastro.
    CREATE UNIQUE INDEX UN_USUARIO_DS_EMAIL
        ON dbo.TB_SY_USUARIO (ds_email)
        WHERE dt_exclusao IS NULL;

    -- Manter o catálogo de planos e sua periodicidade para as assinaturas do aplicativo.
    CREATE TABLE dbo.TB_SY_PLANO
    (
        id_plano INT IDENTITY(1,1) NOT NULL,
        nm_plano VARCHAR(100) NOT NULL,
        tp_periodicidade CHAR(1) NOT NULL,
        ds_plano VARCHAR(250) NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_PLANO_FL_ATIVO DEFAULT (1),
        CONSTRAINT PK_PLANO PRIMARY KEY (id_plano),
        CONSTRAINT UN_PLANO_NM_PLANO UNIQUE (nm_plano),
        CONSTRAINT CK_PLANO_TP_PERIODICIDADE
            CHECK (tp_periodicidade COLLATE Latin1_General_100_BIN2_UTF8 IN ('M', 'A'))
    );

    -- Manter endereços externos e links de recursos, inclusive os utilizados pelo catálogo de áudios.
    CREATE TABLE dbo.TB_SY_LINK
    (
        id_link INT IDENTITY(1,1) NOT NULL,
        url_completa VARCHAR(255) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_LINK_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        fl_ativo BIT NOT NULL CONSTRAINT DF_LINK_FL_ATIVO DEFAULT (1),
        tp_link CHAR(1) NULL,
        CONSTRAINT PK_LINK PRIMARY KEY (id_link),
        CONSTRAINT CK_LINK_TP_LINK
            CHECK (tp_link COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'V', 'W', 'O'))
    );

    -- Manter missões e sua recompensa em pontos para a gamificação.
    CREATE TABLE dbo.TB_SY_MISSAO
    (
        id_missao INT IDENTITY(1,1) NOT NULL,
        nm_missao VARCHAR(100) NOT NULL,
        ds_missao VARCHAR(100) NOT NULL,
        vl_ponto INT NOT NULL,
        CONSTRAINT PK_MISSAO PRIMARY KEY (id_missao),
        CONSTRAINT UN_MISSAO_NM_MISSAO UNIQUE (nm_missao),
        CONSTRAINT CK_MISSAO_VL_PONTO
            CHECK (vl_ponto > 0)
    );

    -- Manter categorias utilizadas para organizar as missões do aplicativo.
    CREATE TABLE dbo.TB_SY_CATEGORIA_MISSAO
    (
        id_categoria INT IDENTITY(1,1) NOT NULL,
        nm_categoria VARCHAR(100) NOT NULL,
        ds_categoria VARCHAR(250) NOT NULL,
        CONSTRAINT PK_CATEGORIA_MISSAO PRIMARY KEY (id_categoria),
        CONSTRAINT UN_CATEGORIA_MISSAO_NM_CATEGORIA UNIQUE (nm_categoria)
    );

    -- Manter o catálogo de gatilhos emocionais associados aos registros de estresse.
    CREATE TABLE dbo.TB_SY_GATILHO
    (
        id_gatilho INT IDENTITY(1,1) NOT NULL,
        nm_gatilho VARCHAR(30) NOT NULL,
        ds_gatilho VARCHAR(250) NOT NULL,
        CONSTRAINT PK_GATILHO PRIMARY KEY (id_gatilho),
        CONSTRAINT UN_GATILHO_NM_GATILHO UNIQUE (nm_gatilho)
    );

    -- Manter o catálogo de conquistas e recompensas em pontos.
    CREATE TABLE dbo.TB_SY_CONQUISTA
    (
        id_conquista INT IDENTITY(1,1) NOT NULL,
        nm_conquista VARCHAR(100) NOT NULL,
        ds_conquista VARCHAR(255) NOT NULL,
        nr_pontos_recompensa INT NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_CONQUISTA_FL_ATIVO DEFAULT (1),
        CONSTRAINT PK_CONQUISTA PRIMARY KEY (id_conquista),
        CONSTRAINT UN_CONQUISTA_NM_CONQUISTA UNIQUE (nm_conquista),
        CONSTRAINT CK_CONQUISTA_NR_PONTOS_RECOMPENSA
            CHECK (nr_pontos_recompensa > 0)
    );

    -- Manter os mundos da gamificação, sua ordem e a pontuação necessária para desbloqueio.
    CREATE TABLE dbo.TB_SY_MUNDO
    (
        id_mundo INT IDENTITY(1,1) NOT NULL,
        nm_mundo VARCHAR(100) NOT NULL,
        ds_mundo VARCHAR(255) NOT NULL,
        nr_pontos_necessarios INT NOT NULL,
        nr_ordem INT NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_MUNDO_FL_ATIVO DEFAULT (1),
        CONSTRAINT PK_MUNDO PRIMARY KEY (id_mundo),
        CONSTRAINT UN_MUNDO_NM_MUNDO UNIQUE (nm_mundo),
        CONSTRAINT UN_MUNDO_NR_ORDEM UNIQUE (nr_ordem),
        CONSTRAINT CK_MUNDO_NR_PONTOS_NECESSARIOS
            CHECK (nr_pontos_necessarios >= 0)
    );

    -- Manter as categorias dos relatos e permitir a organização dos feeds por assunto.
    CREATE TABLE dbo.TB_SY_CATEGORIA_PUBLICACAO
    (
        id_categoria INT IDENTITY(1,1) NOT NULL,
        nm_categoria VARCHAR(100) NOT NULL,
        ds_categoria VARCHAR(250) NOT NULL,
        CONSTRAINT PK_CATEGORIA_PUBLICACAO PRIMARY KEY (id_categoria),
        CONSTRAINT UN_CATEGORIA_PUBLICACAO_NM_CATEGORIA UNIQUE (nm_categoria)
    );

    -- Versionar termos de uso, privacidade e consentimento, com hash do conteúdo e período de vigência.
    -- O índice de versão aberta complementa a validação de sobreposição de vigências (feita pela aplicação).
    CREATE TABLE dbo.TB_SY_TERMO_VERSAO
    (
        id_termo_versao INT IDENTITY(1,1) NOT NULL,
        cd_hash_conteudo CHAR(64) NOT NULL,
        tp_termo CHAR(1) NOT NULL,
        nr_versao VARCHAR(20) NOT NULL,
        dt_vigencia_inicio DATETIME2 NOT NULL,
        dt_vigencia_fim DATETIME2 NULL,
        CONSTRAINT PK_TERMO_VERSAO PRIMARY KEY (id_termo_versao),
        CONSTRAINT UN_TERMO_VERSAO_TP_TERMO_NR_VERSAO UNIQUE (tp_termo, nr_versao),
        CONSTRAINT CK_TERMO_VERSAO_CD_HASH_CONTEUDO
            CHECK (LEN(cd_hash_conteudo) = 64 AND cd_hash_conteudo COLLATE Latin1_General_100_BIN2_UTF8 NOT LIKE '%[^0-9A-Fa-f]%'),
        CONSTRAINT CK_TERMO_VERSAO_TP_TERMO
            CHECK (tp_termo COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'P', 'S', 'R')),
        CONSTRAINT CK_TERMO_VERSAO_DT_VIGENCIA_FIM
            CHECK (dt_vigencia_fim IS NULL OR dt_vigencia_fim > dt_vigencia_inicio)
    );

    -- Uma versão sem data de fim por tipo de termo.
    CREATE UNIQUE INDEX UN_TERMO_VERSAO_TP_TERMO
        ON dbo.TB_SY_TERMO_VERSAO (tp_termo)
        WHERE dt_vigencia_fim IS NULL;

    -- Manter o catálogo de humores que podem ser selecionados nos registros emocionais.
    CREATE TABLE dbo.TB_SY_HUMOR
    (
        id_humor INT IDENTITY(1,1) NOT NULL,
        nm_humor VARCHAR(30) NOT NULL,
        ds_humor VARCHAR(100) NOT NULL,
        CONSTRAINT PK_HUMOR PRIMARY KEY (id_humor),
        CONSTRAINT UN_HUMOR_NM_HUMOR UNIQUE (nm_humor)
    );

    -- Manter o catálogo de prêmios disponíveis para resgate e seus custos em pontos.
    CREATE TABLE dbo.TB_SY_PREMIO
    (
        id_premio INT IDENTITY(1,1) NOT NULL,
        nm_premio VARCHAR(100) NOT NULL,
        ds_premio VARCHAR(255) NOT NULL,
        nr_custo_pontos INT NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_PREMIO_FL_ATIVO DEFAULT (1),
        CONSTRAINT PK_PREMIO PRIMARY KEY (id_premio),
        CONSTRAINT UN_PREMIO_NM_PREMIO UNIQUE (nm_premio),
        CONSTRAINT CK_PREMIO_NR_CUSTO_PONTOS
            CHECK (nr_custo_pontos > 0)
    );

    -- Cadastrar o responsável legal do menor, com contato, documento em HMAC e verificação.
    -- A aplicação calcula o HMAC do documento com chave mantida fora do banco.
    CREATE TABLE dbo.TB_SY_RESPONSAVEL
    (
        id_responsavel INT IDENTITY(1,1) NOT NULL,
        nm_responsavel VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXXXXX",0)') NOT NULL,
        ds_email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
        nr_telefone VARCHAR(11) MASKED WITH (FUNCTION = 'partial(0,"XXXXXXX",4)') NOT NULL,
        tp_documento CHAR(1) NOT NULL,
        cd_documento_hash CHAR(64) NOT NULL,
        dt_cadastro DATETIME2 NOT NULL CONSTRAINT DF_RESPONSAVEL_DT_CADASTRO DEFAULT (SYSUTCDATETIME()),
        fl_verificado BIT NOT NULL CONSTRAINT DF_RESPONSAVEL_FL_VERIFICADO DEFAULT (0),
        CONSTRAINT PK_RESPONSAVEL PRIMARY KEY (id_responsavel),
        CONSTRAINT UN_RESPONSAVEL_TP_DOCUMENTO_CD_DOCUMENTO_HASH UNIQUE (tp_documento, cd_documento_hash),
        CONSTRAINT CK_RESPONSAVEL_NR_TELEFONE
            CHECK (LEN(nr_telefone) IN (10, 11) AND LEN(nr_telefone) = DATALENGTH(nr_telefone) AND nr_telefone COLLATE Latin1_General_100_BIN2_UTF8 NOT LIKE '%[^0-9]%'),
        CONSTRAINT CK_RESPONSAVEL_TP_DOCUMENTO
            CHECK (tp_documento COLLATE Latin1_General_100_BIN2_UTF8 IN ('C', 'R', 'P')),
        CONSTRAINT CK_RESPONSAVEL_CD_DOCUMENTO_HASH
            CHECK (LEN(cd_documento_hash) = 64 AND cd_documento_hash COLLATE Latin1_General_100_BIN2_UTF8 NOT LIKE '%[^0-9A-Fa-f]%')
    );

    -- Registrar arquivos privados do usuário e seus metadados.
    -- O caminho do armazenamento é opaco. A aplicação gera a URL temporária.
    -- Biblioteca de arquivos privados do usuário (ex.: foto de perfil, arquivos exportados).
    CREATE TABLE dbo.TB_SY_ARQUIVO_USUARIO
    (
        id_arquivo INT IDENTITY(1,1) NOT NULL,
        nm_arquivo VARCHAR(255) NOT NULL,
        tp_arquivo CHAR(1) NOT NULL,
        ds_mime_type VARCHAR(100) NOT NULL,
        nr_tamanho_bytes BIGINT NOT NULL,
        ds_caminho_dir VARCHAR(255) NOT NULL,
        dt_cadastro DATETIME2 NOT NULL CONSTRAINT DF_ARQUIVO_USUARIO_DT_CADASTRO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        CONSTRAINT PK_ARQUIVO_USUARIO PRIMARY KEY (id_arquivo),
        CONSTRAINT FK_USUARIO_ARQUIVO_USUARIO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT UN_ARQUIVO_USUARIO_DS_CAMINHO_DIR UNIQUE (ds_caminho_dir),
        CONSTRAINT CK_ARQUIVO_USUARIO_TP_ARQUIVO
            CHECK (tp_arquivo COLLATE Latin1_General_100_BIN2_UTF8 IN ('I', 'A', 'V', 'D')),
        CONSTRAINT CK_ARQUIVO_USUARIO_NR_TAMANHO_BYTES
            CHECK (nr_tamanho_bytes > 0)
    );

    CREATE INDEX IX_ARQUIVO_USUARIO_ID_USUARIO
        ON dbo.TB_SY_ARQUIVO_USUARIO (id_usuario);

    -- Registrar convites e autorizações entre usuário monitorado e guardião, com relação, estado e datas.
    -- id_usuario_guardiao é opcional, conforme o DER; um convite aceito exige guardião identificado.
    -- O convite parte do usuário monitorado; o guardião é preenchido quando aceita o convite.
    CREATE TABLE dbo.TB_SY_CONVITE_GUARDIAO
    (
        id_convite INT IDENTITY(1,1) NOT NULL,
        tp_relacao CHAR(1) NOT NULL,
        st_convite CHAR(1) NOT NULL CONSTRAINT DF_CONVITE_GUARDIAO_ST_CONVITE DEFAULT ('P'),
        dt_solicitacao DATETIME2 NOT NULL CONSTRAINT DF_CONVITE_GUARDIAO_DT_SOLICITACAO DEFAULT (SYSUTCDATETIME()),
        dt_aceite DATETIME2 NULL,
        dt_fim DATETIME2 NULL,
        id_usuario_monitorado INT NOT NULL,
        id_usuario_guardiao INT NULL,
        CONSTRAINT PK_CONVITE_GUARDIAO PRIMARY KEY (id_convite),
        CONSTRAINT FK_USUARIO_CONVITE_GUARDIAO_MONITORADO FOREIGN KEY (id_usuario_monitorado)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_USUARIO_CONVITE_GUARDIAO_GUARDIAO FOREIGN KEY (id_usuario_guardiao)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_CONVITE_GUARDIAO_TP_RELACAO
            CHECK (tp_relacao COLLATE Latin1_General_100_BIN2_UTF8 IN ('F', 'A', 'P', 'O')),
        CONSTRAINT CK_CONVITE_GUARDIAO_ST_CONVITE
            CHECK (st_convite COLLATE Latin1_General_100_BIN2_UTF8 IN ('P', 'A', 'R', 'E')),
        CONSTRAINT CK_CONVITE_GUARDIAO_DT_ACEITE
            CHECK (
                dt_aceite IS NULL AND st_convite IN ('P', 'R', 'E')
                OR dt_aceite IS NOT NULL AND st_convite IN ('A', 'E')
                   AND dt_aceite >= dt_solicitacao
            ),
        CONSTRAINT CK_CONVITE_GUARDIAO_DT_FIM
            CHECK (
                st_convite IN ('P', 'A') AND dt_fim IS NULL
                OR st_convite IN ('R', 'E') AND dt_fim IS NOT NULL
                   AND dt_fim >= dt_solicitacao
                   AND (dt_aceite IS NULL OR dt_fim >= dt_aceite)
            ),
        CONSTRAINT CK_CONVITE_GUARDIAO_ID_USUARIO_GUARDIAO
            CHECK (
                (id_usuario_guardiao IS NULL OR id_usuario_guardiao <> id_usuario_monitorado)
                AND (dt_aceite IS NULL OR id_usuario_guardiao IS NOT NULL)
            )
    );

    CREATE INDEX IX_CONVITE_GUARDIAO_ID_USUARIO_MONITORADO
        ON dbo.TB_SY_CONVITE_GUARDIAO (id_usuario_monitorado);

    CREATE INDEX IX_CONVITE_GUARDIAO_ID_USUARIO_GUARDIAO
        ON dbo.TB_SY_CONVITE_GUARDIAO (id_usuario_guardiao);

    -- Um convite pendente ou aceito por par monitorado/guardião, com histórico dos encerrados.
    CREATE UNIQUE INDEX UN_CONVITE_GUARDIAO_ID_USUARIO_MONITORADO_ID_USUARIO_GUARDIAO
        ON dbo.TB_SY_CONVITE_GUARDIAO (id_usuario_monitorado, id_usuario_guardiao)
        WHERE st_convite IN ('P', 'A') AND id_usuario_guardiao IS NOT NULL;

    -- Registrar dispositivos associados ao usuário, plataforma, token de notificação e atividade.
    CREATE TABLE dbo.TB_SY_DISPOSITIVO
    (
        id_dispositivo INT IDENTITY(1,1) NOT NULL,
        tp_plataforma CHAR(1) NOT NULL,
        ds_modelo VARCHAR(100) NOT NULL,
        ds_versao_so VARCHAR(100) NOT NULL,
        ds_versao_app VARCHAR(30) NULL,
        ds_token_push VARCHAR(200) MASKED WITH (FUNCTION = 'default()') NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_DISPOSITIVO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        dt_ultimo_acesso DATETIME2 NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_DISPOSITIVO_FL_ATIVO DEFAULT (1),
        id_usuario INT NOT NULL,
        CONSTRAINT PK_DISPOSITIVO PRIMARY KEY (id_dispositivo),
        CONSTRAINT FK_USUARIO_DISPOSITIVO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_DISPOSITIVO_TP_PLATAFORMA
            CHECK (tp_plataforma COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'I'))
    );

    CREATE INDEX IX_DISPOSITIVO_ID_USUARIO
        ON dbo.TB_SY_DISPOSITIVO (id_usuario);

    -- Token de notificação único entre dispositivos ativos.
    CREATE UNIQUE INDEX UN_DISPOSITIVO_DS_TOKEN_PUSH
        ON dbo.TB_SY_DISPOSITIVO (ds_token_push)
        WHERE fl_ativo = 1;

    -- Registrar compromissos pessoais, com nome e descrição cifrados, período e indicação de conclusão.
    CREATE TABLE dbo.TB_SY_EVENTO
    (
        id_evento INT IDENTITY(1,1) NOT NULL,
        nm_evento VARBINARY(MAX) NOT NULL,
        ds_evento VARBINARY(MAX) NOT NULL,
        dt_inicio DATETIME2 NOT NULL,
        dt_fim DATETIME2 NOT NULL,
        fl_concluido BIT NOT NULL CONSTRAINT DF_EVENTO_FL_CONCLUIDO DEFAULT (0),
        id_usuario INT NOT NULL,
        CONSTRAINT PK_EVENTO PRIMARY KEY (id_evento),
        CONSTRAINT FK_USUARIO_EVENTO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_EVENTO_DT_FIM
            CHECK (dt_fim >= dt_inicio)
    );

    CREATE INDEX IX_EVENTO_ID_USUARIO_DT_INICIO
        ON dbo.TB_SY_EVENTO (id_usuario, dt_inicio);

    -- Auditar eventos de autenticação, sucesso ou falha, data e endereço IP, inclusive tentativas sem usuário identificado.
    CREATE TABLE dbo.TB_SY_LOG_ACESSO
    (
        id_log_acesso INT IDENTITY(1,1) NOT NULL,
        tp_evento CHAR(1) NOT NULL,
        fl_sucesso BIT NOT NULL,
        dt_evento DATETIME2 NOT NULL CONSTRAINT DF_LOG_ACESSO_DT_EVENTO DEFAULT (SYSUTCDATETIME()),
        ds_ip VARCHAR(45) MASKED WITH (FUNCTION = 'default()') NULL,
        id_usuario INT NULL,
        CONSTRAINT PK_LOG_ACESSO PRIMARY KEY (id_log_acesso),
        CONSTRAINT FK_USUARIO_LOG_ACESSO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_LOG_ACESSO_TP_EVENTO
            CHECK (tp_evento COLLATE Latin1_General_100_BIN2_UTF8 IN ('L', 'O', 'T', 'R', 'P', 'E'))
    );

    CREATE INDEX IX_LOG_ACESSO_ID_USUARIO_DT_EVENTO
        ON dbo.TB_SY_LOG_ACESSO (id_usuario, dt_evento);

    -- Guardar memórias pessoais do usuário, com título e conteúdo cifrados e data da lembrança.
    CREATE TABLE dbo.TB_SY_MEMORIA_AFETIVA
    (
        id_memoria INT IDENTITY(1,1) NOT NULL,
        nm_titulo VARBINARY(MAX) NOT NULL,
        ds_memoria VARBINARY(MAX) NOT NULL,
        dt_memoria DATE NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_MEMORIA_AFETIVA_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        CONSTRAINT PK_MEMORIA_AFETIVA PRIMARY KEY (id_memoria),
        CONSTRAINT FK_USUARIO_MEMORIA_AFETIVA FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario)
    );

    CREATE INDEX IX_MEMORIA_AFETIVA_ID_USUARIO_DT_MEMORIA
        ON dbo.TB_SY_MEMORIA_AFETIVA (id_usuario, dt_memoria);

    -- Registrar nível de estresse, descrição cifrada e data para acompanhamento emocional do usuário.
    CREATE TABLE dbo.TB_SY_MNT_ESTRESSE
    (
        id_estresse INT IDENTITY(1,1) NOT NULL,
        nr_nivel INT NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_MNT_ESTRESSE_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        ds_estresse VARBINARY(MAX) NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_MNT_ESTRESSE PRIMARY KEY (id_estresse),
        CONSTRAINT FK_USUARIO_MNT_ESTRESSE FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_MNT_ESTRESSE_NR_NIVEL
            CHECK (nr_nivel BETWEEN 1 AND 5)
    );

    CREATE INDEX IX_MNT_ESTRESSE_ID_USUARIO_DT_REGISTRO
        ON dbo.TB_SY_MNT_ESTRESSE (id_usuario, dt_registro);

    -- Registrar períodos de sono, despertares, qualidade e observações cifradas do usuário.
    -- A aplicação verifica a sobreposição de períodos de sono do mesmo usuário;
    -- o banco impede apenas dois períodos com o mesmo início.
    CREATE TABLE dbo.TB_SY_MNT_SONO
    (
        id_sono INT IDENTITY(1,1) NOT NULL,
        dt_inicio DATETIME2 NOT NULL,
        dt_fim DATETIME2 NOT NULL,
        nr_despertares INT NOT NULL,
        nr_qualidade INT NOT NULL,
        ds_sono VARBINARY(MAX) NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_MNT_SONO PRIMARY KEY (id_sono),
        CONSTRAINT FK_USUARIO_MNT_SONO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT UN_MNT_SONO_ID_USUARIO_DT_INICIO UNIQUE (id_usuario, dt_inicio),
        CONSTRAINT CK_MNT_SONO_DT_FIM
            CHECK (dt_fim > dt_inicio),
        CONSTRAINT CK_MNT_SONO_NR_DESPERTARES
            CHECK (nr_despertares >= 0),
        CONSTRAINT CK_MNT_SONO_NR_QUALIDADE
            CHECK (nr_qualidade BETWEEN 1 AND 5)
    );

    -- Registrar créditos e débitos imutáveis; o saldo é calculado pela diferença entre os movimentos.
    -- A unicidade (id_movimentacao_pontos, id_usuario) existe para as FKs compostas de missão e conquista.
    CREATE TABLE dbo.TB_SY_MOVIMENTACAO_PONTOS
    (
        id_movimentacao_pontos INT IDENTITY(1,1) NOT NULL,
        nr_pontos INT NOT NULL,
        tp_movimentacao CHAR(1) NOT NULL,
        tp_origem CHAR(1) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_MOVIMENTACAO_PONTOS_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        CONSTRAINT PK_MOVIMENTACAO_PONTOS PRIMARY KEY (id_movimentacao_pontos),
        CONSTRAINT FK_USUARIO_MOVIMENTACAO_PONTOS FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT UN_MOVIMENTACAO_PONTOS_ID_MOVIMENTACAO_PONTOS_ID_USUARIO UNIQUE (id_movimentacao_pontos, id_usuario),
        CONSTRAINT CK_MOVIMENTACAO_PONTOS_NR_PONTOS
            CHECK (nr_pontos > 0),
        CONSTRAINT CK_MOVIMENTACAO_PONTOS_TP_MOVIMENTACAO
            CHECK (tp_movimentacao COLLATE Latin1_General_100_BIN2_UTF8 IN ('C', 'D')),
        CONSTRAINT CK_MOVIMENTACAO_PONTOS_TP_ORIGEM
            CHECK (
                tp_origem COLLATE Latin1_General_100_BIN2_UTF8 = 'A'
                OR tp_origem COLLATE Latin1_General_100_BIN2_UTF8 = 'R'
                   AND tp_movimentacao COLLATE Latin1_General_100_BIN2_UTF8 = 'D'
                OR tp_origem COLLATE Latin1_General_100_BIN2_UTF8 IN ('M', 'Q', 'S')
                   AND tp_movimentacao COLLATE Latin1_General_100_BIN2_UTF8 = 'C'
            )
    );

    CREATE INDEX IX_MOVIMENTACAO_PONTOS_ID_USUARIO_DT_REGISTRO
        ON dbo.TB_SY_MOVIMENTACAO_PONTOS (id_usuario, dt_registro);

    -- Manter a sequência atual e o maior número de dias de atividade do usuário.
    CREATE TABLE dbo.TB_SY_SEQUENCIA
    (
        id_sequencia INT IDENTITY(1,1) NOT NULL,
        nr_sequencia_atual INT NOT NULL CONSTRAINT DF_SEQUENCIA_NR_SEQUENCIA_ATUAL DEFAULT (0),
        nr_maior_sequencia INT NOT NULL CONSTRAINT DF_SEQUENCIA_NR_MAIOR_SEQUENCIA DEFAULT (0),
        dt_ultima_atividade DATETIME2 NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_SEQUENCIA PRIMARY KEY (id_sequencia),
        CONSTRAINT FK_USUARIO_SEQUENCIA FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT UN_SEQUENCIA_FK_ID_USUARIO UNIQUE (id_usuario),
        CONSTRAINT CK_SEQUENCIA_NR_SEQUENCIA_ATUAL
            CHECK (nr_sequencia_atual >= 0),
        CONSTRAINT CK_SEQUENCIA_NR_MAIOR_SEQUENCIA
            CHECK (nr_maior_sequencia >= nr_sequencia_atual)
    );

    -- Registrar o vínculo entre usuário e plano e o ciclo da assinatura, cuja cobrança ocorre pela loja de aplicativos.
    CREATE TABLE dbo.TB_SY_ASSINATURA
    (
        id_assinatura INT IDENTITY(1,1) NOT NULL,
        st_assinatura CHAR(1) NOT NULL CONSTRAINT DF_ASSINATURA_ST_ASSINATURA DEFAULT ('P'),
        dt_inicio DATETIME2 NOT NULL,
        dt_expiracao DATETIME2 NULL,
        dt_cancelamento DATETIME2 NULL,
        fl_renovacao_automatica BIT NOT NULL,
        id_plano INT NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_ASSINATURA PRIMARY KEY (id_assinatura),
        CONSTRAINT FK_PLANO_ASSINATURA FOREIGN KEY (id_plano)
            REFERENCES dbo.TB_SY_PLANO (id_plano),
        CONSTRAINT FK_USUARIO_ASSINATURA FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_ASSINATURA_ST_ASSINATURA
            CHECK (st_assinatura COLLATE Latin1_General_100_BIN2_UTF8 IN ('P', 'A', 'G', 'C', 'E', 'R')),
        CONSTRAINT CK_ASSINATURA_DT_EXPIRACAO
            CHECK (dt_expiracao IS NULL OR dt_expiracao > dt_inicio),
        CONSTRAINT CK_ASSINATURA_DT_CANCELAMENTO
            CHECK (
                (dt_cancelamento IS NULL OR dt_cancelamento >= dt_inicio)
                AND (st_assinatura <> 'C' OR dt_cancelamento IS NOT NULL)
                AND (st_assinatura NOT IN ('P', 'A', 'G') OR dt_cancelamento IS NULL)
            )
    );

    CREATE INDEX IX_ASSINATURA_ID_USUARIO
        ON dbo.TB_SY_ASSINATURA (id_usuario);

    CREATE INDEX IX_ASSINATURA_ID_PLANO
        ON dbo.TB_SY_ASSINATURA (id_plano);

    -- Uma assinatura em aberto por usuário, com histórico de encerradas.
    CREATE UNIQUE INDEX UN_ASSINATURA_FK_ID_USUARIO
        ON dbo.TB_SY_ASSINATURA (id_usuario)
        WHERE st_assinatura IN ('P', 'A', 'G', 'C');

    -- Catalogar áudios de relaxamento com objetivo, tipo, frequências, duração e link de acesso.
    CREATE TABLE dbo.TB_SY_AUDIO_RELAXAMENTO
    (
        id_audio INT IDENTITY(1,1) NOT NULL,
        nm_audio VARCHAR(100) NOT NULL,
        ds_audio VARCHAR(255) NOT NULL,
        tp_audio VARCHAR(30) NOT NULL,
        ds_objetivo VARCHAR(100) NOT NULL,
        nr_frequencia_hz DECIMAL(10,2) NOT NULL,
        nr_frequencia_secundaria_hz DECIMAL(10,2) NULL,
        nr_duracao_segundos INT NOT NULL,
        fl_ativo BIT NOT NULL CONSTRAINT DF_AUDIO_RELAXAMENTO_FL_ATIVO DEFAULT (1),
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_AUDIO_RELAXAMENTO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_link INT NOT NULL,
        CONSTRAINT PK_AUDIO_RELAXAMENTO PRIMARY KEY (id_audio),
        CONSTRAINT FK_LINK_AUDIO_RELAXAMENTO FOREIGN KEY (id_link)
            REFERENCES dbo.TB_SY_LINK (id_link),
        CONSTRAINT CK_AUDIO_RELAXAMENTO_TP_AUDIO
            CHECK (tp_audio COLLATE Latin1_General_100_BIN2_UTF8 IN ('BINAURAL', 'ISOCRONICO', 'RUIDO', 'NATUREZA', 'MUSICA')),
        CONSTRAINT CK_AUDIO_RELAXAMENTO_NR_FREQUENCIA_HZ
            CHECK (nr_frequencia_hz > 0),
        CONSTRAINT CK_AUDIO_RELAXAMENTO_NR_FREQUENCIA_SECUNDARIA_HZ
            CHECK (
                tp_audio = 'BINAURAL' AND nr_frequencia_secundaria_hz IS NOT NULL
                    AND nr_frequencia_secundaria_hz > 0
                OR tp_audio <> 'BINAURAL' AND nr_frequencia_secundaria_hz IS NULL
            ),
        CONSTRAINT CK_AUDIO_RELAXAMENTO_NR_DURACAO_SEGUNDOS
            CHECK (nr_duracao_segundos > 0)
    );

    CREATE INDEX IX_AUDIO_RELAXAMENTO_ID_LINK
        ON dbo.TB_SY_AUDIO_RELAXAMENTO (id_link);

    -- Relacionar missões e categorias, permitindo múltiplas categorias por missão.
    CREATE TABLE dbo.TB_SY_A_CATEGORIA_MISSAO
    (
        id_categoria INT NOT NULL,
        id_missao INT NOT NULL,
        CONSTRAINT PK_A_CATEGORIA_MISSAO PRIMARY KEY (id_categoria, id_missao),
        CONSTRAINT PF_CATEGORIA_MISSAO_A_CATEGORIA_MISSAO FOREIGN KEY (id_categoria)
            REFERENCES dbo.TB_SY_CATEGORIA_MISSAO (id_categoria),
        CONSTRAINT PF_MISSAO_A_CATEGORIA_MISSAO FOREIGN KEY (id_missao)
            REFERENCES dbo.TB_SY_MISSAO (id_missao)
    );

    CREATE INDEX IX_A_CATEGORIA_MISSAO_ID_MISSAO
        ON dbo.TB_SY_A_CATEGORIA_MISSAO (id_missao);

    -- Registrar os mundos desbloqueados por cada usuário e a data do desbloqueio.
    CREATE TABLE dbo.TB_SY_A_USUARIO_MUNDO
    (
        dt_desbloqueio DATETIME2 NOT NULL CONSTRAINT DF_A_USUARIO_MUNDO_DT_DESBLOQUEIO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        id_mundo INT NOT NULL,
        CONSTRAINT PK_A_USUARIO_MUNDO PRIMARY KEY (id_usuario, id_mundo),
        CONSTRAINT PF_USUARIO_A_USUARIO_MUNDO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT PF_MUNDO_A_USUARIO_MUNDO FOREIGN KEY (id_mundo)
            REFERENCES dbo.TB_SY_MUNDO (id_mundo)
    );

    CREATE INDEX IX_A_USUARIO_MUNDO_ID_MUNDO
        ON dbo.TB_SY_A_USUARIO_MUNDO (id_mundo);

    -- Armazenar relatos do feed anônimo, com categoria, autor interno, conteúdo e estado de publicação.
    -- A identificação interna do autor é usada pela moderação. O feed é exibido de forma anônima.
    CREATE TABLE dbo.TB_SY_PUBLICACAO
    (
        id_publicacao INT IDENTITY(1,1) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_PUBLICACAO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        st_publicacao CHAR(1) NOT NULL,
        dt_edicao DATETIME2 NULL,
        ds_conteudo VARCHAR(MAX) NOT NULL,
        id_usuario INT NOT NULL,
        id_categoria INT NOT NULL,
        CONSTRAINT PK_PUBLICACAO PRIMARY KEY (id_publicacao),
        CONSTRAINT FK_USUARIO_PUBLICACAO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_CATEGORIA_PUBLICACAO_PUBLICACAO FOREIGN KEY (id_categoria)
            REFERENCES dbo.TB_SY_CATEGORIA_PUBLICACAO (id_categoria),
        CONSTRAINT CK_PUBLICACAO_ST_PUBLICACAO
            CHECK (st_publicacao COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'R', 'X', 'M')),
        CONSTRAINT CK_PUBLICACAO_DT_EDICAO
            CHECK (dt_edicao IS NULL OR dt_edicao >= dt_registro),
        CONSTRAINT CK_PUBLICACAO_DS_CONTEUDO
            CHECK (LEN(REPLACE(REPLACE(REPLACE(ds_conteudo, CHAR(9), ' '), CHAR(10), ' '), CHAR(13), ' ')) > 0)
    );

    CREATE INDEX IX_PUBLICACAO_ID_USUARIO
        ON dbo.TB_SY_PUBLICACAO (id_usuario);

    CREATE INDEX IX_PUBLICACAO_ID_CATEGORIA_DT_REGISTRO
        ON dbo.TB_SY_PUBLICACAO (id_categoria, dt_registro);

    -- Registrar o consentimento do responsável legal e seu método de verificação, vinculado à versão do termo.
    -- O fluxo de consentimento verifica o tipo e a vigência do termo referenciado.
    CREATE TABLE dbo.TB_SY_CONSENTIMENTO_RESPONSAVEL
    (
        id_consentimento INT IDENTITY(1,1) NOT NULL,
        tp_metodo_verificacao CHAR(1) NOT NULL,
        dt_consentimento DATETIME2 NOT NULL CONSTRAINT DF_CONSENTIMENTO_RESPONSAVEL_DT_CONSENTIMENTO DEFAULT (SYSUTCDATETIME()),
        dt_revogacao DATETIME2 NULL,
        id_termo_versao INT NOT NULL,
        CONSTRAINT PK_CONSENTIMENTO_RESPONSAVEL PRIMARY KEY (id_consentimento),
        CONSTRAINT FK_TERMO_VERSAO_CONSENTIMENTO_RESPONSAVEL FOREIGN KEY (id_termo_versao)
            REFERENCES dbo.TB_SY_TERMO_VERSAO (id_termo_versao),
        CONSTRAINT CK_CONSENTIMENTO_RESPONSAVEL_TP_METODO_VERIFICACAO
            CHECK (tp_metodo_verificacao COLLATE Latin1_General_100_BIN2_UTF8 IN ('E', 'T', 'D', 'G')),
        CONSTRAINT CK_CONSENTIMENTO_RESPONSAVEL_DT_REVOGACAO
            CHECK (dt_revogacao IS NULL OR dt_revogacao >= dt_consentimento)
    );

    CREATE INDEX IX_CONSENTIMENTO_RESPONSAVEL_ID_TERMO_VERSAO
        ON dbo.TB_SY_CONSENTIMENTO_RESPONSAVEL (id_termo_versao);

    -- Registrar aceite e eventual revogação de uma versão de termo pelo próprio usuário.
    -- O aceite é vinculado à versão específica do termo.
    CREATE TABLE dbo.TB_SY_TERMO_LGPD
    (
        id_termo_lgpd INT IDENTITY(1,1) NOT NULL,
        dt_aceite DATETIME2 NOT NULL CONSTRAINT DF_TERMO_LGPD_DT_ACEITE DEFAULT (SYSUTCDATETIME()),
        dt_revogacao DATETIME2 NULL,
        id_termo_versao INT NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_TERMO_LGPD PRIMARY KEY (id_termo_lgpd),
        CONSTRAINT FK_TERMO_VERSAO_TERMO_LGPD FOREIGN KEY (id_termo_versao)
            REFERENCES dbo.TB_SY_TERMO_VERSAO (id_termo_versao),
        CONSTRAINT FK_USUARIO_TERMO_LGPD FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_TERMO_LGPD_DT_REVOGACAO
            CHECK (dt_revogacao IS NULL OR dt_revogacao >= dt_aceite)
    );

    CREATE INDEX IX_TERMO_LGPD_ID_USUARIO
        ON dbo.TB_SY_TERMO_LGPD (id_usuario);

    CREATE INDEX IX_TERMO_LGPD_ID_TERMO_VERSAO
        ON dbo.TB_SY_TERMO_LGPD (id_termo_versao);

    -- Um aceite não revogado por usuário e versão; aceites revogados ficam como histórico
    -- e o usuário pode aceitar de novo a mesma versão.
    CREATE UNIQUE INDEX UN_TERMO_LGPD_ID_USUARIO_ID_TERMO_VERSAO
        ON dbo.TB_SY_TERMO_LGPD (id_usuario, id_termo_versao)
        WHERE dt_revogacao IS NULL;

    -- Registrar o humor e a intensidade informados pelo usuário em cada momento.
    CREATE TABLE dbo.TB_SY_REGISTRO_HUMOR
    (
        id_registro_humor INT IDENTITY(1,1) NOT NULL,
        nr_intensidade INT NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_REGISTRO_HUMOR_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        id_humor INT NOT NULL,
        CONSTRAINT PK_REGISTRO_HUMOR PRIMARY KEY (id_registro_humor),
        CONSTRAINT FK_USUARIO_REGISTRO_HUMOR FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_HUMOR_REGISTRO_HUMOR FOREIGN KEY (id_humor)
            REFERENCES dbo.TB_SY_HUMOR (id_humor),
        CONSTRAINT CK_REGISTRO_HUMOR_NR_INTENSIDADE
            CHECK (nr_intensidade BETWEEN 1 AND 5)
    );

    CREATE INDEX IX_REGISTRO_HUMOR_ID_USUARIO_DT_REGISTRO
        ON dbo.TB_SY_REGISTRO_HUMOR (id_usuario, dt_registro);

    CREATE INDEX IX_REGISTRO_HUMOR_ID_HUMOR
        ON dbo.TB_SY_REGISTRO_HUMOR (id_humor);

    -- Registrar prêmios resgatados e preservar o custo em pontos praticado no momento do resgate.
    -- A aplicação valida o saldo e grava o resgate e o débito na mesma transação.
    CREATE TABLE dbo.TB_SY_RESGATE_PREMIO
    (
        id_resgate INT IDENTITY(1,1) NOT NULL,
        nr_pontos_gastos INT NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_RESGATE_PREMIO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        id_premio INT NOT NULL,
        CONSTRAINT PK_RESGATE_PREMIO PRIMARY KEY (id_resgate),
        CONSTRAINT FK_USUARIO_RESGATE_PREMIO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_PREMIO_RESGATE_PREMIO FOREIGN KEY (id_premio)
            REFERENCES dbo.TB_SY_PREMIO (id_premio),
        CONSTRAINT CK_RESGATE_PREMIO_NR_PONTOS_GASTOS
            CHECK (nr_pontos_gastos > 0)
    );

    CREATE INDEX IX_RESGATE_PREMIO_ID_USUARIO_DT_REGISTRO
        ON dbo.TB_SY_RESGATE_PREMIO (id_usuario, dt_registro);

    CREATE INDEX IX_RESGATE_PREMIO_ID_PREMIO
        ON dbo.TB_SY_RESGATE_PREMIO (id_premio);

    -- Auditar consultas realizadas pelo guardião aos dados autorizados do monitorado.
    CREATE TABLE dbo.TB_SY_LOG_ACESSO_GUARDIAO
    (
        id_log_acesso_guardiao INT IDENTITY(1,1) NOT NULL,
        tp_acesso CHAR(1) NOT NULL,
        dt_acesso DATETIME2 NOT NULL CONSTRAINT DF_LOG_ACESSO_GUARDIAO_DT_ACESSO DEFAULT (SYSUTCDATETIME()),
        id_convite INT NOT NULL,
        CONSTRAINT PK_LOG_ACESSO_GUARDIAO PRIMARY KEY (id_log_acesso_guardiao),
        CONSTRAINT FK_CONVITE_GUARDIAO_LOG_ACESSO_GUARDIAO FOREIGN KEY (id_convite)
            REFERENCES dbo.TB_SY_CONVITE_GUARDIAO (id_convite),
        CONSTRAINT CK_LOG_ACESSO_GUARDIAO_TP_ACESSO
            CHECK (tp_acesso COLLATE Latin1_General_100_BIN2_UTF8 IN ('H', 'E', 'S', 'G', 'V'))
    );

    CREATE INDEX IX_LOG_ACESSO_GUARDIAO_ID_CONVITE_DT_ACESSO
        ON dbo.TB_SY_LOG_ACESSO_GUARDIAO (id_convite, dt_acesso);

    -- Auditar alterações do indicador de conclusão de um evento, com origem e data.
    -- Origem: U = usuário, S = sistema.
    CREATE TABLE dbo.TB_SY_LOG_STATUS_EVENTO
    (
        id_log_status_evento INT IDENTITY(1,1) NOT NULL,
        fl_anterior BIT NULL,
        fl_novo BIT NOT NULL,
        dt_mudanca DATETIME2 NOT NULL CONSTRAINT DF_LOG_STATUS_EVENTO_DT_MUDANCA DEFAULT (SYSUTCDATETIME()),
        tp_origem CHAR(1) NOT NULL,
        id_evento INT NOT NULL,
        CONSTRAINT PK_LOG_STATUS_EVENTO PRIMARY KEY (id_log_status_evento),
        CONSTRAINT FK_EVENTO_LOG_STATUS_EVENTO FOREIGN KEY (id_evento)
            REFERENCES dbo.TB_SY_EVENTO (id_evento),
        CONSTRAINT CK_LOG_STATUS_EVENTO_FL_NOVO
            CHECK (fl_anterior IS NULL OR fl_anterior <> fl_novo),
        CONSTRAINT CK_LOG_STATUS_EVENTO_TP_ORIGEM
            CHECK (tp_origem COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'S'))
    );

    CREATE INDEX IX_LOG_STATUS_EVENTO_ID_EVENTO
        ON dbo.TB_SY_LOG_STATUS_EVENTO (id_evento);

    -- Registrar os anexos de uma memória afetiva, com nome cifrado e localização do arquivo privado.
    -- nm_arquivo guarda o nome cifrado. O arquivo privado é localizado pelo caminho armazenado.
    CREATE TABLE dbo.TB_SY_ARQUIVO_MEMORIA
    (
        id_arquivo INT IDENTITY(1,1) NOT NULL,
        nm_arquivo VARBINARY(MAX) NOT NULL,
        tp_arquivo CHAR(1) NOT NULL,
        ds_mime_type VARCHAR(100) NOT NULL,
        nr_tamanho_bytes BIGINT NOT NULL,
        ds_caminho_dir VARCHAR(255) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_ARQUIVO_MEMORIA_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        id_memoria INT NOT NULL,
        CONSTRAINT PK_ARQUIVO_MEMORIA PRIMARY KEY (id_arquivo),
        CONSTRAINT FK_MEMORIA_AFETIVA_ARQUIVO_MEMORIA FOREIGN KEY (id_memoria)
            REFERENCES dbo.TB_SY_MEMORIA_AFETIVA (id_memoria),
        CONSTRAINT UN_ARQUIVO_MEMORIA_DS_CAMINHO_DIR UNIQUE (ds_caminho_dir),
        CONSTRAINT CK_ARQUIVO_MEMORIA_TP_ARQUIVO
            CHECK (tp_arquivo COLLATE Latin1_General_100_BIN2_UTF8 IN ('I', 'A', 'V', 'D')),
        CONSTRAINT CK_ARQUIVO_MEMORIA_NR_TAMANHO_BYTES
            CHECK (nr_tamanho_bytes > 0)
    );

    CREATE INDEX IX_ARQUIVO_MEMORIA_ID_MEMORIA
        ON dbo.TB_SY_ARQUIVO_MEMORIA (id_memoria);

    -- Relacionar registros de estresse e seus gatilhos em uma associação de muitos para muitos.
    CREATE TABLE dbo.TB_SY_A_ESTRESSE_GATILHO
    (
        id_estresse INT NOT NULL,
        id_gatilho INT NOT NULL,
        CONSTRAINT PK_A_ESTRESSE_GATILHO PRIMARY KEY (id_estresse, id_gatilho),
        CONSTRAINT PF_MNT_ESTRESSE_A_ESTRESSE_GATILHO FOREIGN KEY (id_estresse)
            REFERENCES dbo.TB_SY_MNT_ESTRESSE (id_estresse),
        CONSTRAINT PF_GATILHO_A_ESTRESSE_GATILHO FOREIGN KEY (id_gatilho)
            REFERENCES dbo.TB_SY_GATILHO (id_gatilho)
    );

    CREATE INDEX IX_A_ESTRESSE_GATILHO_ID_GATILHO
        ON dbo.TB_SY_A_ESTRESSE_GATILHO (id_gatilho);

    -- Registrar cada conquista obtida por usuário e sua movimentação de pontos.
    -- A aplicação registra o desbloqueio e o crédito de pontos na mesma transação.
    -- A FK composta garante que a movimentação pertence ao mesmo usuário da conquista.
    CREATE TABLE dbo.TB_SY_A_USUARIO_CONQUISTA
    (
        dt_conquista DATETIME2 NOT NULL CONSTRAINT DF_A_USUARIO_CONQUISTA_DT_CONQUISTA DEFAULT (SYSUTCDATETIME()),
        id_usuario INT NOT NULL,
        id_conquista INT NOT NULL,
        id_movimentacao_pontos INT NOT NULL,
        CONSTRAINT PK_A_USUARIO_CONQUISTA PRIMARY KEY (id_usuario, id_conquista),
        CONSTRAINT PF_USUARIO_A_USUARIO_CONQUISTA FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT PF_CONQUISTA_A_USUARIO_CONQUISTA FOREIGN KEY (id_conquista)
            REFERENCES dbo.TB_SY_CONQUISTA (id_conquista),
        CONSTRAINT FK_MOVIMENTACAO_PONTOS_A_USUARIO_CONQUISTA FOREIGN KEY (id_movimentacao_pontos, id_usuario)
            REFERENCES dbo.TB_SY_MOVIMENTACAO_PONTOS (id_movimentacao_pontos, id_usuario),
        CONSTRAINT UN_A_USUARIO_CONQUISTA_FK_ID_MOVIMENTACAO_PONTOS UNIQUE (id_movimentacao_pontos)
    );

    CREATE INDEX IX_A_USUARIO_CONQUISTA_ID_CONQUISTA
        ON dbo.TB_SY_A_USUARIO_CONQUISTA (id_conquista);

    -- Registrar o acesso e a conclusão de cada missão por usuário, vinculando o crédito de pontos.
    -- Ao abrir a missão, data de conclusão e movimento ficam nulos.
    -- O crédito de pontos e a conclusão são gravados na mesma transação da aplicação.
    -- A FK composta garante que a movimentação pertence ao mesmo usuário da missão; com
    -- id_movimentacao_pontos nulo (missão aberta) ela não é avaliada.
    -- Cada missão é concluída uma única vez por usuário, garantido pela PK.
    CREATE TABLE dbo.TB_SY_A_USUARIO_MISSAO
    (
        id_usuario INT NOT NULL,
        id_missao INT NOT NULL,
        dt_acesso DATETIME2 NOT NULL CONSTRAINT DF_A_USUARIO_MISSAO_DT_ACESSO DEFAULT (SYSUTCDATETIME()),
        dt_conclusao DATETIME2 NULL,
        fl_concluido BIT NOT NULL CONSTRAINT DF_A_USUARIO_MISSAO_FL_CONCLUIDO DEFAULT (0),
        id_movimentacao_pontos INT NULL,
        CONSTRAINT PK_A_USUARIO_MISSAO PRIMARY KEY (id_usuario, id_missao),
        CONSTRAINT PF_USUARIO_A_USUARIO_MISSAO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT PF_MISSAO_A_USUARIO_MISSAO FOREIGN KEY (id_missao)
            REFERENCES dbo.TB_SY_MISSAO (id_missao),
        CONSTRAINT FK_MOVIMENTACAO_PONTOS_A_USUARIO_MISSAO FOREIGN KEY (id_movimentacao_pontos, id_usuario)
            REFERENCES dbo.TB_SY_MOVIMENTACAO_PONTOS (id_movimentacao_pontos, id_usuario),
        CONSTRAINT CK_A_USUARIO_MISSAO_DT_CONCLUSAO
            CHECK (
                fl_concluido = 0 AND dt_conclusao IS NULL
                    AND id_movimentacao_pontos IS NULL
                OR fl_concluido = 1 AND dt_conclusao IS NOT NULL
                    AND dt_conclusao >= dt_acesso
                    AND id_movimentacao_pontos IS NOT NULL
            )
    );

    CREATE INDEX IX_A_USUARIO_MISSAO_ID_MISSAO
        ON dbo.TB_SY_A_USUARIO_MISSAO (id_missao);

    -- Uma movimentação por conclusão, permitindo várias missões ainda abertas.
    CREATE UNIQUE INDEX UN_A_USUARIO_MISSAO_FK_ID_MOVIMENTACAO_PONTOS
        ON dbo.TB_SY_A_USUARIO_MISSAO (id_movimentacao_pontos)
        WHERE id_movimentacao_pontos IS NOT NULL;

    -- Registrar o histórico de mudanças do contador de sequência de atividade.
    CREATE TABLE dbo.TB_SY_LOG_STATUS_SEQUENCIA
    (
        id_log_status_sequencia INT IDENTITY(1,1) NOT NULL,
        nr_anterior INT NULL,
        nr_novo INT NOT NULL,
        dt_mudanca DATETIME2 NOT NULL CONSTRAINT DF_LOG_STATUS_SEQUENCIA_DT_MUDANCA DEFAULT (SYSUTCDATETIME()),
        id_sequencia INT NOT NULL,
        CONSTRAINT PK_LOG_STATUS_SEQUENCIA PRIMARY KEY (id_log_status_sequencia),
        CONSTRAINT FK_SEQUENCIA_LOG_STATUS_SEQUENCIA FOREIGN KEY (id_sequencia)
            REFERENCES dbo.TB_SY_SEQUENCIA (id_sequencia),
        CONSTRAINT CK_LOG_STATUS_SEQUENCIA_NR_ANTERIOR
            CHECK (nr_anterior IS NULL OR nr_anterior >= 0),
        CONSTRAINT CK_LOG_STATUS_SEQUENCIA_NR_NOVO
            CHECK (nr_novo >= 0 AND (nr_anterior IS NULL OR nr_anterior <> nr_novo))
    );

    CREATE INDEX IX_LOG_STATUS_SEQUENCIA_ID_SEQUENCIA
        ON dbo.TB_SY_LOG_STATUS_SEQUENCIA (id_sequencia);

    -- Manter o histórico das mudanças de estado de cada assinatura, com origem, motivo e data.
    CREATE TABLE dbo.TB_SY_LOG_STATUS_ASSINATURA
    (
        id_log_status_assinatura INT IDENTITY(1,1) NOT NULL,
        st_anterior CHAR(1) NULL,
        st_novo CHAR(1) NOT NULL,
        dt_mudanca DATETIME2 NOT NULL CONSTRAINT DF_LOG_STATUS_ASSINATURA_DT_MUDANCA DEFAULT (SYSUTCDATETIME()),
        tp_origem CHAR(1) NOT NULL,
        ds_motivo VARCHAR(50) NULL,
        id_assinatura INT NOT NULL,
        CONSTRAINT PK_LOG_STATUS_ASSINATURA PRIMARY KEY (id_log_status_assinatura),
        CONSTRAINT FK_ASSINATURA_LOG_STATUS_ASSINATURA FOREIGN KEY (id_assinatura)
            REFERENCES dbo.TB_SY_ASSINATURA (id_assinatura),
        CONSTRAINT CK_LOG_STATUS_ASSINATURA_ST_ANTERIOR
            CHECK (st_anterior COLLATE Latin1_General_100_BIN2_UTF8 IN ('P', 'A', 'G', 'C', 'E', 'R')),
        CONSTRAINT CK_LOG_STATUS_ASSINATURA_ST_NOVO
            CHECK (st_novo COLLATE Latin1_General_100_BIN2_UTF8 IN ('P', 'A', 'G', 'C', 'E', 'R') AND (st_anterior IS NULL OR st_anterior <> st_novo)),
        CONSTRAINT CK_LOG_STATUS_ASSINATURA_TP_ORIGEM
            CHECK (tp_origem COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'L', 'S', 'A'))
    );

    CREATE INDEX IX_LOG_STATUS_ASSINATURA_ID_ASSINATURA
        ON dbo.TB_SY_LOG_STATUS_ASSINATURA (id_assinatura);

    -- Registrar os eventos financeiros da assinatura: compra, renovação, falha e estorno.
    -- O valor tem duas casas decimais e comporta até 999,99.
    CREATE TABLE dbo.TB_SY_TRANSACAO_ASSINATURA
    (
        id_transacao INT IDENTITY(1,1) NOT NULL,
        tp_evento CHAR(1) NOT NULL,
        vl_transacao DECIMAL(5,2) NOT NULL,
        cd_moeda CHAR(3) NOT NULL,
        dt_transacao DATETIME2 NOT NULL CONSTRAINT DF_TRANSACAO_ASSINATURA_DT_TRANSACAO DEFAULT (SYSUTCDATETIME()),
        id_assinatura INT NOT NULL,
        CONSTRAINT PK_TRANSACAO_ASSINATURA PRIMARY KEY (id_transacao),
        CONSTRAINT FK_ASSINATURA_TRANSACAO_ASSINATURA FOREIGN KEY (id_assinatura)
            REFERENCES dbo.TB_SY_ASSINATURA (id_assinatura),
        CONSTRAINT CK_TRANSACAO_ASSINATURA_TP_EVENTO
            CHECK (tp_evento COLLATE Latin1_General_100_BIN2_UTF8 IN ('C', 'R', 'F', 'E')),
        CONSTRAINT CK_TRANSACAO_ASSINATURA_VL_TRANSACAO
            CHECK (vl_transacao >= 0),
        CONSTRAINT CK_TRANSACAO_ASSINATURA_CD_MOEDA
            CHECK (cd_moeda COLLATE Latin1_General_100_BIN2_UTF8 LIKE '[A-Z][A-Z][A-Z]')
    );

    CREATE INDEX IX_TRANSACAO_ASSINATURA_ID_ASSINATURA_DT_TRANSACAO
        ON dbo.TB_SY_TRANSACAO_ASSINATURA (id_assinatura, dt_transacao);

    -- Relacionar usuário e publicação, admitindo uma reação por par e a troca do tipo de reação.
    CREATE TABLE dbo.TB_SY_A_REACAO_PUBLICACAO
    (
        tp_reacao CHAR(1) NOT NULL,
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_A_REACAO_PUBLICACAO_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        fl_ativo BIT NOT NULL CONSTRAINT DF_A_REACAO_PUBLICACAO_FL_ATIVO DEFAULT (1),
        id_publicacao INT NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_A_REACAO_PUBLICACAO PRIMARY KEY (id_publicacao, id_usuario),
        CONSTRAINT PF_PUBLICACAO_A_REACAO_PUBLICACAO FOREIGN KEY (id_publicacao)
            REFERENCES dbo.TB_SY_PUBLICACAO (id_publicacao),
        CONSTRAINT PF_USUARIO_A_REACAO_PUBLICACAO FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_A_REACAO_PUBLICACAO_TP_REACAO
            CHECK (tp_reacao COLLATE Latin1_General_100_BIN2_UTF8 IN ('J', 'A'))
    );

    CREATE INDEX IX_A_REACAO_PUBLICACAO_ID_USUARIO
        ON dbo.TB_SY_A_REACAO_PUBLICACAO (id_usuario);

    -- Registrar denúncias de publicações, motivo, denunciante e evolução da análise de moderação.
    -- A aplicação verifica se o denunciante é diferente do autor da publicação.
    CREATE TABLE dbo.TB_SY_DENUNCIA
    (
        id_denuncia INT IDENTITY(1,1) NOT NULL,
        tp_motivo CHAR(1) NOT NULL,
        ds_denuncia VARCHAR(500) NULL,
        st_denuncia CHAR(1) NOT NULL CONSTRAINT DF_DENUNCIA_ST_DENUNCIA DEFAULT ('A'),
        dt_registro DATETIME2 NOT NULL CONSTRAINT DF_DENUNCIA_DT_REGISTRO DEFAULT (SYSUTCDATETIME()),
        dt_resolucao DATETIME2 NULL,
        id_usuario_denunciante INT NOT NULL,
        id_publicacao INT NOT NULL,
        CONSTRAINT PK_DENUNCIA PRIMARY KEY (id_denuncia),
        CONSTRAINT FK_USUARIO_DENUNCIA FOREIGN KEY (id_usuario_denunciante)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_PUBLICACAO_DENUNCIA FOREIGN KEY (id_publicacao)
            REFERENCES dbo.TB_SY_PUBLICACAO (id_publicacao),
        CONSTRAINT UN_DENUNCIA_ID_USUARIO_DENUNCIANTE_ID_PUBLICACAO UNIQUE (id_usuario_denunciante, id_publicacao),
        CONSTRAINT CK_DENUNCIA_TP_MOTIVO
            CHECK (tp_motivo COLLATE Latin1_General_100_BIN2_UTF8 IN ('R', 'A', 'D', 'X', 'I', 'S', 'F', 'O')),
        CONSTRAINT CK_DENUNCIA_DS_DENUNCIA
            CHECK (
                tp_motivo <> 'O'
                OR ds_denuncia IS NOT NULL
                   AND LEN(REPLACE(REPLACE(REPLACE(ds_denuncia, CHAR(9), ' '),
                                           CHAR(10), ' '), CHAR(13), ' ')) > 0
            ),
        CONSTRAINT CK_DENUNCIA_ST_DENUNCIA
            CHECK (st_denuncia COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'E', 'P', 'I')),
        CONSTRAINT CK_DENUNCIA_DT_RESOLUCAO
            CHECK (
                st_denuncia IN ('A', 'E') AND dt_resolucao IS NULL
                OR st_denuncia IN ('P', 'I') AND dt_resolucao IS NOT NULL
                   AND dt_resolucao >= dt_registro
            )
    );

    CREATE INDEX IX_DENUNCIA_ID_PUBLICACAO
        ON dbo.TB_SY_DENUNCIA (id_publicacao);

    -- Auditar alterações do estado de uma publicação, registrando origem, motivo e data.
    CREATE TABLE dbo.TB_SY_LOG_STATUS_PUBLICACAO
    (
        id_log_status_publicacao INT IDENTITY(1,1) NOT NULL,
        st_anterior CHAR(1) NULL,
        st_novo CHAR(1) NOT NULL,
        dt_mudanca DATETIME2 NOT NULL CONSTRAINT DF_LOG_STATUS_PUBLICACAO_DT_MUDANCA DEFAULT (SYSUTCDATETIME()),
        tp_origem CHAR(1) NOT NULL,
        ds_motivo VARCHAR(50) NULL,
        id_publicacao INT NOT NULL,
        CONSTRAINT PK_LOG_STATUS_PUBLICACAO PRIMARY KEY (id_log_status_publicacao),
        CONSTRAINT FK_PUBLICACAO_LOG_STATUS_PUBLICACAO FOREIGN KEY (id_publicacao)
            REFERENCES dbo.TB_SY_PUBLICACAO (id_publicacao),
        CONSTRAINT CK_LOG_STATUS_PUBLICACAO_ST_ANTERIOR
            CHECK (st_anterior COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'R', 'X', 'M')),
        CONSTRAINT CK_LOG_STATUS_PUBLICACAO_ST_NOVO
            CHECK (st_novo COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'R', 'X', 'M') AND (st_anterior IS NULL OR st_anterior <> st_novo)),
        CONSTRAINT CK_LOG_STATUS_PUBLICACAO_TP_ORIGEM
            CHECK (tp_origem COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'M', 'S'))
    );

    CREATE INDEX IX_LOG_STATUS_PUBLICACAO_ID_PUBLICACAO
        ON dbo.TB_SY_LOG_STATUS_PUBLICACAO (id_publicacao);

    -- Relacionar responsável legal e usuário menor ao consentimento concedido, registrando a vigência e o estado do vínculo.
    CREATE TABLE dbo.TB_SY_VINCULO_RESPONSAVEL
    (
        id_vinculo INT IDENTITY(1,1) NOT NULL,
        st_vinculo CHAR(1) NOT NULL CONSTRAINT DF_VINCULO_RESPONSAVEL_ST_VINCULO DEFAULT ('P'),
        dt_inicio DATETIME2 NOT NULL,
        dt_fim DATETIME2 NULL,
        id_responsavel INT NOT NULL,
        id_usuario INT NOT NULL,
        id_consentimento INT NOT NULL,
        CONSTRAINT PK_VINCULO_RESPONSAVEL PRIMARY KEY (id_vinculo),
        CONSTRAINT FK_RESPONSAVEL_VINCULO_RESPONSAVEL FOREIGN KEY (id_responsavel)
            REFERENCES dbo.TB_SY_RESPONSAVEL (id_responsavel),
        CONSTRAINT FK_USUARIO_VINCULO_RESPONSAVEL FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_CONSENTIMENTO_RESPONSAVEL_VINCULO_RESPONSAVEL FOREIGN KEY (id_consentimento)
            REFERENCES dbo.TB_SY_CONSENTIMENTO_RESPONSAVEL (id_consentimento),
        CONSTRAINT UN_VINCULO_RESPONSAVEL_FK_ID_CONSENTIMENTO UNIQUE (id_consentimento),
        CONSTRAINT CK_VINCULO_RESPONSAVEL_ST_VINCULO
            CHECK (st_vinculo COLLATE Latin1_General_100_BIN2_UTF8 IN ('P', 'A', 'R', 'E')),
        CONSTRAINT CK_VINCULO_RESPONSAVEL_DT_FIM
            CHECK (
                st_vinculo IN ('P', 'A') AND dt_fim IS NULL
                OR st_vinculo IN ('R', 'E') AND dt_fim IS NOT NULL AND dt_fim >= dt_inicio
            )
    );

    CREATE INDEX IX_VINCULO_RESPONSAVEL_ID_RESPONSAVEL
        ON dbo.TB_SY_VINCULO_RESPONSAVEL (id_responsavel);

    CREATE INDEX IX_VINCULO_RESPONSAVEL_ID_USUARIO
        ON dbo.TB_SY_VINCULO_RESPONSAVEL (id_usuario);

    -- Um vínculo pendente ou ativo por par responsável/usuário, com histórico dos encerrados.
    CREATE UNIQUE INDEX UN_VINCULO_RESPONSAVEL_ID_RESPONSAVEL_ID_USUARIO
        ON dbo.TB_SY_VINCULO_RESPONSAVEL (id_responsavel, id_usuario)
        WHERE st_vinculo IN ('P', 'A');

    -- Registrar o bloqueio de outro usuário a partir do feed, sua denúncia de referência e período de vigência.
    CREATE TABLE dbo.TB_SY_BLOQUEIO_USUARIO
    (
        id_bloqueio INT IDENTITY(1,1) NOT NULL,
        dt_bloqueio DATETIME2 NOT NULL CONSTRAINT DF_BLOQUEIO_USUARIO_DT_BLOQUEIO DEFAULT (SYSUTCDATETIME()),
        dt_fim DATETIME2 NULL,
        id_usuario_bloqueado INT NOT NULL,
        id_denuncia INT NOT NULL,
        id_usuario INT NOT NULL,
        CONSTRAINT PK_BLOQUEIO_USUARIO PRIMARY KEY (id_bloqueio),
        CONSTRAINT FK_USUARIO_BLOQUEIO_USUARIO_BLOQUEADO FOREIGN KEY (id_usuario_bloqueado)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT FK_DENUNCIA_BLOQUEIO_USUARIO FOREIGN KEY (id_denuncia)
            REFERENCES dbo.TB_SY_DENUNCIA (id_denuncia),
        CONSTRAINT FK_USUARIO_BLOQUEIO_USUARIO_BLOQUEADOR FOREIGN KEY (id_usuario)
            REFERENCES dbo.TB_SY_USUARIO (id_usuario),
        CONSTRAINT CK_BLOQUEIO_USUARIO_DT_FIM
            CHECK (dt_fim IS NULL OR dt_fim >= dt_bloqueio),
        CONSTRAINT CK_BLOQUEIO_USUARIO_ID_USUARIO_BLOQUEADO
            CHECK (id_usuario_bloqueado <> id_usuario)
    );

    CREATE INDEX IX_BLOQUEIO_USUARIO_ID_USUARIO
        ON dbo.TB_SY_BLOQUEIO_USUARIO (id_usuario);

    CREATE INDEX IX_BLOQUEIO_USUARIO_ID_USUARIO_BLOQUEADO
        ON dbo.TB_SY_BLOQUEIO_USUARIO (id_usuario_bloqueado);

    CREATE INDEX IX_BLOQUEIO_USUARIO_ID_DENUNCIA
        ON dbo.TB_SY_BLOQUEIO_USUARIO (id_denuncia);

    -- Um bloqueio vigente por par bloqueador/bloqueado, com histórico dos encerrados.
    CREATE UNIQUE INDEX UN_BLOQUEIO_USUARIO_ID_USUARIO_ID_USUARIO_BLOQUEADO
        ON dbo.TB_SY_BLOQUEIO_USUARIO (id_usuario, id_usuario_bloqueado)
        WHERE dt_fim IS NULL;

    -- Auditar alterações do estado de uma denúncia e a origem e data da mudança.
    -- Origem: U = usuário (denunciante), M = moderador, S = sistema (moderação automática).
    CREATE TABLE dbo.TB_SY_LOG_STATUS_DENUNCIA
    (
        id_log_status_denuncia INT IDENTITY(1,1) NOT NULL,
        st_anterior CHAR(1) NULL,
        st_novo CHAR(1) NOT NULL,
        dt_mudanca DATETIME2 NOT NULL CONSTRAINT DF_LOG_STATUS_DENUNCIA_DT_MUDANCA DEFAULT (SYSUTCDATETIME()),
        tp_origem CHAR(1) NOT NULL,
        id_denuncia INT NOT NULL,
        CONSTRAINT PK_LOG_STATUS_DENUNCIA PRIMARY KEY (id_log_status_denuncia),
        CONSTRAINT FK_DENUNCIA_LOG_STATUS_DENUNCIA FOREIGN KEY (id_denuncia)
            REFERENCES dbo.TB_SY_DENUNCIA (id_denuncia),
        CONSTRAINT CK_LOG_STATUS_DENUNCIA_ST_ANTERIOR
            CHECK (st_anterior COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'E', 'P', 'I')),
        CONSTRAINT CK_LOG_STATUS_DENUNCIA_ST_NOVO
            CHECK (st_novo COLLATE Latin1_General_100_BIN2_UTF8 IN ('A', 'E', 'P', 'I') AND (st_anterior IS NULL OR st_anterior <> st_novo)),
        CONSTRAINT CK_LOG_STATUS_DENUNCIA_TP_ORIGEM
            CHECK (tp_origem COLLATE Latin1_General_100_BIN2_UTF8 IN ('U', 'M', 'S'))
    );

    CREATE INDEX IX_LOG_STATUS_DENUNCIA_ID_DENUNCIA
        ON dbo.TB_SY_LOG_STATUS_DENUNCIA (id_denuncia);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- Papéis de acesso: adicione os usuários do banco a um deles.
-- papel_app lê sem máscara (UNMASK); papel_moderador lê dados pessoais mascarados.
IF DB_NAME() <> N'DB_I_SEE_YOU'
    THROW 50000, N'Execute o script no banco DB_I_SEE_YOU.', 1;

IF OBJECT_ID(N'dbo.TB_SY_USUARIO', N'U') IS NULL
    THROW 50004, N'As tabelas não foram criadas; os papéis não serão configurados.', 1;

IF DATABASE_PRINCIPAL_ID(N'papel_app') IS NULL
    CREATE ROLE [papel_app];

IF DATABASE_PRINCIPAL_ID(N'papel_moderador') IS NULL
    CREATE ROLE [papel_moderador];

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [papel_app];
GRANT UNMASK TO [papel_app];

-- Ledger de pontos e logs: somente inclusão e leitura para a aplicação.
DENY UPDATE, DELETE ON dbo.TB_SY_MOVIMENTACAO_PONTOS TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_ACESSO TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_ACESSO_GUARDIAO TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_STATUS_EVENTO TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_STATUS_SEQUENCIA TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_STATUS_ASSINATURA TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_STATUS_PUBLICACAO TO [papel_app];
DENY UPDATE, DELETE ON dbo.TB_SY_LOG_STATUS_DENUNCIA TO [papel_app];

-- Moderação: publicações, denúncias e seus logs; usuário apenas com dados mascarados.
GRANT SELECT ON dbo.TB_SY_PUBLICACAO TO [papel_moderador];
GRANT SELECT ON dbo.TB_SY_CATEGORIA_PUBLICACAO TO [papel_moderador];
GRANT SELECT ON dbo.TB_SY_DENUNCIA TO [papel_moderador];
GRANT SELECT, INSERT ON dbo.TB_SY_LOG_STATUS_PUBLICACAO TO [papel_moderador];
GRANT SELECT, INSERT ON dbo.TB_SY_LOG_STATUS_DENUNCIA TO [papel_moderador];
GRANT UPDATE ON dbo.TB_SY_PUBLICACAO (st_publicacao) TO [papel_moderador];
GRANT UPDATE ON dbo.TB_SY_DENUNCIA (st_denuncia, dt_resolucao) TO [papel_moderador];
GRANT SELECT ON dbo.TB_SY_USUARIO (id_usuario, nm_completo, nm_exibicao, ds_email, tp_perfil, dt_registro, dt_exclusao, dt_nascimento) TO [papel_moderador];
GO
