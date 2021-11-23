--DROP  
USE master
DROP DATABASE IF EXISTS Agrupamento_STB
--Creates Database
CREATE DATABASE Agrupamento_STB
ON
PRIMARY 
(NAME = agrupamentoSTB,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\agrupamentoSTB.mdf',
SIZE = 10MB, FILEGROWTH = 1MB),
FILEGROUP [Persons_STB]
(NAME = agrupamentoSTB_persons,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\agrupamentoSTB_persons.ndf',
SIZE = 30MB, MAXSIZE = 500MB, FILEGROWTH = 10MB),
FILEGROUP [School_STB]
(NAME = agrupamentoSTB_school,
FILENAME = 'F:\SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\agrupamentoSTB_school.ndf',
SIZE = 100MB, MAXSIZE = 2GB, FILEGROWTH = 30MB);


USE Agrupamento_STB;

DROP SCHEMA IF EXISTS Persons;
DROP SCHEMA IF EXISTS School;
DROP SCHEMA IF EXISTS Logs;

-- CREATE SCHEMA LOGS
CREATE SCHEMA Logs;
GO
-- CREATE SCHEMA PERSONS
CREATE SCHEMA Persons; 
GO
-- CREATE SCHEMA SCHOOL 
CREATE SCHEMA School;
GO

--CREATES TABELAS PERSON 
CREATE TABLE Persons.[Person] (
                [person_id] INT PRIMARY KEY IDENTITY(1, 1),
				[person_name] VARCHAR(50) NOT NULL,
                [person_address] VARCHAR(50) NOT NULL CHECK([person_address] IN ('U', 'R')),
				[person_opt_address] VARCHAR(50),  
				[person_sex] CHAR(1) NOT NULL CHECK([person_sex] IN ('F', 'M')),
				[person_birthDate] DATETIME NOT NULL,
				[person_email] VARCHAR(255),
                )ON [Persons_STB];

--CREATES TABELAS JOBS PARA GUARDAR CADA TRABALHO EXISTENTE
CREATE TABLE Persons.[Jobs] (
                [job_id] INT PRIMARY KEY IDENTITY(1, 1),
				[job_type] VARCHAR(50) NOT NULL CHECK([job_type] IN ('at_home', 'teacher', 'health', 'services', 'other')),
                )ON [Persons_STB];

--CREATES TABELAS REASON PARA GUARDAR CADA RAZAO DE ESCOLHER A ESCOLA EXISTENTE
CREATE TABLE Persons.[Reason] (
                [reason_id] INT PRIMARY KEY IDENTITY(1, 1),
				[reason_text] VARCHAR(50) NOT NULL CHECK ([reason_text] IN ('home', 'reputation', 'course', 'other')), 
                )ON [Persons_STB];

--CREATES TABELAS TRAVELTIME GUARDAR TODOS OS DIFERENTES TEMPOS DE VIAGEM ATE HÁ ESCOLA EXISTENTE
CREATE TABLE Persons.[TravelTime] (
                [travelTime_id] INT PRIMARY KEY IDENTITY(1, 1),
				[travelTime_hours] VARCHAR(50) NOT NULL CHECK ([travelTime_hours] IN ('<15m', '15 to 30m', '30m to 1h', '>1h')),
                )ON [Persons_STB];

--CREATES TABELAS STUDYTIME GUARDAR TODOS OS DIFERENTES TEMPOS DE ESTUDO EXISTENTES
CREATE TABLE Persons.[StudyTime] (
                [studyTime_id] INT PRIMARY KEY IDENTITY(1, 1),
				[studyTime_time] VARCHAR(50) NOT NULL CHECK ([studyTime_time] IN ('<2h', '2 to 5h', '5 to 10h', '>10h')),
                )ON [Persons_STB];

--CREATES TABELAS BADGOOD PARA GUARDAR AS 
CREATE TABLE Persons.[BadGood] (
                [badGood_id] INT PRIMARY KEY IDENTITY(1, 1),
				[badGood_value] VARCHAR(50) NOT NULL CHECK ([badGood_value] IN ('Very Bad', 'Bad', 'Normal', 'Good', 'Very Good')),
                )ON [Persons_STB];

--CREATES TABELAS LOWHIGH
CREATE TABLE Persons.[LowHigh] (
                [lowHigh_id] INT PRIMARY KEY IDENTITY(1, 1),
				[lowHigh_value] VARCHAR(50) NOT NULL CHECK ([lowHigh_value] IN ('Very Low', 'Low', 'Normal', 'High', 'Very High')),
                )ON [Persons_STB];

