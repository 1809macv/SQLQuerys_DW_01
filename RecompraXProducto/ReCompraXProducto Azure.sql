SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE

SET @FechaDesde = DATEADD(MONTH, -2, @FechaHoy)
SET @FechaDesde = DATEFROMPARTS(YEAR(@FechaDesde), MONTH(@FechaDesde), 1)

BEGIN TRANSACTION

DELETE FROM [PIVOT].[RecompraXProducto]
WHERE DATEFROMPARTS(AnioVenta, MesNumero, 1) >= @FechaDesde
IF @@ERROR <> 0
	ROLLBACK;
ELSE
	BEGIN
		--WITH RecompraXProducto(DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, ProductoId, ProductoCodigo, 
		--						ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro) AS   
		--(
		--SELECT DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, ProductoId, ProductoCodigo, 
		--	   ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT DISTINCT Sale.CompanyId AS DistribuidorId
		--		,Cmp.[Name] AS Distribuidor 
		--		,C8.[Name] AS Ciudad 
		--		,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) AS FechaPeriodo
		--		,SDetail.ProductId AS ProductoId
		--		,Prd.Code AS ProductoCodigo 
		--		,Prd.[Name] AS ProductoNombre
		--		,C2.[Name] AS Negocio 
		--		,C3.[Name] AS Reclasificacion 
		--		,C4.[Name] AS Segmento 
		--		,C5.[Name] AS SubRubro 
		--	FROM [Sales].MsSale Sale 
		--		INNER JOIN [Sales].PsSaleDetail SDetail ON SDetail.SaleId = Sale.Id 
		--		INNER JOIN [Warehouse].MsProduct Prd ON Prd.Id = SDetail.ProductId 
		--		INNER JOIN [Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId AND PLine.Id = Prd.ProductLineId 
		--		INNER JOIN [Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
		--		INNER JOIN [Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
		--		INNER JOIN [Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
		--		INNER JOIN [Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
		--		INNER JOIN [Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
		--		INNER JOIN [Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 
		--	WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3')
		--),
		--Recompra( CompanyId, Fecha, ProductoId, Cantidad )
		--AS 
		--(
		--SELECT CompanyId, Fecha, ProductoId, Cantidad
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT S.CompanyId AS CompanyId
		--		,DATEFROMPARTS(YEAR(S.SaleDate),MONTH(S.SaleDate),1) AS Fecha
		--		,SD.ProductId AS ProductoId
		--		,COUNT(*) AS Cantidad
		--	FROM [Sales].[MsSale] S
		--		INNER JOIN [Sales].[PsSaleDetail] SD ON SD.SaleId = S.Id 
		--	WHERE S.CompanyId >= 3 AND S.StatusIdc <> 104 
		--GROUP BY S.CompanyId, DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1), SD.ProductId')
		--),
		--TotalVenta ( CompanyId, Fecha, VentaTotal )
		--AS 
		--(
		--SELECT CompanyId, Fecha, VentaTotal
		--  FROM OPENROWSET('SQLNCLI11','Server=dbmsfsystem.database.windows.net;UID=msfadmin;PWD=arcor.123*;Database=MSFSystemVacio',
	 --  'SELECT sa.CompanyId AS CompanyId
		--		,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) AS Fecha
		--		,COUNT(DISTINCT SDt.ProductId) AS VentaTotal
		--	FROM [Sales].[MsSale] sa
		--		INNER JOIN [Sales].[PsSaleDetail] SDt ON SDt.SaleId = sa.Id
		--	WHERE sa.CompanyId >= 3 AND sa.StatusIdc <> 104 
		--GROUP BY sa.CompanyId, DATEFROMPARTS(YEAR(sa.SaleDate),MONTH(sa.SaleDate),1)')
		--)
		INSERT INTO [PIVOT].[RecompraXProducto]
		SELECT RXP.[DistribuidorId]
				,RXP.[Distribuidor]
				,RXP.[Ciudad]
				,YEAR(RXP.FechaPeriodo) AS AnioVenta 
				,CASE MONTH(RXP.FechaPeriodo) 
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
				,MONTH(RXP.FechaPeriodo) AS MesNumero
				,RXP.[ProductoCodigo]
				,RXP.[ProductoNombre]
				,RXP.[Negocio]
				,RXP.[Reclasificacion]
				,RXP.[Segmento]
				,RXP.[Subrubro]
				,CASE 
					WHEN ISNULL(R.Cantidad,0) > 0 AND ISNULL(TV.VentaTotal,0) > 0 THEN ( 1 / CONVERT(DECIMAL(24,10),TV.VentaTotal) )
					ELSE 0
				END AS [PorcentajeRecompra]    
			FROM [PIVOT].extRecompraXProducto_Select1 RXP
				LEFT JOIN [PIVOT].extRecompraXProducto_Recompra R ON R.DistribuidorId = RXP.DistribuidorId and R.ProductoId = RXP.ProductoId 
					AND R.Fecha > EOMONTH(RXP.FechaPeriodo, -2) AND convert(DATE,R.Fecha) <= EOMONTH(RXP.FechaPeriodo, -1) 
				LEFT JOIN [PIVOT].extRecompraXProducto_TotalVenta TV ON TV.DistribuidorId = RXP.DistribuidorId 
					AND TV.Fecha > EOMONTH(RXP.FechaPeriodo, -2) AND TV.Fecha <= EOMONTH(RXP.FechaPeriodo, -1)
			WHERE RXP.FechaPeriodo >= @FechaDesde AND RXP.FechaPeriodo < @FechaHoy 
		IF @@ERROR <> 0
			ROLLBACK;
		ELSE
			COMMIT ;
	END

