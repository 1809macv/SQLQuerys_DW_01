CREATE VIEW [PIVOT].RecompraXProducto_Select1
AS
SELECT DISTINCT Sale.CompanyId AS DistribuidorId
	  ,Cmp.[Name] AS Distribuidor 
	  ,C8.[Name] AS Ciudad 
	  ,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) AS FechaPeriodo
	  ,SDetail.ProductId AS ProductoId
	  ,Prd.Code AS ProductoCodigo 
	  ,Prd.[Name] AS ProductoNombre
	  ,C2.[Name] AS Negocio 
	  ,C3.[Name] AS Reclasificacion 
	  ,C4.[Name] AS Segmento 
	  ,C5.[Name] AS SubRubro 
  FROM [Sales].MsSale Sale 
		INNER JOIN [Sales].PsSaleDetail SDetail ON SDetail.SaleId = Sale.Id 
		INNER JOIN [Warehouse].MsProduct Prd ON Prd.Id = SDetail.ProductId 
		INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId AND PLine.Id = Prd.ProductLineId 
		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
		INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
		INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
		INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 
 WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3

GO
