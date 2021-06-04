/****** Object:  Table [PIVOT].[extVentasXFecha]    Script Date: 10/4/2019 3:33:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extVentasXFecha]
(
	[DistribuidorID] [bigint] NOT NULL,
	--[Distribuidor] [nvarchar](255) NOT NULL,
	--[NombreContacto] [nvarchar](150) NULL,
	[Ciudad] [varchar](255) NULL,
	[FechaVenta] [date] NULL,
	[Zona] [varchar](100) NULL,
	[ClienteTipo] [varchar](255) NULL,
	[Categoria] [varchar](255) NULL,
	[TipoRecursivo] [varchar](250) NULL,
	[ClienteCodigo] [bigint] NULL,
	[RazonSocial] [varchar](100) NULL,
	[ClienteNombre] [varchar](150) NULL,
	[NumeroNit] [varchar](20) NULL,
	[NumeroFactura] [bigint] NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[CodigoControl] [varchar](50) NULL,
	[TipoPago] [varchar](255) NULL,
	[DocumentoEstado] [varchar](255) NULL,
	[Vendedor] [varchar](200) NULL,
	[Almacen] [varchar](100) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[ProductoCodigo] [varchar](50) NULL,
	[ProductoNombre] [varchar](150) NULL,
	[Bonificacion] [varchar](2) NULL,
	[NumeroLote] [varchar](50) NULL,
	[UnidadMedidaVenta] [varchar](255) NULL,
	[FactorConversion] [int] NULL,
	[ListaPrecio] [varchar](50) NULL,
	[CantDISP_UN] [decimal](18, 2) NULL,
	[UnidadMedidaAlmacen] [varchar](255) NULL,
	[CantBU] [decimal](29, 13) NULL,
	[PrecioProducto] [decimal](18, 3) NULL,
	[TotalProducto] [decimal](18, 3) NULL,
	[DescuentoProducto] [decimal](38, 6) NULL,
	[Descuento2Producto] [decimal](38, 6) NULL,
	[DescuentoDocumento] [decimal](38, 20) NULL,
	[UsuarioTransaccion] [varchar](200) NULL,
	[PesoNeto] [decimal](18, 7) NULL,
	[PesoBruto] [decimal](18, 7) NULL,
	[TotalKilosNetos] [decimal](38, 10) NULL,
	[TotalKilosBrutos] [decimal](38, 10) NULL,
	[CostoPrecioPromedio] [decimal](29, 15) NULL,
	[TotalCostoPromedio] [decimal](38, 7) NULL,
	[CMB_Monto] [decimal](38, 7) NULL,
	[CMB_Porcentaje] [decimal](38, 6) NULL,
	[NumeroGuia] [bigint] NULL,
	[EstadoGuia] [varchar](255) NULL,
	[RepartidorNombre] [varchar](200) NULL,
	[FechaCreacionGuia] [date] NULL,
	[FechaDespachoGuia] [date] NULL,
	[Descripcion] [varchar](250) NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'VentasXFecha')
GO


