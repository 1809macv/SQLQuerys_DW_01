USE MSFSystem_Cube
GO

TRUNCATE TABLE [PIVOT].[RecompraXCliente]
GO

WITH RecompraXCliente(DistribuidorId, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero ,TipoNegocio, TipoCliente, CategoriaCliente, CustomerId, 
                      ClienteNombre, Recompra, TotalClientesRecompra) AS   
(
SELECT DISTINCT Sale.CompanyId as DistribuidorId 
      ,Cmp.Name as Distribuidor 
	  ,C8.Name as Ciudad 
	  ,datepart(YEAR, Sale.SaleDate) as AnioVenta 
	  ,case Month(Sale.SaleDate) 
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
	  ,Month(Sale.SaleDate) as Mes
	  ,CR1.Name as TipoNegocio 
	  ,C6.Name as TipoCliente 
	  ,C7.Name as CategoriaCliente 
	  ,Sale.CustomerId 
	  ,Customer.Name as ClienteNombre 
	  ,CASE WHEN (Select count(*) From MSFSystemVacio.[Sales].[MsSale] S 
				    Where S.CompanyId = Sale.CompanyId and S.StatusIdc <> 104 and 
                    S.CustomerId = Sale.CustomerId and 
					convert(date,S.SaleDate) > EOMONTH(Sale.SaleDate, -2) and convert(date,S.SaleDate) <= EOMONTH(Sale.SaleDate, -1) 
					) > 0 THEN 1
				ELSE 0
	   END as Recompra 
	  ,(SELECT count(distinct CustomerId) FROM MSFSystemVacio.Sales.MsSale X
		 WHERE X.CompanyId = Sale.CompanyId and X.StatusIdc <> 104 and 
		       convert(date,X.SaleDate) > EOMONTH(Sale.SaleDate, -2) and convert(date,X.SaleDate) <= EOMONTH(Sale.SaleDate, -1) ) as TotalClientesRecompra
  FROM MSFSystemVacio.Sales.[MsSale] Sale 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 

 WHERE Sale.StatusIdc <> 104 and Sale.SaleDate >= '2018/06/01'
)
--INSERT [PIVOT].[RecompraXCliente]
SELECT DistribuidorId ,Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero ,TipoNegocio, TipoCliente, CategoriaCliente 
      ,CustomerId ,ClienteNombre 
	  ,(case when TotalClientesRecompra > 0 then 
                  (Recompra / convert(decimal(24,10),TotalClientesRecompra))
			 else 0 end ) as PorcentajeReCompra 
  FROM RecompraXCliente 
 WHERE DistribuidorId >= 3


