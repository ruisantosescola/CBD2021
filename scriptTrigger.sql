USE Agrupamento_STB
DROP TABLE IF EXISTS Logs.PersonLogs;

SELECT * INTO Logs.PersonLogs 
FROM Persons.Person
WHERE 0=1

ALTER TABLE Logs.PersonLogs 
DROP COLUMN person_id

ALTER TABLE Logs.PersonLogs 
	ADD PersonLogID int NOT NULL IDENTITY PRIMARY KEY,
	person_id int NOT NULL,
    Log_Data dateTime NOT NULL,
    Log_Operacao char NOT NULL
    CHECK (Log_Operacao = 'U' OR Log_Operacao = 'D')

SELECT * FROM Logs.PersonLogs
-----------------Trigger-----------------------

DROP TRIGGER IF EXISTS Persons.personEdit;

CREATE OR ALTER TRIGGER Persons.personEdit
    ON Persons.Person
    AFTER UPDATE, DELETE
    AS 
        DECLARE @Type char(1)
        
        SET @Type=NULL

        IF EXISTS (SELECT * FROM inserted)
        BEGIN
            IF EXISTS (SELECT * FROM deleted)
            BEGIN
                SET @Type='U'
                INSERT INTO Logs.PersonLogs 
                    ( person_id,person_name,person_address,person_opt_address,person_sex,person_birthDate,person_email,Log_Data,Log_Operacao)
                SELECT
                   person_id,person_name,person_address,person_opt_address,person_sex,person_birthDate,person_email,GETDATE(),@Type
                FROM inserted
            END
        END
        ELSE IF EXISTS (SELECT * FROM deleted)
        BEGIN
            SET @Type='D'
            INSERT INTO Logs.PersonLogs  
                 ( person_id,person_name,person_address,person_opt_address,person_sex,person_birthDate,person_email,Log_Data,Log_Operacao)
            SELECT
              person_id,person_name,person_address,person_opt_address,person_sex,person_birthDate,person_email,GETDATE(),@Type
            FROM DELETED
        END

--------EXECUTAR---------

UPDATE Persons.Person
SET person_name = 'AAAAAA'
WHERE person_id = 2; 

select * from Persons.Person
select * from Logs.PersonLogs

