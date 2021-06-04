-- 77 Registros 

SELECT Com.Name as Distribuidor
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
	   ,Day(Pur.PurchaseDate) as DiaCompra 
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
  FROM [Purchases].[MsPurchase] Pur 
       INNER JOIN [Purchases].[PsPurchaseDetail] PurDt ON PurDt.PurchaseId = Pur.Id 
       INNER JOIN [Purchases].[MsProvider] Pro On Pro.Id = Pur.ProviderId 
	   INNER JOIN [Base].[MsCompany] Com On Com.Id = Pur.CompanyId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Pur.PaymentStatusIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Pur.ReferenceIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PurDt.UnitIdc 
	   INNER JOIN [Warehouse].[MsProduct] Pr ON Pr.Id = PurDt.ProductId 
	   INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Pr.CompanyId and PLine.Id = Pr.ProductLineId 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Com.CityIdc 
	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Pur.CompanyId and CUnit.ProductId = Pr.Id
	   INNER JOIN [Base].[PsClassifier] C9 ON C9.Id = CUnit.SaleUnitIdc
 WHERE Pur.CompanyId = 3



SELECT Cmp.Name as Distribuidor 
	   ,isnull(
	    (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	      WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') as Proveedor 
       ,Year(Trn.TransactionDate) as AnioGasto 
	   ,case Month(Trn.TransactionDate) 
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
	   end as MesGasto 
	   ,Day(Trn.TransactionDate) as DiaGasto 
       ,Trn.TransactionDate as FechaGasto
	   ,Trn.Detail as Observacion
	   ,C1.Name as EstadoNombre, C2.Name as TipoNombre 
	   ,CR.Name as TipoTransaccion 
	   ,'Sin SubTipo' as SubTipoTransaccion 
	   ,isnull(TrnD.NIT,'S/N') as NumeroNIT 
	   ,TrnD.AuthorizationNumber as AutorizacionNumero
	   ,TrnD.InvoiceNumber as NumeroFactura
	   ,TrnD.ControlCode as CodigoControl
	   ,TrnD.Amount as MontoTotal 
	   ,TrnD.DeductPercentage as PorcentajeDeducible
	   ,Case IsDeductible WHEN 1 THEN TrnD.DeductibleTotal Else TrnD.Amount END as DescuentoTotal 
  FROM [Accounting].[PsTransaction] Trn 
       INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
 WHERE Trn.SubTypeTransactionIdr is null AND Cmp.Id = 3 

UNION ALL 

SELECT Cmp.Name as Distribuidor 
	   ,isnull(
	    (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	      WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') as Proveedor 
       ,Year(Trn.TransactionDate) as AnioGasto 
	   ,case Month(Trn.TransactionDate) 
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
	    end as MesGasto 
 	   ,Day(Trn.TransactionDate) as DiaGasto 
       ,Trn.TransactionDate as FechaGasto 
	   ,Trn.Detail as Observacion
	   ,C1.Name as EstadoNombre, C2.Name as TipoNombre 
	   ,CRv.Name as TipoTransaccion 
	   ,CR.Name as SubTipoTransaccion 
	   ,isnull(TrnD.NIT,'S/N') as NumeroNIT 
	   ,TrnD.AuthorizationNumber as AutorizacionNumero
	   ,TrnD.InvoiceNumber as NumeroFactura
	   ,TrnD.ControlCode as CodigoControl
	   ,TrnD.Amount as MontoTotal 
	   ,TrnD.DeductPercentage as PorcentajeDeducible
	   ,Case IsDeductible WHEN 1 THEN TrnD.DeductibleTotal Else TrnD.Amount END as DescuentoTotal 
  FROM [Accounting].[PsTransaction] Trn 
       INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr and CR.Id = Trn.SubTypeTransactionIdr 
	   INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr  
 WHERE Cmp.Id = 3
