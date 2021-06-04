CREATE EXTERNAL TABLE [PIVOT].extRecompraXProducto_Select1
(
	 [DistribuidorId] bigint NOT NULL
	,[Distribuidor] nvarchar(255) NOT NULL
	,[Ciudad] varchar(255) NOT NULL
	,[FechaPeriodo] date NULL
	,[ProductoId] bigint NOT NULL
	,[ProductoCodigo] varchar(50) NOT NULL
	,[ProductoNombre] varchar(150) NOT NULL
	,[Negocio] varchar(255) NOT NULL
	,[Reclasificacion] varchar(255) NOT NULL
	,[Segmento] varchar(255) NOT NULL
	,[SubRubro] varchar(255) NOT NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXProducto_Select1'
)


CREATE EXTERNAL TABLE [PIVOT].extRecompraXProducto_Recompra
(
	 [DistribuidorId] bigint NOT NULL
	,[Fecha] date NULL
	,[ProductoId] bigint NOT NULL
	,[Cantidad] int NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXProducto_Recompra'
)


CREATE EXTERNAL TABLE [PIVOT].extRecompraXProducto_TotalVenta
(
	 [DistribuidorId] bigint NOT NULL
	,[Fecha] date NULL
	,[VentaTotal] int NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXProducto_TotalVenta'
)
