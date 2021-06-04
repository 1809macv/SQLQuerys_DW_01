-- ======================================================================================
-- Create SQL Login template for Azure SQL Database and Azure SQL Data Warehouse Database
-- ======================================================================================

CREATE LOGIN AVA_PIVOT
	WITH PASSWORD = 'arcor.123*' 
GO

--USE MSFSystemVacio
--GO

CREATE USER AVA_PIVOT
	FOR LOGIN AVA_PIVOT
	WITH DEFAULT_SCHEMA = dbo
GO

-- Add user to the database owner role
EXEC sp_addrolemember N'db_owner', N'AVA_PIVOT'
EXEC sp_addrolemember N'db_datareader', N'AVA_PIVOT'
GO

SELECT @@SERVERNAME




-- Desde aqui hacia abajo 
-- Conexion externa a otra BD
--------------------------------------------------------------------
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'avatech.123*'
;

--CREATE DATABASE SCOPED CREDENTIAL RemoteDBArcor  
ALTER DATABASE SCOPED CREDENTIAL RemoteDBArcor  
WITH IDENTITY  = 'AVA_PIVOT'
,    SECRET    = 'arcor.123*'
GO
--;

CREATE EXTERNAL DATA SOURCE srcArcor
WITH
(    TYPE          = RDBMS
,    LOCATION      = 'dbmsfsystem.database.windows.net'
,    DATABASE_NAME = 'MSFSystemVacio'
,    CREDENTIAL    = RemoteDBArcor
)
;


-- Conectar de SQL a Azure SQL
EXEC( N'
CREATE EXTERNAL DATA SOURCE [AzureArcor]
WITH
  ( TYPE = SHARD_MAP_MANAGER,
    LOCATION = ''dbmsfsystem.database.windows.net'' ,
    DATABASE_NAME = ''MSFSystemVacio'',
	SHARD_MAP_NAME = ''MSFSystemVacio'',
    CREDENTIAL = RemoteDBArcor 
  ) ;'
)



CREATE EXTERNAL TABLE [PIVOT].[StockActual]
(
	   [IdDistribuidor] bigint NOT NULL
      ,[Distribuidor] nvarchar(255) NOT NULL
      ,[Almacen] varchar(100) NOT NULL
      ,[ProductoCodigo] varchar(50) NOT NULL
      ,[ProductNombre] varchar(150) NOT NULL
      ,[UnidadMedidaAlmacen] varchar(255) NULL
      ,[CantidadAlmacen] decimal(18,4) NULL
      ,[UnidadMedidaVenta] varchar(255) NULL
      ,[CantidadUnidadMenor] decimal(29,4) NULL
      ,[FactorConverion] int NULL
      ,[NumeroLote] varchar(50) NULL
      ,[TipoLote] varchar(255) NULL
      ,[Negocio] varchar(255) NULL
      ,[Reclasificacion] varchar(255) NULL
      ,[Segmento] varchar(255) NULL
      ,[SubRubro] varchar(255) NULL
      ,[FechaExpiracion] date  NULL
      ,[PesoNeto] decimal(37,11) NULL
      ,[PesoBruto] decimal(37,11) NULL
      ,[CostoUC] decimal(18,4) NULL
      ,[CostoPPP] decimal(18,4) NULL
)
WITH
(
	 DATA_SOURCE = srcArcor
	,SCHEMA_NAME = 'PIVOT'
	,OBJECT_NAME = 'StockActual'
)
GO


select top 10 * from [PIVOT].[StockActual]

-- Configure Ad Hoc
-----------------------------------------------
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ad Hoc Distributed Queries', 1;
GO
RECONFIGURE;
GO


EXEC sp_configure 'show advanced options', 1
RECONFIGURE with override
GO
EXEC sp_configure 'ad hoc distributed queries', 1
RECONFIGURE with override
GO

EXEC sp_configure
----------------------------------------------------------