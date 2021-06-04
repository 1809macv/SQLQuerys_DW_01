------------------------------------------------------------

SET DATEFORMAT YMD

--Se inicializa los valores de la fecha inicial y fecha final del proceso
DECLARE @FechaInicial DATE = CAST(GETDATE() AS DATE)
       ,@FechaFinal DATE = DATEFROMPARTS(2018,6,1)

-- Se eliminan todos los registros de la tabla [PIVOT].StockXFecha
TRUNCATE TABLE [PIVOT].StockXFecha

-- Inicio del bucle WHILE
WHILE @FechaFinal < @FechaInicial
BEGIN

	-- El stock es del final del dia
	INSERT INTO [PIVOT].StockXFecha 
	SELECT DistribuidorId
		  ,Distribuidor
		  ,AlmacenId 
		  ,Almacen 
		  ,YEAR(@FechaFinal) 
		  ,CASE Month(@FechaFinal) 
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
		  ,@FechaFinal
		  ,ProductoId
		  ,ProductoCodigo, ProductoNombre, FactorConverion
		  ,NumeroLoteId ,NumeroLote, TipoLote, Negocio, Reclasificacion 
		  ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
		  ,SUM(Cantidad) as CantidadAlmacen
	  FROM [PIVOT].[extTransaccionesAlmacen] MA 
	 WHERE FechaTransaccion <= @FechaFinal 
	GROUP BY DistribuidorId, Distribuidor, AlmacenId, Almacen, ProductoId, ProductoCodigo, ProductoNombre, FactorConverion, 
			 NumeroLoteId, NumeroLote, 
			 TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
	HAVING (1.0000 /  FactorConverion) <= SUM(Cantidad) 

	PRINT @FechaFinal
	-- Se incrementa en un dia
	SET @FechaFinal = DATEADD(d,1,@FechaFinal)

END -- del WHILE

GO

