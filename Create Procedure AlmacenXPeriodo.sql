USE [AVAMSFSystemVacioJLOPEZ16052018]
GO

/****** Object:  StoredProcedure [PIVOT].[AlmacenXPeriodo]    Script Date: 7/13/2018 3:16:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [PIVOT].[AlmacenXPeriodo]
AS
BEGIN

DECLARE @PeriodoInicial DATETIME = DATETIMEFROMPARTS(2018,6,1,0,0,0,0)
       ,@PeriodoFinal DATETIME = GETDATE()

--DECLARE @FechaInicial DATETIME
DECLARE @FechaFinal DATETIME
DECLARE @Periodos INTEGER
       ,@i INTEGER = 1

SET @Periodos = DATEDIFF(MONTH, @PeriodoInicial, @PeriodoFinal) + 1

TRUNCATE TABLE [PIVOT].StockXPeriodo

WHILE @i <= @Periodos
BEGIN

--SET @FechaInicial = DATEADD(MONTH, (@i * -1), @PeriodoInicial);
SET @FechaFinal = DATEADD(MONTH, (@i - 1), @PeriodoInicial);

WITH MovimientoAlmacen(DistribuidorId, Distribuidor, Almacen, FechaTransaccion, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, 
                       Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto, TipoTransaccionId, TipoMovimiento, Cantidad)
AS
(
Select Cmp.Id as DistribuidorId 
      ,Cmp.Name as Distribuidor 
      ,Store.Name as Almacen 
      ,THeader.TransactionDate as FechaTransaccion 
      ,Product.Code as ProductoCodigo 
      ,Product.Name as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.BachNumber as NumeroLote
	  ,C1.Name as TipoLote 
	  ,C2.Name as Negocio 
	  ,C3.Name as Reclasificacion 
	  ,C4.Name as Segmento 
	  ,C5.Name as SubRubro 
	  ,Batch.ExpirationDate as FechaExpiracion
      ,Product.Weight as PesoNeto 
	  ,Product.TotalWeight as PesoBruto
      ,THeader.TransactionTypeId 
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
 Where THeader.StatusIdc <> 127 

UNION ALL 

Select Cmp.Id as DistribuidorId 
      ,Cmp.Name as Distribuidor 
      ,Store.Name as Almacen 
      ,THeader.TransactionDate as FechaTransaccion 
      ,Product.Code as ProductoCodigo 
      ,Product.Name as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.BachNumber as NumeroLote
	  ,C1.Name as TipoLote 
	  ,C2.Name as Negocio 
	  ,C3.Name as Reclasificacion 
	  ,C4.Name as Segmento 
	  ,C5.Name as SubRubro 
	  ,Batch.ExpirationDate as FechaExpiracion
      ,Product.Weight as PesoNeto 
	  ,Product.TotalWeight as PesoBruto
      ,THeader.TransactionTypeId 
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
 Where THeader.StatusIdc <> 127 and THeader.StoreTargetId IS NOT NULL 
)
INSERT INTO [PIVOT].StockXPeriodo 
SELECT DistribuidorId
      ,Distribuidor
      ,Almacen 
	  ,@FechaFinal 
      ,ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, Negocio, Reclasificacion 
      ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
      ,SUM(Cantidad) as CantidadAlmacen
  FROM MovimientoAlmacen MA 
 WHERE FechaTransaccion < @FechaFinal      -- FechaTransaccion >= @FechaInicial and 
GROUP BY DistribuidorId, Distribuidor, Almacen, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, 
         TipoLote, Negocio, Reclasificacion,
         Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
HAVING SUM(Cantidad) <> 0 
UNION ALL
SELECT DistribuidorId
       ,Distribuidor
       ,Almacen 
	   ,@FechaFinal 
       ,ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, Negocio, Reclasificacion 
       ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
       ,SUM(Cantidad) as CantidadAlmacen
  FROM MovimientoAlmacen MA 
 WHERE CONVERT(DATE, FechaTransaccion) = @FechaFinal  and TipoTransaccionId = 7 
GROUP BY DistribuidorId, Distribuidor, Almacen, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, 
         TipoLote, Negocio, Reclasificacion,
         Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
HAVING SUM(Cantidad) <> 0 

SET @i = @i + 1

END -- del WHILE

END  -- del STORE PROCEDURE

;

GO


