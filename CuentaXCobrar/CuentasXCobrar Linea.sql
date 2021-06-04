SELECT Comp.[Name] AS Distribuidor
	 , YEAR(FechaVenta) AS AnioVenta
	 , Mes.Nombre AS MesVenta
	 , CxC.FechaVenta
	 , CxC.ClienteCodigo
	 , CxC.ClienteNombre
	 , CxC.VendedorId
	 , CxC.VendedorNombre
	 , CxC.Importe
	 , CxC.PagoParcial
	 , CxC.Saldo
	 , CxC.EstadoCuenta
	 , YEAR(CxC.FechaVencimiento) AS AnioVencimiento
	 , Mes1.Nombre AS MesVencimiento
	 , CxC.FechaVencimiento
	 , CxC.NumeroGuia
	 , CxC.FechaDespacho
	 , CxC.NumeroNota
	 , CxC.Number AS NumeroFactura
	 , CxC.AuthorizationNumber AS AutorizacionNumero
	 , CxC.ControlCode AS CodigoControl
	 , CxC.DiasMora
	 , CxC.EstadoVencimiento
	 , CxC.RepartidorNombre
	 , CxC.ObservacionFactura
  FROM [PIVOT].[extCuentasXCobrar] CxC
	   INNER JOIN [PIVOT].extMsCompany Comp ON Comp.Id = CxC.IdDistribuidor
	   INNER JOIN [PIVOT].Meses Mes ON Mes.Id = MONTH(CxC.FechaVenta)
	   INNER JOIN [PIVOT].Meses Mes1 ON Mes1.Id = MONTH(CxC.FechaVencimiento)
  WHERE FechaVenta > EOMONTH(GetDate(),-4) and IdDistribuidor = 14
--ORDER BY FechaVenta
