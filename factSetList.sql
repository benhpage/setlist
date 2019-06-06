SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[factSetList](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [nvarchar](max) NULL,
	[ArtistId] [int] NOT NULL,
	[VenueId] [int] NOT NULL,
	[Date] date NULL,
	[SetName] [varchar](50) NULL,
	[SongName] [varchar](100) NULL,
	[SongOrder] [int] NULL,
	[CoverInd] [bit] NULL,
	[CoverArtistId] [int] NULL,
	[CoverMBID] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


