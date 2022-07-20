/****** Object:  Table [PIVOT].[extPagos]    Script Date: 5/24/2019 4:56:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extEfectividad_Paso00]
(
	[IdDistribuidor] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[Sucursal] [varchar](255) NOT NULL,
	[FechaVenta] date NULL,
	[SemanaMes] int NULL,
	[NumeroSemana] int NULL,
	[VendedorId] bigint NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Efectividad_Paso00')
GO


select * from [PIVOT].extEfectividad_Paso00
where IdDistribuidor = 16
order by FechaVenta
