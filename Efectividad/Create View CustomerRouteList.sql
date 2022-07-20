CREATE OR ALTER VIEW [PIVOT].CustomerRouteList
AS 
SELECT [Zone].CompanyId 
	,CustomRoute.Id ,CustomRoute.CustomerId ,CustomRoute.RouteId ,CustomRoute.InitialDate
	,CustomRoute.FinalDate ,CustomRoute.[Sequence]
	,[Route].ZoneId ,[Route].Active ,[Route].DayIdc 
	,UMR.InitialDate AS InitialDate_Route
	,UMR.FinalDate AS FinalDate_Route
	, C2.[Name] AS NombreDia, C2.[Value] AS NumeroDia 
	,Usr.Id AS VendedorId, Usr.[Name] AS VendedorNombre   --, Count(DISTINCT CustomerId) AS CantidadClientes
  FROM Zoning.PsCustomerRoute CustomRoute
	INNER JOIN Zoning.PsRoute [Route] ON [Route].Id = CustomRoute.RouteId 
	INNER JOIN Zoning.PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
	INNER JOIN Zoning.PsUserMobileRoute UMR ON UMR.RouteId = [Route].Id 
	INNER JOIN [Security].MsUser Usr ON Usr.Id = UMR.UserId 
	INNER JOIN Base.PsClassifier C2 ON C2.Id = [Route].DayIdc and C2.ClassifierTypeId = 18 
WHERE [Route].Active = 1 

GO

