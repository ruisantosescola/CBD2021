USE Agrupamento_STB
--*************************************************
--INSERTS PARA TABELA PERSON DA OLDDATA
--ALUNOS DE 2017
INSERT INTO Persons.Person(person_name, person_address,person_opt_address, person_sex, person_birthDate, person_email)
SELECT 'NomeTest', [address], 'moradaTeste', [sex], [Birth Date],'email123@gmail.com'
FROM OldData.[dbo].['2017_Student_BD$']

--ALUNOS DE 2018
INSERT INTO Persons.Person(person_name, person_address,person_opt_address, person_sex, person_birthDate, person_email)
SELECT 'NomeTest', [address], 'moradaTeste', [sex], [Birth Date],'email123@gmail.com'
FROM OldData.[dbo].['2018_Student_BD$']

--ALUNOS DE 2019
INSERT INTO Persons.Person(person_name, person_address,person_opt_address, person_sex, person_birthDate, person_email)
SELECT 'NomeTest', [address], 'moradaTeste', [sex], [Birth Date],'email123@gmail.com'
FROM OldData.[dbo].['2019_Student_BD$']
--SELECT PERSON
SELECT * FROM Persons.Person

--*************************************************
--INSERTS PARA TABELA JOBS
INSERT INTO Persons.Jobs(job_type)
VALUES('at_home'), ('teacher'), ('health'), ('services'), ('other')
--SELECT TRAVEL TIME
SELECT * FROM Persons.Jobs

--*************************************************
--INSERTS PARA TABELA REASON
INSERT INTO Persons.Reason(reason_text)
VALUES('home'), ('reputation'), ('course'), ('other')
--SELECT TRAVEL TIME
SELECT * FROM Persons.Reason

--*************************************************
--INSERTS PARA TABELA TRAVELTIME
INSERT INTO Persons.TravelTime(travelTime_hours)
VALUES('<15m'), ('15 to 30m'), ('30m to 1h'), ('>1h')
--SELECT TRAVEL TIME
SELECT * FROM Persons.TravelTime

--*************************************************
--INSERTS PARA TABELA STUDYTIME
INSERT INTO Persons.StudyTime(studyTime_time)
VALUES('<2h'), ('2 to 5h'), ('5 to 10h'), ('>10h')
--SELECT STUDYTIME
SELECT * FROM Persons.StudyTime

--*************************************************
--INSERTS PARA TABELA BADGOOD
INSERT INTO Persons.BadGood(badGood_value)
VALUES('Very Bad'), ('Bad'), ('Normal'), ('Good'), ('Very Good')
--SELECT BADGOOD
SELECT * FROM Persons.BadGood

--*************************************************
--INSERTS PARA TABELA LOWHIGH
INSERT INTO Persons.LowHigh(lowHigh_value)
VALUES('Very Low'), ('Low'), ('Normal'), ('High'), ('Very High')
--SELECT LOWHIGH
SELECT * FROM Persons.LowHigh

--*************************************************
--INSERTS PARA CRIAR PERSON PARA TER UM GUARDIAN COMO TESTE
INSERT INTO Persons.Person(person_name, person_address, person_opt_address, person_sex, person_birthDate, person_email)
VALUES('GuardianTest', 'U', 'randomAddress', 'F',20-12-1999 , 'guardianemail@gmail.com')

--INSERTS PARA CRIAR GUARDIAN COM UM GUARDIAN PARA TESTE
INSERT INTO Persons.Guardian(guardian_person_id, guardian_type, guardian_job_id, guardian_education)
VALUES (1948, 'Mother', 1, 3)

--SELECT 
SELECT * FROM Persons.Person WHERE person_id = 1948
SELECT * FROM Persons.Guardian



--*************************************************

--INSERTS PARA TABELA STUDENT COM CASES PARA SUBSTITUIR O TEXTO QUE VEM DA OLDDATA COM O RESPETIVO ID DAS TABELAS JOB E REASON

