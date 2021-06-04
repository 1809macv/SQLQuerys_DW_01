SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);

BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[CuentasXCobrar]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CuentasXCobrar]
		SELECT CXC.IdDistribuidor
			  , CXC.FechaVenta
			  , CXC.ClienteCodigo
			  , CXC.ClienteNombre
			  , CXC.VendedorId
			  , CXC.VendedorNombre
			  , CXC.Importe 
			  , CXC.PagoParcial 
			  , CXC.Saldo
			  , EstadoCuenta
			  , FechaVencimiento
			  , NumeroGuia
			  , FechaDespacho
			  , NumeroNota
			  , Number
			  , AuthorizationNumber
			  , ControlCode
			  , DiasMora
			  , EstadoVencimiento
			  , RepartidorNombre
			  , ObservacionFactura  
		  FROM [PIVOT].[extCuentasXCobrar] CXC 
		 WHERE FechaVenta < @FechaHoy 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
