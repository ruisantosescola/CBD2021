/***************************************************
* 
* Projeto de Complementos de Base de Dados 2020/2021
*
* Grupo: Andrei-Florin Balcan (200221154) e Ivan Barrinho Lopes (20221145)
*
* Turma: 2�L_EI-SW-05 
*
* SCRIPTS DE MIGRA��O
*
***************************************************/

USE AgrupamentoSTB;

--Migra��o para a tabela Pessoa;
INSERT INTO 
Pessoas.Pessoa(pessoa_nome, pessoa_sexo, pessoa_data_nascimento, pessoa_morada, pessoa_morada_alternativa, pessoa_email)
SELECT 'NomeTeste', sex, [Birth Date], [address], 'Morada Alternativa Teste', 'random@gmail.com'
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO 
Pessoas.Pessoa(pessoa_nome, pessoa_sexo, pessoa_data_nascimento, pessoa_morada, pessoa_morada_alternativa, pessoa_email)
SELECT 'NomeTeste', sex, [Birth Date], [address], 'Morada Alternativa Teste', 'random@gmail.com'
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO 
Pessoas.Pessoa(pessoa_nome, pessoa_sexo, pessoa_data_nascimento, pessoa_morada, pessoa_morada_alternativa, pessoa_email)
SELECT 'NomeTeste', sex, [Birth Date], [address], 'Morada Alternativa Teste', 'random@gmail.com'
FROM oldData.[dbo].['2019 BD$'];

--Teste de verifica��o da tabela Pessoa;
SELECT * FROM Pessoas.Pessoa;


--=====================================================================================================


--Migra��o para a tabela TravelTime;
INSERT INTO Pessoas.TempoViagem(tempoviagem)
VALUES('< 15 min') ,('15 a 30 min'), ('30 min a 1 hora'), (' > 1 hora');

--Teste de verifica��o da tabela TempoViagem;
SELECT * FROM Pessoas.TempoViagem;


--=====================================================================================================


--Migra��o para a tabela TempoEstudo;
INSERT INTO Pessoas.TempoEstudo(tempoestudo)
VALUES('< 2 horas') ,('2 a 5 horas'), ('5 a 10 horas'), (' > 10 horas');

--Teste de verifica��o da tabela TempoEstudo;
SELECT * FROM Pessoas.TempoEstudo;


--=====================================================================================================


--Migra��o para a tabela Qualidade;
INSERT INTO Pessoas.Qualidade(qualidade)
VALUES('Muito m�') ,('M�'), ('Normal'), ('Boa'), ('Muito Boa');

--Teste de verifica��o da tabela Qualidade;
SELECT * FROM Pessoas.Qualidade;


--=====================================================================================================


--Migra��o para a tabela Quantidade;
INSERT INTO Pessoas.Quantidade(quantidade)
VALUES('Muito pouco') ,('Pouco'), ('Normal'), ('Elevado'), ('Muito Elevado');

--Teste de verifica��o da tabela Quantidade;
SELECT * FROM Pessoas.Quantidade;


--=====================================================================================================


--Migra��o para a tabela Motivo;
INSERT INTO Pessoas.Motivo(motivo)
VALUES('Perto de casa') ,('Reputa��o da Escola'), ('Prefer�ncia de Curso'), ('Outro');

--Teste de verifica��o da tabela Motivo;
SELECT * FROM Pessoas.Motivo;


--=====================================================================================================


--Migra��o para a tabela Emprego;
INSERT INTO Pessoas.Emprego(emprego)
VALUES('Professor(a)') ,('�rea da Sa�de'), ('Servi�os P�blico (Ex.: Pol�cia)'), ('Em Casa'), ('Outro');

--Teste de verifica��o da tabela Emprego;
SELECT * FROM Pessoas.Emprego;


--=====================================================================================================


