-- �������� ���� ������
CREATE DATABASE [Alexander_Dubrovinsky];
GO

-- ������������� ��������� �� � �������� �������
USE [Alexander_Dubrovinsky];
GO

-- �������� � ������� �� ���� sales � persons
CREATE SCHEMA [sales];
GO

CREATE SCHEMA [persons];
GO

-- �������� ������� Orders � ����� sales � ����� OrderNum ���� Int 
CREATE TABLE [sales].[Orders] ([OrderNum] INT NULL);
GO

-- �������� ��������� ����� ���� ���� ������ �� �����
BACKUP DATABASE [Alexander_Dubrovinsky]
	TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\Alexander_Dubrovinsky.bak';
GO

-- �������� ���� ������
DROP DATABASE [Alexander_Dubrovinsky];
GO

-- �������������� ���� ������ �� ���������
RESTORE DATABASE [Alexander_Dubrovinsky]
	FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\Alexander_Dubrovinsky.bak';
GO