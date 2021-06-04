SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE);

BEGIN TRANSACTION
TRUNCATE TABLE [PIVOT].[Seguimiento]

IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		INSERT INTO [PIVOT].[Seguimiento]
		SELECT Seg.DistribuidorId
			  , Seg.Distribuidor
			  , Seg.Secuencia 
			  , Seg.ClienteCodigo 
			  , Seg.ClienteNombre
			  , Seg.Fecha
			  , Seg.HoraInicio
			  , Seg.HoraFin
			  , Seg.VendedorId
			  , Seg.VendedorNombre 
			  , Seg.Motivo 
			  , Seg.DiaNombre 
			  , Seg.TieneGPS 
		  FROM [PIVOT].[extSeguimiento] Seg 
		 WHERE Fecha < @FechaHoy 
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END

