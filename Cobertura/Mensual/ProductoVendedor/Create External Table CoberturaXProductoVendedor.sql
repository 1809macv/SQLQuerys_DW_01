/****** Object:  Table [PIVOT].[extCoberturaXProductoVendedor_Mensual]    Script Date: 11/18/2020 16:50:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCoberturaXProductoVendedor_Mensual]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[AnioVenta] [int] NULL,
	[MesVenta] [int] NULL,
	[CustomerId] [bigint] NOT NULL,
	[SellerId] [bigint] NOT NULL,
	[SellerName] [varchar](200) NOT NULL,
	[ProductId] [bigint] NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'CoberturaXProductoVendedor_Mensual')
GO


