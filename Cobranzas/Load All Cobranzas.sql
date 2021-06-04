BEGIN TRANSACTION

TRUNCATE TABLE [PIVOT].[Cobros]

IF ( @@ERROR = 0 )
	BEGIN
		INSERT INTO [PIVOT].[Cobros] 
		SELECT IdDistribuidor
			  ,Distribuidor 
			  ,ClienteNombre
			  ,FechaCobro 
			  ,Observacion
			  ,EstadoDocumento
			  ,TipoTransaccion
			  ,SubTipoTransaccion
			  ,NumeroNIT
			  ,FechaVenta
			  ,ClienteId
			  ,AutorizacionNumero 
			  ,NumeroFactura
			  ,CodigoControl
			  ,VendedorNombre
			  ,MontoCobrado
			  ,NumeroCuenta
			  ,NombreCuenta
			  ,RepartidorNombre
			  ,NumeroGuia
			  ,FechaDespacho
		  FROM [PIVOT].[extCobros] 
		 WHERE FechaCobro >= '2021/01/01'

		IF ( @@ERROR = 0 )
			COMMIT;
		ELSE
			ROLLBACK;
	END
ELSE
	ROLLBACK;
