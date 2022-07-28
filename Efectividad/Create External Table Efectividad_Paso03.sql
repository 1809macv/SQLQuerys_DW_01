/****** Object:  Table [PIVOT].[extPagos]    Script Date: 5/24/2019 4:56:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extEfectividad_Paso03]
(
	[DistribuidorId] [bigint] NOT NULL,
	[Distribuidor] [nvarchar](255) NOT NULL,
	[VendedorId] [bigint] NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL,
	[ClienteId] [bigint] NOT NULL,
	[ClienteNombre] [varchar](150) NOT NULL,
	[Fecha] [date] NULL,
	[Tipo] [varchar](6) NOT NULL

)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'Efectividad_Paso03')
GO


select top 10 * from [PIVOT].extEfectividad_Paso03
