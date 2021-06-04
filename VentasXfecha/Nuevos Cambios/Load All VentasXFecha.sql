
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);
DECLARE @DistribuidorId INT = 3
DECLARE @MaxDistribuidorId INT = (SELECT Max(Id) FROM [PIVOT].[extMsCompany])

BEGIN TRANSACTION

DELETE FROM [PIVOT].[VentasXFecha]
WHERE FechaVenta > @FechaDesde
IF @@ERROR <> 0
	ROLLBACK;
ELSE
WHILE (@DistribuidorId <= @MaxDistribuidorId)
	BEGIN
		INSERT INTO [PIVOT].[VentasXFecha]
		  (IdDistribuidor ,Ciudad ,FechaVenta ,Zona ,ClienteTipo ,Categoria ,TipoRecursivo 
		  ,ClienteCodigo ,RazonSocial ,ClienteNombre ,NumeroNit ,NumeroFactura ,AutorizacionNumero ,CodigoControl ,TipoPago ,DocumentoEstado 
		  ,Vendedor ,Almacen ,Negocio ,Reclasificacion ,Segmento ,SubRubro ,ProductoCodigo ,ProductoNombre ,Bonificacion ,NumeroLote 
		  ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto ,TotalProducto ,DescuentoProducto 
		  ,Descuento2Producto ,DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto ,TotalKilosNetos ,TotalKilosBrutos
		  ,CostoPrecioPromedio ,TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje ,NumeroGuia ,EstadoGuia ,RepartidorNombre 
		  ,FechaCreacionGuia ,FechaDespachoGuia ,Descripcion
		  )
		 SELECT DistribuidorID 
			   --,Distribuidor ,NombreContacto 
			   ,Ciudad
		    --   ,AnioVenta
			   --,MesVenta 
			   ,FechaVenta, Zona, ClienteTipo, Categoria, TipoRecursivo
			   ,ClienteCodigo ,RazonSocial ,ClienteNombre, NumeroNit, NumeroFactura, AutorizacionNumero, CodigoControl, TipoPago, DocumentoEstado
			   ,Vendedor, Almacen, Negocio ,Reclasificacion, Segmento, SubRubro ,ProductoCodigo ,ProductoNombre
			   ,Bonificacion ,NumeroLote ,UnidadMedidaVenta ,FactorConversion ,ListaPrecio ,CantDISP_UN ,CantBU ,PrecioProducto 
			   ,TotalProducto ,DescuentoProducto ,Descuento2Producto, DescuentoDocumento ,UsuarioTransaccion ,PesoNeto ,PesoBruto
			   ,TotalKilosNetos, TotalKilosBrutos ,CostoPrecioPromedio, TotalCostoPromedio ,CMB_Monto ,CMB_Porcentaje
			   ,NumeroGuia, EstadoGuia, RepartidorNombre ,FechaCreacionGuia ,FechaDespachoGuia ,Descripcion
		   FROM [PIVOT].[extVentasXFecha]
		  WHERE ( FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy) and  ( DistribuidorID = @DistribuidorId )
		IF @@ERROR <> 0
			BREAK

		SET @DistribuidorId = @DistribuidorId + 1
	END

	IF @@ERROR <> 0 
		ROLLBACK;
	ELSE
		COMMIT;
