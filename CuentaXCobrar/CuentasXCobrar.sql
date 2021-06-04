select --top 10000 
	   Comp.[Name] as Distribuidor
	 , YEAR(FechaVenta) as AnioVenta
	 , Mes.Nombre as MesVenta
	 , CxC.FechaVenta
	 , CxC.ClienteCodigo
	 , CxC.ClienteNombre
	 , CxC.VendedorId
	 , CxC.VendedorNombre
	 , CxC.Importe
	 , CxC.PagoParcial
	 , CxC.Saldo
	 , CxC.EstadoCuenta
	 , YEAR(CxC.FechaVencimiento) as AnioVencimiento
	 , Mes1.Nombre as MesVencimiento
	 , CxC.FechaVencimiento
	 , CxC.NumeroGuia
	 , CxC.FechaDespacho
	 , CxC.NumeroNota
	 , CxC.NumeroFactura
	 , CxC.AutorizacionNumero
	 , CxC.CodigoControl
	 , CxC.DiasMora
	 , CxC.EstadoVencimiento
	 , CxC.RepartidorNombre
	 , CxC.ObservacionFactura
  from [PIVOT].[CuentasXCobrar] CxC
	   INNER JOIN [PIVOT].extMsCompany Comp ON Comp.Id = CxC.IdDistribuidor
	   INNER JOIN [PIVOT].Meses Mes ON Mes.Id = MONTH(CxC.FechaVenta)
	   INNER JOIN [PIVOT].Meses Mes1 ON Mes1.Id = MONTH(CxC.FechaVencimiento)
