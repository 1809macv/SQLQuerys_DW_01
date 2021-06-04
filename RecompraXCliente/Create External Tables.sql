CREATE EXTERNAL TABLE [PIVOT].extRecompraXcliente_Select1
(
	 [DistribuidorId] bigint NOT NULL
	,[Distribuidor] nvarchar(255) NOT NULL
	,[Ciudad] varchar(255) NOT NULL
	,[FechaPeriodo] date NULL
	,[TipoNegocio] varchar(250) NOT NULL
	,[TipoCliente] varchar(255) NOT NULL
	,[CategoriaCliente] varchar(255) NOT NULL
	,[ClienteId] bigint NOT NULL
	,[ClienteNombre] varchar(150) NOT NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXcliente_Select1'
)


CREATE EXTERNAL TABLE [PIVOT].extRecompraXcliente_Select2
(
	 [DistribuidorId] bigint NOT NULL
	,[Fecha] date NULL
	,[ClienteId] bigint NOT NULL
	,[Cantidad] int NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXcliente_Select2'
)


CREATE EXTERNAL TABLE [PIVOT].extRecompraXcliente_Select3
(
	 [DistribuidorId] bigint NOT NULL
	,[Fecha] date NULL
	,[ClientesTotal] int NULL
)
WITH (
	Data_Source = [srcArcor],
	Schema_Name = N'PIVOT',
	Object_Name = N'RecompraXcliente_Select3'
)
