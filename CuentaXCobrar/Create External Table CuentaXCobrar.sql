/****** Object:  Table [PIVOT].[extCuentaXCobrar]    Script Date: 11/11/2019 5:18:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCuentasXCobrar]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[FechaVenta] [date] NULL,
	[ClienteCodigo] [bigint] NOT NULL,
	[ClienteNombre] [varchar](100) NOT NULL,
	[VendedorId] [bigint] NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL,
	[Importe] [decimal](18,2) NULL,
	[PagoParcial] [decimal](18,2) NULL,
	[Saldo] [decimal](19,2) NULL,
	[EstadoCuenta] [varchar](17) NOT NULL,
	[FechaVencimiento] [date] NULL,
	[NumeroGuia] [bigint] NOT NULL,
	[FechaDespacho] [date] NULL,
	[NumeroNota] [bigint] NULL,
	[Number] [bigint] NULL,
	[AuthorizationNumber] [varchar](50) NULL,
	[ControlCode] [varchar](50) NULL,
	[DiasMora] [int] NULL,
	[EstadoVencimiento] [varchar](10) NOT NULL,
	[RepartidorNombre] [varchar](200) NOT NULL,
	[ObservacionFactura] [varchar](255) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'CuentasXCobrar')
GO


