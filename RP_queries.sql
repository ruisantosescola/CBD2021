/***************************************************
* 
* Projeto de Complementos de Base de Dados 2020/2021
*
* Grupo: Andrei-Florin Balcan (200221154) e Ivan Barrinho Lopes (20221145)
*
* Turma: 2ºL_EI-SW-05 
*
* QUERIES E STORED PROCEDURES
*
***************************************************/


--=====================================================================================================
--QUERIES
--=====================================================================================================
USE AgrupamentoSTB;

--Media de nota no ano letivo por escola
SELECT AVG(n.notas_fech_valor) AS media, al.aluno_escola AS escola, a.ano_letivo AS ano 
FROM ((Escola.NotasFechadas n 
INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id)
INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id) 
GROUP BY a.ano_letivo, al.aluno_escola;

--Média de notas por ano letivo e período letivo por escola
SELECT AVG(CASE WHEN n.notas_fech_periodo = 1 THEN n.notas_fech_valor ELSE NULL END) AS P1, 
	   AVG(CASE WHEN n.notas_fech_periodo = 2 THEN n.notas_fech_valor ELSE NULL END) AS P2,
	   AVG(CASE WHEN n.notas_fech_periodo = 3 THEN n.notas_fech_valor ELSE NULL END) AS P3, 
	   al.aluno_escola, a.ano_letivo
FROM (Escola.NotasFechadas n 
INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id) 
GROUP BY a.ano_letivo, al.aluno_escola;

--Total de alunos por escola/ano letivo
SELECT COUNT(DISTINCT al.aluno_id) AS alunos, al.aluno_escola, a.ano_letivo
FROM (((Pessoas.Aluno al
INNER JOIN Escola.InscricoesFechadas i ON al.aluno_id = i.inscricoes_aluno_id)
INNER JOIN Escola.AnoLetivo a ON i.inscricoes_ano_id = a.ano_id)
INNER JOIN Escola.Disciplinas d on i.inscricoes_disciplina_id = d.disciplina_id) GROUP BY a.ano_letivo, al.aluno_escola;

--=====================================================================================================
--STORED PROECDURES
--=====================================================================================================
USE AgrupamentoSTB
GO

--Stored procedure para o tratamento de erros;
DROP PROCEDURE IF EXISTS Escola.sp_CatchError;

CREATE OR ALTER PROCEDURE Escola.sp_CatchError
AS
BEGIN
	INSERT INTO Erros.ErroLog
	(
	ErroNumero, 
	ErroEstado, 
	ErroMensagem,
	ErroProcedure, 
	ErroLinha, 
	ErroGravidade,
	ErroData
	)
	SELECT ERROR_NUMBER() as ErroNumero,
		   ERROR_STATE() as ErroEstado,
		   ERROR_MESSAGE() as ErroMensagem,
		   ERROR_PROCEDURE() as ErroProcedure,
		   ERROR_LINE () as ErroLinha,
		   ERROR_SEVERITY() as ErroGravidade,
		   SYSDATETIME() as ErroData
	PRINT 'Erro: ' + ERROR_MESSAGE();
	PRINT 'Linha: ' + CONVERT(varchar, ERROR_LINE());
END

--Teste da criação da tabela dos erros;
SELECT * FROM Erros.ErroLog;


--=====================================================================================================


--Criação da stored procedure para Abrir um Ano Letivo;
DROP PROCEDURE IF EXISTS Escola.sp_AbrirAnoLetivo;

CREATE OR ALTER PROCEDURE Escola.sp_AbrirAnoLetivo
    @Ano NVARCHAR(MAX)
	WITH EXECUTE AS OWNER
