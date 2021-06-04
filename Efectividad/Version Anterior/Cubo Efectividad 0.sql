USE MSFSystemVacio
GO

DROP TABLE [PIVOT].[Efectividad];

CREATE TABLE [PIVOT].[Efectividad]
( IdDistribuidor int NOT NULL,
  Distribuidor varchar(255) NULL,
  Sucursal varchar(255) NULL,
  Gestion Integer,
  Mes Integer,
  Fecha Date NULL,
  SemanaMes SmallInt,
  SemanaAnio SmallInt, 
  VendedorId BigInt, 
  VendedorNombre varchar(255) NULL,
  PDVProgramado Integer CONSTRAINT [DF_Efectividad_PDVProgramado]  DEFAULT 0,
  PDVVisitados Integer CONSTRAINT [DF_Efectividad_PDVVisitados]  DEFAULT 0,
  PDVCompraron Integer CONSTRAINT [DF_Efectividad_PDVCompraron]  DEFAULT 0,
  PDVPromedio Integer CONSTRAINT [DF_Efectividad_PDVPromedio]  DEFAULT 0
)
ON [PRIMARY]
GO

--ALTER TABLE [PIVOT].[Efectividad] ADD  CONSTRAINT [DF_Efectividad_PDVPromedio]  DEFAULT ((0)) FOR [PDVPromedio]
--GO

--SELECT * FROM Sales.PsVisit
--SELECT * FROM Zoning.PsRoute
--SELECT * FROM Zoning.PsCustomerRoute
--where finaldate is not null   -- customerid = 1803
--order by CustomerId

USE MSFSystem_Cube
GO

TRUNCATE TABLE [PIVOT].[Efectividad]
GO

DECLARE @FechaDia as Date;
DECLARE @DiaInicio as SmallInt = @@DATEFIRST;
DECLARE @FechaHoy as Date = GETDATE()
--SET @DiaInicio = @@DATEFIRST;
SET DATEFIRST 7;

DECLARE @MinVisitDate as Date
SET @MinVisitDate = (SELECT min(VisitDate) FROM MSFSystemVacio.Sales.PSVisit)
SET @FechaDia = @MinVisitDate

WHILE @FechaDia < @FechaHoy
BEGIN
	WITH Efectividad (DistribuidorId, Distribuidor, Sucursal, ClienteNombre, FechaInicial_ClienteRuta, FechaFinal_ClienteRuta, VendedorId, VendedorNombre, 
					  Tipo, ZonaNombre, RutaDia, ValorRutaDia, DiaSemana, NumeroDiaSemana)   --, NumeroDias
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
		  , C1.[Name] as Tipo
		  , [Zone].[Name] as ZonaNombre
		  , C2.[Name] as RutaDia
		  , convert(int, C2.[Value]) as ValorRutaDia
		  , DateName(dw, CustomRoute.InitialDate) as DiaSemana
		  , DatePart(dw, CustomRoute.InitialDate) as NumeroDiaSemana
		  --, (DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) + 1) as NumeroDias
	  FROM MSFSystemVacio.Zoning.PsCustomerRoute CustomRoute 
	   INNER JOIN MSFSystemVacio.Sales.MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
	   INNER JOIN MSFSystemVacio.Base.MsCompany Company ON Company.Id = Customer.CompanyId
	   INNER JOIN MSFSystemVacio.Zoning.PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
	   INNER JOIN MSFSystemVacio.Base.PsClassifier C1 ON C1.Id = UMR.TypeIdc 
	   INNER JOIN MSFSystemVacio.Zoning.PsRoute [Route] ON [Route].Id = UMR.RouteId 
	   INNER JOIN MSFSystemVacio.Zoning.PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
	   INNER JOIN MSFSystemVacio.Base.PsClassifier C2 ON C2.Id = [Route].DayIdc and C2.ClassifierTypeId = 18 
	   INNER JOIN MSFSystemVacio.[Security].MsUser Usr ON Usr.Id = UMR.UserId 
	   INNER JOIN MSFSystemVacio.Base.PsClassifier C3 ON C3.Id = Company.LocalIdc and C3.ClassifierTypeId = 50 
	 Where [Route].Active = 1 
		   and DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) > 0
	)
	INSERT INTO [PIVOT].Efectividad
	(IdDistribuidor, Distribuidor, Sucursal, Gestion, Mes, Fecha, SemanaMes, SemanaAnio, VendedorId, VendedorNombre, PDVProgramado)   --, PDVVisitados, PDVCompraron, PDVPromedio
	Select DistribuidorId
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
	 WHERE ValorRutaDia = NumeroDiaSemana 
		   and FechaInicial_ClienteRuta <= @FechaDia and FechaFinal_ClienteRuta >= @FechaDia
		   and ValorRutaDia = DatePart(dw, @FechaDia)
	Group By DistribuidorId, Distribuidor, Sucursal, VendedorId, VendedorNombre ;

	--PRINT @FechaDia
	SET @FechaDia = DATEADD(dd, 1, @FechaDia)
