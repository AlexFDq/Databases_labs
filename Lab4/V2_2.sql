USE AdventureWorks2012;
GO

-- a) Создайте представление VIEW, отображающее данные из таблиц Production.Location и 
-- Production.ProductInventory, а также Name из таблицы Production.Product. 
-- Сделайте невозможным просмотр исходного кода представления. 
-- Создайте уникальный кластерный индекс в представлении по полям LocationID, ProductID.

DROP VIEW IF EXISTS Production.vProductInfo;
GO

CREATE VIEW Production.vProductInfo 
WITH SCHEMABINDING, ENCRYPTION AS 
SELECT 
	PrInv.ProductID,
	PrInv.LocationID,
	PrInv.Shelf,
	PrInv.Bin,
	PrInv.Quantity,
	PrInv.rowguid,
	PrInv.ModifiedDate AS ProductInventoryDate,
	Loc.Name AS LocationName,
	Loc.CostRate,
	Loc.Availability,
	Loc.ModifiedDate AS LocationDate,
	Pr.Name AS ProductName

	FROM Production.ProductInventory AS PrInv

	INNER JOIN Production.Location AS Loc
		ON PrInv.LocationID = Loc.LocationID
			
	INNER JOIN Production.Product AS Pr
		ON PrInv.ProductID = Pr.ProductID;
GO

CREATE UNIQUE CLUSTERED INDEX ProductInfo_index
	ON Production.vProductInfo(LocationID, ProductID); 
GO

-- b) Создайте три INSTEAD OF триггера для представления на операции INSERT, UPDATE, DELETE. 
-- Каждый триггер должен выполнять соответствующие операции в таблицах Production.Location и Production.ProductInventory 
-- для указанного Product Name. Обновление и удаление строк производите только в таблицах Production.Location 
-- и Production.ProductInventory, но не в Production.Product.

DROP TRIGGER IF EXISTS Production.instead_of_insert_trigger;
GO

CREATE TRIGGER Production.instead_of_insert_trigger
ON Production.vProductInfo
INSTEAD OF INSERT AS 
BEGIN
	INSERT INTO Production.Location (
		Name,
		CostRate,
		Availability,
		ModifiedDate
	) SELECT 
		ins.LocationName,
		ins.CostRate,
		ins.Availability,
		ins.LocationDate
	FROM inserted AS ins
	INNER JOIN Production.Product AS Pr
		ON ins.ProductName = Pr.Name;
		
	INSERT INTO Production.ProductInventory (
		ProductID,
		LocationID,
		Shelf,
		Bin,
		Quantity,
		rowguid,
		ModifiedDate
	) SELECT
		Pr.ProductID,
		Loc.LocationID,
		ins.Shelf,
		ins.Bin,
		ins.Quantity,
		ins.rowguid,
		ins.ProductInventoryDate
	FROM inserted AS ins
	
	INNER JOIN Production.Product AS Pr
		ON ins.ProductName = Pr.Name

	INNER JOIN Production.Location AS Loc
		ON ins.LocationName = Loc.Name;
END
GO

DROP TRIGGER IF EXISTS Production.instead_of_update_trigger;
GO

CREATE TRIGGER Production.instead_of_update_trigger
ON Production.vProductInfo
INSTEAD OF UPDATE AS 
BEGIN
	UPDATE Production.Location SET
		Name = ins.LocationName,
		CostRate = ins.CostRate,
		Availability = ins.Availability,
		ModifiedDate = ins.LocationDate
	FROM Location AS Loc
	INNER JOIN inserted AS ins
		ON ins.LocationID = Loc.LocationID;
		
	UPDATE Production.ProductInventory SET
		Shelf = ins.Shelf,
		Bin = ins.Bin,
		Quantity = ins.Quantity,
		rowguid = ins.rowguid,
		ModifiedDate = ins.ProductInventoryDate
	FROM ProductInventory AS PrInv
	INNER JOIN inserted AS ins
		ON ins.ProductID = PrInv.ProductID;
END
GO

DROP TRIGGER IF EXISTS Production.instead_of_delete_trigger;
GO

CREATE TRIGGER Production.instead_of_delete_trigger
ON Production.vProductInfo
INSTEAD OF DELETE AS 
BEGIN
	DECLARE @prodID INT;

	SET @prodID = (SELECT ProductID FROM deleted);
	CREATE TABLE #locations (
		LocationID SMALLINT NOT NULL
	);

	INSERT INTO #locations 
	SELECT DISTINCT PrInv.LocationID 
	FROM Production.ProductInventory AS PrInv

	INNER JOIN deleted
		ON deleted.ProductID = PrInv.ProductID

	WHERE PrInv.LocationID NOT IN (
		SELECT DISTINCT ppi.LocationID 
		FROM Production.ProductInventory as ppi 
		WHERE ppi.ProductID != @prodID
	); 

	DELETE PrInv
	FROM Production.ProductInventory AS PrInv
		WHERE PrInv.ProductID = @prodID;

	DELETE Loc 
	FROM Production.Location AS Loc
		WHERE LocationID IN (SELECT * FROM #locations);
END
GO

-- c) Вставьте новую строку в представление, указав новые данные для Location и ProductInventory, 
-- но для существующего Product (например для ‘Adjustable Race’). Триггер должен добавить новые строки 
-- в таблицы Production.Location и Production.ProductInventory для указанного Product Name. 
-- Обновите вставленные строки через представление. Удалите строки.

-- Вставка

INSERT INTO Production.vProductInfo 
(
	Shelf,
	Bin,
	Quantity,
	rowguid,
	LocationDate,
	ProductInventoryDate,
	LocationName,
	CostRate,
	Availability,
	ProductName
) VALUES (
	'A',
	3,
	200,
	'99944D7D-CAF5-46B3-AB22-5718DCC26B5E',
	GETDATE(),
	GETDATE(),
	'Window',
	'10000',
	1000.00,
	'Adjustable Race'
);
GO

SELECT * FROM Production.Location;
GO

SELECT * FROM Production.ProductInventory;
GO

-- Обновление

UPDATE Production.vProductInfo 
	SET CostRate = '555',
		LocationName = 'NewLocation'
	
	WHERE ProductName = 'Adjustable Race';
GO

SELECT * FROM Production.Location AS Loc
	INNER JOIN Production.ProductInventory AS PrInv
		ON Loc.LocationID = PrInv.LocationID
	WHERE CostRate = '555';
GO

-- Удаление

DELETE FROM Production.vProductInfo 
	WHERE ProductName = 'Adjustable Race';
GO

SELECT * FROM Production.Location L
	INNER JOIN Production.ProductInventory I
		ON L.LocationID = I.LocationID
	INNER JOIN Production.Product P
		ON P.ProductID = I.ProductID
	WHERE P.Name = 'Adjustable Race';
GO
