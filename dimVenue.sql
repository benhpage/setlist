SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dimVenue](
	[ID] int IDENTITY(1,1) PRIMARY KEY,
	[venueSLID] [varchar](50) NOT NULL,
	[Name] [varchar](250) NULL,
	[City] [varchar](250) NULL,
	[State] [varchar](50) NULL,
	[StateCode] [varchar](10) NULL,
	[Country] [varchar](250) NULL,
	[CountryCode] [varchar](10) NULL,
	[lat] [decimal](12, 7) NULL,
	[long] [decimal](12, 7) NULL
) ON [PRIMARY]
GO


