USE [MSFSystem_Cube]
GO

--TRUNCATE TABLE [PIVOT].[VentasXFecha]
--GO


WITH Ventas (DistribuidorID, Distribuidor, Ciudad, AnioVenta, MesVenta, FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo, ClienteCodigo,   ---DiaVenta, 
             RazonSocial, NombreContacto, 
             ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado, Vendedor, Almacen, Negocio, 
			 Reclasificacion, Segmento, SubRubro, ProductoCodigo, ProductoNombre, Bonificacion, NumeroLote, UnidadMedidaVenta, FactorConversion, 
			 ListaPrecio, CantDISP_UN, CantBU, PrecioProducto, TotalProducto, DescuentoProducto, DescuentoDocumento, UsuarioTransaccion, 
			 PesoNeto, PesoBruto, TotalKilosNetos, TotalKilosBrutos, CostoPrecioPromedio, TotalCostoPromedio, NumeroGuia, EstadoGuia, RepartidorNombre)
AS (
SELECT Cmp.Id as DistribuidorID 
       ,Cmp.[Name] AS Distribuidor 
       ,C8.[Name] AS Ciudad 
       ,Year(Sale.SaleDate) AS AnioVenta 
	   ,CASE Month(Sale.SaleDate) 
	        WHEN 1 THEN '01. Enero'
	        WHEN 2 THEN '02. Febrero'
	        WHEN 3 THEN '03. Marzo'
	        WHEN 4 THEN '04. Abril'
	        WHEN 5 THEN '05. Mayo'
	        WHEN 6 THEN '06. Junio'
	        WHEN 7 THEN '07. Julio'
	        WHEN 8 THEN '08. Agosto'
	        WHEN 9 THEN '09. Septiembre'
	        WHEN 10 THEN '10. Octubre'
	        WHEN 11 THEN '11. Noviembre'
	        WHEN 12 THEN '12. Diciembre'
	    END AS MesVenta 
	   --,Day(Sale.SaleDate) AS DiaVenta  
       ,Convert(date,Sale.SaleDate) AS FechaVenta
	   ,Zne.[Name] AS Zona 
	   ,C9.[Name] AS ClienteTipo 
	   ,C10.[Name] AS Categoria 
	   ,CRecursive.[Name] AS TipoRecursivo 
	   ,Customer.Code AS ClienteCodigo 
       ,Sale.CustomerName AS RazonSocial 
	   ,Cmp.Contact as NombreContacto
	   ,Customer.[Name] AS ClienteNombre
	   ,Sale.Nit AS NumeroNIT
	   ,Sale.Number AS NumeroFactura 
	   ,Sale.AuthorizationNumber AS AutorizacionNumero
	   ,Sale.ControlCode AS CodigoControl
	   ,C1.[Name] AS TipoPago 
	   ,C2.[Name] AS DocumentoEstado 
	   ,Usr.[Name] AS Vendedor 
	   ,Store.[Name] AS Almacen 
	   ,C4.[Name] AS Negocio 
	   ,C5.[Name] AS Reclasificacion 
	   ,C6.[Name] AS Segmento 
	   ,C7.[Name] AS SubRubro 
	   ,Prd.Code AS ProductoCodigo 
	   ,Prd.[Name] AS ProductoNombre 
	   ,CASE SaleD.Bonus 
	       WHEN 0 THEN 'No'
		   WHEN 1 THEN 'Si'
		END AS Bonificacion 
	   ,Batch.BachNumber AS NumeroLote
	   ,C3.[Name] AS UnidadMedidaVenta 
	   ,CUnit.Equivalence AS FactorConversion 
	   ,PLst.[Name] AS ListaPrecio 
	   ,SaleD.Quantity AS CantDISP_UN
	   ,(SaleD.Quantity / CUnit.Equivalence) AS CantBU
	   ,SaleD.Price AS PrecioProducto
	   ,SaleD.Total AS TotalProducto
	   ,CASE SaleD.DiscountTypeIdc 
	         WHEN 33 THEN Round( ( (SaleD.Total * SaleD.Discount * 100) / 10000 ) ,2)
	         WHEN 34 THEN SaleD.Discount
			 ELSE 0.00 
	    END AS DescuentoProducto 
	   ,CASE Sale.DiscountTypeIdc 
	         WHEN 33 THEN ( Sale.Discount / 100 )
	         WHEN 34 THEN Round( ( Sale.Discount / Sale.Total ), 6)
			 ELSE 0.00 
	    END AS DescuentoDocumento 
	   ,Usr1.[Name] AS UsuarioTransaccion 
	   ,Prd.[Weight] AS PesoNeto 
	   ,Prd.TotalWeight AS PesoBruto 
	   ,(Prd.[Weight] * SaleD.Quantity/CUnit.Equivalence) AS TotalKilosNetos 
	   ,(Prd.TotalWeight * SaleD.Quantity/CUnit.Equivalence) AS TotalKilosBrutos 
	   ,( STd.PPP / CUnit.Equivalence ) AS CostoPrecioPromedio 
	   ,( SaleD.Quantity * ( STd.PPP / CUnit.Equivalence ) ) as TotalCostoPromedio 
	   ,Opc.Number AS NumeroGuia 
	   ,C11.[Name] AS EstadoGuia 
	   ,Seller.[Name] AS RepartidorNombre
  FROM MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SaleD ON SaleD.SaleId = Sale.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Prd ON Prd.Id = SaleD.ProductId 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Sale.PaymentTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Sale.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = SaleD.UnitIdc 
	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Usr1 ON Usr1.Id = Sale.UserId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = Sale.StoreId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = SaleD.BatchId 
	   INNER JOIN MSFSystemVacio.[Sales].[PsPriceList] Plst ON Plst.Id = SaleD.PriceListId 

	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 

	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C9 ON C9.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C10 ON C10.Id = Customer.CategoryIdC 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsOpcOrderSale] OpcSale ON OpcSale.SaleId = Sale.Id
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsOpc] Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C11 ON C11.Id = Opc.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Seller ON Seller.Id = Opc.SellerId

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] STd ON STd.StoreTransactionId = Sale.StoreTransactionId and STd.ProductId = SaleD.ProductId 
	                                                            and STd.BatchId = SaleD.BatchId 
  
 UNION ALL 
 
 SELECT Cmp.Id as DistribuidorID 
       ,Cmp.[Name] AS Distribuidor 
       ,C8.[Name] AS Ciudad 
       ,Year(Sale.SaleDate) AS AnioVenta 
	   ,CASE Month(Sale.SaleDate) 
	        WHEN 1 THEN '01. Enero'
	        WHEN 2 THEN '02. Febrero'
	        WHEN 3 THEN '03. Marzo'
	        WHEN 4 THEN '04. Abril'
	        WHEN 5 THEN '05. Mayo'
	        WHEN 6 THEN '06. Junio'
	        WHEN 7 THEN '07. Julio'
	        WHEN 8 THEN '08. Agosto'
	        WHEN 9 THEN '09. Septiembre'
	        WHEN 10 THEN '10. Octubre'
	        WHEN 11 THEN '11. Noviembre'
	        WHEN 12 THEN '12. Diciembre'
	    END AS MesVenta 
	   --,Day(Sale.SaleDate) AS DiaVenta  
       ,Convert(date,Sale.SaleDate) AS FechaVenta
	   ,Zne.[Name] AS Zona 
	   ,C9.[Name] AS ClienteTipo 
	   ,C10.[Name] AS Categoria 
	   ,CRecursive.[Name] AS TipoRecursivo 
	   ,Customer.Code AS ClienteCodigo 
       ,Sale.CustomerName AS RazonSocial
	   ,Cmp.Contact as NombreContacto
	   ,Customer.[Name] AS ClienteNombre
	   ,Sale.Nit AS NumeroNIT
	   ,Sale.Number AS NumeroFactura 
	   ,Sale.AuthorizationNumber AS AutorizacionNumero
	   ,Sale.ControlCode AS CodigoControl
	   ,C1.[Name] AS TipoPago 
	   ,C2.[Name] AS DocumentoEstado 
	   ,Usr.[Name] AS Vendedor 
	   ,Store.[Name] AS Almacen 
	   ,C4.[Name] AS Negocio 
	   ,C5.[Name] AS Reclasificacion 
	   ,C6.[Name] AS Segmento 
	   ,C7.[Name] AS SubRubro 
	   ,Prd.Code AS ProductoCodigo 
	   ,Prd.[Name] AS ProductoNombre 
	   ,CASE SaleD.Bonus 
	       WHEN 0 THEN 'No'
		   WHEN 1 THEN 'Si'
		END AS Bonificacion 
	   ,Batch.BachNumber AS NumeroLote
	   ,C3.[Name] AS UnidadMedidaVenta 
	   ,CUnit.Equivalence AS FactorConversion 
	   ,PLst.[Name] AS ListaPrecio 
	   ,SaleD.Quantity AS CantDISP_UN
	   ,(SaleD.Quantity / CUnit.Equivalence) AS CantBU
	   ,SaleD.Price AS PrecioProducto
	   ,SaleD.Total AS TotalProducto
	   ,CASE SaleD.DiscountTypeIdc 
	         WHEN 33 THEN Round( ( (SaleD.Total * SaleD.Discount * 100) / 10000 ) ,2)
	         WHEN 34 THEN SaleD.Discount
			 ELSE 0.00 
	    END AS DescuentoProducto 
	   ,CASE Sale.DiscountTypeIdc 
	         WHEN 33 THEN ( Sale.Discount / 100 )
	         WHEN 34 THEN Round( ( Sale.Discount / Sale.Total ), 6)
			 ELSE 0.00 
	    END AS DescuentoDocumento 
	   ,Usr1.[Name] AS UsuarioTransaccion 
	   ,Prd.[Weight] AS PesoNeto 
	   ,Prd.TotalWeight AS PesoBruto 
	   ,(Prd.[Weight] * SaleD.Quantity/CUnit.Equivalence) AS TotalKilosNetos 
	   ,(Prd.TotalWeight * SaleD.Quantity/CUnit.Equivalence) AS TotalKilosBrutos 
	   ,( STd.PPP / CUnit.Equivalence ) AS CostoPrecioPromedio 
	   ,( SaleD.Quantity * ( STd.PPP / CUnit.Equivalence ) ) as TotalCostoPromedio 
	   ,0 AS NumeroGuia 
	   ,'No Definido' AS EstadoGuia 
	   --,'VENTA DIRECTA' AS RepartidorNombre 
	   ,Usr.[Name] AS RepartidorNombre 
  FROM MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SaleD ON SaleD.SaleId = Sale.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Prd ON Prd.Id = SaleD.ProductId 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Sale.PaymentTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Sale.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = SaleD.UnitIdc 
	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Usr1 ON Usr1.Id = Sale.UserId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = Sale.StoreId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = SaleD.BatchId 
	   INNER JOIN MSFSystemVacio.[Sales].[PsPriceList] Plst ON Plst.Id = SaleD.PriceListId 

	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 

	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C9 ON C9.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C10 ON C10.Id = Customer.CategoryIdC 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 
 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] STd ON STd.StoreTransactionId = Sale.StoreTransactionId and STd.ProductId = SaleD.ProductId 
	                                                            and STd.BatchId = SaleD.BatchId 
