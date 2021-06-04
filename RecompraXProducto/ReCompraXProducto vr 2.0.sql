--8375 Registros

USE MSFSystem_Cube
GO

TRUNCATE TABLE [PIVOT].[RecompraXProducto]
GO

WITH RecompraXProducto(DistribuidorId, Distribuidor, Ciudad, FechaPeriodo, ProductoId, ProductoCodigo, 
                       ProductoNombre, Negocio, Reclasificacion, Segmento, SubRubro) AS   
(
SELECT DISTINCT Sale.CompanyId as DistribuidorId
      ,Cmp.[Name] as Distribuidor 
	  ,C8.[Name] as Ciudad 
	  ,DATEFROMPARTS(Year(Sale.SaleDate),Month(Sale.SaleDate),1) as FechaPeriodo
	  ,SDetail.ProductId as ProductoId
	  ,Prd.Code as ProductoCodigo 
      ,Prd.[Name] as ProductoNombre
      ,C2.[Name] as Negocio 
	  ,C3.[Name] as Reclasificacion 
	  ,C4.[Name] as Segmento 
	  ,C5.[Name] as SubRubro 
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
       and Sale.CompanyId >= 3
),
Recompra( CompanyId, Fecha, ProductoId, Cantidad )
AS 
(
Select S.CompanyId as CompanyId
	  ,DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1) as Fecha
	  ,SD.ProductId as ProductoId
	  ,count(*) as Cantidad
  From MSFSystemVacio.[Sales].[MsSale] S
	   INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SD ON SD.SaleId = S.Id 
 Where S.CompanyId >= 3 
	   and S.StatusIdc <> 104 
Group By S.CompanyId, DATEFROMPARTS(Year(S.SaleDate),Month(S.SaleDate),1), SD.ProductId 
),
TotalVenta ( CompanyId, Fecha, VentaTotal )
AS 
(
Select sa.CompanyId as CompanyId
	  ,DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1) as Fecha
	  ,count(DISTINCT SDt.ProductId) as VentaTotal
  FROM MSFSystemVacio.[Sales].[MsSale] sa
	   INNER JOIN MSFSystemVacio.[Sales].[PsSaleDetail] SDt ON SDt.SaleId = sa.Id
 WHERE sa.CompanyId >= 3 
	   and sa.StatusIdc <> 104 
Group By sa.CompanyId, DATEFROMPARTS(Year(sa.SaleDate),Month(sa.SaleDate),1)
)
INSERT INTO [PIVOT].[RecompraXProducto]
SELECT RXP.[DistribuidorId]
      ,RXP.[Distribuidor]
      ,RXP.[Ciudad]
      ,YEAR(RXP.FechaPeriodo) as AnioVenta 
	  ,case Month(RXP.FechaPeriodo) 
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
	  ,MONTH(RXP.FechaPeriodo) as MesNumero
      ,RXP.[ProductoCodigo]
      ,RXP.[ProductoNombre]
      ,RXP.[Negocio]
      ,RXP.[Reclasificacion]
      ,RXP.[Segmento]
      ,RXP.[Subrubro]
      ,case 
	      when ISNULL(R.Cantidad,0) > 0 and ISNULL(TV.VentaTotal,0) > 0 then ( 1 / convert(decimal(24,10),TV.VentaTotal) )
		  else 0
	   end as [PorcentajeRecompra]    
  FROM RecompraXProducto RXP
     LEFT JOIN Recompra R ON R.CompanyId = RXP.DistribuidorId and R.ProductoId = RXP.ProductoId 
	       and R.Fecha > EOMONTH(RXP.FechaPeriodo, -2) and convert(date,R.Fecha) <= EOMONTH(RXP.FechaPeriodo, -1) 
	 LEFT JOIN TotalVenta TV ON TV.CompanyId = RXP.DistribuidorId 
	       and TV.Fecha > EOMONTH(RXP.FechaPeriodo, -2) AND TV.Fecha <= EOMONTH(RXP.FechaPeriodo, -1)


