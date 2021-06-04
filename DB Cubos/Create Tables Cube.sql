USE MSFSystem_Cube
GO

CREATE SCHEMA [PIVOT]
GO

CREATE TABLE [PIVOT].CoberturaXVendedor (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[AnioVenta] int Null,
	[MesVenta] varchar(20) Null,
	[MesNumero] smallint Null,
	[TipoNegocio] varchar(255) Null,
	[TipoCliente] varchar(255) Null,
	[CategoriaCliente] varchar(255) Null,
	[Zona] varchar(255) Null,
	[Vendedorid] bigint Null,
	[Vendedor] varchar(255) Null,
	[Cobertura] int Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].CoberturaXProducto (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[AnioVenta] int Null,
	[MesVenta] varchar(20) Null,
	[MesNumero] int Null,
	[TipoNegocio] varchar(255) Null,
	[TipoCliente] varchar(255) Null,
	[CategoriaCliente] varchar(255) Null,
	[Zona] varchar(255) Null,
	[Customerid] bigint Null,
	[ClienteNombre] varchar(255),
	[Negocio] varchar(255) Null,
	[Reclasificacion] varchar(255) Null,
	[Segmento] varchar(255) Null,
	[Subrubro] varchar(255) Null,
	[ProductoCodigo] varchar(20) Null,
	[ProductoNombre] varchar(255) Null, 
	[Cobertura] int Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].CoberturaXCliente (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[AnioVenta] int Null,
	[MesVenta] varchar(20) Null,
	[MesNumero] int Null,
	[TipoNegocio] varchar(255) Null,
	[TipoCliente] varchar(255) Null,
	[CategoriaCliente] varchar(255) Null,
	[Zona] varchar(255) Null,
	[Cobertura] int Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].Compras (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[Proveedor] varchar(255) Null,
	[AnioCompra] int Null,
	[MesCompra] varchar(20) Null,
	--[DiaCompra] int Null,
	[FechaCompra] date Null,
	[NumeroFactura] varchar(20) Null,
	[FechaFactura] date Null,
	[NumeroAutorizacion] varchar(50) Null,
	[CodigoControl] varchar(20) Null,
	[EstadoPago] varchar(80) Null,
	[Referencia] varchar(255) Null,
	[MontoDebito] decimal(24,4) Null,
	[DiasCredito] int Null,
	[Negocio] varchar(255) Null,
	[Reclasificacion] varchar(255) Null,
	[Segmento] varchar(255) Null,
	[Subrubro] varchar(255) Null,
	[ProductoCodigo] varchar(20) Null,
	[ProductoNombre] varchar(255) Null,
	[UnidadMedidaAlmacen] varchar(255) Null,
	[FactorConversion] int Null,
	[CantidadProducto] decimal(24,4) Null,
	[UnidadMedidaMenor] varchar(255) Null,
	[CantidadProductoUnidadMenor] decimal(24,4) Null,
	[CostoUnitario] decimal(24,4) Null,
	[MontoTotalProducto] decimal(24,4) Null,
	[TotalDescuento] decimal(24,4) Null,
	[MontoTotal] decimal(24,4) Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].Pagos (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Proveedor] varchar(255) Null,
	[AnioGasto] int Null,
	[MesGasto] varchar(20) Null,
	[FechaGasto] date Null,
	[Observacion] varchar(255) Null,
	[EstadoDocumento] varchar(255) Null,
	[TipoNombre] varchar(255) Null,
	[TipoTransaccion] varchar(255) Null,
	[SubtipoTransaccion] varchar(255) Null,
	[NumeroNIT] varchar(25) Null,
	[AutorizacionNumero] varchar(50) Null,
	[NumeroFactura] varchar(20) Null,
	[CodigoControl] varchar(30) Null,
	[TipoMovimiento] varchar(15) Null,
	[Debe] decimal(24,4) Null,
	[Haber] decimal(24,4) Null,
	[NumeroCuenta] varchar(50) Null,
	[NombreCuenta] varchar(150) Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].RecompraXCliente (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[AnioVenta] int Null,
	[MesVenta] varchar(20) Null,
	[MesNumero] int Null,
	[TipoNegocio] varchar(255) Null,
	[TipoCliente] varchar(255) Null,
	[CategoriaCliente] varchar(255) Null,
	[Customerid] bigint Null,
	[ClienteNombre] varchar(255),
	[PorcentajeRecompra] decimal(24,16) Null
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].RecompraXProducto (
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Ciudad] varchar(255) Null,
	[AnioVenta] int Null,
	[MesVenta] varchar(20) Null,
	[MesNumero] int Null,
	[ProductoCodigo] varchar(20) Null,
	[ProductoNombre] varchar(255) Null,
	[Negocio] varchar(255) Null,
	[Reclasificacion] varchar(255) Null,
	[Segmento] varchar(255) Null,
	[Subrubro] varchar(255) Null,
	[PorcentajeRecompra] decimal(24,16) Null
) ON [PRIMARY]

