/****** Object:  Table [PIVOT].[StockActual]    Script Date: 4/8/2021 10:53:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[StockActual]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	IdAlmacen [bigint] NOT NULL,
	[Almacen] [varchar](100) NOT NULL, 
	IdProducto [bigint] NOT NULL,
	[ProductoCodigo] [varchar](50) NOT NULL,
	[ProductNombre] [varchar](150) NOT NULL,
	[UnidadMedidaAlmacen] [varchar](255) NULL,
	[CantidadAlmacen] [decimal](24, 16) NULL,
	[UnidadMedidaVenta] [varchar](255) NULL,
	[CantidadUnidadMenor] [decimal](35, 16) NULL,
	[FactorConverion] [int] NULL,
	[NumeroLote] [varchar](50) NULL,
	[TipoLote] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[FechaExpiracion] [date] NOT NULL,
	[PesoNeto] [decimal](18, 4) NULL,
	[PesoBruto] [decimal](18, 4) NULL,
	[CostoUC] [decimal](18, 4) NULL,
	[CostoPPP] [decimal](18, 4) NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'StockActual')
GO


