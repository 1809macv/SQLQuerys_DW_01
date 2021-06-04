/****** Object:  Table [PIVOT].[extMsCompany]    Script Date: 11/18/2019 4:02:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extMsCompany]
(
	[Id] [bigint] NOT NULL,
	[TypeIdc] [bigint] NOT NULL,
	[CityIdc] [bigint] NOT NULL,
	[CiudadNombre] [varchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Address] [nvarchar](300) NOT NULL,
	[Telephone] [nvarchar](50) NOT NULL,
	[Activity] [nvarchar](500) NOT NULL,
	[Reference] [nvarchar](500) NOT NULL,
	[Active] [bit] NOT NULL,
	[Contact] [nvarchar](150) NULL,
	[Email] [nvarchar](50) NULL,
	[Code] [bigint] NOT NULL,
	[Nit] [varchar](20) NOT NULL,
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'MsCompany')
GO


