--**STORED PROCEDURE PARA OS ERROS
USE Agrupamento_STB
DROP PROCEDURE IF EXISTS [School].[spLogErrors]


--STORED PROCEDURE PARA CRIAR LOGS DE ERROS QUE IRAO PARA A TABELA CRIADA COM O NOME LOGERRORS COM DIFERENTES INFORMAÇÕES SOBRE ESTE ERRO
GO
CREATE OR ALTER PROCEDURE [School].[spLogErrors]
AS
BEGIN
INSERT INTO [Logs].[LogErrors](  
log_errors_line, 
log_errors_Message, 
log_errors_Number,  
log_errors_Procedure, 
log_errors_Severity, 
log_errors_State,  
log_errors_Date
)  
SELECT  
ERROR_LINE () as log_errors_line,  
ERROR_MESSAGE() as log_errors_Message,  
ERROR_NUMBER() as log_errors_Number,  
ERROR_PROCEDURE() as log_errors_Procedure,  
ERROR_SEVERITY() as log_errors_Severity,  
Error_State() as log_errors_State,  
GETDATE () as log_errors_Date

PRINT ERROR_MESSAGE()
END  

SELECT * FROM Logs.[LogErrors]


--**STORED PROCEDURE PARA ABRIR ANO LETIVO
--RECEBE UM VALOR QUE SERA O ANO A ABRIR E ESTE SERA USADO PARA CRIAR A TABELA INSCRIÇÕES(INSCRIPTIONS) E NOTAS(GRADES) COM ESTE MESMO ANO NO NOME
USE Agrupamento_STB

DROP PROCEDURE IF EXISTS [School].spNewAcademicYear

CREATE OR ALTER PROCEDURE [School].spNewAcademicYear
    @NewYearToOpen VARCHAR(5)
AS
BEGIN
BEGIN TRY
   
EXEC ('CREATE TABLE [School].Inscriptions' + @NewYearToOpen + '(
[inscrip_id] INT PRIMARY KEY IDENTITY(1, 1),
[inscrip_student_id] INT NOT NULL,
[inscrip_subject_id] INT NOT NULL,
[inscrip_academicY_id] INT NOT NULL,
CONSTRAINT fk_Inscriptions_inscrip_student_id FOREIGN KEY (inscrip_student_id) REFERENCES Persons.[Student](student_Id),
CONSTRAINT fk_Inscriptions_inscrip_subject_id FOREIGN KEY (inscrip_subject_id) REFERENCES School.[Subjects](subject_Id),
CONSTRAINT fk_Inscriptions_inscrip_academicY_id FOREIGN KEY (inscrip_academicY_id) REFERENCES School.[AcademicYear](academicY_Id),
)ON [School_STB];')


EXEC('CREATE TABLE [School].Grades' + @NewYearToOpen + '(  
[grade_id] INT PRIMARY KEY IDENTITY(1, 1),
[grade_student_id] INT NOT NULL,
[grade_subject_id] INT NOT NULL,
[grade_academicY_id] INT NOT NULL,
[grade_value] FLOAT NOT NULL CHECK([grade_value] >= 0 AND [grade_value] <= 20),
[grade_period] INT NOT NULL,
CONSTRAINT fk_Grades_grade_student_id FOREIGN KEY (grade_student_id) REFERENCES Persons.[Student](student_id),
CONSTRAINT fk_Grades_grade_subject_id FOREIGN KEY (grade_subject_id) REFERENCES School.[Subjects](subject_id),
CONSTRAINT fk_Grades_grade_academicY_id FOREIGN KEY (grade_academicY_id) REFERENCES School.[AcademicYear](academicY_id),
)ON [School_STB];')

EXEC('UPDATE School.AcademicYear SET academicY_closed = 0;')

EXEC('INSERT INTO School.AcademicYear(academicY_year, academicY_closed) VALUES ('+ @NewYearToOpen+ ',1);')

END TRY
BEGIN CATCH  
EXEC [School].[spLogErrors]
END CATCH
END

--TESTE
EXEC [School].spNewAcademicYear @NewYearToOpen = 2021

SELECT * FROM School.AcademicYear


--**STORED PROCEDURE PARA INSCREVER ALUNOS NA DISCIPLINA
--CRIAMOS 2 VARIAVEIS QUE RECEBEM O NUMERO DO ESTUDANTE E O ID DA DISCIPLINA EM QUE É PRETENDIDO INSCREVER
--DEPOIS ATRAVES DE OUTRA VARIAVEL DECLARADA COM O ANO ABERTO IREMOS ASSIM INSERIR NESTA TABELA O ALUNO COM O ID DA DISCIPLINA QUE SE COLOCOU
CREATE OR ALTER PROCEDURE School.RegistStudent
@studentNumber INT,
@subjectId VARCHAR(255)