WHERE Not Exists (SELECT * FROM MSFSystemVacio.[Warehouse].[PsOpcOrderSale] OpcSale 
	                WHERE OpcSale.SaleId = Sale.Id )
  )
INSERT INTO [PIVOT].[VentasXFecha]
( IdDistribuidor
  ,Distribuidor, NombreContacto ,Ciudad ,AnioVenta ,MesVenta ,FechaVenta ,Zona ,ClienteTipo ,Categoria ,TipoRecursivo  
  ,ClienteCodigo ,RazonSocial ,ClienteNombre ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago ,DocumentoEstado 
  ,Vendedor ,Almacen ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,ProductoCodigo ,ProductoNombre ,Bonificacion ,NumeroLote 
  ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,DescuentoProducto 
  ,Descuento2Producto ,DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto ,TotalKilosNetos ,TotalKilosBrutos
  ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre 
 )
 SELECT DistribuidorID
       ,Distribuidor ,NombreContacto ,Ciudad, AnioVenta, MesVenta, FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo, ClienteCodigo, RazonSocial 
       ,ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado, Vendedor, Almacen, Negocio 
	   ,Reclasificacion, Segmento, SubRubro, ProductoCodigo, ProductoNombre, Bonificacion, NumeroLote, UnidadMedidaVenta, FactorConversion 
	   ,ListaPrecio, CantDISP_UN, CantBU, PrecioProducto, TotalProducto, DescuentoProducto 
	   ,Round(CASE Bonificacion 
				WHEN 'No' THEN (TotalProducto * DescuentoDocumento) 
				WHEN 'Si' THEN 0.00
			   END, 2) AS Descuento2Producto, DescuentoDocumento 
		,UsuarioTransaccion, PesoNeto, PesoBruto, TotalKilosNetos, TotalKilosBrutos
		,CostoPrecioPromedio, TotalCostoPromedio 
		,Round(CASE
		        WHEN  Bonificacion = 'No' and TotalProducto > 0  THEN ( TotalProducto - TotalCostoPromedio ) 
				ELSE 0.00 
			   END, 3) as CMB_Monto
		,Round(CASE 
		        WHEN Bonificacion = 'No' and TotalProducto > 0 THEN ( ( TotalProducto - TotalCostoPromedio ) / TotalProducto ) 
				ELSE 0.00
				END, 3) as CMB_Porcentaje
		,NumeroGuia, EstadoGuia, RepartidorNombre 
   FROM Ventas 
  WHERE DistribuidorID >= 3

 --WHERE NumeroFactura = 1159
  --Where NumeroGuia = 70000006 --DescuentoTotal > 0

