SELECT Company.[Name] AS Distribuidor
      ,Company.[Contact] AS NombreContacto
      ,Company.[CiudadNombre] AS Ciudad
      ,Year(Ventas.[FechaVenta]) AS AnioVenta
      ,Mes.[Nombre] AS MesVenta
      ,Ventas.[FechaVenta]
      ,Customer.[Zona]
      ,Customer.[ClienteTipo]
      ,Customer.[Categoria]
      ,Customer.[TipoRecursivo]
      ,Customer.[Code] AS ClienteCodigo
      ,Ventas.[RazonSocial]
      ,Customer.[Name] AS ClienteNombre
      ,Ventas.[NumeroNit]
      ,Ventas.[NumeroFactura]
      ,Ventas.[AutorizacionNumero]
      ,Ventas.[CodigoControl]
      ,Ventas.[TipoPago]
      ,Ventas.[DocumentoEstado]
      ,Ventas.[Vendedor]
      ,Store.[Name] AS Almacen
      ,Product.[Negocio]
      ,Product.[Reclasificacion]
      ,Product.[Segmento]
      ,Product.[SubRubro]
      ,Product.[Code] AS ProductoCodigo
      ,Product.[Name] AS ProductoNombre
      ,Ventas.[Bonificacion]
      ,Ventas.[NumeroLote]
      ,Ventas.[UnidadMedidaVenta]
      ,Ventas.[FactorConversion]
      ,Ventas.[ListaPrecio]
      ,Ventas.[CantDISP_UN]
      ,Ventas.[CantBU]
      ,Ventas.[PrecioProducto]
      ,Ventas.[TotalProducto]
	  ,Ventas.[CantidadDevuelta]
      ,Ventas.[Descuento2Producto]
      ,Ventas.[DescuentoDocumento]
      ,Ventas.[UsuarioTransaccion]
      ,Product.[Weight] AS PesoNeto
      ,Product.[TotalWeight] AS PesoBruto
	  ,(Product.[Weight] * Ventas.[CantDISP_UN] / Ventas.[FactorConversion] )
	  ,(Product.[TotalWeight] * Ventas.[CantDISP_UN] / Ventas.[FactorConversion]) AS TotalKilosBrutos
      ,Ventas.[CostoPrecioPromedio]
      ,Ventas.[TotalCostoPromedio]
      ,Ventas.[CMB_Monto]
      ,Ventas.[CMB_Porcentaje]
      ,Ventas.[NumeroGuia]
      ,Ventas.[EstadoGuia]
      ,Ventas.[RepartidorNombre]
      ,Year(Ventas.[FechaDespachoGuia]) as AnioGuia
      ,Month(Ventas.[FechaDespachoGuia]) as MesGuia
      ,Ventas.[FechaCreacionGuia] 
      ,Ventas.[FechaDespachoGuia] 
      ,Ventas.[ObservacionFactura]
  FROM [PIVOT].[VentasXFecha_NuevosCambios] Ventas
		INNER JOIN [PIVOT].[extMsCompany] Company ON Company.Id = Ventas.IdDistribuidor 
		INNER JOIN [PIVOT].[extMsCustomer] Customer ON Customer.Id = Ventas.ClienteId 
		INNER JOIN [PIVOT].[extMsStore] Store ON Store.Id = Ventas.AlmacenID 
		INNER JOIN [PIVOT].[extMsProduct] Product ON Product.Id = Ventas.ProductoID 
		INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = Month(Ventas.[FechaVenta]) 


 --,(Prd.Weight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosNetos 
 --,(Prd.TotalWeight*SaleD.Quantity/CUnit.Equivalence) AS TotalKilosBrutos
 --,Ventas.[DescuentoProducto]
