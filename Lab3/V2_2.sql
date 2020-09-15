USE AdventureWorks2012;
GO

-- a) выполните код, созданный во втором задании второй лабораторной работы. 
-- Добавьте в таблицу dbo.PersonPhone поля JobTitle NVARCHAR(50), BirthDate DATE и HireDate DATE. 
-- Также создайте в таблице вычисляемое поле HireAge, считающее количество лет, прошедших между BirthDate и HireDate.

ALTER TABLE dbo.PersonPhone
	ADD JobTitle NVARCHAR(50), 
	BirthDate DATE,
	HireDate DATE,
	HireAge AS DATEDIFF(year, BirthDate, HireDate)
GO

-- b) создайте временную таблицу #PersonPhone, с первичным ключом по полю BusinessEntityID.
-- Временная таблица должна включать все поля таблицы dbo.PersonPhone за исключением поля HireAge.

CREATE TABLE #PersonPhone (
	BusinessEntityID INT PRIMARY KEY,
	PhoneNumber NVARCHAR(25),
	PhoneNumberTypeID INT,
	ModifiedDate DATETIME,
	ID BIGINT,
	JobTitle NVARCHAR(50), 
	BirthDate DATE,
	HireDate DATE
);
GO

-- c) заполните временную таблицу данными из dbo.PersonPhone. Поля JobTitle, BirthDate и HireDate 
-- заполните значениями из таблицы HumanResources.Employee. Выберите только сотрудников с JobTitle = ‘Sales Representative’. 
-- Выборку данных для вставки в табличную переменную осуществите в Common Table Expression (CTE).

WITH TempPersonPhone (
	BusinessEntityID,	
	PhoneNumber, 
	PhoneNumberTypeID, 
	ModifiedDate, 
	ID,
	JobTitle, 
	BirthDate,
	HireDate
) AS ( 
SELECT
	PersonPhone.BusinessEntityID,
	PersonPhone.PhoneNumber,
	PersonPhone.PhoneNumberTypeID,
	PersonPhone.ModifiedDate,
	PersonPhone.ID,
	Employee.JobTitle, 
	Employee.BirthDate,
	Employee.HireDate
FROM dbo.PersonPhone

INNER JOIN HumanResources.Employee
	ON PersonPhone.BusinessEntityID = Employee.BusinessEntityID

WHERE Employee.JobTitle = 'Sales Representative'
)
INSERT INTO #PersonPhone (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	ID,
	JobTitle, 
	BirthDate,
	HireDate
) 

SELECT * FROM TempPersonPhone;
GO

-- Получить данные из временной таблицы

SELECT * FROM #PersonPhone;
GO

-- d) удалите из таблицы dbo.PersonPhone одну строку (где BusinessEntityID = 275)

DELETE FROM dbo.PersonPhone
	WHERE PersonPhone.BusinessEntityID = 275;
GO

SELECT * FROM dbo.PersonPhone 
	WHERE PersonPhone.BusinessEntityID = 275;

-- e) напишите Merge выражение, использующее dbo.PersonPhone как target, а временную таблицу как source. 
-- Для связи target и source используйте BusinessEntity	ID. Обновите поля JobTitle, BirthDate и HireDate, 
-- если запись присутствует и в source и в target. Если строка присутствует во временной таблице, но не существует в target, 
-- добавьте строку в dbo.PersonPhone. Если в dbo.PersonPhone присутствует такая строка, которой не существует во временной таблице, 
-- удалите строку из dbo.PersonPhone.

-- Заполнение таблицы PersonPhone "мусорными" данными

SET IDENTITY_INSERT dbo.PersonPhone ON;

INSERT INTO dbo.PersonPhone (
	BusinessEntityID,
	PhoneNumber,
	PhoneNumberTypeID,
	ModifiedDate,
	ID,
	JobTitle, 
	BirthDate,
	HireDate
) VALUES (
	11111,
	'11111',
	11111,
	GETDATE(),
	11111,
	'Manager',
	GETDATE(),
	GETDATE()
);
GO

-- Merge выражение

MERGE dbo.PersonPhone trg
USING #PersonPhone src
	ON (trg.BusinessEntityID = src.BusinessEntityID)

WHEN MATCHED 
	THEN UPDATE SET
		trg.JobTitle = src.JobTitle, 
		trg.BirthDate = src.BirthDate,
		trg.HireDate = src.HireDate

WHEN NOT MATCHED BY TARGET
	THEN INSERT (
		BusinessEntityID,
		PhoneNumber,
		PhoneNumberTypeID,
		ModifiedDate,
		ID,
		JobTitle, 
		BirthDate,
		HireDate
) VALUES (
		src.BusinessEntityID,
		src.PhoneNumber,
		src.PhoneNumberTypeID,
		src.ModifiedDate,
		src.ID,
		src.JobTitle, 
		src.BirthDate,
		src.HireDate
)

WHEN NOT MATCHED BY SOURCE
	THEN DELETE;
GO

SELECT * FROM dbo.PersonPhone
	WHERE BusinessEntityID = 275;

