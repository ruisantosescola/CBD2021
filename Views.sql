USE Agrupamento_STB
--VIEW QUE PERMITE VER O TOTAL DE ALUNOS EM CADA ESCOLA POR ANO LETIVO NA NOVA BD "PROJETOATUALZIADO"
CREATE VIEW School.vTotalAlunosEscolaAnoLetivo AS
SELECT COUNT(DISTINCT stu.student_id) AS Students, stu.student_school, aY.academicY_year
    FROM (((Persons.Student stu 
        INNER JOIN School.ClosedInscriptions cloI ON stu.student_id = cloI.closedInscrip_student_id)
            INNER JOIN School.AcademicYear aY ON cloI.closedInscrip_academicY_Id = aY.academicY_id)
                INNER JOIN School.Subjects sub on cloI.closedInscrip_subject_id = sub.subject_id) 
	GROUP BY aY.academicY_year, stu.student_school

--TESTE
SELECT * FROM School.vTotalAlunosEscolaAnoLetivo

--VIEW QUE PERMITE VER O TOTAL DE ALUNOS EM CADA ESCOLA POR ANO LETIVO NA ANTIGA BD "oldData"
--EX:2017 MAT1
USE oldData

CREATE VIEW vTotalAlunosEscolaAnoLetivooldData AS

		SELECT COUNT ([Student Number]) AS alunos,[school],[year]
			FROM [dbo].['2017_Student_MAT1$']
		GROUP BY [school], [year]

--TESTE
	
SELECT * FROM vTotalAlunosEscolaAnoLetivooldData


--********************************************************************--


--VIEW QUE PERMITE VISUALIZAR A MEDIA DE TODOS OS ALUNOS POR ESCOLA E POR ANO LETIVO NA NOVA BD "PROJETOATUALZIADO"
USE Agrupamento_STB

CREATE VIEW School.vMediaNotasAnoLetivoPorEscola AS
SELECT AVG(clo.closed_grade_value) AS AVERAGE, stu.student_school AS School, aY.academicY_year AS Year 
    FROM ((School.ClosedGrades clo 
	INNER JOIN School.AcademicYear aY ON clo.closed_grade_academicY_id = aY.academicY_id) 
        INNER JOIN Persons.Student stu ON clo.closed_grade_student_id = stu.student_id) GROUP BY aY.academicY_year, stu.student_school

--TESTE
SELECT * FROM School.vMediaNotasAnoLetivoPorEscola


--VIEW QUE PERMITE VISUALIZAR A MEDIA DE TODOS OS ALUNOS POR ESCOLA E POR ANO LETIVO NA ANTIGA BD "oldData"
--EX: ANO 2017
USE oldData

CREATE VIEW vMediaNotasAnoLetivoPorEscolaoldData AS
SELECT ((SUM(BD.P1) + SUM(BD.P2) + SUM(BD.P3)) + (SUM(CBD.P1) + SUM(CBD.P2) + SUM(CBD.P3)) + (SUM(MAT1.P1) + SUM(MAT1.P2) + SUM(MAT1.P3))) / 
       ((COUNT(BD.P1) + COUNT(BD.P2) + COUNT(BD.P3)) + (COUNT(CBD.P1) + COUNT(CBD.P2) + COUNT(CBD.P3)) + (COUNT(MAT1.P1) + COUNT(MAT1.P2) + COUNT(MAT1.P3)))as AVERAGE, BD.school 
FROM ([dbo].['2017_Student_BD$'] BD 
	INNER JOIN [dbo].['2017_Student_MAT1$'] MAT1 ON BD.[Student Number] = MAT1.[Student Number]) 
    INNER JOIN [dbo].['2017_Student_CBD$'] CBD ON BD.[Student Number] = CBD.[Student Number] 
GROUP BY BD.school;

--TESTE
SELECT * FROM vMediaNotasAnoLetivoPorEscolaoldData




--********************************************************************--


--VIEW QUE PERMITE VISUALIZAR A MEDIA DE NOTAS POR ANO LETIVO E PERIODO LETIVO POR ESCOLA NA NOVA BD "Agrupamento_STB"
USE Agrupamento_STB

CREATE VIEW School.vMediaNotasAnoPeriodoEscolaLetivo AS
SELECT AVG(CASE WHEN clo.closed_grade_period = 1 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 1', 
       AVG(CASE WHEN clo.closed_grade_period = 2 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 2',
       AVG(CASE WHEN clo.closed_grade_period = 3 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 3', 
       stu.student_school, acaY.academicY_year
	FROM (School.ClosedGrades clo 
			INNER JOIN Persons.Student stu ON clo.closed_grade_student_id = stu.student_id) 
			 INNER JOIN School.AcademicYear acaY ON clo.closed_grade_academicY_id = acaY.academicY_id   
	GROUP BY acaY.academicY_year, stu.student_school


--TESTE
SELECT * FROM School.vMediaNotasAnoPeriodoEscolaLetivo


--VIEW QUE PERMITE VISUALIZAR A MEDIA DE NOTAS POR ANO LETIVO E PERIODO LETIVO POR ESCOLA NA ANTIGA BD "OLDADATA"
--EX:2017
USE oldData

CREATE VIEW vMediaNotasAnoPeriodoEscolaLetivooldData AS
SELECT ((SUM(BD.P1) + SUM(CBD.P1) + SUM(MAT1.P1))/(COUNT(BD.P1) + COUNT(CBD.P1) + COUNT(MAT1.P1))) AS 'Period 1',
       ((SUM(BD.P2) + SUM(CBD.P2) + SUM(MAT1.P2))/(COUNT(BD.P2) + COUNT(CBD.P2) + COUNT(MAT1.P2))) AS 'Period 2',
       ((SUM(BD.P3) + SUM(CBD.P3) + SUM(MAT1.P3))/(COUNT(BD.P3) + COUNT(CBD.P3) + COUNT(MAT1.P3))) AS 'Period 3',BD.school 
FROM 
		([dbo].['2017_Student_BD$'] BD 
		INNER JOIN [dbo].['2017_Student_MAT1$'] MAT1 ON bd.[Student Number] = MAT1.[Student Number] 
		INNER JOIN [dbo].['2017_Student_CBD$'] CBD ON bd.[Student Number] = CBD.[Student Number])	
GROUP BY BD.school;

--TESTE
SELECT * FROM vMediaNotasAnoPeriodoEscolaLetivooldData
