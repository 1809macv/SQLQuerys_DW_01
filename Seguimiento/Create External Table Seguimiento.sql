/****** Object:  Table [PIVOT].[extSeguimiento]    Script Date: 11/1/2019 11:05:17 PM ******/
DROP EXTERNAL TABLE [PIVOT].[extSeguimiento]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extSeguimiento]
(
	[DistribuidorId] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[Secuencia] [int] NOT NULL,
	[ClienteCodigo] [bigint] NOT NULL,
	[ClienteNombre] [varchar](150) NOT NULL,
	[Fecha] [date] NULL,
	[HoraInicio] [time](7) NULL,
	[HoraFin] [time](7) NULL,
	[VendedorId] [bigint] NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL,
	[Motivo] [varchar](50) NOT NULL,
	[DiaNombre] [varchar](255) NOT NULL,
	[TieneGPS] [varchar](2) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Seguimiento')
GO


--select top 10 * from [PIVOT].extSeguimiento
