SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
--DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[CoberturaXProducto_Mensual]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXProducto_Mensual]
		SELECT IdDistribuidor
			  ,Distribuidor 
			  ,Ciudad 
			  ,AnioVenta 
			  ,MesVenta 
			  ,TipoNegocio 
			  ,TipoCliente 
			  ,CategoriaCliente 
			  ,Zona 
			  ,CustomerId 
			  ,ClienteNombre 
			  ,Negocio 
			  ,Reclasificacion 
			  ,Segmento 
			  ,SubRubro 
			  ,ProductoCodigo 
			  ,ProductoNombre 
			  ,1 
		  FROM [PIVOT].[extCoberturaXProducto_Mensual]
		 WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
