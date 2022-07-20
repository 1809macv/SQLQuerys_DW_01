/****** Object:  Table [PIVOT].[Efectividad]    Script Date: 7/14/2022 6:06:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[Efectividad2](
	[IdDistribuidor] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Sucursal] [varchar](255) NULL,
	[Gestion] [int] NULL,
	[Mes] [int] NULL,
	[Fecha] [date] NULL,
	[SemanaMes] [smallint] NULL,
	[SemanaAnio] [smallint] NULL,
	[VendedorId] [bigint] NULL,
	[VendedorNombre] [varchar](255) NULL,
	[PDVProgramado] [int] NULL,
	[PDVVisitados] [int] NULL,
	[PDVCompraron] [int] NULL,
	[PDVPromedio] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [PIVOT].[Efectividad2] ADD  CONSTRAINT [DF_Efectividad2_PDVProgramado]  DEFAULT ((0)) FOR [PDVProgramado]
GO

ALTER TABLE [PIVOT].[Efectividad2] ADD  CONSTRAINT [DF_Efectividad2_PDVVisitados]  DEFAULT ((0)) FOR [PDVVisitados]
GO

ALTER TABLE [PIVOT].[Efectividad2] ADD  CONSTRAINT [DF_Efectividad2_PDVCompraron]  DEFAULT ((0)) FOR [PDVCompraron]
GO

ALTER TABLE [PIVOT].[Efectividad2] ADD  CONSTRAINT [DF_Efectividad2_PDVPromedio]  DEFAULT ((0)) FOR [PDVPromedio]
GO


