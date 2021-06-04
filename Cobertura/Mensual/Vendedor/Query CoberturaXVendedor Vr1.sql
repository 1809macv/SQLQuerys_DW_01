TRUNCATE TABLE [PIVOT].[CoberturaXVendedor];

WITH Cobertura(IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor, 
               CustomerId, ClienteNombre) AS
(
SELECT DISTINCT Sale.CompanyId as IdDistribuidor
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
	   ,Month(Sale.SaleDate) as MesNumero
	   ,CR1.Name as TipoNegocio 
	   ,C6.Name as TipoCliente 
	   ,C7.Name as CategoriaCliente 
	   ,Zne.Name as Zona 
	   ,Sale.SellerId as VendedorId
	   ,Usr.Name as Vendedor 
	   ,Sale.CustomerId 
	   ,Customer.Name as ClienteNombre 
  FROM MSFSystemVacio.[Sales].MsSale Sale 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 

  	   INNER JOIN MSFSystemVacio.[Security].[MsUser] Usr ON Usr.Id = Sale.SellerId AND Usr.CompanyId = Sale.CompanyId 
 WHERE Sale.StatusIdc <> 104 and Sale.SaleDate >= '2018/06/01' AND Sale.CompanyId >= 3
)
INSERT INTO [PIVOT].[CoberturaXVendedor]
SELECT IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor, 
       Count(CustomerId) as Cobertura 
  FROM Cobertura 
GROUP BY IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, VendedorId, Vendedor 
