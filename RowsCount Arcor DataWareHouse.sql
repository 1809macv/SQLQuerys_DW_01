SELECT [Name], [TotalRows] FROM (
		VALUES 
			  (N'CoberturaXcliente', (select count(*) from [PIVOT].[CoberturaXcliente])),
			  (N'CoberturaXProducto', (select count(*) from [PIVOT].[CoberturaXProducto])),
			  (N'CoberturaXVendedor', (select count(*) from [PIVOT].[CoberturaXVendedor])),
			  (N'Compras', (select count(*) from [PIVOT].[Compras])),
			  (N'Efectividad', (select count(*) from [PIVOT].[Efectividad])),
			  (N'Pagos', (select count(*) from [PIVOT].[Pagos])),
			  (N'RecompraXCliente', (select count(*) from [PIVOT].[RecompraXCliente])),
			  (N'RecompraXProducto', (select count(*) from [PIVOT].[RecompraXProducto])),
			  (N'StockXFecha', (select count(*) from [PIVOT].[StockXFecha])),
			  (N'VentasXFecha', (select count(*) from [PIVOT].[VentasXFecha])),
			  (N'VentasXFecha2', (select count(*) from [PIVOT].[VentasXFecha2]))
			  ) TableRows([Name], [TotalRows]);


DECLARE @maxId bigint = (SELECT max(Id) FROM [PIVOT].extMsCompany)
PRINT @maxId
