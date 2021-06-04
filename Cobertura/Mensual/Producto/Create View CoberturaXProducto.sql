/****** Object:  View [PIVOT].[CoberturaXProducto_Mensual]    Script Date: 10/15/2019 10:24:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [PIVOT].[CoberturaXProducto_Mensual]
AS
SELECT DISTINCT Sale.CompanyId AS IdDistribuidor
	  ,Cmp.Name AS Distribuidor 
	  ,C8.Name AS Ciudad 
	  ,Year(Sale.SaleDate) as AnioVenta
	  ,Month(Sale.SaleDate) as MesVenta
	  ,CR1.Name AS TipoNegocio 
	  ,C6.Name AS TipoCliente 
	  ,C7.Name AS CategoriaCliente 
	  ,Zne.Name AS Zona 
	  ,Sale.CustomerId 
	  ,Customer.Name AS ClienteNombre 
	  ,C4.Name AS Negocio 
	  ,C5.Name AS Reclasificacion 
	  ,C2.Name AS Segmento 
	  ,C3.Name AS SubRubro 
	  ,Product.Code AS ProductoCodigo 
	  ,Product.Name AS ProductoNombre 
  FROM [Sales].MsSale Sale 
	INNER JOIN [Sales].[PsSaleDetail] SDetail ON SDetail.SaleId = Sale.Id 
	INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	INNER JOIN [Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
	INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
	INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 

	INNER JOIN [Warehouse].[MsProduct] Product ON Product.Id = SDetail.ProductId 
	INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Product.CompanyId and PLine.Id = Product.ProductLineId 
	INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.SegmentIdc 
	INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.SubcategoryIdc 
 WHERE Sale.StatusIdc <> 104 and Sale.CompanyId >= 3 
GO