AS
BEGIN
BEGIN TRY
	DECLARE @academicYear INT;
		SET @academicYear = (SELECT academicY_year FROM School.AcademicYear WHERE academicY_closed = 1);
	DECLARE @academicYear_id INT;
		SET @academicYear_id = (SELECT academicY_id FROM School.AcademicYear WHERE academicY_closed = 1);
	EXEC ('INSERT INTO School.Inscriptions' + @academicYear + '(inscrip_student_id, inscrip_subject_id, inscrip_academicY_id) values (' + @studentNumber + ',' + @subjectId + ',' + @academicYear_id +')')
END TRY
BEGIN CATCH
EXEC [School].[spLogErrors]
END CATCH
END

EXEC School.RegistStudent @studentNumber = 2, @subjectId = 1
SELECT * FROM School.Inscriptions2021


--**STORED PROCEDURE PARA FECHAR ANO LETIVO
--DECLARAMOS UMA VARIAVEL QUE IRÁ RECEBER O ANO QUE SE ENCONTRA ABERTO
--VAMOS PASSAR TODOS OS VALORES DAS TABELAS DESSE ANO PARA A DAS NOTAS E INSCRIÇOES FECHADAS E DAR DROP DESSAS PARA ASSIM O ANO FICAR SEM TABELA
--NAO EXECUTAR PROCEDURE DEPOIS DE CRIA-LA, SO EXECUTAR DEPOIS DE CRIAR TODAS AS OUTRAS PROCEDURE
DROP PROCEDURE IF EXISTS [School].spCloseAcademicYear