INSERT INTO Persons.Student(student_person_id, 
student_number, 
student_guardian_id, 
student_mJob_id, 
student_fJob_id, 
student_school, 
student_famSize, 
student_Pstatus, 
student_reason_id,
student_travelTime_id, 
student_studyTime_id, 
student_failures,
student_schoolsup, 
student_famsup, 
student_paid, 
student_activities, 
student_nursery, 
student_higher,
student_internet, 
student_romantic, 
student_famrel_id, 
student_freetime_id, 
student_goout_id,
student_Dalc_id, 
student_Walc_id, student_health_id,student_absences)
SELECT  [Student Number],
[Student Number], 
1,
CASE WHEN [Mjob] = 'at_home' THEN 1 
	WHEN [Mjob] = 'teacher' THEN 2 
	WHEN [Mjob] = 'health' THEN 3
	WHEN [Mjob] = 'services' THEN 4
	WHEN [Mjob] = 'other' THEN 5 ELSE 0 END, 

CASE WHEN [Fjob] = 'at_home' THEN 1 
	WHEN [Fjob] = 'teacher' THEN 2 
	WHEN [Fjob] = 'health' THEN 3
	WHEN [Fjob] = 'services' THEN 4
	WHEN [Fjob] = 'other' THEN 5 ELSE 0 END, 
[school], 
[famsize], 
[Pstatus],
CASE WHEN [reason] = 'home' THEN 1
     WHEN [reason] = 'reputation' THEN 2
     WHEN [reason] = 'course' THEN 3
	 WHEN [reason] = 'other' THEN 4
     ELSE 0 END,
