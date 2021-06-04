/****** Object:  Table [PIVOT].[CoberturaXProducto]    Script Date: 10/4/2019 11:31:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CoberturaXProducto_Diario](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesNumero] [int] NULL,
	[FechaVenta] [date] NULL,
	[TipoNegocio] [varchar](255) NULL,
	[TipoCliente] [varchar](255) NULL,
	[CategoriaCliente] [varchar](255) NULL,
	[Zona] [varchar](255) NULL,
	[Customerid] [bigint] NULL,
	[ClienteNombre] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[Subrubro] [varchar](255) NULL,
	[ProductoCodigo] [varchar](20) NULL,
	[ProductoNombre] [varchar](255) NULL,
	[Cobertura] [int] NULL
) ON [PRIMARY]
GO


