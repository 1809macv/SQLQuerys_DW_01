
SET LANGUAGE Spanish
SET DATEFIRST 7;

CREATE VIEW [PIVOT].[Efectividad_Paso00]
AS

SELECT DISTINCT Company.Id AS IdDistribuidor
	,Company.[Name] AS Distribuidor
	,C3.[Name] AS Sucursal 
	,convert(date, Sale.SaleDate) AS FechaVenta
	,((Day(Sale.SaleDate) + (Datepart(dw, Dateadd(Month, Datediff(Month, 0, Sale.SaleDate), 0)) - 1) -1) / 7 + 1) AS SemanaMes
	,DatePart(wk, Sale.SaleDate) AS NumeroSemana
	,Usr.Id AS VendedorId
	,Usr.[Name] AS VendedorNombre
  FROM [Sales].MsSale Sale
		INNER JOIN Base.MsCompany Company ON Company.Id = Sale.CompanyId
		INNER JOIN [Security].MsUser Usr ON Usr.Id = Sale.UserId 
		INNER JOIN Base.PsClassifier C3 ON C3.Id = Company.LocalIdc and C3.ClassifierTypeId = 50 
 WHERE Sale.CompanyId >= 3 

GO
