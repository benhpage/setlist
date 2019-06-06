/****** Object:  Table [dbo].[dimArtist]    Script Date: 6/4/2019 2:28:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dimSetlist](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceId] [varchar](max) NULL,
	[ArtistId] int NULL,
	[ArtistName] [varchar](max) NULL,
	[VenueId] int NULL,
	[VenueName] [varchar](max) NULL,
	[Date] date NULL	
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


