/****** Object:  Table [PIVOT].[extVentasXFecha]    Script Date: 11/12/2019 11:07:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extVentasXFecha]
(
	[DistribuidorID] [bigint] NOT NULL,
	[FechaVenta] [date] NULL,
	[ClienteId] [bigint] NOT NULL,
	[RazonSocial] [varchar](100) NULL,
	[NumeroNit] [varchar](20) NULL,
	[NumeroFactura] [bigint] NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[CodigoControl] [varchar](50) NULL,
	[TipoPago] [varchar](255) NOT NULL,
	[IdDocumentoEstado] [bigint] NOT NULL,
	[DocumentoEstado] [varchar](255) NOT NULL,
	[Vendedor] [varchar](200) NOT NULL,
	[AlmacenID] [bigint] NOT NULL,
	[ProductoID] [bigint] NOT NULL, 
	[Bonificacion] [varchar](2) NULL,
	[NumeroLote] [varchar](50) NULL,
	[UnidadMedidaVenta] [varchar](255) NULL,
	[FactorConversion] [int] NULL,
	[ListaPrecio] [varchar](50) NULL,
	[CantDISP_UN] [decimal](18, 2) NULL,
	[CantBU] [decimal](29, 13) NULL,
	[PrecioProducto] [decimal](18, 3) NULL,
	[TotalProducto] [decimal](18, 3) NULL,
	[CantidadDevuelta] [decimal](18,2) NULL,
	[DescuentoProducto] [decimal](38, 6) NULL,
	[Descuento2Producto] [decimal](38, 6) NULL,
	[UsuarioTransaccion] [varchar](200) NULL,
	[CostoPrecioPromedio] [decimal](29, 15) NULL,
	[TotalCostoPromedio] [decimal](38, 7) NULL,
	[CMB_Monto] [decimal](38, 7) NULL,
	[CMB_Porcentaje] [decimal](38, 6) NULL,
	[NumeroGuia] [bigint] NOT NULL,
	[EstadoGuia] [varchar](255) NULL,
	[RepartidorNombre] [varchar](200) NULL,
	[FechaCreacionGuia] [date] NULL,
	[FechaDespachoGuia] [date] NULL,
	[ObservacionFactura] [varchar](255) NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'VentasXFecha')
GO

