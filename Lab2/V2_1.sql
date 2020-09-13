-- ����������� ������� ��
USE [AdventureWorks2012];
GO

-- ������� �� ����� ������� ����������, ������� �������� �� ������� �Purchasing Manager�. 
-- � ����� ������� �������� �� �������, � ��������� �������� ������ � ������ ������.

SELECT [EmployeeDepartmentHistory].[BusinessEntityID],
		[Employee].[JobTitle],
		[Department].[Name] AS [DepartmentName],
		[EmployeeDepartmentHistory].[StartDate],
		[EmployeeDepartmentHistory].[EndDate]

	FROM [HumanResources].[EmployeeDepartmentHistory]

	INNER JOIN [HumanResources].[Employee]
		ON [EmployeeDepartmentHistory].[BusinessEntityID] = [Employee].[BusinessEntityID]

	INNER JOIN [HumanResources].[Department]
		ON [EmployeeDepartmentHistory].[DepartmentID] = [Department].[DepartmentID]

	WHERE [Employee].[JobTitle] = N'Purchasing Manager';
GO

-- ������� �� ����� ������ �����������, � ������� ��������� ������ ���������� ���� �� ���� ���.

SELECT [Employee].[BusinessEntityID],
		[Employee].[JobTitle],
		COUNT([EmployeePayHistory].[Rate]) AS [RateCount]

	FROM [HumanResources].[Employee]
		
	INNER JOIN [HumanResources].[EmployeePayHistory]
		ON [Employee].[BusinessEntityID] = [EmployeePayHistory].[BusinessEntityID]
	
	GROUP BY [Employee].[BusinessEntityID], [Employee].[JobTitle]

	HAVING COUNT([EmployeePayHistory].[Rate]) >= 2;
GO
	
-- ������� �� ����� ������������ ��������� ������ � ������ ������. 
-- ������� ������ ���������� ����������. ���� ��������� ������ �� �������� � ������ � �� ��������� ����� ������.

SELECT [Department].[DepartmentID],
		[Department].[Name],
		MAX([EmployeePayHistory].[Rate]) AS [MaxRate]

	FROM [HumanResources].[EmployeePayHistory]

	INNER JOIN [HumanResources].[Employee]
		ON [Employee].[BusinessEntityID] = [EmployeePayHistory].[BusinessEntityID]

	INNER JOIN [HumanResources].[EmployeeDepartmentHistory]
		ON [Employee].[BusinessEntityID] = [EmployeeDepartmentHistory].[BusinessEntityID]

	INNER JOIN [HumanResources].[Department]
		ON [EmployeeDepartmentHistory].[DepartmentID] = [Department].[DepartmentID]
	
	WHERE [EmployeeDepartmentHistory].[EndDate] IS NULL
	
	GROUP BY [Department].[DepartmentID], [Department].[Name];
GO