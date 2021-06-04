SELECT Cmp.Name AS Distribuidor   --, IsTransfer, IsDeductible  
	  ,isnull(
	   (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	     WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') AS Proveedor 
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
	  ,Day(Trn.TransactionDate) AS DiaGasto 
      ,Trn.TransactionDate AS FechaGasto
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CR.Name AS TipoTransaccion 
	  ,'Sin SubTipo' AS SubTipoTransaccion 
	  ,isnull(TrnD.NIT,'S/N') AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,CASE Trn.TypeIdc 
	        WHEN 85 THEN TrnD.Amount 
			WHEN 86 THEN ( TrnD.Amount * -1 )
			ELSE 
			    CASE WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 0 THEN ( TrnD.Amount * -1 )
				     WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 1 THEN TrnD.Amount
				END
	   END AS MontoTotal 
	  ,TrnD.DeductPercentage AS PorcentajeDeducible 
	  ,Case  
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN ( TrnD.DeductibleTotal * -1 ) 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 0) THEN ( TrnD.Amount * -1 ) 
			WHEN (Trn.TypeIdc = 92 and TrnD.IsTransfer = 0) THEN ( TrnD.Amount * -1 ) 
			Else TrnD.Amount 
	   END AS DeducibleTotal 
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
       AND Cmp.Id = 3 

UNION ALL 

SELECT Cmp.Name as Distribuidor 
	  ,isnull(
	   (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	     WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') AS Proveedor 
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
 	  ,Day(Trn.TransactionDate) AS DiaGasto 
      ,Trn.TransactionDate AS FechaGasto 
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CRv.Name AS TipoTransaccion 
	  ,CR.Name AS SubTipoTransaccion 
	  ,isnull(TrnD.NIT,'S/N') AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,CASE Trn.TypeIdc 
	        WHEN 85 THEN TrnD.Amount 
			WHEN 86 THEN ( TrnD.Amount * -1 )
			ELSE 
			    CASE WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 0 THEN ( TrnD.Amount * -1 )
				     WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 1 THEN TrnD.Amount
				END
	   END AS MontoTotal 
	  ,TrnD.DeductPercentage AS PorcentajeDeducible 
	  ,Case  
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN ( TrnD.DeductibleTotal * -1 ) 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 0) THEN ( TrnD.Amount * -1 ) 
			WHEN (Trn.TypeIdc = 92 and TrnD.IsTransfer = 0) THEN ( TrnD.Amount * -1 ) 
			Else TrnD.Amount 
	   END AS DeducibleTotal 
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
 WHERE Cmp.Id = 3 

 UNION ALL 

 SELECT Cmp.Name AS Distribuidor 
	  ,isnull(
	   (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	     WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') AS Proveedor 
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
	  ,Day(Trn.TransactionDate) AS DiaGasto 
      ,Trn.TransactionDate AS FechaGasto
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CR.Name AS TipoTransaccion 
	  ,'Sin SubTipo' AS SubTipoTransaccion 
	  ,isnull(TrnD.NIT,'S/N') AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,CASE Trn.TypeIdc 
	        WHEN 85 THEN TrnD.Amount 
			WHEN 86 THEN ( TrnD.Amount * -1 )
			ELSE 
			    CASE WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 0 THEN ( TrnD.Amount * -1 )
				     WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 1 THEN TrnD.Amount
				END
	   END AS MontoTotal 
	  ,TrnD.DeductPercentage AS PorcentajeDeducible 
	  ,Case  
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN ( TrnD.DeductibleTotal * -1 ) 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 0) THEN ( TrnD.Amount * -1 ) 
			WHEN (Trn.TypeIdc = 92 and TrnD.IsTransfer = 0) THEN ( TrnD.Amount * -1 ) 
			Else TrnD.Amount 
	   END AS DeducibleTotal 
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
	   AND Cmp.Id = 3 

UNION ALL 

SELECT Cmp.Name as Distribuidor 
	  ,isnull(
	   (SELECT Pr.Name FROM [Purchases].[MsProvider] Pr 
	     WHERE Pr.NIT = TrnD.NIT and Pr.CompanyId = Trn.CompanyId and Pr.Nit <> '0'),'Proveedor no Definido') AS Proveedor 
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
 	  ,Day(Trn.TransactionDate) AS DiaGasto 
      ,Trn.TransactionDate AS FechaGasto 
	  ,Trn.Detail AS Observacion
	  ,C1.Name AS EstadoDocumento 
	  ,C2.Name AS TipoNombre 
	  ,CRv.Name AS TipoTransaccion 
	  ,CR.Name AS SubTipoTransaccion 
	  ,isnull(TrnD.NIT,'S/N') AS NumeroNIT 
	  ,TrnD.AuthorizationNumber AS AutorizacionNumero
	  ,TrnD.InvoiceNumber AS NumeroFactura
	  ,TrnD.ControlCode AS CodigoControl
	  ,CASE Trn.TypeIdc 
	        WHEN 85 THEN TrnD.Amount 
			WHEN 86 THEN ( TrnD.Amount * -1 )
			ELSE 
			    CASE WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 0 THEN ( TrnD.Amount * -1 )
				     WHEN Trn.TypeIdc = 92 and TrnD.IsTransfer = 1 THEN TrnD.Amount
				END
	   END AS MontoTotal 
	  ,TrnD.DeductPercentage AS PorcentajeDeducible 
	  ,Case 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 1) THEN ( TrnD.DeductibleTotal * -1 ) 
	        WHEN (Trn.TypeIdc = 86 and TrnD.IsDeductible = 0) THEN ( TrnD.Amount * -1 ) 
			WHEN (Trn.TypeIdc = 92 and TrnD.IsTransfer = 0) THEN ( TrnD.Amount * -1 ) 
			Else TrnD.Amount 
	   END AS DeducibleTotal 
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
       AND Cmp.Id = 3 