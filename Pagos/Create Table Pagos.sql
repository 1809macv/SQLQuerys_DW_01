/****** Object:  Table [PIVOT].[Pagos]    Script Date: 3/7/2021 5:06:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[Pagos](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Proveedor] [varchar](100) NULL,
	[FechaGasto] [date] NOT NULL,
	[Observacion] [varchar](max) NULL,
	[EstadoDocumento] [varchar](255) NULL,
	[TipoTransaccion] [varchar](250) NULL,
	[SubtipoTransaccion] [varchar](250) NULL,
	[NumeroNIT] [varchar](50) NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[NumeroFactura] [bigint] NULL,
	[CodigoControl] [varchar](50) NULL,
	[TipoMovimiento] [varchar](255) NULL,
	[Debe] [decimal](18, 2) NULL,
	[Haber] [decimal](18, 2) NULL,
	[NumeroCuenta] [varchar](20) NULL,
	[NombreCuenta] [varchar](60) NULL
) ON [PRIMARY]
GO


