/****** Object:  View [PIVOT].[CuentasXCobrar]    Script Date: 3/7/2021 8:58:19 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [PIVOT].[CuentasXCobrar]
AS

SELECT CxC.CompanyId AS IdDistribuidor
	 , Convert( date, Sale.SaleDate ) AS FechaVenta
	 , Customer.Code AS ClienteCodigo
	 , Sale.CustomerName AS ClienteNombre
	 , Sale.SellerId AS VendedorId
	 , Usr.[Name] AS VendedorNombre
	 , CxC.Total AS Importe
	 , CxC.Pay AS PagoParcial
	 , ( CxC.Total - CxC.Pay ) AS Saldo
	 , CASE 
			WHEN CxC.Pay = 0 THEN 'Pendiente de Pago'
			WHEN CxC.Total > CxC.Pay THEN 'Pago Parcial'
			ELSE 'Pagado'
	   end AS EstadoCuenta 
	 , Convert( date, CxC.ExpirationDate ) as FechaVencimiento
	 , Opc.Number as NumeroGuia 
	 , Convert( date, Opc.[DispatchDate] ) as FechaDespacho
	 , Sale.OrderId as NumeroNota 
	 , Sale.Number 
	 , Sale.AuthorizationNumber 
	 , Sale.ControlCode 
	 , CASE 
			WHEN (CxC.Total - CxC.Pay ) > 0 THEN DateDiff(DAY, CxC.ExpirationDate, GetDate()) 
			ELSE 0 
	   END AS DiasMora
	 , CASE
			WHEN Convert(DATE, CxC.ExpirationDate) >= Convert(DATE, GetDate()) THEN 'Por Vencer' 
			ELSE 'Vencido'
	   END AS EstadoVencimiento 
	 , Seller.[Name] AS RepartidorNombre
	 , Sale.Observation AS ObservacionFactura 
  FROM [Accounting].[MsReceivable] CxC
	   INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = CxC.SaleId 
	   INNER JOIN [Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
	   INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId
	   INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
	   INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Opc.SellerId
 WHERE CxC.CompanyId >= 3 and CxC.StatusIdc <> 106
	   and Sale.StatusIdc <> 104 

UNION 

SELECT CxC.CompanyId AS IdDistribuidor
	 , convert( DATE, Sale.SaleDate ) AS FechaVenta
	 , Customer.Code AS ClienteCodigo
	 , Sale.CustomerName AS ClienteNombre
	 , Sale.SellerId AS VendedorId
	 , Usr.[Name] AS VendedorNombre
	 , CxC.Total AS Importe
	 , CxC.Pay AS PagoParcial
	 , ( CxC.Total - CxC.Pay ) AS Saldo
	 , CASE 
			WHEN CxC.Pay = 0 THEN 'Pendiente de Pago'
			WHEN CxC.Total > CxC.Pay THEN 'Pago Parcial'
			Else 'Pagado'
	   END AS EstadoCuenta 
	 , Convert( DATE, CxC.ExpirationDate ) AS FechaVencimiento
	 , 0 as NumeroGuia 
	 , Convert( DATE, Sale.SaleDate ) AS FechaDespacho
	 , IsNull(Sale.OrderId, 0) AS NumeroNota 
	 , Sale.Number 
	 , IsNull(Sale.AuthorizationNumber, '') 
	 , IsNull(Sale.ControlCode, '') 
	 , CASE 
			WHEN (CxC.Total - CxC.Pay ) > 0 THEN DateDiff(DAY, CxC.ExpirationDate, GetDate()) 
			ELSE 0 
	   END AS DiasMora
	 , CASE
			WHEN Convert(DATE, CxC.ExpirationDate) >= Convert(DATE, GetDate()) THEN 'Por Vencer' 
			ELSE 'Vencido'
	   END AS EstadoVencimiento 
	 , Seller.[Name] AS RepartidorNombre
	 , Sale.Observation AS ObservacionFactura 
  FROM [Accounting].[MsReceivable] CxC
	   INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = CxC.SaleId 
	   INNER JOIN [Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
	   INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId
	   LEFT JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
	   --INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE CxC.CompanyId >= 3 and CxC.StatusIdc <> 106
	   and Sale.StatusIdc <> 104 and OpcSale.SaleId Is Null


GO


