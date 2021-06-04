
DECLARE @DiaInicio as SmallInt = @@DATEFIRST;
DECLARE @FechaHoy as Date = GETDATE()
DECLARE @FechaDia as Date = DATEADD(MONTH, -2, @FechaHoy)
DECLARE @FechaProceso as Date

SET DATEFIRST 7;

SET @FechaDia = DATEFROMPARTS(YEAR(@FechaDia), MONTH(@FechaDia), 1)
SET @FechaProceso = @FechaDia

DELETE FROM [PIVOT].[Efectividad]
WHERE Fecha >= @FechaDia;
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		WHILE @FechaDia < @FechaHoy
		BEGIN
			--WITH Efectividad (IdDistribuidor, Distribuidor, Sucursal, ClienteNombre, FechaInicial_ClienteRuta, FechaFinal_ClienteRuta, VendedorId, VendedorNombre, 
			--				  Tipo, ZonaNombre, RutaDia, ValorRutaDia, DiaSemana, NumeroDiaSemana) 
			--AS 
			--(
			--SELECT IdDistribuidor, Distribuidor, Sucursal, ClienteNombre, FechaInicial_ClienteRuta, FechaFinal_ClienteRuta, VendedorId, VendedorNombre, 
			--	   Tipo, ZonaNombre, RutaDia, ValorRutaDia, DiaSemana, NumeroDiaSemana
			--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio', 
		 --  'SELECT Company.Id AS IdDistribuidor
			--	  ,Company.[Name] AS Distribuidor
			--	  ,C3.[Name] AS Sucursal 
			--	  ,Customer.[Name] AS ClienteNombre
			--	  ,convert(date, CustomRoute.InitialDate) AS FechaInicial_ClienteRuta
			--	  ,convert(date, isnull(CustomRoute.FinalDate, GetDate())) AS FechaFinal_ClienteRuta
			--	  ,Usr.Id AS VendedorId
			--	  ,Usr.[Name] AS VendedorNombre
			--	  ,C1.[Name] AS Tipo
			--	  ,[Zone].[Name] AS ZonaNombre
			--	  ,C2.[Name] AS RutaDia
			--	  ,convert(int, C2.[Value]) AS ValorRutaDia
			--	  ,DateName(dw, CustomRoute.InitialDate) AS DiaSemana
			--	  ,DatePart(dw, CustomRoute.InitialDate) AS NumeroDiaSemana
			--  FROM Zoning.PsCustomerRoute CustomRoute 
			--   INNER JOIN Sales.MsCustomer Customer ON Customer.Id = CustomRoute.CustomerId 
			--   INNER JOIN Base.MsCompany Company ON Company.Id = Customer.CompanyId
			--   INNER JOIN Zoning.PsUserMobileRoute UMR ON UMR.RouteId = CustomRoute.RouteId 
			--   INNER JOIN Base.PsClassifier C1 ON C1.Id = UMR.TypeIdc 
			--   INNER JOIN Zoning.PsRoute [Route] ON [Route].Id = UMR.RouteId 
			--   INNER JOIN Zoning.PsZone [Zone] ON [Zone].Id = [Route].ZoneId 
			--   INNER JOIN Base.PsClassifier C2 ON C2.Id = [Route].DayIdc and C2.ClassifierTypeId = 18 
			--   INNER JOIN [Security].MsUser Usr ON Usr.Id = UMR.UserId 
			--   INNER JOIN Base.PsClassifier C3 ON C3.Id = Company.LocalIdc and C3.ClassifierTypeId = 50 
			-- WHERE [Route].Active = 1 
			--	   AND DateDiff(d, CustomRoute.InitialDate, isnull(CustomRoute.FinalDate,GetDate())) > 0')
			--)
			INSERT INTO [PIVOT].Efectividad
			(IdDistribuidor, Distribuidor, Sucursal, Gestion, Mes, Fecha, SemanaMes, SemanaAnio, VendedorId, VendedorNombre, PDVProgramado)
			Select IdDistribuidor
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
			  FROM [PIVOT].extEfectividad_Paso01
			 WHERE IdDistribuidor >= 3
				   AND ValorRutaDia = NumeroDiaSemana 
				   AND FechaInicial_ClienteRuta <= @FechaDia AND FechaFinal_ClienteRuta >= @FechaDia
				   AND ValorRutaDia = DatePart(dw, @FechaDia)
			GROUP BY IdDistribuidor, Distribuidor, Sucursal, VendedorId, VendedorNombre;

			--PRINT @FechaDia
			SET @FechaDia = DATEADD(dd, 1, @FechaDia)
		END
		SET DATEFIRST @DiaInicio;


		-- Actualiza el campo PDVCompraron se realiza un DSITINCT para aquellas compras realizadas mas de una vez para un mismo
		-- Cliente en el mismo dia.
		--WITH Compraron (DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha)
		--as
		--(
		--SELECT DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio', 
	 --  'SELECT Distinct Sale.CompanyId as DistribuidorId
		--	   , Company.[Name] as Distribuidor
		--	   , Seller.[Name] as VendedorNombre
		--	   , CustomerName as ClienteNombre
		--	   , SellerId as VendedorId
		--	   , convert(date, SaleDate)
		--  FROM [Sales].MsSale Sale 
		--	   INNER JOIN [Base].MsCompany Company ON Company.Id = Sale.CompanyId 
		--	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
		-- WHERE StatusIdc <> 104')
		--)
		UPDATE [PIVOT].Efectividad
		   SET Efectividad.PDVCompraron = (SELECT count(*) FROM [PIVOT].extEfectividad_Paso02 Efec
											WHERE Efec.DistribuidorId = Efectividad.IdDistribuidor AND
												  Efec.VendedorId = Efectividad.VendedorId AND
												  Efec.Fecha = Efectividad.Fecha )
		 WHERE Fecha >= @FechaProceso;


		-- Actualiza el campo PDVVisitados se realiza un DSITINCT para aquellas visitas y compras realizadas mas de una vez para un mismo
		-- Cliente en el mismo dia.
		-- Uso de Jerarquias con CTE
		--WITH Promedio(DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha, Tipo)
		--AS
		--(
		--SELECT DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha, Tipo
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio', 
	 --  'SELECT DISTINCT Sale.CompanyId as DistribuidorId
		--	   , Company.[Name]as Distribuidor
		--	   , Seller.[Name] as VendedorNombre
		--	   , CustomerName as ClienteNombre
		--	   , Sale.SellerId as VendedorId
		--	   , convert(date, SaleDate) as SaleDate
		--	   , ''Compra''
		--  FROM [Sales].MsSale Sale 
		--	   INNER JOIN [Base].MsCompany Company ON Company.Id = Sale.CompanyId 
		--	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
		-- WHERE StatusIdc <> 104

		--UNION ALL
 
		--SELECT DISTINCT Visit.CompanyId
		--	   ,Comp.[Name] as DistribuidorId
		--	   ,Seller.[Name] as VendedorNombre
		--	   ,Customer.[Name] as ClienteNombre
		--	   ,Visit.UserId as VendedorId
		--	   ,convert(date, VisitDate)
		--	   ,''Visita''
		--  FROM [Sales].PsVisit Visit
		--	 INNER JOIN [Base].MsCompany Comp ON Comp.Id = Visit.CompanyId 
		--	 INNER JOIN [Security].MsUser Seller ON Seller.Id = Visit.UserId
		--	 INNER JOIN [Sales].MsCustomer Customer ON Customer.Id = Visit.CustomerId')
		--),
		WITH Promedio2(DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha)
		AS
		(
		SELECT Distinct DistribuidorId, Distribuidor, VendedorNombre, ClienteNombre, VendedorId, Fecha
		  FROM [PIVOT].extEfectividad_Paso03 
		)
		UPDATE [PIVOT].Efectividad
		   SET PDVVisitados = ( SELECT count(*) FROM Promedio2
								 WHERE Promedio2.DistribuidorId = Efectividad.IdDistribuidor and
									   Promedio2.VendedorId = Efectividad.VendedorId and
									   Promedio2.Fecha = Efectividad.Fecha )
		 WHERE Fecha >= @FechaProceso;


	-- Se realiza la somatoria de los 6 meses anteriores y se divide entre 6, si es menor, entre la cantdad de meses 
	-- recuperados
	DECLARE @FechaInicio as Date
	DECLARE @FechaFin as Date
	DECLARE @Max_Distribuidor as SmallInt
	DECLARE @IdDistribuidor as SmallInt = 3
	DECLARE @FechaMin as Date
	DECLARE @NumeroMeses as SmallInt

	SET @Max_Distribuidor = (SELECT max(Id) as Id FROM [PIVOT].[extMsCompany])
	--(SELECT X.Id FROM 
	--OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio', 
	--'SELECT max(Id) as Id FROM [Base].[MsCompany]') AS X )

	WHILE @IdDistribuidor <= @Max_Distribuidor
	BEGIN
		SET @FechaDia = @FechaProceso
		SET @FechaMin = (SELECT MIN(Fecha) From [PIVOT].[Efectividad]
						  WHERE IdDistribuidor = @IdDistribuidor)
		--PRINT @FechaMin
		IF @FechaMin IS NOT NULL
		BEGIN
			--SET @FechaDia = @FechaMin
			IF @FechaMin > @FechaDia
				SET @FechaDia = @FechaMin

			WHILE @FechaDia < GETDATE()
			BEGIN
				IF EOMONTH(@FechaMin,-1) < @FechaDia AND @FechaDia <= EOMONTH(@FechaMin)
					BEGIN
					UPDATE [PIVOT].[Efectividad]
						SET PDVPromedio = 0
						WHERE IdDistribuidor = @IdDistribuidor and Fecha = @FechaDia; 
					END
				ELSE
					BEGIN
						SET @FechaInicio = EOMONTH(@FechaDia, -1)
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
							WHERE Efec.IdDistribuidor = @IdDistribuidor and Efec.Fecha = @FechaDia 
					END
				SET @FechaDia = DATEADD(DAY, 1, @FechaDia)
			END
		END
		SET @IdDistribuidor = @IdDistribuidor + 1
	END

END

GO