END
SET DATEFIRST @DiaInicio;


-- Actualiza el campo PDVCompraron se realiza un DSITINCT para aquellas compras realizadas mas de una vez para un mismo
-- Cliente en el mismo dia.
WITH Compraron (DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha)
as
(
select Distinct Sale.CompanyId
       , Company.[Name]
       , Seller.[Name]
	   , CustomerName 
	   , SellerId 
	   , convert(date, SaleDate)
  from MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Base].MsCompany Company ON Company.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Security].MsUser Seller ON Seller.Id = Sale.UserId
 Where StatusIdc <> 104
)
--Select * From Compraron 
UPDATE [PIVOT].Efectividad
   SET Efectividad.PDVCompraron = (Select count(*) From Compraron 
                                    Where Compraron.DistribuidorId = Efectividad.IdDistribuidor and
										  Compraron.VendedorId = Efectividad.VendedorId and
										  Compraron.Fecha = Efectividad.Fecha );


-- Actualiza el campo PDVVisitados se realiza un DSITINCT para aquellas visitas y compras realizadas mas de una vez para un mismo
-- Cliente en el mismo dia.
-- Uso de Jerarquias con CTE
WITH Promedio(DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha, Tipo)
AS
(
select Distinct Sale.CompanyId 
       , Company.[Name]
       , Seller.[Name]
	   , CustomerName
	   , Sale.SellerId 
	   , convert(date, SaleDate)
	   , 'Compra'
  from MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Base].MsCompany Company ON Company.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Security].MsUser Seller ON Seller.Id = Sale.UserId
 Where StatusIdc <> 104

UNION ALL
 
SELECT DISTINCT Visit.CompanyId
       , Comp.[Name]
       , Seller.[Name]
	   , Customer.[Name]
	   , Visit.UserId 
	   , convert(date, VisitDate)
	   , 'Visita'
FROM MSFSystemVacio.[Sales].PsVisit Visit
     INNER JOIN MSFSystemVacio.[Base].MsCompany Comp ON Comp.Id = Visit.CompanyId 
     INNER JOIN MSFSystemVacio.[Security].MsUser Seller ON Seller.Id = Visit.UserId
	 INNER JOIN MSFSystemVacio.[Sales].MsCustomer Customer ON Customer.Id = Visit.CustomerId
),
Promedio2(DistribuidorId, Distribuidor, VendedorId, VendedorNombre, ClienteNombre, Fecha)
AS
(
SELECT Distinct DistribuidorId, Distribuidor, VendedorId, VendedorNombre, ClienteNombre, Fecha
  FROM Promedio
)
UPDATE [PIVOT].Efectividad
   SET PDVVisitados = ( SELECT count(*) FROM Promedio2
                         WHERE Promedio2.DistribuidorId = Efectividad.IdDistribuidor and
							   Promedio2.VendedorId = Efectividad.VendedorId and
							   Promedio2.Fecha = Efectividad.Fecha );


-- Se realiza la somatoria de los 6 meses anterior y se divide entre 6, si es menor, entre la cantdad de meses 
-- recuperados
DECLARE @FechaInicio as Date
DECLARE @FechaFin as Date, @FechaProceso as Date
DECLARE @Max_Distribuidor as SmallInt
DECLARE @IdDistribuidor as SmallInt = 3
DECLARE @FechaMin as Date
DECLARE @NumeroMeses as SmallInt

SET @Max_Distribuidor = (SELECT max(Id) FROM MSFSystemVacio.[Base].[MsCompany])

