SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [stage].[loadFinalStage]

AS

--load Final Staging Table

--declare show-level variables
DECLARE @showId varchar(max);
DECLARE @eventDate varchar(max);
DECLARE @artistId varchar(max);
DECLARE @artistName varchar(max);
DECLARE @venueId varchar(max);
DECLARE @venueName varchar(max);
DECLARE @venueCity varchar(max);
DECLARE @venueStateName varchar(max);
DECLARE @venueStateCode varchar(max);
DECLARE @venueCountryName varchar(max);
DECLARE @venueCountryCode varchar(10);
DECLARE @venueLat decimal(12,7);
DECLARE @venueLong decimal(12,7);
DECLARE @tourName varchar(max);

--delcare json object variables
DECLARE @stage nvarchar(max);
DECLARE @sets nvarchar(max);

--declare counter variables
DECLARE @innerCountRows int;
DECLARE @innerCounter int
DECLARE @outerCountRows int;
DECLARE @outerCounter int;

--set variables that need to be established before OUTER WHILE LOOP starts
set @outerCounter = 1;
set @outerCountRows = (select count(*) from json_stage);

drop table if exists #stage
select 
	*,
	ROW_NUMBER() OVER(ORDER BY file_dump) r_num
into
	#stage
from
	json_stage
;

WHILE @outerCounter <= @outerCountRows
BEGIN

--Set variables that need to be established before INNER WHILE LOOP starts
set @stage = (select file_dump from #stage where r_num = @outerCounter);
set @innerCountRows = (select count(*) from openjson(@stage));
set @innerCounter = 1;

--temp table for the sets sub array
drop table if exists #sets
select 
	row_number() over (order by json_query(value, '$.sets.set')) r_num,
	json_value(value, '$.id') showId,
	json_value(value, '$.eventDate') eventDate,
	json_value(value, '$.artist.mbid') artistMBID,
	json_value(value, '$.artist.name') artistName,
	json_value(value, '$.venue.id') venueSLID,
	json_value(value, '$.venue.name') venueName,
	json_value(value, '$.venue.city.name') venueCity,
	json_value(value, '$.venue.city.state') venueStateName,
	json_value(value, '$.venue.city.stateCode') venueStateCode,
	json_value(value, '$.venue.city.country.name') venueCountryName,
	json_value(value, '$.venue.city.country.code') venueCountryCode,
	json_value(value, '$.venue.city.coords.lat') venueLat,
	json_value(value, '$.venue.city.coords.long') venueLong,
	json_value(value, '$.tour.name') tourName,
	json_query(value, '$.sets.set') sets
into #sets
from 
	openjson(@stage)
;

drop table if exists #songs;
CREATE table #songs (
	showSLID varchar(max),
	eventDate varchar(max),
	artistMBID varchar(max),
	artistName varchar(max),
	venueSLID varchar(max),
	venueName varchar(max),
	venueCity varchar(max),
	venueStateName varchar(max),
	venueStateCode varchar(max),
	venueCountryName varchar(max),
	venueCountryCode varchar(max),
	venueLat decimal(12,7),
	venueLong decimal(12,7),
	tourName varchar(max),
	setName varchar(max),
	song varchar(max),
	songName varchar(max),
	coverArtistMBID varchar(max),
	coverArtistName varchar(max)
);

--START WHILE LOOP
WHILE @innerCounter <= @innerCountRows
BEGIN

--Set variables that need to be updated in while loop
SET @showId = (select showId from #sets where r_num = @innerCounter);
SET @eventDate = (select eventDate from #sets where r_num = @innerCounter);
SET @artistId = (select artistMBID from #sets where r_num = @innerCounter);
SET @artistName = (select artistName from #sets where r_num = @innerCounter);
SET @venueId = (select venueSLID from #sets where r_num = @innerCounter);
SET @venueName = (select venueName from #sets where r_num = @innerCounter);
SET @venueCity = (select venueCity from #sets where r_num = @innerCounter);
SET @venueStateName = (select venueStateName from #sets where r_num = @innerCounter);
SET @venueStateName = (select venueStateName from #sets where r_num = @innerCounter);
SET @venueStateCode = (select venueStateCode from #sets where r_num = @innerCounter);
SET @venueCountryName = (select venueCountryName from #sets where r_num = @innerCounter);
SET @venueCountryCode = (select venueCountryCode from #sets where r_num = @innerCounter);
SET @venueLat = (select venueLat from #sets where r_num = @innerCounter);
SET @venueLong = (select venueLong from #sets where r_num = @innerCounter);
SET @tourName = (select tourName from #sets where r_num = @innerCounter);
SET @sets = (select sets from #sets where r_num = @innerCounter);


INSERT INTO #songs
(showSLID,eventDate, artistMBID, artistName, venueSLID, venueName, venueCity, venueStateName, venueStateCode,
 venueCountryName, venueCountryCode, venueLat, venueLong, tourName, setName, song, songName, coverArtistMBID, coverArtistName)
select
	@showId showSLID,
	@eventDate eventDate,
	@artistId artistMBID,
	@artistName artistName,
	@venueId venueSLID,
	@venueName venueName,
	@venueCity venueCity,
	@venueStateName venueStateName,
	@venueStateCode venueStateCode,
	@venueCountryName venueCountryName,
	@venueCountryCode venueCountryCode,
	@venueLat venueLat,
	@venueLong venueLong,
	@tourName tourName,
	*
from
	openjson(@sets)
WITH (
	setName varchar(max) '$.name', 
	song nvarchar(max) '$.song' as json) --json objects have to be type nvarchar(max)
	outer apply openjson( song ) 
                     with ( 
							songname varchar(max) '$.name',
							coverArtistMBID varchar(max) '$.cover.mbid',
							coverArtistName varchar(max) '$.cover.name'
	)

--update inner counter variable to keep looping through shows
SET @innerCounter = @innerCounter + 1

END
--END OF INNER WHILE LOOP
;

insert into stage.finalStage
(showSLID, eventDateOriginal, EventDate, ArtistMBID, ArtistName, VenueSLID, VenueName, VenueCity, VenueStateName, VenueStateCode,
 VenueCountryName, VenueCountryCode, VenueLat, VenueLong, TourName, SetName, SongName, SongOrder,CoverArtistMBID, CoverArtistName)
select * from (
select 
	showSLID,
	eventDate eventDateOriginal,
	CAST(CONCAT( SUBSTRING(eventDate,4,2),'/',LEFT(eventDate,2),'/',RIGHT(eventDate,4)) AS DATE) EventDate,
	ArtistMBID,
	ArtistName,
	VenueSLID,
	venueName,
	venueCity,
	venueStateName,
	venueStateCode,
	venueCountryName,
	venueCountryCode,
	venueLat,
	venueLong,
	tourName,
	SetName,
	SongName,
	ROW_NUMBER() OVER (PARTITION BY showSLID ORDER BY setName, showSLID) SongOrder,
	CoverArtistMBID,
	coverArtistName 
from
	#songs s
) stage

where not exists (select showSLID from stage.finalStage f where f.showSLID = stage.showSLID)

--update outer counter variable to keep looping through files
SET @outerCounter = @outerCounter + 1

END
--END OF OUTER LOOP

RETURN 0