/****** Object:  View [PIVOT].[VentasXFecha]    Script Date: 11/12/2019 11:02:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [PIVOT].[VentasXFecha]
AS

WITH Ventas (DistribuidorID, FechaVenta ,ClienteID ,RazonSocial, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago 
			,IdDocumentoEstado ,DocumentoEstado, Vendedor, AlmacenID, ProductoID ,Bonificacion, NumeroLote, UnidadMedidaVenta
			,FactorConversion, ListaPrecio ,CantDISP_UN, CantBU, PrecioProducto ,TotalProducto ,CantidadDevuelta ,DescuentoProducto
			,DescuentoDocumento, UsuarioTransaccion ,CostoPrecioPromedio ,TotalCostoPromedio, NumeroGuia, EstadoGuia, RepartidorNombre
			,FechaCreacionGuia, FechaDespachoGuia ,ObservacionFactura)
AS (
	SELECT Sale.CompanyId as DistribuidorID 
		  ,Convert(date,Sale.SaleDate) AS FechaVenta 
		  ,Sale.CustomerId as ClienteId 
		  ,Sale.CustomerName AS RazonSocial 
		  ,Sale.Nit AS NumeroNIT 
		  ,Sale.Number AS NumeroFactura ,Sale.AuthorizationNumber AS AutorizacionNumero ,Sale.ControlCode AS CodigoControl
		  ,C1.[Name] AS TipoPago 
		  ,Sale.StatusIdc as IdDocumentoEstado
		  ,C2.[Name] AS DocumentoEstado ,Usr.[Name] AS Vendedor 
		  ,Sale.StoreId 
		  ,SaleD.ProductId as ProductoId 
		  ,CASE SaleD.Bonus
					WHEN 0 THEN 'No'
					WHEN 1 THEN 'Si'
		   END AS Bonificacion
		  ,Batch.BachNumber AS NumeroLote ,C3.[Name] AS UnidadMedidaVenta ,CUnit.Equivalence AS FactorConversion ,PLst.[Name] AS ListaPrecio
		  ,SaleD.Quantity AS CantDISP_UN ,(SaleD.Quantity/CUnit.Equivalence) AS CantBU ,SaleD.Price AS PrecioProducto ,SaleD.Total AS TotalProducto 
		  ,SaleD.QuantityDevolution 
		  ,CASE SaleD.DiscountTypeIdc 
				WHEN 33 THEN Round(((SaleD.Total*SaleD.Discount*100)/10000),2) 
				WHEN 34 THEN SaleD.Discount
				ELSE 0.00 
		   END AS DescuentoProducto    
		  ,CASE Sale.DiscountTypeIdc 
				WHEN 33 THEN (Sale.Discount/100) 
				WHEN 34 THEN Round((Sale.Discount/Sale.Total),6)
				ELSE 0.00 
		   END AS DescuentoDocumento 
		  ,Usr1.[Name] AS UsuarioTransaccion 
		  ,(STd.PPP / CUnit.Equivalence) AS CostoPrecioPromedio ,(SaleD.Quantity*(STd.PPP/CUnit.Equivalence)) AS TotalCostoPromedio
		  ,Opc.Number AS NumeroGuia ,C11.[Name] AS EstadoGuia ,Seller.[Name] AS RepartidorNombre
		  ,convert(DATE, Opc.CreationDate) as FechaCreacionGuia ,convert(DATE, Opc.DispatchDate) AS FechaDespachoGuia
  		  ,Sale.Observation as ObservacionFactura 
FROM Sales.MsSale Sale
			INNER JOIN Sales.PsSaleDetail SaleD ON SaleD.SaleId = Sale.Id
			INNER JOIN Base.PsClassifier C1 ON C1.Id = Sale.PaymentTypeIdc
			INNER JOIN Base.PsClassifier C2 ON C2.Id = Sale.StatusIdc
			INNER JOIN Base.PsClassifier C3 ON C3.Id = SaleD.UnitIdc
			INNER JOIN [Security].MsUser Usr ON Usr.Id = Sale.SellerId
			INNER JOIN [Security].MsUser Usr1 ON Usr1.Id = Sale.UserId
			INNER JOIN Warehouse.PsBatch Batch ON Batch.Id = SaleD.BatchId
			INNER JOIN Sales.PsPriceList Plst ON Plst.Id = SaleD.PriceListId
			INNER JOIN Warehouse.PsCompanyUnit CUnit ON CUnit.CompanyId = Sale.CompanyId and CUnit.ProductId = SaleD.ProductId
			INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
			INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
			INNER JOIN Base.PsClassifier C11 ON C11.Id = Opc.StatusIdc
			INNER JOIN [Security].MsUser Seller ON Seller.Id = Opc.SellerId
			INNER JOIN Warehouse.PsStoreTransactionDetail STd ON STd.ProductId = SaleD.ProductId
																and STd.BatchId = SaleD.BatchId 
																and STd.Id = (Select min(X.Id) FROM Warehouse.PsStoreTransactionDetail X 
																	               WHERE X.StoreTransactionId = Sale.StoreTransactionId and 
																				         X.ProductId = SaleD.ProductId
																						 and X.BatchId = SaleD.BatchId )
	 UNION ALL 
	SELECT Sale.CompanyId as DistribuidorID 
		  ,Convert(date,Sale.SaleDate) AS FechaVenta 
		  ,Sale.CustomerId as ClienteId 
		  ,Sale.CustomerName AS RazonSocial 
		  ,Sale.Nit AS NumeroNIT 
		  ,Sale.Number AS NumeroFactura ,Sale.AuthorizationNumber AS AutorizacionNumero ,Sale.ControlCode AS CodigoControl
		  ,C1.[Name] AS TipoPago 
		  ,Sale.StatusIdc as IdDocumentoEstado
		  ,C2.[Name] AS DocumentoEstado ,Usr.[Name] AS Vendedor 
		  ,Sale.StoreId 
		  ,SaleD.ProductId as ProductoId 
		  ,CASE SaleD.Bonus
					WHEN 0 THEN 'No'
					WHEN 1 THEN 'Si'
		   END AS Bonificacion
		  ,Batch.BachNumber AS NumeroLote ,C3.[Name] AS UnidadMedidaVenta ,CUnit.Equivalence AS FactorConversion ,PLst.[Name] AS ListaPrecio
		  ,SaleD.Quantity AS CantDISP_UN ,(SaleD.Quantity/CUnit.Equivalence) AS CantBU ,SaleD.Price AS PrecioProducto ,SaleD.Total AS TotalProducto
		  ,SaleD.QuantityDevolution 
		  ,CASE SaleD.DiscountTypeIdc 
				WHEN 33 THEN Round(((SaleD.Total*SaleD.Discount*100)/10000),2) 
				WHEN 34 THEN SaleD.Discount
				ELSE 0.00 
		   END AS DescuentoProducto 
		  ,CASE Sale.DiscountTypeIdc 
				WHEN 33 THEN (Sale.Discount/100) 
				WHEN 34 THEN Round((Sale.Discount/Sale.Total),6)
				ELSE 0.00 
		   END AS DescuentoDocumento 
		   ,Usr1.[Name] AS UsuarioTransaccion 
		  ,(STd.PPP/CUnit.Equivalence) AS CostoPrecioPromedio 
		  ,(SaleD.Quantity*(STd.PPP/CUnit.Equivalence)) as TotalCostoPromedio
		  ,0 AS NumeroGuia ,'No Definido' AS EstadoGuia ,Usr.[Name] AS RepartidorNombre 
  		  ,DATEFROMPARTS(1900, 1 ,1) as FechaCreacionGuia ,DATEFROMPARTS(1900, 1 ,1) as FechaDespachoGuia
  		  ,Sale.Observation as ObservacionFactura 
	  FROM Sales.MsSale Sale
			INNER JOIN Sales.PsSaleDetail SaleD ON SaleD.SaleId = Sale.Id
			INNER JOIN Warehouse.MsProduct Prd ON Prd.Id = SaleD.ProductId
			INNER JOIN Base.PsClassifier C1 ON C1.Id = Sale.PaymentTypeIdc
			INNER JOIN Base.PsClassifier C2 ON C2.Id = Sale.StatusIdc
			INNER JOIN Base.PsClassifier C3 ON C3.Id = SaleD.UnitIdc
			INNER JOIN [Security].MsUser Usr ON Usr.Id = Sale.SellerId
			INNER JOIN [Security].MsUser Usr1 ON Usr1.Id = Sale.UserId
			INNER JOIN Warehouse.PsBatch Batch ON Batch.Id = SaleD.BatchId
			INNER JOIN Sales.PsPriceList Plst ON Plst.Id = SaleD.PriceListId
			INNER JOIN Warehouse.PsCompanyUnit CUnit ON CUnit.CompanyId = Sale.CompanyId and CUnit.ProductId = SaleD.ProductId
			INNER JOIN Warehouse.PsStoreTransactionDetail STd ON STd.StoreTransactionId = Sale.StoreTransactionId and STd.ProductId = SaleD.ProductId
																	and STd.BatchId = SaleD.BatchId
	 WHERE Not Exists (SELECT * FROM Warehouse.PsOpcOrderSale OpcSale
						WHERE OpcSale.SaleId = Sale.Id )
		)
SELECT DistribuidorID 
	  ,FechaVenta
	  ,ClienteId 
	  ,RazonSocial 
	  ,NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago
	  ,IdDocumentoEstado
	  ,DocumentoEstado
	  ,Vendedor, AlmacenID
	  ,ProductoID 
	  ,Bonificacion 
	  ,NumeroLote, UnidadMedidaVenta
	  ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto 
	  ,CantidadDevuelta ,DescuentoProducto 
	  ,Round(CASE Bonificacion 
				WHEN 'No' THEN (TotalProducto * DescuentoDocumento) 
				WHEN 'Si' THEN 0.0000
			 END, 4) AS Descuento2Producto
	  --,DescuentoDocumento 
	  ,UsuarioTransaccion
	  ,CostoPrecioPromedio, TotalCostoPromedio 
	  ,Round(CASE
				WHEN Bonificacion = 'No' and TotalProducto > 0  THEN ( TotalProducto - TotalCostoPromedio ) 
				ELSE 0.0000 
			  END, 4) as CMB_Monto
	  ,Round(CASE 
				WHEN Bonificacion = 'No' and TotalProducto > 0 THEN ( ( TotalProducto - TotalCostoPromedio ) / TotalProducto ) 
				ELSE 0.0000
			  END, 4) as CMB_Porcentaje
	  ,NumeroGuia, EstadoGuia, RepartidorNombre 
	  ,FechaCreacionGuia 
	  ,FechaDespachoGuia 
	  ,ObservacionFactura
  FROM Ventas 
 WHERE DistribuidorID >= 3 

GO


--and FechaVenta >= '2020/04/01' and DocumentoEstado = 'Anulado' 

-- Campos Adicionales
-- Descuento2Producto ,CMB_Moto , CMB_Porcentaje

