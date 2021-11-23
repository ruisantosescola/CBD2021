--QUERIES 
--Média de notas no ano letivo por escola NOVA BD
--FAZEMOS O AVG DA NOTA NO CLOSED GRADE E INNER JOINS PARA FAZER A LIGAÇÃO AS RESPETIVAS TABELAS PARA PODER SER AGRUPADO POR ESCOLA
USE Agrupamento_STB

SELECT AVG(clo.closed_grade_value) AS AVERAGE, stu.student_school AS School, aY.academicY_year AS Year 
	FROM ((School.ClosedGrades clo 
		INNER JOIN Persons.Student stu ON clo.closed_grade_student_id = stu.student_id) 
		INNER JOIN School.AcademicYear aY ON clo.closed_grade_academicY_id = aY.academicY_id) 
	GROUP BY aY.academicY_year, stu.student_school

-- Média de notas no ano letivo por escola OLD DATA
-- FAZEMOS O SUMATÓRIO DE CADA PERIODO PARA CADA DISCIPLINA E CONTAMOS O NUMERO DE NOTAS PARA FAZER A DIVISAO DESTAS
-- FAZER ISTO PARA CADA UM DOS DIFERENTES ANOS TENDO ASSIM NO FIM PARA TODOS

--MEDIA DE NOTAS NO ANO LETIVO POR ESCOLA 2017
USE oldData

SELECT ((SUM(BD.P1) + SUM(BD.P2) + SUM(BD.P3)) + (SUM(CBD.P1) + SUM(CBD.P2) + SUM(CBD.P3)) + (SUM(MAT1.P1) + SUM(MAT1.P2) + SUM(MAT1.P3))) / 
       ((COUNT(BD.P1) + COUNT(BD.P2) + COUNT(BD.P3)) + (COUNT(CBD.P1) + COUNT(CBD.P2) + COUNT(CBD.P3)) + (COUNT(MAT1.P1) + COUNT(MAT1.P2) + COUNT(MAT1.P3)))as AVERAGE, BD.school 
FROM ([dbo].['2017_Student_BD$'] BD 
	INNER JOIN [dbo].['2017_Student_MAT1$'] MAT1 ON BD.[Student Number] = MAT1.[Student Number]) 
    INNER JOIN [dbo].['2017_Student_CBD$'] CBD ON BD.[Student Number] = CBD.[Student Number] 
GROUP BY BD.school;

--MEDIA DE NOTAS NO ANO LETIVO POR ESCOLA 2018
USE oldData

SELECT ((SUM(BD.P1) + SUM(BD.P2) + SUM(BD.P3)) + (SUM(CBD.P1) + SUM(CBD.P2) + SUM(CBD.P3)) + (SUM(MAT1.P1) + SUM(MAT1.P2) + SUM(MAT1.P3))) / 
       ((COUNT(BD.P1) + COUNT(BD.P2) + COUNT(BD.P3)) + (COUNT(CBD.P1) + COUNT(CBD.P2) + COUNT(CBD.P3)) + (COUNT(MAT1.P1) + COUNT(MAT1.P2) + COUNT(MAT1.P3)))as AVERAGE, BD.school 
FROM ([dbo].['2018_Student_BD$'] BD 
	INNER JOIN [dbo].['2018_Student_MAT1$'] MAT1 ON BD.[Student Number] = MAT1.[Student Number]) 
    INNER JOIN [dbo].['2018_Student_CBD$'] CBD ON BD.[Student Number] = CBD.[Student Number] 
GROUP BY BD.school;

--MEDIA DE NOTAS NO ANO LETIVO POR ESCOLA 2019
USE oldData

