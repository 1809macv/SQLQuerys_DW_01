TRUNCATE TABLE [PIVOT].[Compras]
GO

INSERT [PIVOT].[Compras]
SELECT Pur.CompanyId as IdDistribuidor
	   ,Com.Name as Distribuidor
       ,C8.Name as Ciudad 
       ,Pro.Name as Proveedor
	   ,Year(Pur.PurchaseDate) as AnioCompra
	   ,case Month(Pur.PurchaseDate) 
	        when 1 then '01. Enero'
	        when 2 then '02. Febrero'
	        when 3 then '03. Marzo'
	        when 4 then '04. Abril'
	        when 5 then '05. Mayo'
	        when 6 then '06. Junio'
	        when 7 then '07. Julio'
	        when 8 then '08. Agosto'
	        when 9 then '09. Septiembre'
	        when 10 then '10. Octubre'
	        when 11 then '11. Noviembre'
	        when 12 then '12. Diciembre'
	    end as MesCompra 
	   ,Pur.PurchaseDate as FechaCompra
	   ,Pur.InvoiceNumber as NumeroFactura
	   ,Pur.InvoiceDate as FechaFactura
	   ,Pur.AuthorizationNumber as NumeroAutorizacion
       ,Pur.ControlCode as CodigoControl
       ,C1.Name as EstadoPago 
	   ,C2.Name as Referencia 
	   ,Pur.Debt as MontoDebito 
	   ,Pur.CreditDay as DiasCredito
	   ,C4.Name as Negocio 
	   ,C5.Name as Reclasificacion 
	   ,C6.Name as Segmento 
	   ,C7.Name as SubRubro 
	   ,Pr.Code as ProductoCodigo 
	   ,Pr.Name as Producto 
	   ,C3.Name as UnidadMedidaAlmacen 
	   ,CUnit.Equivalence as FactorConversion
	   ,PurDt.Quantity as CantidadProducto
	   ,C9.Name as UnidadMedidaMenor
	   ,(PurDt.Quantity * CUnit.Equivalence) as CantidadProductoUnidadMenor
	   ,PurDt.Cost as CostoUnitario 
	   ,(PurDt.Quantity * PurDt.Cost) as MontoTotalProducto 
	   ,PurDt.Discount as TotalDescuento
	   ,PurDt.Total as MontoTotal 
	   ,EstadoDocumento 
  FROM MSFSystemVacio.[Purchases].[MsPurchase] Pur 
       INNER JOIN MSFSystemVacio.[Purchases].[PsPurchaseDetail] PurDt ON PurDt.PurchaseId = Pur.Id 
       INNER JOIN MSFSystemVacio.[Purchases].[MsProvider] Pro On Pro.Id = Pur.ProviderId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Com On Com.Id = Pur.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Pur.PaymentStatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Pur.ReferenceIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PurDt.UnitIdc 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Pr ON Pr.Id = PurDt.ProductId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Pr.CompanyId and PLine.Id = Pr.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Com.CityIdc 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Pr.CompanyId and CUnit.ProductId = Pr.Id
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C9 ON C9.Id = CUnit.SaleUnitIdc
 WHERE Pur.CompanyId >= 3
GO
