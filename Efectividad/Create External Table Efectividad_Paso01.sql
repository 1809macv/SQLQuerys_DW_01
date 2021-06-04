/****** Object:  Table [PIVOT].[extPagos]    Script Date: 5/24/2019 4:56:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extEfectividad_Paso01]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[Sucursal] [varchar](255) NOT NULL,
	[ClienteNombre] varchar(150) NOT NULL,
	[FechaInicial_ClienteRuta] date NULL,
	[FechaFinal_ClienteRuta] date NULL,
	[VendedorId] bigint NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL,
	[Tipo] [varchar](255) NOT NULL,
	[ZonaNombre] [varchar](100) NOT NULL,
	[RutaDia] [varchar](255) NOT NULL,
	[ValorRutadia] int NULL,
	[DiaSemana] nvarchar(30) NULL,
	[NumeroDiaSemana] int NULL
)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Efectividad_Paso01')
GO


select top 10 * from [PIVOT].extEfectividad_Paso01
