DECLARE @FechaDia as Date;
SET @FechaDia = datefromparts(2018,11,9);

	WITH Efectividad (DistribuidorId, Distribuidor, Sucursal, ClienteNombre, FechaInicial_ClienteRuta, FechaFinal_ClienteRuta, VendedorId, VendedorNombre, 
					  ZonaNombre, ValorRutaDia, DiaSemana, NumeroDiaSemana)   --,Tipo, NumeroDias, RutaDia
	AS 
	(
	SELECT Company.Id as DistribuidorId
		  , Company.[Name] as Distribuidor
		  , C3.[Name] as Sucursal 
		  , Customer.[Name] as ClienteNombre
		  , convert(date, CustomRoute.InitialDate) as FechaInicial_ClienteRuta
		  , convert(date, isnull(CustomRoute.FinalDate, GetDate())) as FechaFinal_ClienteRuta
		  , Usr.Id as VendedorId
		  , Usr.[Name] as VendedorNombre
		  --, C1.[Name] as Tipo
		  , [Zone].[Name] as ZonaNombre
		  --, C2.[Name] as RutaDia
		  , convert(int, C2.[Value]) as ValorRutaDia
		  , DateName(dw, CustomRoute.InitialDate) as DiaSemana
		  , DatePart(dw, CustomRoute.InitialDate) as NumeroDiaSemana
		  --, (DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) + 1) as NumeroDias
	  FROM MSFSystemVacio.Zoning.PsCustomerRoute CustomRoute 
	   INNER JOIN MSFSystemVacio.Sales.MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
	   INNER JOIN MSFSystemVacio.Base.MsCompany Company ON Company.Id = Customer.CompanyId
	   INNER JOIN MSFSystemVacio.Zoning.PsRoute [Route] ON [Route].Id = CustomRoute.RouteId 
	   INNER JOIN MSFSystemVacio.Zoning.PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
	   --INNER JOIN Base.PsClassifier C1 ON C1.Id = UMR.TypeIdc 
	   INNER JOIN MSFSystemVacio.Zoning.PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
	   INNER JOIN MSFSystemVacio.Base.PsClassifier C2 ON C2.Id = [Route].DayIdc and C2.ClassifierTypeId = 18 
	   INNER JOIN MSFSystemVacio.[Security].MsUser Usr ON Usr.Id = UMR.UserId 
	   INNER JOIN MSFSystemVacio.Base.PsClassifier C3 ON C3.Id = Company.LocalIdc and C3.ClassifierTypeId = 50 
	 Where [Route].Active = 1 
		   and DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) > 0 
	)
	--INSERT INTO [PIVOT].Efectividad
	--(DistribuidorId, Distribuidor, Sucursal, Gestion, Mes, Fecha, SemanaMes, SemanaAnio, VendedorId, VendedorNombre, PDVProgramado)   --, PDVVisitados, PDVCompraron, PDVPromedio
	Select --*
	       DistribuidorId
	      ,Distribuidor
	      ,Sucursal
	      ,Year(@FechaDia)
	      ,Month(@FechaDia)
		  ,@FechaDia
	      ,((Day(@FechaDia) + (Datepart(dw, Dateadd(Month, Datediff(Month, 0, @FechaDia), 0)) - 1) -1) / 7 + 1)
		  ,DatePart(wk, @FechaDia)
		  ,VendedorId
		  ,VendedorNombre
		  ,count(*) 
	  FROM Efectividad
	 WHERE --ValorRutaDia = NumeroDiaSemana and 
		   FechaInicial_ClienteRuta <= @FechaDia and FechaFinal_ClienteRuta >= @FechaDia
		   and ValorRutaDia = DatePart(dw, @FechaDia)
	Group By DistribuidorId, Distribuidor, Sucursal, VendedorId, VendedorNombre ;
