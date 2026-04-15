-- Creating a table
CREATE TABLE website_analytics (
    Timestamp TEXT,
    User_ID TEXT,
    Page_Visited TEXT,
    Device_Type TEXT,
    Region TEXT,
    Session_Duration REAL,
    Bounce_Rate REAL,
    Conversion INTEGER,
    Page_Load_Time REAL
);


/* ====================================================================================================================================
												Inspecting the Raw Data
==================================================================================================================================== */

SELECT * FROM website_analytics LIMIT 10;

-- Count rows and check for nulls
SELECT COUNT(*) AS total_rows FROM website_analytics;

-- Missing values by column
SELECT
    SUM(CASE WHEN Session_Duration IS NULL THEN 1 ELSE 0 END) AS missing_session_duration,
    SUM(CASE WHEN Bounce_Rate IS NULL THEN 1 ELSE 0 END) AS missing_bounce_rate,
    SUM(CASE WHEN Page_Load_Time IS NULL THEN 1 ELSE 0 END) AS missing_page_load,
    SUM(CASE WHEN Device_Type IS NULL THEN 1 ELSE 0 END) AS missing_device_type
FROM website_analytics;


/* ====================================================================================================================================
												Identifing Invalid or Outlier Values
==================================================================================================================================== */

-- Negative session durations
SELECT * FROM website_analytics WHERE Session_Duration < 0;

-- Bounce rate greater than 1
SELECT * FROM website_analytics WHERE Bounce_Rate > 1;

-- Conversion flag not 0 or 1
SELECT * FROM website_analytics WHERE Conversion NOT IN (0, 1);

/* ====================================================================================================================================
														Data Cleaning
==================================================================================================================================== */

-- ** Replacing Missing Values ** --

-- Fill missing device type with 'Unknown'
UPDATE website_analytics
SET Device_Type = 'Unknown'
WHERE Device_Type IS NULL;

-- Fill missing numeric columns with median or average
-- (Example using AVG — for production, use a subquery to calculate median if needed)
UPDATE website_analytics
SET Session_Duration = (
    SELECT AVG(Session_Duration)
    FROM website_analytics
    WHERE Session_Duration > 0
)
WHERE Session_Duration IS NULL;

UPDATE website_analytics
SET Bounce_Rate = (
    SELECT AVG(Bounce_Rate)
    FROM website_analytics
    WHERE Bounce_Rate > 0
)
WHERE Bounce_Rate IS NULL;


UPDATE website_analytics
SET Page_Load_Time = (
    SELECT AVG(Page_Load_Time)
    FROM website_analytics
    WHERE Page_Load_Time > 0
)
WHERE Page_Load_Time IS NULL;

-- ** Correcting Invalid Values ** --

-- Fixing negative session durations (replacing with median)
UPDATE website_analytics
SET Session_Duration = (
    SELECT AVG(Session_Duration)
    FROM website_analytics
    WHERE Session_Duration > 0
)
WHERE Session_Duration < 0;

-- Clip bounce rate to range 0–1
UPDATE website_analytics
SET Bounce_Rate = 1
WHERE Bounce_Rate > 1;

UPDATE website_analytics
SET Bounce_Rate = 0
WHERE Bounce_Rate < 0;

-- Fixing invalid conversion flags
UPDATE website_analytics
SET Conversion = 0
WHERE Conversion NOT IN (0, 1);

S

/* ====================================================================================================================================
												Creating New Features (For Visulaization)
==================================================================================================================================== */

-- Add date and hour columns
ALTER TABLE website_analytics ADD COLUMN Date DATE;
ALTER TABLE website_analytics ADD COLUMN Hour INTEGER;

-- Data Type Check
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'website_analytics';

-- Changing Type
ALTER TABLE website_analytics
ALTER COLUMN timestamp TYPE TIMESTAMP
USING TO_TIMESTAMP(timestamp, 'MM/DD/YYYY HH24:MI');


-- Adding and Populating Data & Hour Columns
UPDATE website_analytics
SET
    Date = CAST(timestamp AS DATE),
    Hour = EXTRACT(HOUR FROM timestamp);


-- Adding engagement score (Session_Duration / (Page_Load_Time + 1))
ALTER TABLE website_analytics ADD COLUMN Engagement_Score REAL;

UPDATE website_analytics
SET Engagement_Score = ROUND( (Session_Duration / (Page_Load_Time + 1))::numeric, 2 );


