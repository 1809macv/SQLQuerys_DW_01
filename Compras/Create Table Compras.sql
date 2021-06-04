/****** Object:  Table [PIVOT].[Compras]    Script Date: 1/4/2020 2:47:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[Compras](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [nvarchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[Proveedor] [varchar](50) NULL,
	[FechaCompra] [date] NULL,
	[NumeroFactura] [int] NULL,
	[FechaFactura] [date] NULL,
	[NumeroAutorizacion] [varchar](50) NULL,
	[CodigoControl] [varchar](50) NULL,
	[EstadoPago] [varchar](255) NULL,
	[Referencia] [varchar](255) NULL,
	[MontoDebito] [decimal](18, 2) NULL,
	[DiasCredito] [int] NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[Subrubro] [varchar](255) NULL,
	[ProductoCodigo] [varchar](50) NULL,
	[ProductoNombre] [varchar](150) NULL,
	[UnidadMedidaAlmacen] [varchar](255) NULL,
	[FactorConversion] [int] NULL,
	[CantidadProducto] [decimal](18, 4) NULL,
	[UnidadMedidaMenor] [varchar](255) NULL,
	[CantidadProductoUnidadMenor] [decimal](29, 4) NULL,
	[CostoUnitario] [decimal](18, 4) NULL,
	[MontoTotalProducto] [decimal](37, 8) NULL,
	[TotalDescuento] [decimal](18, 4) NOT NULL,
	[MontoTotal] [decimal](18, 4) NOT NULL,
	[EstadoDocumento] [varchar](255) NOT NULL,
	[NumeroLote] [varchar](50) NOT NULL, 
	[FechaExpiracion] [date] NOT NULL
) ON [PRIMARY]
GO


