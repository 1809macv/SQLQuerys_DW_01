------------------------------------------------------------

SET DATEFORMAT YMD
-- Numero de Días que procesara el Stock por Fecha desde el dia actual 
-- hacia atras ejemplo 5 dias, este parametro puede ser cambiado
DECLARE @NumeroDias INTEGER = -5
--Se inicializa los valores de la fecha inicial y fecha final del proceso
DECLARE @FechaInicial DATE = CAST(DATEADD(DAY, @NumeroDias,GETDATE()) as DATE)
       ,@FechaFinal DATE = CAST(GETDATE() as DATE)

DECLARE @FechaProceso DATE
DECLARE @Dias INTEGER
DECLARE @i INTEGER = 0

-- Se obtiene la diferencia de dias entre las 2 fecha
SET @Dias = DATEDIFF(DAY, @FechaInicial, @FechaFinal)

-- Se eliminan todos los registros desde la fecha inicial
DELETE [PIVOT].StockXFecha
WHERE FechaStock >= @FechaInicial

-- Inicio del bucle WHILE donde @i sea menor que le numero de dias
WHILE @i < @Dias
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
  From MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Product.CompanyId and PLine.Id = Product.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = THeader.StoreId 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Product.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
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
  From MSFSystemVacio.[Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Product.CompanyId and PLine.Id = Product.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = THeader.StoreTargetId 

	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Product.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
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

GO

