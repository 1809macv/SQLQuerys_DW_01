/****** Object:  View [PIVOT].[Pagos]    Script Date: 3/9/2021 3:08:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [PIVOT].[Pagos]
AS
WITH Pagos(IdDistribuidor, Distribuidor, Proveedor, FechaGasto, Observacion, EstadoDocumento, TipoTransaccion   --AnioGasto, MesGasto, TipoNombre, 
			,SubTipoTransaccion ,NumeroNIT ,AutorizacionNumero ,NumeroFactura ,CodigoControl ,TypeIdc ,TipoMovimiento ,IsTransfer 
			,MontoTotal ,NumeroCuenta ,NombreCuenta)
AS
(
SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name AS Distribuidor 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'Proveedor no Definido'
			ELSE
				(SELECT Top 1 Pr.[Name] FROM [Purchases].[MsProvider] Pr 
					WHERE Pr.NIT = TrnD.NIT AND Pr.CompanyId = Trn.CompanyId )
		END AS Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		--,C2.[Name] AS TipoNombre 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
			END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl 
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,Case 
			WHEN (Trn.TypeIdc = 86 AND TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			Else TrnD.Amount 
		END AS MontoTotal 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
	WHERE Trn.SubTypeTransactionIdr IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc in (86, 92)

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name as Distribuidor 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'Proveedor no Definido'
			ELSE
				(SELECT Top 1 Pr.[Name] FROM [Purchases].[MsProvider] Pr 
					WHERE Pr.NIT = TrnD.NIT AND Pr.CompanyId = Trn.CompanyId )
		END AS Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		--,C2.Name AS TipoNombre 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,CASE 
			WHEN (Trn.TypeIdc = 86 AND TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			ELSE TrnD.Amount 
		END AS MontoTotal 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
   WHERE Trn.CompanyId >= 3 and Trn.TypeIdc in (86, 92)

	UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name AS Distribuidor 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'Proveedor no Definido'
			ELSE
				(SELECT Top 1 Pr.[Name] FROM [Purchases].[MsProvider] Pr 
					WHERE Pr.NIT = TrnD.NIT AND Pr.CompanyId = Trn.CompanyId )
		END AS Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		--,C2.Name AS TipoNombre 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,CASE 
			WHEN (Trn.TypeIdc = 86 AND TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			ELSE TrnD.Amount 
		END AS MontoTotal 
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
	WHERE Trn.SubTypeTransactionIdr IS null 
		AND TrnD.AccountId IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc in (86, 92)

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name as Distribuidor 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'Proveedor no Definido'
			ELSE
				(SELECT Top 1 Pr.[Name] FROM [Purchases].[MsProvider] Pr 
					WHERE Pr.NIT = TrnD.NIT AND Pr.CompanyId = Trn.CompanyId )
			END AS Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		--,C2.Name AS TipoNombre 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN TrnD.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(TrnD.Nit))) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,CASE 
			WHEN (Trn.TypeIdc = 86 AND TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			ELSE TrnD.Amount 
		END AS MontoTotal 
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
	WHERE TrnD.AccountId IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc in (86, 92)

UNION
/*
======================================================================
 Querys que recuperan los datos de las facturas de ventas 
======================================================================
*/
SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name AS Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,Sale.AuthorizationNumber AS AutorizacionNumero
		,Sale.Number AS NumeroFactura
		,Sale.ControlCode AS CodigoControl 
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,RP.Quantity AS MontoTotal 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
   WHERE Trn.SubTypeTransactionIdr IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc = 85 
		 and RP.Quantity > 0

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name as Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,RP.Quantity AS MontoTotal 
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
   WHERE Trn.CompanyId >= 3 and Trn.TypeIdc = 85
		 and RP.Quantity > 0

	UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name AS Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,RP.Quantity AS MontoTotal 
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
	WHERE Trn.SubTypeTransactionIdr IS null 
		AND TrnD.AccountId IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc = 85
		 and RP.Quantity > 0

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
		,Cmp.Name as Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(date,Trn.TransactionDate) AS FechaGasto 
		,Trn.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CRv.[Name] AS TipoTransaccion 
		,CR.[Name] AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,TrnD.AuthorizationNumber AS AutorizacionNumero
		,TrnD.InvoiceNumber AS NumeroFactura
		,TrnD.ControlCode AS CodigoControl
		,Trn.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,RP.Quantity AS MontoTotal 
		,'0000000000' AS NumeroCuenta 
		,'Cuenta NO DEFINIDA' AS NombreCuenta 
	FROM [Accounting].[PsTransaction] Trn 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr AND CR.Id = Trn.SubTypeTransactionIdr 
		INNER JOIN [Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
		INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trn.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
	WHERE TrnD.AccountId IS NULL and Trn.CompanyId >= 3 and Trn.TypeIdc = 85
		 and RP.Quantity > 0

UNION ALL

SELECT Trans.CompanyId as IdDistribuidor 
		--,Trans.Id ,TrnD.Id ,Sale.PaymentTypeIdc
		,Cmp.Name AS Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(date,Trans.TransactionDate) AS FechaGasto
		,Trans.Detail AS Observacion
		,C1.[Name] AS EstadoDocumento 
		,CR.[Name] AS TipoTransaccion 
		,'Sin SubTipo' AS SubTipoTransaccion 
		,CASE 
			WHEN Sale.Nit IS NULL OR ISNUMERIC(RTRIM(LTRIM(Sale.Nit))) = 0 THEN 'S/N'
			ELSE Sale.Nit 
		 END AS NumeroNIT 
		,Sale.AuthorizationNumber AS AutorizacionNumero
		,Sale.Number AS NumeroFactura
		,Sale.ControlCode AS CodigoControl 
		,Trans.TypeIdc 
		,C2.[Name] AS TipoMovimiento 
		,TrnD.IsTransfer
		,TrnD.Amount AS MontoTotal --, Sale.Total
		,Account.Number AS NumeroCuenta 
		,Account.[Name] AS NombreCuenta  
  FROM [Accounting].[PsTransaction] Trans 
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trans.Id 
		INNER JOIN [Sales].[MsSale] Sale ON Sale.TransactionId = Trans.Id
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trans.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trans.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trans.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
 WHERE Sale.CompanyId >= 3
)
SELECT IdDistribuidor ,Distribuidor, Proveedor
		,FechaGasto, Observacion, EstadoDocumento, TipoTransaccion   --TipoNombre, 
		,SubTipoTransaccion ,NumeroNIT ,AutorizacionNumero ,NumeroFactura ,CodigoControl ,TipoMovimiento 
		,CASE  
			WHEN TypeIdc = 85 THEN MontoTotal 
			WHEN TypeIdc = 92 and IsTransfer = 1 THEN MontoTotal
			ELSE 0
		END AS Debe 
		,CASE  
			WHEN TypeIdc = 86 THEN MontoTotal 
			WHEN TypeIdc = 92 and IsTransfer = 0 THEN MontoTotal
			ELSE 0
		END AS Haber 
		,NumeroCuenta ,NombreCuenta 
  FROM Pagos
 --WHERE IdDistribuidor >= 14 and FechaGasto >= '2021/03/01' and NumeroFactura in (1097, 1098, 1099)
GO


