SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST(GETDATE() as DATE)
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -3)

--BEGIN TRANSACTION
DELETE FROM [PIVOT].[CoberturaXCliente]
WHERE DATEFROMPARTS(AnioVenta, MesVenta, 1) > @FechaDesde;

WITH CoberturaXCliente(IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, 
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
 WHERE Sale.StatusIdc <> 104  and Sale.CompanyId >= 3 
       AND cast(Sale.SaleDate as date) > @FechaDesde AND cast(Sale.SaleDate as date) < @FechaHoy
 )
INSERT INTO [PIVOT].[CoberturaXCliente]
SELECT CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, CXC.AnioVenta, CXC.MesVenta, CXC.MesNumero, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente, CXC.Zona, 
       COUNT(CXC.CustomerId) as Cobertura 
  FROM CoberturaXCliente CXC 
GROUP BY CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, CXC.AnioVenta, CXC.MesVenta, CXC.MesNumero, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente, CXC.Zona