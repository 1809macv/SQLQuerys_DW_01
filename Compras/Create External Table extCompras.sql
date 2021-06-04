CREATE EXTERNAL TABLE [PIVOT].[extCompras]
(
     [IdDistribuidor] bigint NOT NULL
      ,[Distribuidor] nvarchar(255) NOT NULL
      ,[Ciudad] varchar(255) NOT NULL
      ,[Proveedor] varchar(50) NOT NULL
      ,[AnioCompra] int NULL
      ,[MesCompra] varchar(14) NULL
      ,[FechaCompra] datetime NOT NULL
      ,[NumeroFactura] int NOT NULL
      ,[FechaFactura] date NOT NULL
      ,[NumeroAutorizacion] varchar(50) NULL
      ,[CodigoControl] varchar(50) NULL
      ,[EstadoPago] varchar(255) NOT NULL
      ,[Referencia] varchar(255) NOT NULL
      ,[MontoDebito]decimal(18,2) NOT NULL
      ,[DiasCredito]int NOT NULL
      ,[Negocio] varchar(255) NOT NULL
      ,[Reclasificacion] varchar(255) NOT NULL
      ,[Segmento] varchar(255) NOT NULL
      ,[SubRubro] varchar(255) NOT NULL
      ,[ProductoCodigo] varchar(50) NOT NULL
      ,[ProductoNombre] varchar(150) NOT NULL
      ,[UnidadMedidaAlmacen] varchar(255) NOT NULL
      ,[FactorConversion] int NOT NULL
      ,[CantidadProducto] decimal(18,4) NOT NULL
      ,[UnidadMedidaMenor] varchar(255) NOT NULL
      ,[CantidadProductoUnidadMenor] decimal(29,4) NULL
      ,[CostoUnitario] decimal(18,4) NOT NULL
      ,[MontoTotalProducto] decimal(37,8) NULL
      ,[TotalDescuento] decimal(18,4) NOT NULL
      ,[MontoTotal] decimal(18,4) NOT NULL
)
WITH
(
	 DATA_SOURCE = srcArcor
	,SCHEMA_NAME = 'PIVOT'
	,OBJECT_NAME = 'Compras'
)
GO


--select top 10 * from [PIVOT].[extCompras]
