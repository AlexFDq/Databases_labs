-- Обозначение рабочей БД
USE [AdventureWorks2012];
GO

-- Вывести на экран историю сотрудника, который работает на позиции ‘Purchasing Manager’. 
-- В каких отделах компании он работал, с указанием периодов работы в каждом отделе.

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

-- Вывести на экран список сотрудников, у которых почасовая ставка изменялась хотя бы один раз.

SELECT [Employee].[BusinessEntityID],
		[Employee].[JobTitle],
		COUNT([EmployeePayHistory].[Rate]) AS [RateCount]

	FROM [HumanResources].[Employee]
		
	INNER JOIN [HumanResources].[EmployeePayHistory]
		ON [Employee].[BusinessEntityID] = [EmployeePayHistory].[BusinessEntityID]
	
	GROUP BY [Employee].[BusinessEntityID], [Employee].[JobTitle]

	HAVING COUNT([EmployeePayHistory].[Rate]) >= 2;
GO
	
-- Вывести на экран максимальную почасовую ставку в каждом отделе. 
-- Вывести только актуальную информацию. Если сотрудник больше не работает в отделе — не учитывать такие данные.

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