AS
	BEGIN
		SET XACT_ABORT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
			EXEC(
				'CREATE TABLE Escola.Notas' + @Ano + ' (
				notas' + @Ano + '_id INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				notas' + @Ano + '_aluno_id INT NOT NULL,
				notas' + @Ano + '_disciplina_id INT NOT NULL,
				notas' + @Ano + '_ano_id INT NOT NULL,
				notas' + @Ano + '_periodo INT NOT NULL CHECK ([notas' + @Ano + '_periodo] IN (1, 2, 3)),
				notas' + @Ano + '_valor FLOAT NOT NULL CHECK([notas' + @Ano + '_valor] >= 0.0 AND [notas' + @Ano + '_valor] <= 20.0),
				CONSTRAINT fk_notas' + @Ano + '_aluno_id FOREIGN KEY (notas' + @Ano + '_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id),
				CONSTRAINT fk_notas' + @Ano + '_disciplina_id FOREIGN KEY (notas' + @Ano + '_disciplina_id) REFERENCES Escola.[Disciplinas](disciplina_id),
				CONSTRAINT fk_notas' + @Ano + '_ano_id FOREIGN KEY (notas' + @Ano + '_ano_id) REFERENCES Escola.[AnoLetivo](ano_id)
			   )ON [Escola]'
			   );
			EXEC('CREATE TABLE Escola.Inscricoes' + @Ano + ' (
				inscricoes' + @Ano + '_id INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				inscricoes' + @Ano + '_aluno_id INT NOT NULL, 
				inscricoes' + @Ano + '_disciplina_id INT NOT NULL,
				inscricoes' + @Ano + '_ano_id INT NOT NULL,
				CONSTRAINT fk_inscricoes' + @Ano + '_aluno_id FOREIGN KEY (inscricoes' + @Ano + '_aluno_id) REFERENCES Pessoas.[Aluno](aluno_id),
				CONSTRAINT fk_inscricoes' + @Ano + '_disciplina_id FOREIGN KEY (inscricoes' + @Ano + '_disciplina_id) REFERENCES Escola.[Disciplinas](disciplina_id),
				CONSTRAINT fk_inscricoes' + @Ano + '_ano_id FOREIGN KEY (inscricoes' + @Ano + '_ano_id) REFERENCES Escola.[AnoLetivo](ano_id)
			   )
			   ON [Escola]'
			   );
			EXEC('UPDATE Escola.AnoLetivo SET ativo = 0;');
			EXEC('INSERT INTO Escola.AnoLetivo(ano_letivo,ativo) VALUES ('+ @Ano + ',1);');
			COMMIT
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE()
			IF @@TRANCOUNT > 0
				ROLLBACK
			EXEC Escola.sp_CatchError
		END CATCH
	END

--Teste da stored procedure sp_AbrirAnoLetivo com a abertura do ano letivo 2021;
EXEC Escola.sp_AbrirAnoLetivo @Ano = 2021;


--=====================================================================================================


--Criação da stored procedure para inscrever um aluno na disciplina;

DROP PROCEDURE IF EXISTS Escola.sp_IncreverAluno;

CREATE OR ALTER PROCEDURE Escola.sp_InscreverAluno
	@aluno INT,
	@disciplina VARCHAR(50)
