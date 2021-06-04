--Select top 100 * from [PIVOT].[extCoberturaXVendedor]

--select top 10 * from [PIVOT].[CoberturaXVendedor]


SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
--DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

BEGIN TRANSACTION 

TRUNCATE TABLE [PIVOT].[CoberturaXVendedor_Diario]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXVendedor_Diario]
		SELECT IdDistribuidor, Distribuidor, Ciudad
			  , Year(FechaVenta)
			  , Mes.Id
			  , FechaVenta, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor
			  , Count(CustomerId) as Cobertura 
		  FROM [PIVOT].[extCoberturaXVendedor_Diario] CxV 
			   INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = Month(CxV.FechaVenta)
		 WHERE FechaVenta < @FechaHoy 
		GROUP BY IdDistribuidor, Distribuidor, Ciudad, Mes.Id, FechaVenta, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
