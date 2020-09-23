USE AdventureWorks2012;
GO

--a) Создайте таблицу Production.LocationHst, которая будет хранить информацию об изменениях в таблице Production.Location.
-- Обязательные поля, которые должны присутствовать в таблице: ID — первичный ключ IDENTITY(1,1); 
-- Action — совершенное действие (insert, update или delete); ModifiedDate — дата и время, когда была совершена операция; 
-- SourceID — первичный ключ исходной таблицы; UserName — имя пользователя, совершившего операцию. 
-- Создайте другие поля, если считаете их нужными.

CREATE TABLE Production.LocationHst (
	ID INT IDENTITY(1,1) PRIMARY KEY,
	Action NVARCHAR(10),
	ModifiedDate DATETIME,
	SourceID SMALLINT,
	UserName NVARCHAR(20)
);
GO

-- b) Создайте один AFTER триггер для трех операций INSERT, UPDATE, DELETE для таблицы Production.Location. 
-- Триггер должен заполнять таблицу Production.LocationHst с указанием типа операции в поле Action
-- в зависимости от оператора, вызвавшего триггер.

CREATE TRIGGER Production.trgLocation
ON Production.Location
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	IF EXISTS (SELECT * FROM inserted)
		AND EXISTS (SELECT * FROM deleted)
		INSERT INTO Production.LocationHst (
			Action,
			ModifiedDate,
			SourceID,
			UserName
		) SELECT 
			'update',
			CURRENT_TIMESTAMP,
			LocationID,
			CURRENT_USER
		FROM inserted

	ELSE IF EXISTS (SELECT * FROM inserted)
		INSERT INTO Production.LocationHst (
			Action,
			ModifiedDate,
			SourceID,
			UserName
		) SELECT 
			'insert',
			CURRENT_TIMESTAMP,
			LocationID,
			CURRENT_USER
		FROM inserted

	ELSE IF EXISTS (SELECT * FROM deleted)
		INSERT INTO Production.LocationHst (
			Action,
			ModifiedDate,
			SourceID,
			UserName
		) SELECT 
			'delete',
			CURRENT_TIMESTAMP,
			LocationID,
			CURRENT_USER
		FROM deleted;	
END
GO

-- c) Создайте представление VIEW, отображающее все поля таблицы Production.Location.

CREATE VIEW Production.vLocation AS
	SELECT * FROM Production.Location;
GO

-- d) Вставьте новую строку в Production.Location через представление. Обновите вставленную строку. 
-- Удалите вставленную строку. Убедитесь, что все три операции отображены в Production.LocationHst.

SET IDENTITY_INSERT Production.Location ON;
GO

INSERT INTO Production.vLocation (
	LocationID,
	Name,
	CostRate,
	Availability,
	ModifiedDate
) VALUES (
	100,
	'SomeName',
	10.00,
	100.00,
	GETDATE()
);
GO

UPDATE Production.vLocation
	SET Name = 'OtherName'
	WHERE LocationID = 100;
GO

DELETE FROM Production.vLocation
	WHERE LocationID = 100;
GO

SELECT * FROM Production.LocationHst;
GO

