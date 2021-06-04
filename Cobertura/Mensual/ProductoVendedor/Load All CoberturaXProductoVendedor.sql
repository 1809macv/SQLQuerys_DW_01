SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);

BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[CoberturaXProductoVendedor_Mensual]

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
		 WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
