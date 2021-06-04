SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3);

--PRINT @FechaDesde;
BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXCliente_Mensual]
WHERE DATEFROMPARTS(AnioVenta, MesNumero, 1) > @FechaDesde;

IF @@ERROR <> 0
	ROLLBACK;
ELSE
BEGIN
	INSERT INTO [PIVOT].[CoberturaXCliente_Mensual]
	SELECT IdDistribuidor
		  ,Distribuidor 
		  ,Ciudad 
		  ,AnioVenta 
		  ,MesVenta 
		  ,TipoNegocio 
		  ,TipoCliente 
		  ,CategoriaCliente 
		  ,Zona 
		  ,ClienteCodigo
		  ,ClienteNombre 
		  ,1
	  FROM [PIVOT].[extCoberturaXCliente_Mensual]
	 WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) > @FechaDesde and DATEFROMPARTS(AnioVenta, MesVenta, 1) < @FechaHoy
	IF @@ERROR <> 0 
		ROLLBACK;
	ELSE
		COMMIT;
END
