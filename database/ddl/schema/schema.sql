/*
    Projeto: ISEEYOU
    Arquivo: 01_create_tables.sql
    Objetivo: criar as tabelas, chaves primárias, chaves estrangeiras e restrições básicas.
    Banco alvo: SQL Server

    Observações de modelagem:
    - IDs principais foram definidos como INT IDENTITY para facilitar o uso no SQL Server.
    - Tabelas associativas usam chave primária composta, sem ID artificial.
    - Campos de data/hora usam DATETIME e DEFAULT GETDATE() quando representam criação/registro.
    - Regras que dependem de consulta em outra tabela ficaram em triggers, pois CHECK não consulta outra tabela no SQL Server.
*/

CREATE TABLE dbo.TB_SY_ENDERECO (
    id_endereco     INT IDENTITY(1,1) NOT NULL,
    nr_cep          CHAR(8)           NOT NULL,
    ds_logradouro   VARCHAR(100)      NOT NULL,
    nr_numero       VARCHAR(10)       NOT NULL,
    ds_complemento  VARCHAR(100)      NULL,
    nm_bairro       VARCHAR(60)       NOT NULL,
    nm_cidade       VARCHAR(60)       NOT NULL,
    sg_estado       CHAR(2)           NOT NULL,
    CONSTRAINT PK_TB_SY_ENDERECO PRIMARY KEY CLUSTERED (id_endereco),
    CONSTRAINT CK_TB_SY_ENDERECO_NR_CEP_NUMERICO CHECK (nr_cep NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_TB_SY_ENDERECO_SG_ESTADO CHECK (sg_estado IN (
        'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG',
        'PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'
    ))
);
GO

CREATE TABLE dbo.TB_SY_PLANO (
    id_plano    INT IDENTITY(1,1) NOT NULL,
    nm_plano    VARCHAR(10)       NOT NULL,
    ds_plano    VARCHAR(100)      NOT NULL,
    CONSTRAINT PK_TB_SY_PLANO PRIMARY KEY CLUSTERED (id_plano),
    CONSTRAINT UQ_TB_SY_PLANO_NM_PLANO UNIQUE (nm_plano)
);
GO

CREATE TABLE dbo.TB_SY_TP_CLASSIFICACAO (
    id_tp_classificacao INT IDENTITY(1,1) NOT NULL,
    nm_tp_classificacao VARCHAR(30)       NOT NULL,
    ds_tp_classificacao VARCHAR(100)      NOT NULL,
    vl_min              INT               NOT NULL,
    vl_max              INT               NOT NULL,
    CONSTRAINT PK_TB_SY_TP_CLASSIFICACAO PRIMARY KEY CLUSTERED (id_tp_classificacao),
    CONSTRAINT UQ_TB_SY_TP_CLASSIFICACAO_NM UNIQUE (nm_tp_classificacao),
    CONSTRAINT CK_TB_SY_TP_CLASSIFICACAO_INTERVALO CHECK (vl_min <= vl_max)
);
GO

CREATE TABLE dbo.TB_SY_TP_TESTE (
    id_tp_teste     INT IDENTITY(1,1) NOT NULL,
    nm_tipo_teste   VARCHAR(50)       NOT NULL,
    ds_tipo_teste   VARCHAR(100)      NOT NULL,
    tm_duracao      INT               NOT NULL,
    CONSTRAINT PK_TB_SY_TP_TESTE PRIMARY KEY CLUSTERED (id_tp_teste),
    CONSTRAINT UQ_TB_SY_TP_TESTE_NM UNIQUE (nm_tipo_teste),
    CONSTRAINT CK_TB_SY_TP_TESTE_TM_DURACAO CHECK (tm_duracao > 0)
);
GO

CREATE TABLE dbo.TB_SY_HUMOR (
    id_humor    INT IDENTITY(1,1) NOT NULL,
    nm_humor    VARCHAR(30)       NOT NULL,
    ds_humor    VARCHAR(100)      NULL,
    CONSTRAINT PK_TB_SY_HUMOR PRIMARY KEY CLUSTERED (id_humor),
    CONSTRAINT UQ_TB_SY_HUMOR_NM UNIQUE (nm_humor)
);
GO

CREATE TABLE dbo.TB_SY_GATILHOS (
    id_gatilho  INT IDENTITY(1,1) NOT NULL,
    nm_gatilho  VARCHAR(30)       NOT NULL,
    ds_gatilho  VARCHAR(100)      NOT NULL,
    CONSTRAINT PK_TB_SY_GATILHOS PRIMARY KEY CLUSTERED (id_gatilho),
    CONSTRAINT UQ_TB_SY_GATILHOS_NM UNIQUE (nm_gatilho)
);
GO

CREATE TABLE dbo.TB_SY_PERSONALIDADE (
    id_personalidade  INT IDENTITY(1,1) NOT NULL,
    nm_personalidade  VARCHAR(100)      NOT NULL,
    ds_personalidade  VARCHAR(255)      NOT NULL,
    CONSTRAINT PK_TB_SY_PERSONALIDADE PRIMARY KEY CLUSTERED (id_personalidade),
    CONSTRAINT UQ_TB_SY_PERSONALIDADE_NM UNIQUE (nm_personalidade)
);
GO

CREATE TABLE dbo.TB_SY_CARACTERISTICA (
    id_caracteristica  INT IDENTITY(1,1) NOT NULL,
    nm_caracteristica  VARCHAR(50)       NOT NULL,
    CONSTRAINT PK_TB_SY_CARACTERISTICA PRIMARY KEY CLUSTERED (id_caracteristica),
    CONSTRAINT UQ_TB_SY_CARACTERISTICA_NM UNIQUE (nm_caracteristica)
);
GO

CREATE TABLE dbo.TB_SY_USUARIO (
    id_usuario     INT IDENTITY(1,1) NOT NULL,
    nm_completo    VARCHAR(100)      NOT NULL,
    ds_email       VARCHAR(100)      NOT NULL,
    nr_telefone    CHAR(15)          NOT NULL,
    ds_senha_hash  VARCHAR(255)      NOT NULL,
    tp_perfil      CHAR(1)           NOT NULL,
    CONSTRAINT PK_TB_SY_USUARIO PRIMARY KEY CLUSTERED (id_usuario),
    CONSTRAINT UQ_TB_SY_USUARIO_DS_EMAIL UNIQUE (ds_email),
    CONSTRAINT CK_TB_SY_USUARIO_DS_EMAIL CHECK (ds_email LIKE '%_@_%._%')
);
GO

CREATE TABLE dbo.TB_SY_PESSOA_FISICA (
    id_usuario          INT          NOT NULL,
    dt_nascimento       DATE         NOT NULL,
    ds_email_guardiao   VARCHAR(100) NULL,
    nr_cpf              CHAR(11)     NOT NULL,
    CONSTRAINT PK_TB_SY_PESSOA_FISICA PRIMARY KEY CLUSTERED (id_usuario),
    CONSTRAINT UQ_TB_SY_PESSOA_FISICA_NR_CPF UNIQUE (nr_cpf),
    CONSTRAINT FK_TB_SY_PESSOA_FISICA_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT CK_TB_SY_PESSOA_FISICA_NR_CPF_NUMERICO CHECK (nr_cpf NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_TB_SY_PESSOA_FISICA_EMAIL_GUARDIAO CHECK (ds_email_guardiao IS NULL OR ds_email_guardiao LIKE '%_@_%._%')
);
GO

CREATE TABLE dbo.TB_SY_PSICOLOGO (
    id_usuario   INT     NOT NULL,
    id_endereco  INT     NOT NULL,
    nr_crp       CHAR(7) NOT NULL,
    CONSTRAINT PK_TB_SY_PSICOLOGO PRIMARY KEY CLUSTERED (id_usuario),
    CONSTRAINT UQ_TB_SY_PSICOLOGO_NR_CRP UNIQUE (nr_crp),
    CONSTRAINT FK_TB_SY_PSICOLOGO_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_PSICOLOGO_ENDERECO FOREIGN KEY (id_endereco)
        REFERENCES dbo.TB_SY_ENDERECO (id_endereco)
);
GO

CREATE TABLE dbo.TB_SY_ASSINATURA (
    id_assinatura      INT IDENTITY(1,1) NOT NULL,
    id_plano           INT               NOT NULL,
    id_usuario         INT               NOT NULL,
    st_status          CHAR(1)           NOT NULL,
    dt_assinatura      DATETIME          NOT NULL CONSTRAINT DF_TB_SY_ASSINATURA_DT_ASSINATURA DEFAULT GETDATE(),
    nr_valor           DECIMAL(6,2)      NOT NULL,
    sg_tipo_pagamento  CHAR(1)           NOT NULL,
    tp_periodo         CHAR(1)           NOT NULL,
    CONSTRAINT PK_TB_SY_ASSINATURA PRIMARY KEY CLUSTERED (id_assinatura),
    CONSTRAINT FK_TB_SY_ASSINATURA_PLANO FOREIGN KEY (id_plano)
        REFERENCES dbo.TB_SY_PLANO (id_plano),
    CONSTRAINT FK_TB_SY_ASSINATURA_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT CK_TB_SY_ASSINATURA_NR_VALOR CHECK (nr_valor >= 0),
    CONSTRAINT CK_TB_SY_ASSINATURA_ST_STATUS CHECK (st_status IN ('A','I','C')),
    CONSTRAINT CK_TB_SY_ASSINATURA_TP_PERIODO CHECK (tp_periodo IN ('M','A')),
    CONSTRAINT CK_TB_SY_ASSINATURA_SG_TIPO_PAGAMENTO CHECK (sg_tipo_pagamento IN ('C','D','P','B'))
);
GO

CREATE TABLE dbo.TB_SY_CLASSIFICACAO (
    id_classificacao     INT IDENTITY(1,1) NOT NULL,
    id_tp_classificacao  INT               NOT NULL,
    vl_classificacao     INT               NOT NULL,
    nm_classificacao     VARCHAR(30)       NOT NULL,
    CONSTRAINT PK_TB_SY_CLASSIFICACAO PRIMARY KEY CLUSTERED (id_classificacao),
    CONSTRAINT FK_TB_SY_CLASSIFICACAO_TP_CLASSIFICACAO FOREIGN KEY (id_tp_classificacao)
        REFERENCES dbo.TB_SY_TP_CLASSIFICACAO (id_tp_classificacao),
    CONSTRAINT UQ_TB_SY_CLASSIFICACAO_TIPO_VALOR UNIQUE (id_tp_classificacao, vl_classificacao)
);
GO

CREATE TABLE dbo.TB_SY_TESTE (
    id_teste      INT IDENTITY(1,1) NOT NULL,
    id_tp_teste   INT               NOT NULL,
    nm_teste      VARCHAR(50)       NOT NULL,
    ds_teste      VARCHAR(100)      NOT NULL,
    dt_criacao    DATETIME          NOT NULL CONSTRAINT DF_TB_SY_TESTE_DT_CRIACAO DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SY_TESTE PRIMARY KEY CLUSTERED (id_teste),
    CONSTRAINT FK_TB_SY_TESTE_TP_TESTE FOREIGN KEY (id_tp_teste)
        REFERENCES dbo.TB_SY_TP_TESTE (id_tp_teste)
);
GO

CREATE TABLE dbo.TB_SY_PERGUNTA_TESTE (
    id_pergunta   INT IDENTITY(1,1) NOT NULL,
    ds_pergunta   VARCHAR(255)      NOT NULL,
    nr_ordem      INT               NOT NULL,
    CONSTRAINT PK_TB_SY_PERGUNTA_TESTE PRIMARY KEY CLUSTERED (id_pergunta),
    CONSTRAINT CK_TB_SY_PERGUNTA_TESTE_NR_ORDEM CHECK (nr_ordem > 0)
);
GO

CREATE TABLE dbo.TB_SY_A_TESTE_PERGUNTA_TESTE (
    id_pergunta  INT NOT NULL,
    id_teste     INT NOT NULL,
    CONSTRAINT PK_TB_SY_A_TESTE_PERGUNTA_TESTE PRIMARY KEY CLUSTERED (id_pergunta, id_teste),
    CONSTRAINT FK_TB_SY_A_TESTE_PERGUNTA_TESTE_PERGUNTA FOREIGN KEY (id_pergunta)
        REFERENCES dbo.TB_SY_PERGUNTA_TESTE (id_pergunta),
    CONSTRAINT FK_TB_SY_A_TESTE_PERGUNTA_TESTE_TESTE FOREIGN KEY (id_teste)
        REFERENCES dbo.TB_SY_TESTE (id_teste)
);
GO

CREATE TABLE dbo.TB_SY_FAIXA_RESULTADO_TESTE (
    id_faixa_resultado  INT IDENTITY(1,1) NOT NULL,
    id_teste            INT               NOT NULL,
    id_classificacao    INT               NOT NULL,
    vl_min_pontuacao    INT               NULL,
    vl_max_pontuacao    INT               NULL,
    CONSTRAINT PK_TB_SY_FAIXA_RESULTADO_TESTE PRIMARY KEY CLUSTERED (id_faixa_resultado),
    CONSTRAINT FK_TB_SY_FAIXA_RESULTADO_TESTE_TESTE FOREIGN KEY (id_teste)
        REFERENCES dbo.TB_SY_TESTE (id_teste),
    CONSTRAINT FK_TB_SY_FAIXA_RESULTADO_TESTE_CLASSIFICACAO FOREIGN KEY (id_classificacao)
        REFERENCES dbo.TB_SY_CLASSIFICACAO (id_classificacao),
    CONSTRAINT CK_TB_SY_FAIXA_RESULTADO_TESTE_INTERVALO CHECK (
        vl_min_pontuacao IS NULL OR vl_max_pontuacao IS NULL OR vl_min_pontuacao <= vl_max_pontuacao
    )
);
GO

CREATE TABLE dbo.TB_SY_APLICACAO_TESTE (
    id_aplicacao         INT IDENTITY(1,1) NOT NULL,
    id_usuario           INT               NOT NULL,
    id_teste             INT               NOT NULL,
    id_faixa_resultado   INT               NOT NULL,
    dt_aplicacao         DATETIME          NOT NULL CONSTRAINT DF_TB_SY_APLICACAO_TESTE_DT_APLICACAO DEFAULT GETDATE(),
    nr_pontuacao_total   INT               NOT NULL,
    CONSTRAINT PK_TB_SY_APLICACAO_TESTE PRIMARY KEY CLUSTERED (id_aplicacao),
    CONSTRAINT FK_TB_SY_APLICACAO_TESTE_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_APLICACAO_TESTE_TESTE FOREIGN KEY (id_teste)
        REFERENCES dbo.TB_SY_TESTE (id_teste),
    CONSTRAINT FK_TB_SY_APLICACAO_TESTE_FAIXA_RESULTADO FOREIGN KEY (id_faixa_resultado)
        REFERENCES dbo.TB_SY_FAIXA_RESULTADO_TESTE (id_faixa_resultado),
    CONSTRAINT CK_TB_SY_APLICACAO_TESTE_PONTUACAO CHECK (nr_pontuacao_total >= 0)
);
GO

CREATE TABLE dbo.TB_SY_RESPOSTA_TESTE_USUARIO (
    id_resposta_teste_usuario  INT IDENTITY(1,1) NOT NULL,
    id_pergunta                INT               NOT NULL,
    id_aplicacao               INT               NOT NULL,
    nr_resposta                INT               NOT NULL,
    nr_pontuacao               INT               NOT NULL,
    CONSTRAINT PK_TB_SY_RESPOSTA_TESTE_USUARIO PRIMARY KEY CLUSTERED (id_resposta_teste_usuario),
    CONSTRAINT FK_TB_SY_RESPOSTA_TESTE_USUARIO_PERGUNTA FOREIGN KEY (id_pergunta)
        REFERENCES dbo.TB_SY_PERGUNTA_TESTE (id_pergunta),
    CONSTRAINT FK_TB_SY_RESPOSTA_TESTE_USUARIO_APLICACAO FOREIGN KEY (id_aplicacao)
        REFERENCES dbo.TB_SY_APLICACAO_TESTE (id_aplicacao),
    CONSTRAINT CK_TB_SY_RESPOSTA_TESTE_USUARIO_RESPOSTA CHECK (nr_resposta >= 0),
    CONSTRAINT CK_TB_SY_RESPOSTA_TESTE_USUARIO_PONTUACAO CHECK (nr_pontuacao >= 0)
);
GO

CREATE TABLE dbo.TB_SY_REGISTRO_HUMOR (
    id_registro_humor  INT IDENTITY(1,1) NOT NULL,
    id_usuario         INT               NOT NULL,
    id_humor           INT               NOT NULL,
    id_classificacao   INT               NOT NULL,
    dt_registro        DATETIME          NOT NULL CONSTRAINT DF_TB_SY_REGISTRO_HUMOR_DT_REGISTRO DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SY_REGISTRO_HUMOR PRIMARY KEY CLUSTERED (id_registro_humor),
    CONSTRAINT FK_TB_SY_REGISTRO_HUMOR_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_REGISTRO_HUMOR_HUMOR FOREIGN KEY (id_humor)
        REFERENCES dbo.TB_SY_HUMOR (id_humor),
    CONSTRAINT FK_TB_SY_REGISTRO_HUMOR_CLASSIFICACAO FOREIGN KEY (id_classificacao)
        REFERENCES dbo.TB_SY_CLASSIFICACAO (id_classificacao)
);
GO

CREATE TABLE dbo.TB_SY_MNT_SONO (
    id_sono           INT IDENTITY(1,1) NOT NULL,
    id_usuario        INT               NOT NULL,
    id_classificacao  INT               NOT NULL,
    dt_inicio         DATETIME          NOT NULL,
    dt_fim            DATETIME          NOT NULL,
    ds_sono           VARCHAR(100)      NOT NULL,
    CONSTRAINT PK_TB_SY_MNT_SONO PRIMARY KEY CLUSTERED (id_sono),
    CONSTRAINT FK_TB_SY_MNT_SONO_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_MNT_SONO_CLASSIFICACAO FOREIGN KEY (id_classificacao)
        REFERENCES dbo.TB_SY_CLASSIFICACAO (id_classificacao),
    CONSTRAINT CK_TB_SY_MNT_SONO_INTERVALO CHECK (dt_fim > dt_inicio)
);
GO

CREATE TABLE dbo.TB_SY_MNT_ESTRESSE (
    id_estresse       INT IDENTITY(1,1) NOT NULL,
    id_usuario        INT               NOT NULL,
    id_classificacao  INT               NOT NULL,
    dt_registro       DATETIME          NOT NULL CONSTRAINT DF_TB_SY_MNT_ESTRESSE_DT_REGISTRO DEFAULT GETDATE(),
    ds_estresse       VARCHAR(100)      NOT NULL,
    CONSTRAINT PK_TB_SY_MNT_ESTRESSE PRIMARY KEY CLUSTERED (id_estresse),
    CONSTRAINT FK_TB_SY_MNT_ESTRESSE_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_MNT_ESTRESSE_CLASSIFICACAO FOREIGN KEY (id_classificacao)
        REFERENCES dbo.TB_SY_CLASSIFICACAO (id_classificacao)
);
GO

CREATE TABLE dbo.TB_SY_A_ESTRESSE_GATILHO (
    id_estresse  INT NOT NULL,
    id_gatilho   INT NOT NULL,
    CONSTRAINT PK_TB_SY_A_ESTRESSE_GATILHO PRIMARY KEY CLUSTERED (id_estresse, id_gatilho),
    CONSTRAINT FK_TB_SY_A_ESTRESSE_GATILHO_ESTRESSE FOREIGN KEY (id_estresse)
        REFERENCES dbo.TB_SY_MNT_ESTRESSE (id_estresse),
    CONSTRAINT FK_TB_SY_A_ESTRESSE_GATILHO_GATILHO FOREIGN KEY (id_gatilho)
        REFERENCES dbo.TB_SY_GATILHOS (id_gatilho)
);
GO

CREATE TABLE dbo.TB_SY_FEEDBACK (
    id_feedback       INT IDENTITY(1,1) NOT NULL,
    id_usuario        INT               NOT NULL,
    id_classificacao  INT               NOT NULL,
    ds_feedback       VARCHAR(200)      NOT NULL,
    dt_registro       DATETIME          NOT NULL CONSTRAINT DF_TB_SY_FEEDBACK_DT_REGISTRO DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SY_FEEDBACK PRIMARY KEY CLUSTERED (id_feedback),
    CONSTRAINT FK_TB_SY_FEEDBACK_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT FK_TB_SY_FEEDBACK_CLASSIFICACAO FOREIGN KEY (id_classificacao)
        REFERENCES dbo.TB_SY_CLASSIFICACAO (id_classificacao)
);
GO

CREATE TABLE dbo.TB_SY_SITUACAO (
    id_situacao   INT IDENTITY(1,1) NOT NULL,
    id_usuario    INT               NOT NULL,
    ds_situacao   VARCHAR(200)      NOT NULL,
    nv_gravidade  CHAR(1)           NOT NULL,
    dt_criacao    DATETIME          NOT NULL CONSTRAINT DF_TB_SY_SITUACAO_DT_CRIACAO DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SY_SITUACAO PRIMARY KEY CLUSTERED (id_situacao),
    CONSTRAINT FK_TB_SY_SITUACAO_USUARIO FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),
    CONSTRAINT CK_TB_SY_SITUACAO_NV_GRAVIDADE CHECK (nv_gravidade IN ('B','M','A'))
);
GO

CREATE TABLE dbo.TB_SY_LINK (
    id_link            INT IDENTITY(1,1) NOT NULL,
    id_pessoa_fisica   INT               NOT NULL,
    url_completa       VARCHAR(255)      NOT NULL,
    dt_criacao         DATETIME          NOT NULL CONSTRAINT DF_TB_SY_LINK_DT_CRIACAO DEFAULT GETDATE(),
    tp_link            CHAR(1)           NOT NULL,
    CONSTRAINT PK_TB_SY_LINK PRIMARY KEY CLUSTERED (id_link),
    CONSTRAINT FK_TB_SY_LINK_PESSOA_FISICA FOREIGN KEY (id_pessoa_fisica)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario),
    CONSTRAINT CK_TB_SY_LINK_TP_LINK CHECK (tp_link IN ('C','R','O')),
    CONSTRAINT CK_TB_SY_LINK_URL CHECK (url_completa LIKE 'http%://%')
);
GO

CREATE TABLE dbo.TB_SY_A_PERSONALIDADE_CARACTERISTICA (
    id_personalidade   INT NOT NULL,
    id_caracteristica  INT NOT NULL,
    CONSTRAINT PK_TB_SY_A_PERSONALIDADE_CARACTERISTICA PRIMARY KEY CLUSTERED (id_personalidade, id_caracteristica),
    CONSTRAINT FK_TB_SY_A_PERSONALIDADE_CARACTERISTICA_PERSONALIDADE FOREIGN KEY (id_personalidade)
        REFERENCES dbo.TB_SY_PERSONALIDADE (id_personalidade),
    CONSTRAINT FK_TB_SY_A_PERSONALIDADE_CARACTERISTICA_CARACTERISTICA FOREIGN KEY (id_caracteristica)
        REFERENCES dbo.TB_SY_CARACTERISTICA (id_caracteristica)
);
GO
