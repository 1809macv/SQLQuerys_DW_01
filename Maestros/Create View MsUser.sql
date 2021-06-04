
CREATE VIEW [PIVOT].[MsUser]
AS
SELECT SystemUser.Id
	  ,SystemUser.TypeIdc 
	  ,Classifier.[Name] AS Classifier
	  ,SystemUser.CompanyId
	  ,Company.[Name] AS CompanyName
	  ,SystemUser.Code AS UserCode
	  ,SystemUser.[Name] AS UserName
	  ,ISNULL(SystemUser.Email,'') AS UserEmail
	  ,ISNULL(SystemUser.Phone,'') AS PhoneNumber
	  ,SystemUser.Active
  FROM [Security].[MsUser] SystemUser
		INNER JOIN [Base].[PsClassifier] Classifier ON Classifier.Id = SystemUser.TypeIdc
		INNER JOIN [Base].[MsCompany] Company ON Company.Id = SystemUser.CompanyId

GO
