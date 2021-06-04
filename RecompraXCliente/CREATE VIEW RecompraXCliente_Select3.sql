ALTER VIEW [PIVOT].RecompraXCliente_Select3
AS
SELECT sa.CompanyId AS DistribuidorId
	  ,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) AS Fecha
	  ,count(DISTINCT sa.CustomerId) AS ClientesTotal
  FROM MSFSystemVacio.[Sales].[MsSale] sa
 WHERE sa.CompanyId >= 3 AND sa.StatusIdc <> 104 
GROUP BY sa.CompanyId, DATEFROMPARTS(YEAR(sa.SaleDate),MONTH(sa.SaleDate),1)

GO
