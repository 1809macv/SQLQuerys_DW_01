SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

--PRINT @FechaDesde;
BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXCliente_Diario]
WHERE FechaVenta > @FechaDesde;

IF @@ERROR <> 0
	BEGIN
		ROLLBACK;
	END
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXCliente_Diario]
		SELECT CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad 
			  , YEAR(FechaVenta)
			  , MONTH(CXC.FechaVenta)
			  , CXC.FechaVenta, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente
			  , CXC.Zona
			  , CXC.ClienteCodigo 
			  , CXC.ClienteNombre 			  
			  , COUNT(CXC.CustomerId) as Cobertura 
		  FROM [PIVOT].[extCoberturaXCliente_Diario] CXC 
		 WHERE FechaVenta > @FechaDesde AND FechaVenta < @FechaHoy
		GROUP BY CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, Mes.Id, CXC.FechaVenta, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente
			   , CXC.Zona, CXC.ClienteCodigo, CXC.ClienteNombre 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
