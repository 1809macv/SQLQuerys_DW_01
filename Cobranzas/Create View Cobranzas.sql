SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [PIVOT].[Cobros]
AS
WITH Pagos(IdDistribuidor, Distribuidor, ClienteNombre, FechaCobro, Observacion, EstadoDocumento, TipoTransaccion 
			,SubTipoTransaccion ,NumeroNIT ,FechaVenta ,ClienteId ,AutorizacionNumero ,NumeroFactura ,CodigoControl 
			,VendedorNombre ,MontoCobrado ,NumeroCuenta ,NombreCuenta ,RepartidorNombre ,NumeroGuia ,FechaDespacho)
AS
(
/*
======================================================================
 Querys que recuperan los datos de las facturas de ventas 
======================================================================
*/
SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,Sale.CustomerName as ClienteNombre 
		,CONVERT(DATE,Payment.PaymentDate) AS FechaCobro 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,CONVERT(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,Sale.AuthorizationNumber AS AutorizacionNumero
		,Sale.Number AS NumeroFactura
		,Sale.ControlCode AS CodigoControl 
		,Seller.[Name] AS VendedorNombre
		,RP.Quantity AS MontoCobrado
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
		,Transport.[Name] AS RepartidorNombre
		,CONVERT(VARCHAR(20),Opc.Number) AS NumeroGuia 
		,CONVERT(DATE,Opc.DispatchDate) AS FechaDespacho 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN [Accounting].[PsPayment] Payment ON Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP ON RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable ON Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = Receivable.SaleId
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN [Security].MsUser Transport ON Transport.Id = Opc.SellerId
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
   WHERE Trn.SubTypeTransactionIdr IS NULL AND Trn.CompanyId >= 3 AND Trn.TypeIdc = 85 
		 AND RP.Quantity > 0

UNION ALL 

SELECT Trn.CompanyId AS IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,Sale.CustomerName AS ClienteNombre 
		,CONVERT(DATE,Payment.PaymentDate) AS FechaCobro 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,CONVERT(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Seller.[Name] AS VendedorNombre
		,RP.Quantity AS MontoCobrado
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
		,Transport.[Name] AS RepartidorNombre
		,CONVERT(varchar(20),Opc.Number) AS NumeroGuia
		,CONVERT(DATE,Opc.DispatchDate) AS FechaDespacho 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN [Accounting].[PsPayment] Payment ON Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP ON RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable ON Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = Receivable.SaleId 
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN [Security].MsUser Transport ON Transport.Id = Opc.SellerId
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
   WHERE Trn.CompanyId >= 3 AND Trn.TypeIdc = 85
		 AND RP.Quantity > 0

UNION ALL 

SELECT Trn.CompanyId AS IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,Sale.CustomerName AS ClienteNombre 
		,Convert(DATE,Payment.PaymentDate) AS FechaCobro 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,Convert(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Seller.[Name] AS VendedorNombre
		,RP.Quantity AS MontoCobrado
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
		,Transport.[Name] AS RepartidorNombre
		,Convert(varchar(20),Opc.Number) AS NumeroGuia
		,Convert(DATE,Opc.DispatchDate) AS FechaDespacho 
  FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[PsPayment] Payment ON Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP ON RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable ON Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = Receivable.SaleId 
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN [Security].MsUser Transport ON Transport.Id = Opc.SellerId
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE Trn.SubTypeTransactionIdr IS NULL 
		AND TrnD.AccountId IS NULL AND Trn.CompanyId >= 3 AND Trn.TypeIdc = 85
		AND RP.Quantity > 0

UNION ALL 

SELECT Trn.CompanyId AS IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,Sale.CustomerName AS ClienteNombre 
		,Convert(DATE,Payment.PaymentDate) AS FechaCobro 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,Convert(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Seller.[Name] AS VendedorNombre
		,RP.Quantity AS MontoCobrado
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
		,Transport.[Name] AS RepartidorNombre
		,Convert(varchar(20),Opc.Number) AS NumeroGuia
		,Convert(DATE,Opc.DispatchDate) AS FechaDespacho 
  FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[PsPayment] Payment ON Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP ON RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable ON Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = Receivable.SaleId 
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN [Security].MsUser Transport ON Transport.Id = Opc.SellerId
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE TrnD.AccountId IS NULL AND Trn.CompanyId >= 3 AND Trn.TypeIdc = 85
		AND RP.Quantity > 0

UNION ALL

--------------------------------------------------------------------------
-- Se adiciono el query con las ventas directas 
--------------------------------------------------------------------------
SELECT Trans.CompanyId AS IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,Sale.CustomerName AS ClienteNombre 
		,Convert(DATE,Trans.TransactionDate) AS FechaCobro
		,Trans.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,Convert(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,Sale.AuthorizationNumber AS AutorizacionNumero
		,Sale.Number AS NumeroFactura
		,Sale.ControlCode AS CodigoControl 
		,Seller.[Name] AS VendedorNombre
		,TrnD.Amount AS MontoCobrado 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta  
		,Transport.[Name] AS RepartidorNombre
		,Convert(varchar(20),Opc.Number) AS NumeroGuia
		,Convert(DATE,Opc.DispatchDate) AS FechaDespacho 
  FROM [Accounting].[PsTransaction] Trans 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trans.Id 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.TransactionId = Trans.Id
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trans.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trans.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
		INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
		INNER JOIN [Security].MsUser Transport ON Transport.Id = Opc.SellerId
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE Sale.CompanyId >= 3

UNION ALL

-----------------------------------------------------------------------------
---- Se adiciono el query de los ingresos que no tienen ninguna relacion
---- con la tabla [Accounting].[PsPayment]
---- y con la tabla [Sales].[MsSale]
-----------------------------------------------------------------------------
SELECT Trans.CompanyId AS IdDistribuidor 
		,Cmp.[Name] AS Distribuidor 
		,'S/N CLIENTE' AS ClienteNombre 
		,CONVERT(DATE,Trans.TransactionDate) AS FechaCobro
		,Trans.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,CONVERT(DATE,Sale.SaleDate) AS FechaVenta 
		,Sale.CustomerId AS ClienteId
		,Sale.AuthorizationNumber AS AutorizacionNumero
		,Sale.Number AS NumeroFactura
		,Sale.ControlCode AS CodigoControl 
		,'S/N del Vendedor' AS VendedorNombre
		,TransD.Amount AS MontoCobrado 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta  
		,'CONTADO' AS RepartidorNombre
		,'S/N de Guia' AS NumeroGuia
		,DATEFROMPARTS(1900,1,1) AS FechaDespacho 
  FROM [Accounting].[PsTransaction] Trans
		INNER JOIN [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TransD.AccountId 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trans.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trans.StatusIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trans.TypeTransactionIdr 
		LEFT JOIN [Sales].[MsSale] Sale ON Sale.TransactionId = Trans.Id
		LEFT JOIN [Accounting].[PsPayment] Payment ON Payment.TransactionId = Trans.Id
 WHERE Trans.CompanyId >= 3 AND Trans.TypeIdc = 85 AND Payment.Id IS NULL AND Sale.Id IS NULL
)
SELECT IdDistribuidor ,Distribuidor, ClienteNombre ,FechaCobro, Observacion, EstadoDocumento, TipoTransaccion 
	  ,SubTipoTransaccion ,NumeroNIT ,FechaVenta ,ClienteId ,AutorizacionNumero ,NumeroFactura ,CodigoControl 
	  ,VendedorNombre ,MontoCobrado ,NumeroCuenta ,NombreCuenta ,RepartidorNombre, NumeroGuia ,FechaDespacho
  FROM Pagos 

GO


