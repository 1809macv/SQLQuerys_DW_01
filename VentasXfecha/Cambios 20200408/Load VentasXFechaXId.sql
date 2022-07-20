
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE)
--DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -2);
DECLARE @FechaDesde DATE = DATEADD(day,-31, @FechaHoy);
DECLARE @DistribuidorId INT = 15

BEGIN TRANSACTION

DELETE FROM [PIVOT].[VentasXFecha]
WHERE IdDistribuidor = @DistribuidorId AND (FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy)
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	INSERT INTO [PIVOT].[VentasXFecha]
		(IdDistribuidor ,FechaVenta, ClienteId ,RazonSocial ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago 
		,IdDocumentoEstado ,DocumentoEstado ,VendedorId ,Vendedor ,AlmacenId ,ProductoId ,Bonificacion ,NumeroLote ,UnidadMedidaVenta 
		,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,CantidadDevuelta ,DescuentoProducto 
		,Descuento2Producto ,UsuarioTransaccion ,CostoPrecioPromedio     --,DescuentoDocumento 
		,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia 
		,ObservacionFactura
		)
		SELECT DistribuidorID ,FechaVenta, ClienteID ,RazonSocial ,NumeroNit, NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago 
			,IdDocumentoEstado ,DocumentoEstado ,VendedorId ,Vendedor ,AlmacenID ,ProductoId ,Bonificacion ,NumeroLote ,UnidadMedidaVenta 
			,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,CantidadDevuelta ,DescuentoProducto 
			,Descuento2Producto     --,DescuentoDocumento 
			,UsuarioTransaccion ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia 
			,RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia ,ObservacionFactura
		FROM [PIVOT].[extVentasXFecha]
		WHERE  ( FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy) AND ( DistribuidorID = @DistribuidorId )

IF @@ERROR <> 0 
	ROLLBACK;
ELSE
	COMMIT;
