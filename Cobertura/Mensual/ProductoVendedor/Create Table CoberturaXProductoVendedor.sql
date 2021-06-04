/****** Object:  Table [PIVOT].[CoberturaXProductoVendedor_Mensual]    Script Date: 11/18/2020 17:01:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CoberturaXProductoVendedor_Mensual](
	[IdDistribuidor] [bigint] NULL,
	[AnioVenta] [int] NULL,
	[MesNumero] [smallint] NULL,
	[CustomerId] [bigint] NULL,
	[SellerId] [bigint] NULL,
	[SellerName] [varchar](200) NULL,
	[ProductId] [bigint] NULL,
	[Cobertura] [int] NULL
) ON [PRIMARY]
GO


