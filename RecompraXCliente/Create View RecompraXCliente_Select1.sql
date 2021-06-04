CREATE VIEW [PIVOT].RecompraXCliente_Select1
AS
SELECT DISTINCT Sale.CompanyId AS DistribuidorId 
	  ,Cmp.Name AS Distribuidor 
	  ,C8.Name AS Ciudad 
	  ,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) AS FechaPeriodo
	  ,CR1.Name AS TipoNegocio 
	  ,C6.Name AS TipoCliente 
	  ,C7.Name AS CategoriaCliente 
	  ,Sale.CustomerId AS  ClienteId
	  ,Customer.Name AS ClienteNombre 
  FROM Sales.[MsSale] Sale 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
		INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
		INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
		INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 
 WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3
