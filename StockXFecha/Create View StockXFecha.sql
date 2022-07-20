/****** Object:  View [PIVOT].[StockXFecha]    Script Date: 31/03/2022 9:19:38 ******/

SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

ALTER VIEW [PIVOT].[StockXFecha]
WITH SCHEMABINDING
AS

SELECT DistribuidorId
      ,Distribuidor
      ,AlmacenId 
      ,Almacen 
	  ,YEAR(FechaTransaccion) AS AnioStock
	  ,CASE Month(FechaTransaccion) 
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
	   END AS MesStock
	  ,FechaTransaccion AS FechaStock
	  ,ProductoId
      ,ProductoCodigo, ProductoNombre 
	  ,convert(int, FactorConverion) AS FactorConversion
	  ,NumeroLoteId ,NumeroLote, TipoLote, Negocio, Reclasificacion 
      ,Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto
      ,SUM(Cantidad) AS Cantidad
	  ,COUNT_BIG(*) AS RecordCount
  FROM [PIVOT].[TransaccionesAlmacen] MA 
GROUP BY DistribuidorId, Distribuidor, AlmacenId, Almacen, FechaTransaccion, ProductoId, ProductoCodigo, ProductoNombre, FactorConverion, 
		 NumeroLoteId, NumeroLote, 
         TipoLote, Negocio, Reclasificacion, Segmento, SubRubro, FechaExpiracion, PesoNeto, PesoBruto


GO


