exec [PIVOT].[spStockXFecha]
go

--138229
select * from [PIVOT].[StockXFecha]
where productocodigo = '1001064' and numerolote = 'Lote06032020' and messtock = '11. Noviembre'

--69,68
select * from [Warehouse].[PsBatch]
where BachNumber = 'Lote09102019'
--888,889
select * from [Warehouse].[MsProduct]
where code = '1011395'

select * from [Warehouse].[PsStoreTransactionDetail]
where productid = 888 and batchid = 69

select * from [Warehouse].[PsStockCost]
where productid in ( 893,807,779,732,469,524,399,377,938,101,977,963 ) and companyid = 3


-- 539,1034,947,206
-- 888,680,551,550,1047


DECLARE @date DATETIME = '12/1/2011';  
SELECT EOMONTH ( @date ) AS Result;  
GO

SELECT Distribuidor
	  ,Almacen
	  ,AnioStock
	  ,MesStock
	  ,FechaStock
	  ,ProductoCodigo
	  ,ProductoNombre
	  ,FactorConversion
	  ,NumeroLote
	  ,TipoLote
	  ,Negocio
	  ,Reclasificacion
	  ,Segmento
	  ,SubRubro
	  ,FechaExpiracion
	  ,PesoNeto
	  ,PesoBruto
	  ,Cantidad
  FROM [PIVOT].[StockXFecha] SxF
 WHERE FechaStock in (Select Distinct EOMONTH(x.FechaStock) FROM [PIVOT].[StockXFecha] x
                       WHERE x.DistribuidorId = SxF.DistribuidorId)
	   --and DistribuidorId >= 3

SELECT Distribuidor
      ,Almacen
	  ,AnioStock
	  ,MesStock
	  ,FechaStock
	  ,ProductoCodigo
	  ,ProductoNombre
	  ,FactorConversion
	  ,NumeroLote
	  ,TipoLote
	  ,Negocio
	  ,Reclasificacion
	  ,Segmento
	  ,SubRubro
	  ,FechaExpiracion
	  ,PesoNeto
	  ,PesoBruto
	  ,Cantidad
  FROM [PIVOT].[StockXFecha]
 WHERE DistribuidorId = 5
