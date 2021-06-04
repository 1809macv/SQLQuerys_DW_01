/****** Object:  Table [PIVOT].[CoberturaXVendedor]    Script Date: 10/4/2019 11:29:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CoberturaXVendedor_Diario](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesNumero] [smallint] NULL,
	[FechaVenta] [date] NULL,
	[TipoNegocio] [varchar](255) NULL,
	[TipoCliente] [varchar](255) NULL,
	[CategoriaCliente] [varchar](255) NULL,
	[Zona] [varchar](255) NULL,
	[Vendedorid] [bigint] NULL,
	[Vendedor] [varchar](255) NULL,
	[Cobertura] [int] NULL
) ON [PRIMARY]
GO


