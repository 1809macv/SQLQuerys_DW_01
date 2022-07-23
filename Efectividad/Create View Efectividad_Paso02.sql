/****** Object:  View [PIVOT].[Efectividad_Paso02]    Script Date: 7/22/2022 4:02:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER VIEW [PIVOT].[Efectividad_Paso02]
AS
SELECT Distinct Sale.CompanyId AS DistribuidorId
	  ,Sale.SellerId AS VendedorId
	  ,Seller.[Name] AS VendedorNombre
	  ,Sale.CustomerId AS ClienteId
	  ,Sale.CustomerName AS ClienteNombre
	  ,convert(date, Sale.SaleDate) AS FechaVenta
  FROM [Sales].MsSale Sale 
		INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId and Seller.CompanyId = Sale.CompanyId
 WHERE StatusIdc <> 104
    and Sale.CompanyId >= 3 
	--and convert(date, SaleDate) = '2019/05/06' and Sale.SellerId = 249


GO