--Migra��o para a tabela Aluno dos dados dos anos 2017, 2017 e 2019;
INSERT INTO Pessoas.Aluno(aluno_pessoa_id, aluno_numero, aluno_escola, aluno_agregado, aluno_pais_coabitacao, aluno_motivo_id, aluno_tempo_viagem_id, aluno_tempo_estudo_id, aluno_bolseiro, aluno_suporte_familia, aluno_explicacao, aluno_atividades, aluno_infantario, aluno_intencao, aluno_internet, aluno_relacionamento, aluno_relacionamento_familiar_id, aluno_tempo_livre_id, aluno_saidas_id, aluno_alcool_semana_id, aluno_alcool_fim_id, aluno_saude_id)
	SELECT [Student Number], 
		   [Student Number], 
		   [school], 
		   CASE WHEN  [famsize] = 'LE3' THEN 2 ELSE 3 END, 
		   [Pstatus], 
		   CASE WHEN  [reason] = 'home' THEN 1 WHEN [reason] = 'reputation' THEN 2 WHEN [reason] = 'course' THEN 3 ELSE 4 END,
		   [traveltime], 
		   [studytime], 
		   CASE WHEN [schoolsup] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [famsup] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [paid] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [activities] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [nursery] = 'yes' THEN 1 ELSE 0 END, 
	       CASE WHEN [higher] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [internet] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [romantic] = 'yes' THEN 1 ELSE 0 END, 
		   [famrel], 
		   [freetime], 
		   [goout], 
		   [Dalc], 
		   [Walc], 
		   [health]
	FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Pessoas.Aluno(aluno_pessoa_id, aluno_numero, aluno_escola, aluno_agregado, aluno_pais_coabitacao, aluno_motivo_id, aluno_tempo_viagem_id, aluno_tempo_estudo_id, aluno_bolseiro, aluno_suporte_familia, aluno_explicacao, aluno_atividades, aluno_infantario, aluno_intencao, aluno_internet, aluno_relacionamento, aluno_relacionamento_familiar_id, aluno_tempo_livre_id, aluno_saidas_id, aluno_alcool_semana_id, aluno_alcool_fim_id, aluno_saude_id )
	SELECT [Student Number], 
		   [Student Number], 
		   [school],
		   CASE WHEN  [famsize] = 'LE3' THEN 2 ELSE 3 END,
		   [Pstatus], 
		   CASE WHEN  [reason] = 'home' THEN 1 WHEN [reason] = 'reputation' THEN 2 WHEN [reason] = 'course' THEN 3 ELSE 4 END,
		   [traveltime], 
		   [studytime], 
		   CASE WHEN [schoolsup] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [famsup] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [paid] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [activities] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [nursery] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [higher] = 'yes' THEN 1 ELSE 0 END, 
		   CASE WHEN [internet] = 'yes' THEN 1 ELSE 0 END, CASE WHEN [romantic] = 'yes' THEN 1 ELSE 0 END, 
		   [famrel], 
		   [freetime], 
		   [goout], 
		   [Dalc], 
		   [Walc], 
		   [health]
	FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Pessoas.Aluno(aluno_pessoa_id, aluno_numero, aluno_escola, aluno_agregado, aluno_pais_coabitacao, aluno_motivo_id, aluno_tempo_viagem_id, aluno_tempo_estudo_id, aluno_bolseiro, aluno_suporte_familia, aluno_explicacao, aluno_atividades, aluno_infantario, aluno_intencao, aluno_internet, aluno_relacionamento, aluno_relacionamento_familiar_id, aluno_tempo_livre_id, aluno_saidas_id, aluno_alcool_semana_id, aluno_alcool_fim_id, aluno_saude_id )
	SELECT [Student Number], 
		   [Student Number], 
		   [school],
		   CASE WHEN  [famsize] = 'LE3' THEN 2 ELSE 3 END,
		   [Pstatus], 
		   CASE WHEN  [reason] = 'home' THEN 1 WHEN [reason] = 'reputation' THEN 2 WHEN [reason] = 'course' THEN 3 ELSE 4 END,
		   [traveltime],
		   [studytime],
		   CASE WHEN [schoolsup] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [famsup] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [paid] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [activities] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [nursery] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [higher] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [internet] = 'yes' THEN 1 ELSE 0 END,
		   CASE WHEN [romantic] = 'yes' THEN 1 ELSE 0 END,
		   [famrel],
		   [freetime],
		   [goout],
		   [Dalc],
		   [Walc],
		   [health]
	FROM oldData.[dbo].['2019 BD$'];

--Teste de verifica��o da tabela Aluno;
SELECT * FROM Pessoas.Aluno;


--=====================================================================================================


--Tabela Pais


--=====================================================================================================


--Tabela Encarregado_educacao


--=====================================================================================================


--Migra��o para a tabela Hierarquia;
INSERT INTO Pessoas.Hierarquia(hierarquia)
VALUES ('Estudante'), ('Encarregado Educa��o');

--Teste de verifica��o da tabela Hierarquia;
SELECT * FROM Pessoas.Hierarquia;


--=====================================================================================================


--Migra��o para a tabela Login dos dados dos anos 2017, 2018 e 2019;
INSERT INTO Pessoas.Login(login_pessoa_id, login_hierarquia_id, login_password)
SELECT [Student Number], 1, 'pass'
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Pessoas.Login(login_pessoa_id, login_hierarquia_id, login_password)
SELECT [Student Number], 1, 'pass'
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Pessoas.Login(login_pessoa_id, login_hierarquia_id, login_password)
SELECT [Student Number], 1, 'pass'
FROM oldData.[dbo].['2019 BD$'];

--Teste de verifica��o da tabela Login;
SELECT * FROM Pessoas.Login;


