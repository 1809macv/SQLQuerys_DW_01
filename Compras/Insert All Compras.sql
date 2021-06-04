
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 

BEGIN TRANSACTION

TRUNCATE TABLE [PIVOT].[Compras]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT [PIVOT].[Compras]
		SELECT * 
		  FROM [PIVOT].[extCompras]
		 WHERE FechaFactura < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END
GO
