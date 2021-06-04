/****** Object:  Table [PIVOT].[extCoberturaXVendedor_Mensual]    Script Date: 10/7/2019 11:04:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCoberturaXVendedor_Mensual]
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
	[VendedorId] [bigint] NOT NULL,
	[Vendedor] [varchar](200) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[ClienteNombre] [varchar](150) NOT NULL 
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'CoberturaXVendedor_Mensual')
GO


