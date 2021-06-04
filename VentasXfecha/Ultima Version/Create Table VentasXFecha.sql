/****** Object:  Table [PIVOT].[VentasXFecha]    Script Date: 11/12/2019 11:13:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[VentasXFecha](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[NombreContacto] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesVenta] [varchar](20) NULL,
	[FechaVenta] [date] NULL,
	[Zona] [varchar](255) NULL,
	[ClienteTipo] [varchar](255) NULL,
	[Categoria] [varchar](5) NULL,
	[TipoRecursivo] [varchar](255) NULL,
	[ClienteCodigo] [varchar](15) NULL,
	[RazonSocial] [varchar](255) NULL,
	[ClienteNombre] [varchar](255) NULL,
	[NumeroNit] [varchar](15) NULL,
	[NumeroFactura] [varchar](15) NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[CodigoControl] [varchar](25) NULL,
	[TipoPago] [varchar](20) NULL,
	[DocumentoEstado] [varchar](20) NULL,
	[Vendedor] [varchar](255) NULL,
	[Almacen] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[ProductoCodigo] [varchar](15) NULL,
	[ProductoNombre] [varchar](255) NULL,
	[Bonificacion] [varchar](2) NULL,
	[NumeroLote] [varchar](50) NULL,
	[UnidadMedidaVenta] [varchar](255) NULL,
	[FactorConversion] [int] NULL,
	[ListaPrecio] [varchar](255) NULL,
	[CantDISP_UN] [decimal](25, 6) NULL,
	[CantBU] [decimal](25, 6) NULL,
	[PrecioProducto] [decimal](25, 6) NULL,
	[TotalProducto] [decimal](25, 6) NULL,
	[DescuentoProducto] [decimal](25, 6) NULL,
	[Descuento2Producto] [decimal](25, 6) NULL,
	[DescuentoDocumento] [decimal](25, 6) NULL,
	[UsuarioTransaccion] [varchar](255) NULL,
	[PesoNeto] [decimal](25, 6) NULL,
	[PesoBruto] [decimal](25, 6) NULL,
	[TotalKilosNetos] [decimal](25, 6) NULL,
	[TotalKilosBrutos] [decimal](25, 6) NULL,
	[CostoPrecioPromedio] [decimal](25, 6) NULL,
	[TotalCostoPromedio] [decimal](25, 6) NULL,
	[CMB_Monto] [decimal](25, 6) NULL,
	[CMB_Porcentaje] [decimal](25, 6) NULL,
	[NumeroGuia] [varchar](15) NULL,
	[EstadoGuia] [varchar](50) NULL,
	[RepartidorNombre] [varchar](255) NULL,
	[FechaCreacionGuia] [date] NULL,
	[FechaDespachoGuia] [date] NULL,
	[ObservacionFactura] [varchar](250) NULL
) ON [PRIMARY]
GO


