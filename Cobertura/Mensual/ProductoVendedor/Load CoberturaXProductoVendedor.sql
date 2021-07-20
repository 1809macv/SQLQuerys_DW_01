SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -2);

BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXProductoVendedor_Mensual]
WHERE DATEFROMPARTS(AnioVenta, MesNumero, 1) > @FechaDesde;
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[CoberturaXProductoVendedor_Mensual]
		SELECT IdDistribuidor
			  ,AnioVenta 
			  ,MesVenta 
			  ,CustomerId 
			  ,SellerId 
			  ,SellerName 
			  ,ProductId 
			  ,1 
		  FROM [PIVOT].[extCoberturaXProductoVendedor_Mensual]
		 WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) > @FechaDesde AND DATEFROMPARTS(AnioVenta, MesVenta, 1) < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