[traveltime],
[studytime],
[failures],
CASE WHEN[schoolsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[famsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[paid] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[activities] = 'yes' THEN 1 ELSE 0 END, 
CASE WHEN[nursery] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[higher] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[internet] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[romantic] = 'yes' THEN 1 ELSE 0 END , 
		[famrel], [freetime],[goout],[Dalc],[Walc],[health],[absences]
FROM OldData.[dbo].['2017_Student_BD$'];

INSERT INTO Persons.Student(student_person_id, 
student_number, 
student_guardian_id, 
student_mJob_id, 
student_fJob_id, 
student_school, 
student_famSize, 
student_Pstatus, 
student_reason_id,
student_travelTime_id, 
student_studyTime_id, 
student_failures,
student_schoolsup, 
student_famsup, 
student_paid, 
student_activities, 
student_nursery, 
student_higher,
student_internet, 
student_romantic, 
student_famrel_id, 
student_freetime_id, 
student_goout_id,
student_Dalc_id, 
student_Walc_id, student_health_id,student_absences)
SELECT  [Student Number],
[Student Number], 
1,
CASE WHEN [Mjob] = 'at_home' THEN 1 
	WHEN [Mjob] = 'teacher' THEN 2 
	WHEN [Mjob] = 'health' THEN 3
	WHEN [Mjob] = 'services' THEN 4
	WHEN [Mjob] = 'other' THEN 5 ELSE 0 END, 

CASE WHEN [Fjob] = 'at_home' THEN 1 
	WHEN [Fjob] = 'teacher' THEN 2 
	WHEN [Fjob] = 'health' THEN 3
	WHEN [Fjob] = 'services' THEN 4
	WHEN [Fjob] = 'other' THEN 5 ELSE 0 END, 
[school], 
[famsize], 
[Pstatus],
CASE WHEN [reason] = 'home' THEN 1
     WHEN [reason] = 'reputation' THEN 2
     WHEN [reason] = 'course' THEN 3
	 WHEN [reason] = 'other' THEN 4
     ELSE 0 END,
[traveltime],
[studytime],
[failures],
CASE WHEN[schoolsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[famsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[paid] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[activities] = 'yes' THEN 1 ELSE 0 END, 
CASE WHEN[nursery] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[higher] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[internet] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[romantic] = 'yes' THEN 1 ELSE 0 END , 
		[famrel], [freetime],[goout],[Dalc],[Walc],[health],[absences]

FROM OldData.[dbo].['2018_Student_BD$'];

INSERT INTO Persons.Student(student_person_id, 
student_number, 
student_guardian_id, 
student_mJob_id, 
student_fJob_id, 
student_school, 
student_famSize, 
student_Pstatus, 
student_reason_id,
student_travelTime_id, 
student_studyTime_id, 
student_failures,
student_schoolsup, 
student_famsup, 
student_paid, 
student_activities, 
student_nursery, 
student_higher,
student_internet, 
student_romantic, 
student_famrel_id, 
student_freetime_id, 
student_goout_id,
student_Dalc_id, 
student_Walc_id, student_health_id,student_absences)
SELECT  [Student Number],
[Student Number], 
1,
CASE WHEN [Mjob] = 'at_home' THEN 1 
	WHEN [Mjob] = 'teacher' THEN 2 
	WHEN [Mjob] = 'health' THEN 3
	WHEN [Mjob] = 'services' THEN 4
	WHEN [Mjob] = 'other' THEN 5 ELSE 0 END, 

CASE WHEN [Fjob] = 'at_home' THEN 1 
	WHEN [Fjob] = 'teacher' THEN 2 
	WHEN [Fjob] = 'health' THEN 3
	WHEN [Fjob] = 'services' THEN 4
	WHEN [Fjob] = 'other' THEN 5 ELSE 0 END, 
[school], 
[famsize], 
[Pstatus],
CASE WHEN [reason] = 'home' THEN 1
     WHEN [reason] = 'reputation' THEN 2
     WHEN [reason] = 'course' THEN 3
	 WHEN [reason] = 'other' THEN 4
     ELSE 0 END,
[traveltime],
[studytime],
[failures],
CASE WHEN[schoolsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[famsup] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[paid] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[activities] = 'yes' THEN 1 ELSE 0 END, 
CASE WHEN[nursery] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[higher] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[internet] = 'yes' THEN 1 ELSE 0 END,
CASE WHEN[romantic] = 'yes' THEN 1 ELSE 0 END , 
		[famrel], [freetime],[goout],[Dalc],[Walc],[health],[absences]

FROM OldData.[dbo].['2019_Student_BD$'];
--SELECT DA TABELA STUDENT
SELECT * FROM Persons.STUDENT
--*************************************************
--INSERT PARA TABELA HIERARCHY PARA NO LOGIN SABER O TIPO DE UTILIZADOR
INSERT INTO Persons.Hierarchy(hierarchy_type)
VALUES ('Student'), ('Guardian');

--SELECT TABELA HIERARCHY
SELECT * FROM Persons.Hierarchy

--*************************************************
--INSERT PARA TABELA ACCESS COM DADOS DUMMY
INSERT INTO Persons.Access(access_person_id, access_password, access_hierarchy_id)
SELECT [Student Number], Persons.hashPassword('password'), 1
FROM OldData.[dbo].['2017_Student_CBD$']

INSERT INTO Persons.Access(access_person_id, access_password, access_hierarchy_id)
SELECT [Student Number], Persons.hashPassword('password'), 1
FROM OldData.[dbo].['2018_Student_CBD$']

INSERT INTO Persons.Access(access_person_id, access_password, access_hierarchy_id)
SELECT [Student Number], Persons.hashPassword('password'), 1
FROM OldData.[dbo].['2019_Student_CBD$']

SELECT * FROM Persons.Access;

--*************************************************
--INSERT PARA TABELA LANGUAGE PARA TER 2 TRADUÇÕES
INSERT INTO School.Language(language_initials)
VALUES ('ENG'), ('PT');

SELECT * FROM School.Language

--*************************************************
--INSERT PARA TABELA DEPARTMENT
INSERT INTO School.Department(department_name)
SELECT DISTINCT [Department]
FROM OldData.[dbo].['2017_Student_BD$']

INSERT INTO School.Department(department_name)
SELECT DISTINCT [Department]
FROM OldData.[dbo].['2017_Student_MAT1$']

SELECT * FROM School.Department

--*************************************************
--INSERT PARA TABELA DEPARTMENTLANGUAGE COM AS SUAS TRADUÇÕES
INSERT INTO School.DepartmentLanguage(departmentLanguage_department_id, departmentLanguage_language_id, department_translation)
VALUES (1, 1, 'Information Systems Department'), (1, 2, 'Departamento de Sistemas de Informação'), (2, 1, 'Mathematics Department'), (2, 2, 'Departamento de Matemática');
SELECT * FROM School.DepartmentLanguage;
--*************************************************
--INSERT PARA TABELA SCIENTIFICAREA
INSERT INTO School.ScientificArea(area_name, area_department_id)
SELECT DISTINCT [ScientificArea], 1
FROM oldData.[dbo].['2017_Student_BD$'];

INSERT INTO School.ScientificArea(area_name, area_department_id)
SELECT DISTINCT [ScientificArea], 2
FROM OldData.[dbo].['2017_Student_MAT1$']

SELECT * FROM School.ScientificArea;
--*************************************************
--INSERT PARA TABELA AREALANGUAGE COM AS SUAS TRADUÇÕES
INSERT INTO School.AreaLanguage(areaLanguage_area_id, areaLanguage_language_id, area_translation)
VALUES (1, 1, 'Databases'), (1, 2, 'Base de Dados'), (2, 1, 'Mathematics'), (2, 2, 'Matemática');
SELECT * FROM School.AreaLanguage;
--*************************************************
--INSERT PARA TABELA SUBJECT
INSERT INTO School.Subjects(subject_name, subject_area_id)
SELECT DISTINCT [Subject],1
FROM oldData.[dbo].['2017_Student_BD$'];

INSERT INTO School.Subjects(subject_name, subject_area_id)
SELECT DISTINCT [Subject],1
FROM oldData.[dbo].['2017_Student_CBD$'];

INSERT INTO School.Subjects(subject_name, subject_area_id)
SELECT DISTINCT [Subject],2
FROM oldData.[dbo].['2017_Student_MAT1$'];

SELECT * FROM School.Subjects
--*************************************************
--INSERT PARA TABELA SUBJECTAREA COM AS SUAS TRADUÇÕES
INSERT INTO School.SubjectsLanguage(subjectLanguage_subject_id, subjectLanguage_language_id, subject_translation)
VALUES (1, 1, 'Databases'), (1, 2, 'Bases de Dados'), (2, 1, 'DataBase Add-Ons'), (2, 2, 'DataBase Add-Ons'), (3, 1, 'Mathematics 1'), (3, 2, 'Matemática 1');
SELECT * FROM School.SubjectsLanguage;
--*************************************************
--INSERT PARA TABELA ACADEMICYEAR
INSERT INTO School.AcademicYear(academicY_year, academicY_closed)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2017_Student_BD$'];

INSERT INTO School.AcademicYear(academicY_year, academicY_closed)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2018_Student_BD$'];

INSERT INTO School.AcademicYear(academicY_year, academicY_closed)
SELECT DISTINCT [year], 0
FROM oldData.[dbo].['2019_Student_BD$'];

SELECT * FROM School.AcademicYear
--*************************************************
--INSERT PARA TABELA PERIOD
INSERT INTO School.Period(period_number)
VALUES (1), (2), (3);

SELECT * FROM School.Period

--*************************************************
--INSERT PARA TABELA CLOSEDINSCRIPTIONS ANO 2017
INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 1, 1
FROM oldData.[dbo].['2017_Student_BD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 2, 1
FROM oldData.[dbo].['2017_Student_CBD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 3, 1
FROM oldData.[dbo].['2017_Student_MAT1$']
------
--INSERT PARA TABELA CLOSEDINSCRIPTIONS ANO 2018
INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 1, 2
FROM oldData.[dbo].['2018_Student_BD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 2, 2
FROM oldData.[dbo].['2018_Student_CBD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 3, 2
FROM oldData.[dbo].['2018_Student_MAT1$']
----

--INSERT PARA TABELA CLOSEDINSCRIPTIONS ANO 2018
INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 1, 3
FROM oldData.[dbo].['2019_Student_BD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 2, 3
FROM oldData.[dbo].['2019_Student_CBD$']

INSERT INTO School.ClosedInscriptions(closedInscrip_student_id, closedInscrip_subject_id, closedInscrip_academicY_Id)
SELECT [Student Number], 3, 3
FROM oldData.[dbo].['2019_Student_MAT1$']

SELECT * FROM School.ClosedInscriptions	

--INSERT PARA TABELA CLOSEDGRADES
--INSERT TABELA NOTASFECHADAS DA DISCIPLINA BD 2017 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 1, [P1], 1
FROM OldData.[dbo].['2017_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 1, [P2], 2
FROM OldData.[dbo].['2017_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 1, [P3], 3
FROM OldData.[dbo].['2017_Student_BD$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA CBD 2017 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 1, [P1], 1
FROM OldData.[dbo].['2017_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 1, [P2], 2
FROM OldData.[dbo].['2017_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 1, [P3], 3
FROM OldData.[dbo].['2017_Student_CBD$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA MAT1 2017 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 1, [P1], 1
FROM OldData.[dbo].['2017_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 1, [P2], 2
FROM OldData.[dbo].['2017_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 1, [P3], 3
FROM OldData.[dbo].['2017_Student_MAT1$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA BD 2018 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 2, [P1], 1
FROM OldData.[dbo].['2018_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 2, [P2], 2
FROM OldData.[dbo].['2018_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 2, [P3], 3
FROM OldData.[dbo].['2018_Student_BD$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA CBD 2018 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 2, [P1], 1
FROM OldData.[dbo].['2018_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 2, [P2], 2
FROM OldData.[dbo].['2018_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 2, [P3], 3
FROM OldData.[dbo].['2018_Student_CBD$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA MAT1 2018 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 2, [P1], 1
FROM OldData.[dbo].['2018_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 2, [P2], 2
FROM OldData.[dbo].['2018_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 2, [P3], 3
FROM OldData.[dbo].['2018_Student_MAT1$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA BD 2019 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 3, [P1], 1
FROM OldData.[dbo].['2019_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 3, [P2], 2
FROM OldData.[dbo].['2019_Student_BD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 1, 3, [P3], 3
FROM OldData.[dbo].['2019_Student_BD$'];
 
--INSERT TABELA NOTASFECHADAS DA DISCIPLINA CBD 2019 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 3, [P1], 1
FROM OldData.[dbo].['2019_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 3, [P2], 2
FROM OldData.[dbo].['2019_Student_CBD$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 2, 3, [P3], 3
FROM OldData.[dbo].['2019_Student_CBD$'];

--INSERT TABELA NOTASFECHADAS DA DISCIPLINA MAT1 2019 PERIODO 1, 2 E 3
INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 3, [P1], 1
FROM OldData.[dbo].['2019_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 3, [P2], 2
FROM OldData.[dbo].['2019_Student_MAT1$'];

INSERT INTO School.ClosedGrades(closed_grade_student_id, closed_grade_subject_id, closed_grade_academicY_id, closed_grade_value, closed_grade_period)
SELECT [Student Number], 3, 3, [P3], 3
FROM OldData.[dbo].['2019_Student_MAT1$'];

SELECT * FROM School.ClosedGrades

