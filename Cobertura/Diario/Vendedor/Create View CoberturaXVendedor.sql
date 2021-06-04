ALTER VIEW [PIVOT].[CoberturaXVendedor_Diario]
AS
SELECT DISTINCT Sale.CompanyId AS IdDistribuidor
	,Cmp.Name AS Distribuidor 
	,C8.Name AS Ciudad 
	--,datepart(YEAR, Sale.SaleDate) AS AnioVenta 
	--,Month(Sale.SaleDate) AS MesNumero
	,convert(date, Sale.SaleDate) AS FechaVenta 
	,CR1.Name AS TipoNegocio 
	,C6.Name AS TipoCliente 
	,C7.Name AS CategoriaCliente 
	,Zne.Name AS Zona 
	,Sale.SellerId AS VendedorId
	,Usr.Name AS Vendedor 
	,Sale.CustomerId 
	,Customer.Name AS ClienteNombre 
  FROM [Sales].MsSale Sale 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
		INNER JOIN [Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
		INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
		INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
		INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 
  		INNER JOIN [Security].[MsUser] Usr ON Usr.Id = Sale.SellerId AND Usr.CompanyId = Sale.CompanyId 
 WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3
