
SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = DATEADD(MONTH, -2, @FechaHoy)

SET @FechaDesde = DATEFROMPARTS(YEAR(@FechaDesde), MONTH(@FechaDesde), 1)

BEGIN TRANSACTION

DELETE FROM [PIVOT].[RecompraXCliente]
WHERE DATEFROMPARTS(AnioVenta, MesNumero, 1) >= @FechaDesde
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		--WITH RecompraXCliente(DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, TipoNegocio, TipoCliente, CategoriaCliente, CustomerId, 
		--					  ClienteNombre) AS   
		--(
		--SELECT DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, TipoNegocio, TipoCliente, CategoriaCliente, CustomerId, 
		--					  ClienteNombre
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT DISTINCT Sale.CompanyId AS DistribuidorId 
		--	  ,Cmp.Name AS Distribuidor 
		--	  ,C8.Name AS Ciudad 
		--	  ,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) AS FechaPeriodo
		--	  ,CR1.Name AS TipoNegocio 
		--	  ,C6.Name AS TipoCliente 
		--	  ,C7.Name AS CategoriaCliente 
		--	  ,Sale.CustomerId 
		--	  ,Customer.Name AS ClienteNombre 
		--  FROM Sales.[MsSale] Sale 
		--	   INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		--	   INNER JOIN [Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
		--	   INNER JOIN [Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
		--	   INNER JOIN [Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
		--	   INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
		--	   INNER JOIN [Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 
		-- WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3')
		--),
		--Recompra( CompanyId, Fecha, CustomerId, Cantidad )
		--AS 
		--(
		--SELECT CompanyId, Fecha, CustomerId, Cantidad
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT S.CompanyId AS CompanyId
		--	  ,DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1) AS Fecha
		--	  ,S.CustomerId AS CustomerId
		--	  ,COUNT(*) AS Cantidad
		--  FROM [Sales].[MsSale] S
		-- WHERE S.CompanyId >= 3 AND S.StatusIdc <> 104 
		--GROUP BY S.CompanyId, DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1), S.CustomerId')
		--),
		--TotalClientes ( CompanyId, Fecha, ClientesTotal )
		--AS 
		--(
		--SELECT CompanyId, Fecha, ClientesTotal
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT sa.CompanyId AS CompanyId
		--	  ,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) AS Fecha
		--	  ,count(DISTINCT sa.CustomerId) AS ClientesTotal
		--  FROM MSFSystemVacio.[Sales].[MsSale] sa
		-- WHERE sa.CompanyId >= 3 AND sa.StatusIdc <> 104 
		--GROUP BY sa.CompanyId, DATEFROMPARTS(YEAR(sa.SaleDate),MONTH(sa.SaleDate),1)')
		--)
		INSERT [PIVOT].[RecompraXCliente]
		SELECT RXC.DistribuidorId 
			  ,RXC.Distribuidor
			  ,RXC.Ciudad
			  ,YEAR(RXC.FechaPeriodo) AS AnioVenta 
			  ,CASE MONTH(RXC.FechaPeriodo) 
					WHEN 1 THEN '01. Enero'
					WHEN 2 THEN '02. Febrero'
					WHEN 3 THEN '03. Marzo'
					WHEN 4 THEN '04. Abril'
					WHEN 5 THEN '05. Mayo'
					WHEN 6 THEN '06. Junio'
					WHEN 7 THEN '07. Julio'
					WHEN 8 THEN '08. Agosto'
					WHEN 9 THEN '09. Septiembre'
					WHEN 10 THEN '10. Octubre'
					WHEN 11 THEN '11. Noviembre'
					WHEN 12 THEN '12. Diciembre'
			   END AS MesVenta 
			  ,MONTH(RXC.FechaPeriodo) AS MesNumero 
			  ,RXC.TipoNegocio
			  ,RXC.TipoCliente
			  ,RXC.CategoriaCliente 
			  ,RXC.ClienteId 
			  ,RXC.ClienteNombre 
			  ,CASE 
				  WHEN ISNULL(R.Cantidad,0) > 0 AND ISNULL(TC.ClientesTotal,0) > 0 THEN ( 1 / CONVERT(DECIMAL(24,10),TC.ClientesTotal) )
				  ELSE 0
			   END AS [PorcentajeRecompra]
		  FROM [PIVOT].extRecompraXCliente_Select1 RXC
			 LEFT JOIN [PIVOT].extRecompraXCliente_Select2 R ON R.DistribuidorId = RXC.DistribuidorId AND R.ClienteId = RXC.ClienteId 
				   AND R.Fecha > EOMONTH(RXC.FechaPeriodo, -2) AND R.Fecha <= EOMONTH(RXC.FechaPeriodo, -1) 
			 LEFT JOIN [PIVOT].extRecompraXCliente_Select3 TC ON TC.DistribuidorId = RXC.DistribuidorId 
				   AND TC.Fecha > EOMONTH(RXC.FechaPeriodo, -2) AND TC.Fecha <= EOMONTH(RXC.FechaPeriodo, -1)
		 WHERE RXC.FechaPeriodo >=  @FechaDesde AND RXC.FechaPeriodo < @FechaHoy
		IF @@ERROR <> 0 
			ROLLBACK;
		ELSE
			COMMIT;
	END

