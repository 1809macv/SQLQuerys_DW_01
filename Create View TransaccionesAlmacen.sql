/****** Object:  View [PIVOT].[TransaccionesAlmacen]    Script Date: 2/10/2020 10:25:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [PIVOT].[TransaccionesAlmacen]
AS

WITH MovimientoAlmacen(DistribuidorId, Distribuidor, AlmacenId, Almacen, FechaTransaccion, ProductoId, ProductoCodigo, ProductoNombre, FactorConverion, 
                       NumeroLoteId, NumeroLote, TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto, 
					   TransaccionId ,TipoTransaccion ,TransactionTypeId ,TipoMovimiento, Cantidad)
AS
(
SELECT Cmp.Id as DistribuidorId 
      ,Cmp.[Name] as Distribuidor 
      ,Store.Id as AlmacenId 
      ,Store.[Name] as Almacen 
      ,CAST(THeader.TransactionDate as DATE) as FechaTransaccion 
      ,Product.Id as ProductoId 
      ,Product.Code as ProductoCodigo 
      ,Product.[Name] as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.Id as NumeroLoteId 
	  ,Batch.BachNumber as NumeroLote 
	  ,C1.[Name] as TipoLote 
	  ,C2.[Name] as Negocio 
	  ,C3.[Name] as Reclasificacion 
	  ,C4.[Name] as Segmento 
	  ,C5.[Name] as SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) as FechaExpiracion
      ,IsNull(Product.[Weight],0) as PesoNeto 
	  ,IsNull(Product.TotalWeight,0) as PesoBruto
	  ,THeader.Id as TransaccionId
	  ,TType.[Name] as TipoTransaccion
      ,THeader.TransactionTypeId 
	  ,CASE TType.Movement 
             WHEN 0 THEN 'Egreso'
             WHEN 1 THEN 'Ingreso'
        END as TipoMovimiento 
	  ,CASE TType.Movement 
             WHEN 0 THEN (TDetail.Quantity * -1)
             WHEN 1 THEN TDetail.Quantity
       END as Cantidad 
  FROM MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.Id = Product.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = THeader.StoreId 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id AND CUnit.ProductId = Product.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
 WHERE THeader.StatusIdc = 67 

UNION ALL 

SELECT Cmp.Id as DistribuidorId 
      ,Cmp.[Name] as Distribuidor 
      ,Store.Id as AlmacenId 
      ,Store.[Name] as Almacen 
      ,CAST(THeader.TransactionDate AS DATE) as FechaTransaccion 
      ,Product.Id as ProductoId 
      ,Product.Code as ProductoCodigo 
      ,Product.[Name] as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.Id as NumeroLoteId 
	  ,Batch.BachNumber as NumeroLote 
	  ,C1.[Name] as TipoLote 
	  ,C2.[Name] as Negocio 
	  ,C3.[Name] as Reclasificacion 
	  ,C4.[Name] as Segmento 
	  ,C5.[Name] as SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) as FechaExpiracion
      ,IsNull(Product.[Weight],0) as PesoNeto 
	  ,IsNull(Product.TotalWeight,0) as PesoBruto
	  ,THeader.Id as TransaccionId
	  ,TType.[Name] as TipoTransaccion
      ,THeader.TransactionTypeId 
	  ,'Ingreso' as TipoMovimiento 
	  ,TDetail.Quantity as Cantidad 
  FROM MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.Id = Product.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = THeader.StoreTargetId 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id AND CUnit.ProductId = Product.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
 WHERE THeader.StatusIdc = 67 
)
SELECT DistribuidorId
      ,Distribuidor
	  ,AlmacenId
	  ,Almacen
	  ,FechaTransaccion
	  ,ProductoId
	  ,Productocodigo
	  ,ProductoNombre
	  ,FactorConverion
	  ,NumeroLoteId
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
 WHERE DistribuidorId >= 3

GO