WHILE @IdDistribuidor <= @Max_Distribuidor
BEGIN
	SET @FechaMin = (SELECT MIN(Fecha) From [PIVOT].[Efectividad]
					  WHERE IdDistribuidor = @IdDistribuidor)
	--PRINT @FechaMin
	IF @FechaMin IS NOT NULL
	BEGIN
		PRINT 'COMPANIA : ' + CONVERT(VARCHAR(2), @IdDistribuidor)
		SET @FechaProceso = @FechaMin

		WHILE @FechaProceso < GETDATE()
		BEGIN
			IF EOMONTH(@FechaMin,-1) < @FechaProceso AND @FechaProceso <= EOMONTH(@FechaMin)
				BEGIN
				UPDATE [PIVOT].[Efectividad]
					SET PDVPromedio = 0
					WHERE IdDistribuidor = @IdDistribuidor and Fecha = @FechaProceso; 
				END
			ELSE
				BEGIN
					SET @FechaInicio = EOMONTH(@FechaProceso, -1)
					SET @FechaFin = DATEADD(DAY, -180, @FechaInicio)

					if @FechaMin > @FechaFin
						SET @FechaFin = @FechaMin

					SET @NumeroMeses = CEILING( DATEDIFF(DAY, @FechaFin, @FechaInicio) / 30.00 );
					WITH Promedio(IdDistribuidor ,VendedorId ,Fecha ,TotalVisitados)
					AS (
					SELECT IdDistribuidor
							,VendedorId
							,Fecha
							,sum(PDVVisitados)
						FROM [PIVOT].[Efectividad] 
					GROUP BY IdDistribuidor ,VendedorId ,Fecha
					)
					UPDATE [PIVOT].[Efectividad] 
						SET Efectividad.PDVPromedio = ROUND(( Pro.TotalVisitados / @NumeroMeses ), 0)
						FROM [PIVOT].[Efectividad] Efec 
							INNER JOIN Promedio Pro ON Pro.IdDistribuidor = Efec.IdDistribuidor and Pro.VendedorId = Efec.VendedorId and Pro.Fecha = Efec.Fecha
						WHERE Efec.IdDistribuidor = @IdDistribuidor and Efec.Fecha = @FechaProceso 
				END
			SET @FechaProceso = DATEADD(DAY, 1, @FechaProceso)
		END
	END
	SET @IdDistribuidor = @IdDistribuidor + 1
END

GO

------------------------------------------------------------------------
select max(fecha), min(fecha) from [PIVOT].[Efectividad]
------------------------------------------------------------------------

-- Actualiza el campo PDVVisitados se realiza un DISTINCT para aquellas visitas realizadas mas de una vez a un mismo cliente
-- en el mismo dia
--WITH Visitados (Distribuidor, VendedorNombre, ClienteNombre, Fecha)
--AS
--(
--SELECT DISTINCT Company.[Name]
--       , Seller.[Name]
--	   , CustomerId
--	   , convert(date, VisitDate)
--FROM Sales.PsVisit Visit 
--       INNER JOIN Base.MsCompany Company ON Company.Id = Visit.CompanyId 
--	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Visit.UserId
--)
--UPDATE [PIVOT].Efectividad
--   SET Efectividad.PDVVisitados = (Select count(*) From Visitados 
--                                    Where Visitados.Distribuidor = Efectividad.Distribuidor and
--										  Visitados.VendedorNombre = Efectividad.VendedorNombre and
--										  Visitados.Fecha = Efectividad.Fecha );
--GO;


-------------------------------------------------------------------------------------------
--Select Distribuidor, VendedorNombre, ClienteNombre, Fecha FROM Promedio2
----where ClienteNombre like '%FLORA%'
--Order by Distribuidor, Fecha, ClienteNombre    --, Tipo    ---, VendedorNombre
-------------------------------------------------------------------------------------------

DECLARE @FechaDia as Date;
DECLARE @DiaInicio as SmallInt;
DECLARE @Distribuidor as VARCHAR(255);
DECLARE @Sucursal as VARCHAR(255);
DECLARE @Vendedor as VARCHAR(255);
DECLARE @PDVProgramada as Integer

SET @DiaInicio = @@DATEFIRST;
SET DATEFIRST 7;
SET @FechaDia = '2018/11/05';

DECLARE Efectividad_Cursor CURSOR FOR
WITH Efectividad (Distribuidor, Sucursal, ClienteNombre, FechaInicial_ClienteRuta, FechaFinal_ClienteRuta, VendedorNombre, Tipo, ZonaNombre, RutaDia, 
     ValorRutaDia, DiaSemana, NumeroDiaSemana, NumeroDias)
