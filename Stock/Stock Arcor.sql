CREATE VIEW [PIVOT].StockActual
AS

SELECT Stock.CompanyId as IdDistribuidor
       ,Cmp.Name as Distribuidor 
       ,Store.Name as Almacen 
	   ,Prd.Code as ProductoCodigo 
       ,Prd.Name as ProductNombre 
	   ,(SELECT x.Name FROM MSFSystemVacio.[Base].[PsClassifier] x WHERE x.Id = CUnit.StorageUnitIdc) as UnidadMedidaAlmacen 
       ,Stock.Quantity as CantidadAlmacen 
	   ,(SELECT y.Name FROM MSFSystemVacio.[Base].[PsClassifier] y WHERE y.Id = CUnit.SaleUnitIdc) as UnidadMedidaVenta 
	   ,(Stock.Quantity * CUnit.Equivalence) as CantidadUnidadMenor
	   ,CUnit.Equivalence as FactorConverion
	   ,Batch.BachNumber as NumeroLote
	   ,C1.Name as TipoLote 
	   ,C2.Name as Negocio 
	   ,C3.Name as Reclasificacion 
	   ,C4.Name as Segmento 
	   ,C5.Name as SubRubro 
	   ,Batch.ExpirationDate as FechaExpiracion
	   ,(Stock.Quantity * Prd.Weight) as PesoNeto 
	   ,(Stock.Quantity * Prd.TotalWeight) as PesoBruto 
	   ,isnull(SCost.Cost,0) as CostoUC 
	   ,isnull(SCost.Ppp,0) as CostoPPP
  FROM MSFSystemVacio.[Warehouse].[PsStock] Stock 
       INNER JOIN MSFSystemVacio.[Warehouse].[MsProduct] Prd ON Prd.Id = Stock.ProductId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   LEFT JOIN MSFSystemVacio.[Warehouse].[PsStockCost] SCost ON SCost.CompanyId = Stock.CompanyId and SCost.ProductId = Stock.ProductId
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Stock.CompanyId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsBatch] Batch ON Batch.Id = Stock.BatchId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsStore] Store ON Store.Id = Stock.StoreId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc and C1.ClassifierTypeId = 27
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc and C2.ClassifierTypeId = 6
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc and C3.ClassifierTypeId = 8
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc and C4.ClassifierTypeId = 9
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc and C5.ClassifierTypeId = 10
	   INNER JOIN MSFSystemVacio.[Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 
 WHERE Stock.Quantity <> 0 and Stock.CompanyId >= 3

