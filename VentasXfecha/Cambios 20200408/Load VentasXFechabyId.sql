
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -2);
print @FechaDesde
DECLARE @DistribuidorId INT = 15
--DECLARE @MaxDistribuidorId INT = (SELECT Max(Id) FROM [PIVOT].[extMsCompany])

BEGIN TRANSACTION

DELETE FROM [PIVOT].[VentasXFecha_CargaVendedorId]
WHERE ( IdDistribuidor = @DistribuidorId AND FechaVenta > @FechaDesde)
--WHERE ( FechaVenta > @FechaDesde ) and  ( IdDistribuidor = 14 )
IF @@ERROR <> 0
	ROLLBACK;
ELSE
--WHILE (@DistribuidorId <= @MaxDistribuidorId)
--	BEGIN
		INSERT INTO [PIVOT].[VentasXFecha_CargaVendedorId]
		  (IdDistribuidor ,FechaVenta, ClienteId ,RazonSocial ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago 
		  ,IdDocumentoEstado ,DocumentoEstado ,VendedorId ,Vendedor ,AlmacenId ,ProductoId ,Bonificacion ,NumeroLote ,UnidadMedidaVenta 
		  ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,CantidadDevuelta ,DescuentoProducto 
		  ,Descuento2Producto ,UsuarioTransaccion ,CostoPrecioPromedio 
		  ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia 
		  ,ObservacionFactura
		  )
		 SELECT DistribuidorID ,FechaVenta, ClienteID ,RazonSocial ,NumeroNit, NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago 
			   ,IdDocumentoEstado ,DocumentoEstado ,VendedorId ,Vendedor ,AlmacenID ,ProductoId ,Bonificacion ,NumeroLote ,UnidadMedidaVenta 
			   ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,CantidadDevuelta ,DescuentoProducto 
			   ,Descuento2Producto 
			   ,UsuarioTransaccion ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia 
			   ,RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia ,ObservacionFactura
		   FROM [PIVOT].[extVentasXFecha]
		  WHERE ( FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy) AND ( DistribuidorID = @DistribuidorId )
		  --WHERE ( FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy) AND ( DistribuidorID = 14 )
	--	IF @@ERROR <> 0
	--		BREAK

	--	SET @DistribuidorId = @DistribuidorId + 1
	--END

IF @@ERROR <> 0 
	ROLLBACK;
ELSE
	COMMIT;
