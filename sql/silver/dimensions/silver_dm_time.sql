/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create silver.DM_TIME

Language Used: SQL, T-SQL

*/
--
-- Generating the values to be inserted into silver.dm_time
DROP VIEW IF EXISTS silver.dm_time;
--
CREATE OR ALTER VIEW silver.dm_time AS
WITH distinct_date AS (
SELECT 
	[date] AS unique_date
,	ROW_NUMBER() OVER(PARTITION BY [date] ORDER BY [date] ASC) AS unique_date_rn
FROM bronze.covid19data
)
SELECT
-- Generates date_integer_id in the format YYYYMMDD as INT to be used as a foreign key (FK) in fact tables,
-- providing better performance in joins and reduced storage compared to DATE/VARCHAR types
	CAST(REPLACE(unique_date, '-', '') AS INT) AS date_integer_id
,	CAST(unique_date AS DATE) AS [date]
,	DATEPART(YEAR, unique_date) AS [year]
,	DATEPART(QUARTER, unique_date) AS [quarter]
,	DATEPART(MONTH, unique_date) AS [month]
,	DATEPART(WEEK, unique_date) AS [week]
,	DATEPART(DAY, unique_date) AS [day]
,	DATEPART(WEEKDAY, unique_date) AS [weekday]
FROM distinct_date
WHERE 1=1
AND unique_date_rn = 1;