CREATE OR ALTER PROCEDURE [School].spCloseAcademicYear
AS
BEGIN
BEGIN TRY
		DECLARE @YearToClose INT;
		SET @YearToClose = (SELECT academicY_year FROM AcademicYear WHERE academicY_closed = 1)

		EXEC('INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_id)
		SELECT inscrip_student_id, inscrip_subject_id, inscrip_academicY_id FROM School.Inscriptions'+ @YearToClose);
		EXEC('DROP TABLE IF EXISTS School.Inscriptions'+ @YearToClose)

		EXEC('INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
		SELECT grade_student_id, grade_subject_id, grade_academicY_id, grade_value, grade_period FROM School.Grades'+ @YearToClose);
		EXEC('DROP TABLE IF EXISTS School.Grades'+ @YearToClose)

		EXEC('UPDATE School.AcademicYear 
		SET academicY_closed = 0
		WHERE academicY_year ='+@YearToClose)


END TRY
BEGIN CATCH
EXEC [School].[spLogErrors]
END CATCH
END

EXEC School.spCloseAcademicYear

SELECT *FROM School.AcademicYear



--**STORED PROCEDURE PARA ATUALIZAR NOTA DO ALUNO NUMA DETERMINADA DISCIPLINA
--INSERIMOS O ID DO ESTUDANTE, ID DA DISCIPLINA, ID DO ANO LETIVO, O VALOR DA NOTA E O PERIODO EM QUE PERTENDEMOS ATUALIZAR A NOTA
USE Agrupamento_STB
DROP PROCEDURE IF EXISTS [School].[spUpdateGradeValue]

GO
CREATE PROCEDURE [School].[spUpdateGradeValue] 
@idStudent INT,
@idSubject INT,
@idAcaY INT,
@value FLOAT,
@Period INT
AS  
BEGIN    
BEGIN TRY  
UPDATE School.[ClosedGrades]
SET closed_grade_value = @value
WHERE closed_grade_subject_id = @idSubject 
AND closed_grade_student_id = @idStudent 
AND closed_grade_period = @Period 
AND closed_grade_academicY_id = @idAcaY;
END TRY  
BEGIN CATCH  
EXEC [School].[spLogErrors]
END CATCH  
END

--TESTE
SELECT DISTINCT closed_grade_value FROM [Persons].Student, [School].AcademicYear , [School].ClosedGrades, [School].Subjects 
WHERE closed_grade_student_id = 1 AND closed_grade_subject_id = 1 AND closed_grade_period = 1 AND closed_grade_academicY_id = 1


EXEC [School].[spUpdateGradeValue] 
@idStudent = 1,
@idSubject = 1,
@idAcaY = 1,
@value = 12,
@Period = 1;

SELECT * FROM School.ClosedGrades

--**STORED PROCEDURE Média de notas de todos os alunos por escola num determinado ano
--RECEBEMOS UM VALOR ATRAVES DA VARIAVEL E UTILIZAMOS ESTA PARA MOSTRAR SO A MEDIA DAS NOTAS NO ANO LETIVO PRETENDIDO
USE Agrupamento_STB;

DROP PROCEDURE IF EXISTS [School].[spAverageGrades]

CREATE OR ALTER PROCEDURE School.spAverageGrades
@academicYear INT
AS
BEGIN 
BEGIN TRY

	SELECT AVG(clo.closed_grade_value) AS AVERAGE, stu.student_school AS School, aY.academicY_year AS Year 
		FROM ((School.ClosedGrades clo 
			INNER JOIN Persons.Student stu ON clo.closed_grade_student_id = stu.student_id)
			INNER JOIN School.AcademicYear aY ON clo.closed_grade_academicY_id = aY.academicY_id) 			
			WHERE @academicYear = academicY_year
		GROUP BY aY.academicY_year, stu.student_school
END TRY
BEGIN CATCH  
EXEC [School].[spLogErrors]
END CATCH
END

EXEC School.spAverageGrades
@academicYear = 2017


--**STORED PROCEDURE PARA TOTAL DE ALUNOS INSCRITOS EM CADA DISCIPLINA NO ANO ABERTO FACE AO ANO ANTERIOR
--

USE Agrupamento_STB
DROP PROCEDURE IF EXISTS [School].[spTotalStudents]

CREATE OR ALTER PROCEDURE School.spTotalStudents
AS
BEGIN 
BEGIN TRY

	DECLARE @academicYear INT = (SELECT academicY_year FROM School.AcademicYear WHERE academicY_closed = 1);
	DECLARE @lastYear INT = @academicYear - 1
	DECLARE @subjects INT = (SELECT COUNT(*) FROM School.Subjects)
	DECLARE @cnt INT = 1

EXEC('SELECT COUNT(DISTINCT stu.student_id) AS Students, sub.subject_name, aY.academicY_year
	FROM (((Persons.Student stu 
			INNER JOIN School.Inscriptions'+@academicYear+' cloI ON stu.student_id = cloI.inscrip_student_id)
			INNER JOIN School.Subjects sub ON cloI.inscrip_subject_id = sub.subject_id)
			INNER JOIN School.AcademicYear aY ON cloI.inscrip_academicY_Id = aY.academicY_id)
			WHERE academicY_year = '+@academicYear+ 'GROUP BY aY.academicY_year, sub.subject_name'
			);
EXEC ('SELECT COUNT(DISTINCT stu.student_id) AS StudentsLast , sub.subject_name
	FROM (((Persons.Student stu 
			JOIN School.Inscriptions cloI ON stu.student_id = cloI.inscrip_student_id)
			INNER JOIN School.AcademicYear aY ON cloI.inscrip_academicY_Id = aY.academicY_id)
			INNER JOIN School.Subjects sub ON cloI.inscrip_subject_id = sub.subject_id) WHERE aY.academicY_year = ' + @academicYear +' - 1 GROUP BY aY.academicY_year, sub.subject_name'
			);
			WHILE @cnt <= @subjects
			BEGIN
				EXEC ('SELECT ((SELECT COUNT(DISTINCT stu.student_id) AS student
					   FROM (((Persons.Student stu
					   INNER JOIN School.Inscriptions' + @academicYear +' cloI ON stu.student_id = cloI.inscrip_student_id' + @academicYear +'stu.student_id)
					   INNER JOIN School.AcademicYear aY ON cloI.inscrip' + @academicYear +'_academicY_Id = aY.academicY_id)
					   INNER JOIN School.Subjects sub ON cloI.inscrip' + @academicYear +'_subject_id = sub.subject_id) WHERE sub.subject_id = ' + @cnt + ' GROUP BY aY.academicY_year, sub.subject_name)
						-
						(SELECT COUNT(DISTINCT stu.student_id) AS student
						FROM (((Persons.Student stu
						INNER JOIN School.ClosedInscriptions I ON stu.student_id = cloI.inscrip_student_id)
						INNER JOIN School.AcademicYear aY ON cloI.inscrip_academicY_Id = aY.academicY_id)
						INNER JOIN School.Subjects sub ON cloI.inscrip_subject_id = sub.subject_id) WHERE aY.academicY_id = ' + @academicYear +' - 1 AND sub.subject_id = ' + @cnt + ' GROUP BY aY.academicY_year, sub.subject_name)) as taxa, sub.subject_name
						FROM School.Subjects sub Where sub.subject_id = ' + @cnt)
			SET @cnt = @cnt + 1;
			END
END TRY
BEGIN CATCH  
EXEC [School].[spLogErrors]
END CATCH  
END
--TESTE
EXEC School.spTotalStudents





--Stored procedure para calcular o total de alunos de alunos inscritos em cada uma das disciplinas no ano aberto face ao ano anterior e a respetiva taxa de crescimento.
DROP PROCEDURE IF EXISTS School.sp_TotalAlunosAberto;

CREATE OR ALTER PROCEDURE School.sp_TotalAlunosAberto
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

CREATE OR ALTER PROCEDURE School.sp_MediaDeNotas
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
