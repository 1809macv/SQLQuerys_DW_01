/****** Object:  View [PIVOT].[CoberturaXProductoVendedor_Mensual]    Script Date: 11/18/2020 10:24:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [PIVOT].[CoberturaXProductoVendedor_Mensual]
AS
SELECT DISTINCT Sale.CompanyId AS IdDistribuidor
	  ,Year(Sale.SaleDate) as AnioVenta
	  ,Month(Sale.SaleDate) as MesVenta
	  ,Sale.CustomerId 
	  ,Sale.SellerId 
	  ,Usr.[Name] as SellerName
	  ,SDetail.ProductId as ProductId
  FROM [Sales].MsSale Sale 
	INNER JOIN [Sales].[PsSaleDetail] SDetail ON SDetail.SaleId = Sale.Id 
	INNER JOIN [Security].[MsUser] Usr ON Usr.Id = Sale.SellerId 
 WHERE Sale.StatusIdc <> 104 and Sale.CompanyId >= 3 
GO


