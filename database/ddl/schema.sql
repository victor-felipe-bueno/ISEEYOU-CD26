CREATE TABLE dbo.TB_SY_ESTADO (
    id_estado INT IDENTITY(1,1) NOT NULL,
    sg_estado CHAR(2) NOT NULL,
    nm_estado VARCHAR(30) NOT NULL,

    CONSTRAINT PK_TB_SY_ESTADO
        PRIMARY KEY (id_estado),

    CONSTRAINT UQ_TB_SY_ESTADO_SG
        UNIQUE (sg_estado)
);
GO

CREATE TABLE dbo.TB_SY_CIDADE (
    id_cidade INT IDENTITY(1,1) NOT NULL,
    id_estado INT NOT NULL,
    cd_cidade CHAR(7) NOT NULL,
    nm_cidade VARCHAR(80) NOT NULL,

    CONSTRAINT PK_TB_SY_CIDADE
        PRIMARY KEY (id_cidade),

    CONSTRAINT FK_TB_SY_CIDADE_ESTADO
        FOREIGN KEY (id_estado)
        REFERENCES dbo.TB_SY_ESTADO (id_estado),

    CONSTRAINT UQ_TB_SY_CIDADE_CD
        UNIQUE (cd_cidade)
);
GO

CREATE TABLE dbo.TB_SY_BAIRRO (
    id_bairro INT IDENTITY(1,1) NOT NULL,
    id_cidade INT NOT NULL,
    nm_bairro VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TB_SY_BAIRRO
        PRIMARY KEY (id_bairro),

    CONSTRAINT FK_TB_SY_BAIRRO_CIDADE
        FOREIGN KEY (id_cidade)
        REFERENCES dbo.TB_SY_CIDADE (id_cidade),

    CONSTRAINT UQ_TB_SY_BAIRRO_CIDADE_NOME
        UNIQUE (id_cidade, nm_bairro)
);
GO

CREATE TABLE dbo.TB_SY_TP_LOGRADOURO (
    id_tp_logradouro INT IDENTITY(1,1) NOT NULL,
    ds_tp_logradouro VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TB_SY_TP_LOGRADOURO
        PRIMARY KEY (id_tp_logradouro),

    CONSTRAINT UQ_TB_SY_TP_LOGRADOURO_DS
        UNIQUE (ds_tp_logradouro)
);
GO

CREATE TABLE dbo.TB_SY_LOGRADOURO (
    id_logradouro INT IDENTITY(1,1) NOT NULL,
    id_tp_logradouro INT NOT NULL,
    nm_logradouro VARCHAR(80) NOT NULL,

    CONSTRAINT PK_TB_SY_LOGRADOURO
        PRIMARY KEY (id_logradouro),

    CONSTRAINT FK_TB_SY_LOGRADOURO_TP_LOGRADOURO
        FOREIGN KEY (id_tp_logradouro)
        REFERENCES dbo.TB_SY_TP_LOGRADOURO (id_tp_logradouro),

    CONSTRAINT UQ_TB_SY_LOGRADOURO_TIPO_NOME
        UNIQUE (id_tp_logradouro, nm_logradouro)
);
GO

CREATE TABLE dbo.TB_SY_ENDERECO (
    id_endereco INT IDENTITY(1,1) NOT NULL,
    id_bairro INT NOT NULL,
    id_logradouro INT NOT NULL,
    nr_numero VARCHAR(20) NOT NULL,
    ds_complemento VARCHAR(250) NULL,
    nr_cep CHAR(8) NOT NULL,

    CONSTRAINT PK_TB_SY_ENDERECO
        PRIMARY KEY (id_endereco),

    CONSTRAINT FK_TB_SY_ENDERECO_BAIRRO
        FOREIGN KEY (id_bairro)
        REFERENCES dbo.TB_SY_BAIRRO (id_bairro),

    CONSTRAINT FK_TB_SY_ENDERECO_LOGRADOURO
        FOREIGN KEY (id_logradouro)
        REFERENCES dbo.TB_SY_LOGRADOURO (id_logradouro)
);
GO

