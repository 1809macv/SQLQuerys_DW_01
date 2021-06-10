SET DATEFORMAT YMD

DECLARE @FechaHoy DATE = CAST( GETDATE() as DATE) 
DECLARE @FechaDesde DATE = EOMONTH(@FechaHoy, -2);

DELETE FROM [PIVOT].VentasCobertura
WHERE DATEFROMPARTS(AnioVenta, MesNumero, 1) > @FechaDesde

--Realiza la insercion de los valores de las ventas
--se obtiene de la tabla: VentasXFecha
--------------------------------------------------------------------------
INSERT INTO [PIVOT].VentasCobertura
(IdDistribuidor ,AnioVenta ,MesNumero ,VendedorId ,ProductoId ,TotalNeto ,CantidadProducto ,CantidadBultos
	,CantidadCobertura)
SELECT IdDistribuidor 
      ,YEAR(FechaVenta)
      ,MONTH(FechaVenta)
      ,VendedorId
      ,ProductoId
      ,SUM(TotalProducto - DescuentoProducto - Descuento2Producto) AS TotalNeto
      ,SUM(CantDISP_UN) AS CantidadProducto
      ,SUM(CantBU) AS CantidadBultos
	  ,0
  FROM [PIVOT].VentasXFecha
 WHERE FechaVenta >= @FechaDesde AND IdDocumentoEstado <> 104
GROUP BY IdDistribuidor ,YEAR(FechaVenta) ,MONTH(FechaVenta) ,VendedorId ,ProductoId;

--Se realiza la actualizacion del valor de las coberturas
--se obtiene de la tabla: CoberturaXPRoductoVendedor_Mensual
--------------------------------------------------------------------------
WITH Cobertura (IdDistribuidor ,AnioVenta ,MesNumero ,SellerId ,ProductId ,Cobertura)
AS (
SELECT IdDistribuidor ,AnioVenta ,MesNumero ,SellerId ,ProductId
	  ,SUM(Cobertura) AS Cobertura
  FROM [PIVOT].CoberturaXProductoVendedor_Mensual Cobertura 
GROUP BY IdDistribuidor ,AnioVenta ,MesNumero ,SellerId ,ProductId
)
UPDATE Sales 
   SET Sales.CantidadCobertura = ISNULL(Cobertura.Cobertura, 0)
  FROM [PIVOT].VentasCobertura AS Sales 
	   INNER JOIN Cobertura AS Cobertura ON Cobertura.IdDistribuidor = Sales.IdDistribuidor
					AND Cobertura.AnioVenta = Sales.AnioVenta
					AND Cobertura.MesNumero = Sales.MesNumero
					AND Cobertura.SellerId = Sales.VendedorId
					AND Cobertura.ProductId = Sales.ProductoId
 WHERE DATEFROMPARTS(Sales.AnioVenta, Sales.MesNumero, 1) >= @FechaDesde


--UPDATE [PIVOT].VentasCobertura 
--   SET CantidadCobertura = (Select Cobertura.Cobertura From Cobertura AS Cobertura
--							 Where Cobertura.IdDistribuidor = [PIVOT].VentasCobertura.IdDistribuidor
--									AND Cobertura.AnioVenta = [PIVOT].VentasCobertura.AnioVenta
--									AND Cobertura.MesNumero = [PIVOT].VentasCobertura.MesNumero
--									AND Cobertura.SellerId = [PIVOT].VentasCobertura.VendedorId
--									AND Cobertura.ProductId = [PIVOT].VentasCobertura.ProductoId)
--WHERE [PIVOT].VentasCobertura.IdDistribuidor = 5 
--		AND [PIVOT].VentasCobertura.AnioVenta = 2021
--		AND [PIVOT].VentasCobertura.MesNumero = 1
--		AND [PIVOT].VentasCobertura.VendedorId = 90
--		AND [PIVOT].VentasCobertura.ProductoId in (1178, 1179, 1180)

