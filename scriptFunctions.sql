USE Agrupamento_STB
DROP FUNCTION IF EXISTS Persons.hashPassword

GO
CREATE or alter FUNCTION Persons.hashPassword(@password varchar(100))
RETURNS varbinary(250)
AS
BEGIN
	declare @pass varchar(200)
	select @pass = hashbytes('SHA1',@password)
	return convert(varbinary(250),@pass)
END

