/****** Object:  Table [PIVOT].[StockXFecha]    Script Date: 4/8/2021 11:51:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[StockXFecha](
	[DistribuidorId] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[AlmacenId] [bigint] NULL,
	[Almacen] [varchar](100) NULL,
	[AnioStock] [int] NULL,
	[MesStock] [varchar](80) NULL,
	[FechaStock] [date] NULL,
	[ProductoId] [bigint] NULL,
	[ProductoCodigo] [varchar](50) NULL,
	[ProductoNombre] [varchar](150) NULL,
	[FactorConversion] [smallint] NULL,
	[NumeroLoteId] [bigint] NULL,
	[NumeroLote] [varchar](50) NULL,
	[TipoLote] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[FechaExpiracion] [date] NULL,
	[PesoNeto] [decimal](18, 7) NULL,
	[PesoBruto] [decimal](18, 7) NULL,
	[Cantidad] [decimal](26, 16) NULL
) ON [PRIMARY]
GO


