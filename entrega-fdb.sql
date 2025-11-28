---------------------------------------------
-- Comando DDL para criação das tabelas  ----
---------------------------------------------

-- 1. TABELAS BASE

CREATE TABLE ASSISTIDA (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    identidadeGenero VARCHAR(50),
    n_social VARCHAR(100),
    escolaridade VARCHAR(50),
    religiao VARCHAR(50),
    nacionalidade VARCHAR(50) NOT NULL,
    zona VARCHAR(20) NOT NULL,
    ocupacao VARCHAR(100) NOT NULL,
    cad_social VARCHAR(50),
    dependentes INT NOT NULL,
    cor_raca VARCHAR(20) NOT NULL,
    endereco VARCHAR(50),
    deficiencia VARCHAR(50),
    limitacao VARCHAR(50)
);

CREATE TABLE FILHO (
    seq_filho INT NOT NULL,
    qtd_filhos_deficiencia INT,
    qtd_filho_agressor INT,
    qtd_filho_outro_relacionamento INT,
    viu_violencia BOOLEAN NOT NULL,
    violencia_gravidez BOOLEAN NOT NULL,
    id_assistida INT NOT NULL,
    FOREIGN KEY(id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE,
    CONSTRAINT PK_filho PRIMARY KEY(id_assistida, seq_filho)
);

CREATE TABLE CONFLITO_FILHO (
    tipo_conflito VARCHAR(50) NOT NULL,
    id_assistida INT NOT NULL,
    seq_filho INT NOT NULL,
    FOREIGN KEY(id_assistida, seq_filho)
        REFERENCES FILHO(id_assistida, seq_filho) ON DELETE CASCADE,
    CONSTRAINT PK_conflito PRIMARY KEY(id_assistida, seq_filho, tipo_conflito)
);

CREATE TABLE FAIXA_FILHO (
    id_assistida INT NOT NULL,
    id_filhos INT NOT NULL,
    faixa_etaria VARCHAR(20) NOT NULL,
    FOREIGN KEY(id_assistida, seq_filho)
        REFERENCES FILHO(id_assistida, id_filhos) ON DELETE CASCADE,
    CONSTRAINT PK_faixa_filho PRIMARY KEY(id_assistida, id_filhos)
)

CREATE TABLE CASO (
    id_caso SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    separacao VARCHAR(20) NOT NULL,
    novo_relac BOOLEAN NOT NULL,
    abrigo BOOLEAN NOT NULL,
    depen_finc BOOLEAN NOT NULL,
    mora_risco VARCHAR(20) NOT NULL,
    medida BOOLEAN NOT NULL,
    frequencia BOOLEAN NOT NULL,
    id_assistida INT NOT NULL,
    outras_informacoes text,
    FOREIGN KEY(id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- 2. FUNCIONARIOS E REDE

CREATE TABLE REDE_DE_APOIO (
    Email VARCHAR(100) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL
);

CREATE TABLE CREDENCIAIS_PROCURADORIA (
    id INT PRIMARY KEY DEFAULT 1,
    email_institucional VARCHAR(100) NOT NULL,
    senha_email VARCHAR(255) NOT NULL,
    servico_smtp VARCHAR(50) DEFAULT 'gmail',
    CONSTRAINT check_single_row CHECK (id = 1)
);

-- Inserir valor padrão para não quebrar o sistema na primeira execução
INSERT INTO CREDENCIAIS_PROCURADORIA (id, email_institucional, senha_email)
VALUES (1, 'nao_configurado@email.com', 'vazio')
ON CONFLICT (id) DO NOTHING;

CREATE TABLE FUNCIONARIO (
    Email VARCHAR(100) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Senha VARCHAR(100) NOT NULL
);

CREATE TABLE ADMINISTRADOR (
    Email VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (Email) REFERENCES FUNCIONARIO(Email) ON DELETE CASCADE
);

CREATE TABLE FUNCIONARIO_ACOMPANHA_CASO (
    email_funcionario VARCHAR(100) NOT NULL,
    id_caso INT NOT NULL,
    FOREIGN KEY(email_funcionario) REFERENCES FUNCIONARIO(Email) ON DELETE CASCADE,
    FOREIGN KEY(id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    CONSTRAINT PK_func PRIMARY KEY(email_funcionario, id_caso)
);

-- 3. AGRESSOR E MULTIVALORADOS

CREATE TABLE AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor SERIAL NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Idade INT,
    Vinculo VARCHAR(100),
    doenca VARCHAR(100), 
    medida_protetiva BOOLEAN,
    suicidio BOOLEAN,
    financeiro BOOLEAN,
    arma_de_fogo BOOLEAN,

    PRIMARY KEY (id_caso, id_assistida, id_agressor),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

CREATE TABLE SUBSTANCIAS_AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor INT NOT NULL,
    tipo_substancia VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_caso, id_assistida, id_agressor, tipo_substancia),
    FOREIGN KEY (id_caso, id_assistida, id_agressor)
        REFERENCES AGRESSOR(id_caso, id_assistida, id_agressor) ON DELETE CASCADE
);

CREATE TABLE AMEACA_AGRESSOR (
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    id_agressor INT NOT NULL,
    alvo_ameaca VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_caso, id_assistida, id_agressor, alvo_ameaca),
    FOREIGN KEY (id_caso, id_assistida, id_agressor)
        REFERENCES AGRESSOR(id_caso, id_assistida, id_agressor) ON DELETE CASCADE
);

-- 4. VIOLENCIA 

CREATE TABLE VIOLENCIA (
    id_violencia SERIAL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,

    estupro BOOLEAN,
    data_ocorrencia DATE,

    PRIMARY KEY (id_violencia, id_caso, id_assistida),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- ======= TIPOS MULTIVALORADOS =======

CREATE TABLE TIPO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_violencia VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_violencia),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE AMEACAS_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_ameaca VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_ameaca),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE AGRESSAO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    tipo_agressao VARCHAR(80) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, tipo_agressao),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);

CREATE TABLE COMPORTAMENTO_VIOLENCIA (
    id_violencia INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    descricao_comportamento VARCHAR(200) NOT NULL,

    PRIMARY KEY (id_violencia, id_caso, id_assistida, descricao_comportamento),

    FOREIGN KEY (id_violencia, id_caso, id_assistida)
        REFERENCES VIOLENCIA(id_violencia, id_caso, id_assistida) ON DELETE CASCADE
);


-- 5. ANEXO


CREATE TABLE ANEXO (
    id_anexo SERIAL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,

    nome VARCHAR(120),
    tipo VARCHAR(30),
    dados BYTEA,

    PRIMARY KEY (id_anexo, id_caso, id_assistida),

    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE,
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE
);

-- 6. PREENCHIMENTO PROFISSIONAL

CREATE TABLE PREENCHIMENTO_PROFISSIONAL (
    id_preenchimento INT NOT NULL,
    id_caso INT NOT NULL,
    id_assistida INT NOT NULL,
    assistida_respondeu_sem_ajuda boolean NOT NULL,
    assistida_respondeu_com_auxilio boolean NOT NULL,
    assistida_sem_condicoes boolean NOT NULL,
    assistida_recusou boolean NOT NULL,
    terceiro_comunicante boolean NOT NULL,
    PRIMARY KEY (id_preenchimento),
    FOREIGN KEY (id_assistida) REFERENCES ASSISTIDA(id) ON DELETE CASCADE,
    FOREIGN KEY (id_caso) REFERENCES CASO(id_caso) ON DELETE CASCADE
);

CREATE TABLE TIPO_VIOLENCIA_PREENCHIMENTO (
    id_preenchimento integer NOT NULL,
    tipo_violencia character varying(80) NOT NULL,
    PRIMARY KEY (id_preenchimento, tipo_violencia),
    FOREIGN KEY (id_preenchimento) REFERENCES PREENCHIMENTO_PROFISSIONAL(id_preenchimento) ON DELETE CASCADE
);

CREATE TABLE HISTORICO (
    id SERIAL PRIMARY KEY,

    id_func VARCHAR(120),
    tipo VARCHAR(80) NOT NULL,
    mudanca TEXT NOT NULL,

    id_caso INT,
    id_assistida INT,

    FOREIGN KEY (id_func)
        REFERENCES FUNCIONARIO(email)
        ON DELETE SET NULL,

    FOREIGN KEY (id_caso)
    REFERENCES CASO(id_caso)
    ON DELETE SET NULL,

    FOREIGN KEY (id_assistida)
        REFERENCES ASSISTIDA(id)
        ON DELETE SET NULL
);



------------------------------------------------------
-- Comandos DML para inserção de dados nas tabelas  --
------------------------------------------------------

-- Povoamento Tabela ASSISTIDA