--=====================================================================================================


--Tabela Recupera��o


--=====================================================================================================


--Migra��o para a tabela Escola.Idioma;
INSERT INTO Escola.Idioma(idioma)
VALUES ('PT'), ('ENG');

--Teste de verifica��o da tabela Idioma;
SELECT * FROM Escola.Idioma;


--=====================================================================================================


--Migra��o para a tabela Departamento;
INSERT INTO Escola.Departamento(departamento)
SELECT DISTINCT[departamento]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.Departamento(departamento)
SELECT DISTINCT[departamento]
FROM oldData.[dbo].['2017 MAT$'];

--Teste de verifica��o da tabela Departamento;
SELECT * FROM Escola.Departamento;


--=====================================================================================================


--Migra��o para a tabela IdiomaDepartamento;
INSERT INTO Escola.IdiomaDepartamento(idioma_departamento_dep_id, idioma_departamento_idioma_id, idioma_traducao)
VALUES (1, 1, 'Departamento de Sistemas de Informa��o'), (1, 2, 'Information Systems Department'), (2, 1, 'Departamento de Matem�tica'), (2, 2, 'Mathematics Department');


--Teste de verifica��o da tabela IdiomaDepartamento;
SELECT * FROM Escola.IdiomaDepartamento;


--=====================================================================================================


--Migra��o para a tabela AreaCientifica
INSERT INTO Escola.AreaCientifica(area_dept_id, area)
SELECT DISTINCT 1, [area]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.AreaCientifica(area_dept_id, area)
SELECT DISTINCT 2, [area]
FROM oldData.[dbo].['2017 MAT$'];

--Teste de verifica��o da tabela AreaCientifica;
SELECT * FROM Escola.AreaCientifica;


--=====================================================================================================


--Migra��o para a tabela IdiomaArea;
INSERT INTO Escola.IdiomaArea(idioma_area_area_id, idioma_area_idioma_id, idioma_traducao)
VALUES (1, 1, 'Base de Dados'), (1, 2, 'Databases'), (2, 1, 'Matem�tica'), (2, 2, 'Mathematics');

--Teste de verifica��o da tabela IdiomaArea;
SELECT * FROM Escola.IdiomaArea;


--=====================================================================================================


--Migra��o para a tabela Disciplinas;
INSERT INTO Escola.Disciplinas(disciplina_area_id, disciplina)
SELECT DISTINCT 1, [disc]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.Disciplinas(disciplina_area_id, disciplina)
SELECT DISTINCT 1, [disc]
FROM oldData.[dbo].['2017 CBD$'];

INSERT INTO Escola.Disciplinas(disciplina_area_id, disciplina)
SELECT DISTINCT 2, [disc]
FROM oldData.[dbo].['2017 MAT$'];

--Teste de verifica��o da tabela Disciplinas;
SELECT * FROM Escola.Disciplinas;


--=====================================================================================================


--Migra��o para a tabela IdiomaDisciplinas;
INSERT INTO Escola.IdiomaDisciplinas(idioma_disc_disc_id, idioma_idioma_id, idioma_traducao)
VALUES (1, 1, 'Bases de Dados'), (1, 2, 'Databases'), (2, 1, 'Complementos de Base de Dados'), (2, 2, 'Database Add-ons'), (3, 1, 'Matem�tica 1'), (3, 2, 'Mathematics 1');

--Teste de verifica��o da tabela IdiomaDisciplinas;
SELECT * FROM Escola.IdiomaDisciplinas;


--=====================================================================================================


--Migra��o da tabela AnoLetivo de todos os anos (2017, 2018 e 2019);
INSERT INTO Escola.AnoLetivo(ano_letivo, ativo)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2017 MAT$'];

INSERT INTO Escola.AnoLetivo(ano_letivo, ativo)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2018 MAT$'];

INSERT INTO Escola.AnoLetivo(ano_letivo, ativo)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2019 MAT$'];

--Teste de verifica��o da tabela AnoLetivo;
SELECT * FROM Escola.AnoLetivo;


--=====================================================================================================


