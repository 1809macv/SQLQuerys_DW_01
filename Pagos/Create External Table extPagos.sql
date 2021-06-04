CREATE EXTERNAL TABLE [PIVOT].[extPagos]
(
	   [IdDistribuidor] bigint NULL
      ,[Distribuidor] nvarchar(255) NULL
      ,[Proveedor] varchar(100) NULL
      ,[FechaGasto] date NULL
      ,[Observacion] varchar(max) NULL
      ,[EstadoDocumento] varchar(255) NULL
      ,[TipoTransaccion] varchar(250) NULL
      ,[SubTipoTransaccion] varchar(250) NULL
      ,[NumeroNIT] varchar(50) NULL
      ,[AutorizacionNumero] varchar(50) NULL
      ,[NumeroFactura] bigint NULL
      ,[CodigoControl] varchar(50) NULL
      ,[TipoMovimiento] varchar(255) NULL
	  ,[Debe] decimal(18,2) NULL
	  ,[Haber] decimal(18,2) NULL
	  ,[NumeroCuenta] varchar(20) NULL
	  ,[NombreCuenta] varchar(60) NULL
)
WITH
(
	 DATA_SOURCE = srcArcor
	,SCHEMA_NAME = 'PIVOT'
	,OBJECT_NAME = 'Pagos'
)
GO



