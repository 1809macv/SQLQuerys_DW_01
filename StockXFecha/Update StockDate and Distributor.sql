------------------------------------------------------------
SET DATEFORMAT YMD

-- Numero de Días que procesara el Stock por Fecha desde el dia actual 
-- hacia atras ejemplo 5 dias, este parametro puede ser cambiado
--DECLARE @NumeroDias INTEGER = -15
--Se inicializa los valores de la fecha inicial y fecha final del proceso
--DECLARE @FechaInicial DATE = CAST(DATEADD(DAY, @NumeroDias,GETDATE()) as DATE)
DECLARE @FechaInicial DATE = DATEFROMPARTS(2021,2,1)
       ,@FechaFinal DATE = CAST(GETDATE() as DATE)

DECLARE @DistribuidorId INT = 14

DECLARE @FechaProceso DATE
DECLARE @Dias INTEGER
DECLARE @i INTEGER = 0

SET @FechaFinal = DATEADD(DAY, -1, @FechaFinal)
-- Se obtiene la diferencia de dias entre las 2 fecha
SET @Dias = DATEDIFF(DAY, @FechaInicial, @FechaFinal)

-- Se eliminan todos los registros desde la fecha inicial
DELETE [PIVOT].StockXFecha
WHERE ( DistribuidorId = @DistribuidorId ) AND ( FechaStock >= @FechaInicial )

IF @@ERROR = 0 
	-- Inicio del bucle WHILE donde @i sea menor que le numero de dias
	WHILE @i < @Dias
	BEGIN
		BEGIN TRANSACTION

		-- Se inicializa la fecha que se obbtendra el stock
		SET @FechaProceso = DATEADD(DAY, @i, @FechaInicial);
		-- El stock es del final del dia
		INSERT INTO [PIVOT].StockXFecha 
		SELECT DistribuidorId
			  ,Distribuidor
			  ,AlmacenId 
			  ,Almacen 
			  ,YEAR(@FechaProceso) 
			  ,CASE Month(@FechaProceso) 
					WHEN 1 THEN '01. Enero'
					WHEN 2 THEN '02. Febrero'
					WHEN 3 THEN '03. Marzo'
					WHEN 4 THEN '04. Abril'
					WHEN 5 THEN '05. Mayo'
					WHEN 6 THEN '06. Junio'
					WHEN 7 THEN '07. Julio'
					WHEN 8 THEN '08. Agosto'
					WHEN 9 THEN '09. Septiembre'
					WHEN 10 THEN '10. Octubre'
					WHEN 11 THEN '11. Noviembre'
					WHEN 12 THEN '12. Diciembre'
			   END
			  ,@FechaProceso
			  ,ProductoId
			  ,ProductoCodigo, ProductoNombre, FactorConverion
			  ,NumeroLoteId ,NumeroLote, TipoLote, Negocio, Reclasificacion 
			  ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
			  ,SUM(Cantidad) as CantidadAlmacen
		  FROM [PIVOT].[extTransaccionesAlmacen] MA 
		 WHERE ( DistribuidorId = @DistribuidorId ) AND ( FechaTransaccion <= @FechaProceso ) 
		GROUP BY DistribuidorId, Distribuidor, AlmacenId, Almacen, ProductoId, ProductoCodigo, ProductoNombre, FactorConverion, 
				 NumeroLoteId, NumeroLote, 
				 TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
		HAVING (1.0000 /  FactorConverion) <= SUM(Cantidad) 
		IF @@ERROR <> 0
			BREAK
		ELSE
			COMMIT;

		-- Se incrementa en una unidad o dia
		SET @i = @i + 1
		
	END -- del WHILE

IF @@ERROR <> 0
	ROLLBACK;

GO


