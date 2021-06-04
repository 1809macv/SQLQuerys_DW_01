DECLARE @FechaFinal DATE = DATEFROMPARTS(2020,12,31)

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
	 WHERE FechaTransaccion <= @FechaFinal and DistribuidorId = 3 and Productocodigo = '1010638'
	GROUP BY DistribuidorId, Distribuidor, AlmacenId, Almacen, ProductoId, ProductoCodigo, ProductoNombre, FactorConverion, 
			 NumeroLoteId, NumeroLote, 
			 TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
	HAVING (1.0000 /  FactorConverion) <= ABS(SUM(Cantidad)) 
--order by Productocodigo