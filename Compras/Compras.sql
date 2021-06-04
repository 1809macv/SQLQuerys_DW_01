
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = DATEADD(MONTH, -2, @FechaHoy)

SET @FechaDesde = DATEFROMPARTS(YEAR(@FechaDesde), MONTH(@FechaDesde), 1)

BEGIN TRANSACTION

DELETE FROM [PIVOT].[Compras]
WHERE FechaCompra >= @FechaDesde
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT [PIVOT].[Compras]
		SELECT * 
		  FROM [PIVOT].[extCompras]
		WHERE FechaFactura >= @FechaDesde AND FechaFactura < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
GO
