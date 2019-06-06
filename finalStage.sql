SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stage].[finalStage](
	[showSLID] [varchar](max) NULL,
	[eventDateOriginal] [varchar](max) NULL,
	[EventDate] [date] NULL,
	[ArtistMBID] [varchar](max) NULL,
	[ArtistName] [varchar](max) NULL,
	[VenueSLID] [varchar](max) NULL,
	[venueName] [varchar](max) NULL,
	[venueCity] [varchar](max) NULL,
	[venueStateName] [varchar](max) NULL,
	[venueStateCode] [varchar](max) NULL,
	[venueCountryName] [varchar](max) NULL,
	[venueCountryCode] [varchar](max) NULL,
	[venueLat] [decimal](12, 7) NULL,
	[venueLong] [decimal](12, 7) NULL,
	[tourName] [varchar](max) NULL,
	[SetName] [varchar](max) NULL,
	[SongName] [varchar](max) NULL,
	[SongOrder] [int] NULL,
	[CoverArtistMBID] [varchar](max) NULL,
	[coverArtistName] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


