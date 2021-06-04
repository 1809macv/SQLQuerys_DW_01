
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = DATEADD(MONTH, -2, @FechaHoy)

SET @FechaDesde = DATEFROMPARTS(YEAR(@FechaDesde), MONTH(@FechaDesde), 1)

BEGIN TRANSACTION

DELETE FROM [PIVOT].[Pagos]
WHERE FechaGasto >= @FechaDesde
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
		WHERE FechaGasto >= @FechaDesde and FechaGasto < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
