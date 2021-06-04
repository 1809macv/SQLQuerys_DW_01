/****** Object:  Table [PIVOT].[CoberturaXCliente]    Script Date: 10/7/2019 5:24:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CoberturaXCliente_Diario](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesNumero] [int] NULL,
	[FechaVenta][date] NULL,
	[TipoNegocio] [varchar](255) NULL,
	[TipoCliente] [varchar](255) NULL,
	[CategoriaCliente] [varchar](255) NULL,
	[Zona] [varchar](255) NULL,
	[ClienteCodigo] [bigint] NULL,
	[ClienteNombre] [varchar](150) NULL, 
	[Cobertura] [int] NULL
) ON [PRIMARY]
GO


