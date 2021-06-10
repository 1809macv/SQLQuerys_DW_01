/****** Object:  Table [PIVOT].[VentasCobertura]    Script Date: 09/06/2021 11:30:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[VentasCobertura](
	[IdDistribuidor] [bigint] NOT NULL,
	[AnioVenta] [bigint] NOT NULL,
	[MesNumero] [bigint] NOT NULL,
	[VendedorId] [bigint] NOT NULL,
	[ProductoId] [bigint] NOT NULL,
    [TotalNeto] [decimal](18,6) NOT NULL,
	[CantidadProducto] [decimal](18,6) NOT NULL,
	[CantidadBultos] [decimal](24,16) NOT NULL,
	[CantidadCobertura] [integer] NULL
) ON [PRIMARY]
GO
