/****** Object:  Table [PIVOT].[extCompras]    Script Date: 1/4/2020 2:46:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCompras]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[Ciudad] [varchar](255) NOT NULL,
	[Proveedor] [varchar](50) NOT NULL,
	[FechaCompra] [date] NULL,
	[NumeroFactura] [int] NOT NULL,
	[FechaFactura] [date] NULL,
	[NumeroAutorizacion] [varchar](70) NULL,
	[CodigoControl] [varchar](50) NULL,
	[EstadoPago] [varchar](255) NOT NULL,
	[Referencia] [varchar](255) NOT NULL,
	[MontoDebito] [decimal](18, 2) NOT NULL,
	[DiasCredito] [int] NOT NULL,
	[Negocio] [varchar](255) NOT NULL,
	[Reclasificacion] [varchar](255) NOT NULL,
	[Segmento] [varchar](255) NOT NULL,
	[SubRubro] [varchar](255) NOT NULL,
	[ProductoCodigo] [varchar](50) NOT NULL,
	[ProductoNombre] [varchar](150) NOT NULL,
	[UnidadMedidaAlmacen] [varchar](255) NOT NULL,
	[FactorConversion] [int] NULL,
	[CantidadProducto] [decimal](24, 16) NOT NULL,
	[UnidadMedidaMenor] [varchar](255) NOT NULL,
	[CantidadProductoUnidadMenor] [decimal](35, 16) NULL,
	[CostoUnitario] [decimal](18, 4) NOT NULL,
	[MontoTotalProducto] [decimal](38, 15) NULL,
	[TotalDescuento] [decimal](18, 4) NOT NULL,
	[MontoTotal] [decimal](18, 4) NOT NULL,
	[EstadoDocumento] [varchar](255) NOT NULL, 
	[NumeroLote] [varchar](50) NOT NULL, 
	[FechaExpiracion] [date] NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Compras')
GO


