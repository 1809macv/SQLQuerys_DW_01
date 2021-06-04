WITH RecompraXProducto(CompanyId, Distribuidor, Ciudad, AnioVenta, NumeroMes, MesVenta, FechaVenta, TipoNegocio, TipoCliente, CategoriaCliente, Zona, CustomerId, 
                       ClienteNombre, ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro, Recompra, TotalReCompraAnterior) AS
(
SELECT DISTINCT Sale.CompanyId 
      ,Cmp.Name as Distribuidor 
	  ,C8.Name as Ciudad 
	  ,datepart(YEAR, Sale.SaleDate) as AnioVenta 
	  ,Month(Sale.SaleDate) as NumeroMes
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
	  ,convert(date, Sale.SaleDate) as FechaVenta 
	  ,CR1.[Name] as TipoNegocio 
	  ,C6.[Name] as TipoCliente 
	  ,C7.[Name] as CategoriaCliente 
	  ,Zne.[Name] as Zona 
	  ,Sale.CustomerId 
	  ,Sale.CustomerName as ClienteNombre 
      ,Prd.[Name] as ProductoNombre
      ,C2.[Name] as Negocio 
	  ,C3.[Name] as Reclasificacion 
	  ,C4.[Name] as Segmento 
	  ,C5.[Name] as SubRubro 
	  ,CASE WHEN (Select count(*) From MSFSystemVacio.[Sales].[MsSale] S 
                  INNER JOIN MSFSystemVacio.Sales.PsSaleDetail SD ON SD.SaleId = S.Id 
				   Where S.CompanyId = Sale.CompanyId and 
                         S.CustomerId = Sale.CustomerId and 
						 convert(date,S.SaleDate) > EOMONTH(Sale.SaleDate, -2) and convert(date,S.SaleDate) <= EOMONTH(Sale.SaleDate, -1)
                         and SD.ProductId = SDetail.ProductId ) > 0 THEN 1
					  ELSE 0
			 END as Recompra 
	  ,(Select count(distinct sd.ProductId) From MSFSystemVacio.Sales.MsSale sa
		 INNER JOIN MSFSystemVacio.Sales.PsSaleDetail sd on sd.SaleId = sa.Id
		 Where sa.CompanyId = 3 
			   and convert(date,sa.SaleDate) > EOMONTH(Sale.SaleDate, -2) and convert(date,sa.SaleDate) <= EOMONTH(Sale.SaleDate, -1)) as TotalReCompraAnterior
  FROM MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Sales].PsSaleDetail SDetail ON SDetail.SaleId = Sale.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].MsProduct Prd ON Prd.Id = SDetail.ProductId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Sales].[MsCustomer] Customer ON Customer.Id = Sale.CustomerId 
	   INNER JOIN MSFSystemVacio.[Zoning].[PsZone] Zne ON Zne.Id = Customer.ZoneId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C6 ON C6.Id = Customer.CustomerTypeIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C7 ON C7.Id = Customer.CategoryIdC 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifierRecursive] CR1 ON CR1.Id = Customer.BussinessTypeIdr 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 
 WHERE Sale.StatusIdc <> 104 and Sale.SaleDate >= '2018/06/01 00:00:00'
)
SELECT Distribuidor, Ciudad, AnioVenta, MesVenta, TipoNegocio, TipoCliente, CategoriaCliente, Zona, CustomerId 
      ,ClienteNombre, ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro, ReCompra, TotalReCompraAnterior
	  ,(case when TotalReCompraAnterior > 0 
			 then  ReCompra / convert(decimal(24,10),TotalReCompraAnterior) 
	   else 0 end) as PorcentajeReCompra
  FROM RecompraXProducto RXP

						  --convert(varchar(4), datepart(YEAR, S.SaleDate)) + right(CONVERT(varchar(4),'00' + RTRIM(LTRIM(datepart(MONTH, S.SaleDate)))),2) = 
						  --convert(varchar(4), datepart(YEAR, DATEADD(MONTH,-1,Sale.SaleDate))) + right(CONVERT(varchar(4),'00' + RTRIM(LTRIM(datepart(MONTH,DATEADD(MONTH,-1,Sale.SaleDate))))),2) 
	  --,Recompra, TotalReCompraAnterior 
	  --,case when Recompra > 0 then (Recompra / (Select convert(decimal(24,10),count(*)) From RecompraXProducto x
	  --               Where x.CompanyId = RXP.CompanyId 
			--		    and x.FechaVenta > EOMONTH(RXP.FechaVenta, -2)   
			--			and x.FechaVenta <= EOMONTH(RXP.FechaVenta, -1)) 
			--) else 0 end as PorcentajeReCompra
			--	        --and x.AnioVenta = RXP.AnioVenta and x.MesVenta = RXP.MesVenta )) as PorcentajeReCompra


