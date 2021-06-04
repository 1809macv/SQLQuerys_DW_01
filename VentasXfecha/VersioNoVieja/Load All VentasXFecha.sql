
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @DistribuidorId INT = 3
DECLARE @MaxDistribuidorId INT = (SELECT Max(Id) FROM [PIVOT].[extMsCompany])

BEGIN TRANSACTION

TRUNCATE TABLE [PIVOT].[VentasXFecha]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
WHILE (@DistribuidorId <= @MaxDistribuidorId)
	BEGIN
		INSERT INTO [PIVOT].[VentasXFecha]
		  (IdDistribuidor ,FechaVenta ,Zona ,ClienteTipo ,Categoria ,TipoRecursivo 
		  ,ClienteCodigo ,RazonSocial ,ClienteNombre ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago 
		  ,IdDocumentoEstado, DocumentoEstado 
		  ,Vendedor ,Almacen ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,ProductoCodigo ,ProductoNombre ,Bonificacion ,NumeroLote 
		  ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,DescuentoProducto 
		  ,Descuento2Producto ,DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto ,TotalKilosNetos ,TotalKilosBrutos
		  ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre 
		  ,FechaCreacionGuia ,FechaDespachoGuia ,ObservacionFactura
		  )
		 SELECT DistribuidorID 
			   ,FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo
			   ,ClienteCodigo ,RazonSocial ,ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago
			   ,IdDocumentoEstado, DocumentoEstado
			   ,Vendedor, Almacen, Negocio ,Reclasificacion, Segmento, SubRubro ,ProductoCodigo ,ProductoNombre
			   ,Bonificacion ,NumeroLote ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto 
			   ,TotalProducto ,DescuentoProducto ,Descuento2Producto, DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto
			   ,TotalKilosNetos, TotalKilosBrutos ,CostoPrecioPromedio, TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje
			   ,NumeroGuia, EstadoGuia, RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia ,ObservacionFactura
		   FROM [PIVOT].[extVentasXFecha]
		  WHERE ( FechaVenta < @FechaHoy) and  ( DistribuidorID = @DistribuidorId )
		IF @@ERROR <> 0
			BREAK

		SET @DistribuidorId = @DistribuidorId + 1
	END

	IF @@ERROR <> 0 
		ROLLBACK;
	ELSE
		COMMIT;