INSERT INTO ASSISTIDA (Nome, Idade, endereco, identidadeGenero, n_social, Escolaridade, Religiao, Nacionalidade, zona, ocupacao, cad_social, Dependentes, Cor_Raca, deficiencia, limitacao)
VALUES 
    ('Maria Silva Santos', 35, 'SERRAGEM', 'MULHER CISGENERO', 'NIS001', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'VENDEDORA', 'CAD001', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Ana Paula Costa', 28, 'OCARA', 'MULHER CISGENERO', 'NIS002', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ASSISTENTE ADMINISTRATIVO', 'CAD002', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Joana Carvalho Oliveira', 42, 'SERENO', 'MULHER CISGENERO', 'NIS003', 'ENSINO FUNDAMENTAL INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'DIARISTA', 'CAD003', 3, 'NEGRA', 'HIPERTENSAO', 'MOBILIDADE REDUZIDA'),
    ('Fernanda Gomes Ribeiro', 31, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS004', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'CABELEIREIRA', 'CAD004', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Lucia Martins Ferreira', 45, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS005', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'SERVICOS GERAIS', 'CAD005', 4, 'NEGRA', 'ARTRITE', 'ARTRITE'),
    ('Carolina Pereira Silva', 29, 'FURNAS', 'MULHER CISGENERO', 'NIS006', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ENFERMEIRA', 'CAD006', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Gabriela Santos Oliveira', 38, 'SERRAGEM', 'MULHER CISGENERO', 'NIS007', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PROFESSORA', 'CAD007', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Mariana Costa Ferreira', 16, 'OCARA', 'MULHER CISGENERO', 'NIS008', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'VENDEDORA', 'CAD008', 0, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Rafaela Gomes Alves', 33, 'SERENO', 'MULHER CISGENERO', 'NIS009', 'ENSINO FUNDAMENTAL COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'FAXINEIRA', 'CAD009', 3, 'NEGRA', 'DIABETES', 'DIABETES'),
    ('Beatriz Martins Souza', 40, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS010', 'ENSINO MEDIO INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'BALCONISTA', 'CAD010', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Camila Rocha Pereira', 27, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS011', 'ENSINO SUPERIOR COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ANALISTA', 'CAD011', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Patricia Silva Gomes', 44, 'FURNAS', 'MULHER CISGENERO', 'NIS012', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'COSTUREIRA', 'CAD012', 3, 'PARDA', 'PROBLEMAS ORTOPEDICOS', 'PROBLEMAS ORTOPEDICOS'),
    ('Cristina Ferreira Costa', 36, 'SERRAGEM', 'MULHER CISGENERO', 'NIS013', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'CAIXA', 'CAD013', 2, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Daniela Souza Martins', 32, 'OCARA', 'MULHER CISGENERO', 'NIS014', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'SERVICOS DOMESTICOS', 'CAD014', 4, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Elena Oliveira Santos', 48, 'SERENO', 'MULHER CISGENERO', 'NIS015', 'ENSINO MEDIO INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'VIGILANTE', 'CAD015', 2, 'NEGRA', 'PRESSAO ALTA', 'PRESSAO ALTA'),
    ('Fernanda Silva Rocha', 30, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS016', 'ENSINO SUPERIOR INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'ESTUDANTE', 'CAD016', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Gisele Costa Gomes', 41, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS017', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ATENDENTE', 'CAD017', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Helena Pereira Alves', 25, 'FURNAS', 'MULHER CISGENERO', 'NIS018', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'MANICURE', 'CAD018', 0, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Iris Martins Silva', 39, 'SERRAGEM', 'MULHER CISGENERO', 'NIS019', 'ENSINO FUNDAMENTAL COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'LAVADEIRA', 'CAD019', 2, 'NEGRA', 'ASMA', 'ASMA'),
    ('Juliana Ferreira Souza', 34, 'OCARA', 'MULHER CISGENERO', 'NIS020', 'ENSINO SUPERIOR COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'SECRETARIA', 'CAD020', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Kamila Santos Costa', 28, 'SERENO', 'MULHER CISGENERO', 'NIS021', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PROMOTORA', 'CAD021', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Laura Gomes Oliveira', 46, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS022', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'DONA DE CASA', 'CAD022', 4, 'PARDA', 'OSTEOPOROSE', 'OSTEOPOROSE'),
    ('Monica Rocha Silva', 37, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS023', 'ENSINO MEDIO INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'FUNCIONARIA PUBLICA', 'CAD023', 2, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Natalia Souza Ferreira', 24, 'FURNAS', 'MULHER CISGENERO', 'NIS024', 'ENSINO SUPERIOR INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'AUXILIAR ENFERMAGEM', 'CAD024', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Olivia Silva Pereira', 43, 'SERRAGEM', 'MULHER CISGENERO', 'NIS025', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'RECEPCIONISTA', 'CAD025', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Paula Martins Costa', 31, 'OCARA', 'MULHER CISGENERO', 'NIS026', 'ENSINO FUNDAMENTAL COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'MERENDEIRA', 'CAD026', 2, 'NEGRA', 'HEPATITE C', 'HEPATITE C'),
    ('Quesia Santos Gomes', 50, 'SERENO', 'MULHER CISGENERO', 'NIS027', 'ENSINO FUNDAMENTAL INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PENSIONISTA', 'CAD027', 4, 'BRANCA', 'CANCER', 'CANCER'),
    ('Rita Oliveira Ferreira', 29, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS028', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'GERENTE COMERCIAL', 'CAD028', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Sandra Rocha Alves', 39, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS029', 'ENSINO SUPERIOR INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'CONSULTORA', 'CAD029', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Tatiana Gomes Souza', 35, 'FURNAS', 'MULHER CISGENERO', 'NIS030', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'ELETRICISTA', 'CAD030', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Urania Silva Barbosa', 33, 'SERRAGEM', 'MULHER CISGENERO', 'NIS031', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'TELEFONISTA', 'CAD031', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Vanessa Rocha Gomes', 27, 'OCARA', 'MULHER CISGENERO', 'NIS032', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'JORNALISTA', 'CAD032', 0, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Wanda Pereira Silva', 41, 'SERENO', 'MULHER CISGENERO', 'NIS033', 'ENSINO FUNDAMENTAL COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'COZINHEIRA', 'CAD033', 3, 'NEGRA', 'PRESSAO ALTA', 'PRESSAO ALTA'),
    ('Ximena Costa Ferreira', 36, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS034', 'ENSINO MEDIO INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'VENDEDORA AMBULANTE', 'CAD034', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Yasmin Souza Martins', 14, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS035', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PEDIATRA', 'CAD035', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Zelia Oliveira Gomes', 52, 'FURNAS', 'MULHER CISGENERO', 'NIS036', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'APOSENTADA', 'CAD036', 4, 'NEGRA', 'ARTRITE', 'ARTRITE'),
    ('Adriana Silva Costa', 30, 'SERRAGEM', 'MULHER CISGENERO', 'NIS037', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'CONSULTORA DE VENDAS', 'CAD037', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Bernadete Ferreira Rocha', 38, 'OCARA', 'MULHER CISGENERO', 'NIS038', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'AGENTE DE LIMPEZA', 'CAD038', 3, 'BRANCA', 'ASMA', 'ASMA'),
    ('Carmem Santos Souza', 25, 'SERENO', 'MULHER CISGENERO', 'NIS039', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ESTAGIARIA', 'CAD039', 0, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Dolores Gomes Alves', 47, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS040', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'ASSISTENTE SOCIAL', 'CAD040', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Erica Pereira Martins', 29, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS041', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'ENGENHEIRA', 'CAD041', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Francisca Silva Oliveira', 53, 'FURNAS', 'MULHER CISGENERO', 'NIS042', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'SERVICOS DOMESTICOS', 'CAD042', 3, 'NEGRA', 'DIABETES', 'DIABETES'),
    ('Geisiane Costa Santos', 34, 'SERRAGEM', 'MULHER CISGENERO', 'NIS043', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'AUXILIAR ADMINISTRATIVO', 'CAD043', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Helena Gomes Ferreira', 26, 'OCARA', 'MULHER CISGENERO', 'NIS044', 'ENSINO SUPERIOR INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'DESIGNER GRAFICO', 'CAD044', 0, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Iris Costa Barbosa', 40, 'SERENO', 'MULHER CISGENERO', 'NIS045', 'ENSINO FUNDAMENTAL COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'FAXINEIRA', 'CAD045', 3, 'NEGRA', 'PRESSAO ALTA', 'PRESSAO ALTA'),
    ('Jezabel Souza Oliveira', 45, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS046', 'ENSINO MEDIO INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'DONA DE CASA', 'CAD046', 4, 'PARDA', 'FIBROMIALGIA', 'FIBROMIALGIA'),
    ('Karen Silva Ferreira', 19, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS047', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'ADVOGADA', 'CAD047', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Lilia Pereira Gomes', 38, 'FURNAS', 'MULHER CISGENERO', 'NIS048', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'PROFESSORA UNIVERSITARIA', 'CAD048', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Miriam Santos Costa', 51, 'SERRAGEM', 'MULHER CISGENERO', 'NIS049', 'ENSINO FUNDAMENTAL COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'AUXILIAR DE BIBLIOTECA', 'CAD049', 3, 'PARDA', 'CARDIOPATIA', 'CARDIOPATIA'),
    ('Nair Oliveira Silva', 28, 'OCARA', 'MULHER CISGENERO', 'NIS050', 'ENSINO SUPERIOR INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'EDITORA', 'CAD050', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Odete Gomes Alves', 43, 'SERENO', 'MULHER CISGENERO', 'NIS051', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'CAIXA SUPERMERCADO', 'CAD051', 2, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Priscila Costa Souza', 35, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS052', 'ENSINO FUNDAMENTAL INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'VENDEDORA LOJA', 'CAD052', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Quezia Ferreira Martins', 15, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS053', 'ENSINO MEDIO INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'OPERADORA CAIXA', 'CAD053', 2, 'BRANCA', 'LUPUS', 'LUPUS'),
    ('Rosana Silva Pereira', 31, 'FURNAS', 'MULHER CISGENERO', 'NIS054', 'ENSINO SUPERIOR COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'PSICOLOGIA', 'CAD054', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Shirley Rocha Costa', 37, 'SERRAGEM', 'MULHER CISGENERO', 'NIS055', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'GERENTE DE RESTAURANTE', 'CAD055', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Telma Souza Oliveira', 44, 'OCARA', 'MULHER CISGENERO', 'NIS056', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'ENCANADORA', 'CAD056', 2, 'BRANCA', 'COLUNA DESVIADA', 'COLUNA DESVIADA'),
    ('Urania Gomes Santos', 27, 'SERENO', 'MULHER CISGENERO', 'NIS057', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ESTETICIEN', 'CAD057', 0, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Valeska Martins Ferreira', 42, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS058', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'VENDEDORA CONSIGNADO', 'CAD058', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Vivian Silva Costa', 55, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS059', 'ENSINO FUNDAMENTAL INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PENSIONISTA', 'CAD059', 4, 'BRANCA', 'PROBLEMAS CARDIACOS', 'PROBLEMAS CARDIACOS'),
    ('Xueling Santos Barbosa', 26, 'FURNAS', 'MULHER CISGENERO', 'NIS060', 'ENSINO SUPERIOR COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'FARMACEUTICA', 'CAD060', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Yara Oliveira Gomes', 39, 'SERRAGEM', 'MULHER CISGENERO', 'NIS061', 'ENSINO MEDIO INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'COMERCIANTE', 'CAD061', 3, 'PARDA', 'MIOPIA', 'MIOPIA'),
    ('Zenilda Costa Silva', 48, 'OCARA', 'MULHER CISGENERO', 'NIS062', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'VIGILANTE NOTURNO', 'CAD062', 2, 'BRANCA', 'HIPERTENSAO', 'HIPERTENSAO'),
    ('Abigail Silva Pereira', 34, 'SERENO', 'MULHER CISGENERO', 'NIS063', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'NUTRICIONISTA', 'CAD063', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Benedita Ferreira Alves', 46, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS064', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'OPERADORA TURISMO', 'CAD064', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Conceicao Gomes Rocha', 53, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS065', 'ENSINO FUNDAMENTAL INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'FAXINEIRA PREDIOS', 'CAD065', 3, 'BRANCA', 'ARTROSE', 'ARTROSE'),
    ('Divina Santos Souza', 41, 'FURNAS', 'MULHER CISGENERO', 'NIS066', 'ENSINO MEDIO INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'VENDEDORA LOJAS', 'CAD066', 2, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Eloiza Martins Costa', 29, 'SERRAGEM', 'MULHER CISGENERO', 'NIS067', 'ENSINO SUPERIOR COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'CONTADORA', 'CAD067', 1, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Fatima Silva Gomes', 37, 'OCARA', 'MULHER CISGENERO', 'NIS068', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'JARDINEIRA', 'CAD068', 2, 'BRANCA', 'PROBLEMAS AUDITIVOS', 'PROBLEMAS AUDITIVOS'),
    ('Gardenia Costa Oliveira', 25, 'SERENO', 'MULHER CISGENERO', 'NIS069', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'SOCIAL MEDIA', 'CAD069', 0, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Hulda Pereira Santos', 51, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS070', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'GERENTE BANCO', 'CAD070', 3, 'PARDA', 'PRESBIOPIA', 'PRESBIOPIA'),
    ('Ingrid Rocha Martins', 33, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS071', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'MOTORISTA UBER', 'CAD071', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Jacira Silva Ferreira', 73, 'FURNAS', 'MULHER CISGENERO', 'NIS072', 'ENSINO MEDIO INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'CONSULTOR IMOBIILIARIO', 'CAD072', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Kamila Souza Costa', 28, 'SERRAGEM', 'MULHER CISGENERO', 'NIS073', 'ENSINO SUPERIOR COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'ARQUITETA', 'CAD073', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Lidia Gomes Silva', 45, 'OCARA', 'MULHER CISGENERO', 'NIS074', 'ENSINO FUNDAMENTAL COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'COSTUREIRA FREELANCER', 'CAD074', 3, 'BRANCA', 'DISTIMIA', 'DISTIMIA'),
    ('Maira Oliveira Alves', 31, 'SERENO', 'MULHER CISGENERO', 'NIS075', 'ENSINO MEDIO COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'MODELO', 'CAD075', 1, 'NEGRA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Nilda Ferreira Souza', 44, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS076', 'ENSINO SUPERIOR INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'AUDITORA', 'CAD076', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Otavia Santos Costa', 37, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS077', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'MANICURE PEDICURE', 'CAD077', 3, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Palmira Costa Pereira', 42, 'FURNAS', 'MULHER CISGENERO', 'NIS078', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'DONA DE LANCHONETE', 'CAD078', 2, 'NEGRA', 'CEFALEIA CRONICA', 'CEFALEIA CRONICA'),
    ('Quirina Martins Gomes', 55, 'SERRAGEM', 'MULHER CISGENERO', 'NIS079', 'ENSINO MEDIO INCOMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'SUPERVISORA', 'CAD079', 4, 'PARDA', 'OSTEOPOROSE', 'OSTEOPOROSE'),
    ('Roberta Silva Rocha', 26, 'OCARA', 'MULHER CISGENERO', 'NIS080', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'PESQUISADORA', 'CAD080', 0, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Samara Gomes Dias', 37, 'SERRAGEM', 'MULHER CISGENERO', 'NIS081', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'TELEFONISTA', 'CAD081', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Thalia Silva Costa', 18, 'OCARA', 'MULHER CISGENERO', 'NIS082', 'ENSINO SUPERIOR COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'ARQUITETA', 'CAD082', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Ursula Martins Alves', 43, 'SERENO', 'MULHER CISGENERO', 'NIS083', 'ENSINO FUNDAMENTAL COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'SERVICOS GERAIS', 'CAD083', 3, 'NEGRA', 'ASMA', 'ASMA'),
    ('Vanessa Costa Rocha', 31, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS084', 'ENSINO MEDIO COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'SEGURANCA', 'CAD084', 2, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Wagner Silva Santos', 52, 'BAIXA GRANDE', 'MULHER CISGENERO', 'NIS085', 'ENSINO FUNDAMENTAL INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'APOSENTADA', 'CAD085', 4, 'NEGRA', 'ARTRITE', 'ARTRITE'),
    ('Ximena Pereira Gomes', 28, 'FURNAS', 'MULHER CISGENERO', 'NIS086', 'ENSINO SUPERIOR COMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'ENGENHEIRA', 'CAD086', 1, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Yasmin Oliveira Santos', 15, 'SERRAGEM', 'MULHER CISGENERO', 'NIS087', 'ENSINO MEDIO COMPLETO', 'ESPIRITA', 'BRASILEIRA', 'URBANA', 'ASSISTENTE SOCIAL', 'CAD087', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Zenaide Ferreira Costa', 34, 'OCARA', 'MULHER CISGENERO', 'NIS088', 'ENSINO FUNDAMENTAL COMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'COZINHEIRA', 'CAD088', 2, 'NEGRA', 'DIABETES', 'DIABETES'),
    ('Adelaide Martins Silva', 47, 'SERENO', 'MULHER CISGENERO', 'NIS089', 'ENSINO MEDIO INCOMPLETO', 'CATOLICA', 'BRASILEIRA', 'URBANA', 'LAVANDERIA', 'CAD089', 3, 'PARDA', 'NAO INFORMADO', 'NAO INFORMADO'),
    ('Bernadete Costa Alves', 39, 'JUAZEIRO', 'MULHER CISGENERO', 'NIS090', 'ENSINO SUPERIOR INCOMPLETO', 'EVANGELICA', 'BRASILEIRA', 'URBANA', 'COORDENADORA', 'CAD090', 2, 'BRANCA', 'NAO INFORMADO', 'NAO INFORMADO');

-- Povoamento Tabela FILHO

INSERT INTO FILHO (seq_filho, qtd_filhos_deficiencia, viu_violencia, violencia_gravidez, id_assistida, qtd_filho_agressor, qtd_filho_outro_relacionamento)
VALUES 
    (1, 0, true, false, 1, 2, 0),
    (2, 0, false, false, 2, 1, 0),
    (3, 1, true, true, 3, 2, 1),
    (4, 0, true, false, 4, 2, 0),
    (5, 0, false, false, 5, 0, 4),
    (6, 1, true, false, 6, 1, 0),
    (7, 0, false, true, 7, 2, 1),
    (8, 0, true, false, 8, 1, 1),
    (9, 2, true, true, 9, 3, 0),
    (10, 0, false, false, 10, 2, 2),
    (11, 1, true, false, 11, 1, 0),
    (12, 0, true, true, 12, 2, 1),
    (13, 0, false, false, 13, 2, 0),
    (14, 1, true, false, 14, 3, 2),
    (15, 0, false, true, 15, 1, 1),
    (16, 0, true, false, 16, 2, 0),
    (17, 1, false, false, 17, 2, 1),
    (18, 0, true, true, 18, 1, 0),
    (19, 0, false, false, 19, 3, 1),
    (20, 1, true, false, 20, 2, 0),
    (21, 0, false, true, 21, 1, 2),
    (22, 0, true, false, 22, 2, 1),
    (23, 2, true, true, 23, 3, 0),
    (24, 0, false, false, 24, 1, 1),
    (25, 1, true, false, 25, 2, 0),
    (26, 0, false, true, 26, 2, 1),
    (27, 0, true, false, 27, 4, 0),
    (28, 1, true, true, 28, 1, 2),
    (29, 0, false, false, 29, 2, 1),
    (30, 0, true, false, 30, 3, 0),
    (31, 1, false, false, 31, 2, 0),
    (32, 0, true, true, 32, 1, 1),
    (33, 0, false, false, 33, 3, 0),
    (34, 1, true, false, 34, 2, 1),
    (35, 0, false, true, 35, 1, 0),
    (36, 0, true, false, 36, 4, 1),
    (37, 1, true, true, 37, 2, 0),
    (38, 0, false, false, 38, 3, 1),
    (39, 1, true, false, 39, 1, 0),
    (40, 0, false, true, 40, 2, 2),
    (41, 0, true, false, 41, 2, 0),
    (42, 1, false, false, 42, 3, 1),
    (43, 0, true, true, 43, 1, 0),
    (44, 0, false, false, 44, 2, 1),
    (45, 1, true, false, 45, 4, 0),
    (46, 0, false, true, 46, 1, 1),
    (47, 0, true, false, 47, 2, 0),
    (48, 1, true, true, 48, 3, 1),
    (49, 0, false, false, 49, 2, 0),
    (50, 1, true, false, 50, 1, 2),
    (51, 0, false, true, 51, 2, 0),
    (52, 0, true, false, 52, 3, 1),
    (53, 1, true, true, 53, 1, 0),
    (54, 0, false, false, 54, 4, 1),
    (55, 1, true, false, 55, 2, 0),
    (56, 0, false, true, 56, 2, 1),
    (57, 0, true, false, 57, 1, 0),
    (58, 1, false, false, 58, 3, 1),
    (59, 0, true, true, 59, 2, 0),
    (60, 0, false, false, 60, 4, 2),
    (61, 1, true, false, 61, 1, 0),
    (62, 0, false, true, 62, 2, 1),
    (63, 0, true, false, 63, 3, 0),
    (64, 1, true, true, 64, 2, 1),
    (65, 0, false, false, 65, 1, 0),
    (66, 0, true, false, 66, 2, 1),
    (67, 1, false, false, 67, 3, 0),
    (68, 0, true, true, 68, 1, 1),
    (69, 0, false, false, 69, 4, 0),
    (70, 1, true, false, 70, 2, 1),
    (71, 0, false, true, 71, 2, 0),
    (72, 0, true, false, 72, 1, 2),
    (73, 1, true, true, 73, 3, 0),
    (74, 0, false, false, 74, 2, 1),
    (75, 0, true, false, 75, 2, 0),
    (76, 1, false, false, 76, 4, 1),
    (77, 0, true, true, 77, 1, 0),
    (78, 0, false, false, 78, 3, 1),
    (79, 1, true, false, 79, 2, 0),
    (80, 0, false, true, 80, 2, 1);


-- Povoamento Tabela FAIXA_FILHO
INSERT INTO FAIXA_FILHO (id_assistida, id_filhos, faixa_etaria)
VALUES 
    (1, 1, '0 A 11 ANOS'),
    (2, 2, '12 A 17 ANOS'),
    (3, 3, '0 A 11 ANOS'),
    (4, 4, '12 A 17 ANOS'),
    (5, 5, 'A PARTIR DE 18 ANOS'),
    (6, 6, '12 A 17 ANOS'),
    (7, 7, '0 A 11 ANOS'),
    (8, 8, 'A PARTIR DE 18 ANOS'),
    (9, 9, '0 A 11 ANOS'),
    (10, 10, '12 A 17 ANOS'),
    (11, 11, '12 A 17 ANOS'),
    (12, 12, '0 A 11 ANOS'),
    (13, 13, 'A PARTIR DE 18 ANOS'),
    (14, 14, '0 A 11 ANOS'),
    (15, 15, '12 A 17 ANOS'),
    (16, 16, '12 A 17 ANOS'),
    (17, 17, '0 A 11 ANOS'),
    (18, 18, '12 A 17 ANOS'),
    (19, 19, '0 A 11 ANOS'),
    (20, 20, 'A PARTIR DE 18 ANOS'),
    (21, 21, '12 A 17 ANOS'),
    (22, 22, '0 A 11 ANOS'),
    (23, 23, '0 A 11 ANOS'),
    (24, 24, '12 A 17 ANOS'),
    (25, 25, '12 A 17 ANOS'),
    (26, 26, '0 A 11 ANOS'),
    (27, 27, 'A PARTIR DE 18 ANOS'),
    (28, 28, '12 A 17 ANOS'),
    (29, 29, '0 A 11 ANOS'),
    (30, 30, 'A PARTIR DE 18 ANOS'),
    (31, 31, '0 A 11 ANOS'),
    (32, 32, '12 A 17 ANOS'),
    (33, 33, '0 A 11 ANOS'),
    (34, 34, '12 A 17 ANOS'),
    (35, 35, 'A PARTIR DE 18 ANOS'),
    (36, 36, '12 A 17 ANOS'),
    (37, 37, '0 A 11 ANOS'),
    (38, 38, 'A PARTIR DE 18 ANOS'),
    (39, 39, '0 A 11 ANOS'),
    (40, 40, '12 A 17 ANOS'),
    (41, 41, '12 A 17 ANOS'),
    (42, 42, '0 A 11 ANOS'),
    (43, 43, 'A PARTIR DE 18 ANOS'),
    (44, 44, '0 A 11 ANOS'),
    (45, 45, '12 A 17 ANOS'),
    (46, 46, '12 A 17 ANOS'),
    (47, 47, '0 A 11 ANOS'),
    (48, 48, '12 A 17 ANOS'),
    (49, 49, '0 A 11 ANOS'),
    (50, 50, 'A PARTIR DE 18 ANOS'),
    (51, 51, '12 A 17 ANOS'),
    (52, 52, '0 A 11 ANOS'),
    (53, 53, '0 A 11 ANOS'),
    (54, 54, '12 A 17 ANOS'),
    (55, 55, '12 A 17 ANOS'),
    (56, 56, '0 A 11 ANOS'),
    (57, 57, 'A PARTIR DE 18 ANOS'),
    (58, 58, '12 A 17 ANOS'),
    (59, 59, '0 A 11 ANOS'),
    (60, 60, 'A PARTIR DE 18 ANOS'),
    (61, 61, '0 A 11 ANOS'),
    (62, 62, '12 A 17 ANOS'),
    (63, 63, '0 A 11 ANOS'),
    (64, 64, '12 A 17 ANOS'),
    (65, 65, 'A PARTIR DE 18 ANOS'),
    (66, 66, '12 A 17 ANOS'),
    (67, 67, '0 A 11 ANOS'),
    (68, 68, 'A PARTIR DE 18 ANOS'),
    (69, 69, '0 A 11 ANOS'),
    (70, 70, '12 A 17 ANOS'),
    (71, 71, '12 A 17 ANOS'),
    (72, 72, '0 A 11 ANOS'),
    (73, 73, 'A PARTIR DE 18 ANOS'),
    (74, 74, '0 A 11 ANOS'),
    (75, 75, '12 A 17 ANOS'),
    (76, 76, '12 A 17 ANOS'),
    (77, 77, '0 A 11 ANOS'),
    (78, 78, '12 A 17 ANOS'),
    (79, 79, '0 A 11 ANOS'),
    (80, 80, 'A PARTIR DE 18 ANOS');

-- Povoamento Tabela CONFLITO_FILHO
INSERT INTO CONFLITO_FILHO (tipo_conflito, id_assistida, seq_filho)
VALUES 
    ('SIM, GUARDA DO(S) FILHO(S)', 1, 1),
    ('SIM, VISITAS', 2, 2),
    ('SIM, PAGAMENTO DE PENSAO', 3, 3),
    ('NAO', 4, 4),
    ('SIM, GUARDA DO(S) FILHO(S)', 5, 5),
    ('SIM, VISITAS', 6, 6),
    ('SIM, PAGAMENTO DE PENSAO', 7, 7),
    ('NAO', 8, 8),
    ('SIM, GUARDA DO(S) FILHO(S)', 9, 9),
    ('SIM, VISITAS', 10, 10),
    ('SIM, PAGAMENTO DE PENSAO', 11, 11),
    ('NAO', 12, 12),
    ('SIM, GUARDA DO(S) FILHO(S)', 13, 13),
    ('SIM, VISITAS', 14, 14),
    ('SIM, PAGAMENTO DE PENSAO', 15, 15),
    ('NAO', 16, 16),
    ('SIM, GUARDA DO(S) FILHO(S)', 17, 17),
    ('SIM, VISITAS', 18, 18),
    ('SIM, PAGAMENTO DE PENSAO', 19, 19),
    ('NAO', 20, 20),
    ('SIM, GUARDA DO(S) FILHO(S)', 21, 21),
    ('SIM, VISITAS', 22, 22),
    ('SIM, PAGAMENTO DE PENSAO', 23, 23),
    ('NAO', 24, 24),
    ('SIM, GUARDA DO(S) FILHO(S)', 25, 25),
    ('SIM, VISITAS', 26, 26),
    ('SIM, PAGAMENTO DE PENSAO', 27, 27),
    ('NAO', 28, 28),
    ('SIM, GUARDA DO(S) FILHO(S)', 29, 29),
    ('SIM, VISITAS', 30, 30),
    ('SIM, PAGAMENTO DE PENSAO', 31, 31),
    ('NAO', 32, 32),
    ('SIM, GUARDA DO(S) FILHO(S)', 33, 33),
    ('SIM, VISITAS', 34, 34),
    ('SIM, PAGAMENTO DE PENSAO', 35, 35),
    ('NAO', 36, 36),
    ('SIM, GUARDA DO(S) FILHO(S)', 37, 37),
    ('SIM, VISITAS', 38, 38),
    ('SIM, PAGAMENTO DE PENSAO', 39, 39),
    ('NAO', 40, 40),
    ('SIM, GUARDA DO(S) FILHO(S)', 41, 41),
    ('SIM, VISITAS', 42, 42),
    ('SIM, PAGAMENTO DE PENSAO', 43, 43),
    ('NAO', 44, 44),
    ('SIM, GUARDA DO(S) FILHO(S)', 45, 45),
    ('SIM, VISITAS', 46, 46),
    ('SIM, PAGAMENTO DE PENSAO', 47, 47),
    ('NAO', 48, 48),
    ('SIM, GUARDA DO(S) FILHO(S)', 49, 49),
    ('SIM, VISITAS', 50, 50),
    ('SIM, PAGAMENTO DE PENSAO', 51, 51),
    ('NAO', 52, 52),
    ('SIM, GUARDA DO(S) FILHO(S)', 53, 53),
    ('SIM, VISITAS', 54, 54),
    ('SIM, PAGAMENTO DE PENSAO', 55, 55),
    ('NAO', 56, 56),
    ('SIM, GUARDA DO(S) FILHO(S)', 57, 57),
    ('SIM, VISITAS', 58, 58),
    ('SIM, PAGAMENTO DE PENSAO', 59, 59),
    ('NAO', 60, 60),
    ('SIM, GUARDA DO(S) FILHO(S)', 61, 61),
    ('SIM, VISITAS', 62, 62),
    ('SIM, PAGAMENTO DE PENSAO', 63, 63),
    ('NAO', 64, 64),
    ('SIM, GUARDA DO(S) FILHO(S)', 65, 65),
    ('SIM, VISITAS', 66, 66),
    ('SIM, PAGAMENTO DE PENSAO', 67, 67),
    ('NAO', 68, 68),
    ('SIM, GUARDA DO(S) FILHO(S)', 69, 69),
    ('SIM, VISITAS', 70, 70),
    ('SIM, PAGAMENTO DE PENSAO', 71, 71),
    ('NAO', 72, 72),
    ('SIM, GUARDA DO(S) FILHO(S)', 73, 73),
    ('SIM, VISITAS', 74, 74),
    ('SIM, PAGAMENTO DE PENSAO', 75, 75),
    ('NAO', 76, 76),
    ('SIM, GUARDA DO(S) FILHO(S)', 77, 77),
    ('SIM, VISITAS', 78, 78),
    ('SIM, PAGAMENTO DE PENSAO', 79, 79),
    ('NAO', 80, 80);

-- Povoamento Tabela CASO
INSERT INTO CASO (Data, separacao, novo_relac, abrigo, depen_finc, mora_risco, medida, frequencia, id_assistida, outras_informacoes)
VALUES 
    ('2025-11-20', 'SIM', false, false, true, 'SIM', true, true, 1, 'SITUACAO DE RISCO MODERADO. ACOMPANHAMENTO CONTINUO NECESSARIO.'),
    ('2025-11-18', 'NAO', true, false, false, 'NAO', false, false, 2, 'NOVO RELACIONAMENTO CAUSOU AUMENTO NA AGRESSAO VERBAL.'),
    ('2025-11-15', 'SIM', false, true, true, 'SIM', true, true, 3, 'SITUACAO CRITICA. RECOMENDADO ABRIGAMENTO TEMPORARIO.'),
    ('2025-11-22', 'NAO', false, false, true, 'SIM', true, true, 4, 'CASOS DE VIOLENCIA FISICA RECORRENTES.'),
    ('2025-11-10', 'SIM', false, false, false, 'NAO', false, false, 5, 'ACOMPANHAMENTO PSICOSSOCIAL EM ANDAMENTO.'),
    ('2025-11-19', 'SIM', false, false, true, 'NAO', true, false, 6, 'DENUNCIADO AOS ORGAOS COMPETENTES.'),
    ('2025-11-17', 'NAO', true, false, false, 'SIM', false, true, 7, 'ENCAMINHAMENTO PARA ABRIGO REALIZADO.'),
    ('2025-11-16', 'SIM', false, true, true, 'SIM', true, true, 8, 'VIOLENCIA INTRAFAMILIAR CONFIRMADA.'),
    ('2025-11-21', 'NAO', false, false, true, 'NAO', false, false, 9, 'NECESSARIO ACOMPANHAMENTO MENSAL.'),
    ('2025-11-14', 'SIM', true, false, false, 'SIM', true, false, 10, 'MEDIDA PROTETIVA EM VIGOR.'),
    ('2025-11-12', 'NAO', false, true, true, 'NAO', false, true, 11, 'CASO ENCERRADO COM SUCESSO.'),
    ('2025-11-11', 'SIM', false, false, false, 'SIM', true, true, 12, 'ACOMPANHAMENTO PSICOLOGICO NECESSARIO.'),
    ('2025-11-23', 'NAO', true, false, true, 'NAO', false, false, 13, 'RENDA FAMILIAR INSUFICIENTE.'),
    ('2025-11-09', 'SIM', false, true, true, 'SIM', true, true, 14, 'CRIANCAS NECESSITAM DE PROTECAO.'),
    ('2025-11-08', 'NAO', false, false, false, 'NAO', false, false, 15, 'RELACOES FAMILIARES ESTABILIZADAS.'),
    ('2025-11-24', 'SIM', true, false, true, 'SIM', true, false, 16, 'VIOLENCIA DOMESTICA COMPROVADA.'),
    ('2025-11-07', 'NAO', false, true, false, 'NAO', false, true, 17, 'ABRIGAMENTO CONTINUA INDICADO.'),
    ('2025-11-25', 'SIM', false, false, true, 'SIM', true, true, 18, 'REINCIDENCIA DE AGRESSOES.'),
    ('2025-11-06', 'NAO', true, false, false, 'NAO', false, false, 19, 'ESTABILIDADE ALCANCADA.'),
    ('2025-11-05', 'SIM', false, true, true, 'SIM', true, true, 20, 'PROTECAO DE MENORES PRIORITARIA.'),
    ('2025-11-04', 'NAO', false, false, true, 'NAO', false, false, 21, 'ACOMPANHAMENTO SOCIOECONOMICO.'),
    ('2025-11-03', 'SIM', true, false, false, 'SIM', true, false, 22, 'NOVO CASAL REQUER INTERVENCAO.'),
    ('2025-11-02', 'NAO', false, true, true, 'NAO', false, true, 23, 'ABRIGAMENTO TEMPORARIO CONCLUIDO.'),
    ('2025-11-01', 'SIM', false, false, true, 'SIM', true, true, 24, 'NECESSARIA REAVALIACAO DO CASO.'),
    ('2025-10-31', 'NAO', true, false, false, 'NAO', false, false, 25, 'CLIENTE SATISFEITA COM ACOMPANHAMENTO.'),
    ('2025-10-30', 'SIM', false, true, true, 'SIM', true, true, 26, 'CRISE CONJUGAL SUPERADA.'),
    ('2025-10-29', 'NAO', false, false, true, 'NAO', false, false, 27, 'VIGILANCIA CONTINUADA.'),
    ('2025-10-28', 'SIM', true, false, false, 'SIM', true, false, 28, 'VIOLENCIA PSICOLOGICA DOCUMENTADA.'),
    ('2025-10-27', 'NAO', false, true, true, 'NAO', false, true, 29, 'ABRIGO PARA FILHOS NECESSARIO.'),
    ('2025-10-26', 'SIM', false, false, true, 'SIM', true, true, 30, 'CASO EM ACOMPANHAMENTO CONTINUO'),
    ('2025-10-25', 'SIM', true, false, false, 'SIM', true, false, 31, 'VIOLENCIA ECONOMICA DOCUMENTADA.'),
    ('2025-10-24', 'NAO', false, true, true, 'NAO', false, true, 32, 'ACOMPANHAMENTO ASSISTENCIA SOCIAL.'),
    ('2025-10-23', 'SIM', false, false, true, 'SIM', true, true, 33, 'RISCO IMINENTE DE MORTE.'),
    ('2025-10-22', 'NAO', true, false, false, 'NAO', false, false, 34, 'MEDIDA PROTETIVA VIGENTE.'),
    ('2025-10-21', 'SIM', false, true, true, 'SIM', true, true, 35, 'VIOLENCIA CONTRA CRIANCAS CONFIRMADA.'),
    ('2025-10-20', 'NAO', false, false, true, 'NAO', false, false, 36, 'ENCAMINHAMENTO PARA RENDA EMERGENCIAL.'),
    ('2025-10-19', 'SIM', true, false, false, 'SIM', true, false, 37, 'SITUACAO SOCIAL CRITICA.'),
    ('2025-10-18', 'NAO', false, true, true, 'NAO', false, true, 38, 'ASSISTIDA EM ABRIGO TEMPORARIO.'),
    ('2025-10-17', 'SIM', false, false, true, 'SIM', true, true, 39, 'ORIENTACAO LEGAL NECESSARIA.'),
    ('2025-10-16', 'NAO', true, false, false, 'NAO', false, false, 40, 'CASO ESTAVEL COM SUPORTE.'),
    ('2025-10-15', 'SIM', false, true, true, 'SIM', true, true, 41, 'FILHOS PRECISAM PROTECAO IMEDIATA.'),
    ('2025-10-14', 'NAO', false, false, true, 'NAO', false, false, 42, 'ATENDIMENTO PSICOLOGICO INICIADO.'),
    ('2025-10-13', 'SIM', true, false, false, 'SIM', true, false, 43, 'AGRESSOR COM RESTRICOES JUDICIAIS.'),
    ('2025-10-12', 'NAO', false, true, true, 'NAO', false, true, 44, 'ABRIGAMENTO PROLONGADO NECESSARIO.'),
    ('2025-10-11', 'SIM', false, false, true, 'SIM', true, true, 45, 'REDE DE APOIO ATIVADA.'),
    ('2025-10-10', 'NAO', true, false, false, 'NAO', false, false, 46, 'DOCUMENTACAO COMPLETA REALIZADA.'),
    ('2025-10-09', 'SIM', false, true, true, 'SIM', true, true, 47, 'MEDIDA CAUTELAR SOLICITADA.'),
    ('2025-10-08', 'NAO', false, false, true, 'NAO', false, false, 48, 'ACOMPANHAMENTO CONTINUO ESTABELECIDO.'),
    ('2025-10-07', 'SIM', true, false, false, 'SIM', true, false, 49, 'VIOLENCIA RECORRENTE DOCUMENTADA.'),
    ('2025-10-06', 'NAO', false, true, true, 'NAO', false, true, 50, 'CASO REABERTO POR NOVAS QUEIXAS.'),
    ('2025-10-05', 'SIM', false, false, true, 'SIM', true, true, 51, 'SITUACAO CONTROLADA COM INTERVENCAO.'),
    ('2025-10-04', 'NAO', true, false, false, 'NAO', false, false, 52, 'PSICOLOGO DESIGNADO AO CASO.'),
    ('2025-10-03', 'SIM', false, true, true, 'SIM', true, true, 53, 'RISCO DE RETALIACOES IDENTIFICADO.'),
    ('2025-10-02', 'NAO', false, false, true, 'NAO', false, false, 54, 'ENCAMINHAMENTO EDUCACIONAL REALIZADO.'),
    ('2025-10-01', 'SIM', true, false, false, 'SIM', true, false, 55, 'AGRESSOR SOB MONITORAMENTO.'),
    ('2025-09-30', 'NAO', false, true, true, 'NAO', false, true, 56, 'ABRIGO PARA FAMILIARES ACIONADO.'),
    ('2025-09-29', 'SIM', false, false, true, 'SIM', true, true, 57, 'VIOLENCIA PROGRESSIVA DOCUMENTADA.'),
    ('2025-09-28', 'NAO', true, false, false, 'NAO', false, false, 58, 'RECONCILIACAO NAO RECOMENDADA.'),
    ('2025-09-27', 'SIM', false, true, true, 'SIM', true, true, 59, 'FILHOS COM TRAUMA PSICOLOGICO.'),
    ('2025-09-26', 'NAO', false, false, true, 'NAO', false, false, 60, 'TRABALHO SOCIAL INTENSIFICADO.'),
    ('2025-09-25', 'SIM', true, false, false, 'SIM', true, false, 61, 'DENANCIA CRIMINAL FORMALIZADA.'),
    ('2025-09-24', 'NAO', false, true, true, 'NAO', false, true, 62, 'ASSISTIDA RECEBENDO BENEFICIO EMERGENCIAL.'),
    ('2025-09-23', 'SIM', false, false, true, 'SIM', true, true, 63, 'MONITORACAO ELETRONICA SOLICITADA.'),
    ('2025-09-22', 'NAO', true, false, false, 'NAO', false, false, 64, 'ACOMPANHAMENTO LEGAL CONTINUADO.'),
    ('2025-09-21', 'SIM', false, true, true, 'SIM', true, true, 65, 'VIOLENCIA INSTITUCIONAL DOCUMENTADA.'),
    ('2025-09-20', 'NAO', false, false, true, 'NAO', false, false, 66, 'ATENDIMENTO MULTIDISCIPLINAR ATIVO.'),
    ('2025-09-19', 'SIM', true, false, false, 'SIM', true, false, 67, 'AGRESSOR RETIRADO DO DOMICILIO.'),
    ('2025-09-18', 'NAO', false, true, true, 'NAO', false, true, 68, 'CRIANCAS EM GUARDA COMPARTILHADA.'),
    ('2025-09-17', 'SIM', false, false, true, 'SIM', true, true, 69, 'RENDA FAMILIAR CRITICA RESOLVIDA.'),
    ('2025-09-16', 'NAO', true, false, false, 'NAO', false, false, 70, 'ACOMPANHAMENTO PREVENTIVO INICIADO.'),
    ('2025-09-15', 'SIM', false, true, true, 'SIM', true, true, 71, 'VULNERABILIDADE SOCIAL REDUZIDA.'),
    ('2025-09-14', 'NAO', false, false, true, 'NAO', false, false, 72, 'APOIO FAMILIAR FORTALECIDO.'),
    ('2025-09-13', 'SIM', true, false, false, 'SIM', true, false, 73, 'AGRESSOR APRESENTA RISCO MODERADO.'),
    ('2025-09-12', 'NAO', false, true, true, 'NAO', false, true, 74, 'ASSISTIDA RETORNOU AO ABRIGO.'),
    ('2025-09-11', 'SIM', false, false, true, 'SIM', true, true, 75, 'PROCESSO JUDICIAL EM ANDAMENTO.'),
    ('2025-09-10', 'NAO', true, false, false, 'NAO', false, false, 76, 'ACOMPANHAMENTO REGULAR CONFIRMADO.'),
    ('2025-09-09', 'SIM', false, true, true, 'SIM', true, true, 77, 'ORIENTACAO SOBRE DIREITOS EFETIVADA.'),
    ('2025-09-08', 'NAO', false, false, true, 'NAO', false, false, 78, 'ROMPIMENTO COM AGRESSOR CONSOLIDADO.'),
    ('2025-09-07', 'SIM', true, false, false, 'SIM', true, false, 79, 'SITUACAO ESTAVEL E MONITORADA.'),
    ('2025-09-06', 'NAO', false, true, true, 'NAO', false, true, 80, 'CASE MANAGEMENT CONCLUIDO COM SUCESSO'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 81, 'PRIMEIRO CASO - VIOLENCIA INICIAL DOCUMENTADA.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 81, 'SEGUNDO CASO - REINCIDENCIA POS SEPARACAO.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 81, 'TERCEIRO CASO - SITUACAO REABERTA.'),
    ('2025-11-26', 'NAO', true, false, false, 'NAO', false, false, 81, 'QUARTO CASO - NOVO RELACIONAMENTO VIOLENTO.'),
    ('2025-11-26', 'SIM', false, true, true, 'SIM', true, true, 82, 'PRIMEIRO CASO - AGRESSAO PSICOLOGICA.'),
    ('2025-11-26', 'NAO', false, false, true, 'NAO', false, false, 82, 'SEGUNDO CASO - ACOMPANHAMENTO CONTINUO.'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 82, 'TERCEIRO CASO - VIOLENCIA FISICA.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 83, 'PRIMEIRO CASO - DENUNDA FORMALIZADA.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 83, 'SEGUNDO CASO - MEDIDA PROTETIVA VIGENTE.'),
    ('2025-11-26', 'NAO', true, false, false, 'NAO', false, false, 83, 'TERCEIRO CASO - ROMPIMENTO COM AGRESSOR.'),
    ('2025-11-26', 'SIM', false, true, true, 'SIM', true, true, 84, 'PRIMEIRO CASO - VIOLENCIA CONTRA FILHOS.'),
    ('2025-11-26', 'NAO', false, false, true, 'NAO', false, false, 84, 'SEGUNDO CASO - ABRIGAMENTO TEMPORARIO.'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 84, 'TERCEIRO CASO - RETORNO AO DOMICILIO.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 85, 'PRIMEIRO CASO - SITUACAO CRITICA.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 85, 'SEGUNDO CASO - INTERVENCAO MULTIDISCIPLINAR.'),
    ('2025-11-26', 'NAO', true, false, false, 'NAO', false, false, 85, 'TERCEIRO CASO - ESTABILIDADE ALCANCADA.'),
    ('2025-11-26', 'SIM', false, true, true, 'SIM', true, true, 86, 'PRIMEIRO CASO - VIOLENCIA ECONOMICA.'),
    ('2025-11-26', 'NAO', false, false, true, 'NAO', false, false, 86, 'SEGUNDO CASO - INDEPENDENCIA FINANCEIRA.'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 86, 'TERCEIRO CASO - NOVA AMEACA.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 87, 'PRIMEIRO CASO - ABUSOS REPETITIVOS.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 87, 'SEGUNDO CASO - PROTECAO DE MENORES.'),
    ('2025-11-26', 'NAO', true, false, false, 'NAO', false, false, 87, 'TERCEIRO CASO - ENCERRAMENTO COM SUCESSO.'),
    ('2025-11-26', 'SIM', false, true, true, 'SIM', true, true, 88, 'PRIMEIRO CASO - DENANCIA CRIMINAL.'),
    ('2025-11-26', 'NAO', false, false, true, 'NAO', false, false, 88, 'SEGUNDO CASO - AGUARDANDO JULGAMENTO.'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 88, 'TERCEIRO CASO - RECONCILIACAO FRACASSADA.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 89, 'PRIMEIRO CASO - RISCO IMINENTE.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 89, 'SEGUNDO CASO - ABRIGAMENTO PROLONGADO.'),
    ('2025-11-26', 'NAO', true, false, false, 'NAO', false, false, 89, 'TERCEIRO CASO - REINSERCAO SOCIAL.'),
    ('2025-11-26', 'SIM', false, true, true, 'SIM', true, true, 90, 'PRIMEIRO CASO - VIOLENCIA INTRAFAMILIAR.'),
    ('2025-11-26', 'NAO', false, false, true, 'NAO', false, false, 90, 'SEGUNDO CASO - ACOMPANHAMENTO PSICOLOGICO.'),
    ('2025-11-26', 'SIM', true, false, false, 'SIM', true, false, 90, 'TERCEIRO CASO - RETOMADA DE VIDA.'),
    ('2025-11-26', 'NAO', false, true, true, 'NAO', false, true, 81, 'QUINTO CASO - NOVA AMEACA.'),
    ('2025-11-26', 'SIM', false, false, true, 'SIM', true, true, 85, 'QUARTO CASO - MONITORAMENTO CONTINUO.');

-- Povoamento Tabela AGRESSOR
INSERT INTO AGRESSOR (id_caso, id_assistida, Nome, Idade, Vinculo, doenca, medida_protetiva, suicidio, financeiro, arma_de_fogo)
VALUES 
    (1, 1, 'Carlos Alberto Santos', 40, 'MARIDO', '', false, false, true, false),
    (2, 2, 'Roberto Costa Silva', 32, 'COMPANHEIRO', 'DEPRESSAO', true, false, false, false),
    (3, 3, 'Marcos Oliveira', 45, 'MARIDO', 'TRANSTORNO DE PERSONALIDADE', true, true, true, true),
    (4, 4, 'João Paulo Ribeiro', 38, 'COMPANHEIRO', '', false, false, true, false),
    (5, 5, 'Pedro Ferreira Costa', 50, 'EX-MARIDO', '', false, false, false, false),
    (6, 6, 'Lucas Silva Santos', 35, 'MARIDO', 'ANSIEDADE', false, false, true, false),
    (7, 7, 'Fernando Costa Oliveira', 42, 'COMPANHEIRO', '', true, false, false, false),
    (8, 8, 'Antonio Ferreira Alves', 48, 'MARIDO', 'BIPOLARIDADE', true, true, true, true),
    (9, 9, 'Gustavo Silva Rocha', 39, 'EX-COMPANHEIRO', '', false, false, false, false),
    (10, 10, 'Diego Martins Pereira', 33, 'MARIDO', 'ALCOOLISMO', false, false, true, false),
    (11, 11, 'Rafael Gomes Costa', 44, 'COMPANHEIRO', '', true, false, false, true),
    (12, 12, 'Thiago Santos Souza', 36, 'MARIDO', 'TRANSTORNO MENTAL', false, true, true, false),
    (13, 13, 'Rodrigo Oliveira Silva', 41, 'EX-MARIDO', '', false, false, true, false),
    (14, 14, 'Fabio Costa Ferreira', 37, 'COMPANHEIRO', 'DEPRESSAO', true, false, true, true),
    (15, 15, 'Bruno Alves Pereira', 46, 'MARIDO', '', false, false, false, false),
    (16, 16, 'Eduardo Silva Gomes', 34, 'COMPANHEIRO', 'PSICOPATIA', true, true, true, true),
    (17, 17, 'Henrique Martins Costa', 52, 'EX-MARIDO', '', false, false, false, false),
    (18, 18, 'Leandro Santos Oliveira', 62, 'MARIDO', 'ALCOOLISMO', true, false, true, false),
    (19, 19, 'Matheus Ferreira Silva', 38, 'COMPANHEIRO', '', false, false, false, true),
    (20, 20, 'Paulo Rocha Alves', 43, 'MARIDO', 'TRANSTORNO DE HUMOR', false, true, true, false),
    (21, 21, 'Vitor Costa Souza', 35, 'EX-COMPANHEIRO', '', true, false, true, false),
    (22, 22, 'Ulisses Silva Pereira', 47, 'MARIDO', 'DEPENDENCIA QUIMICA', false, false, false, true),
    (23, 23, 'Cesar Oliveira Martins', 39, 'COMPANHEIRO', '', true, true, true, false),
    (24, 24, 'Danilo Gomes Costa', 36, 'MARIDO', 'AGRESSIVIDADE PATOLOGICA', false, false, false, false),
    (25, 25, 'Everton Ferreira Alves', 44, 'EX-MARIDO', '', false, false, true, true),
    (26, 26, 'Flavio Santos Silva', 41, 'COMPANHEIRO', 'TRANSTORNO OBSESSIVO', true, false, true, false),
    (27, 27, 'Gilberto Costa Oliveira', 50, 'MARIDO', '', false, true, false, false),
    (28, 28, 'Helio Martins Rocha', 37, 'EX-COMPANHEIRO', 'NARSISSISMO', true, false, true, true),
    (29, 29, 'Igor Silva Ferreira', 43, 'MARIDO', '', false, false, true, false),
    (30, 30, 'Julio Alves Souza', 38, 'COMPANHEIRO', 'ALCOOLISMO CRONICO', true, true, true, false),
    (31, 31, 'Kaio Martins Barbosa', 36, 'MARIDO', '', false, false, false, false),
    (32, 32, 'Lourival Gomes Costa', 52, 'COMPANHEIRO', 'DEPRESSAO', true, false, true, true),
    (33, 33, 'Marcelo Ferreira Silva', 41, 'EX-MARIDO', '', false, true, true, false),
    (34, 34, 'Nelio Costa Rocha', 39, 'MARIDO', 'TRANSTORNO DE PERSONALIDADE', false, false, false, false),
    (35, 35, 'Olegario Alves Santos', 45, 'COMPANHEIRO', '', true, false, true, true),
    (36, 36, 'Paulo Fernandes Oliveira', 38, 'MARIDO', 'ALCOOLISMO', false, true, true, false),
    (37, 37, 'Quincy Silva Barbosa', 44, 'EX-COMPANHEIRO', '', false, false, false, false),
    (38, 38, 'Ronaldo Martins Costa', 51, 'MARIDO', 'BIPOLARIDADE', true, false, true, true),
    (39, 39, 'Samuel Gomes Ferreira', 35, 'COMPANHEIRO', '', true, true, true, false),
    (40, 40, 'Tiago Rocha Silva', 48, 'EX-MARIDO', 'ANSIEDADE', false, false, false, false),
    (41, 41, 'Ubiratan Costa Alves', 42, 'MARIDO', '', false, false, true, true),
    (42, 42, 'Vanderlei Ferreira Santos', 37, 'COMPANHEIRO', 'DEPRESSAO', true, false, false, false),
    (43, 43, 'Wagner Oliveira Silva', 46, 'EX-MARIDO', '', true, true, true, true),
    (44, 44, 'Xandro Barbosa Costa', 33, 'MARIDO', 'TRANSTORNO MENTAL', false, false, true, false),
    (45, 45, 'Yuri Silva Gomes', 39, 'COMPANHEIRO', '', false, false, false, false),
    (46, 46, 'Zetho Alves Rocha', 55, 'EX-MARIDO', 'ALCOOLISMO', true, false, true, true),
    (47, 47, 'Ailton Costa Ferreira', 40, 'MARIDO', '', false, true, true, false),
    (48, 48, 'Beltrano Martins Silva', 36, 'COMPANHEIRO', 'PSICOPATIA', true, false, false, false),
    (49, 49, 'Cristovao Gomes Alves', 43, 'EX-MARIDO', '', false, false, true, true),
    (50, 50, 'Demetrio Ferreira Costa', 38, 'MARIDO', 'DEPRESSAO', false, true, true, false),
    (51, 51, 'Evaristo Silva Barbosa', 47, 'COMPANHEIRO', '', true, false, false, false),
    (52, 52, 'Feliciano Rocha Oliveira', 42, 'EX-MARIDO', 'TRANSTORNO DE PERSONALIDADE', true, false, true, true),
    (53, 53, 'Getulio Costa Santos', 35, 'MARIDO', '', false, true, true, false),
    (54, 54, 'Heitor Alves Martins', 50, 'COMPANHEIRO', 'ALCOOLISMO', false, false, false, false),
    (55, 55, 'Isidoro Ferreira Silva', 44, 'EX-MARIDO', '', true, false, true, true),
    (56, 56, 'Januario Gomes Costa', 39, 'MARIDO', 'ANSIEDADE', false, true, true, false),
    (57, 57, 'Kunisada Silva Rocha', 48, 'COMPANHEIRO', '', false, false, false, false),
    (58, 58, 'Leopoldo Barbosa Alves', 36, 'EX-MARIDO', 'BIPOLARIDADE', true, false, true, true),
    (59, 59, 'Macario Costa Ferreira', 41, 'MARIDO', '', true, true, true, false),
    (60, 60, 'Norberto Martins Silva', 46, 'COMPANHEIRO', 'DEPRESSAO', false, false, false, false),
    (61, 61, 'Otoniel Alves Gomes', 43, 'EX-MARIDO', '', false, false, true, true),
    (62, 62, 'Policarpo Silva Rocha', 38, 'MARIDO', 'TRANSTORNO MENTAL', true, true, true, false),
    (63, 63, 'Quintino Costa Oliveira', 45, 'COMPANHEIRO', '', false, false, false, false),
    (64, 64, 'Rosalvo Ferreira Barbosa', 52, 'EX-MARIDO', 'ALCOOLISMO', true, false, true, true),
    (65, 65, 'Silas Gomes Alves', 37, 'MARIDO', '', true, true, true, false),
    (66, 66, 'Teodoro Martins Costa', 44, 'COMPANHEIRO', 'PSICOPATIA', false, false, false, false),
    (67, 67, 'Umberto Silva Santos', 39, 'EX-MARIDO', '', false, false, true, true),
    (68, 68, 'Valdemar Rocha Ferreira', 48, 'MARIDO', 'DEPRESSAO', true, false, true, false),
    (69, 69, 'Wenceslau Costa Alves', 35, 'COMPANHEIRO', '', true, true, true, true),
    (70, 70, 'Xisto Barbosa Silva', 50, 'EX-MARIDO', 'TRANSTORNO DE PERSONALIDADE', false, false, false, false),
    (71, 71, 'Yclaro Alves Gomes', 41, 'MARIDO', '', false, false, true, true),
    (72, 72, 'Zacarias Martins Costa', 36, 'COMPANHEIRO', 'ALCOOLISMO', true, false, true, false),
    (73, 73, 'Ambrosio Silva Rocha', 43, 'EX-MARIDO', '', false, true, true, true),
    (74, 74, 'Benedito Ferreira Alves', 45, 'MARIDO', 'ANSIEDADE', true, false, false, false),
    (75, 75, 'Cândido Costa Oliveira', 39, 'COMPANHEIRO', '', false, false, true, true),
    (76, 76, 'Donato Barbosa Silva', 52, 'EX-MARIDO', 'BIPOLARIDADE', true, true, true, false),
    (77, 77, 'Emiliano Alves Gomes', 38, 'MARIDO', '', false, false, false, false),
    (78, 78, 'Fabiano Martins Costa', 44, 'COMPANHEIRO', 'DEPRESSAO', false, false, true, true),
    (79, 79, 'Galdino Silva Rocha', 40, 'EX-MARIDO', '', true, true, true, false),
    (80, 80, 'Horacio Ferreira Santos', 47, 'MARIDO', 'TRANSTORNO MENTAL', false, false, false, false),
    (81, 81, 'Ivan Santos Barbosa', 44, 'COMPANHEIRO', '', false, false, true, false),
    (82, 81, 'Jacinto Martins Costa', 39, 'EX-MARIDO', 'ALCOOLISMO', true, false, true, true),
    (83, 81, 'Kleber Silva Rocha', 48, 'MARIDO', '', false, true, false, false),
    (84, 81, 'Leandro Costa Alves', 35, 'COMPANHEIRO', 'DEPRESSAO', false, false, true, false),
    (85, 82, 'Mauricio Gomes Silva', 50, 'EX-MARIDO', '', true, false, true, true),
    (86, 82, 'Nelcir Ferreira Martins', 41, 'MARIDO', 'ANSIEDADE', false, true, true, false),
    (87, 82, 'Odilon Silva Costa', 37, 'COMPANHEIRO', '', false, false, false, false),
    (88, 83, 'Percival Barbosa Alves', 46, 'EX-MARIDO', 'BIPOLARIDADE', true, false, true, true),
    (89, 83, 'Queremom Rocha Santos', 43, 'MARIDO', '', true, true, true, false),
    (90, 83, 'Raimundo Costa Gomes', 38, 'COMPANHEIRO', 'ALCOOLISMO', false, false, false, false),
    (91, 84, 'Sebastiao Silva Martins', 52, 'EX-MARIDO', '', false, false, true, true),
    (92, 84, 'Tertuliano Ferreira Costa', 39, 'MARIDO', 'TRANSTORNO DE PERSONALIDADE', true, false, true, false),
    (93, 84, 'Ulisses Gomes Rocha', 44, 'COMPANHEIRO', '', false, true, false, false),
    (94, 85, 'Venceslau Martins Silva', 48, 'EX-MARIDO', 'DEPRESSAO', true, false, true, true),
    (95, 85, 'Waldomiro Costa Alves', 42, 'MARIDO', '', false, false, true, false),
    (96, 85, 'Xico Silva Santos', 50, 'COMPANHEIRO', 'PSICOPATIA', true, true, true, false),
    (97, 86, 'Yuri Barbosa Martins', 37, 'EX-MARIDO', '', false, false, false, false),
    (98, 86, 'Zeferino Ferreira Costa', 45, 'MARIDO', 'ALCOOLISMO', false, false, true, true),
    (99, 86, 'Abelardo Gomes Alves', 40, 'COMPANHEIRO', '', true, false, true, false),
    (100, 87, 'Baltazar Silva Costa', 49, 'EX-MARIDO', 'ANSIEDADE', false, true, false, false),
    (101, 87, 'Casimiro Martins Rocha', 36, 'MARIDO', '', false, false, true, true),
    (102, 87, 'Deolindo Costa Silva', 43, 'COMPANHEIRO', 'TRANSTORNO MENTAL', true, false, true, false),
    (103, 88, 'Eladio Barbosa Martins', 51, 'EX-MARIDO', '', true, true, true, true),
    (104, 88, 'Fabio Silva Alves', 38, 'MARIDO', 'DEPRESSAO', false, false, false, false),
    (105, 88, 'Gildardo Ferreira Costa', 46, 'COMPANHEIRO', '', false, false, true, true),
    (106, 89, 'Hilario Gomes Silva', 44, 'EX-MARIDO', 'BIPOLARIDADE', true, false, true, false),
    (107, 89, 'Ignacio Costa Martins', 39, 'MARIDO', '', false, true, true, true),
    (108, 89, 'Jarbas Silva Rocha', 47, 'COMPANHEIRO', 'ALCOOLISMO', false, false, false, false),
    (109, 90, 'Kleberson Barbosa Alves', 41, 'EX-MARIDO', '', true, false, true, true),
    (110, 90, 'Lamartine Ferreira Costa', 69, 'MARIDO', 'TRANSTORNO DE PERSONALIDADE', false, true, true, false),
    (111, 90, 'Magnolia Silva Gomes', 35, 'COMPANHEIRO', '', false, false, false, false),
    (112, 81, 'Nelson Costa Silva', 46, 'EX-MARIDO', 'DEPRESSAO', true, false, true, true),
    (113, 85, 'Osmar Barbosa Ferreira', 41, 'MARIDO', '', false, false, true, false);


-- Povoamento Tabela SUBSTANCIAS_AGRESSOR
INSERT INTO SUBSTANCIAS_AGRESSOR (id_caso, id_assistida, id_agressor, tipo_substancia)
VALUES 
    (1, 1, 1, 'SIM, DE ALCOOL'),
    (2, 2, 2, 'SIM, DE ALCOOL'),
    (3, 3, 3, 'SIM, DE DROGAS'),
    (4, 4, 4, 'SIM, DE DROGAS'),
    (5, 5, 5, 'SIM, DE ALCOOL'),
    (6, 6, 6, 'SIM, DE DROGAS'),
    (7, 7, 7, 'SIM, DE ALCOOL'),
    (8, 8, 8, 'SIM, DE DROGAS'),
    (9, 9, 9, 'SIM, DE DROGAS'),
    (10, 10, 10, 'SIM, DE ALCOOL'),
    (11, 11, 11, 'NAO'),
    (12, 12, 12, 'SIM, DE ALCOOL'),
    (13, 13, 13, 'SIM, DE DROGAS'),
    (14, 14, 14, 'SIM, DE DROGAS'),
    (15, 15, 15, 'SIM, DE ALCOOL'),
    (16, 16, 16, 'SIM, DE DROGAS'),
    (17, 17, 17, 'SIM, DE ALCOOL'),
    (18, 18, 18, 'SIM, DE ALCOOL'),
    (19, 19, 19, 'NAO'),
    (20, 20, 20, 'SIM, DE ALCOOL'),
    (21, 21, 21, 'SIM, DE DROGAS'),
    (22, 22, 22, 'SIM, DE ALCOOL'),
    (23, 23, 23, 'SIM, DE DROGAS'),
    (24, 24, 24, 'NAO'),
    (25, 25, 25, 'SIM, DE ALCOOL'),
    (26, 26, 26, 'SIM, DE DROGAS'),
    (27, 27, 27, 'SIM, DE DROGAS'),
    (28, 28, 28, 'SIM, DE ALCOOL'),
    (29, 29, 29, 'SIM, DE ALCOOL'),
    (30, 30, 30, 'NAO'),
    (31, 31, 31, 'SIM, DE ALCOOL'),
    (32, 32, 32, 'SIM, DE ALCOOL'),
    (33, 33, 33, 'SIM, DE DROGAS'),
    (34, 34, 34, 'SIM, DE DROGAS'),
    (35, 35, 35, 'SIM, DE ALCOOL'),
    (36, 36, 36, 'SIM, DE DROGAS'),
    (37, 37, 37, 'SIM, DE ALCOOL'),
    (38, 38, 38, 'SIM, DE DROGAS'),
    (39, 39, 39, 'SIM, DE DROGAS'),
    (40, 40, 40, 'SIM, DE ALCOOL'),
    (41, 41, 41, 'NAO'),
    (42, 42, 42, 'SIM, DE ALCOOL'),
    (43, 43, 43, 'SIM, DE DROGAS'),
    (44, 44, 44, 'SIM, DE DROGAS'),
    (45, 45, 45, 'SIM, DE ALCOOL'),
    (46, 46, 46, 'SIM, DE DROGAS'),
    (47, 47, 47, 'SIM, DE ALCOOL'),
    (48, 48, 48, 'SIM, DE ALCOOL'),
    (49, 49, 49, 'NAO'),
    (50, 50, 50, 'SIM, DE ALCOOL'),
    (51, 51, 51, 'SIM, DE DROGAS'),
    (52, 52, 52, 'SIM, DE ALCOOL'),
    (53, 53, 53, 'SIM, DE DROGAS'),
    (54, 54, 54, 'NAO'),
    (55, 55, 55, 'SIM, DE ALCOOL'),
    (56, 56, 56, 'SIM, DE DROGAS'),
    (57, 57, 57, 'SIM, DE DROGAS'),
    (58, 58, 58, 'SIM, DE ALCOOL'),
    (59, 59, 59, 'SIM, DE ALCOOL'),
    (60, 60, 60, 'NAO'),
    (61, 61, 61, 'SIM, DE ALCOOL'),
    (62, 62, 62, 'SIM, DE ALCOOL'),
    (63, 63, 63, 'SIM, DE DROGAS'),
    (64, 64, 64, 'SIM, DE DROGAS'),
    (65, 65, 65, 'SIM, DE ALCOOL'),
    (66, 66, 66, 'SIM, DE DROGAS'),
    (67, 67, 67, 'SIM, DE ALCOOL'),
    (68, 68, 68, 'SIM, DE DROGAS'),
    (69, 69, 69, 'SIM, DE DROGAS'),
    (70, 70, 70, 'SIM, DE ALCOOL'),
    (71, 71, 71, 'NAO'),
    (72, 72, 72, 'SIM, DE ALCOOL'),
    (73, 73, 73, 'SIM, DE DROGAS'),
    (74, 74, 74, 'SIM, DE DROGAS'),
    (75, 75, 75, 'SIM, DE ALCOOL'),
    (76, 76, 76, 'SIM, DE DROGAS'),
    (77, 77, 77, 'SIM, DE ALCOOL'),
    (78, 78, 78, 'SIM, DE ALCOOL'),
    (79, 79, 79, 'NAO'),
    (80, 80, 80, 'SIM, DE ALCOOL'),
    (81, 81, 81, 'SIM, DE DROGAS'),
    (82, 81, 82, 'SIM, DE ALCOOL'),
    (83, 81, 83, 'SIM, DE DROGAS'),
    (84, 81, 84, 'NAO'),
    (85, 82, 85, 'SIM, DE ALCOOL'),
    (86, 82, 86, 'NAO SEI'),
    (87, 82, 87, 'SIM, DE DROGAS'),
    (88, 83, 88, 'SIM, DE ALCOOL'),
    (89, 83, 89, 'SIM, DE ALCOOL'),
    (90, 83, 90, 'NAO');

-- Povoamento Tabela AMEACA_AGRESSOR
INSERT INTO AMEACA_AGRESSOR (id_caso, id_assistida, id_agressor, alvo_ameaca)
VALUES 
    (1, 1, 1, 'A_VITIMA'), (1, 1, 1, 'FILHOS'),
    (2, 2, 2, 'A_VITIMA'),
    (3, 3, 3, 'A_VITIMA'), (3, 3, 3, 'FILHOS'), (3, 3, 3, 'FAMILIARES'),
    (4, 4, 4, 'A_VITIMA'), (4, 4, 4, 'ANIMAIS'),
    (5, 5, 5, 'FILHOS'),
    (6, 6, 6, 'A_VITIMA'), (6, 6, 6, 'FAMILIARES'),
    (7, 7, 7, 'FILHOS'),
    (8, 8, 8, 'A_VITIMA'), (8, 8, 8, 'OUTRAS_PESSOAS'),
    (9, 9, 9, 'A_VITIMA'), (9, 9, 9, 'ANIMAIS'),
    (10, 10, 10, 'FILHOS'), (10, 10, 10, 'FAMILIARES'),
    (11, 11, 11, 'A_VITIMA'),
    (12, 12, 12, 'FILHOS'), (12, 12, 12, 'NAO_SEI'),
    (13, 13, 13, 'A_VITIMA'), (13, 13, 13, 'OUTRAS_PESSOAS'),
    (14, 14, 14, 'FAMILIARES'), (14, 14, 14, 'ANIMAIS'),
    (15, 15, 15, 'A_VITIMA'),
    (16, 16, 16, 'FILHOS'), (16, 16, 16, 'OUTRAS_PESSOAS'),
    (17, 17, 17, 'A_VITIMA'), (17, 17, 17, 'NAO_SEI'),
    (18, 18, 18, 'FILHOS'), (18, 18, 18, 'FAMILIARES'),
    (19, 19, 19, 'A_VITIMA'), (19, 19, 19, 'ANIMAIS'),
    (20, 20, 20, 'OUTRAS_PESSOAS'),
    (21, 21, 21, 'A_VITIMA'), (21, 21, 21, 'FILHOS'),
    (22, 22, 22, 'FAMILIARES'), (22, 22, 22, 'NAO_SEI'),
    (23, 23, 23, 'A_VITIMA'), (23, 23, 23, 'OUTRAS_PESSOAS'),
    (24, 24, 24, 'FILHOS'), (24, 24, 24, 'ANIMAIS'),
    (25, 25, 25, 'A_VITIMA'),
    (26, 26, 26, 'FAMILIARES'),
    (27, 27, 27, 'A_VITIMA'), (27, 27, 27, 'OUTRAS_PESSOAS'),
    (28, 28, 28, 'FILHOS'), (28, 28, 28, 'NAO_SEI'),
    (29, 29, 29, 'A_VITIMA'), (29, 29, 29, 'FAMILIARES'),
    (30, 30, 30, 'OUTRAS_PESSOAS'), (30, 30, 30, 'ANIMAIS'),
    (31, 31, 31, 'A_VITIMA'), (31, 31, 31, 'FILHOS'),
    (32, 32, 32, 'A_VITIMA'), (32, 32, 32, 'NAO_SEI'),
    (33, 33, 33, 'FAMILIARES'), (33, 33, 33, 'OUTRAS_PESSOAS'),
    (34, 34, 34, 'FILHOS'), (34, 34, 34, 'ANIMAIS'),
    (35, 35, 35, 'A_VITIMA'), (35, 35, 35, 'OUTRAS_PESSOAS'),
    (36, 36, 36, 'FAMILIARES'),
    (37, 37, 37, 'A_VITIMA'), (37, 37, 37, 'NAO_SEI'),
    (38, 38, 38, 'FILHOS'), (38, 38, 38, 'FAMILIARES'),
    (39, 39, 39, 'A_VITIMA'), (39, 39, 39, 'OUTRAS_PESSOAS'),
    (40, 40, 40, 'OUTRAS_PESSOAS'), (40, 40, 40, 'ANIMAIS'),
    (41, 41, 41, 'A_VITIMA'),
    (42, 42, 42, 'FAMILIARES'), (42, 42, 42, 'FILHOS'),
    (43, 43, 43, 'A_VITIMA'), (43, 43, 43, 'FAMILIARES'),
    (44, 44, 44, 'OUTRAS_PESSOAS'), (44, 44, 44, 'NAO_SEI'),
    (45, 45, 45, 'A_VITIMA'), (45, 45, 45, 'FILHOS'),
    (46, 46, 46, 'OUTRAS_PESSOAS'), (46, 46, 46, 'ANIMAIS'),
    (47, 47, 47, 'A_VITIMA'), (47, 47, 47, 'FAMILIARES'),
    (48, 48, 48, 'FAMILIARES'),
    (49, 49, 49, 'FILHOS'), (49, 49, 49, 'NAO_SEI'),
    (50, 50, 50, 'A_VITIMA'), (50, 50, 50, 'OUTRAS_PESSOAS'),
    (51, 51, 51, 'FAMILIARES'), (51, 51, 51, 'ANIMAIS'),
    (52, 52, 52, 'A_VITIMA'), (52, 52, 52, 'FILHOS'), (52, 52, 52, 'OUTRAS_PESSOAS'),
    (53, 53, 53, 'A_VITIMA'), (53, 53, 53, 'NAO_SEI'),
    (54, 54, 54, 'FAMILIARES'),
    (55, 55, 55, 'OUTRAS_PESSOAS'), (55, 55, 55, 'ANIMAIS'),
    (56, 56, 56, 'A_VITIMA'), (56, 56, 56, 'FILHOS'),
    (57, 57, 57, 'FAMILIARES'), (57, 57, 57, 'NAO_SEI'),
    (58, 58, 58, 'A_VITIMA'), (58, 58, 58, 'OUTRAS_PESSOAS'),
    (59, 59, 59, 'FAMILIARES'), (59, 59, 59, 'ANIMAIS'),
    (60, 60, 60, 'FILHOS'),
    (61, 61, 61, 'A_VITIMA'), (61, 61, 61, 'OUTRAS_PESSOAS'),
    (62, 62, 62, 'FAMILIARES'), (62, 62, 62, 'NAO_SEI'),
    (63, 63, 63, 'A_VITIMA'), (63, 63, 63, 'FILHOS'),
    (64, 64, 64, 'FAMILIARES'), (64, 64, 64, 'ANIMAIS'),
    (65, 65, 65, 'OUTRAS_PESSOAS'),
    (66, 66, 66, 'A_VITIMA'), (66, 66, 66, 'NAO_SEI'),
    (67, 67, 67, 'FAMILIARES'), (67, 67, 67, 'OUTRAS_PESSOAS'),
    (68, 68, 68, 'FILHOS'), (68, 68, 68, 'ANIMAIS'),
    (69, 69, 69, 'A_VITIMA'), (69, 69, 69, 'FAMILIARES'),
    (70, 70, 70, 'OUTRAS_PESSOAS'), (70, 70, 70, 'NAO_SEI'),
    (71, 71, 71, 'A_VITIMA'), (71, 71, 71, 'FILHOS'),
    (72, 72, 72, 'FAMILIARES'),
    (73, 73, 73, 'A_VITIMA'), (73, 73, 73, 'OUTRAS_PESSOAS'),
    (74, 74, 74, 'FAMILIARES'), (74, 74, 74, 'ANIMAIS'),
    (75, 75, 75, 'FILHOS'), (75, 75, 75, 'NAO_SEI'),
    (76, 76, 76, 'A_VITIMA'), (76, 76, 76, 'OUTRAS_PESSOAS'),
    (77, 77, 77, 'FAMILIARES'),
    (78, 78, 78, 'A_VITIMA'), (78, 78, 78, 'FILHOS'),
    (79, 79, 79, 'FAMILIARES'), (79, 79, 79, 'ANIMAIS'),
    (80, 80, 80, 'OUTRAS_PESSOAS'), (80, 80, 80, 'NAO_SEI'),
    (81, 81, 81, 'A_VITIMA'), (81, 81, 81, 'FILHOS'),
    (82, 81, 82, 'FAMILIARES'), (82, 81, 82, 'ANIMAIS'),
    (83, 81, 83, 'A_VITIMA'), (83, 81, 83, 'OUTRAS_PESSOAS'),
    (84, 81, 84, 'FAMILIARES'), (84, 81, 84, 'NAO_SEI'),
    (85, 82, 85, 'FILHOS'),
    (86, 82, 86, 'A_VITIMA'), (86, 82, 86, 'OUTRAS_PESSOAS'),
    (87, 82, 87, 'FAMILIARES'), (87, 82, 87, 'ANIMAIS'),
    (88, 83, 88, 'A_VITIMA'), (88, 83, 88, 'FILHOS'),
    (89, 83, 89, 'FAMILIARES'), (89, 83, 89, 'NAO_SEI'),
    (90, 83, 90, 'OUTRAS_PESSOAS'), (90, 83, 90, 'ANIMAIS');

--Povoamento Tabela FUNCIONARIO
INSERT INTO FUNCIONARIO (Email, Nome, Cargo, Senha) VALUES
('ana.silva@procuradoria.gov.br', 'Ana Silva', 'Coordenadora', 'S3nha#01'),
('bruno.costa@procuradoria.gov.br', 'Bruno Costa', 'Advogado', 'S3nha#02'),
('carla.oliveira@procuradoria.gov.br', 'Carla Oliveira', 'Psicóloga', 'S3nha#03'),
('daniel.santos@procuradoria.gov.br', 'Daniel Santos', 'Assistente Social', 'S3nha#04'),
('elena.ferreira@procuradoria.gov.br', 'Elena Ferreira', 'Advogada', 'S3nha#05'),
('felipe.almeida@procuradoria.gov.br', 'Felipe Almeida', 'Advogado', 'S3nha#06'),
('gabriela.pereira@procuradoria.gov.br', 'Gabriela Pereira', 'Psicóloga', 'S3nha#07'),
('hugo.rodrigues@procuradoria.gov.br', 'Hugo Rodrigues', 'Recepcionista', 'S3nha#08'),
('isabela.gomes@procuradoria.gov.br', 'Isabela Gomes', 'Advogada', 'S3nha#09'),
('joao.martins@procuradoria.gov.br', 'João Martins', 'Estagiário', 'S3nha#10'),
('karina.barbosa@procuradoria.gov.br', 'Karina Barbosa', 'Assistente Social', 'S3nha#11'),
('lucas.lima@procuradoria.gov.br', 'Lucas Lima', 'Advogado', 'S3nha#12'),
('mariana.araujo@procuradoria.gov.br', 'Mariana Araújo', 'Psicóloga', 'S3nha#13'),
('nicolas.fernandes@procuradoria.gov.br', 'Nicolas Fernandes', 'Advogado', 'S3nha#14'),
('olivia.carvalho@procuradoria.gov.br', 'Olívia Carvalho', 'Coordenadora Adjunta', 'S3nha#15'),
('paulo.ribeiro@procuradoria.gov.br', 'Paulo Ribeiro', 'Motorista', 'S3nha#16'),
('quezia.nunes@procuradoria.gov.br', 'Quezia Nunes', 'Advogada', 'S3nha#17'),
('rafael.mendes@procuradoria.gov.br', 'Rafael Mendes', 'Psicólogo', 'S3nha#18'),
('sabrina.dias@procuradoria.gov.br', 'Sabrina Dias', 'Assistente Social', 'S3nha#19'),
('thiago.farias@procuradoria.gov.br', 'Thiago Farias', 'Advogado', 'S3nha#20'),
('ursula.teixeira@procuradoria.gov.br', 'Úrsula Teixeira', 'Advogada', 'S3nha#21'),
('vinicius.rocha@procuradoria.gov.br', 'Vinícius Rocha', 'TI', 'S3nha#22'),
('wesley.moreira@procuradoria.gov.br', 'Wesley Moreira', 'Segurança', 'S3nha#23'),
('xuxa.meneghel@procuradoria.gov.br', 'Xuxa Meneghel', 'Voluntária', 'S3nha#24'),
('yasmin.cardoso@procuradoria.gov.br', 'Yasmin Cardoso', 'Advogada', 'S3nha#25'),
('zeferino.pinto@procuradoria.gov.br', 'Zeferino Pinto', 'Zelador', 'S3nha#26'),
('alice.machado@procuradoria.gov.br', 'Alice Machado', 'Advogada', 'S3nha#27'),
('breno.reis@procuradoria.gov.br', 'Breno Reis', 'Psicólogo', 'S3nha#28'),
('camila.nascimento@procuradoria.gov.br', 'Camila Nascimento', 'Assistente Social', 'S3nha#29'),
('diego.batista@procuradoria.gov.br', 'Diego Batista', 'Advogado', 'S3nha#30'),
('eduarda.lopes@procuradoria.gov.br', 'Eduarda Lopes', 'Estagiária', 'S3nha#31'),
('fabio.moura@procuradoria.gov.br', 'Fábio Moura', 'Advogado', 'S3nha#32'),
('giovana.freitas@procuradoria.gov.br', 'Giovana Freitas', 'Psicóloga', 'S3nha#33'),
('heitor.siqueira@procuradoria.gov.br', 'Heitor Siqueira', 'Advogado', 'S3nha#34'),
('ines.viana@procuradoria.gov.br', 'Inês Viana', 'Recepcionista', 'S3nha#35'),
('jorge.peixoto@procuradoria.gov.br', 'Jorge Peixoto', 'Motorista', 'S3nha#36'),
('kelly.ramos@procuradoria.gov.br', 'Kelly Ramos', 'Advogada', 'S3nha#37'),
('leandro.dantas@procuradoria.gov.br', 'Leandro Dantas', 'Psicólogo', 'S3nha#38'),
('monica.azevedo@procuradoria.gov.br', 'Mônica Azevedo', 'Assistente Social', 'S3nha#39'),
('nelson.correia@procuradoria.gov.br', 'Nelson Correia', 'Advogado', 'S3nha#40'),
('otavio.braga@procuradoria.gov.br', 'Otávio Braga', 'Advogado', 'S3nha#41'),
('patricia.campos@procuradoria.gov.br', 'Patrícia Campos', 'Psicóloga', 'S3nha#42'),
('quintino.bocaiuva@procuradoria.gov.br', 'Quintino Bocaiuva', 'Consultor', 'S3nha#43'),
('renata.macedo@procuradoria.gov.br', 'Renata Macedo', 'Advogada', 'S3nha#44'),
('samuel.vieira@procuradoria.gov.br', 'Samuel Vieira', 'Estagiário', 'S3nha#45'),
('tatiane.castro@procuradoria.gov.br', 'Tatiane Castro', 'Advogada', 'S3nha#46'),
('ulisses.guimaraes@procuradoria.gov.br', 'Ulisses Guimarães', 'Advogado Sênior', 'S3nha#47'),
('vanessa.duarte@procuradoria.gov.br', 'Vanessa Duarte', 'Psicóloga', 'S3nha#48'),
('william.sales@procuradoria.gov.br', 'William Sales', 'Assistente Social', 'S3nha#49'),
('xavier.britto@procuradoria.gov.br', 'Xavier Britto', 'Advogado', 'S3nha#50'),
('yuri.tavares@procuradoria.gov.br', 'Yuri Tavares', 'TI', 'S3nha#51'),
('zilda.arns@procuradoria.gov.br', 'Zilda Arns', 'Pedagoga', 'S3nha#52'),
('antonio.fagundes@procuradoria.gov.br', 'Antônio Fagundes', 'Advogado', 'S3nha#53'),
('bianca.bin@procuradoria.gov.br', 'Bianca Bin', 'Psicóloga', 'S3nha#54'),
('caio.castro@procuradoria.gov.br', 'Caio Castro', 'Estagiário', 'S3nha#55'),
('debora.secco@procuradoria.gov.br', 'Débora Secco', 'Advogada', 'S3nha#56'),
('emanuel.araujo@procuradoria.gov.br', 'Emanuel Araújo', 'Assistente Social', 'S3nha#57'),
('fernanda.montenegro@procuradoria.gov.br', 'Fernanda Montenegro', 'Conselheira', 'S3nha#58'),
('gustavo.lima@procuradoria.gov.br', 'Gustavo Lima', 'Segurança', 'S3nha#59'),
('heloisa.perisse@procuradoria.gov.br', 'Heloísa Périssé', 'Recepcionista', 'S3nha#60'),
('ivete.sangalo@procuradoria.gov.br', 'Ivete Sangalo', 'Coordenadora de Eventos', 'S3nha#61'),
('juliana.paes@procuradoria.gov.br', 'Juliana Paes', 'Advogada', 'S3nha#62'),
('klebber.toledo@procuradoria.gov.br', 'Klebber Toledo', 'Psicólogo', 'S3nha#63'),
('lazarro.ramos@procuradoria.gov.br', 'Lázaro Ramos', 'Advogado', 'S3nha#64'),
('maisa.silva@procuradoria.gov.br', 'Maisa Silva', 'Estagiária', 'S3nha#65'),
('neymar.junior@procuradoria.gov.br', 'Neymar Junior', 'Voluntário Esportivo', 'S3nha#66'),
('otto.alencar@procuradoria.gov.br', 'Otto Alencar', 'Consultor Jurídico', 'S3nha#67'),
('paolla.oliveira@procuradoria.gov.br', 'Paolla Oliveira', 'Advogada', 'S3nha#68'),
('quiteria.chagas@procuradoria.gov.br', 'Quitéria Chagas', 'Assistente Social', 'S3nha#69'),
('rodrigo.santoro@procuradoria.gov.br', 'Rodrigo Santoro', 'Advogado', 'S3nha#70'),
('sandy.leah@procuradoria.gov.br', 'Sandy Leah', 'Psicóloga', 'S3nha#71'),
('tata.werneck@procuradoria.gov.br', 'Tatá Werneck', 'Advogada', 'S3nha#72'),
('uillian.correia@procuradoria.gov.br', 'Uillian Correia', 'Motorista', 'S3nha#73'),
('vitoria.strada@procuradoria.gov.br', 'Vitória Strada', 'Recepcionista', 'S3nha#74'),
('wagner.moura@procuradoria.gov.br', 'Wagner Moura', 'Advogado', 'S3nha#75'),
('xand.aviao@procuradoria.gov.br', 'Xand Avião', 'Logística', 'S3nha#76'),
('yanna.lavigne@procuradoria.gov.br', 'Yanna Lavigne', 'Psicóloga', 'S3nha#77'),
('zeze.camargo@procuradoria.gov.br', 'Zezé Camargo', 'Zelador', 'S3nha#78'),
('joana.dark@procuradoria.gov.br', 'Joana Dark', 'Advogada', 'S3nha#79'),
('mario.bros@procuradoria.gov.br', 'Mario Bros', 'Encanador Predial', 'S3nha#80');

-- Povoamento Tabela ADMINISTRADOR
INSERT INTO ADMINISTRADOR (Email) VALUES
('ana.silva@procuradoria.gov.br'),
('bruno.costa@procuradoria.gov.br'),
('carla.oliveira@procuradoria.gov.br'),
('daniel.santos@procuradoria.gov.br'),
('elena.ferreira@procuradoria.gov.br'),
('felipe.almeida@procuradoria.gov.br'),
('gabriela.pereira@procuradoria.gov.br'),
('hugo.rodrigues@procuradoria.gov.br'),
('isabela.gomes@procuradoria.gov.br'),
('joao.martins@procuradoria.gov.br'),
('karina.barbosa@procuradoria.gov.br'),
('lucas.lima@procuradoria.gov.br'),
('mariana.araujo@procuradoria.gov.br'),
('nicolas.fernandes@procuradoria.gov.br'),
('olivia.carvalho@procuradoria.gov.br'),
('paulo.ribeiro@procuradoria.gov.br'),
('quezia.nunes@procuradoria.gov.br'),
('rafael.mendes@procuradoria.gov.br'),
('sabrina.dias@procuradoria.gov.br'),
('thiago.farias@procuradoria.gov.br'),
('ursula.teixeira@procuradoria.gov.br'),
('vinicius.rocha@procuradoria.gov.br'),
('wesley.moreira@procuradoria.gov.br'),
('xuxa.meneghel@procuradoria.gov.br'),
('yasmin.cardoso@procuradoria.gov.br'),
('zeferino.pinto@procuradoria.gov.br'),
('alice.machado@procuradoria.gov.br'),
('breno.reis@procuradoria.gov.br'),
('camila.nascimento@procuradoria.gov.br'),
('diego.batista@procuradoria.gov.br'),
('eduarda.lopes@procuradoria.gov.br'),
('fabio.moura@procuradoria.gov.br'),
('giovana.freitas@procuradoria.gov.br'),
('heitor.siqueira@procuradoria.gov.br'),
('ines.viana@procuradoria.gov.br'),
('jorge.peixoto@procuradoria.gov.br'),
('kelly.ramos@procuradoria.gov.br'),
('leandro.dantas@procuradoria.gov.br'),
('monica.azevedo@procuradoria.gov.br'),
('nelson.correia@procuradoria.gov.br'),
('otavio.braga@procuradoria.gov.br'),
('patricia.campos@procuradoria.gov.br'),
('quintino.bocaiuva@procuradoria.gov.br'),
('renata.macedo@procuradoria.gov.br'),
('samuel.vieira@procuradoria.gov.br'),
('tatiane.castro@procuradoria.gov.br'),
('ulisses.guimaraes@procuradoria.gov.br'),
('vanessa.duarte@procuradoria.gov.br'),
('william.sales@procuradoria.gov.br'),
('xavier.britto@procuradoria.gov.br'),
('yuri.tavares@procuradoria.gov.br'),
('zilda.arns@procuradoria.gov.br'),
('antonio.fagundes@procuradoria.gov.br'),
('bianca.bin@procuradoria.gov.br'),
('caio.castro@procuradoria.gov.br'),
('debora.secco@procuradoria.gov.br'),
('emanuel.araujo@procuradoria.gov.br'),
('fernanda.montenegro@procuradoria.gov.br'),
('gustavo.lima@procuradoria.gov.br'),
('heloisa.perisse@procuradoria.gov.br'),
('ivete.sangalo@procuradoria.gov.br'),
('juliana.paes@procuradoria.gov.br'),
('klebber.toledo@procuradoria.gov.br'),
('lazarro.ramos@procuradoria.gov.br'),
('maisa.silva@procuradoria.gov.br'),
('neymar.junior@procuradoria.gov.br'),
('otto.alencar@procuradoria.gov.br'),
('paolla.oliveira@procuradoria.gov.br'),
('quiteria.chagas@procuradoria.gov.br'),
('rodrigo.santoro@procuradoria.gov.br'),
('sandy.leah@procuradoria.gov.br'),
('tata.werneck@procuradoria.gov.br'),
('uillian.correia@procuradoria.gov.br'),
('vitoria.strada@procuradoria.gov.br'),
('wagner.moura@procuradoria.gov.br'),
('xand.aviao@procuradoria.gov.br'),
('yanna.lavigne@procuradoria.gov.br'),
('zeze.camargo@procuradoria.gov.br'),
('joana.dark@procuradoria.gov.br'),
('mario.bros@procuradoria.gov.br');

-- Povoamento Tabela FUNCIONARIO_ACOMPANHA_CASO
INSERT INTO FUNCIONARIO_ACOMPANHA_CASO (email_funcionario, id_caso) VALUES
('ana.silva@procuradoria.gov.br', 1),
('bruno.costa@procuradoria.gov.br', 2),
('carla.oliveira@procuradoria.gov.br', 3),
('daniel.santos@procuradoria.gov.br', 4),
('elena.ferreira@procuradoria.gov.br', 5),
('felipe.almeida@procuradoria.gov.br', 6),
('gabriela.pereira@procuradoria.gov.br', 7),
('hugo.rodrigues@procuradoria.gov.br', 8),
('isabela.gomes@procuradoria.gov.br', 9),
('joao.martins@procuradoria.gov.br', 10),
('karina.barbosa@procuradoria.gov.br', 11),
('lucas.lima@procuradoria.gov.br', 12),
('mariana.araujo@procuradoria.gov.br', 13),
('nicolas.fernandes@procuradoria.gov.br', 14),
('olivia.carvalho@procuradoria.gov.br', 15),
('paulo.ribeiro@procuradoria.gov.br', 16),
('quezia.nunes@procuradoria.gov.br', 17),
('rafael.mendes@procuradoria.gov.br', 18),
('sabrina.dias@procuradoria.gov.br', 19),
('thiago.farias@procuradoria.gov.br', 20),
('ursula.teixeira@procuradoria.gov.br', 21),
('vinicius.rocha@procuradoria.gov.br', 22),
('wesley.moreira@procuradoria.gov.br', 23),
('xuxa.meneghel@procuradoria.gov.br', 24),
('yasmin.cardoso@procuradoria.gov.br', 25),
('zeferino.pinto@procuradoria.gov.br', 26),
('alice.machado@procuradoria.gov.br', 27),
('breno.reis@procuradoria.gov.br', 28),
('camila.nascimento@procuradoria.gov.br', 29),
('diego.batista@procuradoria.gov.br', 30),
('eduarda.lopes@procuradoria.gov.br', 31),
('fabio.moura@procuradoria.gov.br', 32),
('giovana.freitas@procuradoria.gov.br', 33),
('heitor.siqueira@procuradoria.gov.br', 34),
('ines.viana@procuradoria.gov.br', 35),
('jorge.peixoto@procuradoria.gov.br', 36),
('kelly.ramos@procuradoria.gov.br', 37),
('leandro.dantas@procuradoria.gov.br', 38),
('monica.azevedo@procuradoria.gov.br', 39),
('nelson.correia@procuradoria.gov.br', 40),
-- Reiniciando a contagem dos casos para os próximos 40 funcionários
('otavio.braga@procuradoria.gov.br', 1),
('patricia.campos@procuradoria.gov.br', 2),
('quintino.bocaiuva@procuradoria.gov.br', 3),
('renata.macedo@procuradoria.gov.br', 4),
('samuel.vieira@procuradoria.gov.br', 5),
('tatiane.castro@procuradoria.gov.br', 6),
('ulisses.guimaraes@procuradoria.gov.br', 7),
('vanessa.duarte@procuradoria.gov.br', 8),
('william.sales@procuradoria.gov.br', 9),
('xavier.britto@procuradoria.gov.br', 10),
('yuri.tavares@procuradoria.gov.br', 11),
('zilda.arns@procuradoria.gov.br', 12),
('antonio.fagundes@procuradoria.gov.br', 13),
('bianca.bin@procuradoria.gov.br', 14),
('caio.castro@procuradoria.gov.br', 15),
('debora.secco@procuradoria.gov.br', 16),
('emanuel.araujo@procuradoria.gov.br', 17),
('fernanda.montenegro@procuradoria.gov.br', 18),
('gustavo.lima@procuradoria.gov.br', 19),
('heloisa.perisse@procuradoria.gov.br', 20),
('ivete.sangalo@procuradoria.gov.br', 21),
('juliana.paes@procuradoria.gov.br', 22),
('klebber.toledo@procuradoria.gov.br', 23),
('lazarro.ramos@procuradoria.gov.br', 24),
('maisa.silva@procuradoria.gov.br', 25),
('neymar.junior@procuradoria.gov.br', 26),
('otto.alencar@procuradoria.gov.br', 27),
('paolla.oliveira@procuradoria.gov.br', 28),
('quiteria.chagas@procuradoria.gov.br', 29),
('rodrigo.santoro@procuradoria.gov.br', 30),
('sandy.leah@procuradoria.gov.br', 31),
('tata.werneck@procuradoria.gov.br', 32),
('uillian.correia@procuradoria.gov.br', 33),
('vitoria.strada@procuradoria.gov.br', 34),
('wagner.moura@procuradoria.gov.br', 35),
('xand.aviao@procuradoria.gov.br', 36),
('yanna.lavigne@procuradoria.gov.br', 37),
('zeze.camargo@procuradoria.gov.br', 38),
('joana.dark@procuradoria.gov.br', 39),
('mario.bros@procuradoria.gov.br', 40);


-- Povoamento Tabela VIOLENCIA
INSERT INTO VIOLENCIA (id_caso, id_assistida, estupro, data_ocorrencia)
SELECT 
    id_caso, 
    id_assistida, 
    (CASE WHEN RANDOM() < 0.1 THEN TRUE ELSE FALSE END) as estupro, -- 10% de chance de ser estupro
    CURRENT_DATE - (FLOOR(RANDOM() * 365) || ' days')::INTERVAL as data_ocorrencia -- Data aleatória no último ano
FROM CASO
ORDER BY id_caso ASC
LIMIT 80;

-- Atualiza a sequência do ID para o próximo número disponível (evita erro em inserts futuros)
SELECT setval('violencia_id_violencia_seq', (SELECT MAX(id_violencia) FROM VIOLENCIA));


-- Povoamento Tabela TIPO_VIOLENCIA
INSERT INTO TIPO_VIOLENCIA (id_violencia, id_caso, id_assistida, tipo_violencia)
SELECT 
    id_violencia, 
    id_caso, 
    id_assistida,
    CASE (FLOOR(RANDOM() * 5))::INT
        WHEN 0 THEN 'Física'
        WHEN 1 THEN 'Psicológica'
        WHEN 2 THEN 'Moral'
        WHEN 3 THEN 'Sexual'
        ELSE 'Patrimonial'
    END as tipo_violencia
FROM VIOLENCIA;

-- Povoamento Tabela AGRESSAO_VIOLENCIA
INSERT INTO AGRESSAO_VIOLENCIA (id_violencia, id_caso, id_assistida, tipo_agressao)
SELECT 
    id_violencia, 
    id_caso, 
    id_assistida,
    CASE (FLOOR(RANDOM() * 14))::INT -- Sorteia entre opções reais do formulário
        WHEN 0 THEN 'Empurrões'                       -- Pág 1, Item 03
        WHEN 1 THEN 'Tapas'                           -- Pág 1, Item 03
        WHEN 2 THEN 'Socos'                           -- Pág 1, Item 03
        WHEN 3 THEN 'Chutes'                          -- Pág 1, Item 03
        WHEN 4 THEN 'Puxões de cabelo'                -- Pág 1, Item 03
        WHEN 5 THEN 'Enforcamento'                    -- Pág 1, Item 03
        WHEN 6 THEN 'Sufocamento'                     -- Pág 1, Item 03
        WHEN 7 THEN 'Ameaça com arma de fogo'         -- Pág 1, Item 01
        WHEN 8 THEN 'Ameaça com faca'                 -- Pág 1, Item 01
        WHEN 9 THEN 'Queimadura'                      -- Pág 1, Item 03
        WHEN 10 THEN 'Perseguição e Vigilância'       -- Pág 2, Item 05
        WHEN 11 THEN 'Retenção de dinheiro ou bens'   -- Pág 2, Item 05
        WHEN 12 THEN 'Proibição de visita a família'  -- Pág 2, Item 05
        ELSE 'Ciúme excessivo e controle'             -- Pág 2, Item 05
    END as tipo_agressao
FROM VIOLENCIA
ORDER BY id_violencia ASC;

--Povoamento Tabela PREENCHIMENTO_PROFISSIONAL
INSERT INTO PREENCHIMENTO_PROFISSIONAL (
    id_preenchimento,
    id_caso,
    id_assistida,
    assistida_respondeu_sem_ajuda,
    assistida_respondeu_com_auxilio,
    assistida_sem_condicoes,
    assistida_recusou,
    terceiro_comunicante
)
SELECT
    id_caso, -- Usa o ID do caso como ID do preenchimento para garantir unicidade
    id_caso,
    id_assistida,
    -- A lógica abaixo sorteia um número de 0 a 4 e marca apenas uma opção como TRUE
    CASE WHEN r = 0 THEN TRUE ELSE FALSE END, -- Respondeu sem ajuda
    CASE WHEN r = 1 THEN TRUE ELSE FALSE END, -- Respondeu com auxílio
    CASE WHEN r = 2 THEN TRUE ELSE FALSE END, -- Sem condições de responder
    CASE WHEN r = 3 THEN TRUE ELSE FALSE END, -- Recusou-se
    CASE WHEN r = 4 THEN TRUE ELSE FALSE END  -- Terceiro comunicante
FROM (
    SELECT 
        id_caso, 
        id_assistida, 
        FLOOR(RANDOM() * 5)::INT as r -- Gera o número aleatório para o sorteio
    FROM CASO
    ORDER BY id_caso ASC
    LIMIT 80
) as sorteio;

--Povoamento Tabela HISTORICO
INSERT INTO HISTORICO (id_func, tipo, mudanca, id_caso, id_assistida)
SELECT
    -- 1. Sorteia um funcionário aleatório da tabela FUNCIONARIO
    (SELECT Email FROM FUNCIONARIO ORDER BY RANDOM() LIMIT 1),
    
    -- 2. Define o TIPO da ação
    CASE (FLOOR(RANDOM() * 6))::INT
        WHEN 0 THEN 'CRIAÇÃO'
        WHEN 1 THEN 'ATUALIZAÇÃO'
        WHEN 2 THEN 'INSERÇÃO'
        WHEN 3 THEN 'CONSULTA'
        WHEN 4 THEN 'ENCAMINHAMENTO'
        ELSE 'ARQUIVAMENTO'
    END as tipo,

    -- 3. Define a DESCRIÇÃO (mudanca) baseada no número sorteado acima (para fazer sentido com o tipo)
    CASE (FLOOR(RANDOM() * 6))::INT
        WHEN 0 THEN 'Abertura de novo caso e cadastro inicial da assistida'
        WHEN 1 THEN 'Atualização de telefone e endereço de contato'
        WHEN 2 THEN 'Inserção de documentos anexos (RG/CPF e BO)'
        WHEN 3 THEN 'Consulta realizada para verificar andamento da medida protetiva'
        WHEN 4 THEN 'Encaminhamento realizado para a rede de apoio (CRAS/CREAS)'
        ELSE 'Arquivamento temporário aguardando retorno da assistida'
    END as mudanca,

    id_caso,
    id_assistida
FROM CASO
ORDER BY id_caso ASC
LIMIT 80;


------------------
-- Queries SQL  --
------------------

-- Query 1: Query utilizada no nosso sistema back-end para retornar dados para gráfico de pizza, no qual mostra a quantidade de casos ocorridos em cada localidade.

SELECT 
    a.endereco, COUNT(*) as quantidade            
FROM 
    ASSISTIDA a            
JOIN CASO c ON a.id = c.id_assistida            
AND a.endereco IS NOT NULL            
GROUP BY a.endereco            
ORDER BY quantidade DESC;

-- Query 2: Query utilizada para trazer informações necessárias da tela de assistidas, no qual tem uma visão geral do caso relacionado a uma assistida, importantes para o jurídico ter uma análise dos tipos de violência e o agressor relacionado a um caso específico

SELECT
    c.id_caso,
    a.id as id_assistida,
    a.nome as nomeAssistida,
    ag.nome as nomeAgressor,
    c.data,
    pp.assistida_respondeu_sem_ajuda,
    pp.assistida_respondeu_com_auxilio,
    pp.assistida_sem_condicoes,
    pp.assistida_recusou,
    pp.terceiro_comunicante,
    array_agg(DISTINCT tv.tipo_violencia) as tipoViolencia
FROM
    caso c
LEFT JOIN assistida a ON c.id_assistida = a.id
LEFT JOIN agressor ag ON c.id_caso = ag.id_caso
LEFT JOIN preenchimento_profissional pp ON pp.id_caso = c.id_caso
LEFT JOIN tipo_violencia_preenchimento tv ON tv.id_preenchimento = pp.id_preenchimento
WHERE 
    c.id_caso = 20
GROUP BY 
c.id_caso, 
a.id, a.nome, ag.nome, 
c.data, pp.assistida_respondeu_sem_ajuda, 
pp.assistida_respondeu_com_auxilio, pp.assistida_sem_condicoes, 
pp.assistida_recusou, pp.terceiro_comunicante;

-- Query 3: Endereços com maior número de filhos com deficiência que sofreram violência, ou que presenciaram violencia doméstica

SELECT
  a.endereco, COUNT(f.qtd_filhos_deficiencia) AS quantidade
FROM assistida a
LEFT JOIN filho f ON a.id = f.id_assistida
WHERE (f.viu_violencia OR f.violencia_gravidez) AND f.qtd_filhos_deficiencia > 0
GROUP BY a.endereco
ORDER BY quantidade DESC;

-- Query 4: Tempo médio entre a data de ocorrência da violência e a data de realização da denúncia, categoriazado por tipo de violência.

select
    tpv.tipo_violencia as "Tipos de Violência",
    count(*) as "Quantidade de Casos",
    round(avg(c.data - v.data_ocorrencia), 1) as "Média de dias até a realização da Denúncia",
    min(c.data - v.data_ocorrencia) as "Mínimo de dias entre a data do ocorrido e a data da denúncia",
    max(c.data - v.data_ocorrencia) as "Máximo de dias entre a data do ocorrido e a data da denúncia"
from
    caso c
join
    violencia v on c.id_caso = v.id_caso
join
    tipo_violencia tpv on v.id_violencia = tpv.id_violencia
where
    v.data_ocorrencia is not null
    and c.data >= v.data_ocorrencia
group by
    tpv.tipo_violencia
order by
    "Média de dias até a realização da Denúncia" desc;

-- Query 5: Diferença em dias entre a data de ocorrência da violência e a data de realização da denúncia para casos onde a assistida possui filhos que são agressores. 

select 
  (c.data - v.data_ocorrencia) as "Dias de Diferença" 
from 
  caso c 
join 
violencia v on c.id_caso = v.id_caso 
where 
v.data_ocorrencia is not null 
and exists ( 
    select * 
    from filho f 
    where f.id_assistida = c.id_assistida 
    and f.qtd_filho_agressor > 0 
);

-- Query 6: Análise se o agressor estava sob efeito de algum entorpecente quando fez a agressão, quem ele agrediu, e quantas vezes:

SELECT 
    sa.tipo_substancia AS Agressor_Sob_Efeito_De,
    aa.alvo_ameaca AS Quem_Ele_Ameacou,
    tv.tipo_violencia AS O_Que_Ele_Fez_De_Fato,
    COUNT(*) AS Ocorrencias
FROM SUBSTANCIAS_AGRESSOR sa
JOIN AMEACA_AGRESSOR aa ON sa.id_agressor = aa.id_agressor
JOIN VIOLENCIA v ON sa.id_caso = v.id_caso
JOIN TIPO_VIOLENCIA tv ON v.id_violencia = tv.id_violencia
WHERE sa.tipo_substancia NOT ILIKE '%NAO%'
GROUP BY sa.tipo_substancia, aa.alvo_ameaca, tv.tipo_violencia
ORDER BY Ocorrencias DESC;

-- Query 7: Análise da média de tempo que uma assistida demora para prestar queixa dependendo do seu relacionamento com o agressor

SELECT 
    ag.Vinculo AS Relacionamento,
    COUNT(*) AS Qtd_Casos,
    MIN(c.data - v.data_ocorrencia) || ' dias' AS Tempo_Minimo_Denuncia,
    MAX(c.data - v.data_ocorrencia) || ' dias' AS Tempo_Maximo_Denuncia,
    ROUND(AVG(c.data - v.data_ocorrencia), 0) || ' dias' AS Tempo_Medio_Denuncia
FROM CASO c
JOIN VIOLENCIA v ON c.id_caso = v.id_caso
JOIN AGRESSOR ag ON c.id_caso = ag.id_caso
WHERE 
    v.data_ocorrencia IS NOT NULL 
    AND c.data >= v.data_ocorrencia
GROUP BY ag.Vinculo
ORDER BY AVG(c.data - v.data_ocorrencia) DESC;

-- Query 8: Análise de quantos tipos de agressão ocorreram com assistidas menores de idade

SELECT 
    tipos_fixos.nome_tipo AS Tipo_de_Violencia,
    COUNT(DISTINCT dados_reais.id_assistida) AS Qtd_Vitimas_Menores
FROM 
    (VALUES ('FISICA'), ('PSICOLOGICA'), ('SEXUAL'), ('PATRIMONIAL'), ('MORAL')) AS tipos_fixos(nome_tipo)
LEFT JOIN 
    (
        SELECT tv.tipo_violencia, v.id_assistida
        FROM TIPO_VIOLENCIA tv
        JOIN VIOLENCIA v ON tv.id_violencia = v.id_violencia
        JOIN ASSISTIDA a ON v.id_assistida = a.id
        WHERE a.idade < 18
    ) AS dados_reais ON tipos_fixos.nome_tipo = dados_reais.tipo_violencia
GROUP BY tipos_fixos.nome_tipo
ORDER BY Qtd_Vitimas_Menores DESC;

-- Query 9: Análise da quantidade de agressores por faixa etária

SELECT 
    ref.faixa AS Faixa_Etaria,
    COUNT(a.id_agressor) AS Quantidade
FROM 
    (VALUES 
        ('Menor que 13', 1), 
        ('14 a 17', 2), 
        ('18 a 30', 3), 
        ('31 a 59', 4), 
        ('60+', 5),
        ('NÃO INFORMADO', 6)
    ) AS ref(faixa, id_ordem)
LEFT JOIN 
    AGRESSOR a ON ref.faixa = (
        CASE 
            WHEN a.Idade <= 13 THEN 'Menor que 13'
            WHEN a.Idade BETWEEN 14 AND 17 THEN '14 a 17'
            WHEN a.Idade BETWEEN 18 AND 30 THEN '18 a 30'
            WHEN a.Idade BETWEEN 31 AND 59 THEN '31 a 59'
            WHEN a.Idade >= 60 THEN '60+'
            ELSE 'NÃO INFORMADO'
        END
    )
GROUP BY ref.faixa, ref.id_ordem
ORDER BY ref.id_ordem ASC;

-- Query 10: Ocorrência de abuso sexual em Assistidas com deficiência ou doença degenerativa por idade

select distinct
  a.id as "ID da Assistida",
  a.idade as "Idade da Assistida",
  ag.vinculo as "Vinculo da Assistida com o Agressor",
  a.deficiencia as "Condição Limitante ou de Vunerabilidade Social"
from assistida a
join agressor ag ON a.id = ag.id_assistida
join violencia v ON a.id = v.id_assistida
where v.estupro is true and a.deficiencia != 'NAO INFORMADO'
order by a.idade desc;

-- Query 11: Tipo de Violência baseado em cor/raça

select
  brancas.tipo_violencia as "Tipo de Violência",
  nbrancas.vitimas_nao_brancas as "Quantidade de Vítimas Não Brancas",
  brancas.vitimas_brancas as "Quantidade de Vítimas Brancas"
from
  (select v.tipo_violencia, count(*) as "vitimas_brancas"
    from assistida a
    join tipo_violencia v on v.id_assistida = a.id
    where a.cor_raca = 'BRANCA'
    group by v.tipo_violencia) as brancas
full outer join
  (select v.tipo_violencia, count(*) as "vitimas_nao_brancas"
    from assistida a
    join tipo_violencia v on v.id_assistida = a.id
    where a.cor_raca in ('PRETA','PARDA','INDÍGENA','AMARELA/ORIENTAL')
    group by v.tipo_violencia) as nbrancas
on brancas.tipo_violencia = nbrancas.tipo_violencia
order by vitimas_nao_brancas desc;

-- Query 12: Análise comparativa da prevalência de violência patrimonial e psicológica segregada pelo status de dependência financeira da vítima

SELECT 
    CASE 
        WHEN C.depen_finc = true THEN 'SIM - Dependente' 
        ELSE 'NÃO - Independente' 
    END AS "Dependência Financeira",
    COUNT(DISTINCT C.id_caso) AS "Total de Casos",
    COUNT(DISTINCT CASE WHEN TV.tipo_violencia = 'Patrimonial' OR TV.tipo_violencia = 'PATRIMONIAL' THEN C.id_caso END) AS "Qtd. Violência Patrimonial",  
    ROUND(
        (COUNT(DISTINCT CASE WHEN TV.tipo_violencia = 'Patrimonial' OR TV.tipo_violencia = 'PATRIMONIAL' THEN C.id_caso END) * 100.0) / 
        COUNT(DISTINCT C.id_caso), 2
    ) || '%' AS "% Sofrem Violência Patrimonial",
    ROUND(
        (COUNT(DISTINCT CASE WHEN TV.tipo_violencia = 'Psicológica' OR TV.tipo_violencia = 'PSICOLÓGICA' THEN C.id_caso END) * 100.0) / 
        COUNT(DISTINCT C.id_caso), 2
    ) || '%' AS "% Sofrem Violência Psicológica"
FROM CASO C
JOIN VIOLENCIA V ON C.id_caso = V.id_caso
JOIN TIPO_VIOLENCIA TV ON V.id_violencia = TV.id_violencia
GROUP BY C.depen_finc
ORDER BY C.depen_finc DESC;

-- Query 13: Distribuição percentual das assistidas estratificada por nível de escolaridade para identificação do perfil educacional predominante

SELECT  
    A.escolaridade AS "Nível de Escolaridade",   
    COUNT(A.id) AS "Total de Vítimas",
    ROUND(
        (COUNT(A.id) * 100.0) / (SELECT COUNT(*) FROM ASSISTIDA), 1
    ) || '%' AS "% do Total"
FROM ASSISTIDA A
GROUP BY A.escolaridade
ORDER BY "Total de Vítimas" DESC;
