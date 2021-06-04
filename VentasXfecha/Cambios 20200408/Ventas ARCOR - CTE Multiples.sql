WITH Vendedores (Id, TypeIdc, CompanyId, Code, Name, Active)
AS (
SELECT [Id]
      ,[TypeIdc]
      ,[CompanyId]
      ,[Code]
      ,[Name]
      ,[Active]
  FROM [Security].[MsUser]
  where [CompanyId] = 8 and [TypeIdc] = 47
),
Repartidores (Id, TypeIdc, CompanyId, Code, Name, Active)
AS (
SELECT [Id]
      ,[TypeIdc]
      ,[CompanyId]
      ,[Code]
      ,[Name]
      ,[Active]
  FROM [Security].[MsUser]
  where [CompanyId] = 8 and [TypeIdc] = 48
),
Clientes (Id, CustomerTypeIdc, BussinessTypeIdr, CategoryIdC, ZoneId, Code, Name)
AS (
SELECT [Id]
      ,[CustomerTypeIdc]
	  ,[BussinessTypeIdr]
	  ,[CategoryIdC]
	  ,[ZoneId]
      ,[Code]
      ,[Name]
  FROM [Sales].[MsCustomer]
  where [CompanyId] = 8 
),
Ventas (Distribuidor, Ciudad, AnioVenta, MesVenta, DiaVenta, FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo, ClienteCodigo, RazonSocial,
        ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado, VendedorNombre, Almacen, Negocio, 
		Reclasificacion, Segmento, SubRubro, ProductoCodigo, ProductoNombre, NumeroLote, UnidadMedidaVenta, FactorConversion, ListaPrecio, 
		CantDISP_UN, CantBU, PrecioProducto, TotalProducto, DescuentoProducto, DescuentoVenta, CantidadVenta, DescuentoTotal, 
		UsuarioTransaccion, PesoNeto, PesoBruto, TotalKilosNetos, TotalKilosBrutos, NumeroGuia, EstadoGuia, RepartidorNombre)
