/****** Object:  Table [PIVOT].[CoberturaXCliente]    Script Date: 10/7/2019 5:24:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[CuentasXCobrar](
	[IdDistribuidor] [bigint] NULL,
	[FechaVenta][date] NULL,
	[ClienteCodigo] [bigint] NULL,
	[ClienteNombre] [varchar](100) NULL,
	[VendedorId] [bigint] NULL,
	[VendedorNombre] [varchar](200) NULL,
	[Importe] [decimal](18,2) NULL,
	[PagoParcial] [decimal](18,2) NULL,
	[Saldo] [decimal](19,2) NULL,
	[EstadoCuenta] [varchar](17) NULL,
	[FechaVencimiento] [date] NULL,
	[NumeroGuia] [bigint] NULL,
	[FechaDespacho] [date] NULL,
	[NumeroNota] [bigint] NULL,
	[NumeroFactura] [bigint] NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[CodigoControl] [varchar](50) NULL,
	[DiasMora] [int] NULL,
	[EstadoVencimiento] [varchar](10) NULL,
	[RepartidorNombre] [varchar](200) NULL,
	[ObservacionFactura] [varchar](255) NULL
) ON [PRIMARY]
GO


