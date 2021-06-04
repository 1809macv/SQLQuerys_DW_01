SELECT Cmp.[Name] as Distribuidor
	  ,Cmp.CiudadNombre as Ciudad
	  ,AnioVenta
	  ,Mes.Nombre as MesVenta
	  ,Cst.[BusinessName] as ClienteNombre
	  ,Cst.TipoRecursivo as TipoNegocio 
	  ,Cst.ClienteTipo as TipoCliente 
	  ,Cst.Categoria as CategoriaCliente 
	  ,Cst.Zona
	  ,SellerName as VendedorNombre
	  ,Prd.Code as ProductoCodigo
	  ,Prd.[Description] as ProductoNombre
	  ,Prd.Negocio
	  ,Prd.Reclasificacion 
	  ,Prd.Segmento 
	  ,Prd.SubRubro
 	  ,Cobertura
  FROM [PIVOT].[CoberturaXProductoVendedor_Mensual] PV
		INNER JOIN [PIVOT].[extMsCompany] Cmp ON Cmp.Id = PV.IdDistribuidor
		INNER JOIN [PIVOT].[extMsCustomer] Cst ON Cst.Id = PV.CustomerId
		INNER JOIN [PIVOT].[extMsProduct] Prd ON Prd.Id = PV.ProductId
		INNER JOIN [PIVOT].[Meses] as Mes ON PV.MesNumero = Mes.Id

