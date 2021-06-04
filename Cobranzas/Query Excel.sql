SELECT Distribuidor
	  ,DATEPART(YEAR,Cobros.FechaCobro) AS AnioCobranza
	  ,Mes.Nombre AS MesCobranza
	  ,FechaCobro
	  ,Observacion
	  ,EstadoDocumento
	  ,TipoTransaccion
	  ,SubTipoTransaccion
	  ,NumeroNIT
	  ,DATEPART(YEAR,Cobros.FechaVenta) AS AnioVenta
	  ,MesV.Nombre AS MesVenta
	  ,FechaVenta
	  ,ClienteNombre
	  ,Customer.Code AS ClienteCodigo
	  ,NumeroFactura
	  ,AutorizacionNumero
	  ,CodigoControl
	  ,VendedorNombre
	  ,MontoCobrado
	  ,NumeroCuenta
	  ,NombreCuenta
	  ,RepartidorNombre
	  ,NumeroGuia
	  ,FechaDespacho
  FROM [PIVOT].[Cobros] Cobros
	  INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = DATEPART(MONTH,Cobros.FechaCobro)
	  INNER JOIN [PIVOT].[Meses] MesV ON MesV.Id = DATEPART(MONTH,Cobros.FechaVenta)
	  INNER JOIN [PIVOT].[extMsCustomer] Customer ON Customer.Id = Cobros.ClienteId
 WHERE IdDistribuidor = 14 
