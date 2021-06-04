SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
--DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

--PRINT @FechaDesde;
BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[CoberturaXCliente_Diario]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXCliente_Diario]
		SELECT CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad 
			  , YEAR(FechaVenta)
			  , Mes.Id
			  , CXC.FechaVenta, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente
			  , CXC.Zona
			  , CXC.ClienteCodigo 
			  , CXC.ClienteNombre 
			  , COUNT(CXC.CustomerId) as Cobertura 
		  FROM [PIVOT].[extCoberturaXCliente_Diario] CXC 
			   INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = MONTH(CXC.FechaVenta)
		 WHERE FechaVenta < @FechaHoy 
		GROUP BY CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, Mes.Id, CXC.FechaVenta, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente
			   , CXC.Zona, CXC.ClienteCodigo, CXC.ClienteNombre 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
