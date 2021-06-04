select * from [Warehouse].MsStoreTransaction Trans
inner join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
inner join [Sales].[MsSale] Sale ON Sale.StoreTransactionId = Trans.Id
where Trans.CompanyId = 3 and Trans.StoreId = 6 and TransD.ProductId = 507 and Trans.TransactionDate < '2021/03/14' 
order by Trans.TransactionDate

select Trans.*, TransD.* from [Warehouse].MsStoreTransaction Trans
inner join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
left join [Sales].[MsSale] Sale ON Sale.StoreTransactionId = Trans.Id
where Trans.CompanyId = 3 and Trans.StoreId = 6 and TransD.ProductId = 507 and Trans.TransactionDate < '2021/03/14'
		and Sale.StoreTransactionId is null
order by Trans.TransactionDate

select * from [Warehouse].MsStoreTransaction Trans
inner join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
inner join [Warehouse].[psStoreTransactionDetailStock] TransDStock ON TransDStock.StoreTransactionDetailId = TransD.Id
where Trans.CompanyId = 3 and Trans.StoreId = 6 and TransD.ProductId = 464 and Trans.TransactionDate < '2021/03/14' 
		and BatchId = 5689
order by Trans.TransactionDate
