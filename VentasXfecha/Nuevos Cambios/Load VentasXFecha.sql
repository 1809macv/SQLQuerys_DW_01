
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE
DECLARE @DistribuidorId INT = 3

SET @FechaDesde = DATEADD(MONTH, -2, @FechaHoy)
SET @FechaDesde = DATEFROMPARTS(YEAR(@FechaDesde), MONTH(@FechaDesde), 1)

BEGIN TRANSACTION

DELETE FROM [PIVOT].[VentasXFecha]
WHERE FechaVenta >= @FechaDesde
IF @@ERROR <> 0
	BEGIN
		ROLLBACK;
	END
ELSE
WHILE (@DistribuidorId <= 10)
	BEGIN
		INSERT INTO [PIVOT].[VentasXFecha]
		  (IdDistribuidor ,Distribuidor, NombreContacto ,Ciudad ,AnioVenta ,MesVenta ,FechaVenta ,Zona ,ClienteTipo ,Categoria ,TipoRecursivo 
		  ,ClienteCodigo ,RazonSocial ,ClienteNombre ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago ,DocumentoEstado 
		  ,Vendedor ,Almacen ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,ProductoCodigo ,ProductoNombre ,Bonificacion ,NumeroLote 
		  ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,DescuentoProducto 
		  ,Descuento2Producto ,DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto ,TotalKilosNetos ,TotalKilosBrutos
		  ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre 
		  ,FechaCreacionGuia ,FechaDespachoGuia ,Descripcion
		  )
		 SELECT DistribuidorID ,Distribuidor ,NombreContacto ,Ciudad
		       ,AnioVenta
			   ,MesVenta 
			   ,FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo
			   ,ClienteCodigo ,RazonSocial ,ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado
			   ,Vendedor, Almacen, Negocio ,Reclasificacion, Segmento, SubRubro ,ProductoCodigo ,ProductoNombre
			   ,Bonificacion ,NumeroLote ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto 
			   ,TotalProducto ,DescuentoProducto ,Descuento2Producto, DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto
			   ,TotalKilosNetos, TotalKilosBrutos ,CostoPrecioPromedio, TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje
			   ,NumeroGuia, EstadoGuia, RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia ,Descripcion
		   FROM [PIVOT].[extVentasXFecha]
		  WHERE ( FechaVenta >= @FechaDesde AND FechaVenta < @FechaHoy) and  ( DistribuidorID = @DistribuidorId )
		IF @@ERROR <> 0
			BEGIN
				BREAK
			END

		SET @DistribuidorId = @DistribuidorId + 1
	END

	IF @@ERROR <> 0 
		BEGIN
			ROLLBACK;
		END
	ELSE
		BEGIN
			COMMIT;
		END
