
SELECT TOP 100
	   Pedido.CompanyId as DistribuidorId
	  , Comp.[Name] As Distribuidor
	  , CR.[Sequence] as Secuencia
	  , Pedido.CustomerName as ClienteNombre
	  , convert(date, Pedido.InitialDate) as Fecha
	  , convert(varchar(25), Pedido.InitialDate, 108) as HoraInicio
	  , convert(time, Pedido.FinalDate, 8) as HoraFin
	  , Pedido.SellerId as VendedorId
	  , Usr.[Name] as VendedorNombre
	  , 'Pedido' as Motivo
	  , C1.[Name] as DiaNombre
	  , CASE 
			WHEN Pedido.Latitude <> 0 THEN 'SI'
			ELSE 'NO'
		END as TieneGPS
  FROM Sales.MsOrder Pedido
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Pedido.SellerId 
		INNER JOIN Base.MsCompany Comp On Comp.Id = Pedido.CompanyId
		INNER JOIN [Zoning].[PsCustomerRoute] CR ON CR.CustomerId = Pedido.CustomerId and 
				(CR.InitialDate <= convert(date, Pedido.InitialDate) and isnull(CR.FinalDate, convert(date, GETDATE())) >= convert(date, Pedido.InitialDate))
		INNER JOIN [Zoning].[PsRoute] Ruta On Ruta.Id = CR.RouteId
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Ruta.DayIdc and C1.ClassifierTypeId = 18
 WHERE Pedido.CompanyId >= 3 and Pedido.StatusIdc <> 50
UNION ALL 
SELECT --TOP 100 
	   Visita.CompanyId as DistribuidorId
	  , Comp.[Name] as Distribuidor
	  , CR.[Sequence] as Secuencia
	  , Cliente.[Name] as ClienteNombre
	  , convert(date, VisitDate) as Fecha
	  , convert(varchar(25), VisitDate, 108) as HoraInicio
	  , convert(varchar(25), VisitDate, 8) as HoraFin
	  , Usr.Id as VendedorId 
	  , Usr.[Name] as VendedorNombre
	  , Razon.[Name] as Motivo
	  , C1.[Name] as DiaNombre
	  , CASE 
			WHEN Visita.Latitude <> 0 THEN 'SI'
			ELSE 'NO'
		END as TieneGPS
  FROM Sales.PsVisit Visita 
		INNER JOIN Base.MsCompany Comp ON Comp.Id = Visita.CompanyId
		INNER JOIN Sales.MsReason Razon ON Razon.Id = Visita.ReasonId
		INNER JOIN Sales.MsCustomer Cliente ON Cliente.Id = Visita.CustomerId
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Visita.UserId 
		INNER JOIN [Zoning].[PsCustomerRoute] CR ON CR.CustomerId = Visita.CustomerId and 
				(CR.InitialDate <= convert(date, Visita.VisitDate) and isnull(CR.FinalDate, convert(date, GETDATE())) >= convert(date, Visita.VisitDate))
		INNER JOIN [Zoning].[PsRoute] Ruta On Ruta.Id = CR.RouteId
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Ruta.DayIdc and C1.ClassifierTypeId = 18
 WHERE Visita.CompanyId >= 3

union all
-- Pedidos generados a los clientes que no estaban en RUTA
SELECT --TOP 100
	   Pedido.CompanyId as DistribuidorId
	  , Comp.[Name] As Distribuidor
	  , 0 as Secuencia
	  , Pedido.CustomerName as ClienteNombre
	  , convert(date, Pedido.InitialDate) as Fecha
	  , convert(varchar(25), Pedido.InitialDate, 108) as HoraInicio
	  , convert(time, Pedido.FinalDate, 8) as HoraFin
	  , Pedido.SellerId as VendedorId
	  , Usr.[Name] as VendedorNombre
	  , 'Pedido' as Motivo
	  , '' as DiaNombre
	  , CASE 
			WHEN Pedido.Latitude <> 0 THEN 'SI'
			ELSE 'NO'
		END as TieneGPS
  FROM Sales.MsOrder Pedido
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Pedido.SellerId 
		INNER JOIN Base.MsCompany Comp On Comp.Id = Pedido.CompanyId
 WHERE Pedido.CompanyId >= 3 and Pedido.StatusIdc <> 50 and 
	   Pedido.Id not in (
SELECT Pedido.Id
  FROM Sales.MsOrder Pedido
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Pedido.SellerId 
		INNER JOIN Base.MsCompany Comp On Comp.Id = Pedido.CompanyId
		INNER JOIN [Zoning].[PsCustomerRoute] CR ON CR.CustomerId = Pedido.CustomerId and 
				(CR.InitialDate <= convert(date, Pedido.InitialDate) and isnull(CR.FinalDate, convert(date, GETDATE())) >= convert(date, Pedido.InitialDate))
		INNER JOIN [Zoning].[PsRoute] Ruta On Ruta.Id = CR.RouteId
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Ruta.DayIdc and C1.ClassifierTypeId = 18
 WHERE Pedido.CompanyId >= 3 and Pedido.StatusIdc <> 50 )
union all
-- Visitas a Clientes que no estaban en RUTA
SELECT --TOP 100 
	   Visita.CompanyId as DistribuidorId
	  , Comp.[Name] as Distribuidor
	  , 0 as Secuencia
	  , Cliente.[Name] as ClienteNombre
	  , convert(date, VisitDate) as Fecha
	  , convert(varchar(25), VisitDate, 108) as HoraInicio
	  , convert(varchar(25), VisitDate, 8) as HoraFin
	  , Usr.Id as VendedorId 
	  , Usr.[Name] as VendedorNombre
	  , Razon.[Name] as Motivo
	  , '' as DiaNombre
	  , CASE 
			WHEN Visita.Latitude <> 0 THEN 'SI'
			ELSE 'NO'
		END as TieneGPS
  FROM Sales.PsVisit Visita 
		INNER JOIN Base.MsCompany Comp ON Comp.Id = Visita.CompanyId
		INNER JOIN Sales.MsReason Razon ON Razon.Id = Visita.ReasonId
		INNER JOIN Sales.MsCustomer Cliente ON Cliente.Id = Visita.CustomerId
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Visita.UserId 
 WHERE Visita.CompanyId >= 3 and
       Visita.Id not in (
SELECT Visita.Id
  FROM Sales.PsVisit Visita 
		INNER JOIN Base.MsCompany Comp ON Comp.Id = Visita.CompanyId
		INNER JOIN Sales.MsReason Razon ON Razon.Id = Visita.ReasonId
		INNER JOIN Sales.MsCustomer Cliente ON Cliente.Id = Visita.CustomerId
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Visita.UserId 
		INNER JOIN [Zoning].[PsCustomerRoute] CR ON CR.CustomerId = Visita.CustomerId and 
				(CR.InitialDate <= convert(date, Visita.VisitDate) and isnull(CR.FinalDate, convert(date, GETDATE())) >= convert(date, Visita.VisitDate))
		INNER JOIN [Zoning].[PsRoute] Ruta On Ruta.Id = CR.RouteId
		INNER JOIN [Base].[PsClassifier] C1 ON C1.Id = Ruta.DayIdc and C1.ClassifierTypeId = 18
 WHERE Visita.CompanyId >= 3)

