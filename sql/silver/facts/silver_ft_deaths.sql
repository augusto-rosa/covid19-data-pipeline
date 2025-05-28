/*

Author: Augusto Rosa

Source: Bronze layer (bronze.owid-covid-data.parquet)

Description: Create silver.dm_time

Language Used: SQL, T-SQL

*/
--
-- -- Generating the values to be inserted into silver.ft_deaths
DROP VIEW IF EXISTS silver.ft_deaths;
--
CREATE OR ALTER VIEW silver.ft_deaths AS
WITH built_ft_death AS (
SELECT 
	CAST(new_deaths AS INT) AS new_deaths
,	CASE 
        WHEN new_deaths_per_million = '' THEN 0.00
        ELSE CAST(new_deaths_per_million AS DECIMAL(10,2))
    END AS new_deaths_per_million
,	CASE 
        WHEN new_deaths_smoothed = '' THEN 0.00
        ELSE CAST(new_deaths_smoothed AS DECIMAL(10,2))
    END AS new_deaths_smoothed
,	CASE 
        WHEN new_deaths_smoothed_per_million = '' THEN 0.00
        ELSE CAST(new_deaths_smoothed_per_million AS DECIMAL(10,2))
    END AS new_deaths_smoothed_per_million
,	CASE 
        WHEN total_deaths_per_million = '' THEN 0.00
        ELSE CAST(total_deaths_per_million AS DECIMAL(10,2))
    END AS total_deaths_per_million
,	CAST(total_deaths AS INT) AS total_deaths
,	CAST(REPLACE([date], '-', '') AS INT) AS date_int
,	iso_code
,	ROW_NUMBER() OVER(PARTITION BY iso_code, [date] ORDER BY iso_code, [date] ASC) AS rn
FROM bronze.covid19data
WHERE 1=1
AND COALESCE (
	NULLIF(new_deaths, '')
,	NULLIF(new_deaths_per_million, '') 
,	NULLIF(new_deaths_smoothed, '') 
,	NULLIF(new_deaths_smoothed_per_million, '') 
,	NULLIF(total_deaths_per_million, '') 
, NULLIF(total_deaths, '')) IS NOT NULL
)
SELECT 
	bft.new_deaths
,	bft.new_deaths_per_million
,	bft.new_deaths_smoothed
,	bft.new_deaths_smoothed_per_million
,	bft.total_deaths_per_million
,	bft.total_deaths
,	dc.country_id
,	dt.date_integer_id
FROM built_ft_death bft
INNER JOIN silver.dm_country dc ON (dc.country_code = bft.iso_code)
INNER JOIN silver.dm_time dt ON (dt.date_integer_id = bft.date_int)
WHERE 1=1
AND bft.rn = 1;
--
/*
Note: For some reason, the database contained duplicate records. One row held the original data, and another row, referencing the same country and date, had all blank values in every column.

The query above addresses this in the first SELECT statement by handling blank values in each field. This is necessary because SQL Server interprets empty strings as Varchar, which cannot be directly converted to Decimal. Therefore, if a column contains "Empty" or "Blank", it's converted to 0.0. Leaving the value as NULL was also avoided to prevent potential issues with dashboard metric creation.

Then, in the WHERE clause, the query filters out these duplicate rows where all column values are empty or blank. This cleans the data, ensuring only one correct record is returned and maintaining data integrity.

For example, try running a SELECT query on the bronze.covid19data table and look for iso_code = 'TLS' OR iso_code = 'FRO'.
*/

WITH CTE AS (
SELECT
	iso_code
,	[DATE]
,	ROW_NUMBER() OVER(PARTITION BY ISO_CODE, [DATE] ORDER BY [DATE] ASC) AS rn
FROM bronze.covid19data
)
--SELECT DISTINCT
--iso_code
--FROM CTE
--WHERE 1=1
--AND rn > 1
SELECT
COUNT(*)
FROM CTE
WHERE 1=1
--AND rn > 1
--AND iso_code = 'TLS' -- TLS -> Total of 2,688 records in the database, but 1,014 are Duplicate Records
AND iso_code = 'FRO' -- FRO -> Total of 2,068 records in the database, but 394 are Duplicate Records