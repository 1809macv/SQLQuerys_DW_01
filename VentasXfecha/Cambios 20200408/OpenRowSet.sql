SELECT 
	DistribuidorID, Distribuidor, NombreContacto, Ciudad, AnioVenta, MesVenta, FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo, 
	ClienteCodigo, RazonSocial, ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado, 
	Vendedor, Almacen, Negocio, Reclasificacion, Segmento, SubRubro, ProductoCodigo, ProductoNombre, Bonificacion, NumeroLote, 
	UnidadMedidaVenta, FactorConversion, ListaPrecio, CantDISP_UN, CantBU, PrecioProducto, TotalProducto, DescuentoProducto, 
	DescuentoDocumento, UsuarioTransaccion, PesoNeto, PesoBruto, TotalKilosNetos, TotalKilosBrutos, CostoPrecioPromedio, TotalCostoPromedio, 
	NumeroGuia, EstadoGuia, RepartidorNombre
FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=AVA_PIVOT;PWD=arcor.123*;Database=MSFSystemVacio',
'SELECT Cmp.Id as DistribuidorID ,Cmp.Name AS Distribuidor ,Cmp.Contact as NombreContacto ,C8.Name AS Ciudad ,Year(Sale.SaleDate) AS AnioVenta
		,Month(Sale.SaleDate) AS MesVenta ,Convert(date,Sale.SaleDate) AS FechaVenta ,Zne.Name AS Zona ,C9.Name AS ClienteTipo ,C10.Name AS Categoria
		,CRecursive.Name AS TipoRecursivo ,Customer.Code AS ClienteCodigo ,Sale.CustomerName AS RazonSocial ,Customer.Name AS ClienteNombre
		,Sale.Nit AS NumeroNIT ,Sale.Number AS NumeroFactura ,Sale.AuthorizationNumber AS AutorizacionNumero ,Sale.ControlCode AS CodigoControl
		,C1.Name AS TipoPago ,C2.Name AS DocumentoEstado ,Usr.Name AS Vendedor ,Store.Name AS Almacen ,C4.Name AS Negocio ,C5.Name AS Reclasificacion
		,C6.Name AS Segmento ,C7.Name AS SubRubro ,Prd.Code AS ProductoCodigo ,Prd.Name AS ProductoNombre ,SaleD.Bonus AS Bonificacion
		,Batch.BachNumber AS NumeroLote ,C3.Name AS UnidadMedidaVenta ,CUnit.Equivalence AS FactorConversion ,PLst.Name AS ListaPrecio
		,SaleD.Quantity AS CantDISP_UN ,(SaleD.Quantity/CUnit.Equivalence) AS CantBU ,SaleD.Price AS PrecioProducto ,SaleD.Total AS TotalProducto
		,CASE SaleD.DiscountTypeIdc WHEN 33 THEN Round(((SaleD.Total*SaleD.Discount*100)/10000),2) WHEN 34 THEN SaleD.Discount
		 ELSE 0.00 END AS DescuentoProducto ,CASE Sale.DiscountTypeIdc WHEN 33 THEN (Sale.Discount/100) WHEN 34 THEN Round((Sale.Discount/Sale.Total),6)
		 ELSE 0.00 END AS DescuentoDocumento ,Usr1.Name AS UsuarioTransaccion ,Prd.Weight AS PesoNeto ,Prd.TotalWeight AS PesoBruto
		,(Prd.Weight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosNetos ,(Prd.TotalWeight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosBrutos
		,(STd.PPP / CUnit.Equivalence) AS CostoPrecioPromedio ,(SaleD.Quantity*(STd.PPP/CUnit.Equivalence)) as TotalCostoPromedio
		,Opc.Number AS NumeroGuia ,C11.Name AS EstadoGuia ,Seller.Name AS RepartidorNombre
	FROM Sales.MsSale Sale
		INNER JOIN Sales.PsSaleDetail SaleD ON SaleD.SaleId = Sale.Id
		INNER JOIN Warehouse.MsProduct Prd ON Prd.Id = SaleD.ProductId
		INNER JOIN Base.MsCompany Cmp ON Cmp.Id = Sale.CompanyId
		INNER JOIN Base.PsClassifier C1 ON C1.Id = Sale.PaymentTypeIdc
		INNER JOIN Base.PsClassifier C2 ON C2.Id = Sale.StatusIdc
		INNER JOIN Base.PsClassifier C3 ON C3.Id = SaleD.UnitIdc
		INNER JOIN Security.MsUser Usr ON Usr.Id = Sale.SellerId
		INNER JOIN Security.MsUser Usr1 ON Usr1.Id = Sale.UserId
		INNER JOIN Warehouse.MsStore Store ON Store.Id = Sale.StoreId
		INNER JOIN Warehouse.PsBatch Batch ON Batch.Id = SaleD.BatchId
		INNER JOIN Sales.PsPriceList Plst ON Plst.Id = SaleD.PriceListId
		INNER JOIN Warehouse.MsProductLine PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId
		INNER JOIN Base.PsClassifier C4 ON C4.Id = PLine.BussinessIdc
		INNER JOIN Base.PsClassifier C5 ON C5.Id = PLine.ReclassificationIdc
		INNER JOIN Base.PsClassifier C6 ON C6.Id = PLine.SegmentIdc
		INNER JOIN Base.PsClassifier C7 ON C7.Id = PLine.SubcategoryIdc
		INNER JOIN Base.PsClassifier C8 ON C8.Id = Cmp.CityIdc
		INNER JOIN Sales.MsCustomer Customer ON Customer.Id = Sale.CustomerId
		INNER JOIN Zoning.PsZone Zne ON Zne.Id = Customer.ZoneId
		INNER JOIN Base.PsClassifier C9 ON C9.Id = Customer.CustomerTypeIdc
		INNER JOIN Base.PsClassifier C10 ON C10.Id = Customer.CategoryIdC
		INNER JOIN Base.PsClassifierRecursive CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr
		INNER JOIN Warehouse.PsCompanyUnit CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN Base.PsClassifier C11 ON C11.Id = Opc.StatusIdc
		INNER JOIN Security.MsUser Seller ON Seller.Id = Opc.SellerId
		INNER JOIN Warehouse.PsStoreTransactionDetail STd ON STd.StoreTransactionId = Sale.StoreTransactionId and STd.ProductId = SaleD.ProductId
																and STd.BatchId = SaleD.BatchId
 UNION ALL 
 SELECT Cmp.Id as DistribuidorID ,Cmp.Name AS Distribuidor ,Cmp.Contact as NombreContacto ,C8.Name AS Ciudad ,Year(Sale.SaleDate) AS AnioVenta
		,Month(Sale.SaleDate) AS MesVenta ,Convert(date,Sale.SaleDate) AS FechaVenta ,Zne.Name AS Zona ,C9.Name AS ClienteTipo ,C10.Name AS Categoria
		,CRecursive.Name AS TipoRecursivo ,Customer.Code AS ClienteCodigo ,Sale.CustomerName AS RazonSocial ,Customer.Name AS ClienteNombre
		,Sale.Nit AS NumeroNIT ,Sale.Number AS NumeroFactura ,Sale.AuthorizationNumber AS AutorizacionNumero ,Sale.ControlCode AS CodigoControl
		,C1.Name AS TipoPago ,C2.Name AS DocumentoEstado ,Usr.Name AS Vendedor ,Store.Name AS Almacen ,C4.Name AS Negocio ,C5.Name AS Reclasificacion
		,C6.Name AS Segmento ,C7.Name AS SubRubro ,Prd.Code AS ProductoCodigo ,Prd.Name AS ProductoNombre ,SaleD.Bonus AS Bonificacion
		,Batch.BachNumber AS NumeroLote ,C3.Name AS UnidadMedidaVenta ,CUnit.Equivalence AS FactorConversion ,PLst.Name AS ListaPrecio
		,SaleD.Quantity AS CantDISP_UN ,(SaleD.Quantity/CUnit.Equivalence) AS CantBU ,SaleD.Price AS PrecioProducto ,SaleD.Total AS TotalProducto
		,CASE SaleD.DiscountTypeIdc WHEN 33 THEN Round(((SaleD.Total*SaleD.Discount*100)/10000),2) WHEN 34 THEN SaleD.Discount
		 ELSE 0.00 END AS DescuentoProducto ,CASE Sale.DiscountTypeIdc WHEN 33 THEN (Sale.Discount/100) WHEN 34 THEN Round((Sale.Discount/Sale.Total),6)
		 ELSE 0.00 END AS DescuentoDocumento ,Usr1.Name AS UsuarioTransaccion ,Prd.Weight AS PesoNeto ,Prd.TotalWeight AS PesoBruto
		,(Prd.Weight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosNetos ,(Prd.TotalWeight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosBrutos
		,(STd.PPP/CUnit.Equivalence) AS CostoPrecioPromedio ,(SaleD.Quantity*(STd.PPP/CUnit.Equivalence)) as TotalCostoPromedio
		,0 AS NumeroGuia ,''No Definido'' AS EstadoGuia ,Usr.Name AS RepartidorNombre
	FROM Sales.MsSale Sale
		INNER JOIN Sales.PsSaleDetail SaleD ON SaleD.SaleId = Sale.Id
		INNER JOIN Warehouse.MsProduct Prd ON Prd.Id = SaleD.ProductId
		INNER JOIN Base.MsCompany Cmp ON Cmp.Id = Sale.CompanyId
		INNER JOIN Base.PsClassifier C1 ON C1.Id = Sale.PaymentTypeIdc
		INNER JOIN Base.PsClassifier C2 ON C2.Id = Sale.StatusIdc
		INNER JOIN Base.PsClassifier C3 ON C3.Id = SaleD.UnitIdc
		INNER JOIN Security.MsUser Usr ON Usr.Id = Sale.SellerId
		INNER JOIN Security.MsUser Usr1 ON Usr1.Id = Sale.UserId
		INNER JOIN Warehouse.MsStore Store ON Store.Id = Sale.StoreId
		INNER JOIN Warehouse.PsBatch Batch ON Batch.Id = SaleD.BatchId
		INNER JOIN Sales.PsPriceList Plst ON Plst.Id = SaleD.PriceListId
		INNER JOIN Warehouse.MsProductLine PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId
		INNER JOIN Base.PsClassifier C4 ON C4.Id = PLine.BussinessIdc
		INNER JOIN Base.PsClassifier C5 ON C5.Id = PLine.ReclassificationIdc
		INNER JOIN Base.PsClassifier C6 ON C6.Id = PLine.SegmentIdc
		INNER JOIN Base.PsClassifier C7 ON C7.Id = PLine.SubcategoryIdc
		INNER JOIN Base.PsClassifier C8 ON C8.Id = Cmp.CityIdc
		INNER JOIN Sales.MsCustomer Customer ON Customer.Id = Sale.CustomerId
		INNER JOIN Zoning.PsZone Zne ON Zne.Id = Customer.ZoneId
		INNER JOIN Base.PsClassifier C9 ON C9.Id = Customer.CustomerTypeIdc
		INNER JOIN Base.PsClassifier C10 ON C10.Id = Customer.CategoryIdC
		INNER JOIN Base.PsClassifierRecursive CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr
		INNER JOIN Warehouse.PsCompanyUnit CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id
		INNER JOIN Warehouse.PsStoreTransactionDetail STd ON STd.StoreTransactionId = Sale.StoreTransactionId and STd.ProductId = SaleD.ProductId
																and STd.BatchId = SaleD.BatchId
	WHERE Not Exists (SELECT * FROM Warehouse.PsOpcOrderSale OpcSale
					WHERE OpcSale.SaleId = Sale.Id )')


