--Febrero-21 Cantidad de Registros ==>  976
--Marzo 21   Cantidad de Registros ==> 2304
--  Actualizado al 29/03/2021 Cantidad de Registros ==> 2622
select --sum(TransD.Amount), count(*)
 *
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
where Trans.TransactionDate >= '2021/03/01' and Trans.TransactionDate < '2021/03/28' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80 

-- Febrero - 2021
-- Registros => 779 INNER JOIN [Accounting].[PsPayment]
-- Registros => 788 INNER JOIN [Accounting].[psReceivablePayment]
-- Marzo - 2021
-- Registros => 559 INNER JOIN [Accounting].[PsPayment]
-- Registros => 587 INNER JOIN [Accounting].[psReceivablePayment]
-- Actualizacion al 29/03/2021
-- Registros => 613 INNER JOIN [Accounting].[PsPayment]
-- Registros => 641 INNER JOIN [Accounting].[psReceivablePayment]
select --sum(TransD.Amount), count(*)
 *
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trans.Id
INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
--INNER JOIN [Accounting].[MsReceivable] Receivable on Receivable.Id = RP.ReceivableId 
--INNER JOIN [Sales].[MsSale] Sale on Sale.Id = Receivable.SaleId
--INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TransD.AccountId 
where Trans.TransactionDate >= '2021/03/01' and Trans.TransactionDate < '2021/03/28' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80 
	--and Payment.Id in (15967,15968,16043,16044,16121,16474)

/*
Febrero - 2021 Cantidad de Registros =>  196
Marzo - 2021   Cantidad de Registros => 1732
Actualizado al 29/03/2021
    Cantidad de Registros => 1996
*/
select --sum(TransD.Amount), count(*)
 *
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
INNER JOIN [Sales].[MsSale] Sale ON Sale.TransactionId = Trans.Id
INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TransD.AccountId 
where Trans.TransactionDate >= '2021/03/01' and Trans.TransactionDate < '2021/03/28' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80


-- Febrero - 2021 Cantidad de Registros =>  1
-- Marzo - 2021   Cantidad de Registros => 13
select Trans.*, TransD.* 
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
LEFT JOIN [Sales].[MsSale] Sale ON Sale.TransactionId = Trans.Id
LEFT JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trans.Id
where Trans.TransactionDate >= '2021/03/01' and Trans.TransactionDate < '2021/03/28' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80 
	and Payment.Id is Null and Sale.Id Is Null


/*
Registros Duplicados Payment.Id => 15967,15968,16043,16044,16121,16474
*/
select Payment.Id, count(*)
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
INNER JOIN [Accounting].[MsAccount] Account ON Account.Id = TransD.AccountId 
INNER JOIN [Accounting].[PsPayment] Payment on Payment.TransactionId = Trans.Id
INNER JOIN [Accounting].[psReceivablePayment] RP on RP.PaymentId = Payment.Id 
where Trans.TransactionDate >= '2021/02/01' and Trans.TransactionDate < '2021/03/01' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80 
	--and Payment.Id Is Null
group by Payment.Id
having count(*) > 1



select Trans.Id, count(*) from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
where Trans.TransactionDate >= '2021/02/01' and Trans.TransactionDate < '2021/03/01' and Trans.TypeIdc = 85 
	and Trans.CompanyId = 14 and Trans.StatusIdc = 80
group by Trans.Id
having count(*) > 1



----------------------------------------------------------------------------------
-- Los egresos cuadran 426029.54 al <= 24/05/2021

----------------------------------------------------------------------------------
select sum(TransD.Amount)
--* 
from [Accounting].[PsTransaction] Trans
inner join [Accounting].[PsTransactionDetail] TransD ON TransD.TransactionId = Trans.Id
where  TypeIdc = 86 and CompanyId = 14