-- Verifing changes
SELECT timestamp, Date, Hour
FROM website_analytics
LIMIT 10;

SELECT Session_Duration, Page_Load_Time, Engagement_Score
FROM website_analytics
LIMIT 5;

select * from website_analytics LIMIT 10;

/* ====================================================================================================================================
												Validating Cleaned Data
==================================================================================================================================== */

-- Checking ranges
SELECT
    MIN(Session_Duration) AS min_session,
    MAX(Session_Duration) AS max_session,
    AVG(Session_Duration) AS avg_session,
    MIN(Bounce_Rate) AS min_bounce,
    MAX(Bounce_Rate) AS max_bounce
FROM website_analytics;

-- Confirming no invalid conversion flags
SELECT DISTINCT Conversion FROM website_analytics;


/* ====================================================================================================================================
												Storing Cleaned Results In A New Table
==================================================================================================================================== */

CREATE TABLE website_analytics_cleaned AS
SELECT
    TO_TIMESTAMP(timestamp, 'MM/DD/YYYY HH24:MI') AS Timestamp,
    User_ID,
    Page_Visited,
    COALESCE(Device_Type, 'Unknown') AS Device_Type,
    Region,
    CASE
        WHEN Session_Duration < 0 OR Session_Duration IS NULL
            THEN (SELECT AVG(Session_Duration) FROM website_analytics WHERE Session_Duration > 0)
        ELSE Session_Duration
    END AS Session_Duration,
    CASE
        WHEN Bounce_Rate > 1 OR Bounce_Rate IS NULL THEN 1
        WHEN Bounce_Rate < 0 THEN 0
        ELSE Bounce_Rate
    END AS Bounce_Rate,
    CASE
        WHEN Conversion NOT IN (0, 1) THEN 0
        ELSE Conversion
    END AS Conversion,
    COALESCE(Page_Load_Time, (SELECT AVG(Page_Load_Time) FROM website_analytics)) AS Page_Load_Time,
    CAST(TO_TIMESTAMP(timestamp, 'MM/DD/YYYY HH24:MI') AS DATE) AS Date,
    EXTRACT(HOUR FROM TO_TIMESTAMP(timestamp, 'MM/DD/YYYY HH24:MI')) AS Hour
FROM website_analytics;

/* ====================================================================================================================================
													Queries for Dashboard KPIs
==================================================================================================================================== */

-- Traffic Overview
SELECT Date, COUNT(DISTINCT User_ID) AS daily_users
FROM website_analytics
GROUP BY Date
ORDER BY Date;

-- Device Usage
SELECT Device_Type, COUNT(*) AS visits
FROM website_analytics
GROUP BY Device_Type
ORDER BY visits DESC;

-- Region Performance
SELECT Region, ROUND(AVG(Conversion) * 100, 2) AS conversion_rate
FROM website_analytics
GROUP BY Region;

-- Hourly Engagement (Type casting used)
SELECT Hour, ROUND(AVG(Engagement_Score::numeric),2) AS avg_engagement
FROM website_analytics
GROUP BY Hour
ORDER BY Hour;

-- Page Load Performance of Load Time, Bounce Rate and Engagement Rate (Type casting used)
SELECT ROUND(Page_Load_Time::numeric,1) AS load_bucket,
       ROUND(AVG(Bounce_Rate::numeric),2) AS avg_bounce_rate,
       ROUND(AVG(Engagement_Score::numeric),2) AS avg_engagement
FROM website_analytics
GROUP BY load_bucket
ORDER BY load_bucket;

-- Load Time vs Bounce Rate (Type casting used)
SELECT 
    ROUND(Page_Load_Time::numeric, 1) AS load_time,
    ROUND(AVG(Bounce_Rate)::numeric, 2) AS avg_bounce
FROM website_analytics
GROUP BY ROUND(Page_Load_Time::numeric, 1)
ORDER BY load_time;


/* ====================================================================================================================================
										Exporting Cleaned Data For Dashboard (RUNNED IN PSQL TOOL)
==================================================================================================================================== */

\copy website_analytics TO 'C:\Users\user\OneDrive\Desktop\datasets\cleaned_website_analytics.csv' WITH (FORMAT CSV, HEADER TRUE);


/* ------------------------------------------------------- "QUERIES END HERE" ------------------------------------------------------- */













