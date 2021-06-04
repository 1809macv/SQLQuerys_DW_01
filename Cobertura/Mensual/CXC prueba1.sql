SET DATEFORMAT YMD
DECLARE @FechaDesde DATE
DECLARE @FechaHoy DATE;


		WITH CoberturaXCliente(IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, 
					   CustomerId, ClienteNombre) AS
		(
		SELECT IdDistribuidor, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, TipoNegocio, TipoCliente, CategoriaCliente, Zona, 
				CustomerId, ClienteNombre
  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio', 
   'SELECT DISTINCT Sale.CompanyId as IdDistribuidor
			  ,Cmp.Name as Distribuidor 
			  ,C8.Name as Ciudad 
			  ,datepart(YEAR, Sale.SaleDate) as AnioVenta 
			  ,Month(Sale.SaleDate) as MesVenta 
			  ,Month(Sale.SaleDate) as MesNumero 
			  ,CR1.Name as TipoNegocio 
			  ,C6.Name as TipoCliente 
			  ,C7.Name as CategoriaCliente 
			  ,Zne.Name as Zona 
			  ,Sale.CustomerId 
			  ,Customer.Name as ClienteNombre 
		  FROM [Sales].MsSale Sale 
			   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
			   INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
			   INNER JOIN [Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
			   INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
			   INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
			   INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
			   INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 
		 WHERE Sale.StatusIdc <> 104  and Sale.CompanyId >= 3 
			   AND CAST(Sale.SaleDate as DATE) > '' + @FechaDesde + '' AND CAST(Sale.SaleDate as DATE) < '' + @FechaHoy + ''' )
		 )
		--INSERT INTO [PIVOT].[CoberturaXCliente]
		SELECT top 10 CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, CXC.AnioVenta, CXC.MesVenta, CXC.MesNumero, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente, CXC.Zona, 
			   COUNT(CXC.CustomerId) as Cobertura 
		  FROM CoberturaXCliente CXC 
		GROUP BY CXC.IdDistribuidor, CXC.Distribuidor, CXC.Ciudad, CXC.AnioVenta, CXC.MesVenta, CXC.MesNumero, CXC.TipoNegocio, CXC.TipoCliente, CXC.CategoriaCliente, CXC.Zona


