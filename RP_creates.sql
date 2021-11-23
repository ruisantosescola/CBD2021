/***************************************************
* 
* Projeto de Complementos de Base de Dados 2020/2021
*
* Grupo: Andrei-Florin Balcan (200221154) e Ivan Barrinho Lopes (20221145)
*
* Turma: 2ºL_EI-SW-05 
*
* CRIAÇÃO DA BASE DE DADOS E DAS TABELAS
*
***************************************************/

--EXCLUIR a Base de Dados AgrupamentoSTB caso ela exista;
USE master;
DROP DATABASE IF EXISTS AgrupamentoSTB;

--CRIAR A Base de Dados AgrupamentoSTB;

CREATE DATABASE AgrupamentoSTB CONTAINMENT = NONE ON PRIMARY 
(NAME = projeto,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\projeto.mdf', 
SIZE = 8192KB, FILEGROWTH = 65536KB),
FILEGROUP [Pessoas]

(NAME = projeto_pessoas,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\projeto_pessoas.ndf',
SIZE = 8192KB, MAXSIZE = 2048MB, FILEGROWTH = 65536KB),
FILEGROUP [Escola]

(NAME = projeto_conteudos,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\projeto_conteudos.ndf',
SIZE = 8192KB, MAXSIZE = 2048MB, FILEGROWTH = 65536KB);




--CRIAR os schemas Pessoas, Escola e Erros;
USE AgrupamentoSTB;

DROP SCHEMA IF EXISTS Pessoas;
DROP SCHEMA IF EXISTS Escola;
DROP SCHEMA IF EXISTS Erros;

CREATE SCHEMA Pessoas;
GO
CREATE SCHEMA Escola;
GO
CREATE SCHEMA Erros;
GO