--CREATES TABELAS GUARDIAN
CREATE TABLE Persons.[Guardian] (
                [guardian_id] INT PRIMARY KEY IDENTITY(1, 1),
				[guardian_person_id] INT NOT NULL,
                [guardian_type] varchar(50) NOT NULL,
				[guardian_job_id] INT NOT NULL ,
				[guardian_education] NUMERIC NOT NULL CHECK([guardian_education] IN (0, 1, 2, 3, 4)),
                CONSTRAINT fk_Guardian_guardian_person_id FOREIGN KEY (guardian_person_id) REFERENCES Persons.[Person](person_id),
				CONSTRAINT fk_Guardian_guardian_job_id FOREIGN KEY (guardian_job_id) REFERENCES Persons.[Jobs](job_id)
                )ON [Persons_STB];

--CREATES TABELAS STUDENT
CREATE TABLE Persons.[Student] (
                [student_id] INT PRIMARY KEY IDENTITY(1, 1),
				[student_person_id] INT NOT NULL,
				[student_number] CHAR(10) NOT NULL,
				[student_guardian_id] INT NOT NULL,
				[student_mJob_id] INT NOT NULL,--
				[student_fJob_id] INT NOT NULL,--
				[student_school] VARCHAR(2) NOT NULL CHECK([student_school] IN ('GP', 'MS')),
                [student_famSize] VARCHAR(3) NOT NULL CHECK([student_famSize] IN ('LE3', 'GT3')),
				[student_Pstatus] CHAR NOT NULL CHECK([student_Pstatus] IN ('T', 'A')),
				[student_reason_id] INT NOT NULL,
				[student_travelTime_id] INT NOT NULL CHECK([student_travelTime_id] IN (1, 2, 3, 4)),
				[student_studyTime_id] INT NOT NULL CHECK([student_studyTime_id] IN (1, 2, 3, 4)),
				[student_failures] INT NOT NULL CHECK ([student_failures]>=0 AND [student_failures] <= 4),
				[student_schoolsup] BIT NOT NULL CHECK([student_schoolSup] IN (0,1)),
				[student_famsup] BIT NOT NULL CHECK([student_famSup] IN (0,1)),
				[student_paid] BIT NOT NULL CHECK([student_paid] IN (0,1)),
				[student_activities] BIT NOT NULL CHECK([student_activities] IN (0,1)),
				[student_nursery] BIT NOT NULL CHECK([student_nursery] IN (0,1)),
				[student_higher] BIT NOT NULL CHECK([student_higher] IN (0,1)),
				[student_internet] BIT NOT NULL CHECK([student_internet] IN (0,1)),
				[student_romantic] BIT NOT NULL CHECK([student_romantic] IN (0,1)),
				[student_famrel_id] INT NOT NULL CHECK([student_famRel_id] IN (1, 2, 3, 4, 5)),
				[student_freetime_id] INT NOT NULL CHECK ([student_freeTime_id] IN (1, 2, 3, 4, 5)),--
				[student_goout_id] INT NOT NULL CHECK ([student_goout_id] IN (1, 2, 3, 4, 5)),
				[student_Dalc_id] INT NOT NULL CHECK ([student_Dalc_id] IN (1, 2, 3, 4, 5)),
				[student_Walc_id] INT NOT NULL CHECK ([student_Walc_id] IN (1, 2, 3, 4, 5)),
				[student_health_id] INT NOT NULL CHECK ([student_health_id] IN (1, 2, 3, 4, 5)),
				[student_absences] INT NOT NULL CHECK ([student_absences] >= 0 AND [student_absences] <=93),
				CONSTRAINT fk_Student_student_person_id FOREIGN KEY (student_person_id) REFERENCES Persons.[Person](person_id), 
				CONSTRAINT fk_Student_student_mJob_id FOREIGN KEY (student_mJob_id) REFERENCES Persons.[Jobs](job_id),
				CONSTRAINT fk_Student_student_fJob_id FOREIGN KEY (student_reason_id) REFERENCES Persons.[Jobs](job_id),
				CONSTRAINT fk_Student_student_reason_id FOREIGN KEY (student_reason_id) REFERENCES Persons.[Reason](reason_id),
				CONSTRAINT fk_Student_student_travelTime_id FOREIGN KEY (student_travelTime_id) REFERENCES Persons.[TravelTime](travelTime_id),
				CONSTRAINT fk_Student_student_studyTime_id FOREIGN KEY (student_studyTime_id) REFERENCES Persons.[StudyTime](studyTime_id),
				CONSTRAINT fk_Student_student_famrel_id FOREIGN KEY (student_famrel_id) REFERENCES Persons.[BadGood](badGood_id),
				CONSTRAINT fk_Student_student_freetime_id FOREIGN KEY (student_freetime_id) REFERENCES Persons.[LowHigh](lowHigh_id),
				CONSTRAINT fk_Student_student_goout_id FOREIGN KEY (student_goout_id) REFERENCES Persons.[LowHigh](lowHigh_id),
				CONSTRAINT fk_Student_student_Dalc_id FOREIGN KEY (student_Dalc_id) REFERENCES Persons.[LowHigh](lowHigh_id),
				CONSTRAINT fk_Student_student_Walc_id FOREIGN KEY (student_Walc_id) REFERENCES Persons.[LowHigh](lowHigh_id),
				CONSTRAINT fk_Student_student_health_id FOREIGN KEY (student_health_id) REFERENCES Persons.[BadGood](badGood_id),
				CONSTRAINT fk_Student_student_guardian_id FOREIGN KEY (student_guardian_id) REFERENCES Persons.[Guardian](guardian_id)
                )On [Persons_STB];

