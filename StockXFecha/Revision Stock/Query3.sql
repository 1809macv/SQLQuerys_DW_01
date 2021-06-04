select * from [Warehouse].MsStoreTransaction Trans
inner join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
where CompanyId = 3 and StoreId = 6 and TransD.ProductId = 468 and Trans.TransactionDate < '2021/03/16'
order by Trans.TransactionDate

select * from [Warehouse].MsStoreTransaction Trans
left join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
where CompanyId = 3 and StoreId = 6 and TransD.ProductId = 468 and Trans.TransactionDate < '2021/03/16'
		and TransD.StoreTransactionId is null
order by Trans.TransactionDate

select * from [Warehouse].MsStoreTransaction Trans
right join [Warehouse].PsStoreTransactionDetail TransD ON TransD.StoreTransactionId = Trans.Id
where CompanyId = 3 and StoreId = 6 and TransD.ProductId = 468 and Trans.TransactionDate < '2021/03/16'
		and Trans.Id is null
order by Trans.TransactionDate
