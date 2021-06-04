
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXVendedor_Diario]
WHERE FechaVenta > @FechaDesde;

IF @@ERROR <> 0
	BEGIN
		ROLLBACK;
	END
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
		 WHERE FechaVenta > @FechaDesde and FechaVenta < @FechaHoy
		GROUP BY IdDistribuidor, Distribuidor, Ciudad, Mes.Id, FechaVenta, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
