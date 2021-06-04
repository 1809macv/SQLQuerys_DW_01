USE MSFSystem_Cube
GO

TRUNCATE TABLE [PIVOT].[RecompraXCliente]
GO

WITH RecompraXCliente(DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, TipoNegocio, TipoCliente, CategoriaCliente, CustomerId,    -- AnioVenta, MesVenta, MesNumero ,
                      ClienteNombre) AS   
(
SELECT DISTINCT Sale.CompanyId as DistribuidorId 
      ,Cmp.Name as Distribuidor 
	  ,C8.Name as Ciudad 
	  ,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) as FechaPeriodo
	  ,CR1.Name as TipoNegocio 
	  ,C6.Name as TipoCliente 
	  ,C7.Name as CategoriaCliente 
	  ,Sale.CustomerId 
	  ,Customer.Name as ClienteNombre 
  FROM MSFSystemVacio.Sales.[MsSale] Sale 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 

 WHERE Sale.StatusIdc <> 104 and Sale.SaleDate >= '2018/06/01' 
	   and Sale.CompanyId >= 3
),
Recompra( CompanyId, Fecha, CustomerId, Cantidad )
AS 
(
Select S.CompanyId as CompanyId
	  ,DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1) as Fecha
	  ,S.CustomerId as CustomerId
	  ,count(*) as Cantidad
  From MSFSystemVacio.[Sales].[MsSale] S
 Where S.CompanyId >= 3 
	   and S.StatusIdc <> 104 
Group By S.CompanyId, DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1), S.CustomerId    
),
TotalClientes ( CompanyId, Fecha, ClientesTotal )
AS 
(
Select sa.CompanyId as CompanyId
	  ,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) as Fecha
	  ,count(DISTINCT sa.CustomerId) as ClientesTotal
  FROM MSFSystemVacio.[Sales].[MsSale] sa
 WHERE sa.CompanyId >= 3 
	   and sa.StatusIdc <> 104 
Group By sa.CompanyId, DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1)
)
INSERT [PIVOT].[RecompraXCliente]
SELECT RXC.DistribuidorId 
	  ,RXC.Distribuidor
	  ,RXC.Ciudad
	  ,YEAR(RXC.FechaPeriodo) as AnioVenta 
	  ,case Month(RXC.FechaPeriodo) 
	        when 1 then '01. Enero'
	        when 2 then '02. Febrero'
	        when 3 then '03. Marzo'
	        when 4 then '04. Abril'
	        when 5 then '05. Mayo'
	        when 6 then '06. Junio'
	        when 7 then '07. Julio'
	        when 8 then '08. Agosto'
	        when 9 then '09. Septiembre'
	        when 10 then '10. Octubre'
	        when 11 then '11. Noviembre'
	        when 12 then '12. Diciembre'
	   end as MesVenta 
	  ,MONTH(RXC.FechaPeriodo) as MesNumero 
	  ,RXC.TipoNegocio
	  ,RXC.TipoCliente
	  ,RXC.CategoriaCliente 
      ,RXC.CustomerId 
	  ,RXC.ClienteNombre 
	  ,case 
	      when ISNULL(R.Cantidad,0) > 0 and ISNULL(TC.ClientesTotal,0) > 0 then ( 1 / convert(decimal(24,10),TC.ClientesTotal) )
		  else 0
	   end as [PorcentajeRecompra]
  FROM RecompraXCliente RXC
     LEFT JOIN Recompra R ON R.CompanyId = RXC.DistribuidorId and R.CustomerId = RXC.CustomerId 
	       and R.Fecha > EOMONTH(RXC.FechaPeriodo, -2) and convert(date,R.Fecha) <= EOMONTH(RXC.FechaPeriodo, -1) 
	 LEFT JOIN TotalClientes TC ON TC.CompanyId = RXC.DistribuidorId 
	       and TC.Fecha > EOMONTH(RXC.FechaPeriodo, -2) AND TC.Fecha <= EOMONTH(RXC.FechaPeriodo, -1)