AS (
SELECT Cmp.[Name] as Distribuidor 
       ,C8.[Name] as Ciudad 
       ,Year(Sale.SaleDate) as AnioVenta 
	   ,case Month(Sale.SaleDate) 
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
	    end as MesVenta 
	   ,Day(Sale.SaleDate) as DiaVenta  
       ,convert(date,Sale.SaleDate) as FechaVenta
	   ,Zne.[Name] as Zona 
	   ,C9.[Name] as ClienteTipo 
	   ,C10.[Name] as Categoria 
	   ,CRecursive.[Name] as TipoRecursivo 
	   ,Customer.Code as ClienteCodigo 
       ,Sale.CustomerName as RazonSocial
	   ,Customer.[Name] as ClienteNombre
	   ,Sale.Nit as NumeroNIT
	   ,Sale.Number as NumeroFactura 
	   ,Sale.AuthorizationNumber as AutorizacionNumero
	   ,Sale.ControlCode as CodigoControl
	   ,C1.[Name] as TipoPago 
	   ,C2.[Name] as DocumentoEstado 
	   ,Vendedor.[Name] as VendedorNombre 
	   ,Store.[Name] as Almacen 
	   ,C4.[Name] as Negocio 
	   ,C5.[Name] as Reclasificacion 
	   ,C6.[Name] as Segmento 
	   ,C7.[Name] as SubRubro 
	   ,Prd.Code as ProductoCodigo 
	   ,Prd.[Name] as ProductoNombre 
	   ,Batch.BachNumber as NumeroLote
	   ,C3.[Name] as UnidadMedidaVenta 
	   ,CUnit.Equivalence as FactorConversion 
	   ,PLst.[Name] as ListaPrecio 
	   ,SaleD.Quantity as CantDISP_UN
	   ,(SaleD.Quantity / CUnit.Equivalence) as CantBU
	   ,SaleD.Price as PrecioProducto
	   ,SaleD.Total as TotalProducto
	   ,CASE SaleD.DiscountTypeIdc 
	         WHEN 33 THEN round( ( (SaleD.Total * SaleD.Discount * 100) / 10000 ) ,2)
	         WHEN 34 THEN SaleD.Discount
			 ELSE 0.00 
	    END as DescuentoProducto 
	   ,(SELECT sum(CASE SD.DiscountTypeIdc 
	                     WHEN 33 THEN round( ( (SD.Total * SD.Discount * 100) / 10000 ) ,2)
	                     WHEN 34 THEN SD.Discount
			             ELSE 0.00 
	                END) FROM [Sales].[PsSaleDetail] SD WHERE SD.SaleId = Sale.Id) as DescuentoVenta 
	   ,(SELECT sum(SD.Quantity) FROM [Sales].[PsSaleDetail] SD WHERE SD.SaleId = Sale.Id) as CantidadVenta 
	   ,Sale.TotalDiscount as DescuentoTotal
	   ,Usr1.[Name] as UsuarioTransaccion 
	   ,Prd.[Weight] as PesoNeto
	   ,Prd.TotalWeight as PesoBruto 
	   ,(Prd.[Weight] * SaleD.Quantity/CUnit.Equivalence) as TotalKilosNetos 
	   ,(Prd.TotalWeight * SaleD.Quantity/CUnit.Equivalence) as TotalKilosBrutos
	   ,Opc.Number as NumeroGuia 
	   ,C11.[Name] as EstadoGuia 
	   ,Repartidor.[Name] as RepartidorNombre
  FROM Sales.MsSale Sale 
       INNER JOIN [Sales].[PsSaleDetail] SaleD ON SaleD.SaleId = Sale.Id 
       INNER JOIN [Warehouse].[MsProduct] Prd ON Prd.Id = SaleD.ProductId 
       INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Sale.PaymentTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Sale.StatusIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = SaleD.UnitIdc 
	   INNER JOIN Vendedores Vendedor ON Vendedor.Id = Sale.SellerId 
	   INNER JOIN [Security].[MsUser] Usr1 ON Usr1.Id = Sale.UserId 
	   INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = Sale.StoreId 
	   INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = SaleD.BatchId 
	   INNER JOIN [Sales].[PsPriceList] Plst ON Plst.Id = SaleD.PriceListId 

	   INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 

	   INNER JOIN Clientes Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN [Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN [Base].[PsClassifier] C9 ON C9.Id = Customer.CustomerTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C10 ON C10.Id = Customer.CategoryIdC 

	   INNER JOIN [Base].[PsClassifierRecursive] CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr 
	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 

	   INNER JOIN [Warehouse].[PsOpcOrderSale] OpcSale ON OpcSale.SaleId = Sale.Id
	   INNER JOIN [Warehouse].[PsOpc] Opc ON Opc.Id = OpcSale.OpcId 
	   INNER JOIN [Base].[PsClassifier] C11 ON C11.Id = Opc.StatusIdc 
	   INNER JOIN Repartidores Repartidor ON Repartidor.Id = Opc.SellerId 
 WHERE Sale.CompanyId = 8 
 
 UNION ALL 
 
 SELECT Cmp.[Name] as Distribuidor 
       ,C8.[Name] as Ciudad 
       ,Year(Sale.SaleDate) as AnioVenta 
	   ,case Month(Sale.SaleDate) 
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
	    end as MesVenta 
	   ,Day(Sale.SaleDate) as DiaVenta  
       ,convert(date,Sale.SaleDate) as FechaVenta
	   ,Zne.[Name] as Zona 
	   ,C9.[Name] as ClienteTipo 
	   ,C10.[Name] as Categoria 
	   ,CRecursive.[Name] as TipoRecursivo 
	   ,Customer.Code as ClienteCodigo 
       ,Sale.CustomerName as RazonSocial
	   ,Customer.[Name] as ClienteNombre
	   ,Sale.Nit as NumeroNIT
	   ,Sale.Number as NumeroFactura 
	   ,Sale.AuthorizationNumber as AutorizacionNumero
	   ,Sale.ControlCode as CodigoControl
	   ,C1.[Name] as TipoPago 
	   ,C2.[Name] as DocumentoEstado 
	   ,Vendedor.[Name] as VendedorNombre 
	   ,Store.[Name] as Almacen 
	   ,C4.[Name] as Negocio 
	   ,C5.[Name] as Reclasificacion 
	   ,C6.[Name] as Segmento 
	   ,C7.[Name] as SubRubro 
	   ,Prd.Code as ProductoCodigo 
	   ,Prd.[Name] as ProductoNombre 
	   ,Batch.BachNumber as NumeroLote
	   ,C3.[Name] as UnidadMedidaVenta 
	   ,CUnit.Equivalence as FactorConversion 
	   ,PLst.[Name] as ListaPrecio 
	   ,SaleD.Quantity as CantDISP_UN
	   ,(SaleD.Quantity / CUnit.Equivalence) as CantBU
	   ,SaleD.Price as PrecioProducto
	   ,SaleD.Total as TotalProducto
	   ,CASE SaleD.DiscountTypeIdc 
	         WHEN 33 THEN round( ( (SaleD.Total * SaleD.Discount * 100) / 10000 ) ,2)
	         WHEN 34 THEN SaleD.Discount
			 ELSE 0.00 
	    END as DescuentoProducto 
	   ,(SELECT sum(CASE SD.DiscountTypeIdc 
	                     WHEN 33 THEN round( ( (SD.Total * SD.Discount * 100) / 10000 ) ,2)
	                     WHEN 34 THEN SD.Discount
			             ELSE 0.00 
	                END) FROM [Sales].[PsSaleDetail] SD WHERE SD.SaleId = Sale.Id) as DescuentoVenta 
	   ,(SELECT sum(SD.Quantity) FROM [Sales].[PsSaleDetail] SD WHERE SD.SaleId = Sale.Id) as CantidadVenta 
	   ,Sale.TotalDiscount as DescuentoTotal
	   ,Usr1.[Name] as UsuarioTransaccion 
	   ,Prd.[Weight] as PesoNeto
	   ,Prd.TotalWeight as PesoBruto 
	   ,(Prd.[Weight] * SaleD.Quantity/CUnit.Equivalence) as TotalKilosNetos 
	   ,(Prd.TotalWeight * SaleD.Quantity/CUnit.Equivalence) as TotalKilosBrutos
	   ,0 as NumeroGuia 
	   ,'No Definido' as EstadoGuia 
	   ,'VENTA DIRECTA' as RepartidorNombre
  FROM Sales.MsSale Sale 
       INNER JOIN [Sales].[PsSaleDetail] SaleD ON SaleD.SaleId = Sale.Id 
       INNER JOIN [Warehouse].[MsProduct] Prd ON Prd.Id = SaleD.ProductId 
       INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Sale.PaymentTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Sale.StatusIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = SaleD.UnitIdc 
	   INNER JOIN Vendedores Vendedor ON Vendedor.Id = Sale.SellerId 
	   INNER JOIN [Security].[MsUser] Usr1 ON Usr1.Id = Sale.UserId 
	   INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = Sale.StoreId 
	   INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = SaleD.BatchId 
	   INNER JOIN [Sales].[PsPriceList] Plst ON Plst.Id = SaleD.PriceListId 

	   INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = PLine.SubcategoryIdc 
	   INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 

	   INNER JOIN Clientes Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN [Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN [Base].[PsClassifier] C9 ON C9.Id = Customer.CustomerTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C10 ON C10.Id = Customer.CategoryIdC 

	   INNER JOIN [Base].[PsClassifierRecursive] CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr 
	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 
 WHERE Sale.CompanyId = 8 and 
	   Not Exists (SELECT * FROM [Warehouse].[PsOpcOrderSale] OpcSale 
	                WHERE OpcSale.SaleId = Sale.Id )
  )
 Select Distribuidor, Ciudad, AnioVenta, MesVenta, DiaVenta, FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo, ClienteCodigo, RazonSocial,
        ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado, VendedorNombre, Almacen, Negocio, 
		Reclasificacion, Segmento, SubRubro, ProductoCodigo, ProductoNombre, NumeroLote, UnidadMedidaVenta, FactorConversion, ListaPrecio, 
		CantDISP_UN, CantBU, PrecioProducto, TotalProducto, DescuentoProducto, DescuentoVenta, CantidadVenta, DescuentoTotal, 
		UsuarioTransaccion, PesoNeto, PesoBruto, TotalKilosNetos, TotalKilosBrutos, NumeroGuia, EstadoGuia, RepartidorNombre, 
		(DescuentoTotal - DescuentoVenta) as DescuentoVentas2
   From Ventas