CREATE EXTERNAL TABLE [PIVOT].[extCoberturaXCliente]
(
	   [IdDistribuidor] bigint NOT NULL
      ,[Distribuidor] nvarchar(255) NOT NULL
      ,[Ciudad] varchar(255) NOT NULL
      ,[AnioVenta] int NULL
      ,[MesVenta] varchar(14) NULL
      ,[MesNumero] int NULL
      ,[TipoNegocio] varchar(250) NOT NULL
      ,[TipoCliente] varchar(255) NOT NULL
      ,[CategoriaCliente] varchar(255) NOT NULL
      ,[Zona] varchar(100) NOT NULL
      ,[CustomerId] bigint NOT NULL
      ,[ClienteNombre] varchar(150) NOT NULL
      ,[SaleDate] date NULL
)
WITH
(
	 DATA_SOURCE = srcArcor
	,SCHEMA_NAME = 'PIVOT'
	,OBJECT_NAME = 'CoberturaXCliente'
)
GO


--select top 10 * from [PIVOT].[extCoberturaXCliente]
