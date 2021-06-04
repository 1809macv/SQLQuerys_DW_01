SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXProducto_Diario]
WHERE FechaVenta > @FechaDesde;

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXProducto_Diario]
		SELECT IdDistribuidor ,Distribuidor ,Ciudad 
			  ,Year(FechaVenta)
			  ,Mes.Id 
			  ,FechaVenta ,TipoNegocio ,TipoCliente ,CategoriaCliente 
			  ,Zona ,CustomerId ,ClienteNombre ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,ProductoCodigo ,ProductoNombre ,Cobertura
		  FROM [PIVOT].[extCoberturaXProducto_Diario] CxP
			   INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = MONTH(CxP.FechaVenta)
		 WHERE FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
