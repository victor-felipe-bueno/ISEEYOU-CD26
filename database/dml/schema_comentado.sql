/* =========================================================
   DDL - SISTEMA SY
   Banco: SQL Server

   Este arquivo cria as tabelas principais do sistema.

   Esta versão possui comentários para facilitar o entendimento
   do grupo.

   ---------------------------------------------------------
   CONCEITOS IMPORTANTES
   ---------------------------------------------------------

   CREATE TABLE
   Comando usado para criar uma tabela no banco de dados.

   PK - PRIMARY KEY / CHAVE PRIMÁRIA
   Identifica cada registro de forma única.
   Exemplo: id_usuario identifica um único usuário.

   FK - FOREIGN KEY / CHAVE ESTRANGEIRA
   Cria ligação entre duas tabelas.
   Exemplo: id_estado em TB_SY_CIDADE aponta para TB_SY_ESTADO.

   NOT NULL
   Significa que o campo é obrigatório.

   NULL
   Significa que o campo é opcional.

   IDENTITY(1,1)
   Faz o SQL Server gerar o ID automaticamente.
   Começa em 1 e aumenta de 1 em 1.

   UNIQUE
   Impede valores repetidos.
   Exemplo: dois usuários não podem ter o mesmo e-mail.

   CHECK
   Cria uma regra de validação.
   Exemplo: valor de assinatura não pode ser negativo.

   DATETIME
   Guarda data e hora.
   Exemplo: 2026-06-08 15:30:00

   No SQL Server, o tipo é escrito como DATETIME,
   sem parênteses.

   DEFAULT SYSDATETIME()
   Preenche automaticamente o campo com a data e hora atual
   quando o valor não é informado no INSERT.

   VARCHAR(MAX)
   Usado quando o texto pode ser muito grande.
   Neste modelo, foi usado apenas para url_completa, pois links
   podem ser longos.

   dbo.
   É o schema padrão do SQL Server.
   Funciona como uma organização interna das tabelas.

   GO
   Separador de comandos usado no SQL Server Management Studio.
   ========================================================= */


-- =========================================================
-- TABELA: TB_SY_ESTADO
--
-- Guarda os estados.
--
-- Exemplo:
-- SC - Santa Catarina
-- SP - São Paulo
-- PR - Paraná
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_CIDADE
--
-- Guarda as cidades.
-- Cada cidade pertence a um estado.
--
-- O campo id_estado faz a ligação com TB_SY_ESTADO.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_BAIRRO
--
-- Guarda os bairros.
-- Cada bairro pertence a uma cidade.
--
-- A restrição UNIQUE impede cadastrar o mesmo bairro
-- duas vezes na mesma cidade.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_TP_LOGRADOURO
--
-- Guarda o tipo do logradouro.
--
-- Exemplos:
-- Rua
-- Avenida
-- Travessa
-- Rodovia
-- =========================================================

CREATE TABLE dbo.TB_SY_TP_LOGRADOURO (
    id_tp_logradouro INT IDENTITY(1,1) NOT NULL,
    ds_tp_logradouro VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TB_SY_TP_LOGRADOURO
        PRIMARY KEY (id_tp_logradouro),

    CONSTRAINT UQ_TB_SY_TP_LOGRADOURO_DS
        UNIQUE (ds_tp_logradouro)
);
GO


-- =========================================================
-- TABELA: TB_SY_LOGRADOURO
--
-- Guarda o nome do logradouro.
--
-- Exemplo:
-- Tipo: Rua
-- Nome: XV de Novembro
--
-- O campo id_tp_logradouro liga o logradouro ao tipo.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_ENDERECO
--
-- Guarda o endereço completo.
--
-- Um endereço é formado por:
-- bairro, logradouro, número, complemento e CEP.
--
-- nr_numero usa VARCHAR(20), pois pode conter letras
-- ou textos curtos, como 123A ou S/N.
--
-- nr_cep usa CHAR(8), pois CEP deve ser armazenado como texto,
-- sem perder zeros à esquerda.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_USUARIO
--
-- Guarda os dados básicos de qualquer usuário do sistema.
--
-- Pessoa física e psicólogo começam como usuário.
-- Depois, cada um recebe informações específicas em outra tabela.
--
-- tp_perfil pode indicar o tipo do usuário.
-- Exemplo:
-- P = Pessoa física
-- S = Psicólogo
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_PESSOA_FISICA
--
-- Guarda dados específicos da pessoa física.
--
-- id_usuario é PK e FK ao mesmo tempo.
--
-- Isso significa que a pessoa física precisa existir primeiro
-- na tabela TB_SY_USUARIO.
--
-- nr_cpf usa CHAR(11), pois CPF deve ser armazenado como texto,
-- sem pontos e sem hífen.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_PSICOLOGO
--
-- Guarda dados específicos do psicólogo.
--
-- O psicólogo também precisa existir primeiro em TB_SY_USUARIO.
--
-- nr_crp representa o registro profissional do psicólogo.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_PLANO
--
-- Guarda os planos disponíveis no sistema.
--
-- nm_plano foi mantido como VARCHAR(10), conforme o modelo
-- lógico, pois os nomes dos planos já foram definidos.
--
-- Exemplos:
-- deep
-- basic
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_ASSINATURA_PF
--
-- Registra assinaturas de pessoas físicas.
--
-- Esta tabela liga:
-- TB_SY_PESSOA_FISICA + TB_SY_PLANO
--
-- dt_assinatura usa DATETIME para guardar data e hora.
--
-- DEFAULT SYSDATETIME() registra automaticamente o momento
-- em que a assinatura foi criada, caso o valor não seja informado.
--
-- nr_valor usa DECIMAL(6,2), permitindo valores como 9999.99.
--
-- CHECK impede que o valor da assinatura seja negativo.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_ASSINATURA_PSICOLOGO
--
-- Registra assinaturas de psicólogos.
--
-- Esta tabela liga:
-- TB_SY_PSICOLOGO + TB_SY_PLANO
--
-- dt_assinatura também recebe DEFAULT SYSDATETIME()
-- para registrar automaticamente a data/hora da assinatura.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_SITUACAO
--
-- Guarda situações relatadas pela pessoa física.
--
-- Exemplo:
-- "Estou me sentindo ansioso hoje."
--
-- nv_gravidade pode indicar o nível da situação.
-- Exemplo:
-- B = Baixo
-- M = Médio
-- A = Alto
--
-- dt_criacao usa DEFAULT SYSDATETIME() para registrar
-- automaticamente quando a situação foi criada.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_MNT_ESTRESSE
--
-- Registra períodos de estresse do usuário.
--
-- dt_inicio indica quando começou.
-- dt_fim indica quando terminou.
--
-- O CHECK impede que a data final seja menor que a inicial.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_MNT_SONO
--
-- Registra períodos de sono do usuário.
--
-- dt_inicio indica quando o sono começou.
-- dt_fim indica quando o sono terminou.
--
-- O CHECK impede que o fim do sono seja antes do início.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_LINK
--
-- Guarda links relacionados à pessoa física.
--
-- url_completa usa VARCHAR(MAX), pois links podem ser longos.
--
-- TEXT foi evitado porque é um tipo antigo no SQL Server.
--
-- dt_criacao usa DEFAULT SYSDATETIME() para registrar
-- automaticamente quando o link foi cadastrado.
-- =========================================================

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


-- =========================================================
-- TABELA: TB_SY_FEEDBACK
--
-- Guarda avaliações e comentários dos usuários.
--
-- Está ligada à tabela TB_SY_USUARIO para permitir que
-- diferentes tipos de usuários enviem feedback.
-- =========================================================

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