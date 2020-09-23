USE AdventureWorks2012;
GO

-- Вывести значения полей [ProductID], [Name], [ProductNumber] из таблицы [Production].[Product] в виде xml, 
-- сохраненного в переменную. Формат xml должен соответствовать примеру. Создать хранимую процедуру, возвращающую таблицу, 
-- заполненную из xml переменной представленного вида. Вызвать эту процедуру для заполненной на первом шаге переменной.

CREATE PROCEDURE dbo.GetProductsValues(@ProductsValues XML) AS
BEGIN
	SELECT 
		data.value('@ID', 'INT') AS ProductID,
        data.value('Name[1]', 'VARCHAR(30)') AS ProductName,
        data.value('ProductNumber[1]', 'VARCHAR(20)') AS ProductNumber
    FROM @ProductsValues.nodes('/Products/Product') XmlData(data);	
END

DECLARE @xmlFormat XML; 

SET @xmlFormat = (
	SELECT TOP 2
		ProductID AS [@ID],
		Name,
		ProductNumber
	FROM Production.Product
	FOR XML PATH('Product'), ROOT('Products')
);

SELECT @xmlFormat;

EXECUTE dbo.GetProductsValues @xmlFormat;
GO