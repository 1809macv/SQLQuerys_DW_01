/****** Object:  View [PIVOT].[CoberturaXCliente]    Script Date: 10/4/2019 12:03:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [PIVOT].[CoberturaXCliente_Diario]
AS
SELECT DISTINCT Sale.[CompanyId] as IdDistribuidor
	  ,Cmp.[Name] as Distribuidor 
	  ,C8.[Name] as Ciudad 
	  ,convert(date, Sale.[SaleDate]) as FechaVenta 
	  ,CR1.[Name] as TipoNegocio 
	  ,C6.[Name] as TipoCliente 
	  ,C7.[Name] as CategoriaCliente 
	  ,Zne.[Name] as Zona 
	  ,Sale.[CustomerId] 
	  ,Customer.[Code] as ClienteCodigo 
	  ,Customer.[Name] as ClienteNombre 
 FROM [Sales].MsSale Sale 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.[Id] = Sale.[CompanyId] 
		INNER JOIN [Sales].[MsCustomer] Customer ON Customer.[Id] = Sale.[CustomerId] 
		INNER JOIN [Zoning].[PsZone] Zne ON Zne.[Id] = Customer.[ZoneId] 
		INNER JOIN [Base].[PsClassifier] C6 ON C6.[Id] = Customer.[CustomerTypeIdc] 
		INNER JOIN [Base].[PsClassifier] C7 ON C7.[Id] = Customer.[CategoryIdC] 
		INNER JOIN [Base].[PsClassifier] C8 ON C8.[Id] = Cmp.[CityIdc] 
		INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.[Id] = Customer.[BussinessTypeIdr] 
 WHERE Sale.StatusIdc <> 104 and Sale.CompanyId >= 3
GO


