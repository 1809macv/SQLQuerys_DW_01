CREATE VIEW [PIVOT].MsStore 
AS

SELECT Store.Id 
	  ,Store.CompanyId 
	  ,Store.Code 
	  ,Store.[Name] 
	  ,Store.[Address] 
	  ,C1.[Name] AS Type 
  FROM [Warehouse].[MsStore] Store 
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Store.TypeIdc 

GO

