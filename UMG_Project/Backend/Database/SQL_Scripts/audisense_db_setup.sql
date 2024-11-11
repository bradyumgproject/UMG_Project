/*
 Step 1: Create the Tables
 */

-- Create the audience_profiles table
CREATE TABLE audience_profiles (
    profile_id SERIAL PRIMARY KEY,
    age_group VARCHAR(10),
    gender VARCHAR(20),
    location VARCHAR(50),
    preferred_genre VARCHAR(50),
    average_listening_hours DECIMAL(5, 2),
    device_type VARCHAR(20),
    music_service VARCHAR(50)
);


-- Create the artists table
CREATE TABLE artists (
    artist_id SERIAL PRIMARY KEY,
    artist_name VARCHAR(100),
    genre VARCHAR(50),
    label VARCHAR(100),
    social_followers INTEGER,
    monthly_listeners INTEGER,
    region_popularity VARCHAR(50)
);

-- Create the fan_engagement_metrics table
CREATE TABLE fan_engagement_metrics (
    engagement_id SERIAL PRIMARY KEY,
    profile_id INTEGER REFERENCES audience_profiles(profile_id),
    artist_id INTEGER REFERENCES artists(artist_id),
    streams INTEGER,
    likes INTEGER,
    shares INTEGER,
    comments INTEGER,
    time_spent_on_artist DECIMAL(5, 2),
    date DATE
);

-- Create the audience_segments table
CREATE TABLE audience_segments (
    segment_id SERIAL PRIMARY KEY,
    segment_name VARCHAR(100),
    criteria TEXT,
    size INTEGER,
    average_engagement_score DECIMAL(5, 2),
    preferred_device VARCHAR(20)
);

-- Create the insights table
CREATE TABLE insights (
    insight_id SERIAL PRIMARY KEY,
    segment_id INTEGER REFERENCES audience_segments(segment_id),
    artist_id INTEGER REFERENCES artists(artist_id),
    engagement_trend VARCHAR(20),
    audience_growth_rate DECIMAL(5, 2),
    engagement_rate DECIMAL(5, 2),
    top_platform VARCHAR(50)
);

-- Test that all tables were added
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

/*
 Step 2: Add CSV files to the tables using DBeaver interface
 */


-- Check that artists imported properly
SELECT 
	*
FROM 
	artists
LIMIT 
	10;

-- Check that audience_profiles imported properly
SELECT 
	*
FROM 
	audience_profiles 
LIMIT 
	10;

-- Check that audience_segments imported properly
SELECT 
	*
FROM 
	audience_segments 
LIMIT 
	10;

-- Check that fan_engagement_metrics imported properly
SELECT 
	*
FROM 
	fan_engagement_metrics
LIMIT 
	10;

-- Check that insights imported properly
SELECT 
	*
FROM 
	insights
LIMIT 
	10;


