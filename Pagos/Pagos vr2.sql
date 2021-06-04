USE [MSFSystem_Cube]
GO

TRUNCATE TABLE [PIVOT].[Pagos]
GO

WITH Pagos(IdDistribuidor, Distribuidor, Proveedor, AnioGasto, MesGasto, FechaGasto, Observacion, EstadoDocumento, TipoNombre, TipoTransaccion
          ,SubTipoTransaccion ,NumeroNIT ,AutorizacionNumero ,NumeroFactura ,CodigoControl ,TypeIdc ,TipoMovimiento ,IsTransfer ,MontoTotal 
		  ,NumeroCuenta ,NombreCuenta)
AS
(
SELECT Trn.CompanyId as IdDistribuidor 
      ,Cmp.Name AS Distribuidor 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR cast(TrnD.NIT as bigint) = 0 THEN 'Proveedor no Definido'
			ELSE
			    (SELECT Pr.Name FROM MSFSystemVacio.[Purchases].[MsProvider] Pr 
	              WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId )
		 END AS Proveedor 
      ,Year(Trn.TransactionDate) AS AnioGasto 
	  ,CASE Month(Trn.TransactionDate) 
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
	   END AS MesGasto 
      ,Trn.TransactionDate AS FechaGasto
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CR.Name AS TipoTransaccion 
	  ,'Sin SubTipo' AS SubTipoTransaccion 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR CAST(TrnD.NIT as bigint) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		 END AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl 
	  ,Trn.TypeIdc 
	  ,C2.[Name] as TipoMovimiento 
	  ,TrnD.IsTransfer
	  ,Case 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			Else TrnD.Amount 
	   END AS MontoTotal 
	  ,Account.Number AS NumeroCuenta 
	  ,Account.Name AS NombreCuenta 
  FROM MSFSystemVacio.[Accounting].[PsTransaction] Trn 
       INNER JOIN MSFSystemVacio.[Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
	   INNER JOIN MSFSystemVacio.[Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
 WHERE Trn.SubTypeTransactionIdr is null 

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
      ,Cmp.Name as Distribuidor 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR cast(TrnD.NIT as bigint) = 0 THEN 'Proveedor no Definido'
			ELSE
			    (SELECT Pr.Name FROM MSFSystemVacio.[Purchases].[MsProvider] Pr 
	              WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId )
		 END AS Proveedor 
      ,Year(Trn.TransactionDate) as AnioGasto 
	  ,CASE Month(Trn.TransactionDate) 
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
	   END AS MesGasto 
      ,Trn.TransactionDate AS FechaGasto 
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CRv.Name AS TipoTransaccion 
	  ,CR.Name AS SubTipoTransaccion 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR CAST(TrnD.NIT as bigint) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		 END AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,Trn.TypeIdc 
	  ,C2.[Name] as TipoMovimiento 
	  ,TrnD.IsTransfer
	  ,Case 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			Else TrnD.Amount 
	   END AS MontoTotal 
	  ,Account.Number AS NumeroCuenta 
	  ,Account.Name AS NombreCuenta 
  FROM MSFSystemVacio.[Accounting].[PsTransaction] Trn 
       INNER JOIN MSFSystemVacio.[Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr and CR.Id = Trn.SubTypeTransactionIdr 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
	   INNER JOIN MSFSystemVacio.[Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 

 UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
      ,Cmp.Name AS Distribuidor 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR cast(TrnD.NIT as bigint) = 0 THEN 'Proveedor no Definido'
			ELSE
			    (SELECT Pr.Name FROM MSFSystemVacio.[Purchases].[MsProvider] Pr 
	              WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId )
		 END AS Proveedor 
      ,Year(Trn.TransactionDate) AS AnioGasto 
	  ,CASE Month(Trn.TransactionDate) 
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
	   END AS MesGasto 
      ,Trn.TransactionDate AS FechaGasto
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CR.Name AS TipoTransaccion 
	  ,'Sin SubTipo' AS SubTipoTransaccion 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR CAST(TrnD.NIT as bigint) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		 END AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,Trn.TypeIdc 
	  ,C2.[Name] as TipoMovimiento 
	  ,TrnD.IsTransfer
	  ,Case 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			Else TrnD.Amount 
	   END AS MontoTotal 
	  ,'0000000000' AS NumeroCuenta 
	  ,'Cuenta NO DEFINIDA' AS NombreCuenta 
  FROM MSFSystemVacio.[Accounting].[PsTransaction] Trn 
       INNER JOIN MSFSystemVacio.[Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR ON CR.Id = Trn.TypeTransactionIdr 
 WHERE Trn.SubTypeTransactionIdr is null 
       AND TrnD.AccountId IS NULL 

UNION ALL 

SELECT Trn.CompanyId as IdDistribuidor 
      ,Cmp.Name as Distribuidor 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR cast(TrnD.NIT as bigint) = 0 THEN 'Proveedor no Definido'
			ELSE
			    (SELECT Pr.Name FROM MSFSystemVacio.[Purchases].[MsProvider] Pr 
	              WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId )
		 END AS Proveedor 
      ,Year(Trn.TransactionDate) as AnioGasto 
	  ,CASE Month(Trn.TransactionDate) 
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
	   END AS MesGasto 
      ,Trn.TransactionDate AS FechaGasto 
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CRv.Name AS TipoTransaccion 
	  ,CR.Name AS SubTipoTransaccion 
      ,CASE 
	        WHEN TrnD.NIT is NULL OR RTRIM(LTRIM(TrnD.NIT)) = '' OR CAST(TrnD.NIT as bigint) = 0 THEN 'S/N'
			ELSE TrnD.NIT 
		 END AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,Trn.TypeIdc 
	  ,C2.[Name] as TipoMovimiento 
	  ,TrnD.IsTransfer
	  ,Case 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN TrnD.DeductibleTotal
			Else TrnD.Amount 
	   END AS MontoTotal 
	  ,'0000000000' AS NumeroCuenta 
	  ,'Cuenta NO DEFINIDA' AS NombreCuenta 
  FROM MSFSystemVacio.[Accounting].[PsTransaction] Trn 
       INNER JOIN MSFSystemVacio.[Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trn.Id 
       INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Trn.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Trn.StatusIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = Trn.TypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR ON CR.RecursiveId = Trn.TypeTransactionIdr and CR.Id = Trn.SubTypeTransactionIdr 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CRv ON CRv.Id = Trn.TypeTransactionIdr 
 WHERE TrnD.AccountId IS NULL 
)
INSERT [PIVOT].[Pagos]
SELECT IdDistribuidor ,Distribuidor, Proveedor, AnioGasto, MesGasto, FechaGasto, Observacion, EstadoDocumento, TipoNombre, TipoTransaccion
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

