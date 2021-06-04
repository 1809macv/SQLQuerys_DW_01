/****** Object:  Table [PIVOT].[CoberturaXCliente_Mensual]    Script Date: 10/15/2019 11:08:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CoberturaXCliente_Mensual](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesNumero] [smallint] NULL,
	[TipoNegocio] [varchar](255) NULL,
	[TipoCliente] [varchar](255) NULL,
	[CategoriaCliente] [varchar](255) NULL,
	[Zona] [varchar](255) NULL,
	[ClienteCodigo] [bigint] NULL, 
	[ClienteNombre] [varchar](150) NULL, 
	[Cobertura] [int] NULL
) ON [PRIMARY]
GO