USE MSFSystem_Cube
GO

TRUNCATE TABLE [PIVOT].[RecompraXProducto]
GO

-- Query de la tabla dinamica
-- Query que vale
WITH RecompraXProducto(DistriuidorId, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, ProductoCodigo, 
                       ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro, Recompra, TotalCompraAnterior) AS
(
SELECT DISTINCT Sale.CompanyId as DistriuidorId
      ,Cmp.[Name] as Distribuidor 
	  ,C8.[Name] as Ciudad 
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
	  ,Month(Sale.SaleDate) as NumeroMes
	  ,Prd.Code as ProductoCodigo 
      ,Prd.[Name] as ProductoNombre
      ,C2.[Name] as Negocio 
	  ,C3.[Name] as Reclasificacion 
	  ,C4.[Name] as Segmento 
	  ,C5.[Name] as SubRubro 
	  ,CASE WHEN (Select count(*) From MSFSystemVacio.[Sales].[MsSale] S 
                  INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SD ON SD.SaleId = S.Id 
				    Where S.CompanyId = Sale.CompanyId and 
						  S.SaleDate > EOMONTH(Sale.SaleDate, -2) and convert(date,S.SaleDate) <= EOMONTH(Sale.SaleDate, -1)
                          and SD.ProductId = SDetail.ProductId ) > 0 THEN 1
					  ELSE 0
			 END as Recompra 
	  ,(Select count(DISTINCT SDt.ProductId) FROM MSFSystemVacio.[Sales].[MsSale] sa
		 INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SDt ON SDt.SaleId = sa.Id
		 Where sa.CompanyId = Sale.CompanyId  
			   AND sa.SaleDate > EOMONTH(Sale.SaleDate, -2) AND convert(DATE,sa.SaleDate) <= EOMONTH(Sale.SaleDate, -1)) as TotalReCompraAnterior
  FROM MSFSystemVacio.[Sales].MsSale Sale 
       INNER JOIN MSFSystemVacio.[Sales].PsSaleDetail SDetail ON SDetail.SaleId = Sale.Id 
       INNER JOIN MSFSystemVacio.[Warehouse].MsProduct Prd ON Prd.Id = SDetail.ProductId 
	   INNER JOIN MSFSystemVacio.[Warehouse].[MsProductLine] PLine ON PLine.CompanyId = Prd.CompanyId and PLine.Id = Prd.ProductLineId 
	   INNER JOIN MSFSystemVacio.[Base].[MsCompany] Cmp ON Cmp.Id = Sale.CompanyId 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C8 ON C8.Id = Cmp.CityIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C2 ON C2.Id = PLine.BussinessIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C3 ON C3.Id = PLine.ReclassificationIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C4 ON C4.Id = PLine.SegmentIdc 
	   INNER JOIN MSFSystemVacio.[Base].[PsClassifier] C5 ON C5.Id = PLine.SubcategoryIdc 
 WHERE Sale.StatusIdc <> 104 and Sale.SaleDate >= '2018/06/01 00:00:00'
)
--INSERT [PIVOT].[RecompraXProducto]
SELECT DistriuidorId, Distribuidor, Ciudad, AnioVenta, MesVenta, MesNumero, ProductoCodigo 
      ,ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro 
	  ,(CASE WHEN TotalCompraAnterior > 0 
			 THEN  ReCompra / convert(decimal(24,10),TotalCompraAnterior) 
	   ELSE 0 END) AS PorcentajeReCompra
  FROM RecompraXProducto RXP



