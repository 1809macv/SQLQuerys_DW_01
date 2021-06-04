WITH ProductCreate(ProductId, BatchId, StockId, CompanyId, DateCreateProduct) 
AS ( 
SELECT TDetail.ProductId, TDetail.BatchId, TDStock.StockId 
      ,Trans.CompanyId, CONVERT(DATE, min(Trans.TransactionDate )) as DateCreateProduct 
  FROM [Warehouse].[MsStoreTransaction] Trans 
       INNER JOIN [Warehouse].[PsStoreTransactionDetail] TDetail ON TDetail.StoreTransactionId = Trans.Id 
       INNER JOIN [Warehouse].[psStoreTransactionDetailStock] TDStock ON TDStock.StoreTransactionDetailId = TDetail.Id 
 WHERE Trans.StatusIdc = 67 
 GROUP BY TDetail.ProductId, TDetail.BatchId, TDStock.StockId, Trans.CompanyId 
HAVING min(Trans.TransactionDate) < '" + strFecha + " 00:00:00' 

UNION ALL 

SELECT TDetail.ProductId, TDetail.BatchId, TDStock.StockId 
      ,Trans.CompanyId, CONVERT(DATE, min(Trans.TransactionDate )) as DateCreateProduct 
  FROM [Warehouse].[MsStoreTransaction] Trans 
       INNER JOIN [Warehouse].[PsStoreTransactionDetail] TDetail ON TDetail.StoreTransactionId = Trans.Id 
       INNER JOIN [Warehouse].[psStoreTransactionDetailStock] TDStock ON TDStock.StoreTransactionDetailId = TDetail.Id 
 WHERE Trans.TransactionTypeId = 7  and Trans.StatusIdc = 67 
GROUP BY TDetail.ProductId, TDetail.BatchId, TDStock.StockId, Trans.CompanyId 
HAVING convert(date,min(Trans.TransactionDate)) = '" + strFecha + "' 
) 
SELECT Comp.Name as Distribuidor 
      ,Store.Name as Almacen 
	  ,Prod.Code as PorductoCodigo 
	  ,Prod.Name as ProductoNombre 
	  ,Batch.BachNumber as NumeroLote
      ,ProductCreate.DateCreateProduct as FechaCreacionLote 
	  ,(SELECT x.Name FROM [Base].[PsClassifier] x WHERE x.Id = CUnit.StorageUnitIdc) as UnidadMedidaAlmacen 
      ,Stock.Quantity as CantidadAlmacen 
	  ,(SELECT y.Name FROM [Base].[PsClassifier] y WHERE y.Id = CUnit.SaleUnitIdc) as UnidadMedidaVenta 
      ,C1.Name as TipoLote ,C2.Name as Negocio 
	  ,C3.Name as Reclasificacion ,C4.Name as Segmento 
	  ,C5.Name as SubCategoria 
	  ,Batch.ExpirationDate as FechaExpiracion
      ,Prod.Weight as PesoNeto 
	  ,Prod.TotalWeight as PesoBruto 
      ,isnull((SELECT SUM(CASE TType.Movement WHEN 0 THEN TrD.Quantity ELSE (TrD.Quantity * -1) 
                          END) 
                 FROM [Warehouse].[PsStoreTransactionDetail] TrD 
                      INNER JOIN [Warehouse].[MsStoreTransaction] Tr ON Tr.Id = TrD.StoreTransactionId 
                      INNER JOIN [Warehouse].[PsTransactionType] TType ON TType.Id = Tr.TransactionTypeId 
                WHERE TrD.ProductId = Stock.ProductId and TrD.BatchId = Stock.BatchId and Tr.CompanyId = Stock.CompanyId and Tr.StoreId = Stock.StoreId 
                      and Tr.TransactionDate >= '" + strFecha + " 00:00:00' and Tr.TransactionTypeId <> 7 and Tr.StatusIdc <> 127),0) as CantidadMovida 
      ,Stock.ProductId, Stock.BatchId 
  FROM [Warehouse].[PsStock] Stock 
       INNER JOIN ProductCreate ON Stock.ProductId = ProductCreate.ProductId and Stock.BatchId = ProductCreate.BatchId 
	                               and Stock.Id = ProductCreate.StockId 
                                   and Stock.CompanyId = ProductCreate.CompanyId 
       INNER JOIN [Warehouse].[MsProduct] Prod ON Prod.Id = Stock.ProductId 
       INNER JOIN [Base].[MsCompany] Comp ON Comp.Id = Stock.CompanyId 
       INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = Stock.StoreId 
       INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = Stock.BatchId 
       INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Prod.CompanyId and CUnit.ProductId = Prod.ProductLineId 
       INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prod.CompanyId and PLine.Id = Prod.ProductLineId 
       INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
       INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
       INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
       INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
       INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 
    