as 
(
SELECT Company.[Name] as Distribuidor
      , C3.[Name] as Sucursal 
      , Customer.[Name] as ClienteNombre
      , CustomRoute.InitialDate as FechaInicial_ClienteRuta
	  , convert(date, GetDate()) as FechaFinal_ClienteRuta
      , Usr.[Name] as VendedorNombre
	  , C1.[Name] as Tipo
	  , [Zone].[Name] as ZonaNombre, C2.[Name] as RutaDia, C2.[Value] as ValorRutaDia
	  , DateName(dw, CustomRoute.InitialDate) as DiaSemana
	  , DatePart(dw, CustomRoute.InitialDate) as NumeroDiaSemana
	  , (DateDiff(d, CustomRoute.InitialDate, GetDate()) + 1) as NumeroDias
  FROM MSFSystemVacio.[Zoning].PsCustomerRoute CustomRoute 
   INNER JOIN MSFSystemVacio.[Sales].MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
   INNER JOIN MSFSystemVacio.[Base].MsCompany Company ON Company.Id = Customer.CompanyId
   INNER JOIN MSFSystemVacio.[Zoning].PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C1 ON C1.Id = UMR.TypeIdc 
   INNER JOIN MSFSystemVacio.[Zoning].PsRoute [Route] ON [Route].Id = UMR.RouteId 
   INNER JOIN MSFSystemVacio.[Zoning].PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C2 ON C2.Id = [Route].DayIdc 
   INNER JOIN MSFSystemVacio.[Security].MsUser Usr ON Usr.Id = UMR.UserId  
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C3 ON C3.Id = Company.LocalIdc 
 Where [Route].Active = 1 and CustomRoute.FinalDate is null

UNION ALL

SELECT Company.[Name] as Distribuidor
      , C3.[Name] as Sucursal 
      , Customer.[Name] as ClienteNombre
      , CustomRoute.InitialDate as FechaInicial_ClienteRuta
	  , CustomRoute.FinalDate as FechaFinal_ClienteRuta
      , Usr.[Name] as VendedorNombre
	  , C1.[Name] as Tipo
	  , [Zone].[Name] as ZonaNombre, C2.[Name] as RutaDia, C2.[Value] as ValorRutaDia
	  , DateName(dw, CustomRoute.InitialDate) as DiaSemana
	  , DatePart(dw, CustomRoute.InitialDate) as NumeroDiaSemana
	  , (DateDiff(d, CustomRoute.InitialDate, GetDate()) + 1) as NumeroDias
  FROM MSFSystemVacio.[Zoning].PsCustomerRoute CustomRoute 
   INNER JOIN MSFSystemVacio.[Sales].MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
   INNER JOIN MSFSystemVacio.[Base].MsCompany Company ON Company.Id = Customer.CompanyId
   INNER JOIN MSFSystemVacio.[Zoning].PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C1 ON C1.Id = UMR.TypeIdc 
   INNER JOIN MSFSystemVacio.[Zoning].PsRoute [Route] ON [Route].Id = UMR.RouteId 
   INNER JOIN MSFSystemVacio.[Zoning].PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C2 ON C2.Id = [Route].DayIdc and isnumeric(C2.[Value]) = 1
   INNER JOIN MSFSystemVacio.[Security].MsUser Usr ON Usr.Id = UMR.UserId  
   INNER JOIN MSFSystemVacio.[Base].PsClassifier C3 ON C3.Id = Company.LocalIdc 
 Where [Route].Active = 1 and CustomRoute.FinalDate is not null 
       and DateDiff(d, CustomRoute.InitialDate, CustomRoute.FinalDate) > 0
)
Select Distribuidor, Sucursal, VendedorNombre, count(*) 
  FROM Efectividad
 WHERE ValorRutaDia = NumeroDiaSemana 
       and FechaInicial_ClienteRuta <= @FechaDia and FechaFinal_ClienteRuta >= @FechaDia
	   and ValorRutaDia = DatePart(dw, @FechaDia)
Group By Distribuidor, Sucursal, VendedorNombre 

OPEN Efectividad_Cursor
FETCH NEXT FROM Efectividad_Cursor INTO @Distribuidor, @Sucursal, @Vendedor, @PDVProgramada
WHILE @@FETCH_STATUS = 0 
BEGIN
	EXEC(
	'INSERT INTO PIVOT.Efectividad 
	(Distribuidor, Sucursal, Gestion, Mes, Fecha, SemanaMes, VendedorNombre, PDVProgramada, PDV.Visitados, PDVCompraron, PDVPromedio) '
	+ ' VALUES ( ''' + @Distribuidor + ''', ''' + @Sucursal + ''', YEAR(@FechaDia), MONTH(@FechaDia), @FechaDia, 0, ''' + @Vendedor + ''', ''' + @PDVProgramada + ''', 0, 0, 0 )'
	)
	FETCH NEXT FROM Efectividad_Cursor INTO @Distribuidor, @Sucursal, @Vendedor, @PDVProgramada
END
CLOSE Efectividad_Cursor
DEALLOCATE Efectividad_Cursor

SET DATEFIRST @DiaInicio;


------- Preguntas ---------
-- Hay clientes que pertenecen a rutas o zonas distintas y estan activos
-- Hay clientes que son asignados a una ruta y son inhabilitados ese mismo dia
-- Para el cubo solo tomo el cliente sin importar la ruta
-- 
-- 
--------------------

select @@DATEFIRST

set datefirst 7
