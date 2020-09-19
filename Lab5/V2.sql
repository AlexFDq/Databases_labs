USE AdventureWorks2012;
GO

-- Создайте scalar-valued функцию, которая будет принимать в качестве входного параметра id отдела 
-- (HumanResources.Department.DepartmentID) и возвращать количество сотрудников, работающих в отделе.

CREATE FUNCTION HumanResources.GetAmountOfEmployees(@departmentID SMALLINT)
RETURNS SMALLINT AS
BEGIN
	DECLARE @employeesAmount INT 

	SELECT @employeesAmount = COUNT(BusinessEntityID)
	FROM HumanResources.EmployeeDepartmentHistory AS EmlDepHis
	WHERE EmlDepHis.DepartmentID = @departmentID
		AND EmlDepHis.EndDate IS NULL;

	RETURN @employeesAmount;
END
GO

SELECT * FROM HumanResources.EmployeeDepartmentHistory
	ORDER BY DepartmentID;

PRINT(HumanResources.GetAmountOfEmployees(1));
GO

-- Создайте inline table-valued функцию, которая будет принимать в качестве входного параметра id отдела 
-- (HumanResources.Department.DepartmentID), а возвращать сотрудников, которые работают в отделе более 11 лет.

CREATE FUNCTION HumanResources.GetEmployeesList(@departmentID SMALLINT)
RETURNS TABLE AS

RETURN
	SELECT * FROM HumanResources.EmployeeDepartmentHistory AS EmlDepHis
	WHERE EmlDepHis.DepartmentID = @departmentID
		AND DATEDIFF(YEAR, StartDate, GETDATE()) > 11
		AND EmlDepHis.EndDate IS NULL;
GO

SELECT * FROM HumanResources.EmployeeDepartmentHistory AS EmlDepHis
	WHERE EmlDepHis.DepartmentID = 1
		AND DATEDIFF(YEAR, StartDate, GETDATE()) > 11
		AND EmlDepHis.EndDate IS NULL;
GO

SELECT * FROM HumanResources.GetEmployeesList(1);
GO

-- Вызовите функцию для каждого отдела, применив оператор CROSS APPLY. 

SELECT BusinessEntityID,
	ShiftID,
	StartDate,
	Dep.DepartmentID,
	Dep.Name AS DepartmentName,
	Dep.GroupName,
	Dep.ModifiedDate
FROM HumanResources.Department AS Dep
	CROSS APPLY HumanResources.GetEmployeesList(Dep.DepartmentID)
ORDER BY Dep.DepartmentID;
GO

-- Вызовите функцию для каждого отдела, применив оператор OUTER APPLY.

SELECT BusinessEntityID,
	ShiftID,
	StartDate,
	Dep.DepartmentID,
	Dep.Name AS DepartmentName,
	Dep.GroupName,
	Dep.ModifiedDate
FROM HumanResources.Department AS Dep
	OUTER APPLY HumanResources.GetEmployeesList(Dep.DepartmentID)
ORDER BY Dep.DepartmentID;	
GO

-- Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
-- (предварительно сохранив для проверки код создания inline table-valued функции).

CREATE FUNCTION HumanResources.GetEmployeesListMultist(@departmentID SMALLINT)
RETURNS @table TABLE (
	BusinessEntityID INT,
	DepartmentID SMALLINT,
	ShiftID TINYINT,
	StartDate DATE,
	EndDate DATE,
	ModifiedDate DATETIME
) 
AS
BEGIN
	INSERT INTO @table
	SELECT 
		BusinessEntityID,
		DepartmentID,
		ShiftID,
		StartDate,
		EndDate,
		ModifiedDate
	FROM HumanResources.EmployeeDepartmentHistory
	WHERE DepartmentID = @departmentID
		AND DATEDIFF(YEAR, StartDate, GETDATE()) > 11
		AND EndDate IS NULL;

	RETURN
END
GO

SELECT * FROM HumanResources.GetEmployeesListMultist(1);
GO
