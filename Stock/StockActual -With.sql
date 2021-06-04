
With StockAlmacen(IdDistribuidor, Distribuidor, Almacen, ProductoCodigo, ProductNombre, UnidadMedidaAlmacen, CantidadAlmacen, UnidadMedidaVenta, CantidadUnidadMenor, 
			FactorConverion, NumeroLote, TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto, CostoUC, CostoPPP )
AS (
SELECT Stock.CompanyId as IdDistribuidor
       ,Cmp.Name as Distribuidor 
       ,Store.Name as Almacen 
	   ,Prd.Code as ProductoCodigo 
       ,Prd.Name as ProductNombre 
	   ,(SELECT x.Name FROM [Base].[PsClassifier] x WHERE x.Id = CUnit.StorageUnitIdc) as UnidadMedidaAlmacen 
       ,Stock.Quantity as CantidadAlmacen   ---,round((1.00/CUnit.Equivalence),4) as Valor1 
	   ,(SELECT y.Name FROM [Base].[PsClassifier] y WHERE y.Id = CUnit.SaleUnitIdc) as UnidadMedidaVenta 
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
  FROM [Warehouse].[PsStock] Stock 
       INNER JOIN [Warehouse].[MsProduct] Prd ON Prd.Id = Stock.ProductId 
	   INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   LEFT JOIN [Warehouse].[PsStockCost] SCost ON SCost.CompanyId = Stock.CompanyId and SCost.ProductId = Stock.ProductId
	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Stock.CompanyId 
	   INNER JOIN [Warehouse].[PsBatch] Batch ON Batch.Id = Stock.BatchId 
	   INNER JOIN [Warehouse].[MsStore] Store ON Store.Id = Stock.StoreId 
	   INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Batch.BatchTypeIdc and C1.ClassifierTypeId = 27
	   INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc and C2.ClassifierTypeId = 6
	   INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc and C3.ClassifierTypeId = 8
	   INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc and C4.ClassifierTypeId = 9
	   INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc and C5.ClassifierTypeId = 10
	   INNER JOIN [Warehouse].[PsCompanyUnit] CUnit ON CUnit.CompanyId = Cmp.Id and CUnit.ProductId = Prd.Id 
 WHERE Stock.Quantity <> 0 and round(1.0000/CUnit.Equivalence,4) <= Stock.Quantity
	   and Stock.CompanyId >= 3
)
Select --round(1.0000/FactorConverion,4) as xxx, 
	   * from StockAlmacen 
Where ProductoCodigo = '1003786' and IdDistribuidor = 3 
