ALTER VIEW [PIVOT].RecompraXProducto_TotalVenta
AS
SELECT sa.CompanyId AS DistribuidorId
	  ,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) AS Fecha
	  ,COUNT(DISTINCT SDt.ProductId) AS VentaTotal
  FROM [Sales].[MsSale] sa
		INNER JOIN [Sales].[PsSaleDetail] SDt ON SDt.SaleId = sa.Id
 WHERE sa.CompanyId >= 3 AND sa.StatusIdc <> 104 
GROUP BY sa.CompanyId, DATEFROMPARTS(YEAR(sa.SaleDate),MONTH(sa.SaleDate),1)

GO
