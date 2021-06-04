USE [MSFSystemVacio]
GO

DROP TABLE [PIVOT].StockXFecha
GO

CREATE TABLE [PIVOT].StockXFecha
(
	DistribuidorId bigint NULL, 
	Distribuidor varchar(255) NULL, 
	AlmacenId bigint NULL, 
	Almacen varchar(100) NULL, 
	AnioStock integer NULL, 
	MesStock varchar(80) NULL, 
	FechaStock date NULL, 
	ProductoId bigint NULL, 
	ProductoCodigo varchar(50) NULL, 
	ProductoNombre varchar(255) NULL, 
	FactorConversion smallint NULL, 
	NumeroLoteId bigint NULL, 
	NumeroLote varchar(50) NULL, 
	TipoLote varchar(255) NULL, 
	Negocio varchar(255) NULL, 
	Reclasificacion varchar(255) NULL, 
	Segmento varchar(255) NULL, 
	SubRubro varchar(255) NULL, 
	FechaExpiracion date NULL, 
	PesoNeto decimal(18,7) NULL, 
	PesoBruto decimal(18,7) NULL, 
	Cantidad decimal(18,4) NULL 
) ON [Primary] 


------------------------------------------------------------

USE [MSFSystem_Cube]
GO

/****** Object:  StoredProcedure [PIVOT].[AlmacenXPeriodo]    Script Date: 7/13/2018 3:16:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [PIVOT].[spStockXFecha]
AS
BEGIN

SET DATEFORMAT YMD
DECLARE @FechaInicial DATE = DATEFROMPARTS(2018,6,1)
       ,@FechaFinal DATE = CAST(GETDATE() as DATE)

DECLARE @FechaProceso DATE
DECLARE @Dias INTEGER
       ,@i INTEGER = 0

SET @Dias = DATEDIFF(DAY, @FechaInicial, @FechaFinal)

TRUNCATE TABLE [PIVOT].StockXFecha

WHILE @i < @Dias
BEGIN

SET @FechaProceso = DATEADD(DAY, @i, @FechaInicial);

WITH MovimientoAlmacen(DistribuidorId ,Distribuidor ,AlmacenId ,Almacen ,FechaTransaccion ,ProductoId ,ProductoCodigo ,ProductoNombre 
                      ,FactorConverion ,NumeroLoteId ,NumeroLote ,TipoLote ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,FechaExpiracion 
					  ,PesoNeto ,PesoBruto ,TransactionTypeId ,TipoMovimiento ,Cantidad )
AS
(
Select Cmp.Id AS DistribuidorId 
      ,Cmp.Name AS Distribuidor 
	  ,Store.Id AS AlmacenId
      ,Store.Name AS Almacen 
      ,CAST(THeader.TransactionDate AS DATE) AS FechaTransaccion 
	  ,Product.Id AS ProductoId 
      ,Product.Code AS ProductoCodigo 
      ,Product.Name as ProductoNombre 
	  ,CUnit.Equivalence as FactorConverion
	  ,Batch.Id as NumeroLoteId 
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
 Where THeader.StatusIdc = 67 

UNION ALL 

Select Cmp.Id AS DistribuidorId 
      ,Cmp.Name AS Distribuidor 
	  ,Store.Id AS AlmacenId
      ,Store.Name AS Almacen 
      ,CAST(THeader.TransactionDate AS DATE) AS FechaTransaccion 
	  ,Product.Id AS ProductoId 
      ,Product.Code AS ProductoCodigo 
      ,Product.Name AS ProductoNombre 
	  ,CUnit.Equivalence AS FactorConverion 
	  ,Batch.Id AS NumeroLoteId 
	  ,Batch.BachNumber AS NumeroLote
	  ,C1.Name AS TipoLote 
	  ,C2.Name AS Negocio 
	  ,C3.Name AS Reclasificacion 
	  ,C4.Name AS Segmento 
	  ,C5.Name AS SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) AS FechaExpiracion
      ,Product.Weight AS PesoNeto 
	  ,Product.TotalWeight AS PesoBruto 
      ,THeader.TransactionTypeId 
	  ,'Ingreso' AS TipoMovimiento 
	  ,TDetail.Quantity AS Cantidad 
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
 Where THeader.StatusIdc = 67 --and THeader.StoreTargetId IS NOT NULL 
)
INSERT INTO [PIVOT].[StockXFecha] 
SELECT DistribuidorId
      ,Distribuidor
	  ,AlmacenId 
      ,Almacen 
	  ,YEAR(@FechaProceso) 
	  ,CASE Month(@FechaProceso) 
	        WHEN 1 THEN '01. Enero'
	        WHEN 2 THEN '02. Febrero'
	        WHEN 3 THEN '03. Marzo'
	        WHEN 4 THEN '04. Abril'
	        WHEN 5 THEN '05. Mayo'
	        WHEN 6 THEN '06. Junio'
	        WHEN 7 THEN '07. Julio'
	        WHEN 8 THEN '08. Agosto'
	        WHEN 9 THEN '09. Septiembre'
	        WHEN 10 THEN '10. Octubre'
	        WHEN 11 THEN '11. Noviembre'
	        WHEN 12 THEN '12. Diciembre'
	   END
	  ,@FechaProceso ,ProductoId 
      ,ProductoCodigo ,ProductoNombre ,FactorConverion ,NumeroLoteId ,NumeroLote 
	  ,TipoLote ,Negocio ,Reclasificacion 
      ,Segmento ,SubRubro ,FechaExpiracion ,PesoNeto ,PesoBruto 
      ,SUM(Cantidad) AS CantidadAlmacen 
  FROM MovimientoAlmacen MA 
 WHERE FechaTransaccion <= @FechaProceso 
GROUP BY DistribuidorId, Distribuidor ,AlmacenId ,Almacen ,ProductoId ,ProductoCodigo, ProductoNombre, FactorConverion
        ,NumeroLoteId ,NumeroLote ,TipoLote, Negocio, Reclasificacion
		,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
HAVING SUM(Cantidad) <> 0 

SET @i = @i + 1

END -- del WHILE

END  -- del STORE PROCEDURE

GO


