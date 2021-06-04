/****** Object:  Table [PIVOT].[extMsCompany]    Script Date: 11/18/2019 4:02:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extMsStore]
(
	[Id] [bigint] NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[Code] [varchar](10) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Address] [varchar](250) NOT NULL,
	[Type] [varchar](255) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'MsStore')
GO