CREATE TABLE dbo.TB_SY_USUARIO (
    id_usuario INT IDENTITY(1,1) NOT NULL,
    nm_completo VARCHAR(100) NOT NULL,
    ds_email VARCHAR(100) NOT NULL,
    nr_telefone CHAR(9) NOT NULL,
    ds_senha VARCHAR(64) NOT NULL,
    tp_perfil CHAR(1) NOT NULL,

    CONSTRAINT PK_TB_SY_USUARIO
        PRIMARY KEY (id_usuario),

    CONSTRAINT UQ_TB_SY_USUARIO_EMAIL
        UNIQUE (ds_email)
);
GO

CREATE TABLE dbo.TB_SY_PESSOA_FISICA (
    id_usuario INT NOT NULL,
    dt_nascimento DATE NOT NULL,
    ds_email_guardiao VARCHAR(100) NULL,
    nr_cpf CHAR(11) NOT NULL,

    CONSTRAINT PK_TB_SY_PESSOA_FISICA
        PRIMARY KEY (id_usuario),

    CONSTRAINT FK_TB_SY_PESSOA_FISICA_USUARIO
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),

    CONSTRAINT UQ_TB_SY_PESSOA_FISICA_CPF
        UNIQUE (nr_cpf)
);
GO

CREATE TABLE dbo.TB_SY_PSICOLOGO (
    id_usuario INT NOT NULL,
    id_endereco INT NOT NULL,
    nr_crp CHAR(7) NOT NULL,

    CONSTRAINT PK_TB_SY_PSICOLOGO
        PRIMARY KEY (id_usuario),

    CONSTRAINT FK_TB_SY_PSICOLOGO_USUARIO
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario),

    CONSTRAINT FK_TB_SY_PSICOLOGO_ENDERECO
        FOREIGN KEY (id_endereco)
        REFERENCES dbo.TB_SY_ENDERECO (id_endereco),

    CONSTRAINT UQ_TB_SY_PSICOLOGO_CRP
        UNIQUE (nr_crp)
);
GO

CREATE TABLE dbo.TB_SY_PLANO (
    id_plano INT IDENTITY(1,1) NOT NULL,
    nm_plano VARCHAR(10) NOT NULL,
    ds_plano VARCHAR(100) NOT NULL,

    CONSTRAINT PK_TB_SY_PLANO
        PRIMARY KEY (id_plano),

    CONSTRAINT UQ_TB_SY_PLANO_NM
        UNIQUE (nm_plano)
);
GO

CREATE TABLE dbo.TB_SY_ASSINATURA_PF (
    id_assinatura_pf INT IDENTITY(1,1) NOT NULL,
    id_plano INT NOT NULL,
    id_pessoa_fisica INT NOT NULL,
    st_status CHAR(1) NOT NULL,
    dt_assinatura DATETIME NOT NULL
        CONSTRAINT DF_TB_SY_ASSINATURA_PF_DT
        DEFAULT SYSDATETIME(),
    nr_valor DECIMAL(6,2) NOT NULL,
    sg_tipo_pagamento CHAR(1) NOT NULL,
    tp_periodo CHAR(1) NOT NULL,

    CONSTRAINT PK_TB_SY_ASSINATURA_PF
        PRIMARY KEY (id_assinatura_pf),

    CONSTRAINT FK_TB_SY_ASSINATURA_PF_PLANO
        FOREIGN KEY (id_plano)
        REFERENCES dbo.TB_SY_PLANO (id_plano),

    CONSTRAINT FK_TB_SY_ASSINATURA_PF_PESSOA_FISICA
        FOREIGN KEY (id_pessoa_fisica)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario),

    CONSTRAINT CK_TB_SY_ASSINATURA_PF_VALOR
        CHECK (nr_valor >= 0)
);
GO

CREATE TABLE dbo.TB_SY_ASSINATURA_PSICOLOGO (
    id_assinatura_psicologo INT IDENTITY(1,1) NOT NULL,
    id_psicologo INT NOT NULL,
    id_plano INT NOT NULL,
    st_status CHAR(1) NOT NULL,
    dt_assinatura DATETIME NOT NULL
        CONSTRAINT DF_TB_SY_ASSINATURA_PSICOLOGO_DT
        DEFAULT SYSDATETIME(),
    nr_valor DECIMAL(6,2) NOT NULL,
    sg_tipo_pagamento CHAR(1) NOT NULL,
    tp_periodo CHAR(1) NOT NULL,

    CONSTRAINT PK_TB_SY_ASSINATURA_PSICOLOGO
        PRIMARY KEY (id_assinatura_psicologo),

    CONSTRAINT FK_TB_SY_ASSINATURA_PSICOLOGO_PSICOLOGO
        FOREIGN KEY (id_psicologo)
        REFERENCES dbo.TB_SY_PSICOLOGO (id_usuario),

    CONSTRAINT FK_TB_SY_ASSINATURA_PSICOLOGO_PLANO
        FOREIGN KEY (id_plano)
        REFERENCES dbo.TB_SY_PLANO (id_plano),

    CONSTRAINT CK_TB_SY_ASSINATURA_PSICOLOGO_VALOR
        CHECK (nr_valor >= 0)
);
GO

