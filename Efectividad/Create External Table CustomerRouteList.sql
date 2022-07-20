SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extCustomerRouteList]
(
	[CompanyId] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[RouteId] [bigint] NOT NULL,
	[InitialDate] [date] NOT NULL,
	[FinalDate] [date] NULL,
	[Sequence] [int] NOT NULL,
	[ZoneId] [bigint] NOT NULL,
	[Active] [bit] NOT NULL,
	[DayIdc] [bigint] NOT NULL,
	[InitialDate_Route] [date] NOT NULL,
	[FinalDate_Route] [date] NULL,
	[NombreDia] [varchar](255) NOT NULL,
	[NumeroDia] [varchar](50) NULL,
	[VendedorId] [bigint] NOT NULL,
	[VendedorNombre] [varchar](200) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],
SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'CustomerRouteList')
GO