GO

---------------------------------------------------
CREATE TABLE [PIVOT].Efectividad
(
	[IdDistribuidor] bigint Null,
	[Distribuidor] varchar(255) Null,
	[Sucursal] varchar(255) Null,
	[Gestion] int Null,
	[Mes] int Null,
	[Fecha] Date Null,
	[SemanaMes] smallint Null,
	[SemanaAnio] smallint Null,
	[VendedorId] bigint Null,
	[VendedorNombre] varchar(255) Null,
  [PDVProgramado] Integer CONSTRAINT [DF_Efectividad_PDVProgramado]  DEFAULT 0,
  [PDVVisitados] Integer CONSTRAINT [DF_Efectividad_PDVVisitados]  DEFAULT 0,
  [PDVCompraron] Integer CONSTRAINT [DF_Efectividad_PDVCompraron]  DEFAULT 0,
  [PDVPromedio] Integer CONSTRAINT [DF_Efectividad_PDVPromedio]  DEFAULT 0
) ON [PRIMARY]

GO

CREATE TABLE [PIVOT].[StockXFecha](
	[DistribuidorId] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[AlmacenId] [bigint] NULL,
	[Almacen] [varchar](100) NULL,
	[AnioStock] [int] NULL,
	[MesStock] [varchar](80) NULL,
	[FechaStock] [date] NULL,
	[ProductoId] [bigint] NULL,
	[ProductoCodigo] [varchar](50) NULL,
	[ProductoNombre] [varchar](255) NULL,
	[FactorConversion] [smallint] NULL,
	[NumeroLoteId] [bigint] NULL,
	[NumeroLote] [varchar](50) NULL,
	[TipoLote] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[FechaExpiracion] [date] NULL,
	[PesoNeto] [decimal](25, 7) NULL,
	[PesoBruto] [decimal](25, 7) NULL,
	[Cantidad] [decimal](25, 4) NULL
) ON [PRIMARY]
GO

CREATE TABLE [PIVOT].[VentasXFecha](
	[IdDistribuidor] bigint Null,
	[Distribuidor] [varchar](255) NULL,
	[NombreContacto] [varchar](255) NULL,
	[Ciudad] [varchar](255) NULL,
	[AnioVenta] [int] NULL,
	[MesVenta] [varchar](20) NULL,
	[FechaVenta] [date] NULL,
	[Zona] [varchar](255) NULL,
	[ClienteTipo] [varchar](255) NULL,
	[Categoria] [varchar](5) NULL,
	[TipoRecursivo] [varchar](255) NULL,
	[ClienteCodigo] [varchar](15) NULL,
	[RazonSocial] [varchar](255) NULL,
	[ClienteNombre] [varchar](255) NULL,
	[NumeroNit] [varchar](15) NULL,
	[NumeroFactura] [varchar](15) NULL,
	[AutorizacionNumero] [varchar](50) NULL,
	[CodigoControl] [varchar](25) NULL,
	[TipoPago] [varchar](20) NULL,
	[DocumentoEstado] [varchar](20) NULL,
	[Vendedor] [varchar](255) NULL,
	[Almacen] [varchar](255) NULL,
	[Negocio] [varchar](255) NULL,
	[Reclasificacion] [varchar](255) NULL,
	[Segmento] [varchar](255) NULL,
	[SubRubro] [varchar](255) NULL,
	[ProductoCodigo] [varchar](15) NULL,
	[ProductoNombre] [varchar](255) NULL,
	[Bonificacion] [varchar](2) NULL,
	[NumeroLote] [varchar](50) NULL,
	[UnidadMedidaVenta] [varchar](255) NULL,
	[FactorConversion] [int] NULL,
	[ListaPrecio] [varchar](255) NULL,
	[CantDISP_UN] [decimal](25, 6) NULL,
	[CantBU] [decimal](25, 6) NULL,
	[PrecioProducto] [decimal](25, 6) NULL,
	[TotalProducto] [decimal](25, 6) NULL,
	[DescuentoProducto] [decimal](25, 6) NULL,
	[Descuento2Producto] [decimal](25, 6) NULL,
	[DescuentoDocumento] [decimal](25, 6) NULL,
	[UsuarioTransaccion] [varchar](255) NULL,
	[PesoNeto] [decimal](25, 6) NULL,
	[PesoBruto] [decimal](25, 6) NULL,
	[TotalKilosNetos] [decimal](25, 6) NULL,
	[TotalKilosBrutos] [decimal](25, 6) NULL,
	[CostoPrecioPromedio] [decimal](25, 6) NULL,
	[TotalCostoPromedio] [decimal](25, 6) NULL,
	[CMB_Monto] [decimal](25, 6) NULL,
	[CMB_Porcentaje] [decimal](25, 6) NULL,
	[NumeroGuia] [varchar](15) NULL,
	[EstadoGuia] [varchar](50) NULL,
	[RepartidorNombre] [varchar](255) NULL
) ON [PRIMARY]
GO
