/****** Object:  Table [PIVOT].[extMsProduct]    Script Date: 11/18/2019 4:02:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extMsProduct]
(
	[Id] [bigint] NOT NULL,
	[CompanyId] [bigint] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](150) NOT NULL,
	[Description] [varchar](150) NOT NULL,
	[Cost] [decimal](18,2) NULL,
	[IsCombo] [bit] NOT NULL,
	[IsBase] [bit] NOT NULL,
	[ICELitre] [decimal](18,7) NOT NULL,
	[Litre] [decimal](18,7) NOT NULL,
	[Weight] [decimal](18,7) NOT NULL,
	[Volume] [decimal](18,7) NOT NULL,
	[TotalWeight] [decimal](18,7) NOT NULL,
	[Equivalence] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[Negocio] [varchar](255) NOT NULL,
	[Reclasificacion] [varchar](255) NOT NULL, 
	[Segmento] [varchar](255) NOT NULL,
	[SubRubro] [varchar](255) NOT NULL

)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'PIVOT',OBJECT_NAME = N'MsProduct')
GO


