CREATE VIEW [PIVOT].Efectividad_Paso03
AS
SELECT DISTINCT Sale.CompanyId AS DistribuidorId
	  ,Company.[Name] AS Distribuidor
	  ,Seller.[Name] AS VendedorNombre
	  ,CustomerName AS ClienteNombre
	  ,Sale.SellerId AS VendedorId
	  ,convert(DATE, SaleDate) AS Fecha
	  ,'Compra' AS Tipo
  FROM [Sales].MsSale Sale 
	INNER JOIN [Base].MsCompany Company ON Company.Id = Sale.CompanyId 
	INNER JOIN [Security].MsUser Seller ON Seller.Id = Sale.SellerId
 WHERE StatusIdc <> 104

UNION ALL
 
SELECT DISTINCT Visit.CompanyId AS DistribuidorId
	,Comp.[Name] AS Distribuidor
	,Seller.[Name] AS VendedorNombre
	,Customer.[Name] AS ClienteNombre
	,Visit.UserId AS VendedorId
	,convert(DATE, VisitDate) AS Fecha
	,'Visita' AS Tipo
  FROM [Sales].PsVisit Visit
	INNER JOIN [Base].MsCompany Comp ON Comp.Id = Visit.CompanyId 
	INNER JOIN [Security].MsUser Seller ON Seller.Id = Visit.UserId
	INNER JOIN [Sales].MsCustomer Customer ON Customer.Id = Visit.CustomerId


GO
