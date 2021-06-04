CREATE PROCEDURE [PIVOT].sp_Efectividad
	@FechaDia as Date
AS

DECLARE @DiaInicio as SmallInt = @@DATEFIRST;
DECLARE @FechaHoy as Date = GETDATE()
--DECLARE @FechaDia as Date = DATEADD(MONTH, -2, @FechaHoy)
DECLARE @FechaProceso as Date = @FechaDia

SET DATEFIRST 7;

--SET @FechaDia = DATEFROMPARTS(YEAR(@FechaDia), MONTH(@FechaDia), 1)
--SET @FechaProceso = @FechaDia

--DELETE FROM [PIVOT].[Efectividad]
--WHERE Fecha >= @FechaDia;
--IF @@ERROR <> 0
--	ROLLBACK;
--ELSE
	--BEGIN
		WHILE @FechaDia < @FechaHoy
		BEGIN
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

			SET @FechaDia = DATEADD(dd, 1, @FechaDia)
		END
		SET DATEFIRST @DiaInicio;


		-- Actualiza el campo PDVCompraron se realiza un DSITINCT para aquellas compras realizadas mas de una vez para un mismo
		-- Cliente en el mismo dia.
		UPDATE [PIVOT].Efectividad
		   SET Efectividad.PDVCompraron = (SELECT count(*) FROM [PIVOT].extEfectividad_Paso02 Efec
											WHERE Efec.DistribuidorId = Efectividad.IdDistribuidor AND
												  Efec.VendedorId = Efectividad.VendedorId AND
												  Efec.FechaVenta = Efectividad.Fecha )
		 WHERE Fecha >= @FechaProceso;


		-- Actualiza el campo PDVVisitados se realiza un DSITINCT para aquellas visitas y compras realizadas mas de una vez para un mismo
		-- Cliente en el mismo dia.
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


	-- Se realiza la somatoria de los 6 meses anteriores y se divide entre 6, si es menor, entre la cantidad de meses 
	-- recuperados
	DECLARE @FechaInicio as Date
	DECLARE @FechaFin as Date
	DECLARE @Max_Distribuidor as SmallInt
	DECLARE @IdDistribuidor as SmallInt = 3
	DECLARE @FechaMin as Date
	DECLARE @NumeroMeses as SmallInt

	SET @Max_Distribuidor = (SELECT max(Id) as Id FROM [PIVOT].[extMsCompany] WHERE Active = 1)

	WHILE @IdDistribuidor <= @Max_Distribuidor
	BEGIN
		SET @FechaDia = @FechaProceso
		SET @FechaMin = (SELECT MIN(Fecha) From [PIVOT].[Efectividad]
						  WHERE IdDistribuidor = @IdDistribuidor)
		IF @FechaMin IS NOT NULL
		BEGIN
			IF @FechaMin > @FechaDia
				SET @FechaDia = @FechaMin

			WHILE @FechaDia < @FechaHoy
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

						--if @FechaMin > @FechaFin
						--	SET @FechaFin = @FechaMin

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

--END