SELECT ((SUM(BD.P1) + SUM(BD.P2) + SUM(BD.P3)) + (SUM(CBD.P1) + SUM(CBD.P2) + SUM(CBD.P3)) + (SUM(MAT1.P1) + SUM(MAT1.P2) + SUM(MAT1.P3))) / 
       ((COUNT(BD.P1) + COUNT(BD.P2) + COUNT(BD.P3)) + (COUNT(CBD.P1) + COUNT(CBD.P2) + COUNT(CBD.P3)) + (COUNT(MAT1.P1) + COUNT(MAT1.P2) + COUNT(MAT1.P3)))as AVERAGE, BD.school 
FROM ([dbo].['2019_Student_BD$'] BD 
	   INNER JOIN [dbo].['2019_Student_MAT1$'] MAT1 ON BD.[Student Number] = MAT1.[Student Number])
	   INNER JOIN [dbo].['2019_Student_CBD$'] CBD ON BD.[Student Number] = CBD.[Student Number] 
GROUP BY BD.school;

--********************************************************************************************************************************************


-- MEDIA DE NOTAS POR ANO LETIVO E PERIODO LETIVO POR ESCOLA - NOVA BD
USE Agrupamento_STB

SELECT AVG(CASE WHEN clo.closed_grade_period = 1 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 1', 
       AVG(CASE WHEN clo.closed_grade_period = 2 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 2',
       AVG(CASE WHEN clo.closed_grade_period = 3 THEN clo.closed_grade_value ELSE NULL END) AS 'Period 3', 
       stu.student_school, acaY.academicY_year
FROM (School.ClosedGrades clo 
			INNER JOIN Persons.Student stu ON clo.closed_grade_student_id = stu.student_id) 
            INNER JOIN School.AcademicYear acaY ON clo.closed_grade_academicY_id = acaY.academicY_id   
GROUP BY acaY.academicY_year, stu.student_school

-- MEDIA DE NOTAS POR ANO LETIVO E PERIODO LETIVO POR ESCOLA - oldData
-- FAZEMOS O SUMATORIO DE CADA DISCIPLINA POR PERIODO E DIVIDIMOS PELO NUMERO DE NOTAS NESSE MESMO PERIODO
-- DEPOIS FAZEMOS PARA CADA UM DOS ANOS TENDO ASSIM AS MEDIAS DE NOTA POR ANO LETIVO E PERIODO

-- MEDIA DE NOTAS PARA 2017
USE oldData

SELECT ((SUM(BD.P1) + SUM(CBD.P1) + SUM(MAT1.P1))/(COUNT(BD.P1) + COUNT(CBD.P1) + COUNT(MAT1.P1))) AS 'Period 1',
       ((SUM(BD.P2) + SUM(CBD.P2) + SUM(MAT1.P2))/(COUNT(BD.P2) + COUNT(CBD.P2) + COUNT(MAT1.P2))) AS 'Period 2',
       ((SUM(BD.P3) + SUM(CBD.P3) + SUM(MAT1.P3))/(COUNT(BD.P3) + COUNT(CBD.P3) + COUNT(MAT1.P3))) AS 'Period 3',BD.school 
FROM 
		([dbo].['2017_Student_BD$'] BD 
		INNER JOIN [dbo].['2017_Student_MAT1$'] MAT1 ON bd.[Student Number] = MAT1.[Student Number] 
		INNER JOIN [dbo].['2017_Student_CBD$'] CBD ON bd.[Student Number] = CBD.[Student Number])
GROUP BY BD.school;

-- MEDIA DE NOTAS PARA 2018
USE oldData

SELECT ((SUM(BD.P1) + SUM(CBD.P1) + SUM(MAT1.P1))/(COUNT(BD.P1) + COUNT(CBD.P1) + COUNT(MAT1.P1))) AS 'Period 1',
       (( SUM(BD.P2) + SUM(CBD.P2) + SUM(MAT1.P2))/(COUNT(BD.P2) + COUNT(CBD.P2) + COUNT(MAT1.P2))) AS 'Period 2',
       (( SUM(BD.P3) + SUM(CBD.P3) + SUM(MAT1.P3))/(COUNT(BD.P3) + COUNT(CBD.P3) + COUNT(MAT1.P3)))AS 'Period 3', BD.school 
FROM 
		([dbo].['2018_Student_BD$'] BD 
		INNER JOIN [dbo].['2018_Student_MAT1$'] MAT1 ON bd.[Student Number] = MAT1.[Student Number]
		INNER JOIN [dbo].['2018_Student_CBD$'] CBD ON bd.[Student Number] = CBD.[Student Number] )
GROUP BY BD.school;

-- MEDIA DE NOTAS PARA 2019
USE oldData

SELECT ((SUM(BD.P1) + SUM(CBD.P1) + SUM(MAT1.P1))/(COUNT(BD.P1) + COUNT(CBD.P1) + COUNT(MAT1.P1))) AS 'Period 1',
       ((SUM(BD.P2) + SUM(CBD.P2) + SUM(MAT1.P2))/(COUNT(BD.P2) + COUNT(CBD.P2) + COUNT(MAT1.P2))) AS 'Period 2',
       ((SUM(BD.P3) + SUM(CBD.P3) + SUM(MAT1.P3))/(COUNT(BD.P3) + COUNT(CBD.P3) + COUNT(MAT1.P3)))AS 'Period 3', BD.school 
FROM 
	   ([dbo].['2019_Student_BD$'] BD 
	   INNER JOIN [dbo].['2019_Student_MAT1$'] MAT1 ON bd.[Student Number] = MAT1.[Student Number]
	   INNER JOIN [dbo].['2019_Student_CBD$'] CBD ON bd.[Student Number] = CBD.[Student Number]) 
GROUP BY BD.school;



--TOTAL DE ALUNOS POR ESCOLA E ANO LETIVO - NOVA BD
--FIZEMOS UM COUNT PARA SABER O NUMERO DE ALUNOS QUE EXISTEM, COM UM DISTINCT PARA NAO REPETIR VALORES, E AGRUPAMOS POR ANO LETIVO E ESCOLA
USE Agrupamento_STB

SELECT COUNT(DISTINCT stu.student_id) AS Students, stu.student_school, aY.academicY_year
	FROM (((Persons.Student stu 
			INNER JOIN School.ClosedInscriptions cloI ON stu.student_id = cloI.closedInscrip_student_id)
			INNER JOIN School.Subjects sub ON cloI.closedInscrip_subject_id = sub.subject_id)
			INNER JOIN School.AcademicYear aY ON cloI.closedInscrip_academicY_Id = aY.academicY_id)
	GROUP BY aY.academicY_year, stu.student_school


--TOTAL DE ALUNOS POR ESCOLA E ANO LETIVO - oldData
--FAZEMOS UM COUNT DO STUDENT NUMBER PARA CADA ANO LETIVO 
USE oldData

SELECT COUNT ([Student Number]) AS alunos,[school],[year]
FROM [dbo].['2017_Student_MAT1$']
GROUP BY [school], [year]

SELECT COUNT ([Student Number]) AS alunos,[school],[year]
FROM [dbo].['2018_Student_MAT1$']
GROUP BY [school], [year]

SELECT COUNT ([Student Number]) AS alunos,[school],[year]
FROM [dbo].['2019_Student_MAT1$']
GROUP BY [school], [year]





--=====================================================================================================
-- QUERIES ADICIONAIS
--=====================================================================================================

--Query para obter a dimensão retirada de: https://sqlworldwide.com/list-objects-per-filegroup-with-size/;
USE Agrupamento_STB

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
USE Agrupamento_STB

CREATE TABLE #counts
(
    table_name varchar(255),
    row_count int
)

EXEC sp_MSForEachTable @command1='INSERT #counts (table_name, row_count) SELECT ''?'', COUNT(*) FROM ?'
SELECT table_name, row_count FROM #counts ORDER BY table_name, row_count DESC
DROP TABLE #counts

--=====================================================================================================