CREATE TABLE dbo.TB_SY_SITUACAO (
    id_situacao INT IDENTITY(1,1) NOT NULL,
    id_usuario INT NOT NULL,
    ds_situacao VARCHAR(200) NOT NULL,
    nv_gravidade CHAR(1) NOT NULL,
    dt_criacao DATETIME NOT NULL
        CONSTRAINT DF_TB_SY_SITUACAO_DT_CRIACAO
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_TB_SY_SITUACAO
        PRIMARY KEY (id_situacao),

    CONSTRAINT FK_TB_SY_SITUACAO_PESSOA_FISICA
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario)
);
GO

CREATE TABLE dbo.TB_SY_MNT_ESTRESSE (
    id_estresse INT IDENTITY(1,1) NOT NULL,
    id_usuario INT NOT NULL,
    dt_inicio DATETIME NOT NULL,
    dt_fim DATETIME NOT NULL,
    sg_periodo CHAR(1) NOT NULL,
    sg_classificacao CHAR(1) NOT NULL,
    ds_estresse VARCHAR(100) NOT NULL,

    CONSTRAINT PK_TB_SY_MNT_ESTRESSE
        PRIMARY KEY (id_estresse),

    CONSTRAINT FK_TB_SY_MNT_ESTRESSE_PESSOA_FISICA
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario),

    CONSTRAINT CK_TB_SY_MNT_ESTRESSE_DATAS
        CHECK (dt_fim >= dt_inicio)
);
GO

CREATE TABLE dbo.TB_SY_MNT_SONO (
    id_sono INT IDENTITY(1,1) NOT NULL,
    id_usuario INT NOT NULL,
    dt_inicio DATETIME NOT NULL,
    dt_fim DATETIME NOT NULL,
    sg_periodo CHAR(1) NOT NULL,
    sg_classificacao CHAR(1) NOT NULL,
    ds_sono VARCHAR(100) NOT NULL,

    CONSTRAINT PK_TB_SY_MNT_SONO
        PRIMARY KEY (id_sono),

    CONSTRAINT FK_TB_SY_MNT_SONO_PESSOA_FISICA
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario),

    CONSTRAINT CK_TB_SY_MNT_SONO_DATAS
        CHECK (dt_fim >= dt_inicio)
);
GO

CREATE TABLE dbo.TB_SY_LINK (
    id_link INT IDENTITY(1,1) NOT NULL,
    id_pessoa_fisica INT NOT NULL,
    url_completa VARCHAR(MAX) NOT NULL,
    dt_criacao DATETIME NOT NULL
        CONSTRAINT DF_TB_SY_LINK_DT_CRIACAO
        DEFAULT SYSDATETIME(),
    tp_link CHAR(1) NOT NULL,

    CONSTRAINT PK_TB_SY_LINK
        PRIMARY KEY (id_link),

    CONSTRAINT FK_TB_SY_LINK_PESSOA_FISICA
        FOREIGN KEY (id_pessoa_fisica)
        REFERENCES dbo.TB_SY_PESSOA_FISICA (id_usuario)
);
GO

CREATE TABLE dbo.TB_SY_FEEDBACK (
    id_feedback INT IDENTITY(1,1) NOT NULL,
    id_usuario INT NOT NULL,
    sg_satisfacao CHAR(1) NOT NULL,
    ds_feedback VARCHAR(200) NOT NULL,

    CONSTRAINT PK_TB_SY_FEEDBACK
        PRIMARY KEY (id_feedback),

    CONSTRAINT FK_TB_SY_FEEDBACK_USUARIO
        FOREIGN KEY (id_usuario)
        REFERENCES dbo.TB_SY_USUARIO (id_usuario)
);
GO