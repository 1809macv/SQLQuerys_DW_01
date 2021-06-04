set dateformat YMD
CREATE VIEW [PIVOT].[Efectividad_Paso02]
AS
SELECT Distinct Sale.CompanyId as DistribuidorId
	  ,Seller.[Name] as VendedorNombre
	  ,CustomerName as ClienteNombre
	  ,Sale.SellerId as VendedorId
	  ,convert(date, Sale.SaleDate) as FechaVenta
  FROM [Sales].MsSale Sale 
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId and Seller.CompanyId = Sale.CompanyId
 WHERE StatusIdc <> 104
    and Sale.CompanyId = 10 and convert(date, SaleDate) = '2019/05/06' and Sale.SellerId = 249


GO

--select * from [Security].MsUser
--where companyid = 10
--order by name 

--select * from [Sales].PsVisit Visit
