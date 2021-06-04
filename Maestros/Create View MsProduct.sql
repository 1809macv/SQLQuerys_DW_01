CREATE VIEW [PIVOT].MsProduct 
AS

SELECT Product.Id
	  ,Product.CompanyId
	  ,Product.Code
	  ,Product.[Name]
	  ,Product.[Description]
	  ,Product.Cost
	  ,Product.IsCombo
	  ,Product.IsBase
	  ,IsNull(Product.ICELitre, 0) AS ICELitre 
	  ,IsNull(Product.Litre, 0) AS Litre
	  ,IsNull(Product.[Weight], 0) AS [Weight]
	  ,IsNull(Product.Volume, 0) AS Volume 
	  ,IsNull(Product.TotalWeight, 0) AS TotalWeight
	  ,IsNull(Product.Equivalence, 0) AS Equivalence 
	  ,Product.Active
	  ,C4.Name AS Negocio 
	  ,C5.Name AS Reclasificacion
	  ,C6.Name AS Segmento 
	  ,C7.Name AS SubRubro 
  FROM Warehouse.MsProduct Product
		INNER JOIN Warehouse.MsProductLine PLine ON PLine.Id = Product.ProductLineId  
		INNER JOIN Base.PsClassifier C4 ON C4.Id = PLine.BussinessIdc
		INNER JOIN Base.PsClassifier C5 ON C5.Id = PLine.ReclassificationIdc
		INNER JOIN Base.PsClassifier C6 ON C6.Id = PLine.SegmentIdc
		INNER JOIN Base.PsClassifier C7 ON C7.Id = PLine.SubcategoryIdc 

GO
