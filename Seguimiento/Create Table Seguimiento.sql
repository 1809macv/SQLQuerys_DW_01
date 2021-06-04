/****** Object:  Table [PIVOT].[Seguimiento]    Script Date: 11/1/2019 11:09:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PIVOT].[Seguimiento](
	[DistribuidorId] [bigint] NULL,
	[Distribuidor] [varchar](255) NULL,
	[Secuencia] [int] NULL,
	[ClienteCodigo] [bigint] NULL,
	[ClienteNombre] [varchar](150) NULL,
	[Fecha] [date] NULL,
	[HoraInicio] [time](7) NULL,
	[HoraFin] [time](7) NULL,
	[VendedorId] [bigint] NULL,
	[VendedorNombre] [varchar](200) NULL,
	[Motivo] [varchar](50) NULL,
	[DiaNombre] [varchar](255) NULL,
	[TieneGPS] [varchar](2) NULL 
) ON [PRIMARY]
GO


