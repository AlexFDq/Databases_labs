-- Создание базы данных
CREATE DATABASE [Alexander_Dubrovinsky];
GO

-- Использование созданной БД в качестве рабочей
USE [Alexander_Dubrovinsky];
GO

-- Создание в текущей БД схем sales и persons
CREATE SCHEMA [sales];
GO

CREATE SCHEMA [persons];
GO

-- Создание таблицы Orders в схеме sales с полем OrderNum типа Int 
CREATE TABLE [sales].[Orders] ([OrderNum] INT NULL);
GO

-- Создание резервной копии всей базы данных на диске
BACKUP DATABASE [Alexander_Dubrovinsky]
	TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\Alexander_Dubrovinsky.bak';
GO

-- Удаление базы данных
DROP DATABASE [Alexander_Dubrovinsky];
GO

-- Восстановление базы данных из резервной
RESTORE DATABASE [Alexander_Dubrovinsky]
	FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\Backup\Alexander_Dubrovinsky.bak';
GO