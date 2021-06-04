CREATE VIEW [PIVOT].Efectividad_Paso01
AS
SELECT Company.Id AS IdDistribuidor
	,Company.[Name] AS Distribuidor
	,C3.[Name] AS Sucursal 
	,Customer.[Name] AS ClienteNombre
	,convert(date, CustomRoute.InitialDate) AS FechaInicial_ClienteRuta
	,convert(date, isnull(CustomRoute.FinalDate, GetDate())) AS FechaFinal_ClienteRuta
	,Usr.Id AS VendedorId
	,Usr.[Name] AS VendedorNombre
	,C1.[Name] AS Tipo
	,[Zone].[Name] AS ZonaNombre
	,C2.[Name] AS RutaDia
	,convert(int, C2.[Value]) AS ValorRutaDia
	,DateName(dw, CustomRoute.InitialDate) AS DiaSemana
	,DatePart(dw, CustomRoute.InitialDate) AS NumeroDiaSemana
  FROM Zoning.PsCustomerRoute CustomRoute 
		INNER JOIN Sales.MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
		INNER JOIN Base.MsCompany Company ON Company.Id = Customer.CompanyId
		INNER JOIN Zoning.PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
		INNER JOIN Base.PsClassifier C1 ON C1.Id = UMR.TypeIdc 
		INNER JOIN Zoning.PsRoute [Route] ON [Route].Id = UMR.RouteId 
		INNER JOIN Zoning.PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
		INNER JOIN Base.PsClassifier C2 ON C2.Id = [Route].DayIdc and C2.ClassifierTypeId = 18 
		INNER JOIN [Security].MsUser Usr ON Usr.Id = UMR.UserId 
		INNER JOIN Base.PsClassifier C3 ON C3.Id = Company.LocalIdc and C3.ClassifierTypeId = 50 
 WHERE [Route].Active = 1 
	AND DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) > 0

GO
