/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [PIVOT].MsCompany
AS

SELECT Comp.[Id]
      ,Comp.[TypeIdc]
      ,Comp.[CityIdc]
	  ,C8.[Name] as CiudadNombre
      ,Comp.[Name]
      ,Comp.[Address]
      ,Comp.[Telephone]
      ,Comp.[Activity]
      ,Comp.[Reference]
      ,Comp.[Active]
      ,Comp.[Contact]
      ,Comp.[Email]
      ,Comp.[Code]
      ,Comp.[Nit]
  FROM [Base].[MsCompany] Comp
	   INNER JOIN Base.PsClassifier C8 ON C8.Id = CityIdc 

GO
