-- Использовать данную БД как рабочую
USE AdventureWorks2012;
GO

-- a) добавьте в таблицу dbo.PersonPhone поле HireDate типа date;

ALTER TABLE dbo.PersonPhone
	ADD HireDate DATE;
GO

-- b) объявите табличную переменную с такой же структурой как dbo.PersonPhone 
-- и заполните ее данными из dbo.PersonPhone. Заполните поле HireDate значениями 
-- из поля HireDate таблицы HumanResources.Employee;

DECLARE @PersonPhoneTable TABLE(
	BusinessEntityID INT,
	PhoneNumber NVARCHAR(25),
	PhoneNumberTypeID INT,
	ModifiedDate DATETIME,
	ID BIGINT,
	HireDate DATE
)

INSERT INTO @PersonPhoneTable (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	ID,
	HireDate
) 
SELECT
	PersonPhone.BusinessEntityID,
	PersonPhone.PhoneNumber,
	PersonPhone.PhoneNumberTypeID,
	PersonPhone.ModifiedDate,
	PersonPhone.ID,
	Employee.HireDate

FROM dbo.PersonPhone

INNER JOIN HumanResources.Employee
	ON PersonPhone.BusinessEntityID = Employee.BusinessEntityID;

-- Получение данных из таблицы @PersonPhoneTable

SELECT * FROM @PersonPhoneTable;

-- c) обновите HireDate в dbo.PersonPhone данными из табличной переменной, добавив к HireDate один день;

UPDATE dbo.PersonPhone
	SET PersonPhone.HireDate = DATEADD(DAY, 1, PersonPhoneTable.HireDate)
	
	FROM @PersonPhoneTable AS PersonPhoneTable

	WHERE PersonPhone.BusinessEntityID = PersonPhoneTable.BusinessEntityID;

-- Получение таблицы с обновленными данными, у которой к полю HireDate добавлен один день

SELECT * FROM dbo.PersonPhone ORDER BY PersonPhone.BusinessEntityID;

-- d) удалите данные из dbo.PersonPhone, для тех сотрудников,
-- у которых почасовая ставка в таблице HumanResources.EmployeePayHistory больше 50;

DELETE FROM dbo.PersonPhone 
	WHERE EXISTS (
		SELECT BusinessEntityID, Rate
			FROM HumanResources.EmployeePayHistory

			WHERE HumanResources.EmployeePayHistory.Rate > 50
				AND EmployeePayHistory.BusinessEntityID = PersonPhone.BusinessEntityID
		);
GO

-- Получение таблицы без удаленных данных

SELECT PersonPhone.BusinessEntityID,
	EmployeePayHistory.Rate

	FROM dbo.PersonPhone

	INNER JOIN HumanResources.EmployeePayHistory
		ON PersonPhone.BusinessEntityID = EmployeePayHistory.BusinessEntityID;
GO

-- e) удалите все созданные ограничения и значения по умолчанию. После этого, удалите поле ID.
-- Имена значений по умолчанию найдите самостоятельно, приведите код, которым пользовались для поиска;

-- Найти ограничения в таблице dbo.PersonPhone

SELECT * FROM INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
	WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'PersonPhone';
GO

-- Найти значения по умолчанию в таблице dbo.PersonPhone

SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;
GO

-- Удалить ограничение 

ALTER TABLE dbo.PersonPhone
	DROP CONSTRAINT PhoneNumber_Value;
GO

-- Удалить значение по умолчанию

ALTER TABLE dbo.PersonPhone
	DROP CONSTRAINT PhoneNumberTypeID_Default;
GO

--f) удалите таблицу dbo.PersonPhone.

DROP TABLE dbo.PersonPhone;
GO

