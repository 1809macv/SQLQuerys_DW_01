/****** Object:  View [PIVOT].[TransaccionesAlmacen]    Script Date: 31/03/2022 9:24:33 ******/
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


ALTER VIEW [PIVOT].[TransaccionesAlmacen]
WITH SCHEMABINDING
AS

SELECT Cmp.Id AS DistribuidorId 
      ,Cmp.[Name] AS Distribuidor 
      ,Store.Id AS AlmacenId 
      ,Store.[Name] AS Almacen 
      ,CAST(THeader.TransactionDate AS DATE) AS FechaTransaccion 
      ,Product.Id AS ProductoId 
      ,Product.Code AS ProductoCodigo 
      ,Product.[Name] AS ProductoNombre 
	  ,CASE WHEN TDetail.Equivalence = 0 then 
				IsNull((SELECT TOP 1 Equivalence FROM [Warehouse].[PsCompanyUnit]
						 WHERE CompanyId = THeader.CompanyId AND ProductId = TDetail.ProductId),1)
			ELSE TDetail.Equivalence
	   END AS FactorConverion
	  ,Batch.Id AS NumeroLoteId 
	  ,Batch.BachNumber AS NumeroLote 
	  ,C1.[Name] AS TipoLote 
	  ,C2.[Name] AS Negocio 
	  ,C3.[Name] AS Reclasificacion 
	  ,C4.[Name] AS Segmento 
	  ,C5.[Name] AS SubRubro 
	  ,CONVERT(DATE, Batch.ExpirationDate) AS FechaExpiracion
      ,IsNull(Product.[Weight], 0) AS PesoNeto 
	  ,IsNull(Product.TotalWeight,0) AS PesoBruto
	  ,THeader.Id AS TransaccionId
	  ,TType.[Name] AS TipoTransaccion
      ,THeader.TransactionTypeId 
	  ,CASE TType.Movement 
             WHEN 0 THEN 'Egreso'
             WHEN 1 THEN 'Ingreso'
        END AS TipoMovimiento 
	  ,CASE TType.Movement 
             WHEN 0 THEN (TDetail.Quantity * -1)
             WHEN 1 THEN TDetail.Quantity
       END AS Cantidad 
  FROM [Warehouse].[PsStoreTransactionDetail] TDetail
       INNER JOIN [Warehouse].[MsStoreTransaction] THeader ON THeader.Id = TDetail.StoreTransactionId 
       INNER JOIN [Warehouse].[MsProduct] Product ON Product.Id = TDetail.ProductId 
       INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = TDetail.BatchId 
       INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.Id = Product.ProductLineId 
	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = THeader.CompanyId 
       INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = THeader.StoreId 

	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc 
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 

	   INNER JOIN [Warehouse].[PsTransactionType] TType ON TType.Id = THeader.TransactionTypeId 
 WHERE THeader.CompanyId >= 3 AND THeader.StatusIdc = 67 


GO


