/****** Object:  Table [dbo].[dimArtist]    Script Date: 6/3/2019 1:25:28 PM ******/
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


