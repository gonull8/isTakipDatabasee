USE [istakip]
GO
/****** Object:  Table [dbo].[Oteller]    Script Date: 9.06.2023 22:54:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Oteller](
	[OtelID] [int] IDENTITY(1,1) NOT NULL,
	[OtelAd] [nvarchar](50) NULL,
 CONSTRAINT [PK_Oteller] PRIMARY KEY CLUSTERED 
(
	[OtelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PersonelLogin]    Script Date: 9.06.2023 22:54:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonelLogin](
	[PerID] [int] IDENTITY(1,1) NOT NULL,
	[PerAd] [nvarchar](15) NOT NULL,
	[PerSifre] [nvarchar](20) NOT NULL,
	[PerYetki] [int] NOT NULL,
	[PerDurum] [int] NULL,
 CONSTRAINT [PK_PersonelLogin] PRIMARY KEY CLUSTERED 
(
	[PerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Programlar]    Script Date: 9.06.2023 22:54:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Programlar](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[ProgramAdi] [nvarchar](max) NULL,
 CONSTRAINT [PK_Programlar] PRIMARY KEY CLUSTERED 
(
	[ProgramID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sorunlar]    Script Date: 9.06.2023 22:54:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sorunlar](
	[SorunID] [int] IDENTITY(1,1) NOT NULL,
	[IsletmePersonelAdi] [nvarchar](max) NULL,
	[Tel] [nvarchar](30) NULL,
	[Sorun] [nvarchar](max) NULL,
	[Cozum] [nvarchar](max) NULL,
	[SorunSaati] [date] NULL,
	[AtananPersonel] [nvarchar](25) NULL,
	[CozenPersonel] [nvarchar](25) NULL,
	[Departman] [nvarchar](max) NULL,
	[programId] [int] NULL,
	[otelid] [int] NULL,
 CONSTRAINT [PK_Sorunlar] PRIMARY KEY CLUSTERED 
(
	[SorunID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
