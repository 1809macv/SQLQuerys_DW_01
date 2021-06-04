-- 106 Estado Anulado para la Tabla MsReceivable
-- 104 Estado Anulado de la Factura 
SELECT TOP 100 
	   CxC.CompanyId as DistribuidorId
	 , Comp.[Name] as Distribuidor
	 , Sale.SaleDate as FechaVenta
	 , Customer.Code as CodigoCliente
	 , Sale.CustomerName as ClienteNombre
	 , Sale.SellerId as VendedorId
	 , Usr.[Name] as VendedorNombre
	 , CxC.Total as Importe
	 , CxC.Pay as PagoParcial
	 , ( CxC.Total - CxC.Pay ) as Saldo
	 , case 
			when CxC.Pay = 0 then 'Pendiente de Pago'
			when CxC.Total > CxC.Pay then 'Pago Parcial'
			Else 'Pagado'
	   end AS EstadoCuenta 
	 , CxC.ExpirationDate as FechaVencimiento
	 , C1.[Name] as EstadoCuenta 
	 , Opc.Number as NumeroGuia 
	 , Opc.[DispatchDate] as FechaDespacho
	 , Sale.OrderId as NumeroNota 
	 , datediff(day, CxC.ExpirationDate, GetDate()) as DiasMora
	 , case
			when convert(date, CxC.ExpirationDate) >= convert(date, GetDate()) then 'Por Vencer' 
			else 'Vencido'
	   end as EstadoVencimiento 
	 , Seller.Name AS RepartidorNombre
	 , CxC.Observation as Descripcion 
  FROM [Accounting].[MsReceivable] CxC
	   INNER JOIN [Sales].[MsSale] Sale ON Sale.Id = CxC.SaleId 
	   INNER JOIN [Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
	   INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId
	   INNER JOIN Warehouse.PsOpcOrderSale OpcSale ON OpcSale.SaleId = Sale.Id
	   INNER JOIN Warehouse.PsOpc Opc ON Opc.Id = OpcSale.OpcId AND Opc.CompanyId = Sale.CompanyId
	   INNER JOIN [Security].MsUser Seller ON Seller.Id = Opc.SellerId
	   INNER JOIN Base.PsClassifier C1 ON C1.Id = CxC.StatusIdc 
	   INNER JOIN [Base].MsCompany Comp ON Comp.Id = CxC.CompanyId
 WHERE CxC.CompanyId >= 3 and CxC.StatusIdc <> 106
	   --and Sale.SaleDate >= '2019/09/01' and Sale.SaleDate < '2019/10/01' 
	   and Sale.StatusIdc <> 104 
Order by Sale.InvoiceDate


