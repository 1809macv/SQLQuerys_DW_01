
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 

BEGIN TRANSACTION

TRUNCATE TABLE [PIVOT].[Pagos]
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT [PIVOT].[Pagos]
		SELECT IdDistribuidor ,Distribuidor, Proveedor   
			  ,FechaGasto, Observacion, EstadoDocumento, TipoTransaccion   
			  ,SubTipoTransaccion ,NumeroNIT ,AutorizacionNumero ,NumeroFactura ,CodigoControl ,TipoMovimiento 
			  ,Debe 
			  ,Haber 
			  ,NumeroCuenta ,NombreCuenta 
		  FROM [PIVOT].[extPagos]
		WHERE FechaGasto < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
