/****** Object:  Table [PIVOT].[extTransaccionesAlmacen]    Script Date: 4/8/2021 11:31:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extTransaccionesAlmacen]
(
	[DistribuidorId] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[AlmacenId] [bigint] NOT NULL,
	[Almacen] [varchar](100) NOT NULL,
	[FechaTransaccion] [date] NULL,
	[ProductoId] [bigint] NOT NULL,
	[ProductoCodigo] [varchar](50) NOT NULL,
	[ProductoNombre] [varchar](150) NOT NULL,
	[FactorConverion] [int] NULL,
	[NumeroLoteId] [bigint] NOT NULL,
	[NumeroLote] [varchar](50) NOT NULL,
	[TipoLote] [varchar](255) NOT NULL,
	[Negocio] [varchar](255) NOT NULL,
	[Reclasificacion] [varchar](255) NOT NULL,
	[Segmento] [varchar](255) NOT NULL,
	[SubRubro] [varchar](255) NOT NULL,
	[FechaExpiracion] [date] NULL,
	[PesoNeto] [decimal](18, 7) NULL,
	[PesoBruto] [decimal](18, 7) NULL,
	[TransaccionId] [bigint] NOT NULL,
	[TipoTransaccion] [varchar](250) NOT NULL,
	[TipoMovimiento] [varchar](7) NULL,
	[Cantidad] [decimal](26, 16) NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'TransaccionesAlmacen')
GO


