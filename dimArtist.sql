SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dimArtist](
	[ID] int IDENTITY(1,1) PRIMARY KEY,
	[mbid] [nvarchar](max) NULL,
	[name] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


