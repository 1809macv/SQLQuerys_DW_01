/****** Object:  Table [PIVOT].[extMsCompany]    Script Date: 11/18/2019 4:02:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extMsCustomer]
(
	[Id] [bigint] NOT NULL,
	[Code] [bigint] NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[BusinessName] [varchar](150) NULL,
	[Nit] [varchar](20) NOT NULL,
	[Address] [varchar](300) NOT NULL,
	[Reference] [varchar](300) NULL,
	[Phone] [varchar](100) NULL,
	[Latitude] [float] NOT NULL,
	[Longitude] [float] NOT NULL,
	[Active] [bit] NOT NULL,
	[Zona] [varchar](100) NOT NULL,
	[ClienteTipo] [varchar](255) NOT NULL,
	[Categoria] [varchar](255) NOT NULL,
	[TipoRecursivo] [varchar](250) NOT NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'MsCustomer')
GO


