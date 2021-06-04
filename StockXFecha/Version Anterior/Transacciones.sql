WITH MovimientoAlmacen(DistribuidorId, Distribuidor, Almacen, FechaTransaccion, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, 
                       Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto, TransaccionId , TipoTransaccion, TipoMovimiento, Cantidad)
AS
(
Select Cmp.Id as DistribuidorId 
      ,Cmp.Name as Distribuidor 
      ,Store.Name as Almacen 
      ,CAST(THeader.TransactionDate as DATE) as FechaTransaccion 
      ,Product.Code as ProductoCodigo 
      ,Product.Name as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.BachNumber as NumeroLote
	  ,C1.Name as TipoLote 
	  ,C2.Name as Negocio 
	  ,C3.Name as Reclasificacion 
	  ,C4.Name as Segmento 
	  ,C5.Name as SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) as FechaExpiracion
      ,Product.Weight as PesoNeto 
	  ,Product.TotalWeight as PesoBruto
	  ,THeader.Id as TransaccionId
	  ,TType.[Name] as TipoTransaccion
	  ,CASE TType.Movement 
             WHEN 0 THEN 'Egreso'
             WHEN 1 THEN 'Ingreso'
        END as TipoMovimiento 
	  ,CASE TType.Movement 
             WHEN 0 THEN (TDetail.Quantity * -1)
             WHEN 1 THEN TDetail.Quantity
       END as Cantidad 
  From [Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN [Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN [Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Product.CompanyId and PLine.Id = Product.ProductLineId 
	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = THeader.StoreId 

	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Product.Id 
       INNER JOIN [Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
 Where THeader.StatusIdc = 67 

UNION ALL 

Select Cmp.Id as DistribuidorId 
      ,Cmp.Name as Distribuidor 
      ,Store.Name as Almacen 
      ,CAST(THeader.TransactionDate AS DATE) as FechaTransaccion 
      ,Product.Code as ProductoCodigo 
      ,Product.Name as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.BachNumber as NumeroLote
	  ,C1.Name as TipoLote 
	  ,C2.Name as Negocio 
	  ,C3.Name as Reclasificacion 
	  ,C4.Name as Segmento 
	  ,C5.Name as SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) as FechaExpiracion
      ,Product.Weight as PesoNeto 
	  ,Product.TotalWeight as PesoBruto
	  ,THeader.Id as TransaccionId
	  ,TType.[Name] as TipoTransaccion
	  ,'Ingreso' as TipoMovimiento 
	  ,TDetail.Quantity as Cantidad 
  From [Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN [Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN [Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Product.CompanyId and PLine.Id = Product.ProductLineId 
	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = THeader.StoreTargetId 

	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Product.Id 
       INNER JOIN [Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
 Where THeader.StatusIdc = 67 and THeader.StoreTargetId IS NOT NULL 
)
SELECT DistribuidorId
      ,Distribuidor
	  ,Almacen
	  ,FechaTransaccion
	  ,Productocodigo
	  ,ProductoNombre
	  ,FactorConverion
	  ,NumeroLote
	  ,TipoLote
	  ,Negocio
	  ,Reclasificacion
	  ,Segmento
	  ,SubRubro
	  ,FechaExpiracion
	  ,PesoNeto
	  ,PesoBruto
	  ,TransaccionId
	  ,TipoTransaccion
	  ,TipoMovimiento
	  ,Cantidad
  FROM MovimientoAlmacen MA 
-- WHERE FechaTransaccion <= @FechaProceso 
--GROUP BY DistribuidorId, Distribuidor, Almacen, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, 
--         TipoLote, Negocio, Reclasificacion,
--         Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
--HAVING SUM(Cantidad) <> 0 