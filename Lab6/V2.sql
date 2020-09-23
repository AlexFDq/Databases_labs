USE AdventureWorks2012;
GO

-- Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
-- отображающую данные о максимальном весе (Production.Product.Weight) продукта в каждой подкатегории 
-- (Production.ProductSubcategory) для определенного цвета. Список цветов передайте в процедуру через входной параметр.
-- Таким образом, вызов процедуры будет выглядеть следующим образом:
-- EXECUTE dbo.SubCategoriesByColor ‘[Black],[Silver],[Yellow]’

CREATE PROCEDURE dbo.GetMaxWeightByColor (@colors NVARCHAR(MAX)) AS
BEGIN
	EXECUTE('
		SELECT Name, ' + @colors + ' FROM (
			SELECT
				PrSub.Name,
				Pr.Weight,
				Pr.Color
			FROM Production.Product AS Pr
		
			INNER JOIN Production.ProductSubcategory AS PrSub
				ON PrSub.ProductSubcategoryID = Pr.ProductSubcategoryID

		) AS p
		PIVOT (
			MAX(Weight) FOR Color IN (' + @colors + ')
		) AS pvt
	');
END
GO

EXECUTE dbo.GetMaxWeightByColor @colors = '[Black],[Silver],[Yellow]';
GO