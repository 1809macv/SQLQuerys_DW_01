ALTER VIEW [PIVOT].RecompraXCliente_Select2
AS
SELECT S.CompanyId AS DistribuidorId
	  ,DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1) AS Fecha
	  ,S.CustomerId AS ClienteId
	  ,COUNT(*) AS Cantidad
  FROM [Sales].[MsSale] S
 WHERE S.CompanyId >= 3 AND S.StatusIdc <> 104 
GROUP BY S.CompanyId, DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1), S.CustomerId

GO
