/****** Object:  View [PIVOT].[Compras]    Script Date: 4/28/2021 3:58:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [PIVOT].[Compras]
AS
SELECT Pur.CompanyId AS IdDistribuidor 
		,Com.Name AS Distribuidor 
		,C8.Name AS Ciudad 
		,Pro.Name AS Proveedor 
		,CONVERT(DATE, Pur.PurchaseDate) AS FechaCompra 
		,Pur.InvoiceNumber AS NumeroFactura 
		,CONVERT(DATE,Pur.InvoiceDate) AS FechaFactura 
		,Pur.AuthorizationNumber AS NumeroAutorizacion 
		,Pur.ControlCode AS CodigoControl 
		,C1.Name AS EstadoPago 
		,C2.Name AS Referencia 
		,Pur.Debt AS MontoDebito 
		,Pur.CreditDay AS DiasCredito 
		,C4.Name AS Negocio 
		,C5.Name AS Reclasificacion 
		,C6.Name AS Segmento 
		,C7.Name AS SubRubro 
		,Pr.Code AS ProductoCodigo 
		,Pr.Name AS ProductoNombre 
		,C3.Name AS UnidadMedidaAlmacen 
		,CUnit.Equivalence AS FactorConversion 
		,PurDt.Quantity AS CantidadProducto 
		,C9.Name AS UnidadMedidaMenor 
		,(PurDt.Quantity * CUnit.Equivalence) AS CantidadProductoUnidadMenor 
		,PurDt.Cost AS CostoUnitario 
		,(PurDt.Quantity * PurDt.Cost) AS MontoTotalProducto 
		,PurDt.Discount AS TotalDescuento 
		,PurDt.Total AS MontoTotal 
		,C10.[Name] as EstadoDocumento 
		,Lote.BachNumber as NumeroLote 
		,Lote.ExpirationDate as FechaExpiracion 
  FROM [Purchases].[MsPurchase] Pur 
		INNER JOIN [Purchases].[PsPurchaseDetail] PurDt ON PurDt.PurchaseId = Pur.Id 
		INNER JOIN [Purchases].[MsProvider] Pro On Pro.Id = Pur.ProviderId 
		INNER JOIN [Base].[MsCompany] Com On Com.Id = Pur.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Pur.PaymentStatusIdc and C1.ClassifierTypeId = 23 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Pur.ReferenceIdc 
		INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PurDt.UnitIdc 
		INNER JOIN [Warehouse].[MsProduct] Pr ON Pr.Id = PurDt.ProductId 
		INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Pr.CompanyId AND PLine.Id = Pr.ProductLineId 
		INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
		INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
		INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
		INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
		INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Com.CityIdc 
		INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Pur.CompanyId AND CUnit.ProductId = Pr.Id 
		INNER JOIN [Base].[PsClassifier] C9 ON C9.Id = CUnit.SaleUnitIdc 
		INNER JOIN [Base].[PsClassifier] C10 ON C10.Id = Pur.StatusIdc AND C10.ClassifierTypeId = 22 
		INNER JOIN [Warehouse].[MsStoreTransaction] Trans ON Trans.Id = Pur.StoreTransactionId 
		INNER JOIN [Warehouse].[PsStoreTransactionDetail] TDetalle ON TDetalle.StoreTransactionId = Trans.Id 
		INNER JOIN [Warehouse].[PsBatch] Lote ON Lote.Id = TDetalle.BatchId 
 WHERE Pur.CompanyId  >= 3 AND Pur.StatusIdc <> 51 
	   AND PurDt.ProductId = TDetalle.ProductId 

GO


