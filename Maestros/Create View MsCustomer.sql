ALTER VIEW [PIVOT].MsCustomer
AS
SELECT Customer.Id
	  ,Customer.Code
	  ,Customer.[Name]
	  ,Customer.BusinessName
	  ,Customer.Nit
	  ,Customer.[Address]
	  ,Customer.Reference
	  ,Customer.Phone
	  ,Customer.Latitude
	  ,Customer.Longitude
	  ,Customer.Active
	  ,Zne.[Name] AS Zona 
	  ,C9.[Name] AS ClienteTipo 
	  ,C10.[Name] AS Categoria
	  ,CRecursive.[Name] AS TipoRecursivo 
  FROM Sales.MsCustomer Customer
		INNER JOIN Zoning.PsZone Zne ON Zne.Id = Customer.ZoneId
		INNER JOIN Base.PsClassifier C9 ON C9.Id = Customer.CustomerTypeIdc
		INNER JOIN Base.PsClassifier C10 ON C10.Id = Customer.CategoryIdC
		INNER JOIN Base.PsClassifierRecursive CRecursive ON CRecursive.Id = Customer.BussinessTypeIdr

GO