--CREATES TABELAS HIERARCHY
CREATE TABLE Persons.[Hierarchy] (
				[hierarchy_id] INT PRIMARY KEY IDENTITY(1, 1),
				[hierarchy_type] VARCHAR(50) NOT NULL,
				)ON[Persons_STB];

--CREATES TABELAS ACCESS
CREATE TABLE Persons.[Access] (
				[access_id] INT PRIMARY KEY IDENTITY(1, 1),
				[access_person_id] INT NOT NULL,
				[access_password] VARCHAR(50) NOT NULL,
				[access_hierarchy_id] INT NOT NULL,
				CONSTRAINT fk_Access_access_person_id FOREIGN KEY (access_person_id) REFERENCES Persons.[Person](person_id),
				CONSTRAINT fk_Access_access_hierarchy_id FOREIGN KEY (access_hierarchy_id) REFERENCES Persons.[Hierarchy](hierarchy_id)
				) ON [Persons_STB];

--CREATES TABELAS RECOVERY
CREATE TABLE Persons.[Recovery] (
				[recovery_id] INT PRIMARY KEY IDENTITY(1, 1),
				[recovery_access_id] INT NOT NULL,
				[recovery_token] VARCHAR(50),
				[recovery_newPass] VARCHAR(50),
				[recovery_confirmNewPass] VARCHAR(50),
				CONSTRAINT fk_Recovery_recovery_access_id FOREIGN KEY (recovery_access_id) REFERENCES Persons.[Access](access_id)
				)ON [Persons_STB];

--CREATES TABELAS LANGUAGE
CREATE TABLE School.[Language] (
				[language_id] INT PRIMARY KEY IDENTITY(1, 1),
				[language_initials] varchar(5) NOT NULL,
				)ON [School_STB];

--CREATES TABELAS DEPARTMENT
CREATE TABLE School.[Department] (
				[department_id] INT PRIMARY KEY IDENTITY(1, 1),
				[department_name] varchar(50) NOT NULL,
				[department_parent_id] INT,
				CONSTRAINT fk_Department_department_parent_id FOREIGN KEY (department_parent_id) REFERENCES School.[Department](department_id)
				)ON [School_STB];

