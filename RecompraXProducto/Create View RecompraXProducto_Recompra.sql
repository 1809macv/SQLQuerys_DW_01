ALTER VIEW [PIVOT].RecompraXProducto_Recompra
AS
SELECT S.CompanyId AS DistribuidorId
	  ,DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1) AS Fecha
	  ,SD.ProductId AS ProductoId
	  ,COUNT(*) AS Cantidad
  FROM [Sales].[MsSale] S
		INNER JOIN [Sales].[PsSaleDetail] SD ON SD.SaleId = S.Id 
 WHERE S.CompanyId >= 3 AND S.StatusIdc <> 104 
GROUP BY S.CompanyId, DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1), SD.ProductId

GO