AS  
	BEGIN 
		BEGIN TRY  
			DECLARE @ano INT = (SELECT ano_letivo FROM Escola.AnoLetivo WHERE ativo = 1);
			DECLARE @ano_id INT = (SELECT ano_id FROM Escola.AnoLetivo WHERE ativo = 1);
			DECLARE @disciplina_id INT = (SELECT disciplina_id FROM Escola.Disciplinas WHERE disciplina = @disciplina);
			DECLARE @aluno_id INT = (SELECT aluno_id FROM Pessoas.Aluno WHERE aluno_numero = @aluno); 
			EXEC('INSERT INTO Escola.Inscricoes' + @ano + '(inscricoes' + @ano + '_aluno_id, inscricoes' + @ano + '_disciplina_id, inscricoes' + @ano + '_ano_id)
			VALUES(' + @aluno_id + ',' + @disciplina_id + ',' + @ano_id + ')');
		END TRY  
		BEGIN CATCH  
			EXEC Escola.sp_CatchError
		END CATCH  
	END

--Teste da stored procedure sp_InscreverAluno para inscrever o aluno com o número 1 na disciplina BD;
EXEC Escola.sp_InscreverALuno @aluno = 1, @disciplina = 'BD';


--=====================================================================================================


--Criação da stored procedure para atualizar a nota de um aluno, numa disciplina pertencente a um determinado periodo;
DROP PROCEDURE IF EXISTS Escola.sp_AtualizarNota;

CREATE OR ALTER PROCEDURE Escola.sp_AtualizarNota 
	@aluno INT,
	@disciplina VARCHAR(255),
	@nota_valor INT,
	@periodo_id INT
	WITH EXECUTE AS OWNER
AS  
	BEGIN 
		SET XACT_ABORT ON
		BEGIN TRY  
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
			DECLARE @ano INT = (SELECT ano_letivo FROM Escola.AnoLetivo WHERE ativo = 1);
			DECLARE @disciplina_id INT = (SELECT disciplina_id FROM Escola.Disciplinas WHERE disciplina = @disciplina);
 			DECLARE @aluno_id INT = (SELECT aluno_id FROM Pessoas.Aluno WHERE aluno_numero = @aluno);
		EXEC('UPDATE Escola.Notas' + @ano + ' SET notas' + @ano + '_valor =' + @nota_valor + 'WHERE notas'+ @ano +'_disciplina_id =' + @disciplina_id + ' AND notas'+ @ano +'_aluno_id =' + @aluno_id + ' AND notas'+ @ano +'_periodo =' + @periodo_id);
		COMMIT TRAN
		END TRY  
		BEGIN CATCH  
		SELECT ERROR_MESSAGE()
			IF @@TRANCOUNT > 0
				ROLLBACK
			EXEC Escola.sp_CatchError
		END CATCH  
	END


--Inserir e verificar se a nota 20 foi atribuida;
INSERT INTO Escola.Notas2021(notas2021_aluno_id, notas2021_disciplina_id, notas2021_ano_id, notas2021_periodo, notas2021_valor) 
VALUES (2,3,4,1,20);
SELECT * FROM Escola.Notas2021;


--Teste da stored procedure sp_AtualizarNota e alterar a nota de MAT1 para 0 valores;
EXEC Escola.sp_AtualizarNota @aluno = 2, @disciplina = MAT1, @nota_valor = 19, @periodo_id = 1;

--Verificar se a nota ficou alterada para 0 valores;
SELECT * FROM Escola.Notas2021;


--=====================================================================================================


--Stored procedure para calcular o total de alunos de alunos inscritos em cada uma das disciplinas no ano aberto face ao ano anterior e a respetiva taxa de crescimento.
DROP PROCEDURE IF EXISTS Escola.sp_TotalAlunosAberto;

CREATE OR ALTER PROCEDURE Escola.sp_TotalAlunosAberto
AS
	BEGIN
		BEGIN TRY
			DECLARE @ano INT = (SELECT ano_letivo FROM Escola.AnoLetivo WHERE ativo = 1)
			DECLARE @anoAnterior INT = @ano - 1
			DECLARE @disciplinas INT = (SELECT COUNT(*) FROM Escola.Disciplinas)
			DECLARE @cnt INT = 1
			EXEC ('SELECT COUNT(DISTINCT al.aluno_id) AS alunos' + @ano +', d.disciplina
				   FROM (((Pessoas.Aluno al
				   INNER JOIN Escola.Inscricoes' + @ano +' i ON al.aluno_id = i.inscricoes' + @ano +'_aluno_id)
				   INNER JOIN Escola.AnoLetivo a ON i.inscricoes' + @ano +'_ano_id = a.ano_id)
				   INNER JOIN Escola.Disciplinas d on i.inscricoes' + @ano +'_disciplina_id = d.disciplina_id) GROUP BY a.ano_letivo, d.disciplina'
				 );
			EXEC ('SELECT COUNT(DISTINCT al.aluno_id) AS alunosAnterior , d.disciplina
				   FROM (((Pessoas.Aluno al
				   INNER JOIN Escola.InscricoesFechadas i ON al.aluno_id = i.inscricoes_aluno_id)
				   INNER JOIN Escola.AnoLetivo a ON i.inscricoes_ano_id = a.ano_id)
				   INNER JOIN Escola.Disciplinas d on i.inscricoes_disciplina_id = d.disciplina_id) WHERE a.ano_letivo = ' + @ano +' - 1 GROUP BY a.ano_letivo, d.disciplina'
				 );
			WHILE @cnt <= @disciplinas
			BEGIN
				EXEC ('SELECT ((SELECT COUNT(DISTINCT al.aluno_id) AS alunos
					   FROM (((Pessoas.Aluno al
					   INNER JOIN Escola.Inscricoes' + @ano +' i ON al.aluno_id = i.inscricoes' + @ano +'_aluno_id)
					   INNER JOIN Escola.AnoLetivo a ON i.inscricoes' + @ano +'_ano_id = a.ano_id)
					   INNER JOIN Escola.Disciplinas d on i.inscricoes' + @ano +'_disciplina_id = d.disciplina_id) WHERE d.disciplina_id = ' + @cnt + ' GROUP BY a.ano_letivo, d.disciplina)
						-
						(SELECT COUNT(DISTINCT al.aluno_id) AS alunos
						FROM (((Pessoas.Aluno al
						INNER JOIN Escola.InscricoesFechadas i ON al.aluno_id = i.inscricoes_aluno_id)
						INNER JOIN Escola.AnoLetivo a ON i.inscricoes_ano_id = a.ano_id)
						INNER JOIN Escola.Disciplinas d on i.inscricoes_disciplina_id = d.disciplina_id) WHERE a.ano_letivo = ' + @ano +' - 1 AND d.disciplina_id = ' + @cnt + ' GROUP BY a.ano_letivo, d.disciplina)) as taxa, d.disciplina
						FROM Escola.Disciplinas d Where disciplina_id = ' + @cnt)
			SET @cnt = @cnt + 1;
			END
		END TRY
		BEGIN CATCH
			EXEC Escola.sp_CatchError
		END CATCH
	END