--CRIAR as Tabelas da Base de Dados AgrupamentoSTB;
CREATE TABLE Pessoas.[Pessoa] 
	(
        [pessoa_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[pessoa_nome] VARCHAR(50) NOT NULL,
		[pessoa_sexo] CHAR(1) NOT NULL CHECK([pessoa_sexo] IN ('F', 'M')),
		[pessoa_data_nascimento] DATE NOT NULL,
        [pessoa_morada] VARCHAR(100) NOT NULL CHECK([pessoa_morada] IN ('U', 'R')),
		[pessoa_morada_alternativa] VARCHAR(100),  
		[pessoa_email] VARCHAR(100)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[TempoViagem] 
	(
		[tempoviagem_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[tempoviagem] VARCHAR(15) NOT NULL 
	)
ON [Pessoas];

CREATE TABLE Pessoas.[TempoEstudo] 
	(
		[tempoestudo_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[tempoestudo] VARCHAR(15) NOT NULL 
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Qualidade] 
	(
		[qualidade_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[qualidade] VARCHAR(15) NOT NULL 
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Quantidade]
	(
		[quantidade_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[quantidade] VARCHAR(15) NOT NULL 
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Motivo]
	(
		[motivo_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[motivo] VARCHAR(50)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Emprego] 
	(
		[emprego_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[emprego] VARCHAR(50)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Aluno] 
	(
		[aluno_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[aluno_pessoa_id] INT NOT NULL,
		[aluno_numero] INT NOT NULL UNIQUE,
		[aluno_escola] VARCHAR(50) NOT NULL,
        [aluno_agregado] INT NOT NULL,
		[aluno_pais_coabitacao] CHAR NOT NULL CHECK([aluno_pais_coabitacao] IN ('T', 'A')),
		[aluno_motivo_id] INT NOT NULL,
		[aluno_tempo_viagem_id] INT NOT NULL CHECK([aluno_tempo_viagem_id] IN (1, 2, 3, 4)),
		[aluno_tempo_estudo_id] INT NOT NULL CHECK([aluno_tempo_estudo_id] IN (1, 2, 3, 4)),
		[aluno_bolseiro] BIT NOT NULL,
		[aluno_suporte_familia] BIT NOT NULL,
		[aluno_explicacao] BIT NOT NULL,
		[aluno_atividades] BIT NOT NULL,
		[aluno_infantario] BIT NOT NULL,
		[aluno_intencao] BIT NOT NULL,
		[aluno_internet] BIT NOT NULL,
		[aluno_relacionamento] BIT NOT NULL,
		[aluno_relacionamento_familiar_id] INT NOT NULL CHECK([aluno_relacionamento_familiar_id] IN (1, 2, 3, 4, 5)),
		[aluno_tempo_livre_id] INT NOT NULL CHECK ([aluno_tempo_livre_id] IN (1, 2, 3, 4, 5)),
		[aluno_saidas_id] INT NOT NULL CHECK ([aluno_saidas_id] IN (1, 2, 3, 4, 5)),
		[aluno_alcool_semana_id] INT NOT NULL CHECK ([aluno_alcool_semana_id] IN (1, 2, 3, 4, 5)),
		[aluno_alcool_fim_id] INT NOT NULL CHECK ([aluno_alcool_fim_id] IN (1, 2, 3, 4, 5)),
		[aluno_saude_id] INT NOT NULL CHECK ([aluno_saude_id] IN (1, 2, 3, 4, 5))
		CONSTRAINT fk_aluno_pessoa_id FOREIGN KEY (aluno_pessoa_id) REFERENCES Pessoas.[Pessoa](pessoa_id),
		CONSTRAINT fk_aluno_motivo_id FOREIGN KEY (aluno_motivo_id) REFERENCES Pessoas.[Motivo](motivo_id),
		CONSTRAINT fk_aluno_tempo_viagem_id FOREIGN KEY (aluno_tempo_viagem_id) REFERENCES Pessoas.[TempoViagem](tempoviagem_id),
		CONSTRAINT fk_aluno_tempo_estudo_id FOREIGN KEY (aluno_tempo_estudo_id) REFERENCES Pessoas.[TempoEstudo](tempoestudo_id),
		CONSTRAINT fk_aluno_relacionamento_familiar_id FOREIGN KEY (aluno_relacionamento_familiar_id) REFERENCES Pessoas.[Qualidade](qualidade_id),
		CONSTRAINT fk_aluno_tempo_livre_id FOREIGN KEY (aluno_tempo_livre_id) REFERENCES Pessoas.[Quantidade](quantidade_id),
		CONSTRAINT fk_aluno_saidas_id FOREIGN KEY (aluno_saidas_id) REFERENCES Pessoas.[Quantidade](quantidade_id),
		CONSTRAINT fk_aluno_alcool_semana_id FOREIGN KEY (aluno_alcool_semana_id) REFERENCES Pessoas.[Quantidade](quantidade_id),
		CONSTRAINT fk_aluno_alcool_fim_id FOREIGN KEY (aluno_alcool_fim_id) REFERENCES Pessoas.[Quantidade](quantidade_id),
		CONSTRAINT fk_aluno_saude_id FOREIGN KEY (aluno_saude_id) REFERENCES Pessoas.[Qualidade](qualidade_id)
	)
On [Pessoas];

CREATE TABLE Pessoas.[Pais] 
	(
		[pai_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[pai_pessoa_id] INT NOT NULL,
		[pai_aluno_id] INT NOT NULL,
        [pai_grau] varchar(25) NOT NULL,
		[pai_emprego_id] INT NOT NULL,
		[pai_escolaridade] NUMERIC NOT NULL CHECK([pai_escolaridade] IN (0, 1, 2, 3, 4)),
        CONSTRAINT fk_pai_pessoa_id FOREIGN KEY (pai_pessoa_id) REFERENCES Pessoas.[Pessoa](pessoa_id),
		CONSTRAINT fk_pai_aluno_id FOREIGN KEY (pai_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id),
		CONSTRAINT fk_pai_emprego_id FOREIGN KEY (pai_emprego_id) REFERENCES Pessoas.[Emprego](emprego_id)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Encarregado_Educacao] 
	(
		[ee_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[ee_pai_id] INT NOT NULL,
		[ee_aluno_id] INT NOT NULL,
		CONSTRAINT fk_ee_pai_id FOREIGN KEY (ee_pai_id) REFERENCES Pessoas.[Pais](pai_id),
		CONSTRAINT fk_ee_aluno_id FOREIGN KEY (ee_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Hierarquia] 
	(
		[hierarquia_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[hierarquia] VARCHAR(25) NOT NULL,
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Login] 
	(
		[login_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[login_pessoa_id] INT NOT NULL,
		[login_hierarquia_id] INT NOT NULL,
		[login_password] VARCHAR(50) NOT NULL,
		CONSTRAINT fk_login_pessoa_id FOREIGN KEY (login_pessoa_id) REFERENCES Pessoas.[Pessoa](pessoa_id),
		CONSTRAINT fk_login_hierarquia_id FOREIGN KEY (login_hierarquia_id) REFERENCES Pessoas.[Hierarquia](hierarquia_id)
	)
ON [Pessoas];

CREATE TABLE Pessoas.[Recuperacao] 
	(
		[rec_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[rec_login_id] INT NOT NULL,
		[rec_login_password_antiga] VARCHAR(50) NOT NULL,
		[rec_login_password_nova] VARCHAR(50) NOT NULL,
		[rec_token] VARCHAR(255) NOT NULL,
		CONSTRAINT fk_rec_login_id FOREIGN KEY (rec_login_id) REFERENCES Pessoas.[Login](login_id)
	)
ON [Pessoas];

CREATE TABLE Escola.[Idioma] 
	(
		[idioma_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[idioma] varchar(5) NOT NULL,
	)
ON [Escola];

CREATE TABLE Escola.[Departamento] 
	(
		[departamento_id] INT PRIMARY KEY IDENTITY(1, 1),
		[departamento_dept_id] INT,
		[departamento] varchar(50) NOT NULL,
		CONSTRAINT fk_departamento_dept_id FOREIGN KEY (departamento_dept_id) REFERENCES Escola.[Departamento](departamento_id)
	)
ON [Escola];

CREATE TABLE Escola.[IdiomaDepartamento] 
	(
		[idioma_departamento_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[idioma_departamento_dep_id] INT NOT NULL,
		[idioma_departamento_idioma_id] INT NOT NULL,
		[idioma_traducao] VARCHAR(255)
		CONSTRAINT fk_idioma_departamento_dep_id FOREIGN KEY (idioma_departamento_dep_id) REFERENCES Escola.[Departamento](departamento_id),
		CONSTRAINT fk_idioma_departamento_idioma_id FOREIGN KEY (idioma_departamento_idioma_id) REFERENCES Escola.[Idioma](idioma_id)
	)
ON [Escola];

CREATE TABLE Escola.[AreaCientifica] 
	(
		[area_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[area_area_id] INT,
		[area_dept_id] INT NOT NULL,
		[area] varchar(50) NOT NULL,
		CONSTRAINT fk_area_area_id FOREIGN KEY (area_area_id) REFERENCES Escola.[AreaCientifica](area_id),
		CONSTRAINT fk_area_dept_id FOREIGN KEY (area_dept_id) REFERENCES Escola.[Departamento](departamento_id),
	)
ON [Escola];

CREATE TABLE Escola.[IdiomaArea] 
	(	
		[idioma_area_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[idioma_area_area_id] INT NOT NULL,
		[idioma_area_idioma_id] INT NOT NULL,
		[idioma_traducao] VARCHAR(255)
		CONSTRAINT fk_idioma_area_area_id FOREIGN KEY (idioma_area_area_id) REFERENCES Escola.[AreaCientifica](area_id),
		CONSTRAINT fk_idioma_area_idioma_id FOREIGN KEY (idioma_area_idioma_id) REFERENCES Escola.[Idioma](idioma_id)
	)
ON [Escola];

CREATE TABLE Escola.[Disciplinas] 
	(
		[disciplina_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[disciplina_area_id] INT,
		[disciplina] varchar(50) NOT NULL,
		CONSTRAINT fk_disciplina_area_id FOREIGN KEY (disciplina_area_id) REFERENCES Escola.[AreaCientifica](area_id),
	)
ON [Escola];

CREATE TABLE Escola.[IdiomaDisciplinas] 
	(
		[idioma_disc_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[idioma_disc_disc_id] INT NOT NULL,
		[idioma_idioma_id] INT NOT NULL,
		[idioma_traducao] VARCHAR(255)
		CONSTRAINT fk_idioma_disc_disc_id FOREIGN KEY (idioma_disc_disc_id) REFERENCES Escola.[Disciplinas](disciplina_id),
		CONSTRAINT fk_idioma_idioma_id FOREIGN KEY (idioma_idioma_id) REFERENCES Escola.[Idioma](idioma_id)
	)
ON [Escola];

CREATE TABLE Escola.[AnoLetivo] 
	(
		[ano_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[ano_letivo] INT NOT NULL UNIQUE,
		[ativo] BIT NOT NULL,
	)
ON [Escola];

CREATE TABLE Escola.[InscricoesFechadas] 
	(
		[inscricoes_fech_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[inscricoes_aluno_id] INT NOT NULL,
		[inscricoes_disciplina_id] INT NOT NULL,
		[inscricoes_ano_id] INT NOT NULL,
		CONSTRAINT fk_inscricoes_aluno_id FOREIGN KEY (inscricoes_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_inscricoes_disciplina_id FOREIGN KEY (inscricoes_disciplina_id) REFERENCES Escola.[Disciplinas](disciplina_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_inscricoes_ano_id FOREIGN KEY (inscricoes_ano_id) REFERENCES Escola.[AnoLetivo](ano_id) ON DELETE CASCADE ON UPDATE CASCADE,
	)
ON [Escola];

CREATE TABLE Escola.[NotasFechadas] 
	(
		[notas_fech_Id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[notas_fech_aluno_id] INT NOT NULL,
		[notas_fech_disciplinas_id] INT NOT NULL,
		[notas_fech_ano_id] INT NOT NULL,
		[notas_fech_periodo] INT NOT NULL CHECK ([notas_fech_periodo] IN (1, 2, 3)),
		[notas_fech_valor] FLOAT NOT NULL CHECK([notas_fech_valor] >= 0.0 AND [notas_fech_valor] <= 20.0),
		CONSTRAINT fk_notas_fech_aluno_id FOREIGN KEY (notas_fech_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_notas_fech_subject_id FOREIGN KEY (notas_fech_disciplinas_id) REFERENCES Escola.[Disciplinas](disciplina_id),
		CONSTRAINT fk_notas_fech_ano_id FOREIGN KEY (notas_fech_ano_id) REFERENCES Escola.[AnoLetivo](ano_id),
	)
ON [Escola];

CREATE TABLE Pessoas.[Faltas]
	(
		[falta_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[falta_aluno_id] INT NOT NULL,
		[falta_disciplina_id] INT NOT NULL,
		[falta_ano_id] INT NOT NULL,
		[falta_numero] INT NOT NULL,
		CONSTRAINT fk_falta_aluno_id FOREIGN KEY (falta_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id) ON DELETE CASCADE ON UPDATE CASCADE,
		CONSTRAINT fk_falta_disciplina_id FOREIGN KEY (falta_disciplina_id) REFERENCES Escola.[Disciplinas](disciplina_id),
		CONSTRAINT fk_falta_ano_id FOREIGN KEY (falta_ano_id) REFERENCES Escola.[AnoLetivo](ano_id)
	) 
ON [Pessoas];

CREATE TABLE Pessoas.[Reprovado]
	(
		[reprovado_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
		[reprovado_aluno_id] INT NOT NULL,
		[reprovado_disciplina_id] INT NOT NULL,
		[reprovado_ano_id] INT NOT NULL,
		CONSTRAINT fk_reprovado_aluno_id FOREIGN KEY (reprovado_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id),
		CONSTRAINT fk_reprovado_disciplina_id FOREIGN KEY (reprovado_disciplina_id) REFERENCES Escola.[Disciplinas](disciplina_id),
		CONSTRAINT fk_reprovado_ano_id FOREIGN KEY (reprovado_ano_id) REFERENCES Escola.[AnoLetivo](ano_id)
	) 
ON [Pessoas];

CREATE TABLE Erros.[ErroLog]
	(
		[erroId] INT IDENTITY(1, 1) NOT NULL,
		[erroNumero] INT,
		[erroEstado] INT,
		[erroMensagem] VARCHAR(MAX),
		[erroProcedure] VARCHAR(128),
		[erroLinha] INT,
		[erroGravidade] INT,
		[erroData] DATETIME 
	) 
ON [Escola];

CREATE TABLE Escola.Email
	(
		email_id INT IDENTITY(1, 1) NOT NULL,
		email_pessoa_id INT,
		email_mensagem VARCHAR(255)
		CONSTRAINT fk_email_aluno_id FOREIGN KEY (email_pessoa_id) REFERENCES Pessoas.[Aluno](aluno_id)
	)
ON [Escola];