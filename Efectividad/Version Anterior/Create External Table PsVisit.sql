/****** Object:  Table [PIVOT].[extPsVisit]    Script Date: 5/24/2019 10:57:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [PIVOT].[extPsVisit]
(
	   [Id] bigint NOT NULL
      ,[UserId] bigint NOT NULL
      ,[CustomerId] bigint NOT NULL
      ,[ReasonId] bigint NOT NULL
      ,[VisitDate] datetime NOT NULL
      ,[Observation] varchar(250) NOT NULL
      ,[Latitude] float NOT NULL
      ,[Longitude] float NOT NULL
      ,[ReferenceId] bigint NOT NULL
      ,[CompanyId] bigint NOT NULL
      ,[Autogenerated] bigint NULL
)
WITH (DATA_SOURCE = [srcArcor],SCHEMA_NAME = N'Sales',OBJECT_NAME = N'PsVisit')
GO


