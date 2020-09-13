-- ����������� ������� ��
USE [AdventureWorks2012];
GO

-- ������� �� ����� ������ �������, ��������������� �� �������� ������ � ������� Z-A. 
-- ������� �� ����� ������ 5 �����, ������� � 3-�� ������.
SELECT [DepartmentID], 
		[Name]
	FROM [HumanResources].[Department]
	ORDER BY [Name] DESC
	OFFSET 2 ROWS                   -- ���������� ������ 2 ������
	FETCH NEXT 5 ROWS ONLY;			-- ������� ������ 5 �����							
GO

-- ������� �� ����� ������ ��������������� �������, 
-- ������� ������������� ������� ������ ������� � ����������� (OrganizationLevel).
SELECT DISTINCT [JobTitle] 
	FROM [HumanResources].[Employee]
	WHERE [OrganizationLevel] = 1;
GO

-- ������� �� ����� �����������, ������� ����������� 18 ��� � ��� ���, ����� �� ������� �� ������.
SELECT [BusinessEntityID], 
		[JobTitle], 
		[Gender], 
		[BirthDate], 
		[HireDate]
	FROM [HumanResources].[Employee]
	WHERE YEAR([HireDate]) - YEAR([BirthDate]) = 18;
GO