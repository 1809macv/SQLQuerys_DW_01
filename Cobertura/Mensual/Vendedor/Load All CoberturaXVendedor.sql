SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
--DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[CoberturaXVendedor_Mensual]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXVendedor_Mensual]
		SELECT IdDistribuidor
			  ,Distribuidor
			  ,Ciudad
			  ,AnioVenta
			  ,MesVenta
			  ,TipoNegocio
			  ,TipoCliente
			  ,CategoriaCliente
			  ,Zona
			  ,VendedorId
			  ,Vendedor 
			  ,Count(CustomerId) as Cobertura
		  FROM [PIVOT].[extCoberturaXVendedor_Mensual]
		 WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) < @FechaHoy 
		GROUP BY IdDistribuidor
			  ,Distribuidor
			  ,Ciudad
			  ,AnioVenta
			  ,MesVenta
			  ,TipoNegocio
			  ,TipoCliente
			  ,CategoriaCliente
			  ,Zona
			  ,VendedorId
			  ,Vendedor 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