--Teste da stored procedure sp_TotalAlunosAberto;
EXEC Escola.sp_TotalAlunosAberto;


--=====================================================================================================


--Stored procedure para calcular a média de notas de todos os alunos por escola num determinado ano e a respetiva taxa de crescimento face ao ano anterior.
DROP PROCEDURE IF EXISTS Escola.sp_MediaDeNotas;

CREATE OR ALTER PROCEDURE Escola.sp_MediaDeNotas
	@ano INT
AS
	BEGIN
		BEGIN TRY
			DECLARE @ultimoAno INT = (SELECT ano_letivo FROM Escola.AnoLetivo WHERE ativo = 1)
			DECLARE @anoAnterior INT = @ano - 1
			IF @ano = @ultimoAno
				BEGIN
					EXEC ('SELECT AVG(nn.notas' + @ano +'_valor) as Media' + @ano +', AVG(n.notas_fech_valor) as Media' + @anoAnterior +', al.aluno_escola AS escola
						FROM Escola.Notas' + @ano +' nn, Escola.NotasFechadas n
						INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior +' GROUP BY a.ano_letivo, al.aluno_escola')

					EXEC ('SELECT (((AVG(nn.notas' + @ano +'_valor) - AVG(n.notas_fech_valor))*100)/20) as taxa, al.aluno_escola AS escola
						FROM Escola.Notas' + @ano +' nn, Escola.NotasFechadas n
						INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior +' GROUP BY a.ano_letivo, al.aluno_escola')
				END
			ELSE
				BEGIN
					EXEC ('SELECT AVG(notas_fech_valor) as MediaGP' + @ano + '
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @ano + ' AND al.aluno_escola = ''GP'' GROUP BY a.ano_letivo, al.aluno_escola'
						 );

					EXEC ('SELECT AVG(notas_fech_valor) as MediaGP' + @anoAnterior + '
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior + ' AND al.aluno_escola = ''GP'' GROUP BY a.ano_letivo, al.aluno_escola'
						 );

					EXEC ('SELECT AVG(notas_fech_valor) as MediaMS' + @ano + '
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @ano + ' AND al.aluno_escola = ''Ms'' GROUP BY a.ano_letivo, al.aluno_escola'
						 );

					EXEC ('SELECT AVG(notas_fech_valor) as MediaMS' + @anoAnterior + '
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior + ' AND al.aluno_escola = ''MS'' GROUP BY a.ano_letivo, al.aluno_escola'
						 );
				
					EXEC ('SELECT 
						   ((((SELECT AVG(notas_fech_valor)
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @ano + ' AND al.aluno_escola = ''GP'' GROUP BY a.ano_letivo, al.aluno_escola)) 
						- 
						   (SELECT AVG(notas_fech_valor)
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior + ' AND al.aluno_escola = ''GP'' GROUP BY a.ano_letivo, al.aluno_escola)
					       )*100/20) as taxaGP'
						 );

					EXEC ('SELECT 
						   ((((SELECT AVG(notas_fech_valor)
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @ano + ' AND al.aluno_escola = ''Ms'' GROUP BY a.ano_letivo, al.aluno_escola)) 
						- 
					       (SELECT AVG(notas_fech_valor)
						   FROM Escola.NotasFechadas n 
						   INNER JOIN Escola.AnoLetivo a ON n.notas_fech_ano_id = a.ano_id
						   INNER JOIN Pessoas.Aluno al ON n.notas_fech_aluno_id = al.aluno_id WHERE a.ano_letivo = ' + @anoAnterior + ' AND al.aluno_escola = ''MS'' GROUP BY a.ano_letivo, al.aluno_escola)
						   )*100/20) as taxaMS'
						 );
			END
		END TRY
		BEGIN CATCH
			EXEC Escola.sp_CatchError;
		END CATCH
	END

--Teste da stored procedure sp_TotalAlunosAberto para o ano de 2019;
EXEC Escola.sp_MediaDeNotas @ano = 2019;


--=====================================================================================================


--Stored procedure para fechar um ano letivo;
DROP PROCEDURE IF EXISTS Escola.sp_FecharAnoLetivo;

CREATE OR ALTER PROCEDURE Escola.sp_FecharAnoLetivo
	WITH EXECUTE AS OWNER
AS
	BEGIN
		SET XACT_ABORT ON
		BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
			DECLARE @ano INT;
			SET @ano = (SELECT ano_letivo FROM Escola.AnoLetivo WHERE ativo = 1);
			EXEC('INSERT INTO Escola.NotasFechadas(notas_fech_aluno_id, notas_fech_disciplinas_id, notas_fech_ano_id, notas_fech_periodo, notas_fech_valor)
			SELECT notas' + @ano +'_aluno_id, notas' + @ano +'_disciplina_id, notas' + @ano +'_ano_id, notas' + @ano +'_periodo, notas' + @ano +'_valor FROM Escola.Notas' + @ano);
			EXEC('DROP TABLE IF EXISTS Escola.Notas' + @ano);
			EXEC('INSERT INTO Escola.InscricoesFechadas(inscricoes_aluno_id, inscricoes_disciplina_id, inscricoes_ano_id)
			SELECT inscricoes' + @ano + '_aluno_id, inscricoes' + @ano + '_disciplina_id, inscricoes' + @ano + '_ano_id FROM Escola.Inscricoes' + @ano);
			EXEC('DROP TABLE IF EXISTS Escola.Inscricoes' + @ano);
			EXEC('UPDATE Escola.AnoLetivo  SET ativo = 0 WHERE ano_letivo =' + @ano);
			COMMIT TRAN
		END TRY
		BEGIN CATCH
		SELECT ERROR_MESSAGE()
			IF @@TRANCOUNT > 0
				ROLLBACK
			EXEC Escola.sp_CatchError
		END CATCH
	END

--Teste da stored procedure sp_FecharAnoLetivo do ano letivo ativo;
EXEC Escola.sp_FecharAnoLetivo;


--=====================================================================================================
-- QUERIES DE CONFIRMAÇÃO DA MIGRAÇÃO UTILIZANDO A BASE DE DADOS ANTIGA
--=====================================================================================================

--ALTERAR A BASE DE DADOS PARA O NOME INSERIDO NO IMPORT!!
USE OldData;

--Media de nota no ano letivo por escola;
SELECT ((SUM(bd.P1) + SUM(bd.P2) + SUM(bd.P3)) + (SUM(cbd.P1) + SUM(cbd.P2) + SUM(cbd.P3)) + (SUM(mat.P1) + SUM(mat.P2) + SUM(mat.P3))) 
		/ 
	   ((COUNT(bd.P1) + COUNT(bd.P2) + COUNT(bd.P3)) + (COUNT(cbd.P1) + COUNT(cbd.P2) + COUNT(cbd.P3)) + (COUNT(mat.P1) + COUNT(mat.P2) + COUNT(mat.P3)))
	   AS media, bd.school FROM ([dbo].['2017 BD$'] bd 
	   INNER JOIN [dbo].['2017 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number]
	   INNER JOIN [dbo].['2017 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

SELECT ((SUM(bd.P1) + SUM(bd.P2) + SUM(bd.P3)) + (SUM(cbd.P1) + SUM(cbd.P2) + SUM(cbd.P3)) + (SUM(mat.P1) + SUM(mat.P2) + SUM(mat.P3))) 
		/ 
	   ((COUNT(bd.P1) + COUNT(bd.P2) + COUNT(bd.P3)) + (COUNT(cbd.P1) + COUNT(cbd.P2) + COUNT(cbd.P3)) + (COUNT(mat.P1) + COUNT(mat.P2) + COUNT(mat.P3)))
	   AS media, bd.school FROM ([dbo].['2018 BD$'] bd 
	   INNER JOIN [dbo].['2018 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number] 
	   INNER JOIN [dbo].['2018 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

SELECT ((SUM(bd.P1) + SUM(bd.P2) + SUM(bd.P3)) + (SUM(cbd.P1) + SUM(cbd.P2) + SUM(cbd.P3)) + (SUM(mat.P1) + SUM(mat.P2) + SUM(mat.P3))) 
		/ 
	   ((COUNT(bd.P1) + COUNT(bd.P2) + COUNT(bd.P3)) + (COUNT(cbd.P1) + COUNT(cbd.P2) + COUNT(cbd.P3)) + (COUNT(mat.P1) + COUNT(mat.P2) + COUNT(mat.P3)))
	   AS media, bd.school FROM ([dbo].['2019 BD$'] bd 
	   INNER JOIN [dbo].['2019 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number] 
	   INNER JOIN [dbo].['2019 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

--Média de notas por ano letivo e período letivo por escola;
SELECT ((SUM(bd.P1) + SUM(cbd.P1) + SUM(mat.P1))/(COUNT(bd.P1) + COUNT(cbd.P1) + COUNT(mat.P1))) AS 'P1',
	   ((SUM(bd.P2) + SUM(cbd.P2) + SUM(mat.P2))/(COUNT(bd.P2) + COUNT(cbd.P2) + COUNT(mat.P2))) AS 'P2',
	   ((SUM(bd.P3) + SUM(cbd.P3) + SUM(mat.P3))/(COUNT(bd.P3) + COUNT(cbd.P3) + COUNT(mat.P3))) AS 'P3',
	   bd.school FROM ([dbo].['2017 BD$'] bd 
	   INNER JOIN [dbo].['2017 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number] 
	   INNER JOIN [dbo].['2017 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

SELECT ((SUM(bd.P1) + SUM(cbd.P1) + SUM(mat.P1))/(COUNT(bd.P1) + COUNT(cbd.P1) + COUNT(mat.P1))) AS 'P1',
	   ((SUM(bd.P2) + SUM(cbd.P2) + SUM(mat.P2))/(COUNT(bd.P2) + COUNT(cbd.P2) + COUNT(mat.P2))) AS 'P2',
	   ((SUM(bd.P3) + SUM(cbd.P3) + SUM(mat.P3))/(COUNT(bd.P3) + COUNT(cbd.P3) + COUNT(mat.P3))) AS 'P3',
	   bd.school FROM ([dbo].['2018 BD$'] bd 
	   INNER JOIN [dbo].['2018 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number] 
	   INNER JOIN [dbo].['2018 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

SELECT ((SUM(bd.P1) + SUM(cbd.P1) + SUM(mat.P1))/(COUNT(bd.P1) + COUNT(cbd.P1) + COUNT(mat.P1))) AS 'P1',
	   (( SUM(bd.P2) + SUM(cbd.P2) + SUM(mat.P2))/(COUNT(bd.P2) + COUNT(cbd.P2) + COUNT(mat.P2))) AS 'P2',
	   (( SUM(bd.P3) + SUM(cbd.P3) + SUM(mat.P3))/(COUNT(bd.P3) + COUNT(cbd.P3) + COUNT(mat.P3))) AS 'P3',
	   bd.school FROM ([dbo].['2019 BD$'] bd 
	   INNER JOIN [dbo].['2019 CBD$'] cbd ON bd.[Student Number] = cbd.[Student Number] 
	   INNER JOIN [dbo].['2019 MAT$'] mat ON bd.[Student Number] = mat.[Student Number]) GROUP BY bd.school;

--Total de alunos por escola/ano letivo;
SELECT COUNT ([Student Number]) as alunos, [school],[year]
FROM [dbo].['2017 BD$']
GROUP BY [school], [year];

SELECT COUNT ([Student Number]) as alunos, [school],[year]
FROM [dbo].['2018 BD$']
GROUP BY [school], [year];

SELECT COUNT ([Student Number]) as alunos, [school],[year]
FROM [dbo].['2019 BD$']
GROUP BY [school], [year];


--=====================================================================================================
-- QUERIES ADICIONAIS
--=====================================================================================================

--Query para obter a dimensão retirada de: https://sqlworldwide.com/list-objects-per-filegroup-with-size/;
USE AgrupamentoSTB;

SELECT
	FileGroup = FILEGROUP_NAME(a.data_space_id) ,
		TableName = OBJECT_NAME(p.object_id) ,
		IndexName = i.name ,
		8 * SUM(a.used_pages) AS 'Size(KB)' ,
		8 * SUM(a.used_pages) / 1024 AS 'Size(MB)' ,
		8 * SUM(a.used_pages) / 1024 / 1024 AS 'Size(GB)'
	FROM
		sys.allocation_units a
	INNER JOIN sys.partitions p
	ON  a.container_id = CASE WHEN a.type IN ( 1 , 3 ) THEN p.hobt_id
		ELSE p.partition_id END
	AND p.object_id > 1024
		LEFT JOIN sys.indexes i
	ON  i.object_id = p.object_id
		AND i.index_id = p.index_id
	GROUP BY
		a.data_space_id ,
		p.object_id ,
		i.object_id ,
		i.index_id ,
		i.name
	ORDER BY
		FILEGROUP_NAME(a.data_space_id) ,
		SUM(a.used_pages) DESC;

--Query para obter o número de registos em todas as tabelas retirada de: https://stackoverflow.com/questions/2221555/how-to-fetch-the-row-count-for-all-tables-in-a-sql-server-database;
USE AgrupamentoSTB;

CREATE TABLE #counts
(
    table_name varchar(255),
    row_count int
)

EXEC sp_MSForEachTable @command1='INSERT #counts (table_name, row_count) SELECT ''?'', COUNT(*) FROM ?'
SELECT table_name, row_count FROM #counts ORDER BY table_name, row_count DESC
DROP TABLE #counts

--=====================================================================================================

