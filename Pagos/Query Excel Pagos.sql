/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Pago.[Distribuidor]
      ,Pago.[Proveedor]
	  ,Year(Pago.FechaGasto) as AnioGasto
	  ,Mes.Nombre as MesGasto
      ,Pago.[FechaGasto]
      ,Pago.[Observacion]
      ,Pago.[EstadoDocumento]
      ,Pago.[TipoTransaccion]
      ,Pago.[SubtipoTransaccion]
      ,Pago.[NumeroNIT]
      ,Pago.[AutorizacionNumero]
      ,Pago.[NumeroFactura]
      ,Pago.[CodigoControl]
      ,Pago.[TipoMovimiento]
      ,Pago.[Debe]
      ,Pago.[Haber]
      ,Pago.[NumeroCuenta]
      ,Pago.[NombreCuenta]
  FROM [PIVOT].[Pagos] Pago
       INNER JOIN [PIVOT].[Meses] Mes ON Mes.Id = Month(Pago.FechaGasto)
 WHERE IdDistribuidor = 14 