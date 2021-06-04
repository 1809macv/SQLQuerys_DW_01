-- Total registros 3096
-- Total registros periodo Marzo-2021 = 2112
-- Total registros con la condicion "Trans.TypeIdc in (86, 92)" => 15
select * from [Accounting].Pstransaction Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trans.CompanyId 
INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trans.StatusIdc 
INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trans.TypeIdc 
INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TransD.AccountId 
INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trans.TypeTransactionIdr 
where Trans.CompanyId = 14 and Trans.TransactionDate >= '2021/03/01' and Trans.SubTypeTransactionIdr is null
	and Trans.TypeIdc in (86, 92)

-- Total registros => 190
select * from [Accounting].Pstransaction Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
where Trans.CompanyId = 14 and Trans.TransactionDate >= '2021/03/01' and Trans.SubTypeTransactionIdr is null
	 and TransD.Amount = 0   -- and Trans.TypeIdc in (85)


-- 519, 547
-- Total Registros => 357
select Trans.TransactionDate, Payment.PaymentDate, Trans.Number, Sale.Number, TrnD.Number, 
	TrnD.Amount, Payment.Amount, RP.Quantity, Sale.Total, Trans.StatusIdc 
from [Accounting].Pstransaction Trans
		INNER JOIN [Accounting].[PsTransactionDetail] TrnD ON TrnD.TransactionId = Trans.Id 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Trans.CompanyId 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Trans.StatusIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = Trans.TypeIdc 
		INNER JOIN [Base].[PsClassifierRecursive] CR ON CR.Id = Trans.TypeTransactionIdr 
		INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TrnD.AccountId 
		INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trans.Id
		INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
		INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
		INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
where Trans.CompanyId = 14 and Trans.TransactionDate >= '2021/03/01' and Trans.SubTypeTransactionIdr is null
	and Trans.TypeIdc in (85) and TrnD.Amount != 0  --and Sale.TransactionId is not null  -- RP.Quantity > 0
	and Trans.TransactionDate < '2021/03/24' ---and Payment.PaymentDate < '2021/03/24'
order by Sale.Number, Trans.TransactionDate, Payment.PaymentDate 



-- Total Registros 2695
-- Total registros periodo Marzo-2021 => 1934
-- Diferencia -178 registros
select * from [PIVOT].[Pagos] Pagos
where IdDistribuidor = 14 and FechaGasto >= '2021/03/01'


select * from [Base].[PsClassifier]
--where id = 86
order by 4


select * from [Base].[PsClassifier]
where ClassifierTypeId = 36



select * from [Sales].[MsSale]
where CompanyId = 14 and SaleDate >= '2021/03/01'


-- Total registros 1568
SELECT Trans.CompanyId as IdDistribuidor 
		,Cmp.Name AS Distribuidor 
		,Sale.CustomerName as Proveedor 
		,convert(DATE,Trans.TransactionDate) AS FechaGasto
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
 WHERE Sale.CompanyId = 14 and Trans.TransactionDate >= '2021/03/01' and Trans.TransactionDate < '2021/03/24'
 order by Sale.Number


select * from [Base].[PsClassifierRecursive]
order by 4