--Migra��o da tabela InscricoesFechadas;
INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 1, 1
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 2, 1
FROM oldData.[dbo].['2017 CBD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 3, 1
FROM oldData.[dbo].['2017 MAT$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 1, 2
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 2, 2
FROM oldData.[dbo].['2018 CBD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 3, 2
FROM oldData.[dbo].['2018 MAT$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 1, 3
FROM oldData.[dbo].['2019 BD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 2, 3
FROM oldData.[dbo].['2019 CBD$'];

INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
SELECT [Student Number], 3, 3
FROM oldData.[dbo].['2019 MAT$'];

--Teste de verifica��o da tabela InscricoesFechadas;
SELECT * FROM Escola.InscricoesFechadas;


--=====================================================================================================


--Migra��o para a tabela NotasFechadas;

-- DISCIPLINA BD, ANO 2017;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 1, 1, [P1]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 1, 2, [P2]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 1, 3, [P3]
FROM oldData.[dbo].['2017 BD$'];

--DISCIPLINA CBD, ANO 2017;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 2, 1, [P1]
FROM oldData.[dbo].['2017 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 2, 2, [P2]
FROM oldData.[dbo].['2017 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 2, 3, [P3]
FROM oldData.[dbo].['2017 CBD$'];

--DISCIPLINA MAT, ANO 2017;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 3, 1, [P1]
FROM oldData.[dbo].['2017 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 3, 2, [P2]
FROM oldData.[dbo].['2017 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 1, 3, 3, [P3]
FROM oldData.[dbo].['2017 MAT$'];

--DISCIPLINA BD, ANO 2018;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 1, 1, [P1]
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 1, 2, [P2]
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 1, 3, [P3]
FROM oldData.[dbo].['2018 BD$'];

--DISCIPLINA CBD, ANO 2018;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 2, 1, [P1]
FROM oldData.[dbo].['2018 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 2, 2, [P2]
FROM oldData.[dbo].['2018 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 2, 3, [P3]
FROM oldData.[dbo].['2018 CBD$'];

--DISCIPLINA MAT, ANO 2018;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 3, 1, [P1]
FROM oldData.[dbo].['2018 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 3, 2, [P2]
FROM oldData.[dbo].['2018 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 2, 3, 3, [P3]
FROM oldData.[dbo].['2018 MAT$'];

--DISCIPLINA BD, ANO 2019;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 1, 1, [P1]
FROM oldData.[dbo].['2019 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 1, 2, [P2]
FROM oldData.[dbo].['2019 BD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 1, 3, [P3]
FROM oldData.[dbo].['2019 BD$'];

--DISCIPLINA CBD, ANO 2019;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 2, 1, [P1]
FROM oldData.[dbo].['2019 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 2, 2, [P2]
FROM oldData.[dbo].['2019 CBD$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 2, 3, [P3]
FROM oldData.[dbo].['2019 CBD$'];


--DISCIPLINA MAT, ANO 2019;
INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 3, 1, [P1]
FROM oldData.[dbo].['2019 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 3, 2, [P2]
FROM oldData.[dbo].['2019 MAT$'];

INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_ano_id, notas_fech_disciplinas_id, notas_fech_periodo, notas_fech_valor)
SELECT [Student Number], 3, 3, 3, [P3]
FROM oldData.[dbo].['2019 MAT$'];

--Teste de verifica��o da tabela NotasFechadas;
SELECT * FROM Escola.NotasFechadas;


--=====================================================================================================


--Migra��o para a tabela Faltas;
INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 1, 1, [absences]
FROM oldData.[dbo].['2017 BD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 2, 1, [absences]
FROM oldData.[dbo].['2017 CBD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 3, 1, [absences]
FROM oldData.[dbo].['2017 MAT$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 1, 2, [absences]
FROM oldData.[dbo].['2018 BD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 2, 2, [absences]
FROM oldData.[dbo].['2018 CBD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 3, 2, [absences]
FROM oldData.[dbo].['2018 MAT$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 1, 3, [absences]
FROM oldData.[dbo].['2019 BD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 2, 3, [absences]
FROM oldData.[dbo].['2019 CBD$'];

INSERT INTO Pessoas.[Faltas](falta_aluno_id, falta_disciplina_id, falta_ano_id, falta_numero)
SELECT [Student Number], 3, 3, [absences]
FROM oldData.[dbo].['2019 MAT$'];

--Teste de verifica��o da tabela Faltas;
SELECT * FROM Pessoas.[Faltas];


--=====================================================================================================



--Migra��o para a tabela Reprovado;
INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 1, 1
FROM oldData.[dbo].['2017 BD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 2, 1
FROM oldData.[dbo].['2017 CBD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 3, 1
FROM oldData.[dbo].['2017 MAT$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 1, 2
FROM oldData.[dbo].['2018 BD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 2, 2
FROM oldData.[dbo].['2018 CBD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 3, 2
FROM oldData.[dbo].['2018 MAT$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 1, 3
FROM oldData.[dbo].['2019 BD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 2, 3
FROM oldData.[dbo].['2019 CBD$']
WHERE [failures] = '4';

INSERT INTO Pessoas.[Reprovado](reprovado_aluno_id, reprovado_disciplina_id, reprovado_ano_id)
SELECT [Student Number], 3, 3
FROM oldData.[dbo].['2019 MAT$']
WHERE [failures] = '4';

--Teste de verifica��o da tabela Reprovado;
SELECT * FROM Pessoas.[Reprovado];

--=====================================================================================================