--CREATES TABELAS DEPARTMENTLANGUAGE
CREATE TABLE School.[DepartmentLanguage] (
				[departmentLanguage_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				[departmentLanguage_department_id] INT NOT NULL,
				[departmentLanguage_language_id] INT NOT NULL,
				[department_translation] VARCHAR(255)
				CONSTRAINT fk_DepartmentLanguage_departmentLanguage_department_id FOREIGN KEY (departmentLanguage_department_id) REFERENCES School.[Department](department_id),
				CONSTRAINT fk_DepartmentLanguage_departmentLanguage_idioma_id FOREIGN KEY (departmentLanguage_language_id) REFERENCES School.[Language](language_id)
				)ON [School_STB];

--CREATES TABELAS SCIENTIFICAREA
CREATE TABLE School.[ScientificArea] (
				[area_id] INT PRIMARY KEY IDENTITY(1, 1),
				[area_name] varchar(5) NOT NULL,
				[area_department_id] INT NOT NULL,
				CONSTRAINT fk_ScientificArea_area_depart_id FOREIGN KEY (area_department_id) REFERENCES School.[Department](department_Id),
				)ON [School_STB];

--CREATES TABELAS AREALANGUAGE
CREATE TABLE School.[AreaLanguage] (
				[areaLanguage_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				[areaLanguage_area_id] INT NOT NULL,
				[areaLanguage_language_id] INT NOT NULL,
				[area_translation] VARCHAR(255)
				CONSTRAINT fk_AreaLanguage_areaLanguage_area_id FOREIGN KEY (areaLanguage_area_id) REFERENCES School.[ScientificArea](area_id),
				CONSTRAINT fk_AreaLanguage_areaLanguage_language_id FOREIGN KEY (areaLanguage_language_id) REFERENCES School.[Language](language_id)
				)ON [School_STB];

--CREATES TABELAS SUBJECTS
CREATE TABLE School.[Subjects] (
				[subject_id] INT PRIMARY KEY IDENTITY(1, 1),
				[subject_name] varchar(50) NOT NULL,
				[subject_area_id] INT NOT NULL,
				CONSTRAINT fk_Subjects_subject_area_id FOREIGN KEY (subject_area_id) REFERENCES School.[ScientificArea](area_Id),
				)ON [School_STB];

--CREATES TABELAS SUBJECTSLANGUAGE
CREATE TABLE School.[SubjectsLanguage] (
				[subjectLanguage_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
				[subjectLanguage_subject_id] INT NOT NULL,
				[subjectLanguage_language_id] INT NOT NULL,
				[subject_translation] VARCHAR(255)
				CONSTRAINT fk_SubjectsLanguage_subjectLanguage_subject_id FOREIGN KEY (subjectLanguage_subject_id) REFERENCES School.[Subjects](subject_id),
				CONSTRAINT fk_SubjectsLanguage_subjectLanguage_language_id FOREIGN KEY (subjectLanguage_language_id) REFERENCES School.[Language](language_id)
				)ON [School_STB];

--CREATES TABELAS ACADEMICYEAR
CREATE TABLE School.[AcademicYear] (
				[academicY_id] INT PRIMARY KEY IDENTITY(1, 1),
				[academicY_year] INT NOT NULL,
				[academicY_closed] BIT NOT NULL,
				)ON [School_STB];

--CREATES TABELAS PERIOD
CREATE TABLE School.[Period] (
				[period_id] INT PRIMARY KEY IDENTITY(1, 1),
				[period_number] INT NOT NULL CHECK([period_number] IN (1, 2, 3)),
				)ON [School_STB];

--CREATES TABELAS CLOSEDINSCRIPTIONS
CREATE TABLE School.[ClosedInscriptions] (
				[closedInscrip_id] INT PRIMARY KEY IDENTITY(1, 1),
				[closedInscrip_student_id] INT NOT NULL,
				[closedInscrip_subject_id] INT NOT NULL,
				[closedInscrip_academicY_Id] INT NOT NULL,
				CONSTRAINT fk_ClosedInscriptions_closedInscrip_student_id FOREIGN KEY (closedInscrip_student_Id) REFERENCES Persons.[Student](student_Id),
				CONSTRAINT fk_ClosedInscriptions_closedInscrip_subject_id FOREIGN KEY (closedInscrip_subject_Id) REFERENCES School.[Subjects](subject_Id),
				CONSTRAINT fk_ClosedInscriptions_closedInscrip_academicY_Id FOREIGN KEY (closedInscrip_academicY_Id) REFERENCES School.[AcademicYear](academicY_Id),
				)ON [School_STB];

--CREATES TABELAS CLOSEDGRADES
CREATE TABLE School.[ClosedGrades] (
				[closed_grade_id] INT PRIMARY KEY IDENTITY(1, 1),
				[closed_grade_student_id] INT NOT NULL,
				[closed_grade_subject_id] INT NOT NULL,
				[closed_grade_academicY_id] INT NOT NULL,
				[closed_grade_value] FLOAT NOT NULL CHECK([closed_grade_value] >= 0 AND [closed_grade_value] <= 20),
				[closed_grade_period] INT NOT NULL,
				CONSTRAINT fk_ClosedGrades_closed_grade_student_id FOREIGN KEY (closed_grade_student_id) REFERENCES Persons.[Student](student_id),
				CONSTRAINT fk_ClosedGrades_closed_grade_subject_id FOREIGN KEY (closed_grade_subject_id) REFERENCES School.[Subjects](subject_id),
				CONSTRAINT fk_ClosedGrades_closed_grade_academicY_id FOREIGN KEY (closed_grade_academicY_id) REFERENCES School.[AcademicYear](academicY_id),
				)ON [School_STB];

--CREATES TABELAS LOGERRORS
CREATE TABLE Logs.[LogErrors](  
				[log_errors_id] INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,  
				[log_errors_line] INT NULL,  
				[log_errors_Message] VARCHAR(250) NULL,  
				[log_errors_Number] INT NULL,  
				[log_errors_Procedure] VARCHAR(128) NULL,  
				[log_errors_Severity] INT NULL,  
				[log_errors_State] INT NULL,  
				[log_errors_Date] DateTime NULL  
)ON [School_STB]; 

