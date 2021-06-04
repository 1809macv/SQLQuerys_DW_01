------------------------------------------------------------

USE [MSFSystemVacio]
GO

/****** Object:  StoredProcedure [PIVOT].[spStockXFecha2]    Script Date: 7/13/2018 3:16:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [PIVOT].[spStockXFecha2]
AS
BEGIN

SET DATEFORMAT YMD
-- Numero de Días que procesara el Stock por Fecha desde el dia actual 
-- hacia atras ejemplo 5 dias, este parametro puede ser cambiado
DECLARE @NumeroDias INTEGER = -5
--Se inicializa los valores de la fecha inicial y fecha final del proceso
DECLARE @FechaInicial DATE = CAST(DATEADD(DAY, @NumeroDias,GETDATE()) as DATE)
       ,@FechaFinal DATE = CAST(GETDATE() as DATE)

DECLARE @FechaProceso DATE
--DECLARE @Dias INTEGER
DECLARE @i INTEGER = 0

-- Se obtiene la diferencia de dias entre las 2 fecha
--SET @Dias = DATEDIFF(DAY, @FechaInicial, @FechaFinal)

-- Se eliminan todos los registros desde la fecha inicial
DELETE [PIVOT].StockXFecha
WHERE FechaStock >= @FechaInicial

-- Inicio del bucle WHILE donde @i sea menor que le numero de dias
WHILE @i < @NumeroDias
BEGIN

-- Se inicializa la fecha que se obbtendra el stock
SET @FechaProceso = DATEADD(DAY, @i, @FechaInicial);
-- El stock es del final del dia
WITH MovimientoAlmacen(DistribuidorId, Distribuidor, Almacen, FechaTransaccion, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, 
                       Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto, TransactionTypeId , TipoMovimiento, Cantidad)
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
 Where THeader.StatusIdc <> 127 --and THeader.StoreTargetId IS NOT NULL 
)
INSERT INTO [PIVOT].StockXFecha 
SELECT DistribuidorId
      ,Distribuidor
      ,Almacen 
	  ,YEAR(@FechaProceso) 
	  ,case Month(@FechaProceso) 
	        when 1 then '01. Enero'
	        when 2 then '02. Febrero'
	        when 3 then '03. Marzo'
	        when 4 then '04. Abril'
	        when 5 then '05. Mayo'
	        when 6 then '06. Junio'
	        when 7 then '07. Julio'
	        when 8 then '08. Agosto'
	        when 9 then '09. Septiembre'
	        when 10 then '10. Octubre'
	        when 11 then '11. Noviembre'
	        when 12 then '12. Diciembre'
	   end
	  ,@FechaProceso
      ,ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, TipoLote, Negocio, Reclasificacion 
      ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
      ,SUM(Cantidad) as CantidadAlmacen
  FROM MovimientoAlmacen MA 
 WHERE FechaTransaccion <= @FechaProceso 
GROUP BY DistribuidorId, Distribuidor, Almacen, ProductoCodigo, ProductoNombre, FactorConverion, NumeroLote, 
         TipoLote, Negocio, Reclasificacion,
         Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
HAVING SUM(Cantidad) <> 0 

-- Se incrementa en una unidad o dia
SET @i = @i + 1

END -- del WHILE

END  -- del STORE PROCEDURE

GO


