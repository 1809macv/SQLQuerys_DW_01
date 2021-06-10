SELECT Company.[Name] AS Distribuidor
      ,AnioVenta
      ,Mes.Nombre AS MesVenta
      ,Usr.UserName AS VendedroNombre
      ,Product.[Name] AS ProductoNombre
      ,Product.Code AS ProductoCodigo
	  ,Product.Negocio AS Negocio
	  ,Product.Reclasificacion AS Reclasificacion
	  ,Product.Segmento AS Segmento
	  ,Product.SubRubro AS SubRubro
      ,TotalNeto
      ,CantidadBultos
      ,CantidadProducto
      ,CantidadCobertura
  FROM [PIVOT].VentasCobertura Sales
        INNER JOIN [PIVOT].extMsCompany Company ON Company.Id = Sales.IdDistribuidor
        INNER JOIN [PIVOT].Meses AS Mes ON Mes.Id = Sales.MesNumero
        INNER JOIN [PIVOT].extMsUser Usr ON Usr.Id = Sales.VendedorId
        INNER JOIN [PIVOT].extMsProduct Product ON Product.Id = Sales.ProductoId