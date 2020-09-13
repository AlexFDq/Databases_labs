-- ����������� ������� ��
USE [AdventureWorks2012];
GO

-- a) �������� ������� dbo.PersonPhone � ����� �� ���������� ��� 
-- Person.PersonPhone, �� ������� �������, ����������� � ��������;

CREATE TABLE [dbo].[PersonPhone] (
	[BusinessEntityID] INT NOT NULL,
	[PhoneNumber] NVARCHAR(25) NOT NULL,
	[PhoneNumberTypeID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
);
GO

-- b) ��������� ���������� ALTER TABLE, �������� � ������� dbo.PersonPhone ����� ���� ID, 
-- ������� �������� ���������� ������������ UNIQUE ���� bigint � ����� �������� identity. 
-- ��������� �������� ��� ���� identity ������� 2 � ���������� ������� 2;

ALTER TABLE [dbo].[PersonPhone]
	ADD [ID] BIGINT UNIQUE IDENTITY(2, 2);
GO

-- c) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.PersonPhone ����������� 
-- ��� ���� PhoneNumber, ����������� ���������� ����� ���� �������;

ALTER TABLE [dbo].[PersonPhone]
	ADD CONSTRAINT [PhoneNumber_Value] CHECK (PATINDEX('[a-zA-Z�-��-�]', [PhoneNumber]) = 0);
GO

-- d) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.PersonPhone ����������� 
-- DEFAULT ��� ���� PhoneNumberTypeID, ������� �������� �� ��������� 1;

ALTER TABLE [dbo].[PersonPhone]
	ADD CONSTRAINT [PhoneNumberTypeID_Default] DEFAULT 1 FOR [PhoneNumberTypeID];
GO

-- e) ��������� ����� ������� ������� �� Person.PersonPhone, ��� ���� PhoneNumber 
-- �� �������� �������� �(� � �)� � ������ ��� ��� �����������, ������� ���������� 
-- � ������� HumanResources.Employee, � �� ���� �������� �� ������ ��������� � ����� ������ ������ � ������;

INSERT INTO [dbo].[PersonPhone] (
	[BusinessEntityID],
	[PhoneNumber],
	[PhoneNumberTypeID],
	[ModifiedDate]
) 
SELECT 
	[PersonPhone].[BusinessEntityID],
	[PersonPhone].[PhoneNumber],
	[PersonPhone].[PhoneNumberTypeID],
	[PersonPhone].[ModifiedDate]
FROM [Person].[PersonPhone]

INNER JOIN [HumanResources].[Employee] 
	ON [Person].[PersonPhone].[BusinessEntityID] = [HumanResources].[Employee].[BusinessEntityID]

INNER JOIN [HumanResources].[EmployeeDepartmentHistory]
	ON [Employee].[BusinessEntityID] = [EmployeeDepartmentHistory].[BusinessEntityID]

WHERE [Employee].[HireDate] = [EmployeeDepartmentHistory].[StartDate] 
	AND [PersonPhone].[PhoneNumber] NOT LIKE '%(%)%';
GO

-- ��������� �������, ��� ���� PhoneNumber �� �������� �������� �(� � �)� � ������ ��� ��� �����������, 
-- ������� ���������� � ������� HumanResources.Employee, � �� ���� �������� �� ������ ��������� � ����� ������ ������ � ������;

SELECT [PersonPhone].[BusinessEntityID],
		[PersonPhone].[PhoneNumber],
		[PersonPhone].[PhoneNumberTypeID],
		[PersonPhone].[ID],
		[EmployeeDepartmentHistory].[StartDate],
		[Employee].[HireDate]

	FROM [dbo].[PersonPhone]

	INNER JOIN [HumanResources].[Employee] 
	ON [dbo].[PersonPhone].[BusinessEntityID] = [HumanResources].[Employee].[BusinessEntityID]

	INNER JOIN [HumanResources].[EmployeeDepartmentHistory]
	ON [Employee].[BusinessEntityID] = [EmployeeDepartmentHistory].[BusinessEntityID];
GO

	
-- f) �������� ���� PhoneNumber, �������� ���������� null ��������.

ALTER TABLE [dbo].[PersonPhone] 
	ALTER COLUMN [PhoneNumber] NVARCHAR(25) NULL;
GO