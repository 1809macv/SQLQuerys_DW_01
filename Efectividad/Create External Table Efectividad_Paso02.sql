/****** Object:  Table [PIVOT].[extPagos]    Script Date: 5/24/2019 4:56:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extEfectividad_Paso02]
(
	[DistribuidorId] [bigint] NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL,
	[ClienteNombre] varchar(100) NOT NULL,
	[VendedorId] bigint NOT NULL,
	[FechaVenta] date NULL
)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Efectividad_Paso02')
GO


select top 10 * from [PIVOT].extEfectividad_Paso02
