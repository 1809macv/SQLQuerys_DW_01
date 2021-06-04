/****** Object:  Table [PIVOT].[extCoberturaXProducto_Mensual]    Script Date: 10/7/2019 4:16:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCoberturaXProducto_Mensual]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[Ciudad] [varchar](255) NOT NULL,
	[AnioVenta] [int] NULL,
	[MesVenta] [int] NULL,
	[TipoNegocio] [varchar](250) NOT NULL,
	[TipoCliente] [varchar](255) NOT NULL,
	[CategoriaCliente] [varchar](255) NOT NULL,
	[Zona] [varchar](100) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[ClienteNombre] [varchar](150) NOT NULL,
	[Negocio] [varchar](255) NOT NULL,
	[Reclasificacion] [varchar](255) NOT NULL,
	[Segmento] [varchar](255) NOT NULL,
	[SubRubro] [varchar](255) NOT NULL,
	[ProductoCodigo] [varchar](50) NOT NULL,
	[ProductoNombre] [varchar](150) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'CoberturaXProducto_Mensual')
GO


