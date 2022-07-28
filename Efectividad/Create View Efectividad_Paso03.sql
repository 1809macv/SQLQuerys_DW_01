CREATE OR ALTER VIEW [PIVOT].Efectividad_Paso03
AS
SELECT DISTINCT Sale.CompanyId AS DistribuidorId
	  ,Company.[Name] AS Distribuidor
	  ,Sale.SellerId AS VendedorId
	  ,Seller.[Name] AS VendedorNombre
	  ,Sale.CustomerId AS ClienteId
	  ,Sale.CustomerName AS ClienteNombre
	  ,Convert(DATE, SaleDate) AS Fecha
	  ,'Compra' AS Tipo
  FROM [Sales].MsSale Sale 
	INNER JOIN [Base].MsCompany Company ON Company.Id = Sale.CompanyId 
	INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE Sale.StatusIdc <> 104 AND Sale.CompanyId >= 3

UNION ALL
 
SELECT DISTINCT Visit.CompanyId AS DistribuidorId
	,Comp.[Name] AS Distribuidor
	,Visit.UserId AS VendedorId
	,Seller.[Name] AS VendedorNombre
	,Visit.CustomerId AS ClienteId
	,Customer.[Name] AS ClienteNombre
	,Convert(DATE, VisitDate) AS Fecha
	,'Visita' AS Tipo
  FROM [Sales].PsVisit Visit
	INNER JOIN [Base].MsCompany Comp ON Comp.Id = Visit.CompanyId 
	INNER JOIN [Security].MsUser Seller ON Seller.Id = Visit.UserId
	INNER JOIN [Sales].MsCustomer Customer ON Customer.Id = Visit.CustomerId
 WHERE Visit.CompanyId >= 3


GO
