SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCobros]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[ClienteNombre] [varchar](100) NULL,
	[FechaCobro] [date] NULL,
	[Observacion] [varchar](max) NULL,
	[EstadoDocumento] [varchar](255) NULL,
	[TipoTransaccion] [varchar](250) NULL,
	[SubTipoTransaccion] [varchar](250) NULL,
	[NumeroNIT] [varchar](20) NULL,
	[FechaVenta] [date] NULL,
	ClienteId [bigint] NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[NumeroFactura] [bigint] NOT NULL,
	[CodigoControl] [varchar](50) NULL,
	[VendedorNombre] [varchar](200) NULL,
	[MontoCobrado] [decimal](18, 2) NULL,
	[NumeroCuenta] [varchar](20) NULL,
	[NombreCuenta] [varchar](60) NULL,
	[RepartidorNombre] [varchar](200) NULL,
	[NumeroGuia] [varchar](20) NULL,
	[FechaDespacho] [date] NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Cobros')
GO


