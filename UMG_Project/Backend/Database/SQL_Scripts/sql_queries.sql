/*
Scenario
Context: We’ve just received a wealth of new data from Audisense, and as we head into the next quarter, our focus is on deepening fan engagement, increasing cross-platform visibility, and targeting growth segments that have high revenue potential. Our priority is to ensure that our artists reach audiences effectively, and we want to position UMG as a leader in audience-driven strategy within the music industry.

Main Objectives:

Optimize engagement for our top artists by leveraging fan insights.
Identify emerging fan segments and trends to target with new content and marketing strategies.
Enhance cross-platform strategies by understanding where and how fans interact with our content.
*/


/*
Business Question: How consistent do fans interact with each artist?
Final Expected Output: Artist Name | Consistency Score (weighted inverse of STDEV to favor artists with more consistency) | total comments | total likes | total shares
F-1 Expected Output: Artist Name | total_likes | stdev_likes | +...
*/

-- First CTE: Getting the standard deviation and totals for each interaction metric
WITH total_engagement AS (
SELECT 
    a.artist_name,
    a.genre,
    a.LABEL,
    SUM(fem.likes) AS total_likes,
    STDDEV(fem.likes) AS stddev_likes,
    SUM(fem.shares) AS total_shares,
    STDDEV(fem.shares) AS stddev_shares,
    SUM(fem.COMMENTS) AS total_comments,
    STDDEV(fem.comments) AS stddev_comments
FROM 
    artists a 
JOIN 
    fan_engagement_metrics fem ON a.artist_id = fem.artist_id
GROUP BY 
	a.artist_name,
	a.genre,
	a.label
)
-- Final Query: Using the Stddev to create a consistency score that gives higher scores to artists with more consistent interactions
SELECT 
	artist_name,
	genre,
	LABEL,
    (1 / NULLIF(stddev_likes, 0) * (0.333) +
    1 / NULLIF(stddev_shares, 0) * (0.333) + 
    1 / NULLIF(stddev_comments, 0) * (0.333)) * 100 AS consistency_score,
	total_likes,
	total_comments,
	total_shares
FROM 
	total_engagement 
ORDER BY 
	artist_name;

/*
Business Question: Which audiences engage with the most artists/genres
Final Expected Output: segment_name | total_genres | total_artists
*/

-- Getting the total artists and genres for each segment
SELECT 
	as2.segment_name,
	COUNT(a.artist_id) AS total_artists,
	COUNT(DISTINCT a.genre) AS total_genres
FROM 
	audience_segments as2 
	JOIN insights i ON as2.segment_id = i.segment_id 
	JOIN artists a ON i.artist_id = a.artist_id 
GROUP BY 
	as2.segment_name;
	
/*
Business Question: What is the top music service for each genre by streams
Final Expected Output: genre | music_service | streams 
F-1 Expected Output: genre | music_service | ROW_NUMBER() AS ranked_streams
*/

-- Getting the total streams for each genre on each music service and ranking them accoridngly
WITH genres_by_service AS (
SELECT 
	a.genre,
	ap.music_service,
	SUM(streams) AS total_streams,
	ROW_NUMBER() OVER(PARTITION BY genre ORDER BY SUM(streams) DESC) AS streams_ranked
FROM 
	audience_profiles ap 
	JOIN fan_engagement_metrics fem ON ap.profile_id = fem.profile_id 
	JOIN artists a ON fem.artist_id = a.artist_id 
GROUP BY 
	a.genre,
	ap.music_service
)

-- Selecting only the top streamed service for each genre
SELECT 
	genre,
	music_service,
	total_streams
FROM 
	genres_by_service
WHERE 
	streams_ranked = 1;

/*
Business Question: What percent of each segment uses each device type?
Final Expected Output: segment_name  | device_type | user_count | user_percentage
F-1 Expected Output: segment_name | device_type | user_countt
*/

-- Getting the total users for each segment and device
WITH segment_counts AS (
SELECT  
		as2.segment_name,
		ap.device_type,
		COUNT(ap.profile_id) AS user_count		
FROM 
	audience_segments as2 
	JOIN insights i ON as2.segment_id = i.segment_id 
	JOIN artists a ON i.artist_id = a.artist_id 
	JOIN fan_engagement_metrics fem ON fem.artist_id = a.artist_id 
	JOIN audience_profiles ap ON fem.profile_id = ap.profile_id 
GROUP BY 
	as2.segment_name,
	ap.device_type
)

-- Finding the percent of users who use each device in each segment
SELECT 
	segment_name,
	device_type,
	user_count,
	user_count / (SUM(user_count) OVER(PARTITION BY segment_name)) AS user_percentage
FROM 
	segment_counts
GROUP BY 
	segment_name,
	device_type,
	user_count
