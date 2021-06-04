CREATE EXTERNAL TABLE [PIVOT].[extMsUser]
(
	[Id] [bigint] NOT NULL,
	[TypeIdc] [bigint] NOT NULL,
	[Classifier] [varchar](255) NOT NULL,
	[CompanyId] [bigint] NULL,
	[CompanyName] [nvarchar](255) NOT NULL,
	[UserCode] [varchar](10) NOT NULL,
	[UserName] [varchar](200) NOT NULL,
	[UserEmail] [varchar](50) NULL,
	[PhoneNumber] [varchar](20) NOT NULL,
	[Active] [bit] NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'MsUser')
GO

