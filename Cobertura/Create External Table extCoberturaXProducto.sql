CREATE EXTERNAL TABLE [PIVOT].[extCoberturaXProducto]
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
	,[Negocio] varchar(255) NOT NULL
	,[Reclasificacion] varchar(255) NOT NULL
	,[Segmento] varchar(255) NOT NULL
	,[SubRubro] varchar(255) NOT NULL
	,[ProductoCodigo] varchar(50) NOT NULL
	,[ProductoNombre] varchar(150) NOT NULL
	,[Cobertura] int NOT NULL
	,[SaleDate] date NULL
)
WITH
(
	 DATA_SOURCE = srcArcor
	,SCHEMA_NAME = 'PIVOT'
	,OBJECT_NAME = 'CoberturaXProducto'
)
GO


--select top 10 * from [PIVOT].[extCoberturaXProducto]
