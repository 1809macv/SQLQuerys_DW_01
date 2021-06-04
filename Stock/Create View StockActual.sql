/****** Object:  View [PIVOT].[StockActual]    Script Date: 2/10/2020 10:26:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [PIVOT].[StockActual]
AS
SELECT Stock.CompanyId AS IdDistribuidor
       ,Cmp.[Name] AS Distribuidor 
	   ,Store.Id AS IdAlmacen 
       ,Store.[Name] AS Almacen 
	   ,Prd.Id AS IdProducto 
	   ,Prd.Code AS ProductoCodigo 
       ,Prd.[Name] AS ProductNombre 
	   ,(SELECT x.[Name] FROM [Base].[PsClassifier] x WHERE x.Id = CUnit.StorageUnitIdc) AS UnidadMedidaAlmacen 
       ,Stock.Quantity AS CantidadAlmacen 
	   ,(SELECT y.[Name] FROM [Base].[PsClassifier] y WHERE y.Id = CUnit.SaleUnitIdc) AS UnidadMedidaVenta 
	   ,ROUND((Stock.Quantity * CUnit.Equivalence),0) AS CantidadUnidadMenor
	   ,CUnit.Equivalence AS FactorConverion
	   ,Batch.BachNumber AS NumeroLote
	   ,C1.[Name] AS TipoLote 
	   ,C2.[Name] AS Negocio 
	   ,C3.[Name] AS Reclasificacion 
	   ,C4.[Name] AS Segmento 
	   ,C5.[Name] AS SubRubro 
	   ,Batch.ExpirationDate AS FechaExpiracion
	   ,Cast((Stock.Quantity * IsNull(Prd.[Weight], 0)) AS Decimal(18,4)) AS PesoNeto 
	   ,Cast((Stock.Quantity * IsNull(Prd.TotalWeight, 0)) AS Decimal(18,4)) AS PesoBruto 
	   ,IsNull(SCost.Cost,0) AS CostoUC 
	   ,IsNull(SCost.Ppp,0) AS CostoPPP
  FROM [Warehouse].[PsStock] Stock 
       INNER JOIN [Warehouse].[MsProduct] Prd ON Prd.Id = Stock.ProductId 
	   INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.Id = Prd.ProductLineId 
	   LEFT JOIN [Warehouse].[PsStockCost] SCost ON SCost.CompanyId = Stock.CompanyId AND SCost.ProductId = Stock.ProductId
	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Stock.CompanyId 
	   INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = Stock.BatchId 
	   INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = Stock.StoreId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc AND C1.ClassifierTypeId = 27
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc AND C2.ClassifierTypeId = 6
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc AND C3.ClassifierTypeId = 8
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc AND C4.ClassifierTypeId = 9
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc AND C5.ClassifierTypeId = 10
	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id AND CUnit.ProductId = Prd.Id 
 WHERE Stock.Quantity <> 0 AND Round(1.0000000000000000/CUnit.Equivalence, 16) <= Stock.Quantity
	   AND Stock.CompanyId >= 3

GO


